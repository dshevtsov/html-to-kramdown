The tool helps to convert to Kramdown the particular types of HTML elements in `.md` files.

## Usage

```ruby
bin/html-to-kramdown PATH --option
```

If `PATH` is a directory, the tool reads all the `.md` files recursively.

### Available options

- `--images`
- `--headings` - adds a blank line after a heading.
- `--links` - converts to inline links.
- `--tables` - adds two blank lines after a table.

### Example

```ruby
bin/html-to-kramdown /Users/dshevtsov/projects/devdocs/ --images
```

## Requirements

```
$ gem install kramdown
```

## Precautions

Note, that the Kramdown parser doesn't recognize Kramdown elements inside HTML blocks by default.
To make it work, provide additional parameter to tell Kramdown to parse kramdown inside HTML: `markdown="1"`, or `markdown="span"`, or `markdown="block"`

Breaking example:
```html
<ul>
  <li>[text](../link.html)</li>
</ul>
```

Working examnple:
```html
<ul>
  <li markdown="span">[text](../link.html)</li>
</ul>
```
