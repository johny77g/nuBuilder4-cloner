// ## nuBuilder Cloner 1.07

function hashCookieSet($h) {
    return !(preg_match('/\#(.*)\#/', $h) || trim($h) == "");
}

function idWithoutEvent($id) {
    return substr($id, 0, -3);
}

function eventFromId($id) {
    return substr($id, -3);
}

function lookupValue($arr, $key) {
    return array_column($arr, $key) [0];
}

function addToArray(array & $arr, $key, $value) {
     array_push($arr, array($key => $value));
}

function getTabList() {
    
    $t = "#cloner_tabs#";
    return !hashCookieSet($t) || strlen($t) < 3 ? "" : implode(',', json_decode($t));
    
}

function getFormSource(&$f1) {
    
    $f1 = "#cloner_f1#";
    if (! hashCookieSet($f1)) {
        $f1 = "#form_id#";
        return true;
    }
    
    return formExists($f1);    
    
}

function dbQuote($s){
    
	global $nuDB;
	
	return $nuDB->quote($s);
	
}	
	
function getFormDestination(&$f2) {

    $f2 = "#cloner_f2#";
    if (! hashCookieSet($f2)) {
        $f2 = "";
        return true;
    }
    
    return formExists($f2);
    
}

function formExists($f) {
    
    $s = "SELECT * FROM zzzzsys_form WHERE zzzzsys_form_id  = ? LIMIT 1";
    $t = nuRunQuery($s, [$f]);
    return db_num_rows($t) == 1;
    
}

function getFormInfo($f) {
    
    $s = "SELECT * FROM zzzzsys_form WHERE zzzzsys_form_id  = ? LIMIT 1";
    $t = nuRunQuery($s, [$f]);
    $row = db_fetch_object($t);

    return array(
        "code" => $row->sfo_code,
        "description" => $row->sfo_description,
        "table" => $row->sfo_table,
        "type" => $row->sfo_type
    );    
    
}

function dumpFormInfo($f) { 
    
    $fi = getFormInfo($f);
    echo "-- nuBuilder cloner SQL Dump "."<br>";
    echo "-- Version 1.07 "."<br>";
    echo "-- Generation Time: ".date("F d, Y h:i:s A")."<br><br>";
    echo "-- Form Description: ". $fi["description"]."<br>";
    echo "-- Form Code: ". $fi["code"]."<br>";
    echo "-- Form Table: ". $fi["table"]."<br>";
    echo "-- Form Type: ". $fi["type"]."<br><vr>";
    
}

function createInsertStatement($form, $columns, $row) {

    $params = array_map(function ($val) {
        return "?";
    }
    , $row);

    return "INSERT INTO $form (" . implode(', ', $columns) . ") VALUES ( " . implode(" , ", $params) . " ) ";
    
}

function dumpStatement($table, $row, &$first) {

    $values = join(', ', array_map(function ($value) {
        return $value === null ? 'NULL' : dbQuote($value);
    }
    , $row));

    if (!isset($first)) {
        echo "<br>--<br>";
        echo "-- " . $table . "<br>";
        echo "--<br><br>";
        $first = false;
    }

    echo "INSERT INTO $table (" . implode(', ', array_keys($row)) . ") VALUES ( " . $values . " ); " . "<br><br>";

}

function insertRecord($table, $row, &$first) {

    if ("#cloner_dump#" == '1') {
        dumpStatement($table, $row, $first);
    }
    else {
        $i = createInsertStatement($table, array_keys($row) , $row);
        nuRunQuery($i, array_values($row) , true);
    }

}

function getFormType($f) {

    $s = "SELECT sfo_type FROM zzzzsys_form WHERE zzzzsys_form_id  = ? LIMIT 1";
    $t = nuRunQuery($s, [$f]);
    $r = db_fetch_row($t);

    return $r[0];

}

function cloneForm($f1) {

    $s = "SELECT * FROM zzzzsys_form WHERE zzzzsys_form_id  = ? LIMIT 1";
    $t = nuRunQuery($s, [$f1]);
    
    $row = db_fetch_array($t);
    $newid = nuID();
    $row['zzzzsys_form_id'] = $newid;
    $row['sfo_code'] .= "_clone";

    insertRecord('zzzzsys_form', $row, $first);

    return $newid;

}

function cloneFormPHP($f1, $f2) {

    $s = "
        SELECT
            zzzzsys_php.*
        FROM
            zzzzsys_php
        LEFT JOIN zzzzsys_form ON zzzzsys_form_id = LEFT(zzzzsys_php_id, LENGTH(zzzzsys_php_id) - 3)
        WHERE
            zzzzsys_form_id = ?
	";

    $t = nuRunQuery($s, [$f1]);

    while ($row = db_fetch_array($t)) {

        $event = eventFromId($row['zzzzsys_php_id']);
        $row['zzzzsys_php_id'] = $f2 . $event;
        $row['sph_code'] = $f2 . $event;

        insertRecord('zzzzsys_php', $row, $first);

    }

}

