--- 3D vector implementation in lua
-- Was created as inline library to use in Principia game
-- This file is mostly for documentation, you might want to use minified version in your code
-- Minified version https://github.com/mrsimb/lua-vec/blob/main/vec.min.lua
-- @author mrsimb https://github.com/mrsimb

Vec = {}
Vec.protomt = {}
Vec.mt = {}
Vec.mt.__index = Vec

setmetatable(Vec, Vec.protomt)

-- Static methods

--- Vec() constructor
-- @return Vec
-- @see Vec.from
function Vec.protomt:__call(x, y, z)
  return Vec.from(x, y, z)
end

--- Constructs new vector. Call Vec() directly to achieve same result
-- @param x number | table | Vec = 0
-- @param y number = 0
-- @param z number = 0
-- @return Vec
-- @usage Vec(1, 0, 0)
-- @usage Vec({1, 0, 0})
-- @usage Vec({x = 1, y = 0, z = 0})
-- @usage Vec(anotherVector)
function Vec.from(x, y, z)
  if (type(x) == 'table') then
    return Vec.from(x.x or x[1], x.y or x[2], x.z or x[3])
  end
  
  local v = {}

  v.x = x or 0
  v.y = y or 0
  v.z = z or 0
  
  setmetatable(v, Vec.mt)

  return v
end

--- Returns normalized vector from 2D angle
-- @param a number = 0
-- @return Vec
-- @usage Vec.fromAngle(0) -> {1, 0, 0}
function Vec.fromAngle(a)
  return Vec.from(math.cos(a or 0), math.sin(a or 0))
end

--- Returns normalized vector from random 2D angle
-- @return Vec
function Vec.random2d()
  local a = math.random() * math.pi * 2;
  return Vec.fromAngle(a)
end

--- Returns normalized random vector
-- @return Vec
function Vec.random()
  return Vec(
    math.random() * 2 - 1,
    math.random() * 2 - 1,
    math.random() * 2 - 1
  ):norm()
end

-- Metamethods

--- + operator
-- @param v number | table | Vec
-- @return Vec
-- @usage Vec(1, 2, 3) + 10 -> {11, 12, 13}
-- @usage Vec(1, 2, 3) + Vec(10, 0, 0) -> {11, 2, 3}
-- @see Vec:add
function Vec.mt:__add(v)
  return self:add(v, v, v)
end

--- - operator (binary)
-- @param v number | table | Vec
-- @return Vec
-- @usage Vec(1, 2, 3) - 10 -> {-8, -7, -6}
-- @usage Vec(1, 2, 3) - Vec(10, 0, 0) -> {-8, 2, 3}
-- @see Vec:sub
function Vec.mt:__sub(v)
  return self:sub(v, v, v)
end

--- - operator (unary)
-- @usage -Vec(1, 2, 3) -> {-1, -2, -3}
-- @return Vec
function Vec.mt:__unm()
  return self:mul(-1, -1, -1)
end

--- * operator
-- @param v number | table | Vec
-- @return Vec
-- @usage Vec(1, 2, 3) * 10 -> {10, 20, 30}
-- @usage Vec(1, 2, 3) * Vec(10, 1, 1) -> {10, 2, 3}
-- @see Vec:mul
function Vec.mt:__mul(v)
  return self:mul(v, v, v)
end

--- / operator
-- @param v number | table | Vec
-- @return Vec
-- @usage Vec(1, 2, 3) / 10 -> {0.1, 0.2, 0.3}
-- @usage Vec(1, 2, 3) / Vec(10, 1, 1) -> {0.1, 2, 3}
-- @see Vec:div
function Vec.mt:__div(v)
  return self:div(v, v, v)
end

--- ^ operator
-- @param v number | table | Vec
-- @return Vec
-- @usage Vec(1, 2, 3) ^ 2 -> {1, 4, 9}
-- @usage Vec(1, 2, 3) ^ Vec(1, 1, 2) -> {1, 2, 9}
-- @see Vec:pow
function Vec.mt:__pow(v)
  return self:pow(v, v, v)
end

--- == operator
-- @param v Vec
-- @return boolean Vector equals to input
-- @usage Vec(1, 2, 3) == Vec(1, 2, 3) -> true
-- @see Vec:eq
function Vec.mt:__eq(v)
  return self:eq(v)
end

--- < operator
-- @param v Vec
-- @return boolean Vector magnitude is less than input
-- @usage Vec(1, 2, 3) < Vec(3, 3, 3) -> true
-- @see Vec:lt
function Vec.mt:__lt(v)
  return self:lt(v)
end

--- <= operator
-- @param v Vec
-- @return boolean Vector magnitude is less than or equal to input
-- @usage Vec(1, 2, 3) <= Vec(3, 3, 3) -> true
-- @see Vec:lt
function Vec.mt:__le(v)
  return self:le(v)
end

