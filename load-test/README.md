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
      "model": "google/gemma-2-9b-it",
      "messages": [
        {"role": "user", "content": "What is Google DevFest Cloud Bangkok."}
      ],
      "temperature": 0.7
    }' | jq -r '.choices[].message.content' | sed 's/\\n/\n/g' | glow -
```