
# Don't do dumb things with strings
options(stringsAsFactors = FALSE)

# Load libraries
library(dplyr)
library(igraph)
library(igraphdata)
library(RNeo4j)
library(pryr)

# Create connection to graph database
graph <- startGraph("http://localhost:7474/db/data/")

# This will add the karate club network to neo
data(karate)
ingest(karate, 'knows')

# Function to calculate a set of network measures by vertice
localStats <- function(g, stats) {
  as.data.frame(cbind(
    name = vertex.attributes(g)$name,
    degree = if('degree'      %in% stats) centralization.degree(g)$res    else NULL,
    closeness = if('closeness'   %in% stats) centralization.closeness(g)$res else NULL,
    betweeness = if('betweeness'  %in% stats) betweenness(g)                  else NULL,
    eigenvector = if('eigenvector' %in% stats) centralization.evcent(g)$vector else NULL,
    hub = if('hub'         %in% stats) hub.score(g)$vector             else NULL,
    auth = if('auth'        %in% stats) authority.score(g)$vector       else NULL,
    page = if('page'        %in% stats) page.rank(g)$vector             else NULL), 
    row.names = 1:length(V(g)))
}

# This function pulls a given network from the database, computed required
# statistics and tehn writes those back.
mazeWalker <- function(constraints = NULL, stats = c("degree", "closeness")) {
  
  if (!is.null(constraints)) {
    constraints <- paste0("WHERE n.domain = '", constraints, "'")
  }
  
  nodes <- getNodes(graph, paste0("MATCH n ", constraints, " RETURN n"))
  ids <- sapply(nodes, getID)
  
  # Create graph statistics
  paste0("MATCH (n)-[r]->(m) ", constraints, " RETURN ID(n), ID(m);") %>%
    cypher(graph, .) %>%
    graph.data.frame %>% 
    localStats(stats) -> statistics
  
  ind <- which(ids %in% statistics$name)
  
  # Adding values back into the database.
  j <- 1
  for (i in ind) {
    do_call(updateProp, quote(nodes[[i]]), as.list(statistics[j, stats]))
    j <- j + 1
  }
  return(invisible(NULL))
}


mazeWalker('karate', c("degree", "closeness", "betweeness", 'hub'))




clearDom <- function(dom) {
  cypher(graph, paste0("match (a)-[r]->(b) where r.domain = '", dom, "' delete r;"))
  cypher(graph, paste0("match a where a.domain = '", dom, "' delete a;"))
}



clearDom('karate')
