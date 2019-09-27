#!/bin/bash

posx=1;
posy=6;
limite="";
limitpun=5;
campox=10;
campoy=5;
posxm=$(($RANDOM%($campox-1)+1))
posym=$(($RANDOM%($campoy-6)+6))
puntaje=0;
segrest=5;
segact=$(date +%S) segact=${segact#0}
segign=0;
segtemp=0;
segdec=0;


function paintField(){
clear

echo "Mueva el punto con las Letras $limite"
echo "w o up:Arriba	q o Q:Salir"
echo "s o ↓:Abajo"
echo "a o ←:Izquierda	Puntaje	             : $puntaje"
echo "d o →:Derecha	Tiempo Restante      : $segrest"

for i in `seq 1 $campoy`; do
#pintar las demas lineas 30
    printf -v line '%*s' "$campox"
    echo ${line// /-}
  # fi
done	
paintEnemy
paintTime
}

function paintEnemy(){
	printf "\033[%d;%df^"  $posym $posxm;
}

function paintTime(){
    printf "\033[%d;%df$segrest  "  5 40;
}

paintField
paintEnemy

while true; do  #20


#50
read -s -n 1 tecla #captura la tecla para moverse
limite="";
case $tecla in
d | C )
 if [ $posx -eq $campox ]; then
   limite=" - Limite alcansado, haz llegado a la pared derecha"
   continue
 else   
   printf "\033[%d;%df-"  $posy $posx;
   posx=$(($posx+1));
 fi
 ;;
a | D )
 if [ $posx -eq 1 ]; then
   limite=" - Limite alcansado, haz llegado a la pared izquierda"
   continue
 else
   printf "\033[%d;%df-"  $posy $posx;
   posx=$(($posx-1));
 fi
 ;;
s | B ) #70
 if [ $posy -eq $(($campoy+5)) ]; then
   limite=" - Limite alcansado, haz llegado a la pared baja"
   continue
 else
   printf "\033[%d;%df-"  $posy $posx;
   posy=$(($posy+1));
 fi
 ;;
w | A )
 if [ $posy -eq 6 ]; then
   limite=" - Limite alcansado, haz llegado a la pared alta"
   continue
 else
   printf "\033[%d;%df-"  $posy $posx;
   posy=$(($posy-1));
 fi
 ;;
q | Q) clear; echo "Gracias por jugar adios."; exit 0;;
esac


##simula el cronometro.
segtemp=$(date +%S) segtemp=${segtemp#0} 

     #ignora el código si trata de entrar 2 veces en un mismo segundo
if [ $segign -ne $segtemp ]; then  
  while true; do
     #Si son iguales termina el ciclo
     if [ $segact -eq $segtemp ]; then
        break
     fi
  segdec=$(( $segdec + 1 )) #Lleva el conteo de los segundos que han pasado
     if [ $segact -eq 59 ]; then
        segact=0;
        continue;
     fi
   segact=$(( $segact + 1))
  done
  paintTime
fi

segign=$segtemp;
segrest=$(( $segrest - $segdec ))

#Si decrementó 1 seg. vuelve a obtener el tiempo actual
#esto significa que ya pasaron 1 o más segundos.
if [ $segdec -ge 1 ]; then
   segact=$(date +%S) segact=${segact#0} 
fi

#Reestablece el contador
segdec=0


#Verifica si perdiste por tiempo
if [ $segrest -le 0 ]; then
   clear
   echo "Usted ha perdido el juego :C!!!, se le acabó el tiempo"
   exit 0;
fi



##Verfica si alcanzaste el objetivo
if [ $posy -eq $posym ] && [ $posx -eq $posxm ]; then
puntaje=$((puntaje+1))
posxm=$(($RANDOM%($campox-1)+1))
posym=$(($RANDOM%($campoy-6)+6))
segrest=$(( $segrest + 2 ))
paintEnemy
fi

#Cambia el nivel según el puntaje
if [ $puntaje -eq $limitpun ]; then
   campoy=$(($campoy+2))
   campox=$(($campox+5))
   limitpun=$(($limitpun+5))
   paintField
fi
#Verifica si alcansaste el puntaje ganador
if [ $puntaje -eq 200 ]; then
   clear
   echo "************************************"
   echo "*Felicidades has ganado el juego!!!*"
   echo "************************************"
   echo
   echo "        *****************           "
   echo "        *****************           "
   echo "         ***************            "
   echo "           ***********              "
   echo "             *******                "
   echo "               ***                  "
   echo "                *                   "
   echo "                *                   "
   echo "            *********               "
   exit 0;
fi


printf "\033[%d;%df*"  $posy $posx;

printf "\033[%d;%df "  $((campox+1)) 20;
done
