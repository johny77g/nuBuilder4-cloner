// ## nuBuilder Cloner 1.02

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

function getFormDestination(&$f2) {

    $f2 = "#cloner_f2#";
    if (! hashCookieSet($f2)) {
        $f2 = "";
        return true;
    }
    
    return formExists($f2);
    
}

function formExists($f) {
    
    $s = "SELECT * FROM `zzzzsys_form` WHERE zzzzsys_form_id  = ? LIMIT 1";
    $t = nuRunQuery($s, [$f]);
    return db_num_rows($t) == 1;
    
}

function createInsertStatement($form, $columns, $row) {

    $params = array_map(function ($val) {
        return "?";
    }
    , $row);

    return "INSERT INTO `$form` (`" . implode('`, `', $columns) . "`) VALUES ( " . implode(" , ", $params) . " ) ";

}

function insertRecord($form, $row) {

    $i = createInsertStatement($form, array_keys($row) , $row);
    $t = nuRunQuery($i, array_values($row) , true);

    return $t;

}

function getFormType($f) {

    $s = "SELECT sfo_type FROM `zzzzsys_form` where zzzzsys_form_id  = ? LIMIT 1";
    $t = nuRunQuery($s, [$f]);
    $r = db_fetch_row($t);

    return $r[0];

}

function cloneForm($f1) {

    $s = "SELECT * FROM `zzzzsys_form` WHERE zzzzsys_form_id  = ? LIMIT 1";
    $t = nuRunQuery($s, [$f1]);
    
    $row = db_fetch_array($t);
    $newid = nuID();
    $row['zzzzsys_form_id'] = $newid;
    $row['sfo_code'] .= "_clone";

    insertRecord('zzzzsys_form', $row);

    return $newid;

}

function cloneFormPHP($f1, $f2) {

    $s = "
        SELECT zzzzsys_php.*
        FROM zzzzsys_php
        LEFT JOIN zzzzsys_form ON zzzzsys_form_id = LEFT(zzzzsys_php_id , LENGTH(zzzzsys_php_id) - 3)
        WHERE zzzzsys_form_id = ?
	";

    $t = nuRunQuery($s, [$f1]);

    while ($row = db_fetch_array($t)) {

        $event = eventFromId($row['zzzzsys_php_id']);
        $row['zzzzsys_php_id'] = $f2 . $event;
        $row['sph_code'] = $f2 . $event;

        insertRecord('zzzzsys_php', $row);

    }

}

function cloneTabs($f1, $f2) {

    $s = "SELECT * FROM zzzzsys_tab AS tab1 WHERE syt_zzzzsys_form_id  = ?";
    $s .= whereTabs();

    $t = nuRunQuery($s, [$f1]);

    while ($row = db_fetch_array($t)) {

        $row['zzzzsys_tab_id'] = nuID();
        $row['syt_zzzzsys_form_id'] = $f2;

        insertRecord('zzzzsys_tab', $row);

    }

}

function cloneBrowse($f1, $f2) {

    $s = "SELECT * FROM `zzzzsys_browse` WHERE sbr_zzzzsys_form_id  = ?";
    $t = nuRunQuery($s, [$f1]);

    while ($row = db_fetch_array($t)) {

        $row['zzzzsys_browse_id'] = nuID();
        $row['sbr_zzzzsys_form_id'] = $f2;

        insertRecord('zzzzsys_browse', $row);

    }

}

function whereTabs() {
    $tabs = getTabList();
    return $tabs != '' ? " AND tab1.`syt_order` DIV 10 IN ($tabs) " : "";
}

function getTabIds($f1, $f2) {

    $s = "    
        SELECT
            tab1.`zzzzsys_tab_id` AS tab1,
            tab2.`zzzzsys_tab_id` AS tab2
        FROM
            `zzzzsys_tab` AS tab1
        LEFT JOIN `zzzzsys_tab` AS tab2
        ON
            tab1.syt_order = tab2.`syt_order`
        WHERE
            tab1.`syt_zzzzsys_form_id` = ? AND tab2.`syt_zzzzsys_form_id` = ? 
    ";
    
    $s .= whereTabs();
    $t = nuRunQuery($s, [$f1, $f2]);

    $tab_ids = [];
    while ($r = db_fetch_object($t)) {
        addToArray($tab_ids, $r->tab1, $r->tab2);
    }

    return $tab_ids;

}

function cloneFormObjects($f1, $f2, array & $objectIds) {

    $tab_ids = getTabIds($f1, $f2);

    $s = "SELECT * FROM zzzzsys_object WHERE sob_all_zzzzsys_form_id = ?";
    $t = nuRunQuery($s, [$f1]);

    while ($row = db_fetch_array($t)) {

        $row['sob_all_zzzzsys_form_id'] = $f2;
        $newid = nuID();
        addToArray($objectIds,  $row['zzzzsys_object_id'], $newid);
        $row['zzzzsys_object_id'] = $newid;
        $tab_id = lookupValue($tab_ids, $row['sob_all_zzzzsys_tab_id']);

        $row['sob_all_zzzzsys_tab_id'] = $tab_id;

        if ($tab_id != "")  insertRecord('zzzzsys_object', $row);

    }

}

