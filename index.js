import inquirer from 'inquirer'
import fs from 'fs'
import chalk from 'chalk';

let loteriaJson = [];
let loteriaPorTirar = null

let selectedItem = null;

const showMenu = () => {
    inquirer
    .prompt([{
        name: 'option',
        type: 'list',
        message: 'Loteria Mexicana - Elige una opción',
        choices: ['Jugar', 'Reiniciar', 'Salir \n'],
    }]
    ).then((answers) => {
        if (answers.option === 'Jugar') {
            Jugar()
        }
        if (answers.option === 'Reiniciar') {
            Reiniciar(true)
        }
    })
    .catch((err) => {
        console.log(err);
    });
}

function Jugar(){
    //loteriaPorTirar === null && Reiniciar()
    if(loteriaPorTirar === null){
        console.log("Reiniciar")
        Reiniciar(false)
    }
    if (loteriaPorTirar.length === 0){
        console.clear()
        console.log(
            chalk.red(
                `\n -------------------- \n No hay mas cartas por tirar!! \n --------------------\n`)
        )
    }else{
        const ramdomNumber = between(0, loteriaPorTirar.length)
        const ramdomItemLoteria = loteriaPorTirar[ramdomNumber]
        selectedItem = ramdomItemLoteria
        loteriaPorTirar = loteriaPorTirar.filter(item => item.id !== selectedItem.id)
        console.log(`
        Carta :  ${selectedItem.name}
        \n
        ${selectedItem.phrase}
        `)
    }
    
    return showMenu()
}

function Reiniciar(canReturn){
    const rawData = fs.readFileSync('loteria.json')
    loteriaJson = [...JSON.parse(rawData)]
    loteriaPorTirar = [...loteriaJson]
    if(canReturn){
        return showMenu()
    }
}

function between(min, max) {  
    return Math.floor(
      Math.random() * (max - min) + min
    )
}
  


showMenu();