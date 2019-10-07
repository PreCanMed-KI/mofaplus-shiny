FROM r-base:3.5.2

WORKDIR /mofaplus
ADD . /mofaplus/shiny
ADD MOFA2 /mofaplus/mofa2

RUN apt-get update && apt-get install -y python3 python3-setuptools
RUN python3 /mofaplus/mofa2/setup.py install

# Install bioconductor dependencies
RUN R --vanilla -e "\
  if (!requireNamespace('BiocManager', quietly = TRUE)) install.packages('BiocManager', repos = 'https://cran.r-project.org'); \
  sapply(c('rhdf5', 'dplyr', 'tidyr', 'reshape2', 'pheatmap', 'corrplot', \
           'ggplot2', 'ggbeeswarm', 'scales', 'GGally', 'doParallel', 'RColorBrewer', \
           'cowplot', 'ggrepel', 'foreach', 'reticulate', 'HDF5Array', 'DelayedArray', \
           'shiny', 'shinyWidgets', 'devtools'), \ 
         BiocManager::install)"
RUN R CMD INSTALL --build /mofaplus/mofa2/MOFA2

CMD R -e "shiny::runApp('mofaplus-shiny/app', port = 4780)"
