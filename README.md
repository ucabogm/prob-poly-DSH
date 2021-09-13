# prob-poly-project

This online repository contains all python and SQL scripts used in the production of thesis "A Systematic Approach to Predicting Problematic Polypharmacy" as part requirement for the MSc Data Science and Machine Learning at UCL 2020/21. 

### Set-up (SQL and pre-processing)

* Note the numeric coding in each filename represents the CPRD BNF Coding for that medication.*

* *SQL_queries* is a folder containing the SQL scripts used for extracting data from the Patient, Therapy and Clinical CPRD data files for each medication.

* *data_processing* is a folder containing python code for processing the CPRD data extracts for each medication.

* *lookups* is a folder containing pickeled lookup files that the .ipynb files rely on.

* *helper_functions.ipynb* contains a range of helper functions for mapping codes, processing data, constructing datasets and other frequently used pieces of code.

### Main code (Chapters 3 & 4)

* *135_classifiers.ipynb* contains python code relating to the CCB analysis, corresponding to **Chapter 3** of the report.

* *testing_135_generalizability.ipynb* contains python code relating to the testing for generalizability of the CCB-trained classifier and then the extensions of this model, corresponding to **Chapter 4.1** of the report.

* *hypertension_multi_class_classifier.ipynb* contains python code relating to the development of a precision medicine framework, corresponding to **Chapter 4.2** of the report.

