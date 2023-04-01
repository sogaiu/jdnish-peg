# jdnish-peg

Some code for parsing and generating sort of JDN

## Background

Some JDN-like data isn't always valid Janet source because of some
"unreadable" things like functions, c functions, compiled pegs, etc.

This code extends [janet-peg](https://github.com/sogaiu/janet-peg) by
adding an extra `:unreadable` piece to the grammars in janet-peg.

## Usage Examples

Basic Parsing and Generation
```janet
(import jdnish-peg/rewrite)

# parse jdnish
(rewrite/par "@{:main <function 0xabba>}")
# =>
'@[:code
    (:table
      (:keyword ":main") (:whitespace " ")
      (:unreadable "<function 0xabba>"))]

# generate jdnish
(rewrite/gen
  '@(:code
      (:unreadable "<core/stream 0xaaf00f00>")))
# =>
"<core/stream 0xaaf00f00>"

# replace underscores in keywords with dashes
(def src
  ``
  {:a_1 1
   :b_2 2
   :c <core/peg 0xacabbaca>}
  ``)

(rewrite/gen
  (postwalk |(if (and (= (type $) :tuple)
                      (= (first $) :keyword)
                      (string/find "_" (in $ 1)))
               (tuple ;(let [arr (array ;$)]
                         (put arr 1
                              (string/replace-all "_" "-" (in $ 1)))))
               $)
            (rewrite/par src)))
# =>
"{:a-1 1\n :b-2 2\n :c <core/peg 0xacabbaca>>})"
```

## Examples

See `(comment ...)` portions of source files and files in `usages` for examples.

## Roundtrip Testing

To perform roundtrip testing on `.jdn`-ish files, use the
`test-samples.janet` script in the `support` directory.

For example, to test all `.jdn`-ish files in a directory at path `/tmp/samples`:
```
janet support/test-samples.janet /tmp/samples
```

Individual `.jdn`-ish files may also be tested by
specifying file paths.

For example, to test `sample.jdn` that lives under `/tmp`:
```
janet support/test-samples.janet /tmp/sample.jdn
```

