.data
tmp:
.int 0
kinder:
.int 1
const:
.int 100
nom:
.float 0
denom:
.float 0
taux:
.float 0
tauxI:
.float 0
tmpf:
.text
.globl	_ZN4Reer30montantAEpargnerChaqueAnneeAsmEv

_ZN4Reer30montantAEpargnerChaqueAnneeAsmEv:
pushl %ebp
movl %esp, %ebp
# DEBUT COMPLETION
init:
movl 8(%ebp), %edi      #on push this pour avoir acces aux attributs

#Registre - Variable
#4  (16)    anneesDeRetraite,
#8  (79520) salaireDepart,
#12 (4)     augmentationSalariale,
#16 (64)    pourcentageSalaireVouluRetraite)
#20 (8)     tauxInteret,
#24 (32)    anneeAvantRetraite,

# Load étiquette  int     => fildl
# Load étiquette  float   => flds
# Store étiquette int     => fistpl
# Store étiquette float   => fstps

CalculTaux:
movl 20(%edi), %ebx
movl %ebx, tmp
fildl const
fildl tmp
fdivp               #st0    = 0,08
fstps tauxI
flds tauxI

fildl kinder
faddp               #st0    = 1,08
fstps taux          #taux   = 1,08

#+++GDB+++###+++GDB+++###+++GDB+++###+++GDB+++###

#met le nb d'annee avant retraite comme compteur
movl 24(%edi), %ebx
decl %ebx
decl %ebx

flds taux       #st0 = 1,08
pow:
flds taux       #st0, st1 = taux
fmulp
cmpl $0, %ebx   #(ebx = compteur)
decl %ebx
jge pow
fstps denom     #denom = st0 = 11, 73 70 82 99 54

denominateur:
fildl kinder
flds denom      #st0 = 11, 73 70 82 99 54
fsubp           #st0 = 10, 73 70 82 99 54
fstps denom

disvision:
flds denom      #st0 = 10, 73 70 82 99 54
flds tauxI      #st0 = 0, 08
fdivp           #st0 = 0, 00 74 50 81 32

accumul:
pushl %edi
call _ZN4Reer34montantAmasseFinalAvantRetraiteAsmEv
movl %eax, tmp
popl %edi #le popl decremente esp de 4 automatiquement

calculFinal:
fildl tmp
fmulp

fistpl tmpf
movl tmpf, %eax

# FIN COMPLETION
# NE RIEN MODIFIER APRES CETTE LIGNE
retour:
leave
ret
