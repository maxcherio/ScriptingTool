#!/bin/env perl
#
#
# Perl %name: DeltaXML.pl %
# %derived_by: xz2ghk %
# %date_created: 2 Mar 2020 %

use strict;
#use warnings;
no warnings "all";

my @file_buf;

my $directory='..\current';


opendir(my $dir,$directory) or die $!;
while(my $list=readdir($dir)){
	push(@file_buf,$list);
}
closedir($dir);


#foreach my $key(@file_buf){
	#print "key $key\n";
  #};
  
# operators
# read only -<
# write only ->
# append ->>
# read/write -+>
my %Cmpdb;
my %BOM_db;  
my $OutFileP='..\result\report.csv';
my $OutFile='..\result\StubReport.csv';
my $file_previous='..\previous\manifest.xml';
open(FILE,"+<",$file_previous);
while(<FILE>){
	if (($_ =~ /(SWC_([A-Z,0-9]{4})_\w+_DSC).+(refs\/\w+\/.+\"\s+)/))
	  {
	  my $value=$3;
	  my $key=$1;
	  my $ring=$2;

	  $value =~ s/\"\s+//;
	  $BOM_db{$key}=$ring;
	  $Cmpdb{$key}=$value;
	  #print "$key,$Cmpdb{$key}\n";
	  }
	elsif (($_ =~ /(SWC_([A-Z,0-9]{4})_\w+_SRC).+(refs\/\w+\/.+\"\s+)/))  
	  {
	  my $value=$3;
	  my $key=$1;
	  my $ring=$2;

	  $value =~ s/\"\s+//;
	  $BOM_db{$key}=$ring;
	  $Cmpdb{$key}=$value;
	  #print "$key,$Cmpdb{$key}\n";
	  }
	elsif (($_ =~ /(SIG_([A-Z,0-9]{4})_\w+).+(refs\/\w+\/.+\"\s+)/))  
	  {
	  my $value=$3;
	  my $key=$1;
	  my $ring=$2;

	  $value =~ s/\"\s+//;
	  $BOM_db{$key}=$ring;
	  $Cmpdb{$key}=$value;
	  #print "$key,$Cmpdb{$key}\n";
	  }
	else  
	  {
	  #print "$1\n";
	  #my $tmp=$_;
	  #@split(/\s+/,$tmp);
	  #print "$_\n";
	  }
}
close(FILE);  

	  print "CURRENT FILE\n";


my %Cmpdb1;
my %BOM_db1;
  
my $file_current='..\current\manifest.xml';
open(FILE,"+<",$file_current);
while(<FILE>){
	if (($_ =~ /(SWC_([A-Z,0-9]{4})_\w+_DSC).+(refs\/\w+\/.+\"\s+)/))
	  {
	  my $value=$3;
	  my $key=$1;
	  my $ring=$2;
	  
	  $value =~ s/\"\s+//;
	  $BOM_db1{$key}=$ring;
	  $Cmpdb1{$key}=$value;
	  #$BOM_db1{$key}=$ring;
	  #print "$key,$value,$BOM_db1{$key}\n";
	  }
	elsif (($_ =~ /(SWC_([A-Z,0-9]{4})_\w+_SRC).+(refs\/\w+\/.+\"\s+)/))  
	  {
	  my $value=$3;
	  my $key=$1;
	  my $ring=$2;

	  $value =~ s/\"\s+//;
	  $BOM_db1{$key}=$ring;
	  $Cmpdb1{$key}=$value;
	  #print "$key,$Cmpdb1{$key}\n";
	  }
	elsif (($_ =~ /(SIG_([A-Z,0-9]{4})_\w+).+(refs\/\w+\/.+\"\s+)/))  
	  {
	  my $value=$3;
	  my $key=$1;
	  my $ring=$2;

	  $value =~ s/\"\s+//;
	  $BOM_db1{$key}=$ring;
	  $Cmpdb1{$key}=$value;
	  #print "$key,$Cmpdb1{$key}\n";
	  }
	else  
	  {
	  #print "$1\n";
	  #my $tmp=$_;
	  #@split(/\s+/,$tmp);
	  #print "$_\n";
	  }
}
close(FILE);  

#
# STUB PREVIOUS FILE
#
my %Stub_db;
my %Stub_db_ring;
$file_previous='..\previous\Stubs.csv';
open(FILE,"+<",$file_previous);
while(<FILE>){
     if ($_ =~ /(^[A-Z]{1}[a-z,0-9]{1,8}([A-Z,0-9]{4})_\w+),(\w+)/)
       {
       	$Stub_db{$1}=$3;
       	$Stub_db_ring{$1}=$2;
       # print "$1,$Stub_db{$1},$Stub_db_ring{$1}\n";
       }
     elsif($_ =~ /(\w+),(\w+)/)
       {
       	$Stub_db{$1}=$2;
        print "$1,$Stub_db{$1},PRV NO Ring\n";
       }
     else
       {
       }  
       
}
close(FILE);  

#
# STUB CURRENT FILE
#
my %Stub_db1;
my %Stub_db1_ring;
$file_current='..\current\Stubs.csv';
open(FILE,"+<",$file_current);
while(<FILE>){
     if ($_ =~ /(^[A-Z]{1}[a-z,0-9]{1,8}([A-Z,0-9]{4})_\w+),(\w+)/)
       {
       	$Stub_db1{$1}=$3;
       	$Stub_db1_ring{$1}=$2;
        #print "$1,$Stub_db1{$1},$Stub_db1_ring{$1}\n";
       }
     elsif  ($_ =~ /(\w+),(\w+)/)
       {
       	$Stub_db1{$1}=$2;
        print "$1,$Stub_db1{$1},CURR NO Ring\n";
       }
     else
       {
       }  
}
close(FILE);  

#
#
# COMPARE STUB between current and previous
#
#
my @buffer1;
open(STUB_CMP_RESULT,">", "$OutFile" ) or die "$OutFile\n";
print STUB_CMP_RESULT "RING,OBJ,VALUE_CUR,VALUE_PRV,\n"; 
foreach my $obj( sort keys %Stub_db1)
 {
   if (defined $Stub_db{$obj})
     {
     if ($Stub_db{$obj} ne $Stub_db1{$obj})
       {
        push(@buffer1,"$Stub_db1_ring{$obj},$obj,$Stub_db1{$obj},$Stub_db{$obj},");
       }
     else   
       {
        push(@buffer1,"$Stub_db1_ring{$obj},$obj,$Stub_db1{$obj},SameValue,");
       }
     }
   else  
     {
     push(@buffer1,"$Stub_db1_ring{$obj},$obj,$Stub_db1{$obj},NotStub,");
     }
 }

foreach my $obj( sort keys %Stub_db)
 {
   if (!defined $Stub_db1{$obj})
     {
     push(@buffer1,"$Stub_db_ring{$obj},$obj,NotStub,$Stub_db{$obj},");
     }
 }
foreach my $obj( sort @buffer1)
 {
     print STUB_CMP_RESULT "$obj\n"; 
 }

close(STUB_CMP_RESULT);



#
#
# COMPARE COMPONENT between current and previous
#
#

my @buffer;
open(CMP_RESULT,">", "$OutFileP" ) or die "$OutFileP\n";
print CMP_RESULT "RING,CMP OBJ,REVISION,REVISION_PRV,\n"; 

foreach my $obj( sort keys %Cmpdb1)
 {
   if (defined $Cmpdb{$obj})
     {
     if ($Cmpdb1{$obj} ne $Cmpdb{$obj})
       {
 #      print COMR_CMP_RESULT "$obj,$Cmpdb1{$obj},$Cmpdb{$obj},X,X\n";
#        push(@buffer,"$BOM_db1{$obj},$obj,$Cmpdb1{$obj},$Cmpdb{$obj},X,X");
        push(@buffer,"$BOM_db1{$obj},$obj,$Cmpdb1{$obj},$Cmpdb{$obj},");
       }
     else   
       {
 #      print COMR_CMP_RESULT "$obj,$Cmpdb1{$obj},,X,X\n";
       push(@buffer,"$BOM_db1{$obj},$obj,$Cmpdb1{$obj},SameRevision,");
       }
     }
   else  
     {
 #    print COMR_CMP_RESULT "$obj,$Cmpdb1{$obj},,X,,\n"; 
     push(@buffer,"$BOM_db1{$obj},$obj,$Cmpdb1{$obj},NotInUse,");
     }
 }

foreach my $obj( sort keys %Cmpdb)
 {
   if (!defined $Cmpdb1{$obj})
     {
#     print COMR_CMP_RESULT "$obj,,$Cmpdb{$obj},X,\n"; 
     push(@buffer,"$BOM_db{$obj},$obj,NotInUse,$Cmpdb{$obj},");
     }
 }

foreach my $obj( sort @buffer)
 {
     print CMP_RESULT "$obj\n"; 
 }

close(CMP_RESULT);
