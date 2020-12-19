const fs = require('fs');

const rules = fs.readFileSync('../inputs/input19a.txt', 'utf-8').split('\n');
const messages = fs.readFileSync('../inputs/input19b.txt', 'utf-8').split('\n');

const p = console.log;

const resolvable = [];

// get matches from a rule-line
function matchRule(rule) {
    const m = rule.match(/^(\d+): (.+)$/)
    const key = m[1];
    const str = m[2];
    const m2 = str.match(/(\d+)/g);
    return { key, str, m2 };
};

// sort rules into dependency-free order
rules.forEach(rule => {
    if (!rule.length) return;
    ({key, m2 } = matchRule(rule));
    if (!m2) {
        resolvable.push(parseInt(key));
    }
    else if (m2) {
        const values = m2.map(v => parseInt(v));
        if (values.every(v => resolvable.includes(v))) {
            resolvable.push(parseInt(key));
        }
    }
});

const rulesDict = {};

// resolve numbers to letters, store in rulesDict
rules.forEach(rule => {
    ({ key, str } = matchRule(rule));
    let cleaned = str.replace(/\d+/g, d => rulesDict[d]).replace(/["\s]/g, ''); // keep pipes
    if (cleaned.length > 1) {
        cleaned = `(${cleaned})`;
    }
    rulesDict[key] = cleaned;
})

// validate messages
const invalid1 = messages.reduce((acc, msg) => {
    if (!msg.match(new RegExp(`^${rulesDict['0']}$`))) {
        return acc + 1;
    }
    return acc;
}, 0);
// part 1 - 272
p(messages.length - invalid1, 'valid');


// change rule "8: 42 | 42 8" // => simply means rule 42, N times where N > 0
rulesDict['8'] = `(${rulesDict['42']})+?`;
// change rule "11: 42 31 | 42 11 31" // => amount of 42 must match amount of 31, and > 0
rulesDict['11'] = `(${[1,2,3,4].map(i => `((${rulesDict['42']}){${i}}?(${rulesDict['31']}){${i}}?)`).join('|')})`;
// rule['0'] must now be refreshed according to input
rulesDict['0'] = `${rulesDict['8']}${rulesDict['11']}`

// validate messages
const invalid2 = messages.reduce((acc, msg) => {
    if (!msg.match(new RegExp(`^${rulesDict['0']}$`))) {
        return acc + 1;
    }
    return acc;
}, 0);
// part 2 - 374
p(messages.length - invalid2, 'valid');
