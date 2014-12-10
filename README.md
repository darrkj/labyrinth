# mazewalker

![alt text](labyrinth.png)

Package to compute netowrk parameters




I have been playing around lately with [neo4j mazerunner](https://github.com/kbastani/neo4j-mazerunner) project, the handy work of [@kennybastani](https://twitter.com/kennybastani). I think that the capabilities are very cool. They utilize [Neo4j](), [Docker]() and [GraphX]() for each of there strengths. I can see why having it setup as an unmanaged extension is desirable for certain use cases. Other times though this can be a bit much, especially if the data is of smaller scale. I have created something similar using [igraph]().

You first need the newest version of RNeo4j.


```
devtools::install_github("darrkj/labyrinth")

require(labyrinth)

# Create connection to graph database
graph <- startGraph("http://localhost:7474/db/data/")
```


This will add the commonly known Karate data to Neo4j

```{r}
require(igraphdata)
data(karate)

ingest(karate, 'knows')
```


```{r}
data <- cypher(graph, 'match n where n.domain = "karate" return n')
data[[1]][[1]]$data

```

## $Faction
## [1] 1
## 
## $domain
## [1] "karate"
## 
## $name
## [1] "Mr Hi"

Nothing more than the data that was included from the Karate data set.

In the labyrinth project there is a function called mazewalker which can add network statistics to all of our nodes.

We can choose any number of local or global network measures.

```{r}
mazeWalker('karate', 
           loc = c("degree", 'closeness', 'hub', 'eigenvector', 'page'), 
           glob = c('Assortativity', 'Clique', 'Diameter', 'Girth', 'Adhesion'))

```

Now we can re-query the database to see the new parameters that have been added.

```{r}
data <- cypher(graph, 'match n where n.domain = "karate" return n')
data[[1]][[1]]$data
```

## $domain
## [1] "karate"
## 
## $name
## [1] "Mr Hi"
## 
## $Faction
## [1] 1
## 
## $Adhesion
## [1] "0"
## 
## $Girth
## [1] "3"
## 
## $Diameter
## [1] "5"
## 
## $Clique
## [1] "5"
## 
## $Assortativity
## [1] "-0.475613097684614"
## 
## $page
## [1] "0.0484986426941474"
## 
## $eigenvector
## [1] "0.952132366476656"
## 
## $hub
## [1] "0.952132366476656"
## 
## $closeness
## [1] "0.0282700421940928"
## 
## $degree
## [1] "32"