--- .. operator
-- @param a string | Vec
-- @param b string | Vec
-- @return string
-- @usage 'Position is ' .. Vec(1, 2, 3) -> 'Position is {1, 2, 3}'
function Vec.mt.__concat(a, b)
  return tostring(a) .. tostring(b)
end

--- tostring()
-- @return string
-- @usage print(Vec(1, 2, 3)) -> '{1, 2, 3}'
function Vec.mt:__tostring()
  return self:toString()
end

-- Public methods

--- Sets vector components to input. Accepts numbers, table or Vec
-- @param x number | table | Vec = self.x
-- @param y number = self.y
-- @param z number = self.z
-- @return Vec self
-- @usage Vec(1, 2, 3):set(10) -> {10, 2, 3}
-- @usage Vec(1, 2, 3):set(nil, nil, 10) -> {1, 2, 10}
function Vec:set(x, y, z)
  local v = Vec.from(x or self.x, y or self.y, z or self.z)
  self.x = v.x
  self.y = v.y
  self.z = v.z
  return self
end

--- Returns string representation of vector
-- @return string
-- @usage Vec(1, 2, 3):toString() -> '{1, 2, 3}'
function Vec:toString()
  return '{' .. self.x .. ', ' .. self.y .. ', ' .. self.z .. '}'
end

--- Returns array of vector components
-- @return table
-- @usage Vec(1, 2, 3):toArray() -> {1, 2, 3}
function Vec:toArray()
  return {self.x, self.y, self.z}
end

--- Sets vector component by numeric index
-- @param idx number Index of component
-- @param n number New value
-- @return Vec
-- @usage Vec(5, 6, 7):setAt(3, 10) -> {5, 6, 10}
function Vec:setAt(idx, n)
  if (idx == 1) then
    self.x = n
  elseif (idx == 2) then
    self.y = n
  elseif (idx == 3) then
    self.z = n
  end
end

--- Gets vector component value by numeric index
-- @param idx number Index of component
-- @return number
-- @usage Vec(5, 6, 7):getAt(3) -> 7
function Vec:getAt(idx)
  if (idx == 1) then
    return self.x
  elseif (idx == 2) then
    return self.y
  elseif (idx == 3) then
    return self.z
  end
end

--- Returns vectors sum
-- @param x number | table | Vec = 0
-- @param y number = 0
-- @param z number = 0
-- @return Vec
-- @usage Vec(1, 2, 3):add(10) -> {11, 2, 3}
-- @usage Vec(1, 2, 3):add(10, 10, 10) -> {11, 12, 13}
function Vec:add(x, y, z)
  local v = Vec.from(x or 0, y or 0, z or 0)
  return Vec.from(self.x + v.x, self.y + v.y, self.z + v.z)
end

--- Returns vectors difference
-- @param x number | table | Vec = 0
-- @param y number = 0
-- @param z number = 0
-- @return Vec
-- @usage Vec(1, 2, 3):sub(10) -> {-9, 2, 3}
-- @usage Vec(1, 2, 3):sub(10, 10, 10) -> {-9, -8, -7}
function Vec:sub(x, y, z)
  local v = Vec.from(x or 0, y or 0, z or 0)
  return Vec.from(self.x - v.x, self.y - v.y, self.z - v.z)
end

--- Returns vector whose components are multiplicated by input
-- @param x number | table | Vec = 1
-- @param y number = 1
-- @param z number = 1
-- @return Vec
-- @usage Vec(1, 2, 3):mul(10) -> {10, 2, 3}
-- @usage Vec(1, 2, 3):mul(10, 10, 10) -> {10, 20, 30}
function Vec:mul(x, y, z)
  local v = Vec.from(x or 1, y or 1, z or 1)
  return Vec.from(self.x * v.x, self.y * v.y, self.z * v.z)
end

--- Returns vector whose components are divided by input
-- @param x number | table | Vec = 1
-- @param y number = 1
-- @param z number = 1
-- @return Vec
-- @usage Vec(1, 2, 3):div(10) -> {0.1, 2, 3}
-- @usage Vec(1, 2, 3):div(10, 10, 10) -> {0.1, 0.2, 0.3}
function Vec:div(x, y, z)
  local v = Vec.from(x or 1, y or 1, z or 1)
  return Vec.from(self.x / v.x, self.y / v.y, self.z / v.z)
end

--- Returns vector whose components are raised by input
-- @param x number | table | Vec = 1
-- @param y number = 1
-- @param z number = 1
-- @return Vec
-- @usage Vec(2, 3, 4):pow(3) -> {8, 3, 4}
-- @usage Vec(2, 3, 4):pow(3, 3, 3) -> {8, 27, 64}
function Vec:pow(x, y, z)
  local v = Vec.from(x or 1, y or 1, z or 1)
  return Vec.from(self.x ^ v.x, self.y ^ v.y, self.z ^ v.z)
end

--- Returns true if vector and input are equal
-- @param x number | table | Vec
-- @param y number
-- @param z number
-- @return boolean
-- @usage Vec(2, 3, 4):eq(2, 3, 4) -> true
function Vec:eq(x, y, z)
  local v = Vec.from(x, y, z)
  return self.x == v.x and self.y == v.y and self.z == v.z