function cloneObjectsPHP($f1, $objectIds) {

    $s = "
        SELECT
           zzzzsys_php.* 
        FROM
           `zzzzsys_php` 
           LEFT JOIN
              zzzzsys_object 
              ON zzzzsys_object_id = LEFT(`zzzzsys_php_id`, LENGTH(`zzzzsys_php_id`) - 3) 
        WHERE
           sob_all_zzzzsys_form_id = ?
	";

    $t = nuRunQuery($s, [$f1]);

    while ($row = db_fetch_array($t)) {

        $event = eventFromId($row['zzzzsys_php_id']);
        $row['zzzzsys_php_id'] = lookupValue($objectIds, idWithoutEvent($row['zzzzsys_php_id'])) . $event;
        $row['sph_code'] = lookupValue($objectIds, idWithoutEvent($row['sph_code'])) . $event;

        insertRecord('zzzzsys_php', $row);

    }

}

function cloneObjectsSelect($f1, $objectIds, array & $selectIds) {

    $s = "
        SELECT
           zzzzsys_select.* 
        FROM
           `zzzzsys_select` 
           LEFT JOIN
              zzzzsys_object 
              ON zzzzsys_object_id = LEFT(`zzzzsys_select_id`, LENGTH(`zzzzsys_select_id`) - 3) 
        WHERE
           sob_all_zzzzsys_form_id = ?
	";

    $t = nuRunQuery($s, [$f1]);

    while ($row = db_fetch_array($t)) {

        $event = eventFromId($row['zzzzsys_select_id']);
        $newid = lookupValue($objectIds, idWithoutEvent($row['zzzzsys_select_id'])) . $event;
        addToArray($selectIds,  $row['zzzzsys_select_id'], $newid);
        $row['zzzzsys_select_id'] = $newid;

        insertRecord('zzzzsys_select', $row);

    }

}

function cloneObjectsSelectClause($f1, $selectIds) {

    $s = "
        SELECT
           zzzzsys_select_clause.* 
        FROM
           `zzzzsys_select_clause` 
           LEFT JOIN
              zzzzsys_select 
              ON zzzzsys_select_id = ssc_zzzzsys_select_id 
           LEFT JOIN
              zzzzsys_object 
              ON zzzzsys_object_id = LEFT(`zzzzsys_select_id`, LENGTH(`zzzzsys_select_id`) - 3) 
        WHERE
           sob_all_zzzzsys_form_id = ?
	";

    $t = nuRunQuery($s, [$f1]);

    while ($row = db_fetch_array($t)) {

        $row['ssc_zzzzsys_select_id'] = lookupValue($selectIds, $row['ssc_zzzzsys_select_id']);
        $row['zzzzsys_select_clause_id'] = nuID();

        if ($row['ssc_zzzzsys_select_id'] != "")  insertRecord('zzzzsys_select_clause', $row);

    }

}

function cloneEvents($f1, $objectIds) {

    $s = "SELECT * FROM zzzzsys_event WHERE sev_zzzzsys_object_id IN (SELECT zzzzsys_object_id FROM zzzzsys_object WHERE sob_all_zzzzsys_form_id = ?)";
    $t = nuRunQuery($s, [$f1]);

    while ($row = db_fetch_array($t)) {

        $row['zzzzsys_event_id'] = nuID();
        $row['sev_zzzzsys_object_id'] = lookupValue($objectIds, $row['sev_zzzzsys_object_id']);

        insertRecord('zzzzsys_event', $row);

    }

}

function getOpenForm($f2) {
    
    $ft = getFormType($f2);
    $r = $ft == 'browseedit' ? "" : "-1";
    return "nuForm('$f2', '$r', '', '', '2');";
    
}

if (getFormSource($f1) == false) {
    nuJavascriptCallback("nuMessage(['The form $f1 (cloner_f1) does not exist!'])");
    return;
}

if (getFormDestination($f2) == false) {
    nuJavascriptCallback("nuMessage(['The form $f2 (cloner_f2) does not exist!'])");
    return;
}

// If no destination form passed, clone the source form
if ($f2 == "") {
    $f2 = cloneForm($f1);
    cloneTabs($f1, $f2);
    cloneBrowse($f1, $f2);
    cloneFormPHP($f1, $f2);
}

if (hashCookieSet('#cloner_without_objects#')) return;

// Clone form objects, php events, js events, select, select clause
$objectIds = [];
$selectIds = [];

cloneFormObjects($f1, $f2, $objectIds);
cloneObjectsPHP($f1, $objectIds);
cloneObjectsSelect($f1, $objectIds, $selectIds);
cloneObjectsSelectClause($f1, $selectIds);
cloneEvents($f1, $objectIds);

// Show the new form
nuJavascriptCallback(getOpenForm($f2));
