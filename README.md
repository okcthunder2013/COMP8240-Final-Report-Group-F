# How to Run Code for COMP8240 Final Report - Group F - Wei Mi

This guide and repository were created by Wei Mi (Student ID: 48057371).

## 1. Initial Setup

To begin, open the GitHub Codespace associated with this repository, then navigate to the necessary directory by running:

```bash
$ cd fastText-0.9.2
```

## 2. Running the Code to Replicate Original Work

To replicate the original study, execute the following command:

```bash
$ ./replication_of_original_work.sh
```

The running log for this process is saved as `experiment_20241031_152554.log`. Your results should closely resemble those in my log.

## 3. Running the Code for the New Dataset (Subsection 3.1)

To run the code for the new dataset:

1. **Download the Dataset**: First, download `cleaned_data.json` from this repository.
2. **Preprocess in Google Colab**: Open and execute `tweet_preprocess.ipynb` in Google Colab. A T4 GPU is recommended to accelerate processing. This should generate the file `labeled_tweets.txt`, which matches the version in this repository.
3. **Upload Processed Data**: Upload `labeled_tweets.txt` to the Codespace VM, then run the following command:

   ```bash
   $ ./convert.sh
   ```

   This command will produce `labeled_tweets_preprocessed.txt`, matching the version uploaded to this repo.

4. **Run the Experiment**: Execute:

   ```bash
   $ ./tweet_dataset_wei.sh
   ```

The log for this run will be saved as `tweet_experiment_20241101_100923.log`, and your results should be similar to those in my log.

