# xlutils3

The xlutils3 package is a wrapper for the readxl package. It aims to extract all Excel files of a folder at once.

## Installation

You can install:

* the latest development version from Saagie internal Gitlab (requires you have an account):
*
```R
# install.packages("devtools")
devtools::install_git("ssh://git@gitlab.saagie.tech:42/aurele/xlutils3.git")
```

## Usage

```R
library(xlutils3)

# Extract all Excel files from folder, recursively:
data_ <- extract_excel("./Folder full of Excel files/")

# Compute summary of extracted data as a dataframe
View(summary_excel(data_))

# View all extracted data
view_excel(data_)
```

## Features

* Allows to pass args to readxl::excel_read for all files, or for specific files. (See general_case and weird_cases parameters for extract_excel).
