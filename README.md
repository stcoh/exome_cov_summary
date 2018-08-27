# Extract Picard target coverage for the specified genes
perl extract_genes_target_coverage.pl in_gene_list in_Regions.interval_list out_gene_list_out


## in_gene_list example:
CTC1

DAXX
DDX41
DKC1
DLC1
DNMT3A
...


## in_Regions.interval_list example:
@HD     VN:1.5  SO:coordinate
@SQ     SN:chrM LN:16569
@SQ     SN:chr1 LN:249250621
@SQ     SN:chr2 LN:243199373
@SQ     SN:chr3 LN:198022430
@SQ     SN:chr4 LN:191154276
@SQ     SN:chr5 LN:180915260
@SQ     SN:chr6 LN:171115067
@SQ     SN:chr7 LN:159138663
@SQ     SN:chr8 LN:146364022
@SQ     SN:chr9 LN:141213431
@SQ     SN:chr10        LN:135534747
@SQ     SN:chr11        LN:135006516
@SQ     SN:chr12        LN:133851895
@SQ     SN:chr13        LN:115169878
@SQ     SN:chr14        LN:107349540
@SQ     SN:chr15        LN:102531392
@SQ     SN:chr16        LN:90354753
@SQ     SN:chr17        LN:81195210
@SQ     SN:chr18        LN:78077248
@SQ     SN:chr19        LN:59128983
@SQ     SN:chr20        LN:63025520
@SQ     SN:chr21        LN:48129895
@SQ     SN:chr22        LN:51304566
@SQ     SN:chrX LN:155270560
@SQ     SN:chrY LN:59373566
chr1    1718765 1718881 +       GNB1
chr1    1720487 1720713 +       GNB1
chr1    1721829 1722040 +       GNB1
chr1    1724679 1724755 +       GNB1
chr1    1735853 1736025 +       GNB1
chr1    1737909 1737982 +       GNB1
chr1    1747190 1747306 +       GNB1
chr1    1749271 1749319 +       GNB1
chr1    1756831 1756897 +       GNB1
chr1    27022890        27024036        +       ARID1A
chr1    27056137        27056359        +       ARID1A
chr1    27057638        27058100        +       ARID1A
chr1    27059162        27059288        +       ARID1A
chr1    27087342        27087592        +       ARID1A
chr1    27087870        27087969        +       ARID1A
chr1    27088638        27088815        +       ARID1A
chr1    27089459        27089781        +       ARID1A
chr1    27092707        27092862        +       ARID1A
...


Step 2:
  awk -F"\t" '{print NF}' out_gene_list_out | uniq -c
  ## Get the number of columns; there are 2797 columns for example.
  
  head -1 out_gene_list_out | awk -F"\t" '{for(i=2;i<=2797;i+=2) printf "%s\t",$i ;print ""}' > colnames
  ## Add a tab at the beginning of colnames
  
  awk -F"\t" '{for(i=1;i<=2797;i+=2) printf "%s\t",$i ;print ""}' out_gene_list_out > target_coverage
  
  cat colnames target_coverage > colnames_plus_target_coverage
  ## Copy and transpose paste
  ## Add 'Target_Number' in Cell 1A
  ## Save sheet as rowtarget_colsample.txt
  
  
Step 3:
  perl add_target_details_modified_for_interval_list.pl \
       in_Regions.interval_list \
       rowtarget_colsample.txt \
       rowtarget_colsample_add_target_details.txt
