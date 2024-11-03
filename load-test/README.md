# Load Test

## Setup
```bash
poetry install
alias prp='poetry run python'
```

## Test Request
```bash
prp test-request.py ./golden_retriever.jpeg --port 49667
```


```bash
curl http://localhost:8000/v1/chat/completions -H "Content-Type: application/json" -d '{
      "model": "meta-llama/Llama-3.2-1B-Instruct",
      "messages": [
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "Provide a brief sentence describing the DevFest Cloud Bangkok."}
      ],
      "temperature": 0.7
    }'
```