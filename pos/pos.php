<?php

const VALUE = 0;
const TYPE = 1;
const TYPE_NOUN = 'N';
const TYPE_ADJECTIVE = 'A';

$link = mysqli_connect("localhost","root","root","pos") or die("Error " . mysqli_error($link));

$fp = fopen('part-of-speech.txt', 'r');

$nouns = array();
$adjectives = array();

while ( !feof($fp) )
{
    $line = fgets($fp, 2048);

    $delimiter = "\t";
    $data = str_getcsv($line, $delimiter);

    $param1 = mysqli_real_escape_string($link, $data[VALUE]);

    if ($data[TYPE] == TYPE_NOUN) {
        $param2 = 'noun';
    }
    elseif ($data[TYPE] == TYPE_ADJECTIVE) {
        $param2 = 'adjective';
    }
    else {
        continue;
    }

    $param3 = 'not_reviewed';

    $query = "INSERT into Words (value,classification,status) values ('" . $param1 . "','" . $param2 . "','" . $param3 . "')";
    $result = $link->query($query);
}                              

fclose($fp);

/*
foreach($nouns as $noun) {
echo "\n		<string>" . ucfirst($noun) . "</string>";
}
*/

foreach($adjectives as $adjective) {
echo "\n		<string>" . trim(ucfirst($adjective)) . "</string>";
}