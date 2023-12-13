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
  # Reshape the confusion matrix for plotting
  conf_matrix_melted <- melt(conf_matrix)

  # Create the heatmap
  heatmap_plot <- ggplot(data = conf_matrix_melted, aes(x = Var2, y = Var1, fill = value)) +
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

  # Adjust plot size if required, useful when saving to a file
  ggsave(filename = "heatmap.png", plot = heatmap_plot, width = plot_width, height = plot_height, units = "in")

  # Return the plot
  return(heatmap_plot)
}

