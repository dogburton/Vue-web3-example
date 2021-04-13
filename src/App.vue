<template>
  <v-app>
    <v-app-bar
      app
      color="primary"
      dark
    >
      <div class="d-flex align-center">
        
      </div>
      NOTE: Be mindful of the testnetwork where you deploy the contract.
      <v-spacer></v-spacer>

      
    </v-app-bar>

    <v-main>
      
      <v-container class="lighten-6 my-10">

        <v-card
          class="mx-auto pa-8"
          max-width="500"
          elevation="7"
          outlined
          v-if="web3Exists"
        >
          <div v-if="(walletAddress!=null)">
            CONNECTED WITH: <span style="font-weight: bold">{{walletAddress}}</span>
          </div>
          <v-list-item three-line>
            <v-list-item-content>
              <div class="overline mb-4">
                Interacting with Contract at <a :href="'https://kovan.etherscan.io/address/'+contractAddress">{{contractAddress}}</a>
              </div>
              <v-list-item-title class="headline mb-1">
                Contract Data
              </v-list-item-title>
            </v-list-item-content>
          </v-list-item>

          <div v-if="web3Connected">

          <v-text-field label="Number" type="number" v-model="numberInput"></v-text-field>
          
          (value on chain) Number Stored: {{number}}

          <v-card-actions >
            <v-btn
              outlined 
              text
              @click="refreshNumber"
            >
              REFRESH NUMBER
            </v-btn>
              <v-btn
              outlined
              class="alert lighten-5" 
              text
              @click="submitNumber"
            >
              SUBMIT NUMBER
            </v-btn>
          </v-card-actions>
            
          <v-text-field label="Text" v-model="textInput"></v-text-field>
          
          (value on chain) Text Stored: {{text}} 

          <v-card-actions >
            <v-btn
              outlined 
              text
              @click="refreshText"
            >
              REFRESH TEXT
            </v-btn>
              <v-btn
              outlined
              class="alert lighten-5" 
              text
              @click="submitText"
            >
              SUBMIT TEXT
            </v-btn>
          </v-card-actions>
          </div>
            <v-btn
              outlined
              class="primary lighten-5" 
              text
              v-on:click="connectWeb3"
              v-if="!web3Connected"
            >
              CONNECT WALLET
            </v-btn>
        </v-card>

        <v-card
          class="mx-auto pa-8"
          max-width="500"
          elevation="7"
          outlined
          v-else
        >
        Please install an extension or use a browser with web3 support.
        </v-card>

      </v-container>
    </v-main>
  </v-app>
</template>

<script>
//import HelloWorld from './components/HelloWorld';

import Web3 from 'web3'; 

export default {
  name: 'App',

  components: {
    //HelloWorld,
  },
  
  created() {
    this.contractAddress = process.env.VUE_APP_CONTRACT_ADDRESS;
    this.contractABI = process.env.VUE_APP_CONTRACT_ABI;
  },

  mounted() {
    this.$nextTick(function () {
      try{
        if(window.ethereum){
          
          //We connect to Metamask
          let VueContext = this;
          window.ethereum._handleConnect = function(){
            if(window.web3.eth.accounts.currentProvider.selectedAddress != null){
              VueContext.web3Connected = true;
              VueContext.walletAddress = window.web3.eth.accounts.currentProvider.selectedAddress;
            }
            else{
              VueContext.web3Connected = false;
              VueContext.walletAddress = null;
            }
          }
          window.ethereum._handleDisconnect = function(){
            if(window.web3.eth.accounts.currentProvider.selectedAddress != null){
              VueContext.web3Connected = true;
              VueContext.walletAddress = window.web3.eth.accounts.currentProvider.selectedAddress;
            }
            else{
              VueContext.web3Connected = false;
              VueContext.walletAddress = null;
            }
          }
          window.web3 = new Web3(window.ethereum);
          VueContext.web3Exists = true;
          
          window.metamaskContract = new window.web3.eth.Contract(JSON.parse(VueContext.contractABI));
          window.metamaskContract._address = VueContext.contractAddress;

          //populate inital values
          window.metamaskContract.methods.text().call().then(function(result) {
            VueContext.text = result;
          })
          window.metamaskContract.methods.number().call().then(function(result) {
            VueContext.number = result;
          })
          
          if(window.web3.eth.accounts.currentProvider.selectedAddress != null){
            VueContext.web3Connected = true;
          }
        }
        else{
          window.web3 = null;
        }
      }
      catch{
        window.web3 = null;
      }
    })
  },
  
  data: () => {
    return {
        contractAddress : "",
        web3Exists : false,
        web3Connected: false,
        contractABI: "",
        number: 0,
        text: "",
        numberInput: 0,
        textInput: "",
        walletAddress: null,
        InfuraAPI: ""
        }
    },
  methods: {
    connectWeb3: () => {
      if (window.ethereum) {
          window.ethereum.enable();
      }
    },
    refreshText: function(){
      let VueContext = this;
      window.metamaskContract.methods.text().call().then(function(result) {
        VueContext.text = result;
      });
    },
    submitText: function(){
      let VueContext = this;
      let textVal = VueContext.textInput;
      window.metamaskContract.methods.storeText(textVal).send({
        from: VueContext.walletAddress
      }).then(function(result) {
        if(result.status == true){
          VueContext.text = textVal;
        }
      });
    },
    refreshNumber: function(){
      let VueContext = this;
      window.metamaskContract.methods.number().call().then(function(result) {
        VueContext.number = result;
      });
    },
    submitNumber: function(){
      let VueContext = this;
      let numberVal = VueContext.numberInput;
      window.metamaskContract.methods.storeNumber(numberVal).send({
        from: VueContext.walletAddress
      }).then(function(result) {
        if(result.status == true){
          VueContext.number = numberVal;
        }
      });
    }
  }
};
</script>
