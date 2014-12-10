



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
