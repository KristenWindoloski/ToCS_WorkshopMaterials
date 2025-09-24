library(readxl)
library(magrittr)
library(dplyr)


# --- Read in Excel file with bioactivity data; only look at active calls
bioactivity_df <- read_excel("Curve_Data20250923104630-UPOFWZB53.xlsx")
bioactivity_df <- bioactivity_df %>% dplyr::filter(Call == "Active")


# --- Create new data frame to store bioactivity data (1 per compound)
final_df <- data.frame(ChemicalName = unique(bioactivity_df$ChemicalName),
                       CAS = unique(bioactivity_df$CASRN))

final_df$BioactiveConc <- NA


# --- Generate and store 5th quantile bioactivity data
for (i in 1:nrow(final_df)) {
  
  sub_df <- bioactivity_df[bioactivity_df$CASRN == final_df[[i,2]],]
  
  final_df$BioactiveConc[i] <- quantile(as.numeric(sub_df$AC50), 
                                        probs = c(0.05))
}