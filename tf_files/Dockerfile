FROM tensorflow/tensorflow:latest

RUN apt-get install -y python3-pip
RUN pip3 install -U pip
RUN pip3 install numpy tensorflow tensorflow_hub

ENV IMAGE_SIZE 224
ENV OUTPUT_GRAPH tf_files/retrained_graph.pb
ENV OUTPUT_LABELS tf_files/retrained_labels.txt
ENV ARCHITECTURE mobilenet_0.50_${IMAGE_SIZE}
ENV TRAINING_STEPS 500