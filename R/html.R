html <- function(file) {
  # Create temporary html file
  htmlFile <- tempfile(fileext=".html")
  
  cat(readLines(file), sep = '\n', file = htmlFile)
  
  # (code to write some content to the file)
  rstudio::viewer(htmlFile)
}
