// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract SupplyChain{

    struct product {                          // product  propterties
        address farmerID;
        address processorID;
        address distributorID;
        address retailerID;
        uint product_code;
        uint batch_no;
        string product_name;
        State itemstate;
        string[] loc;
    }

        enum State                              // current state of product
    {
        Atfarmer,
        Atprocessor, 
        Atdistributer,
        Atretailer

    }
    product pinst;
    mapping (uint => product)  public products;    // all manufactured products


    // below function  is invoked by processor 
    function producerToProcessor(uint  pro_id,uint batch,address farm_id,string memory farmLoc) produceByFarmer(pro_id) public
    {
        pinst.product_code= pro_id;
        pinst.batch_no= batch;
        pinst.farmerID= farm_id;                                      // transcation 1 : from farmer to processor
        pinst.processorID= msg.sender;
        pinst.itemstate= State.Atprocessor;
        pinst.loc.push(farmLoc);
        products[pro_id]= pinst;
        

    }

    // below  function is invoked by distributer 
    function processorToDistributer(uint pro_id,address processor_id,string memory processorLoc) is_Processor(pro_id,processor_id) public
    {
        products[pro_id].loc.push(processorLoc);
        products[pro_id].distributorID= msg.sender;
        products[pro_id].itemstate= State.Atdistributer;

    }

    // below function is invoked by retailer
    function distributerToRetailer(uint pro_id,address distri_id,string  memory retailerLoc) is_Distri(pro_id,distri_id) public
    {
        products[pro_id].loc.push(retailerLoc);
        products[pro_id].retailerID= msg.sender;
        products[pro_id].itemstate= State.Atretailer;

    }

    function getStatus(uint pro_id) view public returns(State){
        return products[pro_id].itemstate;
    }

    function showLoc(uint pro_id) view public returns(string[] memory){
        return products[pro_id].loc;
    }

    modifier produceByFarmer(uint prodt_code) {
    require(products[prodt_code].itemstate == State.Atfarmer);
    _;
  }
    modifier is_Processor(uint prodt_code,address p) {           // product at and with provided processor
    require(products[prodt_code].itemstate == State.Atprocessor && products[prodt_code].processorID == p);
    _;
  }
  modifier is_Distri(uint prodt_code,address d) {           // product at and with provided distributor
    require(products[prodt_code].itemstate == State.Atdistributer && products[prodt_code].distributorID == d);
    _;
  }


}

