# --- A Guide to Support Vector Machines (SVM) with the Palmer Penguins Dataset ---

# 1. Introduction to SVM
# Support Vector Machines (SVMs) are powerful supervised machine learning models used for
# classification and regression tasks. The main idea behind SVM is to find a hyperplane
# that best separates data points of different classes in a high-dimensional space.
# The "best" hyperplane is the one with the maximum margin, i.e., the largest distance
# between the hyperplane and the nearest data points of any class. These nearest points
# are called "support vectors."

# 2. Setup: Installing and Loading Required Packages
# We will need 'palmerpenguins' for the dataset, 'e1071' for the SVM implementation,
# and 'ggplot2' for creating our final visualization.

if (!require("palmerpenguins")) install.packages("palmerpenguins")
if (!require("e1071")) install.packages("e1071")
if (!require("ggplot2")) install.packages("ggplot2")
if (!require("caTools")) install.packages("caTools")

library(palmerpenguins)
library(e1071)
library(ggplot2)
library(caTools)

# 3. Data Preparation
# We'll load the penguins dataset, select relevant columns, and remove rows with
# missing values to keep this example straightforward.

# Load the data
data("penguins")

# For this guide, we will focus on classifying the three species based on
# bill length and bill depth. We will also remove NA values.
penguins_clean <- na.omit(penguins[, c("species", "bill_length_mm", "bill_depth_mm")])

# Ensure the target variable is a factor
penguins_clean$species <- as.factor(penguins_clean$species)

# Set a seed for reproducibility
set.seed(123)

# Split the data into training (70%) and testing (30%) sets
split <- sample.split(penguins_clean$species, SplitRatio = 0.7)
train_data <- subset(penguins_clean, split == TRUE)
test_data <- subset(penguins_clean, split == FALSE)

cat("Data Preparation Complete.\n")
cat("Training set size:", nrow(train_data), "\n")
cat("Testing set size:", nrow(test_data), "\n")


# 4. Building the SVM Model
# We will use the svm() function from the 'e1071' package. We'll start with a
# linear kernel, which is suitable when the data is linearly separable.

# The formula 'species ~ .' means we are predicting 'species' using all other
# columns in the train_data (bill_length_mm and bill_depth_mm).
# kernel = "linear": Specifies a linear hyperplane.
# cost = 1: The 'C' parameter, which controls the trade-off between a smooth
#           decision boundary and classifying training points correctly.
svm_model <- svm(species ~ .,
                 data = train_data,
                 kernel = "linear",
                 cost = 1,
                 scale = TRUE) # It's good practice to scale features

# Print a summary of the model
print(summary(svm_model))


# 5. Model Evaluation
# Now, we'll use the trained model to make predictions on our unseen test data
# and evaluate its performance using a confusion matrix.

# Predict species on the test set
predictions <- predict(svm_model, newdata = test_data)

# Create a confusion matrix
confusion_matrix <- table(Predicted = predictions, Actual = test_data$species)
cat("\nConfusion Matrix:\n")
print(confusion_matrix)

# Calculate accuracy
accuracy <- sum(diag(confusion_matrix)) / sum(confusion_matrix)
cat("\nModel Accuracy on Test Data:", round(accuracy, 4), "\n")


# 6. Visualization of the SVM Decision Boundaries
# A great way to understand the SVM is to visualize it. We will create a plot
# showing the data points, the decision boundaries, and the support vectors.

# Note: The plot.svm() function can be complex. It creates a grid and predicts
# the class for each point on the grid to draw the decision boundaries.

# To make the plot clearer, let's create a data frame for the plot
plot_data <- train_data
plot_data$sv <- "Not SV"

# Identify the support vectors from the model
sv_indices <- svm_model$index
plot_data$sv[sv_indices] <- "Support Vector"

# Create the plot using ggplot2
# We map bill depth to x-axis and bill length to y-axis.
final_plot <- ggplot(plot_data, aes(x = bill_depth_mm, y = bill_length_mm)) +
  # Plot all data points, with species determining the color
  geom_point(aes(color = species, shape = species), size = 3) +
  # Highlight the support vectors by making them larger and giving them a black border
  geom_point(data = plot_data[plot_data$sv == "Support Vector", ],
             aes(shape = species),
             size = 5,
             stroke = 1.5,
             color = "black") +
  scale_shape_manual(values = c(16, 17, 15)) + # Solid circle, triangle, square
  labs(
    title = "SVM Decision Boundaries for Penguin Species",
    subtitle = "Based on Bill Length and Bill Depth",
    x = "Bill Depth (mm)",
    y = "Bill Length (mm)",
    color = "Species",
    shape = "Species",
    caption = "Black-outlined points are the Support Vectors"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "bottom",
    plot.title = element_text(hjust = 0.5, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5)
  )

# To add the decision boundaries, we need to do some calculations.
# This part is more advanced and involves creating a grid to plot the model's predictions.
# Create a grid of points spanning the range of the data
x_range <- range(plot_data$bill_depth_mm)
y_range <- range(plot_data$bill_length_mm)
grid_points <- expand.grid(bill_depth_mm = seq(x_range[1], x_range[2], length.out = 100),
                           bill_length_mm = seq(y_range[1], y_range[2], length.out = 100))

# Predict the species for each point in the grid
grid_predictions <- predict(svm_model, grid_points)
grid_points$species <- grid_predictions

# Add the decision boundary contours to our plot
final_plot <- final_plot +
  geom_contour(data = grid_points, aes(z = as.numeric(species)), color = "gray40", alpha = 0.8)

# Print the final plot
print(final_plot)

cat("\n--- End of Guide ---\n")
