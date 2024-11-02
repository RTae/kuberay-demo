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

if __name__ == "__main__":

    s3_uri = "s3://anonymous@air-example-data-2/imagenette2/val/"

    ds = ray.data.read_images(
        s3_uri, mode="RGB"
    )

    predictions = ds.map_batches(
        ImageClassifier,
        compute=ray.data.ActorPoolStrategy(size=1), # Change this number based on the number of GPUs in your cluster.
        num_gpus=1, # Specify 1 GPU per model replica.
        batch_size=16 # Use the largest batch size that can fit on our GPUs
    )
    prediction_batch = predictions.take_batch(5)
    print("A few sample predictions: ")
    for prediction in prediction_batch["label"]:
        print("Label: ", prediction)