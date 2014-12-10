

globalStats <- function(g, glob, dir = FALSE) { 
  as.data.frame(cbind(
    name = vertex.attributes(g)$name,
           Degree = if('Degree'        %in% glob) length(V(g)),
         Degree_C = if('Degree_C'      %in% glob) centralization.degree(g)$centralization,
      Closeness_C = if('Closeness_C'   %in% glob) centralization.closeness(g)$centralization,
    Betweenness_C = if('Betweenness_C' %in% glob) centralization.betweenness(g, directed = dir)$centralization,
    Eigenvector_C = if('Eigenvector_C' %in% glob) centralization.evcent(g, directed = dir)$centralization,
    Assortativity = if('Assortativity' %in% glob) assortativity.degree(g),
     Avg_Path_Len = if('Avg_Path_Len'  %in% glob) average.path.length(g, directed = dir, unconnected = TRUE),
    Clique_Number = if('Clique_Number' %in% glob) clique.number(g),
         Diameter = if('Diameter'      %in% glob) diameter(g),
           Radius = if('Radius'        %in% glob) radius(g),
            Girth = if('Girth'         %in% glob) girth(g)$girth,
         Adhesion = if('Adhesion'      %in% glob) graph.adhesion(g),
          Density = if('Density'       %in% glob) graph.density(g),
          Chordal = if('Chordal'       %in% glob) is.chordal(g)$chordal,
        Connected = if('Connected'     %in% glob) is.connected(g),
    row.names = 1:length(V(g)))
}
