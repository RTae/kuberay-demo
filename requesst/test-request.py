import requests
import typer

def main(image_path: str, port: int=8000):
    url = f"http://127.0.0.1:{port}"
    files = {"image": open(image_path, "rb")}
    response = requests.post(url, files=files)
    print(response.text)

if __name__ == "__main__":
    typer.run(main)