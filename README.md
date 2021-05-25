# arturh85/plutolab

Datascience Stack based on docker-stacks excellent [SciPy-Notebook](https://github.com/jupyter/docker-stacks/tree/master/scipy-notebook) with:

- [Jupyter Lab 3](https://jupyterlab.readthedocs.io/en/stable/)
    - Languages: [Julia](https://julialang.org/), [Python](https://www.python.org/), [Rust](https://www.rust-lang.org/), [C#](https://code.visualstudio.com/docs/languages/csharp), [F#](https://fsharp.org/), [PowerShell](https://docs.microsoft.com/en-us/powershell/), [R](https://www.r-project.org/), [SQL](https://en.wikipedia.org/wiki/SQL), [Groovy](https://groovy-lang.org/), [Scala](https://www.scala-lang.org/), [Kotlin](https://kotlinlang.org/), [Clojure](https://clojure.org/), [Java](https://www.java.com/)
    - [BeakerX](http://beakerx.com/)
    - [Elyra AI Extensions](https://github.com/elyra-ai/elyra)
    - [DrawIO](https://github.com/jgraph/drawio)
- [Pluto Notebooks](https://plutojl.org/) (Julia based)
- [Detectron 2](https://www.dlology.com/blog/how-to-train-detectron2-with-custom-coco-datasets/) & [OpenCV](https://opencv.org/)
- [TensorFlow 2.4.1](https://www.tensorflow.org/) & [Keras](https://keras.io/)
- [Pytorch 1.8.1](https://pytorch.org/) & [Torchvision](https://pytorch.org/vision/stable/index.html)
- [ArrayFire](https://arrayfire.org/docs/index.htm)

## Requirements

- [nvidia-docker](https://github.com/NVIDIA/nvidia-docker) (for CUDA support)

## Start as docker container


    docker run --rm --gpus all -p 8888:8888 -v /path/to/workspace:/home/jovyan/workspace arturh85/plutolab:latest
