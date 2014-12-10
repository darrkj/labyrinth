
#' Mazewalker
#'
#' Utilize igraph to compute network statistics to write back to Neo4j
#'
#' @usage mazeWalker(constraints, stats)
#' @param constraints A method pull a certain sub-graph
#' @param stats A list of which netowrk parameters should be calculated
#' @export
#'
#' @details Will write network parameters back tp Neo4j
#'
#' @examples
#' require(igraph)
#' require(igraphdata)
#'   
#' data(karate)
#' ingest(karate, 'knows')
#' 
#' mazeWalker('karate', c("degree", "closeness", "betweeness", 'hub'))


mazeWalker <- function(constraints = NULL, loc = "degree", glob = 'Degree') {
  
  if (!is.null(constraints)) {
    constraints <- paste0("WHERE n.domain = '", constraints, "'")
  }
  
  nodes <- getNodes(graph, paste0("MATCH n ", constraints, " RETURN n"))
  ids <- sapply(nodes, getID)
  
  # Create graph statistics
  paste0("MATCH (n)-[r]->(m) ", constraints, " RETURN ID(n), ID(m);") %>%
    cypher(graph, .) %>%
    graph.data.frame -> g
  
  statistics <- merge(localStats(g, loc), globalStats(g, glob))
  
  #merge(data.frame(name = ids, ind = 1:length(ids))) -> stats
  
  ind <- which(ids %in% statistics$name)
  
  # Adding values back into the database.
  j <- 1
  for (i in ind) {
    do_call(updateProp, quote(nodes[[i]]), as.list(statistics[j, c(loc, glob)]))
    j <- j + 1
  }
  return(invisible(NULL))
}





