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
