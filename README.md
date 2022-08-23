UCSB Jupyter Notebook base
=================

Base image for launching Jupyter notebooks via JupyterHub.  This is based on the [Jupyter upstream](https://hub.docker.com/r/jupyter/base-notebook) and adds features and libraries commonly used in data science lab courses at [UCSB](https://ucsb.edu) that make use of [Python](https://www.python.org/).  In addition, these builds also include updates to the base OS image as available at the time of build.

This repo produces the following images on Docker Hub:
* [ucsb/jupyter-base](https://hub.docker.com/r/ucsb/jupyter-base)
* [ucsb/scipy-base](https://hub.docker.com/r/ucsb/scipy-base)

Looking for RStudio support?  Check out our [RStudio base image](https://hub.docker.com/u/ucsb/rstudio-base).

## Python Package List
Here's a list of python packages that are available in this image:
```
alembic @ file:///home/conda/feedstock_root/build_artifacts/alembic_1654060492067/work
anyio @ file:///home/conda/feedstock_root/build_artifacts/anyio_1652463865103/work/dist
argon2-cffi @ file:///home/conda/feedstock_root/build_artifacts/argon2-cffi_1640817743617/work
argon2-cffi-bindings @ file:///home/conda/feedstock_root/build_artifacts/argon2-cffi-bindings_1649500328244/work
asttokens @ file:///home/conda/feedstock_root/build_artifacts/asttokens_1618968359944/work
async-generator==1.10
attrs @ file:///home/conda/feedstock_root/build_artifacts/attrs_1640799537051/work
Babel @ file:///home/conda/feedstock_root/build_artifacts/babel_1651737115240/work
backcall @ file:///home/conda/feedstock_root/build_artifacts/backcall_1592338393461/work
backports.functools-lru-cache @ file:///home/conda/feedstock_root/build_artifacts/backports.functools_lru_cache_1618230623929/work
beautifulsoup4 @ file:///home/conda/feedstock_root/build_artifacts/beautifulsoup4_1649463573192/work
bleach @ file:///home/conda/feedstock_root/build_artifacts/bleach_1649361991009/work
blinker==1.4
brotlipy @ file:///home/conda/feedstock_root/build_artifacts/brotlipy_1648854167867/work
certifi==2022.6.15
certipy==0.1.3
cffi @ file:///home/conda/feedstock_root/build_artifacts/cffi_1636046050867/work
charset-normalizer @ file:///home/conda/feedstock_root/build_artifacts/charset-normalizer_1644853463426/work
colorama @ file:///home/conda/feedstock_root/build_artifacts/colorama_1602866480661/work
conda==4.12.0
conda-package-handling @ file:///home/conda/feedstock_root/build_artifacts/conda-package-handling_1649385045972/work
cryptography @ file:///home/conda/feedstock_root/build_artifacts/cryptography_1652967019182/work
cycler @ file:///home/conda/feedstock_root/build_artifacts/cycler_1635519461629/work
debugpy @ file:///home/conda/feedstock_root/build_artifacts/debugpy_1649586344343/work
decorator @ file:///home/conda/feedstock_root/build_artifacts/decorator_1641555617451/work
defusedxml @ file:///home/conda/feedstock_root/build_artifacts/defusedxml_1615232257335/work
entrypoints @ file:///home/conda/feedstock_root/build_artifacts/entrypoints_1643888246732/work
executing @ file:///home/conda/feedstock_root/build_artifacts/executing_1646044401614/work
fastjsonschema @ file:///home/conda/feedstock_root/build_artifacts/python-fastjsonschema_1641751198313/work/dist
flit_core @ file:///home/conda/feedstock_root/build_artifacts/flit-core_1645629044586/work/source/flit_core
fonttools @ file:///home/conda/feedstock_root/build_artifacts/fonttools_1657249373943/work
greenlet @ file:///home/conda/feedstock_root/build_artifacts/greenlet_1648882383677/work
idna @ file:///home/conda/feedstock_root/build_artifacts/idna_1642433548627/work
importlib-metadata @ file:///home/conda/feedstock_root/build_artifacts/importlib-metadata_1653252803161/work
importlib-resources @ file:///home/conda/feedstock_root/build_artifacts/importlib_resources_1652715758048/work
ipykernel @ file:///home/conda/feedstock_root/build_artifacts/ipykernel_1649684271090/work/dist/ipykernel-6.13.0-py3-none-any.whl
ipython @ file:///home/conda/feedstock_root/build_artifacts/ipython_1653754916420/work
ipython-genutils==0.2.0
jedi @ file:///home/conda/feedstock_root/build_artifacts/jedi_1649067100958/work
Jinja2 @ file:///home/conda/feedstock_root/build_artifacts/jinja2_1654302431367/work
json5 @ file:///home/conda/feedstock_root/build_artifacts/json5_1600692310011/work
jsonschema @ file:///home/conda/feedstock_root/build_artifacts/jsonschema-meta_1654138136460/work
jupyter-client @ file:///home/conda/feedstock_root/build_artifacts/jupyter_client_1652061014773/work
jupyter-core @ file:///home/conda/feedstock_root/build_artifacts/jupyter_core_1652365243968/work
jupyter-server @ file:///home/conda/feedstock_root/build_artifacts/jupyter_server_1651092495905/work
jupyter-telemetry @ file:///home/conda/feedstock_root/build_artifacts/jupyter_telemetry_1605173804246/work
jupyterhub @ file:///home/conda/feedstock_root/build_artifacts/jupyterhub-feedstock_1651846799684/work
jupyterlab @ file:///home/conda/feedstock_root/build_artifacts/jupyterlab_1652407772753/work
jupyterlab-pygments @ file:///home/conda/feedstock_root/build_artifacts/jupyterlab_pygments_1649936611996/work
jupyterlab-server @ file:///home/conda/feedstock_root/build_artifacts/jupyterlab_server_1652878309867/work
kiwisolver @ file:///home/conda/feedstock_root/build_artifacts/kiwisolver_1657953096987/work
libmambapy @ file:///home/conda/feedstock_root/build_artifacts/mamba-split_1654091934149/work/libmambapy
Mako @ file:///home/conda/feedstock_root/build_artifacts/mako_1649097013621/work
mamba @ file:///home/conda/feedstock_root/build_artifacts/mamba-split_1654091934149/work/mamba
MarkupSafe @ file:///home/conda/feedstock_root/build_artifacts/markupsafe_1648737547956/work
matplotlib @ file:///home/conda/feedstock_root/build_artifacts/matplotlib-suite_1659031533513/work
matplotlib-inline @ file:///home/conda/feedstock_root/build_artifacts/matplotlib-inline_1631080358261/work
mistune @ file:///home/conda/feedstock_root/build_artifacts/mistune_1635844663025/work
munkres==1.1.4
nbclassic @ file:///home/conda/feedstock_root/build_artifacts/nbclassic_1647450696711/work
nbclient @ file:///home/conda/feedstock_root/build_artifacts/nbclient_1654071785565/work
nbconvert @ file:///home/conda/feedstock_root/build_artifacts/nbconvert-meta_1649676641343/work
nbformat @ file:///home/conda/feedstock_root/build_artifacts/nbformat_1651607001005/work
nbgitpuller==1.1.0
nest-asyncio @ file:///home/conda/feedstock_root/build_artifacts/nest-asyncio_1648959695634/work
notebook @ file:///home/conda/feedstock_root/build_artifacts/notebook_1650363291341/work
notebook-shim @ file:///home/conda/feedstock_root/build_artifacts/notebook-shim_1646330736330/work
numpy @ file:///home/conda/feedstock_root/build_artifacts/numpy_1657483876890/work
oauthlib @ file:///home/conda/feedstock_root/build_artifacts/oauthlib_1643507977997/work
packaging @ file:///home/conda/feedstock_root/build_artifacts/packaging_1637239678211/work
pamela==1.0.0
pandas==1.4.3
pandocfilters @ file:///home/conda/feedstock_root/build_artifacts/pandocfilters_1631603243851/work
parso @ file:///home/conda/feedstock_root/build_artifacts/parso_1638334955874/work
pexpect @ file:///home/conda/feedstock_root/build_artifacts/pexpect_1602535608087/work
pickleshare @ file:///home/conda/feedstock_root/build_artifacts/pickleshare_1602536217715/work
Pillow @ file:///home/conda/feedstock_root/build_artifacts/pillow_1657007160045/work
ply==3.11
prometheus-client @ file:///home/conda/feedstock_root/build_artifacts/prometheus_client_1649447152425/work
prompt-toolkit @ file:///home/conda/feedstock_root/build_artifacts/prompt-toolkit_1649130487073/work
psutil @ file:///home/conda/feedstock_root/build_artifacts/psutil_1653089181607/work
ptyprocess @ file:///home/conda/feedstock_root/build_artifacts/ptyprocess_1609419310487/work/dist/ptyprocess-0.7.0-py2.py3-none-any.whl
pure-eval @ file:///home/conda/feedstock_root/build_artifacts/pure_eval_1642875951954/work
pycosat @ file:///home/conda/feedstock_root/build_artifacts/pycosat_1649384799612/work
pycparser @ file:///home/conda/feedstock_root/build_artifacts/pycparser_1636257122734/work
pycurl==7.45.1
Pygments @ file:///home/conda/feedstock_root/build_artifacts/pygments_1650904496387/work
PyJWT @ file:///home/conda/feedstock_root/build_artifacts/pyjwt_1652398519695/work
pyOpenSSL @ file:///home/conda/feedstock_root/build_artifacts/pyopenssl_1643496850550/work
pyparsing @ file:///home/conda/feedstock_root/build_artifacts/pyparsing_1652235407899/work
PyQt5==5.15.7
PyQt5-sip==12.11.0
pyrsistent @ file:///home/conda/feedstock_root/build_artifacts/pyrsistent_1649013351988/work
PySocks @ file:///home/conda/feedstock_root/build_artifacts/pysocks_1648857264958/work
python-dateutil @ file:///home/conda/feedstock_root/build_artifacts/python-dateutil_1626286286081/work
python-json-logger @ file:///home/conda/feedstock_root/build_artifacts/python-json-logger_1602545356084/work
pytz @ file:///home/conda/feedstock_root/build_artifacts/pytz_1647961439546/work
pyzmq @ file:///home/conda/feedstock_root/build_artifacts/pyzmq_1654181424192/work
requests @ file:///home/conda/feedstock_root/build_artifacts/requests_1641580202195/work
ruamel-yaml-conda @ file:///home/conda/feedstock_root/build_artifacts/ruamel_yaml_1653464396679/work
ruamel.yaml @ file:///home/conda/feedstock_root/build_artifacts/ruamel.yaml_1649033201098/work
ruamel.yaml.clib @ file:///home/conda/feedstock_root/build_artifacts/ruamel.yaml.clib_1649013063403/work
Send2Trash @ file:///home/conda/feedstock_root/build_artifacts/send2trash_1628511208346/work
sip @ file:///home/conda/feedstock_root/build_artifacts/sip_1655764888637/work
six @ file:///home/conda/feedstock_root/build_artifacts/six_1620240208055/work
sniffio @ file:///home/conda/feedstock_root/build_artifacts/sniffio_1648819179288/work
soupsieve @ file:///home/conda/feedstock_root/build_artifacts/soupsieve_1638550740809/work
SQLAlchemy @ file:///home/conda/feedstock_root/build_artifacts/sqlalchemy_1654061526482/work
stack-data @ file:///home/conda/feedstock_root/build_artifacts/stack_data_1644872665635/work
terminado @ file:///home/conda/feedstock_root/build_artifacts/terminado_1652790610172/work
tinycss2 @ file:///home/conda/feedstock_root/build_artifacts/tinycss2_1637612658783/work
toml @ file:///home/conda/feedstock_root/build_artifacts/toml_1604308577558/work
tornado @ file:///home/conda/feedstock_root/build_artifacts/tornado_1648827254365/work
tqdm @ file:///home/conda/feedstock_root/build_artifacts/tqdm_1649051611147/work
traitlets @ file:///home/conda/feedstock_root/build_artifacts/traitlets_1654067514780/work
unicodedata2 @ file:///home/conda/feedstock_root/build_artifacts/unicodedata2_1649111910890/work
urllib3 @ file:///home/conda/feedstock_root/build_artifacts/urllib3_1647489083693/work
wcwidth @ file:///home/conda/feedstock_root/build_artifacts/wcwidth_1600965781394/work
webencodings==0.5.1
websocket-client @ file:///home/conda/feedstock_root/build_artifacts/websocket-client_1648562593984/work
zipp @ file:///home/conda/feedstock_root/build_artifacts/zipp_1649012893348/work
```

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
