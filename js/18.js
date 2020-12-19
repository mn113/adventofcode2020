const fs = require('fs');

const data = fs.readFileSync('../inputs/input18.txt', 'utf-8');
const lines = data.split("\n");
lines.pop() // pesky empty line

const p = console.log;

// Evaluate a math string strictly left-to-right, no operator precedence
function mathEvalLtr(str) {
    const regexp = /^\d+\s+[+*]\s+\d+/;
    while (str.match(regexp)) {
        str = str.replace(regexp, eval).trim();
    }
    return eval(str);
}

// Evaluate a math string containing + and *
// + has higher precedence
function mathEvalPlusBeforeTimes(str) {
    const addRegexp = /\d+\s+[+]\s+\d+/;
    const multRegexp = /\d+\s+[*]\s+\d+/;
    while (str.match(addRegexp)) {
        str = str.replace(addRegexp, eval).trim();
    }
    while (str.match(multRegexp)) {
        str = str.replace(multRegexp, eval).trim();
    }
    return eval(str);
}

// Replace the contents of simple (parens) with their internal value
function replaceParens(str, evalFn) {
    const regexp = /\(([^()]+)\)/;
    while (str.match(regexp)) {
        str = str.replace(regexp, (_, p1) => evalFn(p1));
    }
    return evalFn(str);
}

const s1 = '1 + 2 * 3 + 4 * 5 + 6'; // 71 OR 231
const s2 = '1 + (2 * 3) + (4 * (5 + 6))'; // 51 OR 51
const s3 = '2 * 3 + (4 * 5)'; // 26 OR 46
const s4 = '5 + (8 * 3 + 9 + 3 * 4 * 3)'; // 437 OR 1445
const s5 = '5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))'; // 12240 OR 669060
const s6 = '((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2'; // 13632 OR 23340

// part 1 - no operator precedence - 25190263477788
p(lines
    .map(l => replaceParens(l, mathEvalLtr))
    .reduce((acc,next) => acc + next)
);

// part 2 - + before * - 297139939002972
p(lines
    .map(l => replaceParens(l, mathEvalPlusBeforeTimes))
    .reduce((acc,next) => acc + next)
);
