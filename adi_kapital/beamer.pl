#!/usr/bin/env perl

use 5.014.0;
use strict; use warnings; use utf8;

use Data::Dumper;

{   my $lines = join '',<>;
    my $errors = 0;
  
    sub escape {
       $lines =~ s/(\$|\&)/\\$1\{\}/g;
    }
    
    sub frames {
	   my $started = 0;
	   my $match = qr/^(\\frametitle\{.+)$/sm;
	   my $begin = "\n\\begin{frame}";
	   my $end = "\n\\end{frame}\n";
	   while($lines =~ $match) {
		  my $title = $1;
		  my $subst = "";
		  if($started) {
			  $subst = $end;
		  }
		  $subst .= $begin . $title;
	      $lines =~ s/$match/$subst/;
	      $started = 1;
	   }
	   $lines .= $end;
	} 
	
	sub section {
	   my ($sign,$command) = @_;
	   my $headliner = quotemeta($sign);
	   my $match = qr/^([^#\\\$=-\~*&\/%].+?)\n(${headliner}+?)\n/m;
	   while($lines =~ $match) {
	      my ($title,$underline) = ($1,$2); chomp($title); $title =~ s/(^\s*|\s*$)//g;
	      chomp($underline);
	      if(abs(length($title)-length($underline))>2) {
	        warn "Überschrift: $title?\n";
	        $errors++;
	      }
	      my $subst = "\n\\" . $command . '{' . $title . '} %' . "\n\n";
	      $lines =~ s/$match/$subst/;
	   }
	}

sub quotes {
   my $match = qr/^(\| )(.*?)((\|\: )(.*?))?\n\s*\n/sm;
   while($lines =~ $match) {
       my ($quote,$info) = ($2,$5);
       $quote =~ s/\| //g;
       my $replace = _quote($quote,$info);
       $lines =~ s/$match/$replace/;
   }
}

sub _quote {
  my ($text,$author) = @_;
  my $code = <<__LATEX__;
  \\begin{minipage}{0.9\\textwidth}
  \\vspace{4ex}
  \\begin{flushright}
  \\begin{minipage}[t]{\\textwidth}
  \\raggedleft{\\footnotesize{\\slshape{$text\\noindent}}}%
__LATEX__
  if($author) {
    $code .= "\n\n". '\\vspace{1.8ex}\\hspace{1.8ex}' .
       '\\footnotesize\\raggedright{' .
       $author . '}' . "\\vspace{1.8ex}%\n";
  }
  $code .= <<__LATEX__;
  \\end{minipage}
  \\end{flushright}
  \\end{minipage}\\hspace{0.1\\textwidth}
__LATEX__
    return $code;
}

sub zitate {
   $lines =~ s/,,/\\tqt{/g;
   # ´´ ist irgendwie schwerer zu ersetzen??
   $lines =~ s/''/}/g;
}

sub italic {
   my $match = qr/_\/(.*?)\/_/;
   my $replace = '\\it{$1}';
   $lines =~ s/$match/\\it{$1}/mg;
}


sub notes {
   my $match = qr/^(\| )(.*?)((\|\: )(.*?))?\n\s*\n/sm;
   while($lines =~ $match) {
       my ($quote,$info) = ($2,$5);
       $quote =~ s/\| //g;
       my $replace = _quote($quote,$info);
       $lines =~ s/$match/$replace/;
   }
}
	
	escape();
	section('=','frametitle');
	section('-','framesubtitle');
	zitate();
	quotes();
        italic();
	frames();
    say $lines;
    exit $errors;
}

__END__



sub itemize {
   my $match = qr/^(-|\*) (.*?)\n\s*\n/sm;
   while($lines =~ $match) {
       my $list = $2;
       $list =~ s/\s*\n\s*/\n/g;
       my @list = grep { !/^(-|\*)$/ } 
           split /\n(-|\*)\s+/,$list;
       my $replace = '\\begin{itemize*}' . "\n\n"; # mdwlist
       $replace .= "\\item " . join("\n\n\\item ",@list) . "\n\n";
       $replace .= '\\end{itemize*}' . "\n\n";
       $lines =~ s/$match/$replace/;
   }
}

sub pagebreak {
   my $match = qr/\s*\\\\\\+\s/;
   my $replace = "\n\\clearpage{}\n";
   $lines =~ s/$match/$replace/mg;
}

sub paragraph {
   my $match = qr/\s*\/\/\/+\s/;
   my $replace = "\n\\paragraph{}\n";
   $lines =~ s/$match/$replace/mg;
}

escape();
pagebreak();
paragraph();
italic();
zitate();
section('#','part');
section('+','chapter');
section('=','section');
section('-','subsection');
section('~','subsubsection');
itemize();
quotes();


   _/italic text/_
