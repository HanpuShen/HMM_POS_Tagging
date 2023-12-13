#' Viterbi Algorithm for POS Tagging
#'
#' This function implements the Viterbi algorithm, which is used for sequence labeling and is particularly
#' well-suited for tasks like Part-of-Speech tagging. It finds the most likely sequence of hidden states
#' that results in a sequence of observed events, especially in the context of the Hidden Markov Model.
#'
#' @param words A vector of words (observations) for which the tags are to be predicted.
#' @param tags_level A vector of all possible tags (hidden states) in the model.
#' @param start_p A numeric vector of initial probabilities for each tag.
#'               By default, it is set to a uniform distribution.
#' @param trans_p A matrix of transition probabilities where `trans_p[i, j]` is the probability of
#'               transitioning from tag i to tag j.
#' @param emit_p A matrix of emission probabilities where `emit_p[i, j]` is the probability that tag i
#'               emits word j.
#' @param tag2int A named vector or list where names are tags and values are corresponding integer indices.
#' @param word2int A named vector or list where names are words and values are corresponding integer indices.
#'
#' @return A list containing the most probable sequence of tags (`path`) and the probability of that
#'         sequence (`prob`).
#'
viterbi <- function(words, tags_level, start_p=rep(1/length(tags_level),length(tags_level)), trans_p, emit_p,tag2int, word2int) {
  obs = word2int[words]
  states = tag2int[tags_level]
  V <- matrix(0, nrow = length(obs), ncol = length(states))
  path <- matrix(0, nrow = length(obs), ncol = length(states))

  # Initialize base cases (t == 0)
  for (s in 1:length(states)) {
    V[1, s] <- start_p[s] * emit_p[s, obs[1]]
    path[1, s] <- s
  }

  # Run Viterbi for t > 0
  for (t in 2:length(obs)) {
    newpath <- matrix(0, nrow = length(obs), ncol = length(states))

    for (s in 1:length(states)) {
      prob <- V[t - 1, ] * trans_p[, s] * emit_p[s, obs[t]]
      max_prob <- max(prob)
      best_state <- which.max(prob)
      V[t, s] <- max_prob
      newpath[1:(t-1), s] <- path[1:(t-1), best_state]
      newpath[t, s] <- s
    }

    path <- newpath
  }

  # Find the final best path
  max_prob <- max(V[length(obs), ])
  best_path <- path[, which.max(V[length(obs), ])]

  return(list(path = names(tag2int[best_path]), prob = max_prob))
}

#' Compute emission matrix
#'
#' @param ecm total emission count matrix
#' @param alpha smoothness coefficient
create_emission_matrix <- function(ecm,alpha){
  N = ncol(ecm)
  # Divide each row by the corresponding constant
  emission_matrix <- sweep(ecm+alpha, 1, rowSums(ecm)+alpha*N, FUN = "/")
  return(emission_matrix)
}
#' Compute transition matrix
#'
#' @param tcm total transition count matrix on state space, which is tags space in POS
#' @param alpha smoothness coefficient
#' @export
create_transition_matrix <- function(tcm,alpha){
  N = ncol(tcm)
  # Divide each row by the corresponding constant
  transition_matrix <- sweep(tcm+alpha, 1, rowSums(tcm)+alpha*N, FUN = "/")
  return(transition_matrix)
}
#' Get dictionary
#'
#' @param words A list of words
#' @return return a factor levels list for the given words, in POS they refer it to dictionary
get_dictionary <-function(words){
  dictionary = unique(words)
  return(dictionary)
}
