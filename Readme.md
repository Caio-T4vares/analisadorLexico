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
1: Abra o arquivo "sintax.l".
2:Aperte a sequencia: CTRL + SHIFT + B; ou vá em  *Terminal* -> *run task...* -> escolha *Make*. Isso vai criar o "executavel".
3: Vá em *Terminal* -> "New terminal*.
4: execute a seguinte linha: ./sintax input
5: Os resultados devem aparecer no terminal 