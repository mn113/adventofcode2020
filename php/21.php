<?php

// $input = "mxmxvkd kfcds sqjhc nhms (contains dairy, fish)\n
// trh fvjkl sbzzf mxmxvkd (contains dairy)\n
// sqjhc fvjkl (contains soy)\n
// sqjhc mxmxvkd sbzzf (contains fish)";
$rules = explode("\n", $input);

$inputFile = '../inputs/input21.txt';
$rules = file($inputFile);


$next_allergen = 'A';
$next_ingredient = 1;

$all_ingredients = [];
$ingredients_by_allergen = [];

foreach ($rules as $rule) {
    // print($rule . "\n");
    $bracket_pos = strpos($rule, '(');
    $first = substr($rule, 0, $bracket_pos);
    $last = substr($rule, $bracket_pos + 9);
    $ingredients = array_filter(explode(' ', trim($first)), function($el) {
        return strlen($el);
    });
    $all_ingredients = array_merge($all_ingredients, $ingredients);
    preg_match_all("/\w+/", $last, $allergens);
    // print(implode(', ', $allergens[0]) . "\n");
    // print(implode(', ', $ingredients) . "\n");
    foreach ($allergens[0] as $a) {
        // print($a . "\n");
        if (!array_key_exists($a, $ingredients_by_allergen)) {
            $ingredients_by_allergen[$a] = [];
        }
        array_push($ingredients_by_allergen[$a], $ingredients);
    }
}
// var_dump($ingredients_by_allergen);
// var_dump($all_ingredients);

$candidates = [];

foreach ($ingredients_by_allergen as $allergen => $recipes) {
    $all_elements = array_unique(array_merge(...$recipes));
    foreach ($all_elements as $elem) {
        $in_all = true;
        foreach ($recipes as $rec) {
            if (!in_array($elem,$rec)) {
                $in_all = false;
                break;
            }
        }
        if ($in_all) {
            print("$elem in all recipes warning of $allergen\n");
            if (!array_key_exists($allergen, $candidates)) {
                $candidates[$allergen] = [];
            }
            array_push($candidates[$allergen], $elem);
        }
    }
}

$known = [];

$n = 6;
while ($n > 0) {
    print("$n\n");
    $to_remove = [];
    foreach ($candidates as $allergen => $list) {
        if (count($list) === 1) {
            $found = $list[0];
            $to_remove[] = $found;
            $known[$allergen] = $found;
            print("known $found = $allergen\n");
        }
    }
    if (count($to_remove)) {
        foreach ($candidates as $allergen => $list) {
            $candidates[$allergen] = array_values(array_filter($list, function($el) {
                global $to_remove;
                return !in_array($el, $to_remove);
            }));
        }
        $candidates = array_filter($candidates, function($list) {
            return count($list);
        });
    }
    $n--;
}

$known_ingreds = array_values($known);

$clear = array_filter($all_ingredients, function($el) {
    global $known_ingreds;
    return !in_array($el, $known_ingreds);
});

// part 1 - 1679 too high
$ans = count($clear);
print("p1: $ans\n");

// part2 - value sorted alphabetically by key
// dairy,eggs,fish,peanuts,sesame,shellfish,soy,wheat
$alpha_keys = array_keys($known);
sort($alpha_keys);
print("p2: " . implode(",", array_map(function($k) {
    global $known;
    return $known[$k];
}, $alpha_keys)) . "\n");

