import argparse
from PIL import Image
# import imageio
import numpy as np
import tensorflow as tf

def read_tensor_from_image_file(file_name,
                                input_height=299,
                                input_width=299,
                                input_mean=0,
                                input_std=255):
  interpreter = tf.lite.Interpreter(model_path="tf_files/sandwich.tflite")
  interpreter.allocate_tensors()

  # Get input and output tensors.
  input_details = interpreter.get_input_details()
  output_details = interpreter.get_output_details()
  print(input_details)
  print(output_details)

  img = Image.open(file_name)
  img = img.resize((224, 224))

  input_data = np.expand_dims(img, axis=0)

  if input_details[0]['dtype'] == type(np.float32(1.0)):
    floating_model = True
  
  if floating_model:
    input_data = (np.float32(input_data) - input_mean) / input_std

  interpreter.set_tensor(input_details[0]['index'], input_data)

  interpreter.invoke()
  results = interpreter.get_tensor(output_details[0]['index'])
  results = np.squeeze(results)
  print(results)
  top_k = results.argsort()[-5:][::-1]
  print(top_k)

if __name__ == "__main__":
  parser = argparse.ArgumentParser()
  parser.add_argument("--image", help="image to be processed")
  args = parser.parse_args()
  if args.image:
    file_name = args.image

  read_tensor_from_image_file(file_name)