end

--- Returns true if vector magnitude is less than input
-- @param x number | table | Vec
-- @param y number
-- @param z number
-- @return Vec
-- @usage Vec(2, 3, 4):lt(10, 10, 10) -> true
function Vec:lt(x, y, z)
  return self:len() < Vec.from(x, y, z):len()
end

--- Returns true if vector magnitude is less than or equal to input
-- @param x number | table | Vec
-- @param y number
-- @param z number
-- @return boolean
-- @usage Vec(2, 3, 4):le(10, 10, 10) -> true
function Vec:le(x, y, z)
  return self:len() <= Vec.from(x, y, z):len()
end

--- Returns true if vector magnitude is greater than input
-- @param x number | table | Vec
-- @param y number
-- @param z number
-- @return boolean
-- @usage Vec(2, 3, 4):gt(0, 0, 0) -> true
function Vec:gt(x, y, z)
  return self:len() > Vec.from(x, y, z):len()
end

--- Returns true if vector magnitude is greater than or equal to input
-- @param x number | table | Vec
-- @param y number
-- @param z number
-- @return boolean
-- @usage Vec(2, 3, 4):ge(0, 0, 0) -> true
function Vec:ge(x, y, z)
  return self:len() >= Vec.from(x, y, z):len()
end

--- Returns vector magnitude (length)
-- @return number
-- @usage Vec(10, 0, 0):len() -> 10
function Vec:len()
  return math.sqrt(self:lenSq())
end

--- Returns vector magnitude (length) squared
-- @return number
-- @usage Vec(10, 0, 0):len() -> 100
function Vec:lenSq()
  return self.x ^ 2 + self.y ^ 2 + self.z ^ 2
end

--- Returns distance beetween vectors
-- @return number
-- @usage Vec(10, 0, 0):dist(15, 0, 0) -> 5
function Vec:dist(x, y, z)
  return math.sqrt(self:distSq(x, y, z))
end

--- Returns distance squared between vectors
-- @return number
-- @usage Vec(10, 0, 0):distSq(15, 0, 0) -> 25
function Vec:distSq(x, y, z)
  local v = Vec.from(x, y, z)
  return self:sub(v):lenSq()
end

--- Returns vectors cross product
-- @param x number | table | Vec
-- @param y number
-- @param z number
-- @return Vec
-- @usage Vec(3, -3, 1):cross(4, 9, 2) -> {-15, -2, 39}
function Vec:cross(x, y, z)
  local v = Vec.from(x, y, z)
  return Vec.from(
    self.y * v.z - self.z * v.y,
    self.z * v.x - self.x * v.z,
    self.x * v.y - self.y * v.x
  )
end

--- Returns vectors dot product
-- @param x number | table | Vec
-- @param y number
-- @param z number
-- @return number
-- @usage Vec(1, 2, 3):cross(6, 7, 8) -> 44
function Vec:dot(x, y, z)
  local v = Vec.from(x, y, z)
  return self.x * v.x + self.y * v.y + self.z * v.z
end

--- Returns normalized vector
-- @return Vec
-- @usage Vec(10, 5, 0):norm() -> {0.89442719099992, 0.44721359549996, 0}
function Vec:norm()
  local len = self:len()
  return len == 0 and self or self / len
end

--- Returns vector with magnitude limited by number
-- @param n number
-- @return Vec
-- @usage Vec(10, 5, 0):limit(2) -> {0.97014250014533, 0.24253562503633, 0}
function Vec:limit(n)
  return self:norm():mul(n)
end

--- Returns 2D rotation angle of vector
-- @return number
-- @usage Vec(-1, 0, 0):angle2d() -> 3.1415926535898
function Vec:angle2d()
  return math.atan2(self.y, self.x)
end

--- Returns angle between 3D vectors
-- @param x number | table | Vec
-- @param y number
-- @param z number
-- @return number
function Vec:angleBetween(x, y, z)
  local v = Vec.from(x, y, z)
  return math.acos(self:dot(v) / (self:len() * v:len()))
end

--- Returns vector with 2D rotation applied to it
-- @param a number
-- @return Vec
function Vec:rotate2d(a)
  local v = Vec.from(self)
  local na = self:angle2d() + a
  local m = self:len()
  v.x = math.cos(na) * m
  v.y = math.sin(na) * m
  return v
end

--- Returns linear interpolation between vectors
-- @param n number
-- @param x number | table | Vec
-- @param y number
-- @param z number
-- @return Vec
-- @usage Vec(10, -10, 2):lerp(0.5, {20, 10, 1}) -> {15, 0, 1.5}
function Vec:lerp(n, x, y, z)
  local v = Vec.from(x, y, z)
  return Vec.from(
    self.x + (v.x - self.x) * n,
    self.y + (v.y - self.y) * n,
    self.z + (v.z - self.z) * n
  )
end
