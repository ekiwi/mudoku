mudoku
======

A sudoku solver using LEGO and Matlab.

## Class Structure

### AbstractScanner
* Methods
	* **firstScan()**: find grid size, position of cells that contain
	a number
	* **scanCells()**: scans individual cells that contain numbers
	* **getCell(x,y)**: if cell @ x,y contains a number, a 2D greyscale
	matrix is returned
	* **saveCells(fileName)**: save cells to file
	* **loadCells(fileName**: load cells from file
	* **[x,y] = getNumCells()**: returns the number of cells in
	x/y position

### ImageRecognition
* Methods
	* **parseCell(img_matrix)**: takes a 2D greyscale matrix and
	returns the number it represents

### Drawer

## Hardware Abstraction Layer
Provides a wrapper around the low level hardware functions.
Is the only class that accesses the RWTH Mindstorms toolbox directly.

* Methods
	* **HardwareAbstractionLayer(varargin)**: creates an instance and
	opens both NXTs that need to be connected via USB
	* **toggleLamp1**: toggles lamp 1
	* **toggleLamp2**: toggles lamp 2
	* **value = getBrightness1**: returns the value of light sensor 1
	* **value = getBrightness2**: returns the value of light sensor 2
	* **value = getBrightness3**: returns the value of light sensor 3
	* **[a b c] = getBrightness**: returns the values of all three 
	light sensors
	* **moveRight(steps)**: tells the hardware to move right
	* **moveLeft(steps)**: tells the hardware to move left
	* **moveRightW(steps)**: tells the hardware to move right and delays
	program execution untill operation is finished
	* **moveLeftW(steps)**: tells the hardware to move left and delays
	program execution untill operation is finished
	* **moveForwards(steps)**: tells the hardware to move forwards
	* **moveBackwards(steps)**: tells the hardware to move backwards
	* **moveForwardsW(steps)**: tells the hardware to move forewards and
	delays program execution untill operation is finished
	* **moveBackwardsW(steps)**: tells the hardware to move backwards and
	delays program execution untill operation is finished
	* **ans = reachedEnd**: returns 0 if neither of the limit switches is 
	activated, else returns 1
	* **moveToLeftLimit**: moves to the left until end is reached
	* **moveToRightLimit**: moves to the right until end is reached
	* **calibrateSledge**: calculates the max width steps which the sledge can move
	* **[x y] = getPosition**: gets the current position from the motors 
	* **moveToXY(x, y)**: moves to a specific location
