# usage ./test_model.sh $IMAGE_PATH_HERE

python tf_files/label_image.py \
  --graph=tf_files/retrained_graph.pb \
  --image="$1"
