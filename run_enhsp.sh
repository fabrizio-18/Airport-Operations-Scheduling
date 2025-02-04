#!/bin/bash

# Define paths
PLANNER="java -jar /home/indigolog/Desktop/PDDL/enhsp-20.jar"  # Adjust path if necessary
DOMAIN="/home/indigolog/Desktop/PDDL/airport_operation_domain.pddl"

# Problem instances
PROBLEMS=("/home/indigolog/Desktop/PDDL/instance1.pddl" "/home/indigolog/Desktop/PDDL/instance2.pddl" "/home/indigolog/Desktop/PDDL/instance3.pddl")

# Heuristic configurations
CONFIGS=("sat-hadd" "opt-hmax")

# Run ENHSP sequentially for each problem with each heuristic

for PROBLEM in "${PROBLEMS[@]}"; do
    INSTANCE_NAME=$(basename "$PROBLEM" .pddl)  # Estrai il nome dell'istanza senza estensione
    for CONFIG in "${CONFIGS[@]}"; do
        echo "Running ENHSP-20 for $PROBLEM with $CONFIG..."
        $PLANNER -o $DOMAIN -f $PROBLEM -planner $CONFIG > "results_${INSTANCE_NAME}_${CONFIG}.txt"
        echo "Results saved to results_${INSTANCE_NAME}_${CONFIG}.txt"
    done
done
