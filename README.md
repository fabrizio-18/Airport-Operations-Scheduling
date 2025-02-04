# Airport-Operations-Scheduling

## LM: Artificial Intelligence & Robotics - P&R assignment 
[Fabrizio Italia](https://github.com/fabrizio-18), [Stefano D'Urso](https://github.com/stefa350), [Vincenzo Crisà](https://github.com/crisa11)

Sapienza University of Rome, Italy

## Overview

The goal is to efficiently manage the movement and allocation of planes, runways,and gates in an airport. Planes arrive at the airport and require an available runway for landing. Once landed, they must taxi to a gate for passenger boarding or unloading. After completing operations at the gate, the planes need a runway to take off. Constraints include:
* Runways can only be used by one plane at a time.
* Gates have limited availability and can accommodate only one plane at a time.
* Taxiing between runways and gates consumes time and resources, which should be minimized.
* Planes have different fuel levels.

The system should aim to minimize fuel consumption, ensuring efficient use of runways
and gates.

## PDDL

In the problem files the different design choices of the initial state are related to 
* Planes that are waiting to land.
* Available runways and gates.
* Initial fuel level of each plane.
* Taxi time for each plane to each gate (and runway).
* Fuel consumption rate of the actions.
* The eventual assigned gate of each plane.
* The eventual high-priority planes.

The goal is to take off all the planes, after their landing and gating process.

### Instance 1
*Initial State*:
* One runway (```R1```) is available.
* Three gates (```G1, G2, G3```) are available.
* Two planes (```P1, P2```) are waiting to land.
* All gates are unoccupied.

*Goal*: ```P1``` and ```P2``` have landed, taxied to gates, completed their operations, and taken
off.

### Instance 2
*Initial State*:
* Two runways (```R1, R2```) are available.
* Four gates (```G1, G2, G3, G4```) are available.
* Three planes (```P1, P2, P3```) are approaching the airport.
* Each plane has a specific assigned gate: ```P1``` to ```G1```, ```P2``` to ```G2```.

*Goal*: All planes have landed, used their assigned gates, and taken off.

### Instance 3
*Initial State*:
* Three runways (```R1, R2, R3```) are available.
* Five gates (```G1, G2, G3, G4, G5```) are available.
* Five planes (```P1, P2, P3, P4, P5```) are scheduled for landing.
* ```P1``` and ```P2``` are high-priority (VIP planes) and must take precedence for gates and runways.
* All gates are initially unoccupied.

*Goal*:
* All planes have landed, completed operations at their gates, and taken off.
* High-priority planes (```P1, P2```) are served before the others.

## Planner
ENHSP-20, acronym for Expressive Numeric Heuristic Search Planner, is a PDDL automated planning system that supports classical and numeric Planning. The planner reads in input a PDDL domain and problem file and it provides a sequence of actions to achieve the goal state starting from an initial state.
The planner is used with **sat-hadd** and **opt-hmax** heuristics.

## Running the Planner

1. The ENHSP planner has a Java dependency which can be met by Java version 17.0 in Ubuntu 24.04.1. Run the following line successively on command terminal to download and install the required jdk:
```
sudo dpkg -i jdk-17_linux-x64_bin.deb
```
2. In your workspace, download the ‘enhsp-20.jar’ file from _[here](https://sites.google.com/view/enhsp/)_.
3. Navigate to the work folder:
```
cd <work_folder>
```
4. Make the file executable in the repository:
```
chmod +x ./run_enhsp.sh
```
5. Run:
```
./run_enhsp.sh
```
6. The generated output is in text file format ```results_<instance_number>_<heuristic>.txt``` after the above command, for example:
```
/root/Desktop/PDDL/results_instance1_sat-hadd.txt
```

## IndiGolog
IndiGolog is applied to the management of airport operations, specifically in handling aircraft landings, taxiing, passenger management, and takeoff processes.
It uses different controllers:
* **Simple scheduling** for sequential operations.
* **Smart scheduling** for efficient gate assignment, based on the planes dimensions.
* **Exogenous scheduling** to incorporate dynamic and emergency landings.

## Running the IndiGolog script
Once your system is enabled to execute the SWI-Prolog interpreter, run the following commands.
1. Execute the interpreter:
```
swipl config.pl <work_folder/main.pl>
```
2. Write:
```
main.
```
3. Choose the controller.
