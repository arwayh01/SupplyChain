pragma solidity ^0.5.16;

contract AssetTracker {
    struct Asset {
        string name;
        string description;
        string descriptionProcess;
        string descriptionDistribution;
        string manufacturer;
        bool initialized;
        bool verify;
    }

    struct tracking {
        address location;
        string uuid;
    }
    mapping(string => tracking) locations;
    mapping(string  => Asset) private assetStore;

    event AssetCreate(string manufacturer, string uuid, address location);
    event AssetTransfer(address from, address to, string uuid);

    function createAsset(string memory name, string memory description, string memory uuid) public {
        require(!assetStore[uuid].initialized, "Asset With This UUID Already Exists");

        assetStore[uuid] = Asset(name, description," " ," ","m1",true,true);
        locations[uuid] = tracking(msg.sender, uuid);
        //emit AssetCreate(msg.sender, uuid, msg.sender);
    }
    function VerifyAndTransferAsset(bool verify, address to, string memory uuid) public {
        require(!verify, "produit rejete");
        assetStore[uuid].verify=verify;
        locations[uuid]= tracking(to, uuid);
        emit AssetTransfer(msg.sender, to, uuid);
    }
    function ProcessStep(string  memory descriptionP,address to, string memory uuid) public {
        assetStore[uuid].descriptionProcess=descriptionP;
        locations[uuid] = tracking(msg.sender, uuid);
        emit AssetTransfer(msg.sender, to, uuid);
    }
    function DistributionStep(string  memory descriptionD,address to, string memory uuid) public {
        assetStore[uuid].descriptionDistribution=descriptionD;
        locations[uuid] = tracking(msg.sender, uuid);
        emit AssetTransfer(msg.sender, to, uuid);
    }
    function transferAsset(address to, string memory uuid) public {
        require(locations[uuid].location==msg.sender, "You are Not Authorized to Transfer This Asset");

        locations[uuid]= tracking(to, uuid);
        emit AssetTransfer(msg.sender, to, uuid);
    }


    function getAssetDetails(string memory uuid)public view returns (string memory,string memory,string memory) {

        return (assetStore[uuid].name, assetStore[uuid].description, assetStore[uuid].manufacturer);
    }
    function getAssetLocation(string memory uuid)public view returns (address) {

        return (locations[uuid].location);
    }


}
