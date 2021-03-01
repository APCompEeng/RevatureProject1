# RevatureProject1

## Project Description
Revatures Project 1's analysis consists of using Big Data tools to answer questions about datasets from Wikipedia. There are a series of basic analysis questions, answered using Hive, with the tools used varying depending on what the question required at the time. The output includes .hql files, which makes this analysis both repeatable and scalable

## Technologies Used
- Hive
- Scala 2.13
- GitHub
- HDFS
- YARN

## Features
List of features ready and TODOs for future development
4 .hql scripts that analyse
- Which Wikipedia article got the most traffic based on data pulled on January 20, 2021
- What English Wikipedia article has the largest fraction of its readers follow an internal link to another wikipedia article
- What series of wikipedia articles, starting with Hotel California, keeps the largest fraction of its readers clicking on internal links
- An example of an English wikipedia article that is relatively more popular in the UK (repeat for the US and Australia)
- How many users will see the average vandalized wikipedia page before the offending edit is reversed
- Run an analysis you find interesting on the wikipedia datasets we're using.
To-do list:
- Optimize partitions to better read from the database
- Clean up and seperate question 1-3 scripts

## Getting Started
- Copy the repo using ```git clone https://github.com/APCompEeng/RevatureProject1.git```
- Switch to your main Hadoop Directory and run 
```sbin/start-dfs.sh```
```sbin/start-yarn.sh```
- Initiate a hive server running ```hiveserver2```
- Connect to hiveserver and begin running queries
## Usage
To use this project simply run the queries to get their specific data, or edit and run the Hive Queries depending on what questions you wish to answer. Data files are uncommitted due to their size being over 100 MB, they will have to be redownloaded

## Contributors
Adam Pesch

An Explanation and Overview of the project, List of features implemented, Technologies used, How to set up / get started using it, Usage of the project, and License information.
