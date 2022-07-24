#!/bin/bash
set -e
TOTAL_SLOTS=$((RUNAI_MPI_NUM_WORKERS * OMPI_MCA_orte_set_default_slots))

# Ensure all workers are available before executing MPI Command
readarray -t hosts < /etc/mpi/hostfile
max_attempts=60
for host in "${hosts[@]}"; do
	attempts=60
	until ssh -o BatchMode=yes -o ConnectTimeout=5 $host exit &>/dev/null; do
		if [ $attempts -lt $max_attempts ]; then
			echo "Worker ${host} is unavailable. It is probably still creating, retrying..."
			attempts=$((attempts+1))
			sleep 10
		else
			echo "Unable to connect to every worker pod, exiting."
			exit 1
		fi
	done
done


mpirun --allow-run-as-root -np $TOTAL_SLOTS -bind-to none -map-by slot -x NCCL_DEBUG=INFO -x MASTER_ADDR=${hosts[0]} -x MASTER_PORT=1234 -x LD_LIBRARY_PATH -x PATH -mca pml ob1 -mca btl ^openib "$@"