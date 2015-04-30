# words_test
https://gist.github.com/seanthehead/11180933

## Usage ##
    
    Usage: ./words_test.pl [OPTIONS]
    
        Given a dictionary file -f, generates two output files, 'sequences' and 'words'.
        'sequences' will contain every sequence of four letters that appears in exactly one word of the dictionary, one sequence per line.
        'words' will contain the corresponding words that contain the sequences, in the same order, again one per line.
    
        [OPTIONS]
        -f [FILE]   Path to dictionary FILE
    
        -debug      Print tab delimited sequences and words to STDOUT rather than the output files
        -help       This Usage Menu.

## Debug Example ##
    $ ./words_test.pl -f testfile -debug
    carr    carrots
    give    give
    rots    carrots
    rows    arrows
    rrot    carrots
    rrow    arrows

## Benchmark ##
    $ wc -l dictionary.txt
    25143 dictionary.txt
    
    $ time ./words_test.pl -f dictionary.txt
    
    real    0m0.444s
    user    0m0.432s
    sys     0m0.008s
    
    $ wc -l sequences
    11866 sequences
    
    $ wc -l words
    11866 words
