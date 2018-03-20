# Pixel-wise Attentional Gating for Parsimonious Pixel Labeling

For paper, slides and poster, please refer to our [project page](http://www.ics.uci.edu/~skong2/PAG.html "pixel-attentional-gating")


![alt text](http://www.ics.uci.edu/~skong2/image/PAG_splashFigure.png "visualization")


To achieve parsimonious inference in per-pixel labeling tasks with a limited
computational budget, we propose a **Pixel-wise Attentional Gating** unit
(**PAG**) that learns to selectively process a subset of spatial
locations at each layer of a deep convolutional network.  PAG is a generic,
architecture-independent, problem-agnostic mechanism that can be readily
``plugged in'' to an existing model with fine-tuning.  We utilize PAG in two
ways: 1) learning spatially varying pooling fields that improve model
performance without the extra computation cost associated with multi-scale
pooling, and 2) learning a dynamic computation policy for each pixel to
decrease total computation while maintaining accuracy.


We extensively evaluate PAG on a variety of per-pixel labeling tasks, including
semantic segmentation, boundary detection, monocular depth and surface normal
estimation.  We demonstrate that PAG allows competitive or state-of-the-art
performance on these tasks.  Our experiments show that PAG learns dynamic
spatial allocation of computation over the input image which provides better
performance trade-offs compared to related approaches (e.g., truncating deep
models or dynamically skipping whole layers).  Generally, we observe PAG can
reduce computation by $10\%$ without noticeable loss in accuracy and
performance degrades gracefully when imposing stronger computational constraints.

**keywords** Spatial Attention, Dynamic Computation, Per-Pixel Labeling, Semantic
Segmentation, Monocular Depth, Surface Normal, Boundary Detection.



MatConvNet is used in our project, and some functions are changed/added. Please compile accordingly by adjusting the path --

```python
LD_LIBRARY_PATH=/usr/local/cuda/lib64:local matlab 

path_to_matconvnet = './libs/matconvnet-1.0-beta23_modifiedDagnn/';
run(fullfile(path_to_matconvnet, 'matlab', 'vl_setupnn'));
addpath(fullfile(path_to_matconvnet, 'matlab'));
vl_compilenn('enableGpu', true, ...
               'cudaRoot', '/usr/local/cuda', ...
               'cudaMethod', 'nvcc', ...
               'enableCudnn', true, ...
               'cudnnRoot', '/usr/local/cuda/cudnn/lib64') ;

```


If you find our model/method/dataset useful, please cite our work ([draft at arxiv](https://arxiv.org/abs/XXXXXX)):

    @inproceedings{kong2018pag,
      title={Pixel-wise Attentional Gating for Parsimonious Pixel Labeling},
      author={Kong, Shu and Fowlkes, Charless},
      booktitle={arxiv},
      year={2018}
    }



last update: 03/13/2018

Shu Kong

aimerykong At g-m-a-i-l dot com

