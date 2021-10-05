
#' Runs the analytic workflow for the Phase2.1SeverityAugPackage project
#'
#' @keywords 4CE
#' @export

runAnalysis <- function(chartReview_path = '/4ceData/LocalPatientChartReview_wpids.csv',
                        maxdays = 30, mindays = -2,
                        outcome = 'Severe?',
                        run_qc = TRUE,
                        analysis = c("william", "chris")) {
    
    library(readr)
    library(ggplot2)
    library(dplyr)
    library(FourCePhase2.1Data)
    library(tidyr)
    library(stringr)
    library(data.table)
    library(eRm)
    library(splines)
    library(Rmisc)
    
    ## make sure this instance has the latest version of the quality control and data wrangling code available
    devtools::install_github("https://github.com/covidclinical/Phase2.1DataRPackage", subdir="FourCePhase2.1Data", upgrade=FALSE)

    ## get the site identifier assocaited with the files stored in the /4ceData/Input directory that 
    ## is mounted to the container
    currSiteId = FourCePhase2.1Data::getSiteId()

    ## run the quality control
    if (run_qc) {
        FourCePhase2.1Data::runQC(currSiteId)
    }

    # Load all of the key datasets.
    LocalPatientSummary = FourCePhase2.1Data::getLocalPatientSummary(currSiteId)
    LocalPatientObservations = FourCePhase2.1Data::getLocalPatientObservations(currSiteId)
    LocalPatientClinicalCourse = FourCePhase2.1Data::getLocalPatientClinicalCourse(currSiteId)
    labnames <- read_csv(system.file("extdata", "labnames.csv", package = "FourCePhase2.1SeverityAug"))
    LocalPatientChartReview <- read_csv(chartReview_path ) %>% select(c('patient_num', 'Severe?', 'COVID-19 Hospitalization?'))
    
    if ("william" %in% analysis) {
        cat("Running William analysis\n.")
        run_time = system.time({
        analysis_william(currSiteId = currSiteId,
                         LocalPatientSummary = LocalPatientSummary,
                         LocalPatientObservations = LocalPatientObservations,
                         LocalPatientClinicalCourse = LocalPatientClinicalCourse,
                         labnames = labnames,
                         LocalPatientChartReview = LocalPatientChartReview,
                         maxdays = maxdays,
                         mindays = mindays,
                         outcome = outcome)
        })
        cat("William analysis time:\n")
        print(run_time)
    }
    
    if ("chris" %in% analysis) {
        cat("Running Chris analysis\n.")
        run_time = system.time({
        analysis_chris(currSiteId = currSiteId,
                       LocalPatientSummary = LocalPatientSummary,
                       LocalPatientObservations = LocalPatientObservations,
                       LocalPatientClinicalCourse = LocalPatientClinicalCourse,
                       labnames = labnames,
                       LocalPatientChartReview = LocalPatientChartReview)
        })
        cat("Chris analysis time:\n")
        print(run_time)
    }
   
}

