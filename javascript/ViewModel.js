/**
*   Author: Rudz Evan Bernardez, Macquarie University
*   File Name: ViewModel.js
*
*/

var viewModel = {
      $text_field: $("#text_field"),
      textAreaStr: ko.observableArray([]), // For dispaly
      result: ko.observable(""),
      firstIndexOfCurrentWord: 0,

      token: ko.observable(""),
      textList: ko.observableArray([]),
      smallAsp: "",
      bigAsp: "",
      aspState: false,

      $procSpan: $("#proc-span"),

      allowInit: true,
      // CLASSES
      lookahead: Lookahead,
      allowInput: true,

      catTable: ko.observableArray([]),
      anaExp: ko.observableArray([]),

      lookaheadObject: ko.observableArray([]),

      reasonerMode: "normal", // default settings
      inputMode: ko.observable("Text Mode"), //default settings
      speechData: ko.observable(""),

      $loader: $(".loader"),


      textParaList: ko.observableArray([]),


      submitButton: function() {
            KeyHandler.enterKey();
      },

      changeToTextMode: function() {
            $("#start_button").hide();
            $("#speech-detected").hide();
            this.inputMode("Text Mode");
            $('.searchbox-div').css('height', "220px");
      },

      changeToSpeechMode: function() {
            $("#start_button").show();
            $("#speech-detected").show();
            this.inputMode("Speech Mode");
            $('.searchbox-div').css('height', "240px");
            init();
            this.init();
      },

      changeToNormal: function() {
            this.reasonerMode = "normal"
      },

      changeToBrave: function() {
            this.reasonerMode = "brave";
      },

      changeToCautious: function() {
            this.reasonerMode = "cautious";
      },

      loadLookahead: function() {
            this.init();  // only needed at first load
            var lookaheadTable = this.lookahead.createLookaheadTable(this.lookahead);
            this.lookaheadObject(lookaheadTable);
      },

      loadLookahead2: function() {
            var lookaheadTable = this.lookahead.createLookaheadTable(this.lookahead);
            this.lookaheadObject(lookaheadTable);
      },

      postWordClicked: function(data, event) {
            clickHelper.postWordClicked(data, event);
      },

      postAnaExpClicked: function() {
            clickHelper.postAnaExpClicked(this);
      },

      lookUpTable: ko.observableArray([]),
      asp: ko.observable(''),
      answer: ko.observable(''),
      currentInitialLookUpTable: [],
      initSentenceLookUp: [],

      asyncFlag: false,

      fileNames: ko.observableArray([]),
      //WIDGETS
      loadFileNames: function() {

            if(viewModel.fileNames().length == 0) {
                  var jsonObj = this.createJsonObject("load", " ", " ", " ", "off", "normal");
                  $.ajax({
                        url : "/peng/",
                        type: "POST",
                        data : jsonObj,
                        success: function(data, textStatus, jqXHR)
                        {
                              var json = JSON.parse(data);
                              fnames = json.filenames.slice(1,  json.filenames.length);
                              viewModel.fileNames(fnames);
                        },
                        error: function (jqXHR, textStatus, errorThrown)
                        {
                              alert("Failed input on loading file names: \n "+errorThrown);
                        }
                  });
            }


      },

      // Load a single file name
      loadFile: function() {

            var fileNameClicked = this;
            if (textLineData.nodes.length < 2) {

                  viewModel.loadFile1(this);


            }
            else { // GOES HERE WHEN SPECIFICATION IS POPULATED

            $( "form" ).dialog({
                  open: function() {
                  // On open, hide the original submit button
                  $( this ).find( "[type=submit]" ).hide();
                  },
                  buttons: [
                        {
                            text: "Save",
                            click: function() {
                                 saveFile($("#textSave").val());
                                 textLineData.clearAll();
                                 viewModel.textList([]);
                                 viewModel.loadFile1(fileNameClicked);
                                 $( this ).dialog( "close" );
                            }
                        },
                     {
                        text: "Clear",
                        click: function() {
                              textLineData.clearAll();
                              viewModel.textList([]);
                              $( this ).dialog( "close" );
                        }
                  },
                    {
                        text: "Close",
                        click: function() {
                              $( this ).dialog( "close" );
                        }
                    }
                  ]
                  });

            return false;
            }


            return true;
      },

      loadFile1: function(fname) {
            viewModel.$loader.css("visibility", "hidden");

            var jsonObj = viewModel.createJsonObject("load", " ", fname, " ", "off", "normal");
            var str = JSON.stringify(this);
            str = str.replace(" ", "");
            str = str.replace('"', "");
            str = str.replace('"', "");
            var index = viewModel.fileNames().indexOf(str);
            var fn = viewModel.fileNames();
            fn.splice(index, 1);
            viewModel.fileNames(fn);

            $.ajax({
                  url : "/peng/",
                  type: "POST",
                  data : jsonObj,
                  success: function(data, textStatus, jqXHR)
                  {
                        SuccessHelper.loadSingleTextFile(data, textStatus, jqXHR);

                  },
                  error: function (jqXHR, textStatus, errorThrown)
                  {
                        alert("Failed JSON object input when loading file: \n "+errorThrown);
                  }
            });
      },


      updateLookUpTable: function() {
            // This concat must be done to avoid unwanted changes in to other data structures
            var tempLookAheadTable = [].concat(this.lookUpTable());
            this.lookUpTable(this.lookahead.filterTable(this.token(), tempLookAheadTable));

      },

      init: function() {
            var lastNodePostedWasBlank = textLineData.nodes[textLineData.nodes.length-1] != " ";
            var textAreaEmpty = this.textAreaStr().length == 0
            if (textAreaEmpty && lastNodePostedWasBlank) {
                  this.postToken(" ");
                  this.initSentenceLookUp = this.lookUpTable();
                  this.initLookUpObj = this.lookaheadObject();
            }
            else if (this.allowInput){
                  this.$text_field.val(this.textAreaStr());
            }
      },

      populateLookUpTable: function(data) {
            this.lookahead.setAll(data);
            //      this.loadLookahead();  // NEEDS TO BE REMOVED FOR SINGLE FILE LOADING
            this.lookUpTable(this.lookahead.getWordTable());
      },

      setAnswer: function(ansData) {
            var ans = "";
            for(var s = 0; s < ansData.length; s++) {
                  ans += ansData[s]+"\n";
            }
            this.answer(ans);
      },

      setAsp: function(aspData) {
            var asp = aspData.asp;
            var clingo = aspData.reasoner;
            this.bigAsp = asp;
            var index = this.bigAsp.search("% -----------------------------");
            this.smallAsp = this.bigAsp.slice(0, index);

            if (this.aspState) {
                  this.asp(this.bigAsp);
            }
            else {
                  this.asp(this.smallAsp);
            }

            this.result(clingo);
            this.allowInput = true;
      },

      postToken2(word) {
            var wordData =  textLineData.createNode(word, this.reasonerMode);
            var request = $.ajax({
                  url : "/peng/",
                  type: "POST",
                  data : wordData,
                  async: this.asyncFlag
            });
            return request;
      },

      postToken(word) {
            // If word in lookahead
            var request = $.when(this.postToken2(word));
            request.done(function(data)
            {
                  var json = JSON.parse(data);
                  if (word == "." || word == "?") {
                        viewModel.setAsp(json);
                        if(word == "?") {
                              viewModel.setAnswer(json.answer);
                        }
                        // need to get generated paraphrases
                        var para = json.para;
                        var newPara = [];
                        var s = "";
                        for(var z = 0; z < para.length; z++) {
                              if(para[z] == "?" || para[z] == ".") {
                                    s = s.slice(0, s.length-1) + para[z];
                                    newPara.push(s)
                                    s = "";
                              }
                              else if(para[z] == ",") {
                                    s = s.slice(0, s.length-1) + para[z]+" ";
                              }
                              else {
                                    s += para[z] + " ";
                              }
                        }
                        viewModel.textParaList(newPara);

                        viewModel.allowInput = true;
                  }

                  if(json.hasOwnProperty('spelling suggestions') || (json.lookahead.length == 0 && !json.hasOwnProperty('asp'))) {
                        viewModel.allowInput = false;
                        var lAhead = Lookahead.createLookaheadTable(Lookahead);
                        lAhead = Lookahead.addStrInHeadForEachCatInLookahead(word, lAhead);

                        var sliceEndPos = viewModel.textAreaStr().length - word.length;
                        console.log(viewModel.firstIndexOfCurrentWord);
                        viewModel.textAreaStr(viewModel.textAreaStr().slice(0, sliceEndPos));

                        viewModel.lookaheadObject(lAhead);
                  }
                  else {
                        viewModel.populateLookUpTable(json);
                        viewModel.loadLookahead2(); // MAYBE REMOVE IF
                        viewModel.allowInput = true;
                  }

                  if(json.hasOwnProperty('ana') && word != "." && json.ana.length != 0) {
                        var temp = json.ana;
                        for(i = 0; i < json.ana.length; i++) {
                              if(json.ana[i].length > 1) {
                                    temp[i] = [temp[i].join(" ")];

                              }
                              else {
                                    temp[i] = json.ana[i];
                              }
                        }
                        viewModel.anaExp(temp);
                  }

            });

      },

      postSpeechToken: function(words) {

            var newWords = words.replace(",", " ");
            newWords = newWords.replace(".", " .");
            newWords = newWords.split(" ");

            var currentWords = "";
            for (var t = 0; t < newWords.length; t++) {
                  // FORMAT TO USER STRING I.E READABLE
                  var len = currentWords.length;

                  if (newWords[t] == ",") {
                        currentWords = currentWords.slice(0, len-1)+newWords[t]+" ";
                  }
                  else if (newWords[t] == "." || newWords[t] == "?") {
                        currentWords = currentWords.slice(0, len-1)+newWords[t];

                  }
                  else {
                        currentWords += (newWords[t] + " ");
                  }
                  this.textAreaStr(currentWords);
                  this.$text_field.val(currentWords);
                  this.postToken(newWords[t]);

                  if (!this.allowInput) {
                        this.textAreaStr(currentWords.slice(0, len-1));
                        break;
                  }
                  else {
                        this.token(newWords[t]);
                  }
            // SPEECH DATA CLEAR
            }
            this.speechData("");
            this.token("");
      },

contains: function(target, arr) {
      for (i = 0; i < arr.length; i++) {
            if (target == arr[i]) {
                  return true;
            }
      }
      return false;
},


keyHandler: function(d, e) {
      return KeyHandler.keyUpdate(d, e);
},


backSpaceHandler: function(d, e) {
      KeyHandler.backspace(d, e);
},

createJsonObject: function(emode, token, fname, stext, reason, rmode) {
      var object = {
            id: -1,
            inputmode:"text",
            editmode:emode,
            token: token,
            nbest:"[]",
            featurestructure:"{ \"cat\" : \" \",  \"wfm\" : \" \"}",
            filename: fname,
            spectext: stext,
            snum: -1,
            spos: -1,
            reasoner: reason,
            reasonermode: rmode
      }
      return object;
}


};

