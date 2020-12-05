<?php

$inputFile = '../inputs/input05.txt';
$data = file($inputFile);

function find_row($directions) {
    $binary = str_replace(["F", "B"], ["0", "1"], $directions);
    return intval($binary, 2);
}

function find_col($directions) {
    $binary = str_replace(["L", "R"], ["0", "1"], $directions);
    return intval($binary, 2);
}

function find_seat($code) {
    $row = find_row(substr($code, 0, 7));
    $col = find_col(substr($code, 7, 3));
    return ($row * 8) + $col;
}

$filled_seats = array_map("find_seat", $data);

# part 1 - 989
$lo = min($filled_seats);
$hi = max($filled_seats);
print "$hi\n";

# part 2 - 548
for ($i = $lo; $i < $hi; $i++) {
    if (!in_array($i, $filled_seats)) {
        print "$i\n";
        break;
    }
}
