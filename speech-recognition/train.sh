#!/bin/sh
# This is a comment!

# Step 2
echo "STEP 2"
julia ../src/prompts2wlist.jl prompt_sentences wlist
HDMan -A -D -T 1 -m -w wlist -n monophones1 -i -l dlog dict id_dict

echo "STEP 4"
julia ../src/prompts2mlf.jl prompt_sentences words.mlf
HLEd -A -D -T 1 -l '*' -d dict -i phones0.mlf mkphones0.led words.mlf
HLEd -A -D -T 1 -l '*' -d dict -i phones1.mlf mkphones1.led words.mlf

echo "STEP 5"
HCopy -A -D -T 1 -C wav_config -S codetrain.scp

echo "STEP 6"
rm -rf hmm*/
mkdir hmm0
HCompV -A -D -T 1 -C config -f 0.01 -m -S train.scp -M hmm0 proto

echo "Flat Start Monophones"
cp monophones0 hmm0/hmmdefs
python flat_start.py

echo "Create Macros"
cp hmm0/vFloors hmm0/macros
python create_macros.py

echo "Re-estimate Monophones"
mkdir hmm1
HERest -A -D -T 1 -C config -I phones0.mlf -t 250.0 150.0 1000.0 -S train.scp -H hmm0/macros -H hmm0/hmmdefs -M hmm1 monophones0
mkdir hmm2
HERest -A -D -T 1 -C config -I phones0.mlf -t 250.0 150.0 1000.0 -S train.scp -H hmm1/macros -H hmm1/hmmdefs -M hmm2 monophones0
mkdir hmm3
HERest -A -D -T 1 -C config -I phones0.mlf -t 250.0 150.0 1000.0 -S train.scp -H hmm2/macros -H hmm2/hmmdefs -M hmm3 monophones0

echo "STEP 7"
cp -r hmm3 hmm4
python hmm3_to_hmm4.py
mkdir hmm5
HHEd -A -D -T 1 -H hmm4/macros -H hmm4/hmmdefs -M hmm5 sil.hed monophones1
mkdir hmm6
HERest -A -D -T 1 -C config  -I phones1.mlf -t 250.0 150.0 3000.0 -S train.scp -H hmm5/macros -H hmm5/hmmdefs -M hmm6 monophones1
mkdir hmm7
HERest -A -D -T 1 -C config  -I phones1.mlf -t 250.0 150.0 3000.0 -S train.scp -H hmm6/macros -H hmm6/hmmdefs -M hmm7 monophones1

echo "STEP 8"
HVite -A -D -T 1 -l '*' -o SWT -b SENT-END -C config -H hmm7/macros -H hmm7/hmmdefs -i aligned.mlf -m -t 250.0 150.0 1000.0 -y lab -a -I words.mlf -S train.scp dict monophones1> HVite_log
mkdir hmm8
HERest -A -D -T 1 -C config -I aligned.mlf -t 250.0 150.0 3000.0 -S train.scp -H hmm7/macros -H hmm7/hmmdefs -M hmm8 monophones1 
mkdir hmm9
HERest -A -D -T 1 -C config -I aligned.mlf -t 250.0 150.0 3000.0 -S train.scp -H hmm8/macros -H hmm8/hmmdefs -M hmm9 monophones1

echo "STEP 9"
HLEd -A -D -T 1 -n triphones1 -l '*' -i wintri.mlf mktri.led aligned.mlf
julia ../src/mktrihed.jl monophones1 triphones1 mktri.hed
mkdir hmm10
HHEd -A -D -T 1 -H hmm9/macros -H hmm9/hmmdefs -M hmm10 mktri.hed monophones1
mkdir hmm11
HERest  -A -D -T 1 -C config -I wintri.mlf -t 250.0 150.0 3000.0 -S train.scp -H hmm10/macros -H hmm10/hmmdefs -M hmm11 triphones1 
mkdir hmm12
HERest  -A -D -T 1 -C config -I wintri.mlf -t 250.0 150.0 3000.0 -s stats -S train.scp -H hmm11/macros -H hmm11/hmmdefs -M hmm12 triphones1 

echo "STEP 10"
HDMan -A -D -T 1 -b sp -n fulllist0 -g maketriphones.ded -l flog dict-tri id_dict
julia ../src/fixfulllist.jl fulllist0 monophones0 fulllist

echo "cat tree"
cat tree1.hed > tree.hed
julia ../src/mkclscript.jl monophones0 tree.hed
mkdir hmm13
HHEd -A -D -T 1 -H hmm12/macros -H hmm12/hmmdefs -M hmm13 tree.hed triphones1 
mkdir hmm14
HERest -A -D -T 1 -T 1 -C config -I wintri.mlf  -t 250.0 150.0 3000.0 -S train.scp -H hmm13/macros -H hmm13/hmmdefs -M hmm14 tiedlist
mkdir hmm15
HERest -A -D -T 1 -T 1 -C config -I wintri.mlf  -t 250.0 150.0 3000.0 -S train.scp -H hmm14/macros -H hmm14/hmmdefs -M hmm15 tiedlist