ko.applyBindings(viewModel);

function saveButton() {
      var file_name = prompt("Save as...");
      if (file_name != null) {
            if (file_name != "") {
                  file_name += ".txt";
                  alert(file_name);
                  saveFile(file_name);
            }
            else {
                  alert("Please enter a file name");
                  saveButton();
            }
    }
};

var saveFile = function(file_name) {
      var spectext = "";
      for (var i = 0; i < textLineData.sentences.length; i++) {
            textLineData.sentences[i] = textLineData.sentences[i].split('\r').join('');
            spectext += ('\n'+textLineData.sentences[i]+'\n');
      }

      var saveData = {
            "id":"-1",
            "inputmode":"text",
            "editmode":"save",
            "token":" ",
            "nbest":"[]",
            "featurestructure":"{ \"cat\" : \" \",  \"wfm\" : \" \"}",
            "filename":file_name,
            "spectext":spectext,
            "snum":"0",
            "spos":"0",
            "reasoner":"off",
            "reasonermode":"normal"
      }
      $.ajax({
            url : "/peng/",
            type: "POST",
            data : saveData
      });
      alert("File saved");
}

var addToLexicon = function(cat, wfm, vform, num) {
      var idNum = textLineData.nodes.length ;
      var featstruct = FeatureStructure.createFS(cat, wfm, vform, num);
      console.log(featstruct);
      var addData = {
            "id": idNum,
            "inputmode":"text",
            "editmode":"add",
            "token": wfm,
            "nbest":"[]",
            "featurestructure":featstruct,
            "filename":" ",
            "spectext":" ",
            "snum":textLineData.sentences.length+1,
            "spos":textLineData.getSpos() -1,
            "reasoner":"off",
            "reasonermode":"normal"
      }

      $.ajax({
            url : "/peng/",
            type: "POST",
            data : addData
      });
}



