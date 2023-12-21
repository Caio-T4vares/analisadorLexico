Projeto feito no linux (ubuntu) com vsCode
Para rodar é necessario está no linux

Instalação das ferramentas necessarias:
    sudo apt update
    sudo apt upgrade
    sudo apt install g++ gdb
    sudo apt install make cmake
    sudo apt install flex
    sudo apt install bison

Pacotes do vsCode:
    C/C++ - microsoft
    CMake - twxs
    Yash - daohong

Com tudo instalado é só compilar:
1: Abra o arquivo "analisadorLexico.cpp".
2: Com ele aberto vá na parte superior do vsCode e vá *Terminal* -> *run task...* -> escolha *cMake*. Isso criará os arquivos necessarios para compilação, no Build.
3: Ainda no arquivo do ponto 1, aperte a sequencia: CTRL + SHIFT + B; ou vá em  *Terminal* -> *run task...* -> escolha *Make*. Isso vai criar o "executavel" em Build.
4: Vá em *Terminal* -> "New terminal*.
5: No terminal escreva: cd Build
6: Dentro do Build execute a seguinte linha: ./analisadorLexico < ../test.txt
7: Suba o terminal até ver: "Resumo dos tokens do arquivo" 