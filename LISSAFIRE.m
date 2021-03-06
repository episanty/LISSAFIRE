(* ::Package:: *)

(************************************************************************)
(* This file was generated automatically by the Mathematica front end.  *)
(* It contains Initialization cells from a Notebook file, which         *)
(* typically will have the same name as this file except ending in      *)
(* ".nb" instead of ".m".                                               *)
(*                                                                      *)
(* This file is intended to be loaded into the Mathematica kernel using *)
(* the package loading commands Get or Needs.  Doing so is equivalent   *)
(* to using the Evaluate Initialization Cells menu command in the front *)
(* end.                                                                 *)
(*                                                                      *)
(* DO NOT EDIT THIS FILE.  This entire file is regenerated              *)
(* automatically each time the parent Notebook file is saved in the     *)
(* Mathematica front end.  Any changes you make to this file will be    *)
(* overwritten.                                                         *)
(************************************************************************)



(* ::Input::Initialization:: *)
(* LISSAFIRE: Lissajous-figure Reconstruction for nonlinear polarization tomography of bichromatic fields. *)
(* \[Copyright] Emilio Pisanty, 2019 *)

(* For more information,see https://github.com/episanty/LISSAFIRE *)


(* ::Input::Initialization:: *)
BeginPackage["LISSAFIRE`"];


(* ::Input::Initialization:: *)
$LISSAFIREversion::usage="$LISSAFIREversion prints the current version of the LISSAFIRE package in use and its timestamp.";
$LISSAFIREtimestamp::usage="$LISSAFIREtimestamp prints the timestamp of the current version of the LISSAFIRE package.";
Begin["`Private`"];
$LISSAFIREversion:="LISSAFIRE v1.0.1, "<>$LISSAFIREtimestamp;
End[];


(* ::Input::Initialization:: *)
Begin["`Private`"];$LISSAFIREtimestamp="Wed 20 Jan 2021 17:57:04";End[];


(* ::Input::Initialization:: *)
$LISSAFIREdirectory::usage="$LISSAFIREdirectory is the directory where the current LISSAFIRE package instance is located.";


(* ::Input::Initialization:: *)
Begin["`Private`"];
With[{softLinkTestString=StringSplit[StringJoin[ReadList["! ls -la "<>StringReplace[$InputFileName,{" "->"\\ "}],String]]," -> "]},
If[Length[softLinkTestString]>1,(*Testing in case $InputFileName is a soft link to the actual directory.*)
$LISSAFIREdirectory=StringReplace[DirectoryName[softLinkTestString[[2]]],{" "->"\\ "}],
$LISSAFIREdirectory=StringReplace[DirectoryName[$InputFileName],{" "->"\\ "}];
]];
End[];


(* ::Input::Initialization:: *)
$LISSAFIREcommit::usage="$LISSAFIREcommit returns the git commit log at the location of the LISSAFIRE package if there is one.";
$LISSAFIREcommit::OS="$LISSAFIREcommit has only been tested on Linux.";


(* ::Input::Initialization:: *)
Begin["`Private`"];
$LISSAFIREcommit:=(If[$OperatingSystem!="Unix",Message[$LISSAFIREcommit::OS]];
StringJoin[Riffle[ReadList["!cd "<>$LISSAFIREdirectory<>" && git log -1",String],{"\n"}]]);
End[];


(* ::Input::Initialization:: *)
UnitE::usage="UnitE[1] and UnitE[-1] return, respectively, \!\(\*FractionBox[\(1\), SqrtBox[\(2\)]]\){1,\[ImaginaryI]} and \!\(\*FractionBox[\(1\), SqrtBox[\(2\)]]\){1,-\[ImaginaryI]}.";
Begin["`Private`"];
UnitE[1]=1/Sqrt[2] {1,I};
UnitE[-1]=1/Sqrt[2] {1,-I};
End[];


(* ::Input::Initialization:: *)
EnsureRightCircularFundamental::usage="EnsureRightCircularFundamental[{E1p,E1m,E2p,E2m}] ensures that the fundamental has right-circular polarization (i.e. |E1p|>|E1m|) by swapping the input to {E1m\[Conjugate],E1p\[Conjugate],E2m\[Conjugate],E2p\[Conjugate]} if necessary."; 

Begin["`Private`"];
EnsureRightCircularFundamental[{E1p_,E1m_,E2p_,E2m_}]:=If[
Abs[E1p]>Abs[E1m],
{E1p,E1m,E2p,E2m},
{E1m\[Conjugate],E1p\[Conjugate],E2m\[Conjugate],E2p\[Conjugate]}
]
End[];


(* ::Input::Initialization:: *)
PhaseNormalization::usage="PhaseNormalization[{E1p,E1m,E2p,E2m}] Normalizes the field phases so that E1p is real and positive, by multiplying by an appropriate factor of \!\(\*SuperscriptBox[\(\[ExponentialE]\), \(\(-\[ImaginaryI]\)\\\ \[Phi]\)]\) on E1 and \!\(\*SuperscriptBox[\(\[ExponentialE]\), \(\(-2\) \[ImaginaryI]\\\ \[Phi]\)]\) on E2."; 

Begin["`Private`"];
PhaseNormalization[{E1p_,E1m_,E2p_,E2m_}]:=With[{\[Phi]=Arg[E1p]},
Chop[Times[
{E^(-I \[Phi]),E^(-I \[Phi]),E^(-2I \[Phi]),E^(-2I \[Phi])},
{E1p,E1m,E2p,E2m}
]]
]
End[];


(* ::Input::Initialization:: *)
NLPTOutcomes::usage="NLPTOutcomes[{ReE1p,ImE1p,ReE1m,ImE1m,ReE2p,ImE2p,ReE2m,ImE2m}] Calculates the Nonlinear Polarization Tomography outcome functions \!\(\*SubscriptBox[\(I\), \(n\)]\), as defined in the paper, with the normalization set so that the \[ScriptL]>0 components of the paper are given by \!\(\*SubsuperscriptBox[\(I\), \(\[ScriptL]\), \(paper\)]\)(\[Theta])=Re(2\!\(\*SubscriptBox[\(I\), \(\[ScriptL]\)]\)\!\(\*SuperscriptBox[\(\[ExponentialE]\), \(\[ImaginaryI]\\\ \[ScriptL]\\\ \[Theta]\)]\)).

NLPTOutcomes[{E1p,E1m,E2p,E2m}] Uses explicit complex amplitudes.";

Begin["`Private`"];

NLPTOutcomes[{ReE1p_,ImE1p_,ReE1m_,ImE1m_,ReE2p_,ImE2p_,ReE2m_,ImE2m_}]=Block[{u,E1,E2,E1p,E1m,E2p,E2m},
u={Cos[\[Theta]],Sin[\[Theta]]};
E1=UnitE[1]E1p+UnitE[-1]E1m;
E2=UnitE[1]E2p+UnitE[-1]E2m;

Table[
Expand[
Coefficient[
TrigToExp[
1/2 ((u.E1\[Conjugate])^2+u.E2\[Conjugate])((u.E1)^2+u.E2)
]/.{\[Theta]->1/I Log[eI\[Theta]]}
,eI\[Theta],n]/.{
E1p->ReE1p+I ImE1p,
E1m->ReE1m+I ImE1m,
E2p->ReE2p+I ImE2p,
E2m->ReE2m+I ImE2m
}/.{
Conjugate[symbol_?AtomQ]->symbol
}
]
,{n,0,4}
]
];

NLPTOutcomes[{E1p_,E1m_,E2p_,E2m_}]:=NLPTOutcomes[{Re[E1p],Im[E1p],Re[E1m],Im[E1m],Re[E2p],Im[E2p],Re[E2m],Im[E2m]}]

End[];


(* ::Input::Initialization:: *)
ReconstructionMimimizationTarget::usage="ReconstructionMimimizationTarget[{I0,I1,I2,I3,I4}][ReE1p,ImE1p,ReE1m,ImE1m,ReE2p,ImE2p,ReE2m,ImE2m] calculates the reconstruction target \!\(\*FormBox[\(\*UnderoverscriptBox[\"\[Sum]\", 
RowBox[{\"n\", \"=\", \"0\"}], \"4\",\nLimitsPositioning->True]\(\(|\)\(\*SubscriptBox[\(I\), \(n\)] - \*SubscriptBox[\(I\), \(n\)](E)\)\*SuperscriptBox[\(|\), \(2\)]\)\),
TraditionalForm]\), i.e. the sum of squares of the nonlinear-polarimetry Fourier coefficients in difference between the given \!\(\*SubscriptBox[\(I\), \(n\)]\) and those reconstructed from the given complex fields.";


Begin["`Private`"];

ReconstructionMimimizationTarget[{I0_,I1_,I2_,I3_,I4_}][ReE1p_,ImE1p_,ReE1m_,ImE1m_,ReE2p_,ImE2p_,ReE2m_,ImE2m_]=Block[{u,E1,E2,E1p,E1m,E2p,E2m},
u={Cos[\[Theta]],Sin[\[Theta]]};
E1=UnitE[1]E1p+UnitE[-1]E1m;
E2=UnitE[1]E2p+UnitE[-1]E2m;

Total[Flatten[
Table[
(
Simplify[
ReIm[
NLPTOutcomes[{ReE1p,ImE1p,ReE1m,ImE1m,ReE2p,ImE2p,ReE2m,ImE2m}][[n+1]]-{I0,I1,I2,I3,I4}[[n+1]]
]
,Assumptions->{{ReE1p,ImE1p,ReE1m,ImE1m,ReE2p,ImE2p,ReE2m,ImE2m}\[Element]Reals,I0\[Element]Reals}
]
)^2
,{n,0,4}
]]
]
];

End[];


(* ::Input::Initialization:: *)
Options[ReconstructBicircularFieldList]=Join[{SortingFunction->Function[#["Residual"]],SelectionFunction->Function[True],Parallelize->False},Options[FindMinimum]];
Options[ReconstructBicircularField]=Options[ReconstructBicircularFieldList];

SortingFunction::usage="SortingFunction is an option for ReconstructBicircularField and ReconstructBicircularFieldList that specifies a function (applied to the results of the form \[LeftAssociation]\"Fields\"\[Rule]{\!\(\*SubscriptBox[\(E\), \(\(1\)\(+\)\)]\),\!\(\*SubscriptBox[\(E\), \(\(1\)\(-\)\)]\),\!\(\*SubscriptBox[\(E\), \(\(2\)\(+\)\)]\),\!\(\*SubscriptBox[\(E\), \(\(2\)\(-\)\)]\)},\"Outcomes\"\[Rule]{\!\(\*SubscriptBox[\(I\), \(0, rec\)]\),\!\(\*SubscriptBox[\(I\), \(1, rec\)]\),\!\(\*SubscriptBox[\(I\), \(2, rec\)]\),\!\(\*SubscriptBox[\(I\), \(3, rec\)]\),\!\(\*SubscriptBox[\(I\), \(4, rec\)]\)},\"\!\(\*SqrtBox[\(Residual\)]\)\"\[Rule]r,\"Residual\"\[Rule]\!\(\*SuperscriptBox[\(r\), \(2\)]\)\[RightAssociation]) used to sort the individual minima.";
SelectionFunction::usage="SelectionFunction is an option for ReconstructBicircularField and ReconstructBicircularFieldList that specifies a function (applied to the results of the form \[LeftAssociation]\"Fields\"\[Rule]{\!\(\*SubscriptBox[\(E\), \(\(1\)\(+\)\)]\),\!\(\*SubscriptBox[\(E\), \(\(1\)\(-\)\)]\),\!\(\*SubscriptBox[\(E\), \(\(2\)\(+\)\)]\),\!\(\*SubscriptBox[\(E\), \(\(2\)\(-\)\)]\)},\"Outcomes\"\[Rule]{\!\(\*SubscriptBox[\(I\), \(0, rec\)]\),\!\(\*SubscriptBox[\(I\), \(1, rec\)]\),\!\(\*SubscriptBox[\(I\), \(2, rec\)]\),\!\(\*SubscriptBox[\(I\), \(3, rec\)]\),\!\(\*SubscriptBox[\(I\), \(4, rec\)]\)},\"\!\(\*SqrtBox[\(Residual\)]\)\"\[Rule]r,\"Residual\"\[Rule]\!\(\*SuperscriptBox[\(r\), \(2\)]\)\[RightAssociation], and returning True or False) used to keep or discard potential solutions.";
Protect[SortingFunction,SelectionFunction];


ReconstructBicircularFieldList::usage="ReconstructBicircularFieldList[{I0,I1,I2,I3,I4}] calculates a list of candidate reconstructed fields (each an Association of the form \[LeftAssociation]\"Fields\"\[Rule]{\!\(\*SubscriptBox[\(E\), \(\(1\)\(+\)\)]\),\!\(\*SubscriptBox[\(E\), \(\(1\)\(-\)\)]\),\!\(\*SubscriptBox[\(E\), \(\(2\)\(+\)\)]\),\!\(\*SubscriptBox[\(E\), \(\(2\)\(-\)\)]\)},\"Outcomes\"\[Rule]{\!\(\*SubscriptBox[\(I\), \(0, rec\)]\),\!\(\*SubscriptBox[\(I\), \(1, rec\)]\),\!\(\*SubscriptBox[\(I\), \(2, rec\)]\),\!\(\*SubscriptBox[\(I\), \(3, rec\)]\),\!\(\*SubscriptBox[\(I\), \(4, rec\)]\)},\"\!\(\*SqrtBox[\(Residual\)]\)\"\[Rule]r,\"Residual\"\[Rule]\!\(\*SuperscriptBox[\(r\), \(2\)]\)\[RightAssociation]), obtained by minimizing ReconstructionMimimizationTarget over a list of random initial seeds pulled from a box of side 1.

ReconstructBicircularFieldList[{I0,I1,I2,I3,I4},Erange] uses a box of side Erange (which can be a single number, or a list of eight real numbers to be used as the sizes of the boxes for {ReE1p,ImE1p,ReE1m,ImE1m,ReE2p,ImE2p,ReE2m,ImE2m}) for the initial seeds of the minimization.

ReconstructBicircularFieldList[{I0,I1,I2,I3,I4},Erange,iterations] uses the specified number of iterations.";


ReconstructBicircularField::usage="ReconstructBicircularField[{I0,I1,I2,I3,I4}] returns the first element of the corresponding ReconstructBicircularFieldList, using the specified (or default) SortingFunction.

ReconstructBicircularField[{I0,I1,I2,I3,I4},Erange] returns the first element of the corresponding ReconstructBicircularFieldList, using the specified (or default) SortingFunction.

ReconstructBicircularField[{I0,I1,I2,I3,I4},Erange,iterations] returns the first element of the corresponding ReconstructBicircularFieldList, using the specified (or default) SortingFunction.";


Begin["`Private`"];

ReconstructBicircularField[{I0_,I1_,I2_,I3_,I4_},Erange_:1,iterations_:20,options:OptionsPattern[]]:=First[
ReconstructBicircularFieldList[{I0,I1,I2,I3,I4},Erange,iterations,options]
]

ReconstructBicircularFieldList[{I0_,I1_,I2_,I3_,I4_},Erange_:1,iterations_:20,options:OptionsPattern[]]:=Block[{},

SortBy[
Select[
If[OptionValue[Parallelize]==True,Parallelize,#&]@Table[
Function[solution,Block[{fields},
fields=PhaseNormalization[
EnsureRightCircularFundamental[
{ReE1p+I ImE1p,ReE1m+I ImE1m,ReE2p+I ImE2p,ReE2m+I ImE2m}/.solution[[2]]
]];
<|"Fields"->fields,"Outcomes"->NLPTOutcomes[fields],"\!\(\*SqrtBox[\(Residual\)]\)"->Sqrt[solution[[1]]],"Residual"->solution[[1]]|>
]
][
FindMinimum[
ReconstructionMimimizationTarget[{I0,I1,I2,I3,I4}][ReE1p,ImE1p,ReE1m,ImE1m,ReE2p,ImE2p,ReE2m,ImE2m],
Transpose[{
{ReE1p,ImE1p,ReE1m,ImE1m,ReE2p,ImE2p,ReE2m,ImE2m},
Erange RandomReal[{-1,1},8]
}],
Method->{"Newton",StepControl->"TrustRegion"},
Evaluate[Sequence@@FilterRules[{options},Options[FindMinimum]]]
]
]
,{iterations}]
,OptionValue[SelectionFunction]]
,OptionValue[SortingFunction]]
]

End[];


(* ::Input::Initialization:: *)
EndPackage[];


(* ::Input::Initialization:: *)
DistributeDefinitions["LISSAFIRE`"];
