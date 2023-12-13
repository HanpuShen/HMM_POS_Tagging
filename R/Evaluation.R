#' Plot Confusion Matrix as a Heatmap
#'
#' This function takes a confusion matrix and plots it as a heatmap. It adjusts the appearance of the heatmap for better readability, especially when the matrix is large. It allows for customization of text size and plot dimensions.
#'
#' @param conf_matrix A confusion matrix object, typically created by caret::confusionMatrix() or similar.
#' @param title The title for the heatmap.
#' @param text_size A numerical value for the size of the text in the plot.
#' @param plot_width Width of the plot in inches, relevant for saving to a file.
#' @param plot_height Height of the plot in inches, relevant for saving to a file.
#' @return A ggplot object representing the heatmap.
#' @import ggplot2
#' @import reshape2
#' @export
#' @examples
#' # Example usage:
#' # Assuming 'cm' is a confusion matrix
#' # plot_confusion_matrix_heatmap(cm, title = "My Heatmap")
plot_confusion_matrix_heatmap <- function(conf_matrix, title = "Confusion Matrix",
                                          text_size = 5, plot_width = 12, plot_height = 12) {
  # Check if conf_matrix is a table or matrix and convert accordingly
  if (is.table(conf_matrix)) {
    conf_matrix <- as.matrix(conf_matrix)
  }

  # Reshape the confusion matrix for plotting
  conf_matrix_melted <- melt(conf_matrix)
  # Create the heatmap
  heatmap_plot <- ggplot(data = conf_matrix_melted, aes(x = Prediction, y = Reference, fill = value)) +
    geom_tile(color = "white") +
    scale_fill_gradient(low = "white", high = "steelblue") +
    theme_minimal() +
    theme(
      axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1, size = text_size),
      axis.text.y = element_text(size = text_size),
      axis.title = element_text(size = text_size * 1.4),
      legend.title = element_text(size = text_size * 1.4),
      legend.text = element_text(size = text_size * 1.2),
      plot.title = element_text(size = text_size * 1.6)
    ) +
    labs(x = 'Predicted Label', y = 'True Label', fill = 'Count', title = title) +
    geom_text(aes(label = value), size = text_size / 3, check_overlap = TRUE)

  # Return the plot
  return(heatmap_plot)
}
#' Evaluate Part-of-Speech Tagging
#'
#' This function evaluates the performance of a Part-of-Speech tagging algorithm by calculating accuracy,
#' precision, recall, and F1 score, and generating a confusion matrix.
#'
#' @param predicted_tags A character vector of predicted tags.
#' @param true_tags A character vector of true tags.
#'
#' @return A list containing:
#' \itemize{
#'   \item \code{accuracy}: The overall accuracy of the predictions.
#'   \item \code{precision}: The precision for each tag.
#'   \item \code{recall}: The recall for each tag.
#'   \item \code{F1}: The F1 score for each tag.
#'   \item \code{confusion_matrix}: The confusion matrix of the predictions.
#' }
#'
#' @importFrom caret confusionMatrix
#' @importFrom dplyr union
#' @examples
#' # Example usage:
#' # predicted_tags <- c("NN", "VB", "DT", "NN")
#' # true_tags <- c("NN", "NN", "DT", "VB")
#' # results <- evaluate_pos_tagging(predicted_tags, true_tags)
#' # print(results)
#' @export
evaluate_pos_tagging <- function(predicted_tags, true_tags) {
  # Ensure factors have the same levels
  levels <- union(levels(factor(predicted_tags)), levels(factor(true_tags)))
  predicted_tags <- factor(predicted_tags, levels = levels)
  true_tags <- factor(true_tags, levels = levels)

  # Calculate Accuracy
  accuracy <- sum(predicted_tags == true_tags) / length(true_tags)

  # Calculate Confusion Matrix
  conf_matrix <- confusionMatrix(predicted_tags, true_tags)

  # Extract Precision, Recall, and F1 Score
  precision <- conf_matrix$byClass[, "Precision"]
  recall <- conf_matrix$byClass[, "Recall"]
  F1 <- conf_matrix$byClass[, "F1"]

  # Return results
  list(accuracy = accuracy, precision = precision, recall = recall, F1 = F1, confusion_matrix = conf_matrix$table)
}
