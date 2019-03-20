#!/bin/bash
IMAGE_SIZE=224
GRAPH=/tf_files/retrained_graph.pb
OUTPUT=/tf_files/sandwich.tflite

docker build -t sandwiching tf_files/

docker run -it \
  -v $(pwd)/tf_files:/tf_files \
  -v $(pwd)/training_images/output:/input sandwiching

docker run -it \
  -v $(pwd)/tf_files:/tf_files \
  -v $(pwd)/training_images/output:/input sandwiching tflite_convert \
  --graph_def_file=${GRAPH} \
  --output_file=${OUTPUT} \
  --input_format=TENSORFLOW_GRAPHDEF \
  --output_format=TFLITE \
  --input_shape=1,${IMAGE_SIZE},${IMAGE_SIZE},3 \
  --input_array=input \
  --output_array=final_result \
  --inference_type=FLOAT \
  --input_data_type=FLOAT
