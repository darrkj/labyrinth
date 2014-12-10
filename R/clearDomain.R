
clearDomain <- function(domain) {
  cypher(graph, paste0("match (a)-[r]->(b) where r.domain = '", domain, "' delete r;"))
  cypher(graph, paste0("match a where a.domain = '", domain, "' delete a;"))
}



# clearDom('karate')
