#!/bin/sh

perl ../../src/prompts2mlf testref.mlf test_prompts
HVite -A -D -T 1 -H ../hmm15/macros -H ../hmm15/hmmdefs -C config -S test.scp -l '*' -i recout.mlf -w wdnet -p 0.0 -s 5.0 ../id_dict ../tiedlist
HResults -I testref.mlf ../tiedlist recout.mlf