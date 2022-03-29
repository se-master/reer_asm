.data
tmp:
.int 0
kinder:
.int 1
subber:
.int 2
encaisse:
.int 0
const:
.int 100
nom:
.float 0
denom:
.float 0
taux:
.float 0
tmpf:
.text
.globl _ZN6Compte29montantAInvestirMaintenantAsmEv

_ZN6Compte29montantAInvestirMaintenantAsmEv:
pushl %ebp
movl %esp, %ebp
# DEBUT COMPLETION
init:
movl 8(%ebp), %edi      #on push this pour avoir acces aux attributs

#Registre - Variable
#20 (8)     tauxInteret,
#24 (32)    anneeAvantRetraite,



caisseRegister:
movl 28(%edi), %eax
movl %eax, encaisse         #eax = 50 000 (encaisse)

calculTaux:
movl 20(%edi), %ecx
movl %ecx, tmp
fildl const
fildl tmp
fdivp               #st0    = 0,08

fstps tmpf
fildl subber        #st0    = 2
flds tmpf           #st0    = 0,08
fdivp               #st0    = 0,04

fildl kinder        #st0    = 1
faddp               #st0    = 1,04
fstps taux          #taux   = 1,04


calculExp:
flds taux
fildl kinder
fdivp           #st0 = 1/1,04 (0, 96 15 38 46 15)

fstps taux

annees:
movl 24(%edi), %ebx # ebx = 32
decl %ebx
decl %ebx


flds taux       #st0 = 0, 96 15 38 46 15

pow:
flds taux
fmulp
cmp $0, %ebx
decl %ebx
jge pow         #st0 = 0, 28 50 57 93 97

fstps taux      #st0 = 0, 28 50 57 93 97

##++GDB++###++GDB++###++GDB++###++GDB++###++GDB++###++GDB++###++GDB++###++GDB++###

salaire:
pushl %edi
call _ZN4Reer15salaireFinalAsmEv
movl %eax, tmp
popl %edi #le popl decremente esp de 4 automatiquement

fildl tmp   #st0 = SalaireFinal
flds taux   #st0 = 0, 28 50 57 93 97
fmulp       #st0 = salaire * taux

fildl encaisse  #st0 = 50 000

fsubp           #50 000 - salaire * taux


# Load étiquette  int     => fildl
# Load étiquette  float   => flds
# Store étiquette int     => fistpl
# Store étiquette float   => fstps
fistpl tmpf
movl tmpf, %eax
# FIN COMPLETION
# NE RIEN MODIFIER APRES CETTE LIGNE
retour:
leave
ret
