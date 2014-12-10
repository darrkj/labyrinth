
#' Clear Neo4j sub-graph
#'
#' Clear sub-graph in Neo4j with given domain.
#'
#' @usage clearDomain(domain)
#' @param domain A string of which is attached to nodes and relationships as the domain property in the database
#' 
#' @export
#'
#' @examples
#' clearDomain('karate')


clearDomain <- function(domain) {
  cypher(graph, paste0("match (a)-[r]->(b) where r.domain = '", domain, "' delete r;"))
  cypher(graph, paste0("match a where a.domain = '", domain, "' delete a;"))
}

