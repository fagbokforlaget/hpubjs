## hpubjs - hpub reader and writer
[![Build Status](https://travis-ci.org/fagbokforlaget/hpubjs.png?branch=master)](https://travis-ci.org/fagbokforlaget/hpubjs)
hpubjs provides access to hpub files in node.js applications.

### Installation

via npm:

```
$ npm install hpubjs

```

### Usage

#### Reader

```

hpub = require("hpub");

// un-packing book to a folder
reader = new hpub.Reader("path/to/book.hpub");
reader.read(function(err) {
  reader.extract("test/folder", function(err){
    // do whatever you want with extracted publication
  });
});

```

You can read meta information or any other file without extracting the whole book

```

// reading meta information (from book.json) without un-packing the book
reader = new hpub.Reader("path/to/book.hpub")
reader.read(function(err) {
  meta = reader.meta();
  // do something with meta information...
});

// you can extract any file inside book.hpub to buffer
reader = new hpub.Reader("path/to/book.hpub")
reader.read(function(err) {
  bufferedPage = reader.getFile('page-000.html');
  // ... do something with it
});

```

#### Writer

```

hpub = require("hpub");

writer = new hpub.Writer("./test/hpub_samples/book_to_be");

// prepare meta information
meta = {
  hpub: 1,
  title: "Title of the book",
  author: ['First Author', 'Other Author'],
  creator: ['fagbokforlaget'],
  date: "2011-01-01,
  url: 'http://example.com/book/thisbook', 
  cover: 'book.png',
  publisher: 'Fagbokforlaget',
  orientation: 'both',
  zoomable: true,
};

// add them to our hpub
writer.addMeta(meta);

// add one or more pages
writer.addPage("page-000.html");

// if assets are required, add them:
writer.assets.addFolders('css', 'js'); // list folders separeted by coma
writer.assets.addFile('path/to/file.ext'); // one file at a time

// build the book (book.json is going to be created)
writer.build(function(err) {
  // book.json should be created by now

  // if you need a book.hpub it's time to do this now:
  writer.pack("tmp/book", function(err, size) {
      // the book is ready!
  });
});

```

### Tests

```

$ npm test

```

Coverage (Make sure you have installed jscoverage (it's easy `sudo aptitude install jscoverage` or `brew jscoverage`)

```

$ npm test-cov

```

