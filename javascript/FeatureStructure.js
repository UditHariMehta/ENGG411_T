

var FeatureStructure = {


      createFS: function(cat, wfm, vform, num) {
            if (cat == "intransitive verb" || cat == "transitive verb")
                  return this.createFS_verb(cat, wfm, vform, num);
            else if (cat == "name")
                  return this.createFS_name(cat, wfm);
            else if (cat == "count noun" || cat == "mass noun")
                  return this.createFS_noun(cat, wfm, num);
            else if (cat == "adjective" || cat == "adverb")
                  return this.createFS_adjective_adverb(cat, wfm);
      },

      createFS_verb: function(cat, wfm, vform, num) {

            if (vform == "inf")
                  return "{ \"cat\" : \""+cat+"\",  \"wfm\" :"+ "\""+wfm+"\"" +", \"vform\" : \""+vform+"\"}";
            else
                  return "{ \"cat\" : \""+cat+"\",  \"wfm\" :"+ "\""+wfm+"\"" +", \"vform\" : \""+vform+"\",  \"num\" : \""+num+"\"}";
      },

      createFS_name: function(cat, wfm) {
            var num = "Num";
            return "{ \"cat\" : \""+cat+"\",  \"wfm\" :"+ "\""+wfm+"\"" +", \"num\" : \""+num+"\"}"
      },

      createFS_noun: function(cat, wfm, num) {
            if (cat == "count noun")
                  return "{ \"cat\" : \""+cat+"\",  \"wfm\" :"+ "\""+wfm+"\"" +", \"num\" : \""+num+"\"}";
            else
                  return "{ \"cat\" : \""+cat+"\",  \"wfm\" :"+ "\""+wfm+"\"}";
      },

      createFS_adjective_adverb: function(cat, wfm) {
            return "{ \"cat\" : \""+cat+"\",  \"wfm\" :"+ "\""+wfm+"\"}";
      }

}
