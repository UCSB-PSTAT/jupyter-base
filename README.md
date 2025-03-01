UCSB Jupyter Notebook base
=================

Base image for launching Jupyter notebooks via JupyterHub.  This is based on the [Jupyter upstream](https://hub.docker.com/r/jupyter/base-notebook) and adds features and libraries commonly used in data science lab courses at [UCSB](https://ucsb.edu) that make use of [Python](https://www.python.org/).  In addition, these builds also include updates to the base OS image as available at the time of build.

This repo produces the following images on Docker Hub:
* [ucsb/jupyter-base](https://hub.docker.com/r/ucsb/jupyter-base)
* [ucsb/scipy-base](https://hub.docker.com/r/ucsb/scipy-base)
* [ucsb/pytorch-base](https://hub.docker.com/r/ucsb/pytorch-base)

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
Here's a periodically updated list of python packages that are available in the latest tag of the jupyter-base image.  Actual versions may be newer than shown here, especially the "weekly" tags.

To generate the actual current packages and versions as of right now: `podman run --rm -it --pull=Always ucsb/jupyter-base pip list --format=freeze` .  The same method works for scipy and downstream images. 

```
alembic==1.12.0
anyio==4.0.0
argon2-cffi==23.1.0
argon2-cffi-bindings==21.2.0
arrow==1.2.3
asttokens==2.4.0
async-generator==1.10
async-lru==2.0.4
attrs==23.1.0
Babel==2.12.1
backcall==0.2.0
backports.functools-lru-cache==1.6.5
beautifulsoup4==4.12.2
bleach==6.0.0
blinker==1.6.2
boltons==23.0.0
Brotli==1.1.0
cached-property==1.5.2
certifi==2023.7.22
certipy==0.1.3
cffi==1.15.1
charset-normalizer==3.2.0
colorama==0.4.6
comm==0.1.4
conda==23.7.4
conda-package-handling==2.2.0
conda_package_streaming==0.9.0
contourpy==1.1.1
cryptography==41.0.3
cycler==0.11.0
debugpy==1.8.0
decorator==5.1.1
defusedxml==0.7.1
entrypoints==0.4
exceptiongroup==1.1.3
executing==1.2.0
fastjsonschema==2.18.0
fonttools==4.42.1
fqdn==1.5.1
greenlet==2.0.2
idna==3.4
importlib-metadata==6.8.0
importlib-resources==6.0.1
ipykernel==6.25.2
ipython==8.15.0
ipython-genutils==0.2.0
isoduration==20.11.0
jedi==0.19.0
Jinja2==3.1.2
json5==0.9.14
jsonpatch==1.32
jsonpointer==2.4
jsonschema==4.19.0
jsonschema-specifications==2023.7.1
jupyter_client==8.3.1
jupyter_core==5.3.1
jupyter-events==0.7.0
jupyter-lsp==2.2.0
jupyter_server==2.7.3
jupyter_server_terminals==0.4.4
jupyter-telemetry==0.1.0
jupyterhub==4.0.2
jupyterlab==4.0.6
jupyterlab-pygments==0.2.2
jupyterlab_server==2.25.0
jupyterthemes==0.20.0
kiwisolver==1.4.5
lesscpy==0.15.1
libmambapy==1.5.1
Mako==1.2.4
mamba==1.5.1
MarkupSafe==2.1.3
matplotlib==3.8.0
matplotlib-inline==0.1.6
mistune==3.0.1
munkres==1.1.4
nbclassic==1.0.0
nbclient==0.8.0
nbconvert==7.8.0
nbformat==5.9.2
nbgitpuller==1.2.0
nest-asyncio==1.5.6
notebook==7.0.3
notebook_shim==0.2.3
numpy==1.26.0
oauthlib==3.2.2
overrides==7.4.0
packaging==23.1
pamela==1.1.0
pandas==2.1.1
pandocfilters==1.5.0
parso==0.8.3
pexpect==4.8.0
pickleshare==0.7.5
Pillow==10.0.1
pip==23.2.1
pkgutil_resolve_name==1.3.10
platformdirs==3.10.0
pluggy==1.3.0
ply==3.11
prometheus-client==0.17.1
prompt-toolkit==3.0.39
psutil==5.9.5
ptyprocess==0.7.0
pure-eval==0.2.2
pycosat==0.6.4
pycparser==2.21
pycurl==7.45.1
Pygments==2.16.1
PyJWT==2.8.0
pyOpenSSL==23.2.0
pyparsing==3.1.1
PyQt5==5.15.9
PyQt5-sip==12.12.2
PySocks==1.7.1
python-dateutil==2.8.2
python-json-logger==2.0.7
pytz==2023.3.post1
PyYAML==6.0.1
pyzmq==25.1.1
referencing==0.30.2
requests==2.31.0
rfc3339-validator==0.1.4
rfc3986-validator==0.1.1
rpds-py==0.10.3
ruamel.yaml==0.17.32
ruamel.yaml.clib==0.2.7
Send2Trash==1.8.2
setuptools==68.2.2
sip==6.7.11
six==1.16.0
sniffio==1.3.0
soupsieve==2.5
SQLAlchemy==2.0.20
stack-data==0.6.2
terminado==0.17.1
tinycss2==1.2.1
toml==0.10.2
tomli==2.0.1
toolz==0.12.0
tornado==6.3.3
tqdm==4.66.1
traitlets==5.10.0
typing_extensions==4.8.0
typing-utils==0.1.0
tzdata==2023.3
uri-template==1.3.0
urllib3==2.0.4
wcwidth==0.2.6
webcolors==1.13
webencodings==0.5.1
websocket-client==1.6.3
wheel==0.41.2
zipp==3.16.2
zstandard==0.21.0
```
