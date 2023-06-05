# Control-Based CPS Stress Tesing

This repository is associated to the submission of the paper _Stress Testing of Control-Based Cyber-Physical Systems_.
It contains the model of the DC servo case study and the scripts that implement the proposed testing apporach.

## Dependencies

You will need the following add-ons to matlab: Simulink, the control systems toolbox, the statistics toolbox.

## Repository Structure and Content

The repository contains the following sub directories:

 * _model_: contains the simulink models of the DC servo and of the lightweight aircraft.
 * _testing_: contains the matlab functions that implement the functionalities of the testing approach

The main directory contains different scripts

 * \*_init.m_: it initializes relevant variables (paths, data directories names, non-linear phenomena selection, testing apporach parameters). Two different scripts initialize the two case studies.
 * _run\_once_: executes a single test (given shape, amplitude scaling and time scaling)
 * _plot\_single\_test.m_: plots the output of a single test
 * _step\*.m_: implement the different steps of the apporach
 * _preliminary\_eval\_num\_periods.m_: performs the preliminary evaluation used to evaluate the number of periods needed for the computation of the __dnl__ metric

## Execution of Testing Campaign

To execute the testing campaing execute the following commands from the matlab shell:

 * Run ``DCservo_init`` or``LW_altotude`` to initialise the testing process. In the DC servo case study, change lines 46 and 47 to select the non-linearites to be injected.
 * Run ``step1`` to execute the search to retrieve the upper bound of the amplitude values.
 * Run ``step2`` to use the amplitude upper bound to generate the test set.
 * Run ``step3a`` to execute the obtained test set.
 * Run ``step3b`` to analyse the test output (obtain frequency-amplitude points, degree of non linearity, degree of filtering, and non-linear behavoiure ground truth).
 * Run ``step3c`` plot the analysis resutls.

Each step provides its output in the form of csv files.
Those files are stored in the folder _dcServo_test_data_\*periods_ (or _lwAltitude_test_data_\*periods_) where the \* is the number of periods executed in the tests (__note:__ this folder needs to be manually created).
The folder contains separated subfolders for each  version of the DC servo (defined by the different non-linearities included).




