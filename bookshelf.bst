%%%
%%% Create a list of commands from bibtex entries.
%%% Each command is \makebook{author}{title}
%%%

ENTRY {
    author
    title
  }{}{}

INTEGERS { nameptr namesleft numnames }

STRINGS { s }
  
FUNCTION {preamble} {}

FUNCTION { format.names }
{

  's :=
  s num.names$ 'numnames :=
  numnames #3 >
    {#3 'namesleft :=}
    {numnames 'namesleft :=}
  if$
  #1 'nameptr :=               
  { namesleft }
    {
      s nameptr "{ff{ } }{vv{ } }{ll{ }}{, jj}" format.name$
      namesleft #1 >
	{ " \& " *}
	{}
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
      *
    }
    while$
  numnames #3 >
    {" et~al" *}
    {}
  if$
}

FUNCTION {book} {
  "\makebook{" author format.names  "}{" * title * "}%" * write$
  newline$
}

FUNCTION {misc} {book}

FUNCTION { default.type } { book }

READ
ITERATE{call.type$}
