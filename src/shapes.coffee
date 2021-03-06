### 
cube
sphere
cylinder
?torus
?polygon3D

square
circle
plane
text
from points
?from lines
?polygon2D/shape
  
translate
rotate
scale

union
subtract
intersect
invert

cutByPlane
###

ObjectBase = require "./base"
#3d geometry
Cube = require "./3d/Cube"
Sphere = require "./3d/Sphere"
Cylinder = require "./3d/Cylinder" 

#2d geometry
#Rectangle = require "./2d/Rectangle"
#Circle = require "./2d/Circle"
#Text = require "./2d/Text"

module.exports = {ObjectBase:ObjectBase, Cube:Cube,Sphere:Sphere, Cylinder:Cylinder}
#module.exports = {ObjectBase:ObjectBase, Cube:Cube, Sphere:Sphere, Cylinder:Cylinder, Circle:Circle, Rectangle:Rectangle, Text: Text}
