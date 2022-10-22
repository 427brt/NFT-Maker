// Web3Mint.sol
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;
// いくつかの OpenZeppelin のコントラクトをインポートします。
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./libralies/Base64.sol";
import "hardhat/console.sol";

// インポートした OpenZeppelin のコントラクトを継承しています。
// 継承したコントラクトのメソッドにアクセスできるようになります。
contract Web3Mint is ERC721URIStorage {
    struct NftAttributes {
        string name;
        string imageURL;
    }

    NftAttributes[] Web3Nfts;

    // OpenZeppelin が tokenIds を簡単に追跡するために提供するライブラリを呼び出しています
    using Counters for Counters.Counter;
    // _tokenIdsを初期化
    Counters.Counter private _tokenIds;

    // NFT トークンの名前とそのシンボルを渡します。
    constructor() ERC721("SimpNFT", "SIMP") {
        console.log("This is my NFT contract.");
    }

    // ユーザーが NFT を取得するために実行する関数です。
    function mintIpfsNFT(string memory name, string memory imageURI) public {
        uint256 newItemId = _tokenIds.current();
        // msg.sender を使って NFT を送信者に Mint
        _safeMint(msg.sender, newItemId);
        Web3Nfts.push(NftAttributes({name: name, imageURL: imageURI}));

        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newItemId,
            msg.sender
        );
        // 次の NFT が Mint されるときのカウンターをインクリメントする。
        _tokenIds.increment();
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        Web3Nfts[_tokenId].name,
                        " -- NFT #: ",
                        Strings.toString(_tokenId),
                        '", "description": "An epic NFT", "image": "ifps://',
                        Web3Nfts[_tokenId].imageURL,
                        '"}'
                    )
                )
            )
        );
        string memory output = string(
            abi.encodePacked("data:application/json;base64,", json)
        );
        return output;
    }
}
