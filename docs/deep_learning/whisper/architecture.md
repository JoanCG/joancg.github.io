---
title: 'Architecture'
---

# Introduction

The Whisper Model is a language model that uses unsupervised learning to generate coherent and diverse sentences. It is designed to address some of the limitations of existing language models, such as their tendency to generate repetitive or generic text. The Whisper Model achieves this by using a combination of techniques, including a novel training objective that encourages diversity in the generated text. Overall, the Whisper Model has shown promising results in generating high-quality text and has the potential to be useful in a wide range of applications, such as chatbots, language translation, and content generation.  


## Whisper architecture  

The model uses a novel attention mechanism called "masked sparse self-attention" which allows it to focus only on relevant parts of the input sequence, reducing the number of computations required. It also employs quantization techniques to reduce the precision of weights and activations, further reducing the computational cost.

Additionally, the model uses knowledge distillation, a technique where a smaller student model is trained to mimic the behavior of a larger teacher model. This approach helps to improve the efficiency of the model without sacrificing accuracy.

## Ofered by OpenAI

The Whisper Model is a language model developed by OpenAI that uses sparse attention mechanisms to improve efficiency and reduce computation while still maintaining high accuracy. The architecture of the model is based on a combination of techniques such as sparsity, quantization, and knowledge distillation.

The model uses a novel attention mechanism called "masked sparse self-attention" which allows it to focus only on relevant parts of the input sequence, reducing the number of computations required. It also employs quantization techniques to reduce the precision of weights and activations, further reducing the computational cost.

!!! note

    This is an experimental build, it is an ongoing process and by any means can 
    be considered finished. With that said, all positive feedback is appreciated. 

<br>

# Remarks
Overall, the Whisper Model is an impressive achievement in the field of natural language processing that demonstrates how advanced techniques can be combined to create highly efficient and accurate models.