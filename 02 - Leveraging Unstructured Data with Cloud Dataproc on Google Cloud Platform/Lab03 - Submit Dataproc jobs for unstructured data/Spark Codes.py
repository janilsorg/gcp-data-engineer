# Create a Spark RDD (Resilient Distributed Dataset) by reading the text file 
# from HDFS. Use the python type() function to identify the object type. 
# And use a built-in method for the object to count the number of lines.
lines = sc.textFile("/sampledata/sherlock-holmes.txt")
type(lines)
lines.count()
lines.take(15)


# Use a flatMap() spark transformation to split the sentences into words.
words =  lines.flatMap(lambda x: x.split(' '))
type(words)
words.count()
words.take(15)

# Use a spark map() transformation to create pairs. The first element in the pair is the word. 
# The second element of the pair is the number of characters (length) of the word.
pairs = words.map(lambda x: (x,len(x)))
type(pairs)
pairs.count()
pairs.take(5)

# The objective is to count the number of words of various lengths -- so how many words with 10 
# characters are used in the books. Modify the map() so that it creates pairs of word length, and '1' 
# for each instance. This is a common "column-oriented" method for counting instances in a parallelizable way.
pairs = words.map(lambda x: (len(x),1))
pairs.take(5)

# Use a parallelizable method (add) to accumulate the instances. The add function will be called 
# inside the Spark reduceByKey() transformation.
from operator import add
wordsize = pairs.reduceByKey(add)
type(wordsize)
wordsize.count()
wordsize.take(5)

# Convert the RDD into a Python object for easy output.
output = wordsize.collect()
type(output)
for (size,count) in output: print(size, count)


# What happened? Why is the list out of order? It is because the collect() action was parallelized, 
# and then the results were assembled. Use the Spark sortByKey() method to sort the pairs before 
# collecting them into a list
output = wordsize.sortByKey().collect()
for (size,count) in output: print(size, count)

# The following program recreates exactly what you did in the previous steps. At each step you 
# executed one Spark transformation on one RDD which returns results in a separate RDD.

''' 
 Spark doesn't perform operations immediately. It uses an approach called "lazy evaluation".
 There are two classes of operations: transformations and actions. A transformation takes one RDD as 
 input and generates another RDD as output. You can think of a transformation as a request. 
 It explains to Spark what you want done, but doesn't tell Spark how to do it.
 Actions like "collect", "count", or "take" produce a result, such as a number or a list.
 When Spark receives transformations, it stores them in a DAG (Directed Acyclic Graph) but doesn't 
 perform them at that time. When Spark receives an action it examines the transformations in the DAG and 
 the available resources (number of workers in the cluster), and creates pipelines to efficiently perform 
 the work
''' 

# In the previous steps, you issued an action after each transformation to see the intermediate results. 
# In the program below, the only action is "collect" at the end.
from operator import add
lines = sc.textFile("/sampledata/sherlock-holmes.txt")

words =  lines.flatMap(lambda x: x.split(' '))
pairs = words.map(lambda x: (len(x),1))
wordsize = pairs.reduceByKey(add)
output = wordsize.sortByKey().collect()


# To allow Spark to perform its magic, the program needs to build a chain of 
# transformations using the dot operator. When it is passed to Spark in this way, Spark understands 
# the multiple steps and that the results of one transformation are to be passed to the next transformation. 
# This allows Spark to organize the processing in any way it decides based on the resources available 
# in the cluster. So, while the above program is more readable, with "words", "pairs", and "wordsize" 
# called out, the following program does the same thing without naming the intermediate results. 
# They are functionally identical.
output2 =  lines
            .flatMap(lambda x: x.split(' '))
            .map(lambda x: (len(x),1))
            .reduceByKey(add)
            .sortByKey()
            .collect()
for (size, count) in output2: print(size, count)
