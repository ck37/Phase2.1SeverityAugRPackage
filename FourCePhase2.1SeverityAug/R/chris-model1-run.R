chris_model1_run = function(data_wide) {
  # Load model from data file.
  models = rio::import(system.file("extdata", "chris-irt-models.RData", package = "FourCePhase2.1SeverityAug"))
  model = models$binary$model
  irt_data = data_wide[, models$binary$items]
  
  # Apply to new data.
}