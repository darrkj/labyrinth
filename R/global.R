



globalStats <- function(g, glob, dir = FALSE) { 
  as.data.frame(cbind(
    name = vertex.attributes(g)$name,
    Degree = if('Degree' %in% glob) length(V(g)) else NULL,
    Degree_Cent = if('Degree_Cent' %in% glob) centralization.degree(g)$centralization, else NULL,
    Closeness_Cent = if('Closeness_Cent' %in% glob) centralization.closeness(g)$centralization else NULL,
    Betweenness_Cent = if('Betweenness_Cent' %in% glob) centralization.betweenness(g, directed = dir)$centralization else NULL,
    Eigenvector_Cent = if('Eigenvector_Cent' %in% glob) centralization.evcent(g, directed = dir)$centralization else NULL,
    Assortativity = if('Assortativity' %in% glob) assortativity.degree(g) else NULL,
    Avg_Path_Length = if('Avg_Path_Length' %in% glob) average.path.length(g, directed = dir, unconnected = TRUE) else NULL,
    Clique_Number = if('Clique_Number' %in% glob) clique.number(g) else NULL,
    Diameter = if('Diameter' %in% glob) diameter(g) else NULL,
    Radius = if('Radius' %in% glob) radius(g) else NULL,
    Girth = if('Girth' %in% glob) girth(g)$girth else NULL,
    Adhesion = if('Adhesion' %in% glob) graph.adhesion(g) else NULL,
    Density = if('Density' %in% glob) graph.density(g) else NULL,
    Chordal = if('Chordal' %in% glob) is.chordal(g)$chordal else NULL,
    Connected = if('Connected' %in% glob) is.connected(g) else NULL),
    row.names = 1:length(V(g)))
}
