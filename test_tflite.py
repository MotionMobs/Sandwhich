import argparse
from PIL import Image
# import imageio
import numpy as np
import tensorflow as tf

def load_labels(label_file):
  label = []
  proto_as_ascii_lines = tf.gfile.GFile(label_file).readlines()
  for l in proto_as_ascii_lines:
    label.append(l.rstrip())
  return label

def read_tensor_from_image_file(file_name,
                                model,
                                input_height=224,
                                input_width=224,
                                input_mean=0,
                                input_std=255):
  interpreter = tf.lite.Interpreter(model_path=model)
  interpreter.allocate_tensors()

  # Get input and output tensors.
  input_details = interpreter.get_input_details()
  output_details = interpreter.get_output_details()

  img = Image.open(file_name)
  img = img.resize((input_details[0]['shape'][1], input_details[0]['shape'][2]))

  input_data = np.expand_dims(img, axis=0)

  if input_details[0]['dtype'] == type(np.float32(1.0)):
    floating_model = True
  
  if floating_model:
    input_data = (np.float32(input_data) - input_mean) / input_std

  interpreter.set_tensor(input_details[0]['index'], input_data)

  interpreter.invoke()
  results = interpreter.get_tensor(output_details[0]['index'])
  results = np.squeeze(results)
  return results

if __name__ == "__main__":
  label_file = "tensorflow/examples/label_image/data/imagenet_slim_labels.txt"
  model_file = \
    "tensorflow/examples/label_image/data/inception_v3_2016_08_28_frozen.pb"
  parser = argparse.ArgumentParser()
  parser.add_argument("--model", help="tflite model to be executed")
  parser.add_argument("--image", help="image to be processed")
  parser.add_argument("--labels", help="name of file containing labels")
  args = parser.parse_args()
  if args.model:
    model_file = args.model
  if args.image:
    file_name = args.image
  if args.labels:
    label_file = args.labels

  results = read_tensor_from_image_file(file_name, model_file)
  top_k = results.argsort()[-5:][::-1]
  labels = load_labels(label_file)
  for i in top_k:
    print(labels[i], results[i])
