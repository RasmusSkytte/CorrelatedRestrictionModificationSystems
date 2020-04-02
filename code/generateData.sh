# Run the data generators
seq 1 164 | parallel -j 50 "matlab -nodesktop -nosplash -r 'run functions/Fig4_Generator({}); exit'"
seq 1 100 | parallel -j 50 "matlab -nodesktop -nosplash -r 'run functions/FigS3_Generator({}); exit'"
