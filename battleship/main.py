#defining constants for values will help readability of code rather than just symbols
UNKNOWN = '.'
HIT = 'x'
MISS = '?'
SUNK = '*'

class Ship:
     def __init__(self, orientation, coordsHit,coordsNeeded):
        #defining orientatino is useful for properly identifying ships and 
        self.orientation = orientation
        self.coordsHit = coordsHit
        self.coordsNeeded = coordsNeeded

def findShips(grids):
    shipList = []
    coordsRecorded = []
    rowNum = 0
    for rows in grids:
        colNum = 0
        for x in rows:
            if x == HIT:
                coords = str(rowNum)+str(colNum)
                if coords not in coordsRecorded:
                    coordsRecorded.append(coords)
                    coordsUp = str(rowNum-1)+str(colNum)
                    coordsLeft = str(rowNum)+str(colNum-1)
                    coordsRight = str(rowNum)+str(colNum+1)
                    coordsDown=str(rowNum+1)+str(colNum)
                    possibleCoords = []
                    if grids[int(coordsUp[0])][int(coordsUp[1])] == HIT or grids[int(coordsDown[0])][int(coordsDown[1])] == HIT:
                        if grids[int(coordsUp[0])][int(coordsUp[1])] == HIT:
                            coordsRecorded.append(coordsUp)
                            while True:
                                if grids[int(coordsUp[0])-1][int(coordsUp[1])] != HIT:
                                    coordsUp= str(int(coordsUp[0])-1) + str(coordsUp[1])
                                    break
                                coordsUp= str(int(coordsUp[0])-1) + str(coordsUp[1])
                                coordsRecorded.append(coordsUp)
                        if grids[int(coordsDown[0])][int(coordsDown[1])] == HIT:
                            coordsRecorded.append(coordsDown)
                            while True:
                                if grids[int(coordsDown[0])+1][int(coordsDown[1])] != HIT:
                                    coordsDown = str(int(coordsDown[0])+1) + str(coordsDown[1])
                                    break
                                coordsDown = str(int(coordsDown[0])+1) + str(coordsDown[1])
                                coordsRecorded.append(coordsDown)
                        possibleCoords.append(coordsDown)
                        possibleCoords.append(coordsUp)
                        ship = Ship('Vertical',coords,possibleCoords)
                        shipList.append(ship)
                        continue
                    if grids[int(coordsLeft[0])][int(coordsLeft[1])] == HIT or grids[int(coordsRight[0])][int(coordsRight[1])] == HIT:
                        if grids[int(coordsLeft[0])][int(coordsLeft[1])] == HIT:
                            coordsRecorded.append(coordsLeft)
                            while True:
                                if grids[int(coordsLeft[0])][int(coordsLeft[1])-1] != HIT:
                                    coordsLeft = str(coordsLeft[0]) + str(int(coordsLeft[1])-1)
                                    break
                                coordsLeft = str(coordsLeft[0]) + str(int(coordsLeft[1])-1)
                                coordsRecorded.append(coordsLeft)
                        if grids[int(coordsRight[0])][int(coordsRight[1])] == HIT:
                            coordsRecorded.append(coordsRight)
                            while True:
                                if grids[int(coordsRight[0])][int(coordsRight[1])+1] != HIT:
                                    coordsRight = str(coordsRight[0]) + str(int(coordsRight[1])+1)
                                    break
                                coordsRight = str(coordsRight[0]) + str(int(coordsRight[1])+1)
                                coordsRecorded.append(coordsRight)
                        possibleCoords.append(coordsLeft)
                        possibleCoords.append(coordsRight)
                        ship = Ship('Horizontal',coords,possibleCoords)
                        shipList.append(ship)
                    else:
                        possibleCoords.append(coordsUp)
                        possibleCoords.append(coordsDown)
                        possibleCoords.append(coordsLeft)
                        possibleCoords.append(coordsRight)
                        ship = Ship('None',coords,possibleCoords)
                        shipList.append(ship)
                        continue
            colNum += 1
        rowNum += 1
    print(coordsRecorded)
    return shipList

def main():
    f = open("06-directional-one-end","r")
    columns =int(f.readline().rstrip())
    rows = int(f.readline().rstrip())
    grids = [[] for x in range (rows)]
    i = 0
    for element in f.readlines():
        element = element.rstrip()
        for var in element:
            grids[i].append(var)
        i += 1

    shipList = findShips(grids)
    rowNum = 0
    if not shipList :
        for rows in grids:
            colNum = 0
            for x in rows:
                if x == '.':
                     grids[rowNum][colNum] = '+'
                else:
                   grids[rowNum][colNum] = '-'
                colNum += 1
            rowNum += 1
    else:
        for rows in grids:
            colNum = 0
            for x in rows:
                grids[rowNum][colNum] = '-'
                colNum += 1
            rowNum += 1
        for ship in shipList:
            for coords in ship.coordsNeeded:
                grids[int(coords[0])][int(coords[1])] = '+'

    for line in grids:
        print(line)




main()














