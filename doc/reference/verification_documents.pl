:- use_package([assertions]).

:- doc(filetype, documentation).

:- doc(title, "Creating Verification Documents using LPdoc").

:- doc(module,"
@cindex{playground, direct access}
@cindex{playground, runnable examples}
@cindex{runnable examples}
 
@section{Adding CiaoPP static content to documents}

Static examples generated by @apl{CiaoPP} can be easily incorporated into documents
including in the source files calls with the program to be analyzed,
suitable filters and @apl{CiaoPP} flags. To include
these calls, we have supplemented a plugin for @apl{LPdoc} that recognizes a
command with syntax:
 @tt{@@}@em{exfilter}@tt{@{}@var{Code}@tt{@}@{}@var{Action}, @var{FlagsValues}, @var{Filters}@tt{@}}.

For instance, consider the @pred{app/3} program:
 
```ciao
:- module(_,app/3,[assertions]).

:- pred app(Xs, Ys, Zs) : ( list(Xs), list(Ys) ) => list(Zs) .
  
app([],     Ys, Ys).
app([X|Xs], Ys, [X|Zs]) :-
  app(Xs, Ys, Zs).
``` 

where the @tt{pred} assertion indicates how @pred{app/3} should be called
in this program. We would like to display the part of the analysis output
that shows if the assertion has been checked. 
This fragment can be generated by including in the source file the following code:

@begin{verbatim}
@exfilter{app.pl}{V,output=on,filter=check_pred}
@end{verbatim} 
  
This command is composed of the file that we are looking to filter (@tt{app.pl}),
the analysis and the filter options that we want  applied
(@tt{V},@tt{output=on},@tt{filter=check_pred}). The result is:

@exfilter{app.pl}{V,output=on,filter=check_pred}
  
@subsection{CiaoPP/filters options}
Usage:
  @tt{@@}@em{exfilter }@tt{@{}@var{Code }@tt{@}@{}@var{Action}, @var{FlagsValues}, @var{Filters}@tt{@}}.

@subsubsection{CiaoPP flags and actions}
@var{Action} must be one of the following:
@begin{itemize}
@item @bf{A} : Analyzes the code program.
@item @bf{O} : Optimizes the code program.
@item @bf{V} : Verifies the assertions of the code program.
@end{itemize}
@var{FlagsValues} is a list of options @var{FlagName}=@var{FlagValue}
where @var{FlagName} is a valid @apl{CiaoPP} flag name.
This list is optional and
the flags not included in this list will be assumed to take
their default value. The most commonly used flags are:
@begin{verbatim}
Title (FlagName) :                 list of possible FlagValue (default value) ?
-------------------------------------------------------------------------------
Aliasing/Modes Analysis (modes) :  [none, pd, pdb, def, gr, null, share, 
                                   shareson, shfr, shfrson, shfrnv, son, 
                                   share_amgu, share_clique, share_clique_1, 
                                   share_clique_def, sharefree_amgu, 
                                   shfrlin_amgu, sharefree_clique, 
                                   sharefree_clique_def, aeq, depthk, path, 
                                   difflsign, fr, frdef] (shfr) ? 
Shapes/Types Analysis (types) :    [none, eterms, ptypes, svterms, terms, 
                                   deftypes] (eterms) ? 
Determinism Analysis (ana_det) :   [none, det, nfdet] (none) ? 
Non-failure Analysis (ana_nf) :    [none, nf, nfg, nfdet] (none) ? 
Numeric Analysis(ana_num) :        [none, polyhedra, nonrel_finterval, lsign]
                                   (none) ? 
Cost Analysis (ana_cost) :         [none, steps_ub, steps_lb, steps_ualb, 
                                   steps_o, resources, res_plai] (none) ? 
Test assertions (testing) :        [on, off] (off) ?
   | Run test assertions (run_utests) :                [on, off] (off) ?       
   | Generate tests from check assertions (test_gen) : [on, off] (off) ? 
Generate output (output) :         [on, off] (on) ?
@end{verbatim}

@subsubsection{Filters}
@var{Filters} is composed of an option @tt{filter}=@var{Filter} and
an optional list of supplementary filters.
@var{Filter} must be one of the following:
@begin{itemize}
@item @bf{all} : keep all data.
@item @bf{tpred} : all @tt{true} (predicate) assertions.
@item @bf{tpred_plus} : all @tt{true} assertions including  @em{comp} properties.
@item @bf{tpred_regtype} : all @tt{true} assertions and all @em{regtypes}.
@item @bf{regtype} : only all @em{regtypes} definitions.
@item @bf{warnings} : all warning messages
@item @bf{error} : all error messages.
@item @bf{check_pred} : all @tt{check} assertions, @tt{false} assertions and @tt{checked} assertions.
@item @bf{warn_error} : all warning and error messages.
@item @bf{test} : all tests.
@end{itemize}
Include these options with one of the filters for more precise results.
@begin{itemize}
@item  @tt{name}=@var{Pred} : results of a specific predicate, with `Pred` being the predicate.
@item  @tt{assertion}=[@var{Terms}] : assertions that contain a series of terms, where `Terms` is the list of terms to be matched.
@item  @tt{comments}=@tt{on} : If we add this option together with the filter @tt{check_pred} then the comments of the assertions will be added as well.
@item  @tt{absdomain}=@var{AD} : @var{AD} can be types or can be modes. We have to add this option together with filter  @tt{tpred}, @tt{tpred_regtype} or @tt{tpred_plus} to obtain the assertions related to the types or modes.
@end{itemize}

@subsubsection{Example Usage}
The following are very simple examples of use:
@begin{itemize}
@item Run analyse on @tt{app.pl} file with default options and obtain the true assertions related to types:

@begin{verbatim}
@exfilter{app.pl}{A,filter=tpred,absdomain=types}
@end{verbatim}

Output result:
@exfilter{app.pl}{A,filter=tpred,absdomain=types}

@item Setting a cost domain and extracting the true assertions including comp properties:

@begin{verbatim}
@exfilter{app.pl}{A,ana_cost=resources,filter=tpred_plus}
@end{verbatim}

Output result:
@exfilter{app.pl}{A,ana_cost=resources,filter=tpred_plus}

@item Setting a cost domain and extracting the @tt{true} assertions including comp properties, but only
the assertion of the upper bound analysis:

@begin{verbatim}
@exfilter{app.pl}{A,ana_cost=resources,assertion=[ub],filter=tpred_plus}
@end{verbatim}

Output result:
@exfilter{app.pl}{A,ana_cost=resources,assertion=[ub],filter=tpred_plus}
@end{itemize}
@section{Adding CiaoPP editable and embedded content to documents}

 
@apl{LPdoc} includes specific commands for embedding editable and runnable code in place.
For example, in this exercise we want the user to correct the singleton variable written in the
base case of predicate @pred{app/3}:
 
```ciao_runnable
:- module(_,app/3,[assertions]).
%! \\begin{code}
app([],     Ys, Yss).
app([X|Xs], Ys, [X|Zs]) :-
  app(Xs, Ys, Zs).   
%! \\end{code}
%! \\begin{opts}
solution=errors,message=singleton
%! \\end{opts}
%! \\begin{solution}
app([],     Ys, Ys).
app([X|Xs], Ys, [X|Zs]) :-
  app(Xs, Ys, Zs).

% In our case, we type Yss instead of Ys.
%! \\end{solution}
```
When users submit their answers, the playground will return appropriate feedback
showing the error messages related to the singleton variables.
We have defined lpdoc-style commands which mark different parts of the program.
The playground identifies the different parts and classifies them. For example,
the playground will recognize a solution, a set of filters that we want to apply,
and the part of the interactive code that will be shown in the documentation.
In this case, the solution will be shown only when the @key{Show solution} button is clicked. The code part is always visible. Hence, the previous exercise can be generated
by including in the source file the following code:
@begin{verbatim} 
` ` ` ciao_runnable
:- module(_,app/3,[assertions]).
%! \\begin{code}
app([],     Ys, Yss).
app([X|Xs], Ys, [X|Zs]) :-
  app(Xs, Ys, Zs).   
%! \\end{code}
%! \\begin{opts}
solution=errors,message=singleton
%! \\end{opts}
%! \\begin{solution}
app([],     Ys, Ys).
app([X|Xs], Ys, [X|Zs]) :-
  app(Xs, Ys, Zs).

% In our case, we type Yss instead of Ys.
%! \\end{solution}
` ` ` 
@end{verbatim}


@subsection{Modes of interactive exercises}
For the inclusion of exercises in the documentation three distinct modes of exercises have been developed:
@begin{itemize}
@item @tt{solution=equal} : Prints out the clauses from the user's answer that do not match with
the file that contains the solution. It takes care of trivial differences
such as different variable names and different formatting of the code in the files.

@item @tt{solution=errors} : Another task is to find bugs in a program and fix them. Users submit
their solutions and the filter checks them. If there are none then the program
has been corrected successfully.
Additionally, a message filter has been created to extract a message or messages
by a certain term.

@item @tt{solution=verify_assert} : Analysis information allows us to conclude that the program
is incorrect or incomplete, i.e., that the program does not satisfy the
requirements. The idea is that given the solution of the user, the filter checks if the
user's program verifies the assertions (specifications).
@end{itemize}

@subsubsection{Example Usage}
@begin{cartouche}
@bf{Example 1. }@em{What is the correct assertion?}
```ciao_runnable
%! \\begin{code}
:- module(_, [app/3], [assertions]).

:- pred app(A,B,C) : (list(A), list(B)) => var(C).

app([],Y,Y).
app([X|Xs], Ys, [X|Zs]) :-
    app(Xs,Ys,Zs).  
%! \\end{code}
%! \\begin{opts}
solution=verify_assert
%! \\end{opts}  
%! \\begin{solution}
:- module(_, [app/3], [assertions]).

:- pred app(A,B,C) : (list(A), list(B)) => list(C).

app([],Y,Y). 
app([X|Xs], Ys, [X|Zs]) :-
    app(Xs,Ys,Zs).   
%! \\end{solution}
```
@end{cartouche}

Can be generated by including in the source file the following code:
@begin{verbatim}
` ` ` ciao_runnable
:- module(_, [app/3], [assertions]).

:- pred app(A,B,C) : (list(A), list(B)) => var(C).

app([],Y,Y).
app([X|Xs], Ys, [X|Zs]) :-
    app(Xs,Ys,Zs).  
%! \\end{code}
%! \\begin{opts}
solution=verify_assert
%! \\end{opts}  
%! \\begin{solution}
:- module(_, [app/3], [assertions]).

:- pred app(A,B,C) : (list(A), list(B)) => list(C).

app([],Y,Y). 
app([X|Xs], Ys, [X|Zs]) :-
    app(Xs,Ys,Zs).   
%! \\end{solution}
` ` `
@end{verbatim}

Note that you can also generate interactive examples, for example:
```ciao_runnable
%! \\begin{code}
:- module(_,app/3,[assertions]).

:- pred app(Xs, Ys, Zs) : ( list(Xs), list(Ys) ) => list(Zs) .
  
app([],     Ys, Ys).
app([X|Xs], Ys, [X|Zs]) :-
  app(Xs, Ys, Zs).
%! \\end{code}
%! \\begin{opts}
A,ana_det=nfdet,filter=tpred_plus
%! \\end{opts}  
``` 
This block runs analysis on the program with a determinism domain and displays
the @tt{true} assertions including  @em{comp} properties. In this case, the analysis and
the filtering method are executed directly from the browser.
@section{Full page example}

The following pointers provide a complete example of a class exercise
that uses embedded code, showing the full source and the full output:

@begin{itemize}
@item This is the [source of the page (written in this case in LPdoc)]()
@item and this is the [result produced by LPdoc]().
@end{itemize}
  
").