#!/bin/bash

#Set absolute path to Zebra3D.py on your computer
ZEBRA3D=""

if [ ! -n "$ZEBRA3D" ];then
    echo ""
    echo "Edit this script to set the absolute path to Zebra3D.py file"
    echo ""
    exit 
fi

DIR=`pwd`
OUTPUT="results_1.0"

for data in `ls | grep "^Example" | sort -V`
do
    tar xzf $data
    data=`echo $data | sed s/.tar.gz//`
    
    echo "---------------------------------------"
    echo "Working with $data"
    echo "---------------------------------------"
    
    cd $data
    FASTA=`find ./strcore -name "strcore_A-*.fasta"`
    PDB="strcore/aligned_pdbs/"

    if [ ! -f "$FASTA" ];then
	echo "Error: Fasta file is absent from $FASTA"
	exit 1
    fi

    if [ ! -d "$PDB" ];then
	echo "Error: PDB folder is absent from $PDB"
	exit 1
    fi
    
    if [ -d "$OUTPUT" ];then
        v=1
        while [ -d "$OUTPUT""_bac$v" ];do
            let v=v+1
        done
        mv "$OUTPUT" "$OUTPUT""_bac$v"
        echo "Warning: Results fold $OUTPUT from previous run has been saved as $OUTPUT""_bac$v"
    fi
    
    COMMAND="python3 $ZEBRA3D aligned_pdbs=$PDB aligned_fasta=$FASTA output=$OUTPUT"
    echo "Running the command: [$COMMAND]"
    $COMMAND > logfile.log 2>&1
    mv logfile.log $OUTPUT
    
    cd $DIR
    echo ""
done
