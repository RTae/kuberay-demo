from transformers import pipeline
from typing import Dict
from PIL import Image
import numpy as np
import ray

class ImageClassifier:
    def __init__(self, batch_size = 16):
        self.classifier = pipeline("image-classification", model="google/vit-base-patch16-224", device=0)
        self.BATCH_SIZE = batch_size

    def __call__(self, batch: Dict[str, np.ndarray]):
        # Convert the numpy array of images into a list of PIL images which is the format the HF pipeline expects.
        outputs = self.classifier(
            [Image.fromarray(image_array) for image_array in batch["image"]],
            top_k=1,
            batch_size=self.BATCH_SIZE)

        # `outputs` is a list of length-one lists. For example:
        # [[{'score': '...', 'label': '...'}], ..., [{'score': '...', 'label': '...'}]]
        batch["score"] = [output[0]["score"] for output in outputs]
        batch["label"] = [output[0]["label"] for output in outputs]
        return batch

def prepare_for_output(batch):
    return {
        "score": batch["score"],
        "label": batch["label"],
        "path": batch["path"]
    }

if __name__ == "__main__":

    image_path = "/mnt/cluster_storage/03102024/"
    batch_size=16

    ds = ray.data.read_images(
        image_path, mode="RGB", include_paths=True
    )

    predictions = ds.map_batches(
        ImageClassifier,
        concurrency=1,
        num_gpus=1,
        batch_size=batch_size
    ).map_batches(
        prepare_for_output,
        concurrency=1,
        num_gpus=1,
        batch_size=batch_size
    )
    
    print("A few sample predictions: ")
    for row in predictions.iter_rows():
        print(row)