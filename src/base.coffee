THREE = require 'three'
maths = require "usco-maths"
ThreeBSP =  require( '../vendor/ThreeCSG' )
  
#TODO: where to do canonicalization and normalization?
#TODO: review inheritance : basic geometry (cube, sphere) should not have children etc (like "mesh") but should have position, rotation etc
#TODO: add connectors
#TODO: since we want objects / parts to be exportable individually, perhaps adding "export" methods to them
# would be a good idea ...
Vector3 = maths.Vector3


class ObjectBase extends THREE.Mesh
  #base class regrouping features of THREE.Mesh and THREE.CSG
  
  constructor:( geometry, orientation, material )->
    if not material?
      material = new THREE.MeshPhongMaterial({color:  0xFFFFFF , shading: THREE.SmoothShading,  shininess: 0, specular: 0, metal: false}) 
    #super(geometry, material)
    if not geometry?
      geometry = null
    THREE.Mesh.call( @, geometry, material )
    
    orientation = orientation or new Vector3(0,0,1)

    @bsp = null

    
    #VERY important : transforms stack : all operations done on this shape is stored here
    #TODO: should we be explicit , ie in basic shape class, or do it in processor/preprocessor
    @transforms = []
    @connectors = []
    @defaults = {}
  
  #------base transforms--------#
  translate:( amount )->
    tVector = toVector3( amount )
    
    #TODO: work around these, for more efficiency)
    @translateX( tVector.x )
    @translateY( tVector.y )
    @translateZ( tVector.z )
    
    #TODO: add actual data structures for this
    @transforms.push( "T:"+tVector )
    
  rotate:( amount )->
    rVector = toVector3( amount )
    euler = new THREE.Euler( rVector.x, rVector.y, rVector.z)
    
    @setRotationFromEuler( euler )
    
    #TODO: add actual data structures for this
    @transforms.push( "R:"+rVector )
  
  #------backwards compatibility------#
  color:(rgba)->
    @material.color = rgba
    
  #------CSG Methods------#
  union:(object)=>
    @bsp = new ThreeBSP(@)
    if not object.bsp?
      object.bsp = new ThreeBSP(object)
    @bsp = @bsp.union( object.bsp )
    #TODO : only generate geometry on final pass ie make use of csg tree or processing tree/ast
    @geometry = @bsp.toGeometry()
    @geometry.computeVertexNormals()
    
  subtract:(object)=>
    @bsp = new ThreeBSP(@)
    
    object.bsp = new ThreeBSP(object)
    @bsp = @bsp.subtract( object.bsp )
    #TODO : only generate geometry on final pass ie make use of csg tree or processing tree/ast
    @geometry = @bsp.toGeometry()
    @geometry.computeVertexNormals()
    
    @geometry.computeBoundingBox()
    @geometry.computeCentroids()
    @geometry.computeFaceNormals();
    @geometry.computeBoundingSphere()
    
  intersect:=>
    @bsp = @bsp.intersect( object.bsp )
    #TODO : only generate geometry on final pass ie make use of csg tree or processing tree/ast
    @geometry = @bsp.toGeometry()
    @geometry.computeVertexNormals()
    
  inverse:=>
    @bsp = @bsp.invert()
    #TODO : only generate geometry on final pass ie make use of csg tree or processing tree/ast
    @geometry = @bsp.toGeometry()
    @geometry.computeVertexNormals()
  
module.exports = ObjectBase