function cloneFormTabs($f1, $f2) {

    $tab_ids = [];
    $s = "SELECT * FROM zzzzsys_tab AS tab1 WHERE syt_zzzzsys_form_id  = ?";
    $s .= whereTabs();
    
    $t = nuRunQuery($s, [$f1]);

    while ($row = db_fetch_array($t)) {

        $newid = nuID();
        addToArray($tab_ids, $row['zzzzsys_tab_id'], $newid);
    
        $row['zzzzsys_tab_id'] = $newid;
        $row['syt_zzzzsys_form_id'] = $f2;

        insertRecord('zzzzsys_tab', $row, $first);

    }
    
     return $tab_ids;

}

function cloneFormBrowse($f1, $f2) {

    $s = "SELECT * FROM zzzzsys_browse WHERE sbr_zzzzsys_form_id  = ?";
    $t = nuRunQuery($s, [$f1]);

    while ($row = db_fetch_array($t)) {

        $row['zzzzsys_browse_id'] = nuID();
        $row['sbr_zzzzsys_form_id'] = $f2;

        insertRecord('zzzzsys_browse', $row, $first);

    }

}

function whereTabs() {
    $tabs = getTabList();
    return $tabs != '' ? " AND tab1.syt_order DIV 10 IN ($tabs) " : "";
}

function getTabIds($f1, $f2) {

    $s = "    
        SELECT
            tab1.zzzzsys_tab_id AS tab1,
            tab2.zzzzsys_tab_id AS tab2
        FROM
            zzzzsys_tab AS tab1
        LEFT JOIN zzzzsys_tab AS tab2
        ON
            tab1.syt_order = tab2.syt_order
        WHERE
            tab1.syt_zzzzsys_form_id = ? AND tab2.syt_zzzzsys_form_id = ? 
    ";
    
    $s .= whereTabs();
    $t = nuRunQuery($s, [$f1, $f2]);

    $tab_ids = [];
    while ($r = db_fetch_object($t)) {
        addToArray($tab_ids, $r->tab1, $r->tab2);
    }

    return $tab_ids;

}

function cloneFormObjects($f1, $f2, array & $objectIds, $tab_ids) {

    $s = "SELECT * FROM zzzzsys_object WHERE sob_all_zzzzsys_form_id = ?";
    $t = nuRunQuery($s, [$f1]);

    while ($row = db_fetch_array($t)) {

        $row['sob_all_zzzzsys_form_id'] = $f2;
        $newid = nuID();
        addToArray($objectIds,  $row['zzzzsys_object_id'], $newid);
        $row['zzzzsys_object_id'] = $newid;
        $tab_id = lookupValue($tab_ids, $row['sob_all_zzzzsys_tab_id']);
        $row['sob_all_zzzzsys_tab_id'] = $tab_id;

        if ($tab_id != "")  insertRecord('zzzzsys_object', $row, $first);

    }

}

function cloneObjectsPHP($f1, $objectIds) {

    $s = "
        SELECT
           zzzzsys_php.* 
        FROM
           zzzzsys_php 
           LEFT JOIN
              zzzzsys_object 
              ON zzzzsys_object_id = LEFT(zzzzsys_php_id, LENGTH(zzzzsys_php_id) - 3) 
        WHERE
           sob_all_zzzzsys_form_id = ?
	";

    $t = nuRunQuery($s, [$f1]);

    while ($row = db_fetch_array($t)) {

        $event = eventFromId($row['zzzzsys_php_id']);
        $row['zzzzsys_php_id'] = lookupValue($objectIds, idWithoutEvent($row['zzzzsys_php_id'])) . $event;
        $row['sph_code'] = lookupValue($objectIds, idWithoutEvent($row['sph_code'])) . $event;

        insertRecord('zzzzsys_php', $row, $first);

    }

}


function cloneFormSelect($f1, $f2, array & $formSelectIds) {

    $s = "
        SELECT
           zzzzsys_select.* 
        FROM
           zzzzsys_select 
        WHERE LEFT(zzzzsys_select_id, LENGTH(zzzzsys_select_id) - 3)  = ?
	";

    $t = nuRunQuery($s, [$f1]);

    while ($row = db_fetch_array($t)) {

        $event = eventFromId($row['zzzzsys_select_id']);
        $newid = $f2. $event;
        addToArray($formSelectIds,  $row['zzzzsys_select_id'], $newid);
        $row['zzzzsys_select_id'] = $newid;

        insertRecord('zzzzsys_select', $row, $first);

    }

}


