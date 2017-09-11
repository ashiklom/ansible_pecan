# Example implementation of `remote_execute` using Ansible
remote_execute <- function(expr, host) {
  stopifnot(typeof(expr) == "language")
  code_string <- deparse(expr)
  stopifnot(any(grepl("dput", code_string)))
  code_string_c <- paste(code_string, collapse = ';')
  cmd <- sprintf('Rscript -e %s', shQuote(code_string_c))
  result <- system2("ansible", c(host, "-m", "command", "-a", shQuote(cmd)), stdout = TRUE, stderr = TRUE)
  result_status <- attr(result, 'status')
  if (!is.null(result_status) && result_status == 1) {
    stop('Error executing expression: \n', paste(result, collapse = '\n'))
  }
  result_sub <- grep('SUCCESS | .*>>$', result, invert = TRUE, value = TRUE)
  parsed <- parse(text = result_sub)
  evalled <- eval(parsed)
  return(evalled)
}

expr <- quote({
  n <- 5000
  z <- data.frame(norm = rnorm(n), gamma = rgamma(n, 1))
  dput(z)
})

out <- remote_execute(expr, 'testpecan')
par(mfrow = c(2, 1))
hist(out$norm)
hist(out$gamma)
