FROM    nvcr.io/nvidia/tritonserver:23.08-py3

WORKDIR /workspace

COPY ./model_repository ./model_repository

COPY ./requirements.txt ./

RUN apt-get update && pip install --upgrade pip setuptools

RUN pip install -r requirements.txt

EXPOSE  8000
