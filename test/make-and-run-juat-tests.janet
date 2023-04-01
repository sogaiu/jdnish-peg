(-> ["janet"
     "./janet-usages-as-tests/make-and-run-tests.janet"
     # specify file and/or directory paths relative to project root
     "./jdnish-peg"
     "./usages"
     ]
    (os/execute :p)
    os/exit)

