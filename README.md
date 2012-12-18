mudoku
======

A sudoku solver using LEGO and Matlab.

## Class Structure

### AbstractScanner
* Methods
	* **firstScan()**: find grid size, position of cells that contain a number
	* **scanCells()**: scans individual cells that contain numbers
	* **getCell(x,y)**: if cell @ x,y contains a number, a 2D greyscale matrix is returned

### ImageRecognition
* Methods
	* **parseCell(img_matrix)**: takes a 2D greyscale matrix and returns the number it represents

### Drawer

## Hardware "Abstrction"
File **hardware.m** contains defines for Sensor ports like:

    LIMIT_SWITCH_RIGHT = SENSOR_3 % the right limit switch is on sensor port 3