function cloneFormSelectClause($f1, $formSelectIds) {

    $s = "
        SELECT
           zzzzsys_select_clause.* 
        FROM
           zzzzsys_select_clause 
           LEFT JOIN
              zzzzsys_select 
              ON zzzzsys_select_id = ssc_zzzzsys_select_id 
           LEFT JOIN zzzzsys_form ON LEFT(zzzzsys_select_id, LENGTH(zzzzsys_select_id) - 3) = zzzzsys_form_id
           WHERE zzzzsys_form_id  = ? 
	";

    $t = nuRunQuery($s, [$f1]);

    while ($row = db_fetch_array($t)) {

        $row['ssc_zzzzsys_select_id'] = lookupValue($formSelectIds, $row['ssc_zzzzsys_select_id']);
        $row['zzzzsys_select_clause_id'] = nuID();

        if ($row['ssc_zzzzsys_select_id'] != "")  insertRecord('zzzzsys_select_clause', $row, $first);

    }

}



function cloneObjectsSelect($f1, $objectIds, array & $selectIds) {

    $s = "
        SELECT
           zzzzsys_select.* 
        FROM
           zzzzsys_select 
           LEFT JOIN
              zzzzsys_object 
              ON zzzzsys_object_id = LEFT(zzzzsys_select_id, LENGTH(zzzzsys_select_id) - 3) 
        WHERE
           sob_all_zzzzsys_form_id = ?
	";

    $t = nuRunQuery($s, [$f1]);

    while ($row = db_fetch_array($t)) {

        $event = eventFromId($row['zzzzsys_select_id']);
        $newid = lookupValue($objectIds, idWithoutEvent($row['zzzzsys_select_id'])) . $event;
        addToArray($selectIds,  $row['zzzzsys_select_id'], $newid);
        $row['zzzzsys_select_id'] = $newid;

        insertRecord('zzzzsys_select', $row, $first);

    }

}

function cloneObjectsSelectClause($f1, $selectIds) {

    $s = "
        SELECT
           zzzzsys_select_clause.* 
        FROM
           zzzzsys_select_clause 
           LEFT JOIN
              zzzzsys_select 
              ON zzzzsys_select_id = ssc_zzzzsys_select_id 
           LEFT JOIN
              zzzzsys_object 
              ON zzzzsys_object_id = LEFT(zzzzsys_select_id, LENGTH(zzzzsys_select_id) - 3) 
        WHERE
           sob_all_zzzzsys_form_id = ?
	";

    $t = nuRunQuery($s, [$f1]);

    while ($row = db_fetch_array($t)) {

        $row['ssc_zzzzsys_select_id'] = lookupValue($selectIds, $row['ssc_zzzzsys_select_id']);
        $row['zzzzsys_select_clause_id'] = nuID();

        if ($row['ssc_zzzzsys_select_id'] != "")  insertRecord('zzzzsys_select_clause', $row, $first);

    }

}

function cloneObjectsEvents($f1, $objectIds) {

    $s = "SELECT * FROM zzzzsys_event WHERE sev_zzzzsys_object_id IN (SELECT zzzzsys_object_id FROM zzzzsys_object WHERE sob_all_zzzzsys_form_id = ?)";
    $t = nuRunQuery($s, [$f1]);

    while ($row = db_fetch_array($t)) {

        $row['zzzzsys_event_id'] = nuID();
        $row['sev_zzzzsys_object_id'] = lookupValue($objectIds, $row['sev_zzzzsys_object_id']);

        insertRecord('zzzzsys_event', $row, $first);

    }

}

function getOpenForm($f2) {
    
    $ft = getFormType($f2);
    $r = $ft == 'browseedit' ? "" : "-1";
    return "nuForm('$f2', '$r', '', '', '2');";
    
}

function startCloner() {
    
    $dump = "#cloner_dump#";
    $withoutObjects = "#cloner_without_objects#";
    $openNewForm = "#cloner_open_new_form#";
    
    if (getFormSource($f1) == false) {
        nuJavascriptCallback("nuMessage(['The form $f1 (cloner_f1) does not exist!'])");
        return;
    }
    
    if (getFormDestination($f2) == false) {
        nuJavascriptCallback("nuMessage(['The form $f2 (cloner_f2) does not exist!'])");
        return;
    }

    if ($dump == '1') {
         dumpFormInfo($f1);
    }
    
    // If no destination form passed, clone the source form
    if ($f2 == "") {
    
        $formSelectIds = [];
        
        $f2 = cloneForm($f1);
        $tab_ids = cloneFormTabs($f1, $f2, $tab_ids);
    
        cloneFormSelect($f1, $f2, $formSelectIds);
        cloneFormSelectClause($f1, $formSelectIds);
        cloneFormBrowse($f1, $f2);
        cloneFormPHP($f1, $f2);
    
    }
    
    if ($withoutObjects == '1') return;
    
    $objectIds = [];
    $selectIds = [];
    
    cloneFormObjects($f1, $f2, $objectIds, $tab_ids);
    cloneObjectsPHP($f1, $objectIds);
    cloneObjectsSelect($f1, $objectIds, $selectIds);
    cloneObjectsSelectClause($f1, $selectIds);
    cloneObjectsEvents($f1, $objectIds);
    
    if ($openNewForm == '0' || $dump == '1') return;
    
    // Show the new form
    nuJavascriptCallback(getOpenForm($f2));

}

startCloner();
