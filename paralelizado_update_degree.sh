#!/bin/bash
#SBATCH -c 32 #(8 cores per job)
#SBATCH -t 00:02:000 #(10 min of execution time)
#SBATCH --mem=4G #(4GB of memory)
#SBATCH --exclusive

export LC_NUMERIC="en_US.UTF-8"
mkdir -p results

# Ejecuta el comando 3 veces con el comando time
for i in 1 2 4 8 16 32 64
do
        > "results/prueba_${i}.txt"
        export OMP_NUM_THREADS=$i
        total_time=0
        for j in {1..5}
        do
                echo "Ejecución $j para OMP_NUM_THREADS=$i"
                execution_time=$( (time -p ./paralelizado_update_degree) 2>&1 | grep real | awk '{printf "%.4f", $2}' )
                echo "Tiempo real de ejecución $j: $execution_time"
                echo "Tiempo real de ejecución $j: $execution_time" >> "results/prueba_${i}.txt"
                total_time=$(awk "BEGIN {print $total_time + $execution_time}")
                echo "---------------------------------"
        done
        average_time=$(awk "BEGIN {print $total_time / 5}")

        echo ""
        echo "Media: $average_time"

        echo "" >> "results/prueba_${i}.txt"
        echo "Media: $average_time" >> "results/prueba_${i}.txt"
done
