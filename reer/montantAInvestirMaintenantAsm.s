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
tmpf:
.text
.globl	_ZN4Reer29montantAInvestirMaintenantAsmEv

_ZN4Reer29montantAInvestirMaintenantAsmEv:
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

annees:
movl 24(%edi), %ebx
decl %ebx
decl %ebx

calculTaux:
movl 20(%edi), %ecx
movl %ecx, tmp
fildl const
fildl tmp
fdivp               #st0    = 0,08
fildl kinder
faddp               #st0    = 1,08
fstps taux          #taux   = 1,08

calculExpo:
flds taux
fildl kinder
fdivp           #st0 = 1/1,08 (0, 92 59 25 92 59)

fstps taux
flds taux

pow:
flds taux
fmulp
cmp $0, %ebx
decl %ebx
jge pow#st0 = 0, 08 52 00 04 51

fstps taux #st0 = 0, 08 52 00 04 51

montant:
pushl %edi
call _ZN4Reer34montantAmasseFinalAvantRetraiteAsmEv
movl %eax, tmp
popl %edi #le popl decremente esp de 4 automatiquement

calculFinal:
fildl tmp
flds taux
fmulp

fistpl tmpf
movl tmpf, %eax
decl %eax

# FIN COMPLETION
# NE RIEN MODIFIER APRES CETTE LIGNE
retour:
leave
ret
