FROM andrewosh/binder-base

MAINTAINER Michael Bright <dockerfiles@mjbright.net>

USER root

RUN pip install --upgrade pip

# ---- As advised here:
#    https://github.com/binder-project/binder/issues/50
RUN pip install jupyter_client

# ---- Install bash_kernel:
# Make sure not to create a cache dir else NB_UID switching
# will hit issues.
RUN pip install --no-cache-dir bash_kernel
RUN python -m bash_kernel.install

# ---- Clone my metakernel fork:
RUN mkdir -p ~/src/git && \
    cd ~/src/git && \
    git clone https://github.com/mjbright/metakernel

# ---- Install my metakernel fork:
#RUN pip install setuptools
RUN find ~/src/git/metakernel
RUN cd ~/src/git/metakernel                 && python ./setup.py install
RUN cd ~/src/git/metakernel/metakernel_bash && python ./setup.py install

# ---- Install RISE extension:
RUN mkdir -p ~/src/git && \
    cd ~/src/git && \
    git clone https://github.com/damianavila/RISE && \
    cd RISE && \
    python setup.py install

# ---- Install nbextensions (so can install table-of-contents extension):
RUN cd ~/src/git && \
    git clone https://github.com/ipython-contrib/Ipython-notebook-extensions.git && \
    cd Ipython-notebook-extensions && \
    python setup.py install

# ---- Show installed kernels and python/pip versions:
RUN jupyter kernelspec list

USER main

