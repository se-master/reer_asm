.data
annee:          #32
.int 0
salaire:        #79520
.int 0
augmentation:   #4
.int 0
konst:
.int 100
kinst:
.int 1
float:
.float 0
.text
.globl	_ZN4Reer15salaireFinalAsmEv

_ZN4Reer15salaireFinalAsmEv:
pushl %ebp
movl %esp, %ebp
# DEBUT COMPLETION
init:
movl 8(%ebp), %edi

movl 8(%edi), %ebx  #salaire depart
movl %ebx, salaire
movl 12(%edi), %ecx #augmentation
movl %ecx, augmentation
movl 24(%edi), %edx #annee avant retraite
movl %edx, annee

#1. annee - 1
#2. augmentation / 100
#3. #2 += 1
#4. augmentation^(#3)
#5. salaire * #4

#flds salaire => st[0] = salaire, st[1] = st[0] (ancienne)
#fstps addr   => addr = st[0]
#faddp st[o] += st[1]   #fsubp st[o] -= st[1]
#fdivp st[o] /= st[1]

# Load étiquette int => fildl
# Load étiquette float => flds
# Store étiquette int => fistpl
# Store étiquette float => fstps

#1.
decl annee              #annee -= 1
decl annee              #annee -= 1
#2.
fildl konst             #st[0] = 100
fildl augmentation      #st[0] = 4, st[1] = 100
fdivp                   #st[0] => augmentation /= 100 (0,04)
#3.
fildl kinst             #st[0] = 1, st[1] = 0,04
faddp                   #st[0] = 1,04
fstps float              #float = 1,04
#4.
flds float              #st[0] = float (1,04)
pow:
flds float           #st[1] = float (1,04; 1,08;..;3,37)
fmulp                   #st[0] *= st[1]
decl annee              #annee -= 1
cmpl $0, annee          #annee > 0, alors continue
jg pow
#5.
flds salaire        #st[0] = salaire, st[1] = (augm^(annee))
fmulp               # salaire *= annee

fstps float
movl float, %eax

# FIN COMPLETION
# NE RIEN MODIFIER APRES CETTE LIGNE
retour:
leave
ret
