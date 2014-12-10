

# This is all that is needed for adding measures.

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
  #merge(data.frame(name = ids, ind = 1:length(ids))) -> stats
  
  ind <- which(ids %in% statistics$name)
  
  # Adding values back into the database.
  j <- 1
  for (i in ind) {
    do_call(updateProp, quote(nodes[[i]]), as.list(statistics[j, stats]))
    j <- j + 1
  }
  return(invisible(NULL))
}
#


mazeWalker("WHERE n.domain = 'potter'", c("degree", "closeness", "betweeness", 'hub'))


