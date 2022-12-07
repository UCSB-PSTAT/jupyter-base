UCSB Jupyter Notebook base
=================

Base image for launching Jupyter notebooks via JupyterHub.  This is based on the [Jupyter upstream](https://hub.docker.com/r/jupyter/base-notebook) and adds features and libraries commonly used in data science lab courses at [UCSB](https://ucsb.edu) that make use of [Python](https://www.python.org/).  In addition, these builds also include updates to the base OS image as available at the time of build.

This repo produces the following images on Docker Hub:
* [ucsb/jupyter-base](https://hub.docker.com/r/ucsb/jupyter-base)
* [ucsb/scipy-base](https://hub.docker.com/r/ucsb/scipy-base)

Looking for RStudio support?  Check out our [RStudio base image](https://hub.docker.com/u/ucsb/rstudio-base).

## How to run

The most basic way to demo this locally: 

`podman -it -p8888:8888 ucsb/jupyter-base:latest`

In the stdout, there will be a link that includes a token that will allow you to login locally with a browser.  Common endpoints are /tree and /hub.

Generally, refer to [upstream documentation](https://jupyter-docker-stacks.readthedocs.io/en/latest/) for running these containers. These are also suitable images for deployment via [JupyterHub helm chart](https://zero-to-jupyterhub.readthedocs.io/en/latest/) or as a standalone deployment.

## How to build an image from this

In order to build a downstream image, the user should be first set to root, and then reset back once changes are complete:

```
FROM ucsb/jupyter-base:latest

USER root

# Add your changes here
RUN mamba install ...

USER $NB_USER
```

## Tags

`latest` - Periodically a Jupyter release version is tagged in the Containerfile and this tags tracks the most recent build against that particular version.  That version may get updated at least quarterly.

`weekly` - This tag is primarily for integration testing and tracks the upstream `latest` tag.  These images are generally built, tested, and updated weekly on Monday mornings (PDT time).

`v...` - The numbers in these tags represent a date and are effectively a snapshot of the `latest` tag as it was on that particular day.  

## Python Package List
Here's a periodically updated list of python packages that are available in this image.  Actual versions may be newer than shown here.
```
Package                       Version
----------------------------- -----------
alembic                       1.8.1
anyio                         3.6.1
argon2-cffi                   21.3.0
argon2-cffi-bindings          21.2.0
asttokens                     2.0.8
async-generator               1.10
attrs                         22.1.0
Babel                         2.10.3
backcall                      0.2.0
backports.functools-lru-cache 1.6.4
beautifulsoup4                4.11.1
bleach                        5.0.1
blinker                       1.5
brotlipy                      0.7.0
certifi                       2022.9.24
certipy                       0.1.3
cffi                          1.15.1
charset-normalizer            2.1.1
colorama                      0.4.5
conda                         22.9.0
conda-package-handling        1.9.0
contourpy                     1.0.6
cryptography                  38.0.4
cycler                        0.11.0
debugpy                       1.6.3
decorator                     5.1.1
defusedxml                    0.7.1
entrypoints                   0.4
executing                     1.1.1
fastjsonschema                2.16.2
flit_core                     3.7.1
fonttools                     4.38.0
greenlet                      1.1.3
idna                          3.4
importlib-metadata            4.11.4
importlib-resources           5.10.0
ipykernel                     6.16.0
ipython                       8.5.0
ipython-genutils              0.2.0
jedi                          0.18.1
Jinja2                        3.1.2
json5                         0.9.5
jsonschema                    4.16.0
jupyter_client                7.4.2
jupyter_core                  4.11.1
jupyter-server                1.21.0
jupyter-telemetry             0.1.0
jupyterhub                    3.0.0
jupyterlab                    3.4.8
jupyterlab-pygments           0.2.2
jupyterlab_server             2.15.2
kiwisolver                    1.4.4
libmambapy                    1.1.0
Mako                          1.2.3
mamba                         1.1.0
MarkupSafe                    2.1.1
matplotlib                    3.6.2
matplotlib-inline             0.1.6
mistune                       2.0.4
munkres                       1.1.4
nbclassic                     0.4.6
nbclient                      0.7.0
nbconvert                     7.2.1
nbformat                      5.7.0
nbgitpuller                   1.1.1
nest-asyncio                  1.5.6
notebook                      6.4.12
notebook-shim                 0.1.0
numpy                         1.23.5
oauthlib                      3.2.1
packaging                     21.3
pamela                        1.0.0
pandas                        1.5.2
pandocfilters                 1.5.0
parso                         0.8.3
pexpect                       4.8.0
pickleshare                   0.7.5
Pillow                        9.2.0
pip                           22.2.2
pkgutil_resolve_name          1.3.10
ply                           3.11
prometheus-client             0.14.1
prompt-toolkit                3.0.31
psutil                        5.9.2
ptyprocess                    0.7.0
pure-eval                     0.2.2
pycosat                       0.6.3
pycparser                     2.21
pycurl                        7.45.1
Pygments                      2.13.0
PyJWT                         2.5.0
pyOpenSSL                     22.1.0
pyparsing                     3.0.9
PyQt5                         5.15.7
PyQt5-sip                     12.11.0
pyrsistent                    0.18.1
PySocks                       1.7.1
python-dateutil               2.8.2
python-json-logger            2.0.1
pytz                          2022.4
pyzmq                         24.0.1
requests                      2.28.1
ruamel.yaml                   0.17.21
ruamel.yaml.clib              0.2.6
ruamel-yaml-conda             0.15.80
Send2Trash                    1.8.0
setuptools                    65.4.1
sip                           6.7.5
six                           1.16.0
sniffio                       1.3.0
soupsieve                     2.3.2.post1
SQLAlchemy                    1.4.41
stack-data                    0.5.1
terminado                     0.16.0
tinycss2                      1.1.1
toml                          0.10.2
tomli                         2.0.1
toolz                         0.12.0
tornado                       6.2
tqdm                          4.64.1
traitlets                     5.4.0
typing_extensions             4.4.0
unicodedata2                  15.0.0
urllib3                       1.26.11
wcwidth                       0.2.5
webencodings                  0.5.1
websocket-client              1.4.1
wheel                         0.37.1
zipp                          3.9.0
```
