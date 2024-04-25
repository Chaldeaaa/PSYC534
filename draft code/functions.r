# Functions used for data analysis
# craetes correlation matrix for all variables in selected regions
# also check for adjusted p values for each pair
# might not work outside of dataset Crime from pkg plm

# Environments
require(dplyr)
require(tidyverse)
require(ggplot2)
require(stat)


###### Create matrix for testing ######
matxCorr <- function(data, region, adjust = 'bonferroni'){
    # a function to produce a correlation matrix among selected marker of data
    # might not work outside of dataset Crime from pkg plm
    # region (region tag of county): west, central, other
    # adjust (p-value adjustment): "holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr", "none"
    
    data <- data %>% 
        filter(region == region) %>% 
        select(starts_with('l'))
    
    d <- expand.grid(var1 = names(data),
                    var2 = names(data)) %>%
    as_tibble() %>%
    mutate(test = map2(var1, var2, ~cor.test(unlist(data[,.x]),    # perform the correlation test for each pair and store it
                                           unlist(data[,.y]))),
          corr = map_dbl(test, 'estimate'),
          p_unadj = map_dbl(test,'p.value'))
    d$p <- p.adjust(d$p_unadj, adjust)
    return(d)
}


##### Organize matrix to factorial view #####
showCorr <- function(data, type = 'p'){
    # draw a matrix of correlation or p values
    # type includes 'corr' or 'p' (default 'p')
    
    data %>% select(var1, var2, type) %>%
    spread(var2, type)
}


##### Visualize matrix using ggplot heatmap #####
paintCorr <- function(data, type = 'p'){
    # paint heat map based on coorelation or p values
    # type includes 'corr' or 'p' (default 'p')
    
    ggplot(data, aes(var1, var2)) + 
        geom_tile(aes(fill = !!as.name(type))) +
        scale_x_discrete(expand = c(0,0)) +
        scale_y_discrete(expand = c(0,0)) +
        scale_fill_gradient(low = "white", high = "red")
}
