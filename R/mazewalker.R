
localStats <- function(g, stats) {
  as.data.frame(cbind(name = vertex.attributes(g)$name,
                      degree = if('degree' %in% stats) centralization.degree(g)$res else NULL,
                      closeness = if('closeness' %in% stats) centralization.closeness(g)$res else NULL,
                      betweeness = if('betweeness' %in% stats) betweenness(g) else NULL,
                      eigenvector = if('eigenvector' %in% stats) centralization.evcent(g)$vector else NULL,
                      # alpha.centrality(g), bonpow = bonpow(g)
                      hub = if('hub' %in% stats) hub.score(g)$vector else NULL,
                      auth = if('auth' %in% stats) authority.score(g)$vector else NULL,
                      page = if('page' %in% stats) page.rank(g)$vector else NULL), row.names = 1:length(V(g)))
}


globalStats <- function(g) { 
  data.frame(
    Degree = length(V(g)),
    Degree_Centralization = centralization.degree(g)$centralization,
    Closeness_Centralization = centralization.closeness(g)$centralization,
    Betweenness_Centralization = centralization.betweenness(g, directed = FALSE)$centralization,
    Eigenvector_Centralization = centralization.evcent(g, directed = FALSE)$centralization,
    Assortativity_Coefficient = assortativity.degree(g),
    Average_Path_Length = average.path.length(g, directed = FALSE, unconnected = TRUE),
    Clique_Number = clique.number(g),
    Diameter = diameter(g),
    Radius = radius(g),
    Girth = girth(g)$girth,
    Adhesion = graph.adhesion(g),
    Density = graph.density(g),
    Chordal = is.chordal(g)$chordal,
    Connected = is.connected(g)
  )
}


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


