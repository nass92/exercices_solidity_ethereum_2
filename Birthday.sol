// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol";

contract Birthday {
    using Address for address payable;

    address private _winner;
    uint256 private _presentValue;
    uint256 private _birthdayDate;

    constructor(
        address winner_,
        uint256 day,
        uint256 month,
        uint256 year
    ) {
        _winner = winner_;
        _birthdayDate = _dt(day, month, year);
    }

    /*modifier 
    modifier theDate(uint256 day, uint256 month, uint256 year) {
        require(day <= 31 && month <= 12 && year <= 1970);
        _;
    }*/

    modifier notTheDay() {
        require(
            block.timestamp <= _birthdayDate,
            "Birthday: Its not your birthday, you cant take your present."
        );
        _;
    }

    modifier onlyWinner() {
        require(msg.sender == _winner, "Birthday: Its not your present.");
        _;
    }

    // deposit function
    receive() external payable {
        _presentValue += msg.value; // increment _presentValue a chaque fois que l'on envoie un cadeau (eth)
    }

    fallback() external {}

    function offer() external payable {
        _presentValue += msg.value;
    }

    // function getPresent
    function getPresent() public notTheDay onlyWinner {
        uint256 ewe = _presentValue;
        _presentValue = 0;
        payable(msg.sender).sendValue(ewe);
    }

    // function date => 1 journée = 86400 seconde, 1 mois = 2628000 secondes, 1 année = 31 557 600 secondes
    function _dt(
        uint256 day,
        uint256 month,
        uint256 year
    ) private pure returns (uint256) {
        require(day <= 31 && month <= 12 && year >= 1970, "Birthday: error");
        uint256 journee = 86400;
        uint256 mois = 2628000;
        uint256 annee = 31557600;
        return (((day - 1) * journee) +
            ((month - 1) * mois) +
            ((year - 1970) * annee));
    }

    // function à lire (view)

    // lecture du total de la balance de presentValue
    function presentValue() public view returns (uint256) {
        return _presentValue;
    }

    // lecture de la date d'anniversaire
    function birthdayDate() public view returns (uint256) {
        return _birthdayDate;
    }

    //lecture du winner

    function winner() public view returns (address) {
        return _winner;
    }
}
