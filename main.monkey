Import game

Const STATE_MENU:Int = 0
Const STATE_GAME:Int = 1
Const STATE_DEATH:Int = 2

Class MainGame Extends App

	Field gameState:Int = STATE_MENU
	
	Field gravity: Float= 0.2
	
	Field player:Player = New Player(KEY_LEFT, KEY_RIGHT, KEY_UP, KEY_SHIFT, 320, 50, "Ninja")
	
	Field cam:Camera = New Camera()
	
	Field mapWidth:Int
	Field mapOffset:Float
	
	Field collisionMap:IntMap<Int[]> = New IntMap<Int[]>
	
	Field blocks:List<Block> = New List<Block>
	
	Method OnCreate()
		SetUpdateRate(60)
		
		mapWidth = SCREEN_WIDTH / TILE_WIDTH
		mapOffset = (SCREEN_WIDTH Mod TILE_WIDTH)/2
		
		GenerateFloor(8)
	End
	
	Method OnUpdate()
		Select gameState
			Case STATE_MENU
				If KeyHit(KEY_ENTER)
					gameState = STATE_GAME
				End
			Case STATE_GAME
				If KeyHit(KEY_R)
					player.Reset()
					cam.Reset()
				End
			
				UpdatePlayer()
				cam.Update(0.0)
			
			Case STATE_DEATH
		
		End
	End
	
	Method OnRender()
		Cls(0,0,0)
		
		Select gameState
			Case STATE_MENU
				DrawText("3-Person Platforer", 320, 100, 0.5)
				DrawText("Press Enter to Play", 320, 400, 0.5) 
			Case STATE_GAME
				PushMatrix()
				
				Translate(cam.position.x, cam.position.y)
				For Local block:Block = Eachin blocks
					block.Draw()
				End
				
				player.Draw()
				
				PopMatrix()
			Case STATE_DEATH
			
		End
	End
	
	Method GenerateFloor(row:Int)
		Local IndexStack:IntStack = New IntStack()
		For Local i:=0 Until mapWidth 
			IndexStack.Push(i)
		End
		
		
		Local remIndex:Int = 5
		
		IndexStack.Remove(remIndex)
		IndexStack.Remove(remIndex)

		
		
		Local collArray:Int[mapWidth]
		
		For Local x:= Eachin IndexStack 
			collArray[x] = 1
			blocks.AddLast(New Block(mapOffset + TILE_WIDTH/2 + x * TILE_WIDTH, row*TILE_HEIGHT + TILE_HEIGHT/2))
		End
		collisionMap.Set(row, collArray)
		
	End
	
	Method GetTileFromPoint:Vec2DI(x:Float, y:Float)
		Local tileX:Int = (x - mapOffset) / TILE_WIDTH
		Local tileY:Int = y/TILE_HEIGHT
		
		Return New Vec2DI(tileX, tileY)
	End
	
	Method GetTileCollision:Vec2D(playerPos:Vec2D, tile:Vec2DI)
		Local arr:Int[] = collisionMap.Get(tile.y)
		
		If arr.Length > 0


			If arr[tile.x] = 1
				Local xDist:Float = Abs(playerPos.x - (mapOffset + TILE_WIDTH / 2 + tile.x * TILE_WIDTH))
				Local yDist:Float = Abs(playerPos.y - (tile.y * TILE_HEIGHT + TILE_HEIGHT/2))
				Return New Vec2D(xDist, yDist)
			End
		End
		
		Return Null
	End
	Method UpdatePlayer()
		player.Update(gravity)
		
		If player.topLeft.x < mapOffset
			player.SetXPosition(mapOffset + PLAYER_WIDTH/2)
		Elseif player.topRight.x >= mapOffset +( mapWidth * TILE_WIDTH)
			player.SetXPosition(mapOffset +(mapWidth * TILE_WIDTH) - PLAYER_WIDTH/2)
		
		End
		
		Local topLeftTile:Vec2DI = GetTileFromPoint(player.topLeft.x, player.topLeft.y)
		Local topRightTile:Vec2DI = GetTileFromPoint(player.topRight.x, player.topRight.y)
		Local botLeftTile:Vec2DI = GetTileFromPoint(player.botLeft.x, player.botLeft.y)
		Local botRightTile:Vec2DI = GetTileFromPoint(player.botRight.x, player.botRight.y)
		
		Local topLeftColl:Vec2D = GetTileCollision(player.position, topLeftTile)
		Local topRightColl:Vec2D = GetTileCollision(player.position,topRightTile)
		Local botLeftColl:Vec2D = GetTileCollision(player.position, botLeftTile)
		Local botRightColl:Vec2D = GetTileCollision(player.position, botRightTile)
		
		If botLeftColl <> Null
			If botLeftColl.x > botLeftColl.y
				player.SetXPosition(mapOffset + botLeftTile.x * TILE_WIDTH + TILE_WIDTH + PLAYER_WIDTH /2)
			Else
				If player.velocity.y > 0.0
					player.velocity.y = 0.0
				End
				player.SetYPosition(botLeftTile.y * TILE_HEIGHT - PLAYER_HEIGHT / 2)
				player.ResetJumps()
			End
		End
		If botRightColl <> Null
			If botRightColl.x > botRightColl.y
				player.SetXPosition(mapOffset + botRightTile.x * TILE_WIDTH  - PLAYER_WIDTH /2)
				player.ResetJumps()
			Else
				If player.velocity.y > 0.0
					player.velocity.y = 0.0
				End
				player.SetYPosition(botRightTile.y * TILE_HEIGHT - PLAYER_HEIGHT / 2)
			End
		End
		If topLeftColl <> Null
			If topLeftColl.x > topLeftColl.y
				player.SetXPosition(mapOffset + topLeftTile.x * TILE_WIDTH + TILE_WIDTH + PLAYER_WIDTH /2)
			Else
				If player.velocity.y < 0.0
					player.velocity.y = 0.0
				End
				player.SetYPosition(botLeftTile.y * TILE_HEIGHT + PLAYER_HEIGHT / 2)
				
			End
		End
		If topRightColl <> Null
			If topRightColl.x > topRightColl.y
				player.SetXPosition(mapOffset + topRightTile.x * TILE_WIDTH - PLAYER_WIDTH /2)
			Else
				If player.velocity.y < 0.0
					player.velocity.y = 0.0
				End
				player.SetYPosition(botRightTile.y * TILE_HEIGHT + PLAYER_HEIGHT / 2)
			End
		End
	End
	
End



Function Main()
	New MainGame()
End


				
