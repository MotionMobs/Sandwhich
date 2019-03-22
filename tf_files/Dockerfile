FROM tensorflow/tensorflow:latest

RUN apt-get install -y python3-pip curl
RUN pip3 install -U pip
RUN pip3 install numpy tensorflow tensorflow_hub

RUN curl -O https://raw.githubusercontent.com/tensorflow/hub/master/examples/image_retraining/retrain.py
RUN curl -O https://raw.githubusercontent.com/tensorflow/tensorflow/master/tensorflow/examples/label_image/label_image.py

ENV IMAGE_SIZE 224
ENV OUTPUT_GRAPH tf_files/retrained_graph.pb
ENV OUTPUT_LABELS tf_files/retrained_labels.txt
ENV ARCHITECTURE mobilenet_0.50_${IMAGE_SIZE}
ENV TRAINING_STEPS 500
