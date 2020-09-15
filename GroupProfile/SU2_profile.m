(* ::Package:: *)

(* ::Input::Initialization:: *)
(* Initialization *)
If[MatchQ[groupList,_List],AppendTo[groupList,SU2],groupList={SU2}];
If[!AssociationQ[tRep],tRep=<||>];
If[!AssociationQ[tOut],tOut=<||>];
If[!AssociationQ[tVal],tVal=<||>];
tVal[SU2]={del2->IdentityMatrix[2],eps2f->LeviCivitaTensor[2],eps2a->LeviCivitaTensor[2],\[Tau]->GellMann[2],del3n->IdentityMatrix[3],eps3n->LeviCivitaTensor[3]};
If[!AssociationQ[tYDcol],tYDcol=<||>];
tYDcol[SU2]=eps2a;
If[!IntegerQ[dummyIndexCount],dummyIndexCount=0];
If[!AssociationQ[tSimp],tSimp=<||>];


(* ::Input::Initialization:: *)
(* Define invariant tensors *)
AppendTo[tAssumptions,del2\[Element]Arrays[{2,2},Reals]];
tRep[del2]={{1},{1}};
tOut[del2]=PrintTensor[<|"tensor"->"\[Delta]","upind"->ToString[#2],"downind"->ToString[#1]|>]&;

AppendTo[tAssumptions,eps2a\[Element]Arrays[{2,2},Reals,Antisymmetric[{1,2}]]];
tRep[eps2a]={{1},{1}};
tOut[eps2a]=PrintTensor[<|"tensor"->"\[Epsilon]","upind"->StringJoin@@ToString/@{#1,#2},"downind"->""|>]&;

AppendTo[tAssumptions,eps2f\[Element]Arrays[{2,2},Reals,Antisymmetric[{1,2}]]];
tRep[eps2f]={{1},{1}};
tOut[eps2f]=PrintTensor[<|"tensor"->"\[Epsilon]","upind"->"","downind"->StringJoin@@ToString/@{#1,#2}|>]&;

AppendTo[tAssumptions,\[Tau]\[Element]Arrays[{3,2,2},Reals]];
tRep[\[Tau]]={{2},{1},{1}};
tOut[\[Tau]]=PrintTensor[<|"tensor"-> PrintTensor[<|"tensor"->"\[Tau]","upind"->ToString[#1],"downind"->""|>],"upind"->ToString[#3],"downind"->ToString[#2]|>]&;

AppendTo[tAssumptions,del3n\[Element]Arrays[{3,3},Reals,Symmetric[{1,2}]]];
tRep[del3n]={{2},{2}};
tOut[del3n]=PrintTensor[<|"tensor"->"\[Delta]","upind"->StringJoin@@ToString/@{#1,#2},"downind"->""|>]&;

AppendTo[tAssumptions,eps3n\[Element]Arrays[{3,3,3},Reals,Antisymmetric[{1,2,3}]]];
tRep[eps3n]={{2},{2},{2}};
tOut[eps3n]=PrintTensor[<|"tensor"->"\[Epsilon]","upind"->StringJoin@@ToString/@{#1,#2,#3},"downind"->""|>]&;


(* ::Input::Initialization:: *)
tSimp[SU2]=Hold[Block[{},
eps2a[x_,y_] eps2f[z_,y_]:=del2[x,z];
eps2a[x_,y_] eps2f[y_,z_]:=-del2[x,z];
eps2a[x_,y_] eps2f[w_,z_]:=del2[x,w] del2[y,z]-del2[x,z] del2[y,w];
del2[i_,j_]del2[j_,k_]:=del2[i,k];
del2[i_,i_]:=2;
del3n[i_,i_]:=3;
del2[a_,c_]\[Tau][J_,a_,b_]:=\[Tau][J,c,b];
del2[c_,a_]\[Tau][J_,b_,a_]:=\[Tau][J,b,c];
\[Tau][i_,j_,j_]:=0;
\[Tau][i_,j_,k_]\[Tau][l_,k_,m_]:=Module[{},dummyIndexCount++;I eps3n[i,l,dummyIndex[dummyIndexCount]]\[Tau][dummyIndex[dummyIndexCount],j,m]+del3n[i,l]del2[m,j]];
eps3n[i_,j_,k_]eps3n[l_,m_,n_]=Det@Map[Apply[del3n], Partition[Distribute[{{i,j,k},{l,m,n}},List],3],{2}];
del3n[a_,d_]eps3n[a_,b_,c_]:=eps3n[d,b,c];
del3n[a_,d_]eps3n[b_,a_,c_]:=eps3n[b,d,c];
del3n[a_,d_]eps3n[c_,b_,a_]:=eps3n[c,b,d];
del3n[a_,c_]del3n[a_,b_]:=del3n[c,b];
eps2f[i_,j_]del[2][i_,k_]:=eps2f[k,j];
eps2f[i_,j_]del[2][j_,k_]:=eps2f[i,k];
eps2a[i_,j_]del[2][k_,i_]:=eps2a[k,j];
eps2a[i_,j_]del[2][k_,j_]:=eps2a[i,k];
]]


(* ::Input:: *)
(*(* invariant tensor simplification *)*)
(*Unprotect[Times];*)
(*Clear[Times];*)
(*dummyIndexCount=0;*)
(*eps2a[x_,y_] eps2f[z_,y_]:=del2[x,z];*)
(*eps2a[x_,y_] eps2f[y_,z_]:=-del2[x,z];*)
(*eps2a[x_,y_] eps2f[w_,z_]:=del2[x,w] del2[y,z]-del2[x,z] del2[y,w];*)
(*del2[i_,j_]del2[j_,k_]:=del2[i,k];*)
(*del2[i_,i_]:=2;*)
(*del3n[i_,i_]:=3;*)
(*del2[a_,c_]\[Tau][J_,a_,b_]:=\[Tau][J,c,b];*)
(*del2[c_,a_]\[Tau][J_,b_,a_]:=\[Tau][J,b,c];*)
(*\[Tau][i_,j_,j_]:=0;*)
(*\[Tau][i_,j_,k_]\[Tau][l_,k_,m_]:=Module[{},dummyIndexCount++;I eps3n[i,l,dummyIndex[dummyIndexCount]]\[Tau][dummyIndex[dummyIndexCount],j,m]+del3n[i,l]del2[m,j]];*)
(*eps3n[i_,j_,k_]eps3n[l_,m_,n_]=Det@Map[Apply[del3n], Partition[Distribute[{{i,j,k},{l,m,n}},List],3],{2}];*)
(*del3n[a_,d_]eps3n[a_,b_,c_]:=eps3n[d,b,c]*)
(*del3n[a_,d_]eps3n[b_,a_,c_]:=eps3n[b,d,c]*)
(*del3n[a_,d_]eps3n[c_,b_,a_]:=eps3n[c,b,d]*)
(*del3n[a_,c_]del3n[a_,b_]:=del3n[c,b]*)
(*eps2f[i_,j_]del[2][i_,k_]:=eps2f[k,j];*)
(*eps2f[i_,j_]del[2][j_,k_]:=eps2f[i,k];*)
(*eps2a[i_,j_]del[2][k_,i_]:=eps2a[k,j];*)
(*eps2a[i_,j_]del[2][k_,j_]:=eps2a[i,k];*)
(*Protect[Times];*)


(* ::Input::Initialization:: *)
ConvertToFundamental[model_,groupname_,{0}]:=If[CheckGroup[model,groupname]==SU2,1,Message[ConvertToFundamental::name,groupname,{1}]]
ConvertToFundamental[model_,groupname_,{1}]:=If[CheckGroup[model,groupname]==SU2,{1,eps2f[a[1],aa[1]]},Message[ConvertToFundamental::name,groupname,{1}]]
ConvertToFundamental[model_,groupname_,{2}]:=If[CheckGroup[model,groupname]==SU2,dummyIndexCount++;
\[Tau][A[1],aa[1],dummyIndex[dummyIndexCount]]eps2f[dummyIndex[dummyIndexCount],aa[2]],Message[ConvertToFundamental::name,groupname,{2}]]
