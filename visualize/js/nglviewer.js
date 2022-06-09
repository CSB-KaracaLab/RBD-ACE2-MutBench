// NGL
document.addEventListener("DOMContentLoaded", function () {

  let stageParams = { backgroundColor: "white", tooltip: true};
  stage = new NGL.Stage("viewer", stageParams);

  // create tooltip element and add to the viewer canvas
  let tooltip = document.createElement("div");
  tooltip.setAttribute("id", "ngl-tooltip");
  Object.assign(tooltip.style, {
    display: "none",
    position: "absolute",
    zIndex: 10,
    pointerEvents: "none",
    backgroundColor: "rgba(0, 0, 0, 0.6)",
    color: "lightgrey",
    padding: "0.4em",
    fontFamily: "sans-serif"
  });
  stage.viewer.container.appendChild(tooltip);

  // Handle resizing events
  function handleResize() {
    stage.handleResize();
  }

  window.addEventListener("resize", handleResize, false);

  loadMolecule(stage, reference);

});

let schemeId = NGL.ColormakerRegistry.addScheme( function( params ){
    this.atomColor = function( atom ){
        if (atom.element == 'N'){
          return 0x427DA5;
        }
        else if (atom.element == 'O'){
          return 0x9D272D;
        }
        else if (atom.element == 'H'){
          return 0xf2f2f2;
        }
        else if (atom.element == 'S'){
          return 0xffb347;
        }
        else if (atom.element == 'C' && atom.chainname == 'A'){
          return 0xADD8E6;
        }
        else if (atom.element == 'C' && atom.chainname == 'E'){
          return 0xFF7B00;
        }
        else {
            return 0xFFFFFF;
        }
    };
} );

let mutSchemeId = NGL.ColormakerRegistry.addScheme( function( params ){
    this.atomColor = function( atom ){
      return 0xffff00;
    };
} );


// let schemeId = NGL.ColormakerRegistry.addSelectionScheme([
//   ["red", "_O"],
//   ["blue", "_N"],
//   ["gold", "_S"],
//   ["lightgray", '_C'],
//   ["white", "*"]
// ], "lightscheme");

function selectInterface(c) {
  // Because NGL is incredibly clutsy, we have to do this..

  let radius = 10.0;
  let selection = '';
  let neighborsE;
  let neighborsA;

  // neighbors of B belonging to A
  nglsele = new NGL.Selection(":E");
  neighborsE = c.structure.getAtomSetWithinSelection(nglsele, radius);
  neighborsE = c.structure.getAtomSetWithinGroup(neighborsE);
  selection += "((" + neighborsE.toSeleString() + ") and :A)"

  nglsele = new NGL.Selection(":A");
  neighborsA = c.structure.getAtomSetWithinSelection(nglsele, radius);
  neighborsA = c.structure.getAtomSetWithinGroup(neighborsA);
  selection += "or ((" + neighborsA.toSeleString() + ") and :E)"

  return selection

}

// Load molecule function
function loadMolecule(stage, model) {
    
    let components = stage.compList;
   // alert(components)
    component = stage.loadFile(
      model,
      { ext: "pdb" }
    ).then( function (c) {

      c.addRepresentation(
        'cartoon',
        {
          sele: 'protein', 
          color: schemeId,
          aspectRatio: 5.0,
          // quality: 'high' 
        }
      );

      c.addRepresentation(
        'hyperball',
        {
          sele: selectInterface(c),
          color: schemeId
        }
      );

      if (components.length > 1) {
        // Superpose on previous

        c.superpose(
          components[0],
          true,
          ".CA",
          ".CA"
        );
      } else {
        // Adjust view to loaded molecule
        // Do it on first only, since all others are aligned
        let pa = c.structure.getView(new NGL.Selection(".CA or .C5'")).getPrincipalAxes();
        stage.animationControls.rotate(pa.getRotationQuaternion(), 0);
        stage.autoView();
      }

    });

}

function removeMolecule(stage, pdburl) {

    let components = stage.compList;
    for (let i = 0; i < components.length; i++){
      s = components[i].structure;
      if (s.path == pdburl) {
        stage.removeComponent(components[i])
      }
    }

}

function highlightMutations() {

  // colors carbons of mutated residues in yellow

  let components = stage.compList;
  for (let i = 0; i < components.length; i++){
    let c = components[i];

    let mutations = "";

    let modelName = c.object.name;
    let tokens = modelName.split('_');
   
    let nmut = 0;
    for (let t = 0; t < tokens.length-1; t++ ){  // skip first
      //alert(tokens[t])
      if(tokens[t] != "6m0j"){
        let number = tokens[t].replace(/\D/g, '');
        //alert(number)
        if (!number) {
          continue
        }
        mutations = mutations + ' ' + number;
        nmut++;
      }
      }

    if (nmut > 0){
      let atomsele = ':A and (' + mutations + ') and .CA';
      // RBD -> E484K | N501Y | S477N
      if (tokens[0] == "E484K" | tokens[0] == "N501Y" | tokens[0] == "S477N" ){
       atomsele = ':E and (' + mutations + ') and .CA';
       
      } 
     // alert(atomsele)
      c.addRepresentation(
        'spacefill',
        {
          sele: atomsele,
          color: mutSchemeId
        }
      );
    }
  }
}

function hideMutations() {
  let components = stage.compList;
  for (let i = 0; i < components.length; i++){
    let c = components[i];
    for (let r = 0; r < c.reprList.length; r++ ) {
      if (c.reprList[r].getType() == 'spacefill') {
        c.removeRepresentation(c.reprList[r])
      }
    }
 }
}

function toggleMutations() {
  let label = document.getElementById('muta-toggler')
  if (label.innerText.trim() == "Highlight Mutations") 
  {
    label.innerText = "Hide Mutations";
    highlightMutations()
  }
  else {
    label.innerText = "Highlight Mutations";
    hideMutations()
  }
}

function toggleReference() {
  let label = document.getElementById('refe-toggler')
  if (label.innerText.trim() == "Show Reference") 
  {
    label.innerText = "Hide Reference";
    loadMolecule(stage, reference);
  }
  else {
    label.innerText = "Show Reference";
    removeMolecule(stage, reference);
  }
}

function toggleContacts() {

  let components = stage.compList;

  let label = document.getElementById('cont-toggler')
  if (label.innerText.trim() == "Show Contacts") 
  {
    label.innerText = "Hide Contacts";

    for (let i = 0; i < components.length; i++){
      c = components[i];
      // Show interface as hyperballs
      c.addRepresentation(
        'contact',
        {
          sele: selectInterface(c)
        }
      );
    }
  }
  else {
    label.innerText = "Show Contacts";

    for (let i = 0; i < components.length; i++){
      c = components[i];
      let repr = null;
      for(let j = 0; j < c.reprList.length; j++) {
        let r = c.reprList[j];
        if (r.name == 'contact') {
          repr = r;
        }
      }
      if (repr) {
        c.removeRepresentation(repr)
      }
    }
  }
}
