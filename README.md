# arturh85/plutolab

Datascience Stack based on docker-stacks excellent [SciPy-Notebook](https://github.com/jupyter/docker-stacks/tree/master/scipy-notebook) with:

- [Jupyter Lab 3](https://jupyterlab.readthedocs.io/en/stable/)
- [Julia 1.6.1](https://julialang.org/) & [Pluto](https://plutojl.org/)
- [Detectron 2](https://www.dlology.com/blog/how-to-train-detectron2-with-custom-coco-datasets/) & [OpenCV](https://opencv.org/)
- [TensorFlow 2.4.1](https://www.tensorflow.org/) & [Keras](https://keras.io/)
- [Pytorch 1.8.1](https://pytorch.org/) & [Torchvision](https://pytorch.org/vision/stable/index.html)
- [ArrayFire](https://arrayfire.org/docs/index.htm)

# Howto start docker container

Start Jupyter Lab 

    docker run --rm --gpus all -p 8888:8888 -v /path/to/workspace:/home/jovyan/workspace arturh85/plutolab:latest
