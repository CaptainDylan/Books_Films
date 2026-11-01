# Read It or Watch It?

## Motivation

Given the number of movies that are sourced from pre-existing books, it is common for readers/movie viewers to ask the question: “Should I read the book, or should I watch the movie?”  Today, researching this question must be done manually, with many separate steps.  A prospective reader or movie viewer would visit individual movie and/or book review websites, Amazon reviews, and/or social media posts to get opinions on their path forward. 

This project includes topic analysis using the gensim library. It also includes other topic level comparisons such as comparing distance metrics of each set of all the book reviews vs the movie reviews after generating embeddings.

A new view is using BERTTopic to analyze the movie vs book reviews.

## Getting Started

These instructions will get you a copy of the Qlik Sense Dashboard and the additional Extensions used to get you up and running. 

## Prerequisites

### 1. Create a Qlik Sense Account and Download Qlik Sense

You will need to first create an account with Qlik to download Qlik Sense Desktop.

* If you are a professor or a student, take advantage of the Academic Program by [applying here.](https://www.qlik.com/us/company/academic-program)


* If you are not a student, just [register and download here.](https://www.qlik.com/us/try-or-buy/download-qlik-sense)

### 2. Install Qlik Sense Desktop

* While installing, be sure to include the Dashboard and Visualization bundles.


## TODO
There are several items to add to the analysis:

### 1. A UI based on javacript or something simple, not a Qlik package

### 2. A way to characterize the separation of a movie/book combo based on the set of embeddings. This could be SVM or something similar. The end metric would distinguish whether a movie is close to the book or not.

### 3. A BERTTopic analysis, added to the UI. It would analyze topic distribution between books vs movies.

### 4. Probing for semantic concepts. Create synthetic "theme vectors" and compare to each review. This would be used to find reviews that focus mroe on e.g. plot or character. It could also find similar books or movies.

### 5. An automatic embedding generation script for new reviews that don't have embeddings.

### 6. Differential TF-IDF (advanced option)

### 7. Fine tuning a model to do aspect based sentiment analysis (advanced option)

### 8. Identifying salient features using SHAP/LIME. Create a classifier model and use explainable techniques to identify important words or phrases (advanced option)

## License

This project is licensed under the Mozilla Public License 2.0. 

A copy of the license is included in the [LICENSE](LICENSE) file, or you can read it online at the [Official Mozilla MPL 2.0 Portal](https://mozilla.org).
