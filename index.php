<?php
// If you installed via composer, just use this code to requrie autoloader on the top of your projects.
//require 'vendor/autoload.php';
require_once 'medoo.php';

require 'kint/Kint.class.php';

?>
<!DOCTYPE html>
<html>
<head>
	<meta name="viewport" content="width=device-width" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>Remotables DB Import</title>
	<link rel="stylesheet" href="" type="text/css" />
</head>
<body>


<?php






/*
########## DUMP VARIABLE ###########################
Kint::dump($GLOBALS, $_SERVER); // pass any number of parameters

// or simply use d() as a shorthand:
d($_SERVER);


########## DEBUG BACKTRACE #########################
Kint::trace();
// or via shorthand:
d(1);


############# BASIC OUTPUT #########################
# this will show a basic javascript-free display
s($GLOBALS);


######### WHITESPACE FORMATTED OUTPUT ##############
# this will be garbled if viewed in browser as it is whitespace-formatted only
~d($GLOBALS); // just prepend with the tilde


########## MISCELLANEOUS ###########################
# this will disable kint completely
Kint::enabled(false);

ddd('Get off my lawn!'); // no effect

Kint::enabled(true);
ddd( 'this line will stop the execution flow because Kint was just re-enabled above!' );


*/






/*

// Initialize
$database = new medoo([
    'database_type' => 'mysql',
    'database_name' => 'remotables_test',
    'server' => 'localhost',
    'username' => 'root',
    'password' => 'kvr',
    'charset' => 'utf8'
]);
*/
// Enjoy
/*
$database->insert('account', [
    'user_name' => 'foo',
    'email' => 'foo@bar.com',
    'age' => 25,
    'lang' => ['en', 'fr', 'jp', 'cn']
]);
```
*/

$database = new medoo([
    'database_type' => 'mysql',
    'database_name' => 'remotables_test',
    'server' => 'localhost',
    'username' => 'root',
    'password' => 'kvr',
    'charset' => 'utf8'
]);
// Enjoy
 
// Inserting data 1
/*
$scopekey = 0;
$remotablekey =0;
//foreach (glob("remotables.txt") as $file) {
    $file_handle = fopen("remotables.txt", "r");
    while (!feof($file_handle)) {
        $line = rtrim(fgets($file_handle));
        $line_array = str_getcsv($line, "\t");
        if (count($line_array) <= 1) {
            //d("blank line");
        } elseif (count($line_array) == 2) {
           //scope_domain, scope
           ++$scopekey;
           //d($scopekey, $line_array[0], $line_array[1]);
           $database->insert('Scope', [
    'Scope_Domain' => $line_array[0],
    'Scope' => $line_array[1],
    'Scope_Key' => $scopekey
]);
        
        } elseif (count($line_array) == 5) {
           ++$remotablekey;
        // item, min, max, input, output
        $database->insert('Remotables', [
    'Remotable_Item' => $line_array[0],
    'Min' => $line_array[1],
    'Max' => $line_array[2],
    'Input' => $line_array[3],
    'Output' => $line_array[4],
    'Scope_Key' => $scopekey,
    'Remotable_Key' => $remotablekey
]);
     //   d($scopekey, $remotablekey);
        }
        
//        echo $line;
    }
    fclose($file_handle);
//}
*/



$mapkey = 0;
$csitemkey =0;
$groupkey=0;
$variationkey=0;
$rmivkey=0;


//foreach (glob("Remotables/*.remotemap") as $file) {
$mapversion ="";
$csmodel="";
$csmanufacturer="";

