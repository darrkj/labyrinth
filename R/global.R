

#' Graph level measures
#'
#' Function to compute a set of measures for the entire network.
#'
#' @usage globalStats(g, glob)
#' @param g An igraph object
#' @param glob A list of which netowrk parameters should be calculated
#' @export
#'
#' @details Will add to the parameteres into a dataframe.
#'
#' @examples
#' require(igraph)
#' require(igraphdata)
#'   
#' data(karate)
#' 
#' globalStats(karate, c("Degree", "Radius", 'Girth'))


globalStats <- function(g, glob, dir = FALSE) { 
  as.data.frame(cbind(
           name = vertex.attributes(g)$name,
         Degree = if('Degree'    %in% glob) length(V(g)),
       Deg_Cent = if('Deg_Cent'  %in% glob) centralization.degree(g)$cent,
      Clos_Cent = if('Clos_Cent' %in% glob) centralization.closeness(g)$cent,
       Bet_Cent = if('Bet_Cent'  %in% glob) centralization.betweenness(g, dir)$cent,
       Eig_Cent = if('Eig_Cent'  %in% glob) centralization.evcent(g, dir)$cent,
  Assortativity = if('Assortativity'    %in% glob) assortativity.degree(g),
   Avg_Path_Len = if('Avg_Path_Len'  %in% glob) average.path.length(g, dir, TRUE),
         Clique = if('Clique'    %in% glob) suppressWarnings(clique.number(g)),
       Diameter = if('Diameter'  %in% glob) diameter(g),
         Radius = if('Radius'    %in% glob) radius(g),
          Girth = if('Girth'     %in% glob) girth(g)$girth,
       Adhesion = if('Adhesion'  %in% glob) graph.adhesion(g),
        Density = if('Density'   %in% glob) graph.density(g),
        Chordal = if('Chordal'   %in% glob) is.chordal(g)$chordal,
      Connected = if('Connected' %in% glob) is.connected(g)),
    row.names = 1)
}
