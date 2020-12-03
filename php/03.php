<?php

$inputFile = '../inputs/input03.txt';
$data = file($inputFile);

$grid = array_map(function($line) {
    return str_split(trim($line));
}, $data);
$width = count($grid[0]);
$height = count($grid);

function count_trees_in_sloped_path($dx, $dy) {
    global $grid, $width, $height;
    $x = 0;
    $y = 0;
    $trees = 0;
    while (true) {
        if ($grid[$y][$x] == '#') $trees += 1 ;
        $x += $dx;
        $y += $dy;
        if ($x >= $width) $x -= $width ;
        if ($y >= $height) break;
    }
    return $trees;
}

$a = count_trees_in_sloped_path(1, 1);
$b = count_trees_in_sloped_path(3, 1);
$c = count_trees_in_sloped_path(5, 1);
$d = count_trees_in_sloped_path(7, 1);
$e = count_trees_in_sloped_path(1, 2);

// part 1
print "P1: $b\n";

// part 2
$product = $a * $b * $c * $d * $e;
print "P2: $product\n";
