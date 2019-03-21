#!/bin/bash
IMAGE_SIZE=224
GRAPH=/tf_files/retrained_graph.pb
OUTPUT=/tf_files/sandwich.tflite
OUTPUT_LABELS=/tf_files/retrained_labels.txt
ARCHITECTURE=mobilenet_0.50_${IMAGE_SIZE}
# TF_HUB_MODEL=https://tfhub.dev/google/imagenet/mobilenet_v1_050_224/classification/1
TF_HUB_MODEL=https://tfhub.dev/google/imagenet/mobilenet_v1_050_224/feature_vector/1
TRAINING_STEPS=500

echo "Building docker image..."
docker build -t sandwiching tf_files/

# echo "Retraining model with given images..."
# docker run -it \
#   -v $(pwd)/tf_files:/tf_files \
#   -v $(pwd)/training_images/output:/input sandwiching python3 /tf_files/retrain.py \
#   --bottleneck_dir=/tf_files/bottlenecks \
#   --how_many_training_steps="${TRAINING_STEPS}" \
#   --summaries_dir=/tf_files/training_summaries/"${ARCHITECTURE}" \
#   --output_graph="${GRAPH}" \
#   --output_labels="${OUTPUT_LABELS}" \
#   --architecture="${ARCHITECTURE}" \
#   --image_dir=/input

# echo "Now to convert this puppy!"
# docker run -it \
#   -v $(pwd)/tf_files:/tf_files \
#   -v $(pwd)/training_images/output:/input sandwiching tflite_convert \
#   --graph_def_file=${GRAPH} \
#   --output_file=${OUTPUT} \
#   --input_format=TENSORFLOW_GRAPHDEF \
#   --output_format=TFLITE \
#   --output_array=final_result \
#   --inference_type=FLOAT \
#   --input_data_type=FLOAT
# --input_shape=1,${IMAGE_SIZE},${IMAGE_SIZE},3 \
# --input_array=input \

# run with tfhub modules and modern script
docker run -it \
  -v $(pwd)/tf_files:/tf_files \
  -v $(pwd)/training_images/output:/input sandwiching python3 ./retrain.py \
  --how_many_training_steps="${TRAINING_STEPS}" \
  --summaries_dir=/tf_files/training_summaries/"${ARCHITECTURE}" \
  --output_graph="${GRAPH}" \
  --output_labels="${OUTPUT_LABELS}" \
  --image_dir=/input \
  --tfhub_module="${TF_HUB_MODEL}" \
  --saved_model_dir=/tf_files/models

docker run -it \
  -v $(pwd)/tf_files:/tf_files \
  -v $(pwd)/training_images/output:/input sandwiching tflite_convert \
  --graph_def_file=tf_files/retrained_graph.pb \
  --output_file=tf_files/sandwich.tflite \
  --output_array=final_result \
  --input_array=Placeholder