$( document ).ready(function() {


$(".dropdown-menu").delegate("li", "click", function() {
      var str = JSON.stringify($(this).html());
      var addRegex = /Add/i
      var saveRegex = /Save/i
      var loadRegex = /Load/i

      var notFile = !(addRegex.test(str) || saveRegex.test(str) );

      if(notFile) {
            $(this).addClass("active").siblings().removeClass("active");
      }

});

// FOR MENU COLOR

            $('ul.dropdown-menu [data-toggle=dropdown]').on('click', function(event) {
                  event.preventDefault();
                  event.stopPropagation();
                  $(this).parent().siblings().removeClass('open');
                  $(this).parent().toggleClass('open');
            });



// NEED FOR TABS
$('.collapse').on('shown.bs.collapse', function(){
      $(this).parent().find(".glyphicon-plus").removeClass("glyphicon-plus").addClass("glyphicon-minus");
}).on('hidden.bs.collapse', function(){
      $(this).parent().find(".glyphicon-minus").removeClass("glyphicon-minus").addClass("glyphicon-plus");
});


/// for asp toggle (dev mode)
$("[name='my-checkbox']").bootstrapSwitch();
$('input[name="my-checkbox"]').on('switchChange.bootstrapSwitch', function(event, state) {
      if (state) {
            viewModel.asp(viewModel.bigAsp);
      }
      else {
            viewModel.asp(viewModel.smallAsp);
      }
      viewModel.aspState = state;
});

});
