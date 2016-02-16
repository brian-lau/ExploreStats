# coeffcorr
Intuition for how correlations between covariates relates to 
correlations between regression coefficients. This arose from the recent uptick in papers making inferences based on correlations between regression coefficients (i.e., fitting the same model to replicates and correlating the obtained fits for one coeffient with another). This seems pretty questionable given the relation between coefficient covariance and covariances within the design matrix.

![correlations](https://raw.githubusercontent.com/brian-lau/ExploreStats/master/coeffcorr/figure.jpg)

## References
* Finn, J (1974). [A General Model for Multivariate Analysis](http://www.ats.ucla.edu/stat/sca/finn/). 
Holt, Rinehard & Winston, Inc.
* Fomby, T, Hill, R, Johnson, S (1984). Advanced Econometric Methods. Springer.
* Friendly, M, Monette, G, Fox, J (2013). Elliptical insights: Understanding
statistical methods through elliptical geometry. Statistical Science 28, 1-39.
[DOI:10.1214/12-STS402](http://www.datavis.ca/papers/ellipses-STS402.pdf)
