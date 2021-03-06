get_stage("script") %>%
  add_step(step_rcmdcheck(args = "--as-cran", warnings_are_errors = FALSE,
                          notes_are_errors = FALSE))

if (Sys.getenv("id_rsa") != "") {
  # pkgdown documentation can be built optionally. Other example criteria:
  # - `inherits(ci(), "TravisCI")`: Only for Travis CI
  # - `ci()$is_tag()`: Only for tags, not for branches
  # - `Sys.getenv("BUILD_PKGDOWN") != ""`: If the env var "BUILD_PKGDOWN" is set
  # - `Sys.getenv("TRAVIS_EVENT_TYPE") == "cron"`: Only for Travis cron jobs
  get_stage("before_deploy") %>%
    add_step(step_setup_ssh())

  get_stage("deploy") %>%
    add_step(step_build_pkgdown()) %>%
    add_step(step_push_deploy(path = "docs", branch = "gh-pages"))
}

# only deploy man files on Travis on non-cron builds
# only run codecov on Travis
if (inherits(ci(), "TravisCI") && !Sys.getenv("TRAVIS_EVENT_TYPE") == "cron") {

  get_stage("after_deploy") %>%
    add_code_step(covr::codecov(quiet = FALSE))
}
