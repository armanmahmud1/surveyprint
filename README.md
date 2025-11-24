# surveyprint
Use this command organizes the questionnaire into an Excel format for convenient printing. It generates two separate files: one with English labels and another with Bangla labels. Once created, you can open either file and simply press Ctrl+P to print directly or save as a PDF.

## Descriptions
The `surveyprint` command organizes the questionnaire into an Excel format for convenient printing. It generates two separate files: one with English labels and another with Bangla labels. Once created, you can open either file and simply press Ctrl+P to print directly or save as a PDF.

## Installing Process
```
net install surveyprint, from("https://raw.githubusercontent.com/armanmahmud1/surveyprint/main/") replace
```

## ⚠️ Warning
This project provides functionality to **print questionnaires** from different survey platforms.  
Currently, it supports **ODK (Open Data Kit)** questionnaires, with active development underway to extend support for SurveyCTO & KoboToolbox.

## Example
```
   surveyprint, quesxl("C:\Users\Arman\Downloads\ODK_Test_BGWE_[CAPI].xlsx")
```

## Issues
For any issues, report: https://github.com/armanmahmud1/surveyprint/issues

## Author
Arman Mahmud </br>
Email: armanmahmud.du18@gmail.com </br>
Web: https://sites.google.com/view/armanmahmud1/


