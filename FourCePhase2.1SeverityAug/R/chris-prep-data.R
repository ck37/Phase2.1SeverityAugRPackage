#' @import dplyr ggplot2 tidyr
chris_prep_data =
  function(currSiteId,
           LocalPatientSummary,
           LocalPatientObservations,
           LocalPatientClinicalCourse,
           labnames,
           LocalPatientChartReview,
           maxdays,
           mindays) {
    
  out_df = LocalPatientSummary
  full_data = LocalPatientObservations
  
  # Replace -999 values with NA
  full_data$value[full_data$value == -999] = NA
  
  data(code.dict, package="FourCePhase2.1Data")
  code.dict
 
  # Filter to rows that we are analyzing with IRT.
  data = full_data %>%
    # Don't include records more than mindays days prior to index admission (default -2).
    filter(days_since_admission >= mindays) %>%
    # And only up to maxdays days after admission (default 30)
    filter(days_since_admission <= maxdays) %>%
    filter((concept_type == "DIAG-ICD10" &
              (concept_code %in% c(
                # Ventilator-associated pneumonia
                "J95.851",
                # Pneumonia
                "J18.9",
                # ARDS
                "J80", 
                # Intubation
                "0BH17EZ")) |
              # Invasive vent
              grepl("^(5A09[345])", concept_code, perl = TRUE)) |
             (concept_type == "LAB-LOINC" &
                concept_code %in% c(
                  # D-Dimer FEU
                  "48067-3", "48065-7",
                  # LDH
                  "2532-0",
                  # Albumin
                  "1751-7",
                  # AST
                  "1920-8",
                  # C-reactive protein
                  "1988-5",
                  # Fibrinogen,
                  "3255-7",
                  # Bilirubin
                  "1975-2",
                  # Creatinine
                  "2160-0",
                  # White blood cell count (leukocytes)
                  "6690-2",
                  # INR?
                  "34714-6",
                  # Lymphocytes
                  "731-0",
                  # Neutrophil count
                  "751-8",
                  # Prothrombin time
                  "5902-2",
                  # Ferritin
                  "2276-4",
                  # procalcitonin
                  "33959-8",
                  # PaO2
                  "2703-7",
                  # PaCO2
                  "2019-8")) |
             (concept_type %in% c(#"COVID-TEST",
               "PROC-GROUP",
               "SEVERE-LAB",
               #"SEVERE-DIAG",
               "MED-CLASS"))) 
  
  # Set ICD codes to a value of 1 so that we can differentiate from no recorded value.
  # Also set medications to 1.
  data$value[data$concept_type %in%
               c("MED-CLASS",
                 "DIAG-ICD10",
                 "PROC-GROUP")] = 1
  
  # Shorten values where possible.
  data$concept_type[data$concept_type == "LAB-LOINC"] = "loinc"
  data$concept_type[data$concept_type == "DIAG-ICD10"] = "icd10"
  data$concept_type[data$concept_type == "COVID-TEST"] = "covid"
  data$concept_type[data$concept_type == "MED-CLASS"] = "med"
  data$concept_type[data$concept_type == "SEVERE-DIAG"] = "sev"
  data$concept_type[data$concept_type == "PROC-GROUP"] = "proc"
  data$concept_type[data$concept_type == "SEVERE-LAB"] = "sev"
  
  # ideally have one column per lab or procedure.
  data_wide = data %>%
    tidyr::pivot_wider(id_cols = c("patient_num", "days_since_admission"),
                       names_from = c("concept_type", "concept_code"),
                       values_from = "value")
  
  ### Forward fill
  data_wide = data_wide %>% group_by(patient_num) %>%
    tidyr::fill(everything(), .direction = "down") %>% ungroup()
  
  ### Integrate outcome table
  
  # Remove severe label from spreadsheet
  data_wide = dplyr::left_join(data_wide, out_df %>%
                                 # Remove days_since_admission
                                 select(-c(days_since_admission)), by = "patient_num")
  
  # Restrict to positive admissions.
  data_wide = data_wide %>% filter(grepl("PosAdm", cohort, fixed = TRUE))
  
  # Return the prepared dataset. 
  data_wide
  
}