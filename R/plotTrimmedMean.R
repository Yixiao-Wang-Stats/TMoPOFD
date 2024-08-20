#' Plot Trimmed Mean of Partially Observed Functional Data
#'
#' @param data A matrix of size p by n, where n is the number of functions and p is the number of grid points.
#'
#' @param alpha The trimming proportion.
#' @param type The chosen depth measure: Fraiman and Muniz depth (\code{"FMD"}), Modified Band Depth (\code{"MBD"}), 
#' or Modified Half Region Depth and Modified Epigraph/Hipograph Index (\code{"MHRD"}).
#' 
#' @return A plot of the trimmed mean of partially observed functional data.
#'
#' @examples
#' data(exampleData)
#' plotTrimmedMean(exampleData$PoFDextremes)
#'
#' @import ggplot2
#' @import tibble
#' @importFrom magrittr "%>%"
#' @import patchwork
#' @import fdaPOIFD
#' @importFrom reshape2 melt
#'
#' @export
library("fdaPOIFD")

plotTrimmedMean <- function(dataFrame, alpha = 0.3,type) {
  P <- dim(dataFrame)[1]
  N <- dim(dataFrame)[2]
  
  # Define trimmed portion
  trimmedPortion <- round((1 - alpha) * N)
  
  # Choose a depth type
  depthOrder <- POIFD(dataFrame, type)
  
  # Convert to data frame
  dataFrame <- as.data.frame(dataFrame)
  
  # Get column names
  columnNames <- as.numeric(names(head(depthOrder, trimmedPortion)))
  
  
  rowAveragesTrimmed <- rowMeans(dataFrame[, columnNames], na.rm = TRUE)
  rowAverages <- rowMeans(dataFrame, na.rm = TRUE)
  
  # Add trimmed row averages to dataFrame as a new column
  dataFrame$average_trimmed <- rowAveragesTrimmed
  dataFrame$average <- rowAverages
  dataFrame$x <- as.numeric(rownames(dataFrame))
  
  # Rename columns
  colnames(dataFrame)[1:N] <- c(1:N)
  
  # Melt the dataFrame to long format
  meltedData <- reshape2::melt(dataFrame, id.vars = 'x')
  
  # Create color column based on whether variable is in columnNames
  meltedData$color <- ifelse(meltedData$variable %in% columnNames, "black", 
                             ifelse(meltedData$variable == "average", "yellow", 
                                    ifelse(meltedData$variable == "average_trimmed", "green", "blue")))
  # Create size column for line thickness
  meltedData$size <- ifelse(meltedData$color == "black", 0.2,  # Black
                            ifelse(meltedData$color == "blue", 0.1,  # Blue
                                   ifelse(meltedData$color == "green", 0.8,  # Green
                                          0.5)))  # Other colors
  
  # Use ggplot2 to create the plot
  plotPoFD <- ggplot2::ggplot(meltedData, aes(x = x, y = value, col = color, group = as.factor(variable), size = size)) +
    ggplot2::geom_line(alpha = 1) +  # Use size to map line thickness
    ggplot2::scale_color_manual(values = c("black" = "black", "blue" = "blue", "yellow" = "yellow", "green" = "green")) +
    ggplot2::scale_size_continuous(range = c(0.1, 1)) +
    ggplot2::theme(legend.position = "none",
                   legend.title = element_blank(),
                   panel.background = element_blank(),
                   plot.title = element_text(hjust = 0.5),
                   axis.title = element_blank(),
                   axis.line = element_line(colour = "black", size = rel(1))) +
    ggplot2::ggtitle("Trimmed Mean for Partially Observed Functional Data")
  
  return(plotPoFD)  
}
