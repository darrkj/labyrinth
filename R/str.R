str.graph <- function(graph) {
  schema <- cypher(graph, 'MATCH (a)-[r]->(b)
  RETURN DISTINCT head(labels(a)) AS This, type(r) as To, head(labels(b)) AS That')
  
  rels <- cypher(graph, 'MATCH (n)-[r]->() RETURN type(r) as To, count(*) as to;')
  rels$to <- paste0(rels$To, ' (', rels$to, ') ')
  
  types <- unique(c(schema$This, schema$That))
  
  cnt <- unlist(sapply(types, function(type) 
    cypher(graph, paste0('MATCH (n:', type, ') RETURN count(DISTINCT n);'))))
  cnt <- paste0(types, ' (', cnt, ')')
  
  verts <- data.frame(types, cnt, row.names = NULL)
  
  layout <- merge(schema, verts, by.x = 'This', by.y = 'types', all.x = T)
  layout <- merge(layout, rels, all.x = T)
  layout <- merge(layout, verts, by.x = 'That', by.y = 'types', all.x = T)
  names(layout)[4:6] <- c('this', 'to', 'that')
  layout[4:6]
}
