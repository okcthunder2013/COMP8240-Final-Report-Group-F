import pandas as pd

# Load the dataset
df = pd.read_csv('IMDB Dataset.csv')

# Preprocess and save in FastText format
df['review'] = df['review'].str.replace('\n', ' ').str.lower()  # Remove newlines and lowercase
df['label'] = df['sentiment'].apply(lambda x: '__label__' + x)
df['fasttext_format'] = df['label'] + ' ' + df['review']

# Split into train and test
df.sample(frac=0.8, random_state=42).to_csv('train.txt', columns=['fasttext_format'], index=False, header=False)
df.drop(df.sample(frac=0.8, random_state=42).index).to_csv('test.txt', columns=['fasttext_format'], index=False, header=False)
