use "C:\Users\vitor\Documents\Mestrado Econometria\2º Semestre\Microeconometria I\Trabalho 1\t1.1.dta" 
xtset schid year, yearly
xtsum math4 lunch exppp cpi rexppp lrexpp
tab year, gen(y)
reg math4 lunch exppp lrexpp y95- y98, vce(cluster schid)
reg math4 lunch lrexpp small y95- y98, vce(cluster schid)
estimates store beta_POLS
** Random Effects
xtreg math4 lunch lrexpp small y95- y98, re
** Random effects com erros padrao robustos de white por clusters
xtreg math4 lunch lrexpp small y95- y98, re vce(cluster schid)
estimates store beta_RE
** efeitos fixos com erros padrão robusto de white por clusters
xtreg math4 lunch lrexpp small y95- y98, fe vce(cluster schid)
estimates store beta_FE
** Comparar coeficientes
estimates table beta_POLS beta_RE beta_FE
** Teste aos efeitos fixos no estimador tempo  de efeitos fixos
test( y95 y96 y97 y98)
** Teste de Hausman: com time dummies matriz de covariancias singular
quietly xtreg math4 lunch lrexpp small y95- y98, re
estimates store beta_RE_NR
quietly xtreg math4 lunch lrexpp small y95- y98, fe
estimates store beta_FE_NR
** teste
hausman beta_FE_NR beta_RE_NR
** Teste de hausman sem dummiues para efeitos fixos no tempo
xtreg math4 lunch lrexpp small, re
estimates sore beta_RE_SD
estimates store beta_RE_SD
xtreg math4 lunch lrexpp small, fe
estimates store beta_FE_SD
hausman beta_FE_SD beta_RE_SD
