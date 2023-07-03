# GRSmacrofauna
Gaoping River-shelf macrofauna data

# Description
This is a data package containing biological data, environmental data, and self-defined R functions.

Use the following code to download the package to your local R environment:

```
if (sum(as.data.frame(installed.packages())$Package %in% "devtools") < 1) {
  install.packages("devtools")
} else{
  devtools::install_github("chenyenting1998/GRSmacrofauna")
}
```

# Author
Yen-Ting Chen
