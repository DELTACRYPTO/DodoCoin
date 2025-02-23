/**
 *Submitted for verification at sepolia.basescan.org on 2025-02-23
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DodoCoinCasino {
    // Propriétés du contrat
    address payable public owner;
    uint256 public constant PRIX_PARTICIPATION = 100 * 10**18; // 100 DodoCoins pour jouer
    uint256 public constant CHANCE_DE_GAGNER = 1000; // 1 chance sur 1000
    uint256 public constant GAIN = 100_000_000 * 10**18; // 100 millions de DodoCoins pour le gagnant
    uint256 public constant SUPPLY_TOTALE = 1_000_000_000 * 10**18; // 1 milliard de DodoCoins
    uint256 public ronflements; // Compteur de ronflements du Dodo

    // Propriétés du token DodoCoin
    string public constant name = "DodoCoin";
    string public constant symbol = "DODO";
    uint8 public constant decimals = 18;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    // Événements
    event DodoReveille(address indexed joueur, uint256 dodoCoinsGagnes);
    event DodoContinueDeDormir(address indexed joueur);
    event DodoNourri(address indexed joueur, uint256 dodoCoinsDepenses);
    event BerceuseChantee(address indexed joueur, uint256 dodoCoinsDepenses);
    event OreillerOffert(address indexed joueur, uint256 dodoCoinsDepenses);
    event DodoCoinsTransferes(address indexed de, address indexed a, uint256 montant);

    constructor() {
        owner = payable(msg.sender);
        totalSupply = SUPPLY_TOTALE;
        balanceOf[owner] = SUPPLY_TOTALE; // Le propriétaire reçoit toute la supply initiale
    }

    // Modificateur pour vérifier que seul le propriétaire peut appeler certaines fonctions
    modifier onlyOwner() {
        require(msg.sender == owner, "Seul le proprietaire peut faire cela");
        _;
    }

    // Fonction pour transférer des DodoCoins
    function transferer(address to, uint256 amount) external returns (bool) {
        require(balanceOf[msg.sender] >= amount, "Solde insuffisant");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        emit DodoCoinsTransferes(msg.sender, to, amount);
        return true;
    }

    // Fonction pour jouer au jeu
    function reveillerLeDodo() external {
        require(balanceOf[msg.sender] >= PRIX_PARTICIPATION, "Vous n'avez pas assez de DodoCoins pour jouer");

        // Transfert des DodoCoins de participation au contrat
        balanceOf[msg.sender] -= PRIX_PARTICIPATION;
        balanceOf[address(this)] += PRIX_PARTICIPATION;

        // Génération d'un nombre aléatoire (utilisation de block.prevrandao)
        uint256 nombreAleatoire = uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, msg.sender))) % CHANCE_DE_GAGNER;

        if (nombreAleatoire == 0) {
            // Le Dodo se réveille (1 chance sur 1000)
            require(balanceOf[address(this)] >= GAIN, "Pas assez de DodoCoins dans le contrat pour payer le gain");
            balanceOf[address(this)] -= GAIN;
            balanceOf[msg.sender] += GAIN;
            emit DodoReveille(msg.sender, GAIN);
        } else {
            // Le Dodo continue de dormir
            ronflements++; // On incrémente le compteur de ronflements
            emit DodoContinueDeDormir(msg.sender);
        }
    }

    // Fonction pour nourrir le Dodo (absurde)
    function nourrirLeDodo(uint256 montant) external {
        require(balanceOf[msg.sender] >= montant, "Vous n'avez pas assez de DodoCoins pour nourrir le Dodo");
        balanceOf[msg.sender] -= montant;
        balanceOf[address(this)] += montant;
        emit DodoNourri(msg.sender, montant);
    }

    // Fonction pour chanter une berceuse au Dodo (absurde)
    function chanterBerceuse(uint256 montant) external {
        require(balanceOf[msg.sender] >= montant, "Vous n'avez pas assez de DodoCoins pour chanter une berceuse");
        balanceOf[msg.sender] -= montant;
        balanceOf[address(this)] += montant;
        emit BerceuseChantee(msg.sender, montant);
    }

    // Fonction pour offrir un oreiller au Dodo (absurde)
    function offrirOreiller(uint256 montant) external {
        require(balanceOf[msg.sender] >= montant, "Vous n'avez pas assez de DodoCoins pour offrir un oreiller");
        balanceOf[msg.sender] -= montant;
        balanceOf[address(this)] += montant;
        emit OreillerOffert(msg.sender, montant);
    }

    // Fonction pour que le propriétaire retire les DodoCoins accumulés dans le contrat
    function retirerDodoCoins(uint256 montant) external onlyOwner {
        require(balanceOf[address(this)] >= montant, "Pas assez de DodoCoins dans le contrat");
        balanceOf[address(this)] -= montant;
        balanceOf[owner] += montant;
    }

    // Fonction pour que le propriétaire détruise le contrat et récupère les fonds restants
    function detruireContrat() external onlyOwner {
        // Transférer tous les fonds Ether au propriétaire
        uint256 balance = address(this).balance;
        if (balance > 0) {
            owner.transfer(balance);
        }

        // Désactiver le contrat (optionnel)
        // Vous pouvez ajouter un état pour empêcher toute interaction future avec le contrat
        // Par exemple, en utilisant un booléen `isActive` et en vérifiant son état dans chaque fonction.
    }
}
