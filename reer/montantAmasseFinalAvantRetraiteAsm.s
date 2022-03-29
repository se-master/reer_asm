.data
annee:
.int 0
cpt:
.int 0
salaire:
.int 0
temp:
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
float:
.float 0
.text
.globl	_ZN4Reer34montantAmasseFinalAvantRetraiteAsmEv

_ZN4Reer34montantAmasseFinalAvantRetraiteAsmEv:
pushl %ebp
movl %esp, %ebp
# DEBUT COMPLETION
init:
movl 8(%ebp), %edi      #on push this pour avoir acces aux attributs

#            Registre - Variable
#            4  (16)    anneesDeRetraite,
#            8  (79520) salaireDepart,
#            12 (4)     augmentationSalariale,
#            16 (64)    pourcentageSalaireVouluRetraite)
#            20 (8)     tauxInteret,
#            24 (32)    anneeAvantRetraite,

# Load étiquette  int     => fildl
# Load étiquette  float   => flds
# Store étiquette int     => fistpl
# Store étiquette float   => fstps

CalculSalaireFinal:
pushl %edi
call _ZN4Reer15salaireFinalAsmEv
movl %eax, salaire
popl %edi       #le popl decremente esp de 4 automatiquement

#Salaire voulu (64%)
movl 16(%edi), %ebx
movl %ebx, temp #on stock pourcentage voulu dans temp

fildl const     #st0 = 100
fildl temp      #st0 = 64
fdivp           #st0 = 0,64
fildl salaire   #st0 = salaire
fmulp           #
fistpl salaire  #salaire final stocke dans salaire

CalculTaux:
movl 20(%edi), %ebx
movl %ebx, temp
fildl const
fildl temp
fdivp
fstps taux      #on stock le taux/100 dans taux

AnneeRegister:
movl 4(%edi), %ebx
movl %ebx, annee#stock nb d'années dans l'étiquette annee
movl %ebx, cpt

Nominateur:
fildl kinder
flds taux
faddp       #st0 = Taux + 1
fstps float
flds float

decl cpt
decl cpt

pow1:
flds float
fmulp
cmpl $0, cpt
decl cpt
jge pow1       #st0 = 3,42594264333

fstps float

fildl kinder
flds float
fsubp           #st0 = 2,42
fstps nom #calcul du nominateur terminé

Denominateur:
flds taux       #st0 = 0,08
flds float      #st0 = 3,42
fmulp           #st0 = 0,08 * 3,42 = 0,27

##++GDB++###++GDB++###++GDB++###++GDB++###++GDB++###++GDB++###++GDB++###++GDB++###
fstps denom
division:
flds denom
flds nom
fdivp
calculAmasse:
fildl salaire
fmulp

fistpl temp
movl temp, %eax

# NE RIEN MODIFIER APRES CETTE LIGNE
retour:
leave
ret
