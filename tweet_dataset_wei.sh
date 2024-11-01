#!/bin/bash

# Create a timestamped log file for this run
LOG_FILE="tweet_experiment_$(date +%Y%m%d_%H%M%S).log"

# Start logging
exec > >(tee -a "$LOG_FILE") 2>&1

echo "===== Tweet Experiment Started at $(date) ====="

# Display the first few lines of labeled_tweets_preprocessed.txt for inspection
echo "Inspecting labeled tweets content"
head labeled_tweets_preprocessed.txt

# Count words, lines, and bytes in labeled tweets
echo "Counting words, lines, and bytes in labeled_tweets_preprocessed.txt"
wc labeled_tweets_preprocessed.txt

# Split the labeled tweets into training and validation sets
echo "Splitting labeled tweets into training and validation sets"
head -n 9000 labeled_tweets_preprocessed.txt > tweets.train
tail -n 1000 labeled_tweets_preprocessed.txt > tweets.valid

echo "===== Raw Model Training and Evaluation ====="

# Train a supervised fastText model on the raw training data with a fixed seed
echo "Training raw model"
./fasttext supervised -input tweets.train -output model_tweet_raw -seed 123

# Evaluate the raw model
echo "Evaluating raw model"
raw_output=$(./fasttext test model_tweet_raw.bin tweets.valid)
echo -e "Raw Model Results:\n$raw_output\n"

echo "===== Preprocessed Model Training and Evaluation ====="

# Preprocess the data by separating punctuation and converting to lowercase
echo "Preprocessing tweets"
cat labeled_tweets_preprocessed.txt | \
    sed -e "s/\([.\!?,'/()]\)/ \1 /g" | \
    tr "[:upper:]" "[:lower:]" > tweets_preprocessed_final.txt

# Split the final preprocessed dataset
head -n 9000 tweets_preprocessed_final.txt > tweets.train
tail -n 1000 tweets_preprocessed_final.txt > tweets.valid

# Train a model on preprocessed data
echo "Training preprocessed model"
./fasttext supervised -input tweets.train -output model_tweet_preproc -seed 123

# Evaluate the preprocessed model
echo "Evaluating preprocessed model"
preproc_output=$(./fasttext test model_tweet_preproc.bin tweets.valid)
echo -e "Preprocessed Model Results:\n$preproc_output\n"

echo "===== Model with Increased Epochs ====="

# Train a model with increased epochs
echo "Training model with increased epochs (25)"
./fasttext supervised -input tweets.train -output model_tweet_epoch -epoch 25 -seed 123

# Evaluate model with increased epochs
echo "Evaluating model with increased epochs"
epoch_output=$(./fasttext test model_tweet_epoch.bin tweets.valid)
echo -e "Epoch Model Results:\n$epoch_output\n"

echo "===== Model with Increased Learning Rate ====="

# Train model with a higher learning rate
echo "Training model with learning rate (1.0)"
./fasttext supervised -input tweets.train -output model_tweet_lr -lr 1.0 -seed 123

# Evaluate model with increased learning rate
echo "Evaluating model with increased learning rate"
lr_output=$(./fasttext test model_tweet_lr.bin tweets.valid)
echo -e "Learning Rate Model Results:\n$lr_output\n"

echo "===== Combined Model with Increased Learning Rate and Epochs ====="

# Combine increased learning rate and epochs
echo "Training model with learning rate (1.0) and epochs (25)"
./fasttext supervised -input tweets.train -output model_tweet_combined -lr 1.0 -epoch 25 -seed 123

# Evaluate combined model
echo "Evaluating combined model"
combined_output=$(./fasttext test model_tweet_combined.bin tweets.valid)
echo -e "Combined Model Results:\n$combined_output\n"

echo "===== Model with Bigrams and Enhanced Parameters ====="

# Train model with bigram features, increased learning rate, and epochs
echo "Training model with bigrams and enhanced parameters"
./fasttext supervised -input tweets.train -output model_tweet_bigram -lr 1.0 -epoch 25 -wordNgrams 2 -seed 123

# Evaluate bigram model
echo "Evaluating bigram model"
bigram_output=$(./fasttext test model_tweet_bigram.bin tweets.valid)
echo -e "Bigram Model Results:\n$bigram_output\n"

echo "===== Final Model with Multilabel Classification ====="

# Train final enhanced model with multilabel classification settings
echo "Training final model with multilabel classification"
./fasttext supervised \
    -input tweets.train \
    -output model_tweet_final \
    -lr 0.5 \
    -epoch 25 \
    -wordNgrams 2 \
    -bucket 200000 \
    -dim 50 \
    -loss one-vs-all \
    -seed 123

# Evaluate final model with multilabel classification
echo "Evaluating final enhanced model with multilabel classification"
final_output=$(./fasttext test model_tweet_final.bin tweets.valid -1 0.5)
echo -e "Final Enhanced Model Results with Multilabel Classification:\n$final_output\n"

echo "===== Tweet Experiment Ended at $(date) ====="

