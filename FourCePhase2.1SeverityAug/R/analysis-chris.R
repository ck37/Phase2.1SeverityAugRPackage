analysis_chris =
  function(currSiteId,
           LocalPatientSummary,
           LocalPatientObservations,
           LocalPatientClinicalCourse,
           labnames,
           LocalPatientChartReview,
           maxdays,
           mindays,
           outcome) {
    
    data_wide =
      chris_prep_data(currSiteId,
                      LocalPatientSummary,
                      LocalPatientObservations,
                      LocalPatientClinicalCourse,
                      labnames,
                      LocalPatientChartReview,
                      maxdays, mindays)
    
    # Create indicators for IRT model 1; see R/chris-model1-prep.R.
    data_wide = chris_model1_prep(data_wide)
    
    result = chris_model1_run(data_wide)
             
    output = list(NA)
    saveRDS(output, paste0(getProjectOutputDirectory() , '/', currSiteId, '_chrisOutput.RDS'))
}