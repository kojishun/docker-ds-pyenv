FROM ubuntu:latest
RUN apt-get update && apt-get install -y \
    software-properties-common \
    tzdata && \
    apt-add-repository -y ppa:git-core/ppa && \
    apt-get update && \
    apt-get install -y \
    sudo \
    wget \
    curl \
    git \
    vim \
    make \
    wget \
    llvm \
    gcc \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libncurses5-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev \
    libncurses5-dev \
    libproj-dev \
    libgeos-dev \
    proj-data \
    proj-bin \
    xz-utils \
    tk-dev \
    mecab \
    libmecab-dev \
    mecab-ipadic \
    mecab-ipadic-utf8 \
    libc6-dev \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libglib2.0-0 && \
    sudo curl -sL https://deb.nodesource.com/setup_12.x | sudo bash - && \
    sudo apt-get install -y nodejs
# NEologd辞書のインストール
RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git && \
    cd mecab-ipadic-neologd && \
    ./bin/install-mecab-ipadic-neologd -n -y && \
    sudo cp /etc/mecabrc /usr/local/etc/
# pyenvとvirtualenvをインストール
RUN git clone https://github.com/yyuu/pyenv.git ~/.pyenv && \
    git clone https://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv && \
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc && \
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc && \
    echo 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bashrc
ENV PATH $PATH:/root/.pyenv/bin
# pyenv経由でpythonをインストール
RUN pyenv install 3.8.3 && \
    pyenv global 3.8.3 && \
    pyenv rehash
ENV PATH $PATH:/root/.pyenv/shims
# パッケージインストール
RUN pip install --upgrade pip && pip install \
    autopep8 \
    beautifulsoup4 \
    Django \
    folium \
    ipython \
    janome \
    japanize-matplotlib \
    jupyter \
    jupyterlab \
    jupyterlab_code_formatter \
    jupyterlab-git \
    lxml \
    matplotlib \
    mecab-python3 \
    nibabel \
    nltk \
    numpy \
    opencv-python \
    pandas \
    plotly \
    pymysql \
    requests \
    s3fs \
    scikit-learn \
    scipy \
    seaborn \
    tqdm \
    tweepy \
    unidic-lite \
    wordcloud \
    xlrd 
# JupyterLabの拡張機能
RUN jupyter labextension install @lckr/jupyterlab_variableinspector && \
    jupyter labextension install @jupyterlab/toc && \
    jupyter labextension install @ryantam626/jupyterlab_code_formatter && \
    jupyter serverextension enable --py jupyterlab_code_formatter
RUN mkdir /work
CMD ["jupyter","lab","--ip=0.0.0.0","--allow-root","--no-browser","--LabApp.token=''"]