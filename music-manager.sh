#!/bin/bash

# ------------------------------
# Adiciona ou remove músicas de uma lista
# ------------------------------

# Verifica se o zenity está instalado
if [ -x "$(command -v zenity)" ]; then
    ZENITY=TRUE
else
    ZENITY=FALSE   
fi

# Verifica se o arquivo matriz.js existe

if [ ! -e /src/matriz.js ]; then
 echo "const audioTracks = [" >> /src/matriz.js
 echo " " >> /src/matriz.js
 echo "];" >> /src/matriz.js
 echo "export default audioTracks;" >> /src/matriz.js
fi

# ------------------------------
# Funções
# ------------------------------

# Adiciona uma música à lista
function adicionar_musica() {
    if [ "$ZENITY" == "TRUE" ]; then
        FILE=$(zenity --entry --title "Adicionar música" --text "Digite o nome do arquivo:")
        valida_arquivo "$FILE"

        NAME=$(zenity --entry --title "Adicionar música" --text "Digite o nome da música:")
        ARTIST=$(zenity --entry --title "Adicionar música" --text "Digite o nome do artista:")
    else
        echo 'Digite o nome do arquivo:'
        read -r FILE
        valida_arquivo "$FILE"

        echo 'Digite o nome da música:'
        read -r NAME
        echo 'Digite o nome do artista:'
        read -r ARTIST
    fi

    #Inserindo com regex
    sed -i "2i\    {\n      file: '$FILE',\n      name: '$NAME',\n      artist: '$ARTIST',\n    }," /src/matriz.js
    echo 'Música adicionada!'
}

function valida_arquivo() {
    # Se não termina com ".mp3", adiciona ".mp3" no final da variável
    if [[ $1 != *.mp3 ]]; then
        FILE="$1.mp3"
    else
        FILE="$1"
    fi

    echo "Teste $FILE"

    # Verifica se o arquivo da música existe
    if [ -e "$FILE" ]; then
        echo 'Música encontrada!'
        mv "$FILE" "media/$FILE"
        FILE="media/$FILE"
    else
        echo 'erro: música não encontrada! Certifique-se de que o arquivo está na pasta "City Pop"'
        sleep 2
        exit 1
    fi
}


# Remove uma música da lista
function remover_musica() {
    ls
    if [ "$ZENITY" == "TRUE" ]; then
        FILE=$(zenity --entry --title "Remover música" --text "Digite o nome do arquivo:")
    else
        echo 'Digite o nome do arquivo:'
        read -r FILE
    fi

valida_arquivo "$FILE"

#Excluindo com regex
 sed -i "/file: .\{0,\}\/media\/$FILE.\{0,\},/,/{/d" /src/matriz.js
 echo 'Música removida!'
}

# ------------------------------
# Deseja remover ou adicionar uma música?
# ------------------------------

if [ "$ZENITY" == TRUE ]; then
   zenity --question --text "Deseja excluir ou adicionar uma música?" --ok-label="Adicionar" --cancel-label="Excluir"
   RESPOSTA=$?
else 
    echo '1 Excluir música.0  O código vai adicionar música'
    read -r RESPOSTA
fi

   #RESPOSTA = 1, O código vai excluir uma música. RESPOSTA = 0, O código vai adicionar Uma música
   if [ "$RESPOSTA" = "1" ]; then
    remover_musica
   else
    adicionar_musica
   fi