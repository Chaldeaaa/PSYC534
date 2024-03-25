Purpose: gathering data from Crime in NC across county/tinme
Process: Make visuals and tests

### Environtment

```{r}
require('plm')
require('ggplot2')
require('dplyr')
```

Cannot install library 'plm' and dependency 'collapse'
Error message: non-zero exit
Conda installation worked but cannot import
Solution: install and rebuild (lastest version of) collapse & plm separately using pak

```{r}
# require('pak')
# pak::pkg_install("collapse@2.0.11")
# pak::pkg_install("plm@2.6-3")
```

### Gain data
```{r}
data(Crime)
```

### Possible correlations
```{r}
plot(Crime[,1:10])
```

#### Possible correlations
crmrte vs. density
prbpris vs. density
crmrte vs. density

List of variables used:
- crmrte (crime rate)
- density (population density)
- probpris (probability of prison sentence)

#### Corr tests
```{r}
# Crime rate vs. density
cor.test(Crime[,'crmrte'], Crime[,'density'], na.action = omit)

# Probability of prison vs. density
cor.test(Crime[,'prbpris'], Crime[,'density'], na.action = omit)

# Crime rate vs. tax revenew per capita
cor.test(Crime[,'crmrte'], Crime[,'taxpc'], na.action = omit)
```

### Crime rates of all counties across time
```{r}
ggplot(Crime, aes(x = county, y = crmrte)) +
    geom_point(size = 1, colour = 'black') +
    facet_wrap(~year, nrow = 7)
``` 
Points of interest
- county 195 decreased crime rate
- county 181 increased crime rate
- county 141 skyrocket crime rate @1986
```{r}
determine which county (141)
Crime[,'county'][Crime[,'crmrte']>0.12]
```
    
