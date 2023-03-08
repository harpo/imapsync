#!/usr/bin/perl -w -s

use strict;
use threads;
our @a;
our $c = 0;
our $logdir = "/LOGDIR";
my $total = $#ARGV + 1;
#our $listdir = $ARGV[0];

unless ($total >= 1){
print "Fehlende Verzeichnisangabe zu den Userlisten! \n";
exit;
}

our $listdir = $ARGV[0];
#print "Listdir: $listdir \n Total: $total \n";
print "Folgende Userlisten werden gesynct:\n";

openUserlist();

# Define the number of threads
my $num_of_threads = 4;

# use the initThreads subroutine to create an array of threads.
my @threads = initThreads();


# Loop through the array:
foreach(@threads){
                # Tell each thread to perform our 'doOperation()' subroutine.
                $_ = threads->create(\&doOperation);
                $c++;
                sleep(1);
}

# This tells the main program to keep running until all threads have finished.
foreach(@threads){
        $_->join();
}

print "\nProgram Done!\nPress Enter to exit";
$a = <>;

####################### SUBROUTINES ############################
sub initThreads{
        my @initThreads;
        for(my $i = 1;$i<=$num_of_threads;$i++){
                push(@initThreads,$i);
        }
        return @initThreads;
}
sub doOperation{
        # Get the thread id. Allows each thread to be identified.
        my $id = threads->tid();
#foreach my $a (@a){

#print "found $a !\n";
#}

        chdir('/root/') or die "$!";
        my $list = $a[$c];
#       my $output = qx(./sync.sh /root/syncscript/test/$list > /root/syncscript/test/$list.log 2> /root/syncscript/test/$list.error.log );
        my $output = qx(./sync.sh $listdir/$list > $logdir/$list.log 2> $logdir/$list.error.log );
        print "Thread $id done! List: $list\n";
        # Exit the thread
        threads->exit();
}


sub openUserlist {

opendir my $DIR, './prod' or die "Can't open the current directory: $!\n";
my @names = readdir $DIR or die "Unable to read current dir:$!\n";
closedir $DIR;
my $name;
#our @a;
foreach my $name (@names) {
#print "Name:  $name\n";
next if ($name eq '.');
next if ($name eq '..');
if ($name =~ m/list$/i) {
#print "found $name !\n";
push (@a, "$name");
}
}
foreach my $a (@a){

print "Liste gefunden: $a \n";
}
@a
}


