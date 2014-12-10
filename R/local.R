

#' Vertex level measures
#'
#' Function to compute a set of measures for each vertex in a given network.
#'
#' @usage localStats(g, loc)
#' @param g An igraph object
#' @param loc A list of which netowrk parameters should be calculated
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


localStats <- function(g, loc) {
  as.data.frame(cbind(
             name = vertex.attributes(g)$name,
           degree = if('degree'      %in% loc) centralization.degree(g)$res,
        closeness = if('closeness'   %in% loc) centralization.closeness(g)$res,
       betweeness = if('betweeness'  %in% loc) betweenness(g),
      eigenvector = if('eigenvector' %in% loc) centralization.evcent(g)$vector,
              hub = if('hub'         %in% loc) hub.score(g)$vector,
             auth = if('auth'        %in% loc) authority.score(g)$vector,
             page = if('page'        %in% loc) page.rank(g)$vector), 
    row.names = 1:length(V(g)))
}
