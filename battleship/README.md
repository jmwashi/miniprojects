# battleship-test-cases

Each of these test cases build upon the complexity of the last one.
It is recommended to attempt to solve them in order.

## Legend

### Input Format

    $width
    $height
    $GRID

#### Example

    5
    10
    .....
    .....
    ..x..
    ..x..
    ..?..
    .....
    ...?.
    .....
    .?...
    ...?.

| Symbol | Meaning        |
| ------ | -------------- |
| .      | Unknown        |
| x      | Hit            |
| ?      | Miss           |
| \*     | Hit, ship sunk |

### Output

| Symbol | Meaning            |
| ------ | ------------------ |
| +      | Valid Next Target  |
| -      | Not a Valid Target |

#### Example

##### Input

    5
    10
    .....
    .....
    ..x..
    ..x..
    ..?..
    .*...
    .*.?.
    .....
    .?...
    ...?.

##### Output

    -----
    --+--
    -----
    -----
    -----
    -----
    -----
    -----
    -----
    -----
