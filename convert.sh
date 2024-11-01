#!/bin/bash

# Convert labeled_tweets.txt to FastText-compatible format by unifying label prefixes
cat labeled_tweets.txt | sed -e 's/__label_sentiment__\([a-z]*\) __label_topic__\([a-z]*\)/__label__\1 __label__\2/' > labeled_tweets_preprocessed.txt

echo "Converted labeled_tweets.txt to labeled_tweets_preprocessed.txt in the FastText-compatible format."
