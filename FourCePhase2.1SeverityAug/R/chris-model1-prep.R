#' @importFrom dplyr mutate
#' @importFrom magrittr %>%
chris_model1_prep =
  function(data_wide) {
    data_wide %>%
      dplyr::mutate(
             ldh = as.integer(!is.na(`loinc_2532-0`)),
             fibrinogen = as.integer(!is.na(`loinc_3255-7`)),
             ast = as.integer(!is.na(`loinc_1920-8`)),
             bilirubin = as.integer(!is.na(`loinc_1975-2`)),
             bloodgas = as.integer(!is.na(sev_BloodGas)),
             paco2 = as.integer(!is.na(`loinc_2019-8`)),
             pao2 = as.integer(!is.na(`loinc_2703-7`)),
             inr = as.integer(!is.na(`loinc_34714-6`)),
             pneumonia = as.integer(!is.na(icd10_J80)),
             vap = as.integer(!is.na(icd10_J95.851)),
             ards = as.integer(!is.na(icd10_J80)),
             creatinine = as.integer(!is.na(`loinc_2160-0`)),
             sicardiac = as.integer(!is.na(med_SICARDIAC)),
             sianes = as.integer(!is.na(med_SIANES)),
             covid_viral = as.integer(!is.na(med_COVIDVIRAL)),
             ddimer = as.integer(!is.na(`loinc_48065-7`)),
             o2_supp = as.integer(!is.na(proc_SupplementalOxygenSevere)),
             emer_gensurg = as.integer(!is.na(proc_EmergencyGeneralSurgery)),
             diuretic = as.integer(!is.na(med_DIURETIC)),
             crp = as.integer(!is.na(`loinc_1988-5`)),
             albumin = as.integer(!is.na(`loinc_1751-7`)),
             ferritin = as.integer(!is.na(`loinc_2276-4`)),
             wbc = as.integer(!is.na(`loinc_6690-2`)),
             lymphocytes = as.integer(!is.na(`loinc_731-0`)),
             neutrophil = as.integer(!is.na(`loinc_751-8`)),
             prothrombin = as.integer(!is.na(`loinc_5902-2`)),
             renal_repl = as.integer(!is.na(proc_RenalReplacement)))
    
    # Return the updated dataframe.
    data_wide
}