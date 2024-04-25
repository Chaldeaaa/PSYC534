# Functions used for data analysis
# craetes correlation matrix for all variables in selected regions
# also check for p values for each pair

# Environments
require(dplyr)
require(tidyverse)
require(ggplot2)


###### Create matrix for testing ######
matxCorr <- function(data, region){
    # would not work outside of dataset Crime from pkg plm
    
    data <- data %>% 
        filter(region == region) %>% 
        select(starts_with('l'))
    
    d <- expand.grid(var1 = names(data),
                var2 = names(data)) %>%
    as_tibble() %>%
    mutate(test = map2(var1, var2, ~cor.test(unlist(data[.x,]),
                                        unlist(data[.y,]))),
          corr = map_dbl(test, 'estimate'),
          p = map_dbl(test,'p.value'))
    return(d)
}

##### Organize matrix to factorial view #####
showCorr <- function(data, type){
    # type includes 'corr' or 'p'
    # showing corr coef. and p values resp.
    
    data %>% select(var1, var2, type) %>%
    spread(var2, type)
}


##### Visualize matrix using ggplot heatmap #####
paintCorr <- function(Crime, type){
    # type includes 'corr' or 'p'
    # paint heat map based on coorelation or p values
    
    ggplot(Crime, aes(var1, var2)) + 
        geom_tile(aes(fill = !!as.name(type))) +
        scale_x_discrete(expand = c(0,0)) +
        scale_y_discrete(expand = c(0,0)) +
        scale_fill_gradient(low = "white", high = "red")
}