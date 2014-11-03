Import mojo



Const SCREEN_WIDTH:Int = 640
Const SCREEN_HEIGHT:Int = 480

Const TILE_WIDTH:Int = 48
Const TILE_HEIGHT: Int = 48
Const PLAYER_HEIGHT:Int = 32
Const PLAYER_WIDTH: Int = 32


Class Vec2D
	Field x:Float
	Field y:Float
	
	Method New(x:Float=0, y:Float=0)
		Set(x,y)
	End
	Method Set(x:Float, y:Float)
		Self.x = x
		Self.y = y
	End
	
End


Class Vec2DI
	Field x:Int
	Field y:Int
	
	Method New(x:Int=0, y:Int=0)
		Set(x,y)
	End
	Method Set(x:Int, y:Int)
		Self.x = x
		Self.y = y
	End
	
End

Class Player
	Field originalPos:Vec2D
	Field position:Vec2D
	Field velocity:Vec2D
	Field type:String
	Field typeArray:String[3] 'array of Player Characters
	
	Field topLeft:Vec2D = New Vec2D()
	Field topRight:Vec2D = New Vec2D()
	Field botLeft:Vec2D = New Vec2D()
	Field botRight:Vec2D = New Vec2D()
	
	
	Field speed:Float = 6.0 'speed of player
	
	Field leftKey:Int
	Field rightKey:Int
	Field upKey:Int
	Field shiftKey:Int
	Field currChar:Int
	Field alreadyDoubleJump:Bool
	
	Field jumps:Int
	
	Method New(leftKey:Int, rightKey:Int, upKey:Int, shiftKey:Int, x:Float, y:Float, type:String)
		originalPos = New Vec2D(x, y)
		position = New Vec2D(x, y)
		velocity = New Vec2D()
		
		Self.leftKey = leftKey
		Self.rightKey = rightKey
		Self.upKey = upKey
		Self.shiftKey = shiftKey
		Self.jumps = 2
		Self.type = type
		Self.alreadyDoubleJump = False
		
		typeArray[0] = "Ninja"
		typeArray[1] = "Knight"
		typeArray[2] = "Wizard"
		currChar = 0 'Default characrer is Ninja
		
	End
	
	'Reset character position
	Method Reset()
		SetPosition(originalPos.x, originalPos.y)
		velocity.Set(0,0)
		currChar =0
		type = typeArray[currChar]
	End
	
	Method Update(gravity:Float)
		velocity.x = 0
		velocity.y += gravity
		
		If KeyDown(leftKey)
			velocity.x = -speed
		End
		
		If KeyDown(rightKey)
			velocity.x = speed
		End
		
		If KeyHit(upKey)
			If jumps > 0
				velocity.y = -5.0
				jumps -= 1
			End
			If type = "Ninja"
				If jumps = 0
					alreadyDoubleJump = True
				End
			End
			
		End
		If KeyHit(shiftKey)
			If currChar = 2
				currChar = 0
			
			Else
				currChar += 1
			End
		type = typeArray[currChar]
		If type = "Ninja"
			If alreadyDoubleJump = False
				If jumps = 0
					jumps = 1
				End
			End
		End
		
		If type = "Knight"
			
			jumps = 0
			
		End
		
		If type = "Wizard"
			
			jumps = 0
			
		End
	
		End
		
		SetPosition(position.x +velocity.x, position.y + velocity.y)
		
	End
	
	#rem
	  Draw the characters
	  Currently a rectangle.
	#end
	Method Draw()
		If(type = "Ninja")
			SetColor(0,255, 0)
		Elseif(type = "Knight")
			SetColor(255,0, 0)
		Elseif(type = "Wizard")
			SetColor(0,0, 255)
		End
		
		DrawRect(position.x-16, position.y-16, 32, 32)
	End
	
	#rem
	 Resets the jump to default number
	#end
	Method ResetJumps()
	alreadyDoubleJump = False
		If(type = "Ninja")
			jumps = 2
		End
		If(type = "Knight")
			jumps = 1
		End
		If(type = "Wizard")
			jumps = 1
		End
	End
		
	 
	
	Method UpdateCornerPoints()
		topLeft.Set(position.x - PLAYER_WIDTH/2, position.y - PLAYER_HEIGHT/2)
		topRight.Set(position.x + PLAYER_WIDTH/2, position.y - PLAYER_HEIGHT/2)
		botLeft.Set(position.x - PLAYER_WIDTH/2, position.y + PLAYER_HEIGHT/2)
		botRight.Set(position.x + PLAYER_WIDTH/2 -1, position.y + PLAYER_HEIGHT/2)
	End
	
	Method SetPosition(x:Float, y:Float)
		position.Set(x,y)
		UpdateCornerPoints()
	End
	
	Method SetXPosition(x:Float)
		position.Set(x, position.y)
		UpdateCornerPoints()

	End
	
	Method SetYPosition(y:Float)
		position.Set(position.x, y)
		UpdateCornerPoints()

	End

	
End

Class Camera
	Field originalPos:Vec2D
	Field position:Vec2D
	
	Method New(x:Float=0, y:Float=0)
		position = New Vec2D(x,y)
		originalPos = New Vec2D(x,y)
	End
	
	Method Reset()
		position.Set(originalPos.x, originalPos.y)
	End
	
	Method Update(fallSpeed:Float)
		position.y -= fallSpeed
	End
	
	
End

Class Block
	Field position:Vec2D
	
	Method New(x:Float, y:Float)
		position = New Vec2D(x, y)
	End
	
	Method Draw()
		SetColor(123, 123, 123)
		DrawRect(position.x-(TILE_WIDTH/2), position.y-(TILE_HEIGHT/2), TILE_WIDTH, TILE_HEIGHT)
		SetColor(50, 50, 50)
		DrawRect(position.x-(TILE_WIDTH/2), position.y-(TILE_HEIGHT/2), TILE_WIDTH/2, TILE_HEIGHT/2)

	End
End