//    $file_handle = fopen($file, "r");
    $file_handle = fopen("Remotables/Audio Kontrol 1.remotemap", "r");
    while (!feof($file_handle)) {
        $line = rtrim(fgets($file_handle));
        $line_array = str_getcsv($line, "\t");
        if (substr( $line_array[0], 0, 2 ) === "//" ) {
           // ignore line
	
        } elseif ((count($line_array) == 1) && ($line_array[0] == "Propellerhead Remote Mapping File")) {
        	// new map
        	++$mapkey;
        } elseif ((count($line_array) == 2) && ($line_array[0] == "File Format Version")) {
           // ignore line
        } elseif ((count($line_array) == 2) && ($line_array[0] == "Control Surface Manufacturer")) {
            $csmanufacturer=$line_array[1];
        } elseif ((count($line_array) == 2) && ($line_array[0] == "Control Surface Model")) {
            $csmodel=$line_array[1];
        } elseif ((count($line_array) == 2) && ($line_array[0] == "Map Version")) {
            $mapversion=$line_array[1];
            
                d($csmanufacturer,$csmodel,$mapversion,$mapkey);

            
/*            
           $database->insert('Remote_Map', [
    'CS_Manufacturer' => $csmanufacturer,
    'CS_Model' => $csmodel,
    'Map_Version' => $mapversion,
    'Map_Key' => $mapkey
]);
*/
        } elseif ((count($line_array) == 3) && ($line_array[0] == "Scope")) {
// Get the current scope ID
           $scopekey = $database->select('Scope',
    'Scope_key',
    [
    'Scope' => trim($line_array[2]) 
    ]);
          
        //d($line,$scopekey, $line_array[1], $line_array[2]);
        
        
       } elseif ($line_array[0] == "Define Group") {
             ++$groupkey;
/*   
           $database->insert('Remote_Map_Groups', [
            'Group_Name' => trim($line_array[1]),
            'Group_Key' => $groupkey,
            'Scope_Key' => $scopekey[0],
            'Map_Key' => $mapkey
           ]);

        for ($i = 2; $i < count($line_array); $i++) {
           ++$variationkey
           $database->insert('Remote_Map_Variations', [
             'Variation_Name' => trim($line_array[i]),
             'Variation_Key' => $variationkey,
             'Group_Key' => $groupkey,
            'Scope_Key' => $scopekey[0],
            'Map_Key' => $mapkey
           ]);
        }
*/            
             
             
        } elseif (($line_array[0] == "Map")) {
// map an item
//	Control Surface Item	Key	Remotable Item	Scale	Mode	Groups
         
				++$csitemkey;
// first check if this is a variation switch
// = is never first char!
		if (strpos($line_array[3],'=') > -1) {
			$vari = explode("=",trim($line_array[3]));
			$switchgroupname = trim($vari[0]);
			$switchvariationname = trim($vari[1]);
          $switchgroupkey = $database->select('Remote_Map_Groups',
    'Group_Key',
    [
    'Group_Name' => $switchgroupname
    ]);
			$switchvariationkey = $database->select('Remote_Map_Variations',
    'Variation_Key',
    [
    'Variation_Name' => $switchvariationname
    ]);
		} elseif (strpos($line_array[3],'"') > -1) {
			
			$constantvalue = trim($line_array[3]);
		} else {
			$remotableitem = trim($line_array[3]);
		}
           $remotableitemkey = $database->select('Remotables','Remotable_key',[
           'AND' => [
    'Scope_Key' => $scopekey[0],
    'Remotable_Item' => $remotableitem
       ]
    ]);

        //d($line,$remotableitemkey[0], $line_array[1], $line_array[2], $line_array[3], $line_array[4],$scopekey[0]);

/*   

           $database->insert('Remote_Map_Items', [
    'CS_Item' => trim($line_array[1]),
    'CS_Item_Key' => $csitemkey,
    'CS_KeyNote' => trim($line_array[2]),
    'CS_Scale' => trim($line_array[4]), 
    'CS_Mode => trim($line_array[5]), 
    'Remotable_Item' => $remotableitem,
    'Remotable_Item_Key' => $remotableitemkey[0],
    'Switch_Group_Key' => $switchgroupkey[0],
    'Switch_Group_Name' => $switchgroupname,
    'Switch_Variation_Name' => $switchvariationname,
    'Switch_Variation_Key' => $switchvariationkey[0],
    'Constant_Value' => $constantvalue,
    'Scope_Key' => $scopekey[0],
    'Map_Key' => $mapkey
]);
*/



/*   
        for ($i = 6; $i < count($line_array); $i++) {
           ++$rmivkey
           $varkey=$database->select('Remote_Map_Variations','Variation_Key',[
           'AND' => [
           'Variation_Name' => trim($line_array[i]),
           'Scope_Key' => $scopekey[0],
           'Map_Key' => $mapkey
           ]
               ]);
       }

           $database->insert('Remote_Map_Item_Variations', [
    'CS_Item_Key' => $csitemkey,
    'RMIV_Key' => $rmivkey,
    'Variation_Key' => $varkey[0] 
     ]);
 }
*/



       }
    } //while
    fclose($file_handle);
//}
d($database->error());
?>


</body>
</html>


