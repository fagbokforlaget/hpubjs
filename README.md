## hpubjs - hpub reader and writer

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
new hpub.Reader("path/to/book.hpub", function(err, reader) {
    reader.unpack(function(folder){
        //you have now book unpacked in 'folder'

        // if it's temporary then it could be removed...
        reader.clean();
    });
});

```

You can read meta information or any other file without extracting the whole book

```

// reading meta information (from book.json) without un-packing the book
new hpub.Reader("path/to/book.hpub", function(err, reader) {
    meta = reader.meta();
    // do something with meta information...
});

// you can extract any file inside book.hpub to buffer
new hpub.Reader("path/to/book.hpub", function(err, reader) {
    bufferedPage = reader.extractToBuffer('page-000.html');
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

// add them to our hpub
writer.addMeta(meta);

// add one or more pages
writer.addPage("page-000.html");

// if assets are required, add them:
writer.addAssetsFolders('css', 'js');

// build the book (book.json is going to be created)
writer.build(function(err) {
    // book.json should be created by now

    // if you need a book.hpub it's time to do this now:
    writer.pack("tmp/book", function(size) {
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

