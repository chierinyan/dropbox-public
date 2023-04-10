#!/usr/bin/sh
exec > 'benchmarks.csv' 2>&1

benchmarks='dbfs_matrix bfs_pointer conv2D fir kmean mm quicksort sobel'
l1f='--ic=128:1:32 --dc=256:1:32'
l2f='--l2=1024:2:128'

echo 'Benchmark,L2$ Bytes Read,L2$ Bytes Written,L2$ Read Accesses,L2$ Write Accesses,L2$ Read Misses,L2$ Write Misses,L2$ Writebacks,L2$ Miss Rate,D$ Bytes Read,D$ Bytes Written,D$ Read Accesses,D$ Write Accesses,D$ Read Misses,D$ Write Misses,D$ Writebacks,D$ Miss Rate,I$ Bytes Read,I$ Bytes Written,I$ Read Accesses,I$ Write Accesses,I$ Read Misses,I$ Write Misses,I$ Writebacks,I$ Miss Rate'

for benchmark in $benchmarks; do
    echo -n "${benchmark},"
    spike $l1f $l2f pk ./$benchmark/$benchmark \
        | grep -v -E 'bbl loader|Veirification passed' | awk '{print $NF}' | sed -z 's/\n/,/g;s/,$/\n/'
done
