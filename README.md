# HC12 LED Dimming Program

## Overview

This repository contains an assembly language program for the HC12 microcontroller. The program's objective is to dim LED lights on the CSM-12C128 board using the Pulse Width Modulation (PWM) technique. This README provides instructions on setting up the hardware, configuring the software, and running the program on the CodeWarrior debugger/simulator.

## Program Functionality

The program, 'main.asm,' achieves the following functionality:

- Initially, LED 2 is OFF (0%), LED 3 is ON (100%), and LED 4 is OFF (0%).
- LED 1 gradually goes from 0% light level to 100% light level in 0.1 seconds.
- LED 1 then goes from 100% light level to 0% light level in 0.1 seconds.
- This sequence from (1) to (2) is repeated continuously.

## Hardware Setup

To run this program, you will need the following hardware:

- CSM-12C128 board
- LED lights connected to the appropriate pins

Ensure that the hardware connections are properly set up according to the program's requirements.

## Software Setup

To configure the software environment for running this program, follow these steps:

1. **Install CodeWarrior:** Make sure you have CodeWarrior installed on your computer. If not, download and install it from the official website.

2. **Create a New Project:**
   - Open CodeWarrior.
   - Create a new HC12 assembly project.
   - Set the project name and location.

3. **Add Source Code:**
   - Copy the 'main.asm' file from this repository into your project folder.
   - Add the 'main.asm' file to your project in CodeWarrior.

4. **Configure Project Settings:**
   - Configure the project settings, ensuring that the program starts at address $3100 and data starts at address $3000, as specified in the instruction steps.

## Running the Program

To run the program on the CodeWarrior debugger/simulator, follow these steps:

1. **Build the Project:**
   - Build the project to assemble the 'main.asm' file.

2. **Load the Program:**
   - Load the assembled program onto the CodeWarrior debugger/simulator.

3. **Start Debugging:**
   - Start the debugging process.

4. **Observe the LED Dimming:**
   - Monitor the simulator Visualization Tool window to observe the LED dimming as described in the program functionality.

## Notes

- Running your program on the CodeWarrior simulator is significantly slower (about 100 times) than running it on the actual CSM-12C128 board. Keep this timing difference in mind while testing the program.
- The dimming effect on the actual CSM-12C128 board may appear as fast blinking on the simulator.
- Ensure that your hardware connections are correct to see the desired LED behavior.

# Academic Integrity Statement

Please note that all work included in this project is the original work of the author, and any external sources or references have been properly cited and credited. It is strictly prohibited to copy, reproduce, or use any part of this work without permission from the author.

If you choose to use any part of this work as a reference or resource, you are responsible for ensuring that you do not plagiarize or violate any academic integrity policies or guidelines. The author of this work cannot be held liable for any legal or academic consequences resulting from the misuse or misappropriation of this work.

Any unauthorized copying or use of this work may result in serious consequences, including but not limited to academic penalties, legal action, and damage to personal and professional reputation. Therefore, please use this work only as a reference and always ensure that you properly cite and attribute any sources or references used.
