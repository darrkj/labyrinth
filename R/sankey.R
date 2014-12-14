plotRel <- function() {

fight <- cypher(graph, 'MATCH (a)-[r]->(b) where a.domain = "senate"
                RETURN head(labels(a)) AS This, type(r) as To, head(labels(b)) AS That')


d1 <- data.frame(a = unique(fight$This))
d2 <- data.frame(a = unique(fight$To))
d3 <- data.frame(a = unique(fight$That))

d1$n <- 0:(nrow(d1)-1)
d2$n <- (max(d1$n)+1):(max(d1$n) + nrow(d2))
d3$n <- (max(d2$n)+1):(max(d2$n) + nrow(d3))



nod <- rbind(d1, d2, d3)
node <- nod

nod$a <- NULL
names(nod) <- 'name'

node$n <- NULL
names(node) <- 'name'

#class or country to any to class or country
# a to b

fight %>% 
  select(sourcen = This, targetn = To) %>%
  inner_join(d1, by = c('sourcen' = 'a')) %>%
  select(source = n, targetn) %>%
  inner_join(d2, by = c('targetn' = 'a')) %>%
  select(source, target = n) %>%
  group_by(source, target) %>%
  mutate(value = n()) %>% 
  distinct -> ab



fight %>%
  select(sourcen = To, targetn = That) %>%
  inner_join(d2, by = c('sourcen' = 'a')) %>%
  select(source = n, targetn) %>%
  inner_join(d3, by = c('targetn' = 'a')) %>%
  select(source, target = n) %>%
  group_by(source, target) %>%
  mutate(value = n()) %>% 
  distinct -> bc




link <- as.data.frame(rbind(ab, bc))



d3Sankey(Links = link, Nodes = node, Source = "source",
         Target = "target", Value = "value", NodeID = "name",
         fontsize = 12, nodeWidth = 30, file = 'tmp.html')

suppressWarnings('tmp.html')



