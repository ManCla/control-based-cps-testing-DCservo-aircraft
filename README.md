# Control-Based CPS Stress Tesing: DCservo case study

This repository is associated to the submission of the paper _Stress Testing of Control-Based Cyber-Physical Systems_.
It contains the model of the DC servo case study and the scripts that implement the proposed testing apporach.

## Repository Structure and Content

The repository contains the following sub directories:

 * _model_: contains the simulink model of the DC servo
 * _testing_: contains the matlab functions that implement the functionalities of the testing approach

The main directory contains different scripts

 * _init.m: it initializes relevant variables (paths, data directories names, non-linear phenomena selection, testing apporach parameters)
 * _run\_once_: executes a single test (given shape, amplitude scaling and time scaling)
 * _plot\_single\_test.m_: plots the output of a single test
 * _step\*.m_: implement the different steps of the apporach

## Execution of Testing Campaign

To execute the testing campaing execute the following commands from the matlab shell:

 * Run *init.m* to initialise the testing process. Most importantly, change lines 46 and 47 to select the non-linearites to be included in the DC servo model.
 * 
 * 
