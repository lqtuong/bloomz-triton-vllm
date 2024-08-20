
**Model setup

```
model_repository/
|-- vllm
    |-- 1
    |   |-- model.py
    |-- config.pbtxt
    |-- vllm_engine_args.json
```

The vllm_engine_args.json file should contain the following:
```
{
    "model": "bigscience/bloomz-1b1",
    "disable_log_requests": "true"
}
```

**Server setup
Open a new terminal and build a new docker container image derived from tritonserver:23.09-py3
```
docker build -f Dockerfile -t tritonserver_vllm .
```
Start the Triton server
```
docker run -it --rm -p 8000:8000 -p 8001:8001 --shm-size=1G --ulimit memlock=-1 --ulimit stack=67108864 -v ${PWD}/model_repository:/models -w /model_repository tritonserver_vllm tritonserver --model-store=/model_repository
```
Client

Using HTTP request
```
curl -X POST http://localhost:8000/v2/models/vllm/generate \
--header 'Content-Type: application/json' \
--data-raw '{
  "input":[
    {
      "name": "TEXT", 
      "shape": [1],
      "datatype": "BYTES",
      "data":  ["Translate to English: Je t’aime."]
    },
    {
      "name": "STREAM", 
      "shape": [1],
      "datatype": "BOOL",
      "data":  [False]
    },
    {
      "name": "SAMPLING_PARAMETERS", 
      "shape": [1],
      "datatype": "BYTES",
      "data":  [{"temperature": "0.01", "top_p": "1.0", "top_k": 20, "max_tokens": 100}]
    }
    ]
  }'
```

Using gRPC

```
python3 -m pip install tritonclient[all]

python3 client.py
```
