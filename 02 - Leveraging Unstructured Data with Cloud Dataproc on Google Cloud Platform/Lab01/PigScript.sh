cat pet-details.pig 

rmf /GroupedByType
x1 = load '/pet-details' using PigStorage(',') as (Type:chararray,Name:chararray,Breed:chararray,Color:chararray,Weight:int);
x2 = filter x1 by Type != 'Type';
x3 = foreach x2 generate Type, Name, Breed, Color, Weight, Weight / 2.24 as Kilos:float;
x4 = filter x3 by LOWER(Color) == 'black' or LOWER(Color) == 'white';
x5 = group x4 by Type;
store x5 into '/GroupedByType';


In line 'x1', the load statement in the application creates a schema on top of the HDFS data file. 
Lines 'x2' through 'x5' perform transformations on the data. 
And the last line stores the result in a folder called /GroupedByType in HDFS.



cat pet-details.txt 

Dog,Noir,Schnoodle,Black,21
Dog,Bree,MaltePoo,White,10
Dog,Pickles,Golden Retriever,Yellow,30
Dog,Sparky,Mutt,Gray,13
Cat,Tom,Alley,Yellow,11
Cat,Cleo,Siamese,Gray,22
Frog,Kermit,Bull,Green,1
Pig,Bacon,Pot Belly,Pink,30
Pig,Babe,Domestic,White,150
Dog,Rusty,Poodle,White,20

