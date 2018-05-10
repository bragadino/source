pragma solidity ^0.4.23;
import './SplitPayment.sol';
import './buyable.sol';

/**
@title blooming_pool (abstraction layer atop certain functions from Open Zepplin's 'Split Payment'
	contract)
@dev Contract that pays funds owed to multiple payees who own tokens representing
	blooming flowers. Triggered by oracle every 24 hours. Pays out ETH according to proportion of
	of payee's held shares before resetting share count to 0.
*/

contract blooming_pool is SplitPayment, buyable {

	/// @dev needs some kind of 'onlyOracle' modifier?
	function oracle_call() {
		// calls check_blooming()...
		// ...iterates over payees array and calls payout()
		// ...calls resetShares()
	}

	function check_blooming() internal returns() {
		// get all tokenIDs & store in uint[] named 'tokenIDs';?
		uint i;
		for (i=0;i<tokenIDs.length;i++){
			if (TokenId[_tokenId].blooming == true) {
				addPayee(TokenIdtoadress[TokenId],1);
			}
		}
	}

	/// @dev (mostly) recycled code from claim() function in SplitPayment.sol which has been removed
	function payout(address _to, uint _value) internal returns(bool){
		require(shares[payee] > 0);

    uint256 totalReceived = address(this).balance.add(totalReleased);
    uint256 payment = totalReceived.mul(shares[payee]).div(totalShares).sub(released[payee]);

    require(payment != 0);
    require(address(this).balance >= payment);

    released[payee] = released[payee].add(payment);
    totalReleased = totalReleased.add(payment);

    payee.transfer(payment);
	}

	/// @dev this function shouldn't be necessary after payout loop in oracle_call but just in case..
	function reset_shares() internal returns(){
		if (totalShares < 0){
			totalShares = 0;
		}
	}

}
