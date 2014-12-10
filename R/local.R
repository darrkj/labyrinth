

#' Vertex level measures
#'
#' Function to compute a set of measures for each vertex in a given network.
#'
#' @usage localStats(g, stats)
#' @param g An igraph object
#' @param stats A list of which netowrk parameters should be calculated
#' @export
#'
#' @details Will add to the parameteres into a dataframe with the vertex name
#'
#' @examples
#' require(igraph)
#' require(igraphdata)
#'   
#' data(karate)
#' 
#' localStats(karate, c("degree", "closeness", 'hub'))


localStats <- function(g, stats) {
  as.data.frame(cbind(
      name = vertex.attributes(g)$name,
      degree = if('degree' %in% stats) centralization.degree(g)$res,
      closeness = if('closeness' %in% stats) centralization.closeness(g)$res,
      betweeness = if('betweeness' %in% stats) betweenness(g),
      eigenvector = if('eigenvector' %in% stats) centralization.evcent(g)$vector,
            # alpha.centrality(g), bonpow = bonpow(g)
      hub = if('hub' %in% stats) hub.score(g)$vector,
      auth = if('auth' %in% stats) authority.score(g)$vector,
      page = if('page' %in% stats) page.rank(g)$vector), 
    row.names = 1:length(V(g)))
}
