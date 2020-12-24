const fs = require('fs');

let instructions = fs.readFileSync('../inputs/input24.txt', 'utf-8').split('\n');

const p = console.log;

const blackTiles = new Set();

const toKey = (arr) => arr.join('_');
const toArr = (key) => key.split('_').map(c => parseInt(c));

// axis 0: increasing NE
// axis 1: increasing SE
//            ___
//    NW  ___/2,0\___  NE
//    ___/1,0\___/2,1\___
// W /0,0\___/1,1\___/2,2\ E
//   \___/0,1\___/1,2\___/
//       \___/0,2\___/
//    SW     \___/     SE

/**
 * Parse a string such as 'eneswwnwse' to a directions array
 * @param {String} str
 * @returns {Array}
 */
function parse(str) {
    str = str
        .replace(/([sn][ew])/g,',$&,')
        .replace(/([ew])([ew])/g, ',$1,$2,')
        .replace(/,,/g, ',')
        .replace(/^,|,$/g, '');
    return str.split(',');
}

/**
 * Print output to terminal
 */
function printGrid() {
    const { minX, maxX, minY, maxY } = getMinMax();

    for (let x = minX; x <= maxX; x++) {
        let row = ' '.repeat(x - minX);
        for (let y = minY; y <= maxY; y++) {
            const key = `${x}_${y}`;
            row += blackTiles.has(key) ? 'B' : '.';
            row += (x === 0 && y === 0) ? '<' : ' ';
        }
        p(row);
    }
}

/**
 * Get the keys of the 6 hexagons touching the one identified by cellKey
 * @param {String} cellKey
 * @returns {String[]} 6 keys
 */
function getNeighbourKeys(cellKey) {
    const cell = toArr(cellKey);
    // SE,NW,SW,NE,S,N
    const deltas = [[0,1], [0,-1], [1,0], [-1,0], [-1,1], [1,-1]];
    return deltas
        .map(d => [cell[0] + d[0], cell[1] + d[1]])
        .map(toKey);
}

/**
 * Get the minimum and maximum x and y needed to cover blackTiles and periphery
 * @returns {Object}
 */
function getMinMax() {
    const coords = Array.from(blackTiles).map(toArr);
    const xValues = coords.map(c => c[0]);
    const yValues = coords.map(c => c[1]);
    const minX = Math.min(...xValues) - 1;
    const maxX = Math.max(...xValues) + 1;
    const minY = Math.min(...yValues) - 1;
    const maxY = Math.max(...yValues) + 1;
    return { minX, maxX, minY, maxY };
}

/**
 * Loop through all hexagons, build flip list according to rules,
 * flip to create new blackTiles set
 * @param {Number} day
 */
function runDay(day) {
    const { minX, maxX, minY, maxY } = getMinMax();
    toFlip = new Set();
    for (let x = minX; x <= maxX; x++) {
        for (let y = minY; y <= maxY; y++) {
            // check black neighbours
            const key = `${x}_${y}`;
            const isBlack = blackTiles.has(key);
            const blackNbsCount = getNeighbourKeys(key)
                .map(nKey =>  blackTiles.has(nKey))
                .filter(Boolean)
                .length;

            // mark as "to flip"
            if (isBlack && (blackNbsCount === 0 || blackNbsCount > 2)) {
                toFlip.add(key);
            }
            if (!isBlack && blackNbsCount === 2) {
                toFlip.add(key);
            }
        }
    }
    // flip "to flip" tiles
    for (let fKey of toFlip) {
        if (blackTiles.has(fKey)) {
            blackTiles.delete(fKey);
        } else {
            blackTiles.add(fKey);
        }
    }

    if (day % 25 === 0) {
        p(`> Days passed: ${day}`)
    }
}

// set up tiles according to instructions
for (const instr of instructions) {
    pos = [0,0];
    for (const step of parse(instr.trim())) {
        // move
        switch (step) {
            // axis 1
            case 'sw':
                pos[1]--;
                break
            case 'ne':
                pos[1]++;
                break
            // axis 2
            case 'se':
                pos[0]++;
                pos[1]--;
                break;
            case 'nw':
                pos[0]--;
                pos[1]++;
                break;
            // horizontal
            case 'w':
                pos[0]--;
                break;
            case 'e':
                pos[0]++;
                break;
            default:
                throw new Error(`invalid step: ${step}`)
                break;
        }
    }
    // alter final tile
    const key = toKey(pos);
    if (blackTiles.has(key)) {
        blackTiles.delete(key);
    } else {
        blackTiles.add(key);
    }
}

// part 1 - 277
printGrid();
p(`p1: ${blackTiles.size}`);
p('---');

// part 2 - 3531
for (let i = 1; i <= 100; i++) {
    runDay(i);
}
p(`p2: ${blackTiles.size}`);
