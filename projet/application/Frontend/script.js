// SCRIPT.JS FONCTIONNEL
const display = document.getElementById('display');
let currentInput = '';
let hasDecimal = false;

function appendValue(value) {
    console.log("Bouton cliqué:", value);
    
    if (!isNaN(value)) {
        currentInput += value;
    } else if (value === '.') {
        if (!hasDecimal) {
            if (currentInput === '' || /[+\-*/]$/.test(currentInput)) {
                currentInput += '0';
            }
            currentInput += '.';
            hasDecimal = true;
        }
    } else {
        if (currentInput === '') return;
        if (/[+\-*/]$/.test(currentInput)) {
            currentInput = currentInput.slice(0, -1);
        }
        currentInput += value;
        hasDecimal = false;
    }
    display.textContent = currentInput;
}

function clearDisplay() {
    currentInput = '';
    hasDecimal = false;
    display.textContent = '0';
}

async function calculateResult() {
    console.log("=== CALCUL DÉMARRÉ ===");
    console.log("Expression:", currentInput);
    
    if (!currentInput) {
        alert("Entrez un calcul");
        return;
    }
    
    // Parsing SIMPLE
    let a, b, op;
    
    // Chercher l'opérateur
    if (currentInput.includes('+')) {
        op = '+';
    } else if (currentInput.includes('-')) {
        op = '-';
    } else if (currentInput.includes('*')) {
        op = '*';
    } else if (currentInput.includes('/')) {
        op = '/';
    } else {
        display.textContent = 'Opérateur invalide';
        return;
    }
    
    const parts = currentInput.split(op);
    if (parts.length !== 2) {
        display.textContent = 'Expression invalide';
        return;
    }
    
    a = parseFloat(parts[0]);
    b = parseFloat(parts[1]);
    
    console.log("Parsé:", a, op, b);
    
    if (isNaN(a) || isNaN(b)) {
        display.textContent = 'Nombres invalides';
        return;
    }
    
    try {
        // 1. ENVOYER LE CALCUL
        display.textContent = 'Envoi...';
        
        const response = await fetch('/api/calculate', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                a: a,
                b: b,
                op: op
            })
        });
        
        console.log("Réponse API:", response.status);
        
        if (!response.ok) {
            const errorText = await response.text();
            throw new Error(`API error ${response.status}: ${errorText}`);
        }
        
        const data = await response.json();
        console.log("ID calcul:", data.id);
        
        // 2. POLLING POUR LE RÉSULTAT
        display.textContent = 'Calcul en cours...';
        const calculationId = data.id;
        
        let resultReceived = false;
        let attempts = 0;
        
        while (!resultReceived && attempts < 20) {
            attempts++;
            console.log(`Tentative ${attempts}...`);
            
            await new Promise(resolve => setTimeout(resolve, 1000));
            
            const resultResponse = await fetch(`/api/result/${calculationId}`);
            
            if (resultResponse.status === 200) {
                const resultData = await resultResponse.json();
                console.log("Résultat trouvé:", resultData);
                
                display.textContent = resultData.result;
                currentInput = resultData.result.toString();
                hasDecimal = currentInput.includes('.');
                resultReceived = true;
                
            } else if (resultResponse.status === 202) {
                // Encore en cours
                display.textContent = `Calcul... (${attempts}s)`;
                
            } else {
                const error = await resultResponse.json();
                throw new Error(`Erreur résultat: ${error.error || resultResponse.status}`);
            }
        }
        
        if (!resultReceived) {
            display.textContent = 'Timeout';
        }
        
    } catch (error) {
        console.error("ERREUR COMPLÈTE:", error);
        display.textContent = 'Erreur: ' + error.message;
        currentInput = '';
        hasDecimal = false;
    }
    
    console.log("=== CALCUL TERMINÉ ===");
}