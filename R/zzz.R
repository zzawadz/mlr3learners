#' @import paradox
#' @importFrom R6 R6Class
#' @importFrom mlr3 mlr_learners LearnerClassif
"_PACKAGE"

.onLoad = function(libname, pkgname) {
  mlr_learners$add("classif.ranger", LearnerClassifRanger)
}
