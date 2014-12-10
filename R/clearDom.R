
clearDom <- function(dom) {
  cypher(graph, paste0("match (a)-[r]->(b) where r.domain = '", dom, "' delete r;"))
  cypher(graph, paste0("match a where a.domain = '", dom, "' delete a;"))
}



# clearDom('karate')
