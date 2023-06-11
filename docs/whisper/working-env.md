---
title: 'Setting the working environment'
---

- create conda env

- install python v < 3.11, > 3.7 (3.10)

- install Chocolatey (https://chocolatey.org/install)

- install ffmpeg

	> sudo apt update && sudo apt install ffmpeg

- install rust 

	> pip install setuptools-rust

- install [Youtube-dl](https://github.com/ytdl-org/youtube-dl) using:

	```
	sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
	sudo chmod a+rx /usr/local/bin/youtube-dl
	```


## · 🤗 Repositories
In order to create and mange 🤗 Repositories (datasets, for example) we need to install the huggingface_hub CLI and run the login command. Following [🤗 Docs](https://huggingface.co/docs/hub/repositories-getting-started), this can be done by just running these commands on our conda environment: 

```
conda install -c conda-forge huggingface_hub
huggingface-cli login
```

The `huggingface-cli login` command will ask us for a token, which is automatically generated in our account. We only have to follow the clear instructions that appear on the terminal. 


## · 🤗 Datasets library
Before we start creating our flamenco audio dataset, we need to setup the environment and install the appropriate packages. [Hugging Face (🤗) Datasets](https://huggingface.co/docs/datasets/index) is a library for easily accessing and sharing datasets.  It works on Python 3.7+. We will follow the [installation instructions](https://huggingface.co/docs/datasets/installation) provided in the 🤗 docs. 

We go for the `conda` option and install it on our whisper environment using:

```bash
conda install -c huggingface -c conda-forge datasets
```