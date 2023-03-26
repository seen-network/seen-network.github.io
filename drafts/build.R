
args = commandArgs(TRUE)

if(length(args) != 2) stop('must provide 2 arguments: valid document title and date')

post_name = args[1]
post_date = args[2]

suppressPackageStartupMessages({
  # require(googledrive)
  require(stringr)
})

unlink(glue::glue('{post_date}-{post_name}'))

# options(gargle_oauth_email = "robinedwards77@gmail.com")

# drive_download(post_name, overwrite = TRUE)

system(glue::glue('pandoc -s "{post_name}" --wrap=none -t markdown -o tmp.md'))

post = readLines('tmp.md')

header = glue::glue('---
layout: post
title: "{str_replace_all(post_name, "-", " ") |> str_to_sentence()}"
date: {post_date}
future: true
tags: network
subclass: post
author: seen
categories: seen
---\n\n')

formatted = c(header, post) |>
  str_replace_all(fixed('{.underline}]'), '') |>
  str_replace_all(fixed('[['), '[') |> 
  paste(collapse = '\n') |> 
  str_remove('---\n\n---\n') |> 
  str_remove('(?<=subtitle: ").*?[}]')

writeLines(formatted, glue::glue('../_posts/{post_date}-{tolower(str_remove(post_name, \".*/\")) |> str_replace_all("[ ]+", "-")}.md'))

unlink('tmp.md')
unlink(glue::glue("{post_name}.docx"))
