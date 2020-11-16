/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE IF NOT EXISTS `cloner` (
  `cloner_id` varchar(25) NOT NULL,
  `clo_form_source` varchar(25) DEFAULT NULL,
  `clo_form_dest` varchar(25) DEFAULT NULL,
  `clo_tabs` varchar(1000) DEFAULT NULL,
  `clo_dump` tinyint(1) DEFAULT NULL,
  `clo_objects` tinyint(1) DEFAULT NULL,
  `clo_subforms_include` tinyint(1) DEFAULT NULL,
  `clo_subforms` varchar(1000) DEFAULT NULL,
  `clo_iframe_forms_include` tinyint(1) DEFAULT NULL,
  `clo_iframe_forms` text DEFAULT NULL,
  `clo_new_pks` tinyint(1) DEFAULT NULL,
  `clo_open_form` tinyint(1) DEFAULT NULL,
  `clo_notes` text DEFAULT NULL,
  PRIMARY KEY (`cloner_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cloner` DISABLE KEYS */;
/*!40000 ALTER TABLE `cloner` ENABLE KEYS */;

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE IF NOT EXISTS `zzzzsys_browse` (
  `zzzzsys_browse_id` varchar(25) NOT NULL DEFAULT '',
  `sbr_zzzzsys_form_id` varchar(25) DEFAULT NULL,
  `sbr_title` varchar(100) DEFAULT NULL,
  `sbr_display` varchar(512) DEFAULT NULL,
  `sbr_align` char(1) DEFAULT NULL,
  `sbr_format` varchar(300) DEFAULT NULL,
  `sbr_order` int(11) DEFAULT NULL,
  `sbr_width` int(11) DEFAULT NULL,
  PRIMARY KEY (`zzzzsys_browse_id`),
  KEY `sbr_zzzsys_form_id` (`sbr_zzzzsys_form_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `zzzzsys_browse` DISABLE KEYS */;
INSERT INTO `zzzzsys_browse` VALUES ('5f9aaac971fc30c','5f9aaac95b3fa9a','Include Objects','REPLACE(REPLACE(clo_objects,1,\'✔\'),0,\'\')','l','',40,80);
INSERT INTO `zzzzsys_browse` VALUES ('5f9aaac971ec977','5f9aaac95b3fa9a','Dump','REPLACE(REPLACE(clo_dump,1,\'✔\'),0,\'\')','l','',30,80);
INSERT INTO `zzzzsys_browse` VALUES ('5f9c04dbab4da92','5f9aaac95b3fa9a','Notes','clo_notes','l',NULL,60,250);
INSERT INTO `zzzzsys_browse` VALUES ('5f9aaac971c84e2','5f9aaac95b3fa9a','Form Destination','clo_form_dest','l','',20,100);
INSERT INTO `zzzzsys_browse` VALUES ('5f9aaac9719b88c','5f9aaac95b3fa9a','Form Source','clo_form_source','l','',10,100);
INSERT INTO `zzzzsys_browse` VALUES ('5f9aaac9720ab52','5f9aaac95b3fa9a','Show Form','REPLACE(REPLACE(clo_open_form,1,\'✔\'),0,\'\')','l','',50,80);
/*!40000 ALTER TABLE `zzzzsys_browse` ENABLE KEYS */;

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE IF NOT EXISTS `zzzzsys_event` (
  `zzzzsys_event_id` varchar(25) NOT NULL,
  `sev_zzzzsys_object_id` varchar(25) DEFAULT NULL,
  `sev_event` varchar(100) DEFAULT NULL,
  `sev_javascript` varchar(3000) DEFAULT NULL,
  PRIMARY KEY (`zzzzsys_event_id`),
  KEY `sev_zzzsys_object_id` (`sev_zzzzsys_object_id`),
  KEY `sev_event` (`sev_event`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `zzzzsys_event` DISABLE KEYS */;
/*!40000 ALTER TABLE `zzzzsys_event` ENABLE KEYS */;

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE IF NOT EXISTS `zzzzsys_form` (
  `zzzzsys_form_id` varchar(25) NOT NULL,
  `sfo_type` varchar(300) DEFAULT NULL,
  `sfo_code` varchar(300) DEFAULT NULL,
  `sfo_description` varchar(300) DEFAULT NULL,
  `sfo_table` varchar(300) DEFAULT NULL,
  `sfo_primary_key` varchar(300) DEFAULT NULL,
  `sfo_browse_redirect_form_id` varchar(300) DEFAULT NULL,
  `sfo_browse_row_height` int(11) DEFAULT NULL,
  `sfo_browse_rows_per_page` int(11) DEFAULT NULL,
  `sfo_browse_sql` text DEFAULT NULL,
  `sfo_javascript` longtext DEFAULT NULL,
  PRIMARY KEY (`zzzzsys_form_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `zzzzsys_form` DISABLE KEYS */;
INSERT INTO `zzzzsys_form` VALUES ('5f9aaac95b3fa9a','browseedit','cloner','Cloner','cloner','cloner_id',NULL,NULL,NULL,'SELECT * FROM cloner','function labelOnTop(f, e) {\n\n    for (var i = 0; i < f.length; i++) {\n        if ($.inArray(f[i], e) == -1) {\n\n            $(\'#\' + \'label_\' + f[i]).css({\n                \'top\': parseInt($(\'#\' + f[i]).css(\"top\")) - 18,\n                \'left\': parseInt($(\'#\' + f[i]).css(\"left\")),\n                \'text-align\': \'left\'\n            })\n        }\n    }\n}\n\nfunction refreshSelectObject(id) {\n    nuSetProperty(\'cloner_refresh_selectId\', id);\n    nuRunPHPHidden(\"cloner\", 1);\n}\n\nfunction addRunButton() {\n    nuAddActionButton(\'nuRunPHPHidden\', \'Run\', \'runCloner()\');\n    $(\'#nunuRunPHPHiddenButton\').css(\'background-color\', \'#117A65\');\n}\n\nfunction selectRemoveEmpty(id) {\n\n    id = id === undefined ? \'select\' : \'#\' + id;\n\n    $(id + \' option\').filter(function() {\n        return ($(this).val().trim() === \"\" && $(this).text().trim() === \"\");\n    }).remove();\n\n}\n\nfunction selectToIndexArray(id) {\n\n    var a = [];\n    $(\'#\' + id + \' option:selected\').each(function(index) {\n        if ($(this).text() !== \'\') {\n            a.push($(this).index() + 1);\n        }\n    });\n    return a;\n    \n}\n\nfunction selectToValueArray(id) {\n\n    var a = [];\n    $(\'#\' + id + \' option:selected\').each(function(index) {\n        if ($(this).text() !== \'\') {\n            a.push($(this).text())\n        }\n    });\n\n    return a;\n\n}\n\n\nfunction runCloner() {\n\n    if ($(\'#clo_form_source\').val() === \'\') {\n        nuMessage([\'Source Form cannot be left blank.\']);\n        return;\n    }\n\n    if ($(\'#clo_tabs :selected\').length === 0) {\n        nuMessage([\'Select at least 1 Tab.\']);\n        return;\n    }\n\n    nuSetProperty(\'cloner_refresh_selectId\', \'\');\n\n    var tabs = selectToIndexArray(\'clo_tabs\');\n    nuSetProperty(\'cloner_tabs\', tabs.length === 0 ? \'\' : JSON.stringify(tabs));\n\n    var subforms = $(\'#clo_subforms_include\').is(\':checked\');\n    var clo_subforms = selectToValueArray(\'clo_subforms\');\n    nuSetProperty(\'cloner_subforms\', subforms === false || clo_subforms.length === 0 ? \'0\' : JSON.stringify(clo_subforms));\n\n    var formsRunIFrame = selectToValueArray(\'clo_iframe_forms\');\n    nuSetProperty(\'cloner_iframe_forms\', formsRunIFrame === false || formsRunIFrame.length === 0 ? \'0\' : JSON.stringify(formsRunIFrame));\n\n    var dump = $(\'#clo_dump\').is(\':checked\');\n    nuSetProperty(\'cloner_dump\', dump ? \'1\' : \'0\');\n\n    var noObjects = $(\'#clo_objects\').is(\':checked\');\n    nuSetProperty(\'cloner_objects\', noObjects ? \'0\' : \'1\');\n\n    var newPks = $(\'#clo_new_pks\').is(\':checked\');\n    nuSetProperty(\'cloner_new_pks\', newPks ? \'1\' : \'0\');\n\n    nuSetProperty(\'cloner_form_source\', $(\'#clo_form_source\').val());\n    nuSetProperty(\'cloner_form_dest\', $(\'#clo_form_dest\').val());\n    nuSetProperty(\'cloner_notes\', \'#clo_notes#\');\n\n    dump ? nuRunPHP(\'cloner\', \'\', 1) : nuRunPHPHidden(\'cloner\', 0);\n\n}\n\nfunction setTitle() {\n\n    if (!nuIsNewRecord()) {\n        nuSetTitle($(\'#clo_form1description\').val());\n    }\n\n}\n\nfunction setDefaultValues() {\n\n    if (nuIsNewRecord()) {\n        $(\'#clo_open_form\').prop(\'checked\', true).change();\n        $(\'#clo_new_pks\').prop(\'checked\', true).change();\n        $(\'#clo_tabs  option\').prop(\'selected\', true).change();\n    }\n\n}\n\nfunction setParentFormId() {\n\n    if (parent.$(\'#nuModal\').length > 0 && $(\'#clo_form_source\').val() === \'\') {\n        nuGetLookupId(window.parent.nuCurrentProperties().form_id, \'clo_form_source\');\n    }\n\n}\n\nfunction cloSubformsChecked() {\n\n    var c = $(\'#clo_subforms_include\').is(\':checked\');\n    c ? nuEnable(\'clo_subforms\') : nuDisable(\'clo_subforms\');\n    selectAllOptions(\'clo_subforms\', c);\n\n}\n\nfunction cloIframeFormsChecked() {\n\n    var c = $(\'#clo_iframe_forms_include\').is(\':checked\');\n    c ? nuEnable(\'clo_iframe_forms\') : nuDisable(\'clo_iframe_forms\');\n    selectAllOptions(\'clo_iframe_forms\', c);\n\n}\n\nfunction selectObjectPopuplated(formId, selectId, count) {\n\n    if (selectId == \'clo_tabs\') {\n        selectAllOptions(\'clo_tabs\', true);\n    }\n\n    var chk;\n    if (selectId == \'clo_iframe_forms\') {\n        chk = $(\'#clo_iframe_forms_include\');\n        var c = chk.is(\':checked\');\n        if (c) {\n            selectAllOptions(\'clo_iframe_forms\', true);\n        }\n        count === 0 ? nuDisable(\'clo_iframe_forms_include\') : nuEnable(\'clo_iframe_forms_include\');\n        if (count === 0) chk.prop(\'checked\', false).change();\n    }\n\n\n    if (selectId == \'clo_subforms\') {\n\n        chk = $(\'#clo_subforms_include\');\n        var s = chk.is(\':checked\');\n        if (s) {\n            selectAllOptions(\'clo_subforms\', true);\n        }\n        count === 0 ? nuDisable(\'clo_subforms_include\') : nuEnable(\'clo_subforms_include\');\n        if (count === 0) chk.prop(\'checked\', false).change();\n    }\n\n\n\n}\n\nfunction selectAllOptions(id, value) {\n    $(\"#\" + id).find(\'option:not(:empty)\').prop(\'selected\', value);\n    $(\"#\" + id).change();\n}\n\n\nif (nuFormType() == \'edit\') {\n\n    $(\'#clo_form_dest_note\').css(\"font-weight\", \"normal\");\n    $(\'#clo_tabs_note\').css(\"font-weight\", \"normal\");\n\n    // clo_dummy required to adjust correct popup width\n    nuHide(\'clo_dummy\');\n    selectRemoveEmpty();\n\n    labelOnTop([\'clo_iframe_forms\', \'clo_subforms\', \'clo_tabs\'], []);\n\n    cloSubformsChecked();\n    cloIframeFormsChecked();\n\n    setParentFormId();\n    setDefaultValues();\n\n    addRunButton();\n    setTitle();\n\n    nuHasNotBeenEdited();\n}');
/*!40000 ALTER TABLE `zzzzsys_form` ENABLE KEYS */;

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE IF NOT EXISTS `zzzzsys_object` (
  `zzzzsys_object_id` varchar(25) NOT NULL,
  `sob_all_zzzzsys_form_id` varchar(300) DEFAULT NULL,
  `sob_all_table` varchar(300) DEFAULT NULL,
  `sob_all_type` varchar(300) DEFAULT NULL,
  `sob_all_id` varchar(300) DEFAULT NULL,
  `sob_all_label` varchar(1000) DEFAULT NULL,
  `sob_all_zzzzsys_tab_id` varchar(300) DEFAULT NULL,
  `sob_all_order` int(11) DEFAULT NULL,
  `sob_all_top` int(11) DEFAULT NULL,
  `sob_all_left` int(11) DEFAULT NULL,
  `sob_all_width` int(11) DEFAULT NULL,
  `sob_all_height` int(11) DEFAULT NULL,
  `sob_all_cloneable` varchar(300) DEFAULT NULL,
  `sob_all_align` varchar(10) DEFAULT NULL,
  `sob_all_validate` varchar(1) DEFAULT NULL,
  `sob_all_access` varchar(1) DEFAULT NULL,
  `sob_calc_formula` varchar(3000) DEFAULT NULL,
  `sob_calc_format` varchar(300) DEFAULT NULL,
  `sob_run_zzzzsys_form_id` varchar(300) DEFAULT NULL,
  `sob_run_filter` varchar(300) DEFAULT NULL,
  `sob_run_method` varchar(1) DEFAULT NULL,
  `sob_run_id` varchar(300) DEFAULT NULL,
  `sob_display_sql` text DEFAULT NULL,
  `sob_select_multiple` varchar(300) DEFAULT NULL,
  `sob_select_sql` text DEFAULT NULL,
  `sob_lookup_code` varchar(300) DEFAULT NULL,
  `sob_lookup_description` varchar(300) DEFAULT NULL,
  `sob_lookup_description_width` varchar(300) DEFAULT NULL,
  `sob_lookup_autocomplete` varchar(300) DEFAULT NULL,
  `sob_lookup_zzzzsys_form_id` varchar(300) DEFAULT NULL,
  `sob_lookup_javascript` text DEFAULT NULL,
  `sob_lookup_php` varchar(25) DEFAULT NULL,
  `sob_lookup_table` varchar(500) DEFAULT NULL,
  `sob_subform_zzzzsys_form_id` varchar(300) DEFAULT NULL,
  `sob_subform_foreign_key` varchar(300) DEFAULT NULL,
  `sob_subform_add` varchar(300) DEFAULT NULL,
  `sob_subform_delete` varchar(300) DEFAULT NULL,
  `sob_subform_type` varchar(300) DEFAULT NULL,
  `sob_subform_table` varchar(300) DEFAULT NULL,
  `sob_input_count` bigint(20) DEFAULT NULL,
  `sob_input_format` varchar(300) DEFAULT NULL,
  `sob_input_type` varchar(300) DEFAULT NULL,
  `sob_input_javascript` text DEFAULT NULL,
  `sob_html_code` text DEFAULT NULL,
  `sob_html_chart_type` varchar(1000) DEFAULT NULL,
  `sob_html_javascript` varchar(1000) DEFAULT NULL,
  `sob_html_title` varchar(1000) DEFAULT NULL,
  `sob_html_vertical_label` varchar(1000) DEFAULT NULL,
  `sob_html_horizontal_label` varchar(1000) DEFAULT NULL,
  `sob_image_zzzzsys_file_id` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`zzzzsys_object_id`),
  KEY `sob_all_zzzzsys_form_id` (`sob_all_zzzzsys_form_id`),
  KEY `sob_all_zzzzsys_tab_id` (`sob_all_zzzzsys_tab_id`),
  KEY `sob_run_zzzzsys_form_id` (`sob_run_zzzzsys_form_id`),
  KEY `sob_lookup_zzzzsys_form_id` (`sob_lookup_zzzzsys_form_id`),
  KEY `sob_subform_zzzzsys_form_id` (`sob_subform_zzzzsys_form_id`),
  KEY `sob_image_zzzzsys_file_id` (`sob_image_zzzzsys_file_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `zzzzsys_object` DISABLE KEYS */;
INSERT INTO `zzzzsys_object` VALUES ('5f9ab63acc9fd0f','5f9aaac95b3fa9a','cloner','input','clo_notes','Notes','5f9aaac95bc52e7',150,495,80,543,22,'1','left','0','0','','','','','','','SELECT COUNT(*) FROM zzzzsys_debug','','','','','',NULL,'','',NULL,'','','','','','','',0,'','text','','','','','','','','');
INSERT INTO `zzzzsys_object` VALUES ('5f9ac08ec429699','5f9aaac95b3fa9a','cloner','word','clo_version','<small>V. 1.10</small>','5f9aaac95bc52e7',50,19,584,47,20,'1','left','0','0','','','','','','','SELECT COUNT(*) FROM zzzzsys_debug','0','','sfo_code','sfo_description','250',NULL,'nutablookup','',NULL,'zzzzsys_tab','','','','','','',0,'','nuScroll','[\'North\',\'South\',\'East\',\'West\']','','','','','','','');
INSERT INTO `zzzzsys_object` VALUES ('5f9ab977463753f','5f9aaac95b3fa9a','cloner','word','clo_form_dest_note','<small>Leave blank to create a new from</small>','5f9aaac95bc52e7',80,323,161,200,20,'1','left','0','0','','','','','','','SELECT COUNT(*) FROM zzzzsys_debug','','','','','',NULL,'','',NULL,'','','','','','','',0,'','nuScroll','[\'North\',\'South\',\'East\',\'West\']','','','','','','','');
INSERT INTO `zzzzsys_object` VALUES ('5f9aaac9644de7e','5f9aaac95b3fa9a','cloner','input','clo_objects','Without Objects','5f9aaac95bc52e7',130,441,302,18,18,'1','right','0','0','','','','','','','SELECT COUNT(*) FROM zzzzsys_debug','','','','','','','','','','','','','','','','',0,'N|$ 1,000.00','checkbox','','','','','','','','');
INSERT INTO `zzzzsys_object` VALUES ('5f9aaac964ab53d','5f9aaac95b3fa9a','cloner','input','clo_open_form','Show Form after cloning','5f9aaac95bc52e7',140,413,302,18,18,'1','right','0','0','','','','','','','SELECT COUNT(*) FROM zzzzsys_debug','','','','','','','','','','','','','','','','',0,'N|$ 1,000.00','checkbox','','','','','','','','');
INSERT INTO `zzzzsys_object` VALUES ('5f9ab0d78bb5520','5f9aaac95b3fa9a','cloner','select','clo_tabs','Tabs','5f9aaac95bc52e7',20,114,70,147,96,'1','left','0','0','','','','','','','SELECT COUNT(*) FROM zzzzsys_debug','1','SELECT `zzzzsys_tab_id`, `syt_title` FROM `zzzzsys_tab` \nLEFT JOIN zzzzsys_form on syt_zzzzsys_form_id = zzzzsys_form_id\nWHERE zzzzsys_form_id = \'#clo_form_source#\'\nORDER BY `syt_order`','sfo_code','sfo_description','250',NULL,'nutablookup','',NULL,'zzzzsys_tab','','','','','','',0,'','nuScroll','[\'North\',\'South\',\'East\',\'West\']','','','','','','','');
INSERT INTO `zzzzsys_object` VALUES ('5f9ab47bbbe2540','5f9aaac95b3fa9a','cloner','html','clo_box','  ','5f9aaac95bc52e7',160,8,30,18,18,'1','right','0','0','','','','','','','SELECT COUNT(*) FROM zzzzsys_debug','','','','','',NULL,'','',NULL,'','','','','','','',0,'','checkbox','','<style>\n    .content-box-header .content {\n    height:inherit;\n    padding: 10px;\n    font-size: 15px;\n    border-bottom-left-radius: 7px;\n    border-bottom-right-radius: 7px;\n    border:1px solid #dddddd;  /*#d80147; */\n    background-color: #fff;   /*  #F9F9F9; */\n   \n}\n\n.content-box-header .title {   \n    height:4px;\n    line-height:4px;\n    border-top-left-radius: 7px;\n    border-top-right-radius: 7px;\n   /* background:#f0f0f0; */\n    color: #333;\n    font-size:14px;\n    font-weight:bold;    \n    font-family: sans-serif, \"Segoe UI\", Helvetica, \"Helvetica Neue\", Arial, sans-serif;\n    display:block;\n    margin:-1px;\n    padding:9px;\n    /*border: 1px solid #dddddd; */\n    letter-spacing: 1px;\n}\n\n.content-box-header {\n   z-index:-1;\n   position: absolute;\n   height:90px;\n}\n\nselect[multiple]{\n    box-sizing: content-box;\n    padding: 0 0 0 8px;\n}\n\n\n</style>\n\n<div class=\"content-box-header\" style=\" left: 10px; top: 10px; height: 190px; width: 590px;\">\n    <div class=\"title\">Source Form</div>    \n    <div class=\"content\"></div>\n</div>\n\n<div class=\"content-box-header\" style=\" left: 10px; top: 250px; height: 60px; width: 590px;\">\n    <div class=\"title\">Destination Form</div>    \n    <div class=\"content\"></div>\n</div>\n\n<div class=\"content-box-header\" style=\" left: 10px; top: 365px; height: 70px; width: 590px;\">\n    <div class=\"title\">Options</div>\n    <div class=\"content\"></div>\n</div>\n','','','','','','');
INSERT INTO `zzzzsys_object` VALUES ('5f9aaac963ecc49','5f9aaac95b3fa9a','cloner','input','clo_dump','Dump SQL Statements','5f9aaac95bc52e7',90,413,494,18,18,'1','right','0','0','','','','','','','SELECT COUNT(*) FROM zzzzsys_debug','','','','','','','','','','','','','','','','',0,'N|$ 1,000.00','checkbox','','','','','','','','');
INSERT INTO `zzzzsys_object` VALUES ('5f9aaac963362ca','5f9aaac95b3fa9a','cloner','lookup','clo_form_dest','Form','5f9aaac95bc52e7',70,300,161,150,20,'1','left','0','0','','','','','','','','','','sfo_code','sfo_description','250','','nuform','','','zzzzsys_form','','','','','','',0,'N|$ 1,000.00','nuScroll','[\'North\',\'South\',\'East\',\'West\']','','','','','','','');
INSERT INTO `zzzzsys_object` VALUES ('5f9aaac962c91dd','5f9aaac95b3fa9a','cloner','lookup','clo_form_source','Form','5f9aaac95bc52e7',10,58,106,150,20,'1','left','1','0','','','','','','','','','','sfo_code','sfo_description','250','','nuform','refreshSelectObject(\'clo_tabs\');\nrefreshSelectObject(\'clo_subforms\');\nrefreshSelectObject(\'clo_iframe_forms\');\n','','zzzzsys_form','','','','','','',0,'N|$ 1,000.00','nuScroll','[\'North\',\'South\',\'East\',\'West\']','','','','','','','');
INSERT INTO `zzzzsys_object` VALUES ('5f9be5d9ed4f886','5f9aaac95b3fa9a','cloner','input','clo_dummy','..','5f9aaac95bc52e7',60,-3,631,10,20,'1','left','0','0','','','','','','','SELECT COUNT(*) FROM zzzzsys_debug','0','','sfo_code','sfo_description','250',NULL,'nutablookup','',NULL,'zzzzsys_tab','','','','','','',0,'','text','[\'North\',\'South\',\'East\',\'West\']','','','','','','','');
INSERT INTO `zzzzsys_object` VALUES ('5f9d2633027c93e','nuuserhome','gantt','run','run_cloner','Cloner','nufastforms',30,64,76,150,30,'0','center','0','0','','','5f9aaac95b3fa9a','','b','','','','','','','',NULL,'','',NULL,'','','','','','','',0,'','','','','','','','','','');
INSERT INTO `zzzzsys_object` VALUES ('5f9d4ce275c966a','5f9aaac95b3fa9a','cloner','input','clo_new_pks','Generate new PKs','5f9aaac95bc52e7',120,443,494,18,18,'1','right','0','0','','','','','','','SELECT COUNT(*) FROM zzzzsys_debug','','','','','',NULL,'','',NULL,'','','','','','','',0,'','checkbox','','','','','','','','');
INSERT INTO `zzzzsys_object` VALUES ('5fa0ff78688e2c5','5f9aaac95b3fa9a','cloner','select','clo_subforms','Subforms','5f9aaac95bc52e7',30,114,239,157,96,'1','left','0','0','','','','','','','SELECT COUNT(*) FROM zzzzsys_debug','1','SELECT \n    sob_subform_zzzzsys_form_id, sob_all_id\n    FROM zzzzsys_object \nWHERE sob_all_zzzzsys_form_id = \'#clo_form_source#\' AND sob_all_type = \'subform\'','sfo_code','sfo_description','250',NULL,'nutablookup','',NULL,'zzzzsys_tab','','','','','','',0,'','nuScroll','[\'North\',\'South\',\'East\',\'West\']','','','','','','','');
INSERT INTO `zzzzsys_object` VALUES ('5fa249be5df47ad','5f9aaac95b3fa9a','cloner','input','clo_subforms_include',' ','5f9aaac95bc52e7',100,94,302,14,14,'1','right','0','0','','','','','','','SELECT COUNT(*) FROM zzzzsys_debug','','','','','',NULL,'','',NULL,'','','','','','','',0,'','checkbox','','','','','','','','');
INSERT INTO `zzzzsys_object` VALUES ('5fa2751ed4195b7','5f9aaac95b3fa9a','cloner','select','clo_iframe_forms','IFrame forms','5f9aaac95bc52e7',40,116,418,157,96,'1','left','0','0','','','','','','','SELECT COUNT(*) FROM zzzzsys_debug','1','SELECT \n    `sob_run_zzzzsys_form_id`, sob_all_id\nFROM zzzzsys_object \nWHERE sob_all_zzzzsys_form_id =  \'#clo_form_source#\' AND sob_all_type = \'Run\'\nAND sob_run_method = \'i\' AND IFNULL(sob_run_zzzzsys_form_id,\'\') <> \'\'','sfo_code','sfo_description','250',NULL,'nutablookup','',NULL,'zzzzsys_tab','','','','','','',0,'','nuScroll','[\'North\',\'South\',\'East\',\'West\']','','','','','','','');
INSERT INTO `zzzzsys_object` VALUES ('5fa959f97244564','5f9aaac95b3fa9a','cloner','input','clo_iframe_forms_include',' ','5f9aaac95bc52e7',110,94,492,14,14,'1','right','0','0','','','','','','','SELECT COUNT(*) FROM zzzzsys_debug','','','','','',NULL,'','',NULL,'','','','','','','',0,'','checkbox','','','','','','','','');
/*!40000 ALTER TABLE `zzzzsys_object` ENABLE KEYS */;

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE IF NOT EXISTS `zzzzsys_php` (
  `zzzzsys_php_id` varchar(25) NOT NULL,
  `sph_code` varchar(300) DEFAULT NULL,
  `sph_description` varchar(300) DEFAULT NULL,
  `sph_group` varchar(100) DEFAULT NULL,
  `sph_php` longtext DEFAULT NULL,
  `sph_run` varchar(20) DEFAULT NULL,
  `sph_zzzzsys_form_id` varchar(25) DEFAULT NULL,
  `sph_system` varchar(1) DEFAULT NULL,
  `sph_hide` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`zzzzsys_php_id`),
  KEY `sph_zzzzsys_form_id` (`sph_zzzzsys_form_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `zzzzsys_php` DISABLE KEYS */;
INSERT INTO `zzzzsys_php` VALUES ('5f9aaac962c91dd_AB','5f9aaac962c91dd_AB','System PHP','nubuilder',NULL,NULL,NULL,'1',NULL);
/*!40000 ALTER TABLE `zzzzsys_php` ENABLE KEYS */;

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE IF NOT EXISTS `zzzzsys_select` (
  `zzzzsys_select_id` varchar(25) CHARACTER SET utf8 NOT NULL,
  `sse_description` varchar(300) CHARACTER SET utf8 DEFAULT NULL,
  `sse_json` mediumtext CHARACTER SET utf8 DEFAULT NULL,
  `sse_sql` mediumtext CHARACTER SET utf8 DEFAULT NULL,
  `sse_edit` varchar(1) CHARACTER SET utf8 DEFAULT NULL,
  `sse_system` varchar(1) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`zzzzsys_select_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `zzzzsys_select` DISABLE KEYS */;
/*!40000 ALTER TABLE `zzzzsys_select` ENABLE KEYS */;

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE IF NOT EXISTS `zzzzsys_select_clause` (
  `zzzzsys_select_clause_id` varchar(25) NOT NULL,
  `ssc_zzzzsys_select_id` varchar(25) DEFAULT NULL,
  `ssc_type` varchar(300) DEFAULT NULL,
  `ssc_field` varchar(500) DEFAULT NULL,
  `ssc_clause` varchar(500) DEFAULT NULL,
  `ssc_sort` varchar(10) DEFAULT NULL,
  `ssc_order` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`zzzzsys_select_clause_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `zzzzsys_select_clause` DISABLE KEYS */;
/*!40000 ALTER TABLE `zzzzsys_select_clause` ENABLE KEYS */;

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE IF NOT EXISTS `zzzzsys_tab` (
  `zzzzsys_tab_id` varchar(25) NOT NULL,
  `syt_zzzzsys_form_id` varchar(25) DEFAULT NULL,
  `syt_title` varchar(250) DEFAULT NULL,
  `syt_order` int(11) DEFAULT NULL,
  `syt_help` varchar(3000) DEFAULT NULL,
  PRIMARY KEY (`zzzzsys_tab_id`),
  KEY `syt_zzzzsys_form_id` (`syt_zzzzsys_form_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `zzzzsys_tab` DISABLE KEYS */;
INSERT INTO `zzzzsys_tab` VALUES ('5f9aaac95bc52e7','5f9aaac95b3fa9a','Form',10,NULL);
/*!40000 ALTER TABLE `zzzzsys_tab` ENABLE KEYS */;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

