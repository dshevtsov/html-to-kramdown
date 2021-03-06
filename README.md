The tool helps to convert to Kramdown the particular types of HTML elements in `.md` files.

## Usage

```ruby
bin/html-to-kramdown PATH --option
```

If `PATH` is a directory, the tool reads all the `.md` files recursively.

### Available options

- `--images`
- `--headings`
- `--links`
- `--tables`
- `--notes` - converts notes like `<div class="bs-callout bs-callout-xxx" ... >...</div>` to Kramdown and adds the `markdown="1"` argument if it is not there. Same as `--notes_html` + `--notes_wih_md`.
- `--notes_html` - converts HTML content in the notes of format `<div class="bs-callout bs-callout-xxx" ... >...</div>` and adds the `markdown="1"` argument.
- `--notes_wih_md` - converts mixed content in the notes of format `<div class="bs-callout bs-callout-xxx" markdown="1">...</div>`

**Cution:** If the note is already in the valid Kramdown format and doesn't contain HTML, the tool still converts it and can break the valid formatting.

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
To make it work, provide additional parameter to enable Kramdown parsing within HTML: `markdown="1"`, or `markdown="span"`, or `markdown="block"`

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
