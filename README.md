The tool helps to convert the particular types of HTML entities in the markdown documents to Kramdown.

Usage:

```ruby
ruby bin/html-to-kramdown PATH option
```

If `PATH` is a directory, the tool reads all the .md files in it recursively.

Available options:

- `--images`
- `--headings`
- `--links`
- `--tables`

Example:

```ruby
ruby bin/html-to-kramdown /Users/dshevtsov/projects/devdocs/ --images
```