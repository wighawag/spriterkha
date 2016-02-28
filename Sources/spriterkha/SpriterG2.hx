package spriterkha;

import kha.graphics2.Graphics;
import kha.math.FastMatrix3;
import spriter.EntityInstance;
import kha.Color;

import imagesheet.ImageSheet;

class SpriterG2 {
	
	public static function drawSpriter(g2 : Graphics, imageSheet : ImageSheet, entity : EntityInstance, x : Float, y : Float){
		var sprites = entity.sprites;
		var current = sprites.start;
		while (current < sprites.top){
			var folderId = sprites.folderId(current);
			var fileId = sprites.fileId(current);
			var filename = entity.getFilename(folderId, fileId);
			var subImage = imageSheet.getSubImage(filename);
			
			if(subImage == null){
				drawDebugSpriter(g2,entity, x,y);
				return;
			}
			
			var pivotX = sprites.pivotX(current);
			var pivotY = sprites.pivotY(current);
			var offsetX = subImage.offsetX;
			var offsetY = subImage.offsetY;
			
			var width = subImage.originalWidth;
			var height = subImage.originalHeight;
			var originX = pivotX * width - offsetX;
			var originY = (1.0 - pivotY) * height - offsetY;
			var locationX = sprites.x(current) + x ;
			var locationY = -sprites.y(current) + y;
			var scaleX = sprites.scaleX(current); 
			var scaleY = sprites.scaleY(current); 
			var angle = -sprites.angle(current);
			if(subImage.rotated){
				angle -= Math.PI/2;
				var tmp = originX;
				originX = pivotY * height - (height - subImage.height - offsetY);
				originY = pivotX * width - offsetX;
			}
			
			g2.transformation = FastMatrix3.rotation(angle).multmat(FastMatrix3.scale(scaleX,scaleY)).multmat(FastMatrix3.translation(-originX, -originY));
			g2.transformation = FastMatrix3.translation(locationX, locationY).multmat(g2.transformation);
			
			// if(subImage.rotated){
			// 	g2.color = Color.Red;
			// }else{
				g2.color = Color.White;
			// }
			
			
			var subWidth = subImage.width;
			var subHeight = subImage.height;
			if(subImage.rotated){
				subWidth = subHeight;
				subHeight = subImage.width;
			}
			
			g2.drawScaledSubImage(imageSheet.image, subImage.x, subImage.y, subWidth, subHeight,0,0,subWidth, subHeight);
			
			current+=entity.sprites.structSize;
		}
	}
	
