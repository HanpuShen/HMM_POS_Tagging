#' Penn Treebank Sample Dataset
#'
#' A sample dataset extracted from the Penn Treebank, containing annotated
#' parts of speech for a selection of sentences. The dataset is widely used
#' for training and testing part-of-speech taggers and other natural language
#' processing tasks. Each entry consists of a word and its corresponding POS
#' tag as defined by the Penn Treebank project.
#'
#' @format A data frame with 100676 rows and 2 variables:
#' \describe{
#'   \item{word}{Character. The word token.}
#'   \item{tags}{Factor with levels corresponding to the Penn Treebank POS tags.
#'              Each level represents a particular part of speech.}
#' }
#' @source Original Penn Treebank Project
#' @references
#' - Marcus, Mitchell P., et al. "Building a large annotated corpus of English:
#'   The Penn Treebank." Computational linguistics 19.2 (1993): 313-330.
#' - The Penn Treebank: https://www.cis.upenn.edu/~treebank/
"Penn_TreeBank"
