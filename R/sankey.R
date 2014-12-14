

#' neoSankey
#'
#' Sankey plot of relationships in database
#'
#' @usage neoSankey()
#' @export
#'
#'
#' @examples
#' neoSankey()


neoSankey <- function(constraints = NULL) {
  
  if (!is.null(constraints)) {
    constraints <- paste0("WHERE a.domain = '", constraints, "'")
  }
  
  rel <- cypher(graph, paste(
    'MATCH (a)-[r]->(b)', constraints, 
    'RETURN head(labels(a)) AS This, type(r) as To, head(labels(b)) AS That'))

  nd <- as.data.frame(rbind(cbind(unique(rel$This), 'a'),
                            cbind(unique(rel$To), 'b'),
                            cbind(unique(rel$That), 'c')))
  
  nd <- nd[complete.cases(nd), ]
  nd$n <- 0:(nrow(nd)-1)

  rel %>% 
    select(sourcen = This, targetn = To) %>%
    inner_join(nd[nd$V2 == 'a', ], by = c('sourcen' = 'V1')) %>%
    select(source = n, targetn) %>%
    inner_join(nd[nd$V2 == 'b', ], by = c('targetn' = 'V1')) %>%
    select(source, target = n) %>%
    group_by(source, target) %>%
    mutate(value = n()) %>% distinct -> ab

  rel %>%
    select(sourcen = To, targetn = That) %>%
    inner_join(nd[nd$V2 == 'b', ], by = c('sourcen' = 'V1')) %>%
    select(source = n, targetn) %>%
    inner_join(nd[nd$V2 == 'c', ], by = c('targetn' = 'V1')) %>%
    select(source, target = n) %>%
    group_by(source, target) %>%
    mutate(value = n()) %>% distinct -> bc
  
  link <- as.data.frame(rbind(ab, bc))

  d3Sankey(Links = link, Nodes = nd, Source = "source", width = 600,
           Target = "target", Value = "value", NodeID = "V1",
           fontsize = 12, nodeWidth = 30, file = 'tmp.html')

  suppressWarnings(html('tmp.html'))

  return(invisible(NULL))
}

