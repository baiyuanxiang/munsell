#' Make a munsell colour lighter
#'
#' Increases the value of the Munsell colour by 1.
#' @param col character vector of Munsell colours
#' @return character vector of Munsell colours
#' @export
#' @examples 
#' lighter("5PB 2/4")
#' cols <- c("5PB 2/4", "5Y 7/8")
#' plot_mnsl(c(cols, lighter(cols)))
lighter <- function(col){
  col.split <- lapply(strsplit(col, "/"), 
    function(x) unlist(strsplit(x, " ")))
  unlist(lapply(col.split, function(x) 
    paste(x[1], " ", as.numeric(x[2]) + 1,"/", x[3] , sep = "")))  
}

#' Make a munsell colour darker
#'
#' Decreases the value of the Munsell colour by 1.
#' @param col character vector of Munsell colours
#' @return character vector of Munsell colours
#' @export
#' @examples 
#' darker("5PB 2/4")
#' cols <- c("5PB 2/4", "5Y 7/8")
#' plot_mnsl(c(cols, darker(cols)))
darker <- function(col){
  col.split <- lapply(strsplit(col, "/"), 
    function(x) unlist(strsplit(x, " ")))
  unlist(lapply(col.split, function(x) 
    paste(x[1], " ", as.numeric(x[2]) - 1,"/", x[3] , sep = "")))  
}

#' Make a munsell colour more saturated
#'
#' Increases the chroma of the Munsell colour by one step (+ 2).
#' @param col character vector of Munsell colours
#' @return character vector of Munsell colours
#' @export
#' @examples
#' saturate("5PB 2/4")
#' cols <- c("5PB 2/4", "5Y 7/8")
#' plot_mnsl(c(cols, saturate(cols)))
saturate <- function(col){
  col.split <- lapply(strsplit(col, "/"), 
    function(x) unlist(strsplit(x, " ")))
  unlist(lapply(col.split, function(x) 
    paste(x[1], " ", x[2], "/", as.numeric(x[3]) + 2, sep = "")))  
}

#' Make a munsell colour less saturated
#'
#' Decreases the chroma of the Munsell colour by one step (- 2).
#' @param col character vector of Munsell colours
#' @return character vector of Munsell colours
#' @export
#' @examples 
#' desaturate("5PB 2/4")
#' cols <- c("5PB 2/4", "5Y 7/8")
#' plot_mnsl(c(cols, desaturate(cols)))
desaturate <- function(col){
  col.split <- lapply(strsplit(col, "/"), 
    function(x) unlist(strsplit(x, " ")))
  unlist(lapply(col.split, function(x) 
    paste(x[1], " ", x[2], "/", as.numeric(x[3]) - 2, sep = "")))  
}

#' Find the complement of a munsell colour 
#'
#' Finds the munsell colour with the same chroma and value but on the opposite
#' side of the hue circle.
#' @param col character vector of Munsell colours
#' @param ... passed on to \code{\link{in_gamut}}. Use \code{fix = TRUE} to
#' fix "bad" complement
#' @return character vector of Munsell colours
#' @export
#' @examples 
#' complement("5PB 2/4")
#' cols <- c("5PB 2/4", "5Y 7/8")
#' plot_mnsl(c(cols, complement(cols)))
complement <- function(col, ...){
  col <- check_mnsl(col, ...)
  col.split <- lapply(strsplit(col, "/"), 
    function(x) unlist(strsplit(x, " ")))
  hues <- levels(munsell.map$hue)[-1]

  comps <- unlist(lapply(col.split, function(x) {
      hue.index <- match(x[1],  hues)
      paste(hues[(hue.index + 20) %% 40], " ", x[2], "/", x[3], sep = "")
    }))
  in_gamut(comps, ...)
}

#' Generate a sequence of Munsell colours
#'
#' Generates a sequence of Munsell colours.  The sequence is generated by 
#' finding the closest munsell colours to a equidistant sequence of colours in  #' LUV space.
#' @param from character string of first Munsell colour
#' @param to character string of last Munsell colour
#' @param n number of colours in sequence
#' @return character vector of Munsell colours
#' @export
#' @examples
#' seq_mnsl("5R 2/4", "5R 5/16", 4)
#' plot_mnsl(seq_mnsl("5R 2/4", "5R 5/16", 4))
#' plot_mnsl(seq_mnsl("5R 2/4", complement("5R 2/4", fix = TRUE), 5))
seq_mnsl <- function(from, to, n){
  in.LUV <- munsell.map[match(c(from, to), munsell.map$name), c("L", "U", "V")]
  LUV.seq <- matrix(c(seq(in.LUV$L[1], in.LUV$L[2],  length = n), 
    seq(in.LUV$U[1], in.LUV$U[2],  length = n), 
    seq(in.LUV$V[1], in.LUV$V[2],  length = n)),  ncol = 3)
  rgb2mnsl(as(LUV(LUV.seq), "RGB")@coords)
}