<?php
$time_start = microtime(true);

$starter = [null,5,1,9,18,13,8,0];

function say_until($limit) {
    global $starter;

    // $elvish keys: $n
    // $elvish values: array of [penultimate, last] indices
    $elvish = [0 => [null,null]];

    $n = null;

    for ($i = 0; $i <= $limit; $i++) {
        // first few assignments
        if ($i < count($starter)) {
            $n = $starter[$i];
            $elvish[$n] = [$i];
        }
        // unseen n: log under key 0
        else if (!array_key_exists($n, $elvish)) {
            $n = 0;
            $elvish[0][0] = $elvish[0][1]; // move last to first
            $elvish[0][] = $i; // update last
        }
        else {
            // work out new n
            if (count($elvish[$n]) === 1) {
                $new_n = 0;
            }
            else {
                $new_n = $elvish[$n][1] - $elvish[$n][0];
            }

            // log under key new n
            if (!array_key_exists($new_n, $elvish)) {
                $elvish[$new_n] = [$i]; // add first
            }
            else if (count($elvish[$new_n]) === 1) {
                $elvish[$new_n][] = $i; // add second
            }
            else {
                $elvish[$new_n][0] = $elvish[$new_n][1]; // move last to first
                $elvish[$new_n][1] = $i; // update last
            }
            $n = $new_n;
        }
    }
    return $n;
}

print "p1: ";
print say_until(2020); // 376
print "\n";

print "p2: ";
print say_until(30000000); // 323780
print "\n";

print "Total execution time in seconds: " . (microtime(true) - $time_start);