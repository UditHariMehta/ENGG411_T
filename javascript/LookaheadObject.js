/**
*  Lookahead object
*/


var Lookahead = {

      wordTable: [],    // table for words for current token
      cats: [], //categories
      wfms: [],
      vforms: [],
      nums: [],
      catsCanAdd: ["intransitive verb", "transitive verb", "name", "count noun", "mass noun", "adjective", "adverb"],


      getWordTable: function() {
            return this.wordTable;
      },

      emptyAll: function() {
            this.wordTable = [];
            this.cats = [];
            this.wfms = [];
            this.vforms = [];
            this.nums =  [];
      },

      // sets cats, wfm, vform, num into their own list, assuming they exist
      setAll: function (data) {
            this.emptyAll();

            if (data.hasOwnProperty('lookahead')) {
                  var numOfCat = data.lookahead.length;  //number of categories avaialble
                  for (i = 0; i < numOfCat; i++) {

                        this.cats.push(data.lookahead[i].cat);

                        this.wfms.push(data.lookahead[i].wfm);
                        if (data.lookahead[i].hasOwnProperty('vform'))
                              this.vforms.push(data.lookahead[i].vform);
                        else
                              this.vforms.push(" ");

                        if (data.lookahead[i].hasOwnProperty('num'))
                              this.nums.push(data.lookahead[i].num);
                        else
                              this.nums.push(" ");

                  }


                  var temp = [];
                  for (i = 0; i < this.wfms.length; i++) {
                        for (j = 0; j < this.wfms[i].length; j++) {
                              //this.wordTable.push(this.wfms[i][j][0]);
                              temp.push(this.wfms[i][j][0]);
                        }
                  }
                  //remove duplicates of word table
                  var temp2 = [];
                  $.each(temp, function(i, el) {
                        if($.inArray(el, temp2) === -1)  temp2.push(el);
                  });
                  this.wordTable = temp2;
            }
            else {
                  // NEED TO CONSIDER WHAT TO DO IN THE EVENT THIS OCCURS
            }
      },

      // Removes all values in a lookahead table that does not correspond with token  (@ a node level).
      filterTable: function(token, lookahead) {
            for (i = 0; i < lookahead.length; i++) { //CHANGE TO FILTER
                  var notSameString = token != lookahead[i].slice(0, token.length);
                  if (notSameString) {
                        lookahead.splice(i, 1);
                        i--;
                  }
            }
            return lookahead;
      },

      /**
      *     lookahead: JSON object from PENG server
      *     return: an array containing lookahead data containing {cat, wfm}
      */
      createLookaheadTable: function(lookahead) {
            var wfm = [];
            var temp = [];
            for(i = 0; i < lookahead.cats.length; i++) {
                  var wfm = [];
                  for(j = 0; j < lookahead.wfms[i].length; j++) {
                        var word = lookahead.wfms[i][j].join(" ");
                        wfm.push(word);
                  }
                  temp.push({"cat": lookahead.cats[i], "wfm": wfm});
            }
            return temp;
      },

      /**
      *     lookahead: JSON object from PENG server
      *     return: an array containing lookahead data containing {cat, wfm}
      */
      createCatTable: function(lookahead) {
            var wfm = [];
            var temp = [];
            for(i = 0; i < lookahead.cats.length; i++) {
                  var wfm = [];
                  for(j = 0; j < lookahead.wfms[i].length; j++)
                        wfm.push(lookahead.wfms[i][j][0]);
                  temp.push(wfm);
            }
            return temp;
      },

      /**
      * Return: an array with str inserted in the head of wfm
      */
      addStrInHeadForEachCatInLookahead: function(str, lookaheadObject) {
            var catArr = ["intransitive verb", "transitive verb", "name", "count noun", "mass noun", "adjective", "adverb"];
            for(i = 0; i < lookaheadObject.length; i++) {
                  if(catArr.includes(lookaheadObject[i].cat)) {
                        if (lookaheadObject[i].cat != "name" && textLineData.nodes[textLineData.nodes.length-2] != " ") {
                              str = str.toLowerCase();
                        }
                        lookaheadObject[i].wfm.unshift("Add: "+str);
                  }
            }
            return lookaheadObject;
      },


}
