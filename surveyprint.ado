*! version 1.0.0 Arman Mahmud, 23Nov2025

cap program drop surveyprint
program define surveyprint 
	version 13 
	syntax, quesxl(string) [tool(string)]

	

** Load questionnaire
*~~~~~~~~~~~~~~~~~~~~~~*

	cap conf file "`quesxl'"

	if _rc{
	di as err "Questionnaire file not found. Please provide an Excel file"
	}

	if !_rc{
		
		*survey sheet*
		*~~~~~~~~~~~~~~*
		import excel using "`quesxl'", sheet(survey) firstrow clear
		keep type name labelEnglish labelBangla hintEnglish hintBangla constraint relevant
		drop if missing(type)
		
		g __name_type = name +" ["+ type+ "]"
		
		*English label
		g __label_eng_hint = labelEnglish+ " [Hint: "+ hintEnglish+ "]" if !missing(labelEnglish)
		
		*Bangla label
		g __label_bn_hint = labelBangla+ " [Hint: "+ hintBangla+ "]" if !missing(labelBangla)
		
		tempfile surv_sheet
		save `surv_sheet'
	

		*choices sheet*
		*~~~~~~~~~~~~~~*
		import excel using "`quesxl'", sheet(choices) firstrow clear
		keep list_name name labelEnglish labelBangla
		drop if missing(list_name)
		replace labelEnglish = "["+ name+ "] "+ labelEnglish
		replace labelBangla = "["+ name+ "] "+ labelBangla
		drop name
	
		egen __j = seq(), by(list_name)
		reshape wide labelEnglish labelBangla, i(list_name) j(__j)
		
		g ch_label_en = ""
		foreach x of varlist labelEnglish*{
			replace ch_label_en = ch_label_en + " "+ `x'
		}
		drop labelEnglish*
		
		g ch_label_bn = ""
		foreach x of varlist labelBangla*{
			replace ch_label_bn = ch_label_bn + " "+ `x'
		}
		drop labelBangla*
		
		replace list_name = trim(list_name)
		
		tempfile ch_sheet
		save `ch_sheet'
		
		*Merge survey and choice sheet*
		*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
		
		u `surv_sheet', clear
		split type, parse(" ")
		drop type1
		ren type2 list_name
		
		replace list_name = trim(list_name)
		qui merge m:1 list_name using `ch_sheet', keep(1 3)
	
		tempfile final_ques
		save `final_ques'
		
		*settings sheet*
		*~~~~~~~~~~~~~~*
		
		import excel using "`quesxl'", sheet(settings) firstrow clear
		levelsof form_title, loc(form_title)
		loc forms `form_title' 
		
		
		*Export in the Excel sheet*
		*~~~~~~~~~~~~~~~~~~~~~~~~~~*
		
		cap copy "https://raw.githubusercontent.com/armanmahmud1/surveyprint/main/Template/surveyprint_template.xlsx" ///
		"`forms'_English_`=c(current_date)'.xlsx"
		
		cap copy "https://raw.githubusercontent.com/armanmahmud1/surveyprint/main/Template/surveyprint_template.xlsx" ///
		"`forms'_Bangla_`=c(current_date)'.xlsx"
		
		*Put Questionnaire title and date
		preserve
			clear
			set obs 1
			gen __title = "`forms'"
			export excel using "`forms'_English_`=c(current_date)'.xlsx", cell(A1) sheetmodify keepcellfmt
			export excel using "`forms'_Bangla_`=c(current_date)'.xlsx", cell(A1) sheetmodify keepcellfmt
		restore
		
		preserve
			clear
			set obs 1
			gen __today = "`=c(current_date)'"
			export excel using "`forms'_English_`=c(current_date)'.xlsx", cell(A4) sheetmodify keepcellfmt
			export excel using "`forms'_Bangla_`=c(current_date)'.xlsx", cell(A4) sheetmodify keepcellfmt
		restore
		
		
		u `final_ques', clear
		*English Questionnaire
		preserve
			keep __name_type __label_eng_hint ch_label_en constraint relevant
			order __name_type __label_eng_hint ch_label_en constraint relevant
			export excel using "`forms'_English_`=c(current_date)'.xlsx", cell(A6) sheetmodify keepcellfmt
		restore
	
		*Bangla Questionnaire
		preserve
			keep __name_type __label_bn_hint ch_label_bn constraint relevant
			order __name_type __label_bn_hint ch_label_bn constraint relevant
			export excel using "`forms'_Bangla_`=c(current_date)'.xlsx", cell(A6) sheetmodify keepcellfmt
		restore
		
		** notes
	*~~~~~~~~~~~~~~~~~~~~~~~*

	n di ""
	n di ""
	n di as result "{hline}"
	n di as result " ✨ File Export Completed! ✨"
	n di as result "{hline}"
	n di ""
	n di as result " Output files have been saved to the current working directory."
	n di ""
	di as result `" English Questionnaire: {browse "`forms'_English_`=c(current_date)'.xlsx"}"'
	di as result `" Bangla Questionnaire: {browse "`forms'_Bangla_`=c(current_date)'.xlsx"}"'
	n di ""
	n di as result " You can find the directory path by typing " as input "pwd" as result " in the Command window."
	n di as result "{hline}"
		
	}
end
	