	@:access(spriter) 
	public static function drawDebugSpriter(g2 : Graphics, entity : EntityInstance, ?x : Float = 0, ?y : Float = 0){
		
		var sprites = entity.sprites;
		var current = sprites.start;
		while (current < sprites.top){
			var file = entity.entity.spriter.folders[sprites.folderId(current)].files[sprites.fileId(current)];
			var width = file.width;
			var height = file.height;
			var originX = sprites.pivotX(current) * width;
			var originY = (1.0 - sprites.pivotY(current)) * height;
			var locationX = sprites.x(current) + x;
			var locationY = -sprites.y(current) + y;
			var scaleX = sprites.scaleX(current); //Math.abs(sprites.scaleX(current));
			var scaleY = sprites.scaleY(current); //Math.abs(sprites.scaleY(current));
			var angle = -sprites.angle(current);
			
			// if (info.ScaleX < 0)
			// {
			//	 effects |= SpriteEffects.FlipHorizontally;
			//	 origin = new Vector2(texture.Width - origin.X, origin.Y);
			// }

			// if (info.ScaleY < 0)
			// {
			//	 effects |= SpriteEffects.FlipVertically;
			//	 origin = new Vector2(origin.X, texture.Height - origin.Y);
			// }

			//spriteBatch.Draw(texture, location, null, color, angle, origin, scale, effects, 1);
			
			g2.transformation = FastMatrix3.rotation(angle).multmat(FastMatrix3.scale(scaleX,scaleY)).multmat(FastMatrix3.translation(-originX, -originY));
			g2.transformation = FastMatrix3.translation(locationX, locationY).multmat(g2.transformation);
			g2.color = Color.White;
			g2.drawRect(0, 0, width, height);
			
			// g2.transformation = FastMatrix3.identity();
			
			// var x = locationX;
			// var y = locationY;
			
			// var dx = - originX * scaleX;
			// var dy = - originY * scaleY;
			
			// var cos = Math.cos(angle);
			// var sin = Math.sin(angle);
			
			// var w = width * scaleX;
			// var h = height * scaleY;
			
			// var tlX = x + dx * cos - dy * sin;
			// var tlY = y + dx * sin + dy * cos;
			
			// var trX = x + (dx + w) * cos - dy * sin;
			// var trY = y + (dx + w) * sin + dy * cos;
			
			// var blX = x + dx * cos - (dy + h) * sin;
			// var blY = y + dx * sin + (dy + h) * cos;
			
			// var brX = x + (dx + w) * cos - (dy + h) * sin;
			// var brY = y + (dx + w) * sin + (dy + h) * cos;
			
			// g2.drawLine(tlX,tlY,trX,trY,2);
			// g2.drawLine(trX,trY,brX,brY,2);
			// g2.drawLine(brX,brY,blX,blY,2);
			// g2.drawLine(blX,blY,tlX,tlY,2);
			
			current+=entity.sprites.structSize;
		}
		
		// for (boxObjectId in 0...entity.boxObjectIds.numElements){
		// 	var spriteObject = entity.boxObjectIds.get(boxObjectId);
		// 	var file = entity.entity.spriter.folders[spriteObject.folderId].files[spriteObject.fileId];
		// 	var width = file.width;
		// 	var height = file.height;
		// 	var originX = spriteObject.pivotX * width;
		// 	var originY = (1.0 - spriteObject.pivotY) * height;
		// 	var locationX = spriteObject.x + x;
		// 	var locationY = -spriteObject.y + y;
		// 	var scaleX = spriteObject.scaleX; //Math.abs(spriteObject.scaleX);
		// 	var scaleY = spriteObject.scaleY; //Math.abs(spriteObject.scaleY);
		// 	var angle = -(Math.PI / 180.0) * spriteObject.angle;
			
			
		// 	g2.transformation = FastMatrix3.rotation(angle).multmat(FastMatrix3.scale(scaleX,scaleY)).multmat(FastMatrix3.translation(-originX, -originY));
		// 	g2.transformation = FastMatrix3.translation(locationX, locationY).multmat(g2.transformation);
		// 	g2.color = Color.Cyan;
		// 	g2.drawRect(0, 0, width, height);
		// }
		
		// for (pointName in entity.frameData.pointData.keys()){
		// 	var spriteObject = entity.frameData.pointData[pointName];
		// 	var file = entity.entity.spriter.folders[spriteObject.folderId].files[spriteObject.fileId];
		// 	var width = file.width;
		// 	var height = file.height;
		// 	var originX = spriteObject.pivotX * width;
		// 	var originY = (1.0 - spriteObject.pivotY) * height;
		// 	var locationX = spriteObject.x + x;
		// 	var locationY = -spriteObject.y + y;
		// 	var scaleX = spriteObject.scaleX; //Math.abs(spriteObject.scaleX);
		// 	var scaleY = spriteObject.scaleY; //Math.abs(spriteObject.scaleY);
		// 	var angle = -(Math.PI / 180.0) * spriteObject.angle;
			
			
		// 	g2.transformation = FastMatrix3.rotation(angle).multmat(FastMatrix3.scale(scaleX,scaleY)).multmat(FastMatrix3.translation(-originX, -originY));
		// 	g2.transformation = FastMatrix3.translation(locationX, locationY).multmat(g2.transformation);
		// 	g2.color = Color.Cyan;
		// 	g2.drawRect(0, 0, width, height);
		// }
	}
}
