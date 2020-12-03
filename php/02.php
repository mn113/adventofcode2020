<?php

$inputFile = '../inputs/input02.txt';
$data = file($inputFile);

$data = array_map(function($line) {
    preg_match("/(?<lo>\d+)-(?<hi>\d+) (?<letter>[a-z]+): (?<password>[a-z]+)/", $line, $m);
    return [
        'lo' => intval($m['lo']),
        'hi' => intval($m['hi']),
        'letter' => $m['letter'],
        'password' => $m['password']
    ];
}, $data);

function contains_letter_sufficiently($password, $letter, $lo, $hi) {
    $num = substr_count($password, $letter);
    return $num >= $lo && $num <= $hi;
}

function has_letter_in_first_xor_last_position($password, $letter, $lo, $hi) {
    $first = $password[$lo-1] == $letter;
    $last = $password[$hi-1] == $letter;
    return $first xor $last;
}

// part 1
$n1 = count(array_filter($data, function($line) {
    return contains_letter_sufficiently(
        $line['password'],
        $line['letter'],
        $line['lo'],
        $line['hi']
    );
}));
print "P2: $n1\n";

// part 2
$n2 = count(array_filter($data, function($line) {
    return has_letter_in_first_xor_last_position(
        $line['password'],
        $line['letter'],
        $line['lo'],
        $line['hi']
    );
}));
print "P2: $n2\n";