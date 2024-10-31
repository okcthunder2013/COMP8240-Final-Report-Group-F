#!/bin/bash

# Create a timestamped log file for this run
LOG_FILE="experiment_$(date +%Y%m%d_%H%M%S).log"

# Start logging
exec > >(tee -a "$LOG_FILE") 2>&1

echo "===== Experiment Started at $(date) ====="

# Change directory to fastText version 0.9.2
cd fastText-0.9.2

# Download the Cooking StackExchange dataset and extract the contents
echo "Downloading and extracting Cooking StackExchange dataset"
wget https://dl.fbaipublicfiles.com/fasttext/data/cooking.stackexchange.tar.gz && tar xvzf cooking.stackexchange.tar.gz

# Display the first few lines of the dataset to inspect its content
echo "Inspecting dataset contents"
head cooking.stackexchange.txt

# Display the word, line, and byte counts of the dataset
echo "Counting words, lines, and bytes in dataset"
wc cooking.stackexchange.txt

# Split the dataset into training and validation sets
echo "Splitting dataset into training and validation sets"
head -n 12404 cooking.stackexchange.txt > cooking.train
tail -n 3000 cooking.stackexchange.txt > cooking.valid

echo "===== Original Classification Method ====="

# Train a supervised fastText model using the training dataset with a fixed seed for reproducibility
echo "Training original model with fixed seed"
./fasttext supervised -input cooking.train -output model_cooking -seed 123

# Evaluate the trained model using the validation dataset
echo "Evaluating original model"
orig_output=$(./fasttext test model_cooking.bin cooking.valid)
echo -e "Original Model Results:\n$orig_output\n"

echo "===== Preprocessing and Classification ====="

# Preprocess the dataset by:
# - Adding spaces around punctuation marks to separate them as individual tokens
# - Converting all text to lowercase for uniformity
echo "Preprocessing dataset for next model"
cat cooking.stackexchange.txt | \
    sed -e "s/\([.\!?,'/()]\)/ \1 /g" | \
    tr "[:upper:]" "[:lower:]" > cooking.preprocessed.txt

# Split the preprocessed dataset into training and validation sets
head -n 12404 cooking.preprocessed.txt > cooking.train
tail -n 3000 cooking.preprocessed.txt > cooking.valid

# Train a supervised fastText model on the preprocessed training dataset with a fixed seed
echo "Training preprocessed model with fixed seed"
./fasttext supervised -input cooking.train -output model_cooking -seed 123

# Evaluate the newly trained model using the preprocessed validation dataset
echo "Evaluating preprocessed model"
preproc_output=$(./fasttext test model_cooking.bin cooking.valid)
echo -e "Preprocessed Model Results:\n$preproc_output\n"

echo "===== Enhancements with Increased Epochs ====="

# Train the model with a higher number of epochs and fixed seed for reproducibility
echo "Training model with increased epochs (25) and fixed seed"
./fasttext supervised -input cooking.train -output model_cooking -epoch 25 -seed 123

# Evaluate the model trained with increased epochs
echo "Evaluating model with increased epochs"
epochs_output=$(./fasttext test model_cooking.bin cooking.valid)
echo -e "Increased Epochs Model Results:\n$epochs_output\n"

echo "===== Enhancements with Increased Learning Rate ====="

# Train the model with a higher learning rate
echo "Training model with increased learning rate (1.0)"
./fasttext supervised -input cooking.train -output model_cooking -lr 1.0 -seed 123

# Evaluate the model trained with an increased learning rate
echo "Evaluating model with increased learning rate"
lr_output=$(./fasttext test model_cooking.bin cooking.valid)
echo -e "Increased Learning Rate Model Results:\n$lr_output\n"

echo "===== Enhancements with Increased Learning Rate and Epochs ====="

# Combine higher learning rate (1.0) with increased epochs (25)
echo "Training model with increased learning rate (1.0) and epochs (25)"
./fasttext supervised -input cooking.train -output model_cooking -lr 1.0 -epoch 25 -seed 123

# Evaluate the combined enhanced model
echo "Evaluating combined model with increased learning rate and epochs"
combined_output=$(./fasttext test model_cooking.bin cooking.valid)
echo -e "Combined Learning Rate and Epochs Model Results:\n$combined_output\n"

echo "===== Enhancements with Bigrams ====="

# Further enhance the model by adding bigram features
echo "Training model with bigram features, increased learning rate, and epochs"
./fasttext supervised -input cooking.train -output model_cooking -lr 1.0 -epoch 25 -wordNgrams 2 -seed 123

# Evaluate the model with bigram features
echo "Evaluating model with bigram features"
bigram_output=$(./fasttext test model_cooking.bin cooking.valid)
echo -e "Bigram Model Results:\n$bigram_output\n"

echo "===== Final Enhancements with Multilabel Classification ====="

# Perform comprehensive preprocessing and model enhancements
echo "Training final enhanced model with multilabel classification parameters"
./fasttext supervised \
    -input cooking.train \
    -output model_cooking \
    -lr 0.5 \
    -epoch 25 \
    -wordNgrams 2 \
    -bucket 200000 \
    -dim 50 \
    -loss one-vs-all \
    -seed 123

# Evaluate the final enhanced model with multilabel classification
echo "Evaluating final enhanced model with multilabel classification"
final_output=$(./fasttext test model_cooking.bin cooking.valid -1 0.5)
echo -e "Final Enhanced Model Results with Multilabel Classification:\n$final_output\n"

echo "===== Experiment Ended at $(date) ====="
