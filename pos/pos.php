<?php

const VALUE = 0;
const TYPE = 1;
const TYPE_NOUN = 'N';
const TYPE_ADJECTIVE = 'A';

$fp = fopen('part-of-speech.txt', 'r');

$nouns = array();
$adjectives = array();

while ( !feof($fp) )
{
    $line = fgets($fp, 2048);

    $delimiter = "\t";
    $data = str_getcsv($line, $delimiter);

	if ($data[TYPE] == TYPE_NOUN) {
		$nouns[] = $data[VALUE];
	}
    if ($data[TYPE] == TYPE_ADJECTIVE) {
		$adjectives[] = $data[VALUE];
	}
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