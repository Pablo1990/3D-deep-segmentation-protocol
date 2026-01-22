[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.15469937.svg)](https://zenodo.org/records/15469937)

# 3D deep segmentation protocol

Epithelial cells form diverse structures from squamous spherical organoids to densely packed pseudostratified tissues. Quantification of cellular properties in these contexts requires high-resolution deep imaging and computational techniques to achieve truthful three-dimensional (3D) structural features. Here, we describe a detailed step-by-step protocol for deep-learning-assisted cell segmentation to achieve accurate quantification of fluorescently labelled individual cells in 3D within live tissues.

We provide
- A [`jupyter notebook`](3D_deep_segmentation_protocol.ipynb) to explore how to obtain an accurate 3D segmentation from your images. It has detailed comments sections entailing: Initial segmentation using Cellpose; Automated tracking using TrackMate; Manual segmentation using napari; and refining the segmentation model in Cellpose.
- A [`Nextflow worflow`](nextflow/nextflow_pipeline.nf) for you to run seemingly the protocol as many times as you want. It contains the workflow exploiting `Nextflow` functionalities.

## Installation

### [`jupyter notebook`](3D_deep_segmentation_protocol.ipynb)

### [`Nextflow worflow`](nextflow/nextflow_pipeline.nf)

## Usage

### [`jupyter notebook`](3D_deep_segmentation_protocol.ipynb)

### [`Nextflow worflow`](nextflow/nextflow_pipeline.nf)

## Issues

If you encounter any problems, please [file an issue](issues) along with a detailed description.

## Citation

If you use this protocol in your research, please cite the following paper:

```bibtex
@article{Paci2025,
   author = {Giulia Paci and Pablo Vicente-Munuera and Inés Fernandez-Mosquera and Álvaro Miranda and Katherine Lau and Qingyang Zhang and Ricardo Barrientos and Yanlan Mao},
   doi = {10.1038/s44303-025-00099-7},
   issn = {2948-197X},
   issue = {1},
   journal = {npj Imaging},
   month = {9},
   pages = {40},
   title = {Single cell resolution 3D imaging and segmentation within intact live tissues},
   volume = {3},
   url = {https://www.nature.com/articles/s44303-025-00099-7},
   year = {2025}
}
```

and software:

```bibtex
@software{Vicente-Munuera_3D_Protocol,
  author       = {Pablo Vicente Munuera and
                  Paci, Giulia and
                  Mao, Yanlan},
  title        = {Pablo1990/3D-deep-segmentation-protocol},
  month        = may,
  year         = 2025,
  publisher    = {Zenodo},
  doi          = {10.5281/zenodo.15469937},
  url          = {https://doi.org/10.5281/zenodo.15469937},
  swhid        = {swh:1:dir:f057288ad80c902ae809e442560901e584ccd3d5
                   ;origin=https://doi.org/10.5281/zenodo.15469937;vi
                   sit=swh:1:snp:6d437220fc5d86720d83672b636564b7cc17
                   1e6b;anchor=swh:1:rel:4f42c0e32443a72f174c1c2166ba
                   68ff0b2e4e23;path=Pablo1990-3D-deep-segmentation-
                   protocol-f9da31a
                  },
}
```
