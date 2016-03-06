package spriterkha;

import kha.graphics4.Graphics;
import kha.math.FastMatrix3;
import spriter.EntityInstance;
import kha.Color;
import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexStructure;
import imagesheet.ImageSheet;
import kha.arrays.Float32Array;

class SpriterG4 {
	
	// public static function writeSpriter(vertexData : Float32Array, structure : VertexStructure, vertexStart : Int, indexData : Array<Int>, indexStart : Int , vertexIndex : Int, imagesheet : ImageSheet, entity : EntityInstance, x : Float, y : Float) : Int{
	// 	var posStride = structure.
	// 	return drawSpriter(vertexData,vertexSize)
	// }
	
	// public static function writeSpriter(vertexData : Float32Array, vertexStart : Int, vertexSize : Int, posStride : Int, texStride : Int, indexData : Array<Int>, indexStart : Int, vertexIndex : Int,  imageSheet : ImageSheet, entity : EntityInstance, x : Float, y : Float) : Int{
	// 	return writeSpriterWithRotation(vertexData,vertexStart, vertexSize, posStride, texStride, -1, indexData, indexStart, vertexIndex, imageSheet, entity, x, y, 1, 1); //TODO 1 1 = scale
	// }
	
	public static function writeSpriterWithRotation(vertexData : Float32Array, vertexStart : Int, vertexSize : Int, posStride : Int, texStride : Int, rotStride : Int, indexData : Array<Int>, indexStart : Int, vertexIndex : Int,  imageSheet : ImageSheet, entity : EntityInstance, x : Float, y : Float, toScaleX : Float, toScaleY : Float, toAngle : Float) : Int{
		var sprites = entity.sprites;
		var current = sprites.start;
		var counter = 0;
		var indexCounter = 0;
		while (current < sprites.top){
			
			//get filename
			
			var folderId = sprites.folderId(current);
			var fileId = sprites.fileId(current);
			var filename = entity.getFilename(folderId, fileId);
			var subImage = imageSheet.getSubImage(filename);
			
			if(subImage == null){
				//drawDebugSpriter(g2,entity, x,y);
				trace("cannot find subImage for " + filename);
				current +=entity.sprites.structSize;
				continue;
			}
			
			
			//getting values from entity sprite + imageSheet
			
			var pivotX = sprites.pivotX(current);
			var pivotY = sprites.pivotY(current);
			var offsetX = subImage.offsetX;
			var offsetY = subImage.offsetY;
			
			var width = subImage.originalWidth;
			var height = subImage.originalHeight;
			var originX = pivotX * width - offsetX;
			var originY = (1.0 - pivotY) * height - offsetY;
			var locationX = sprites.x(current);
			var locationY = -sprites.y(current);
			var scaleX = sprites.scaleX(current); 
			var scaleY = sprites.scaleY(current); 
			var angle = -sprites.angle(current);
			if(subImage.rotated){
				angle -= Math.PI/2;
				var tmp = originX;
				originX = pivotY * height - (height - subImage.height - offsetY);
				originY = pivotX * width - offsetX;
			}
			
			var subWidth = subImage.width;
			var subHeight = subImage.height;
			if(subImage.rotated){
				subWidth = subHeight;
				subHeight = subImage.width;
			}
			
			
			//applying arguments
			locationX *= toScaleX;
			locationY *= toScaleY;
			var locX = locationX;
			locationX = Math.cos(toAngle) * locationX - Math.sin(toAngle) * locationY;
			locationY = Math.cos(toAngle) * locationY + Math.sin(toAngle) * locX;
			locationX += x;
			locationY += y;
			scaleX *= toScaleX;
			scaleY *= toScaleY;
			angle += toAngle;
			
			
			//computing each corner

			var x = locationX;
			var y = locationY;
			
			var dx = - originX * scaleX;
			var dy = - originY * scaleY;
			
			var cos = Math.cos(angle);
			var sin = Math.sin(angle);
			
			var w = subWidth * scaleX;
			var h = subHeight * scaleY;
			
			var tlX = x + dx * cos - dy * sin;
			var tlY = y + dx * sin + dy * cos;
			
			var trX = x + (dx + w) * cos - dy * sin;
			var trY = y + (dx + w) * sin + dy * cos;
			
			var blX = x + dx * cos - (dy + h) * sin;
			var blY = y + dx * sin + (dy + h) * cos;
			
			var brX = x + (dx + w) * cos - (dy + h) * sin;
			var brY = y + (dx + w) * sin + (dy + h) * cos;
			
			
			
			//writing vertex data
			
			vertexData.set(vertexStart+vertexSize*counter+posStride+0,tlX);
			vertexData.set(vertexStart+vertexSize*counter+posStride+1,tlY);
			vertexData.set(vertexStart+vertexSize*counter+texStride+0,subImage.x / imageSheet.image.width);
			vertexData.set(vertexStart+vertexSize*counter+texStride+1,subImage.y / imageSheet.image.height);
			if(rotStride > 0){
				vertexData.set(vertexStart+vertexSize*counter+rotStride,-angle);
			}
			
			
			vertexData.set(vertexStart+vertexSize*counter+posStride+vertexSize*1+0,trX);
			vertexData.set(vertexStart+vertexSize*counter+posStride+vertexSize*1+1,trY);
			vertexData.set(vertexStart+vertexSize*counter+texStride+vertexSize*1+0,(subImage.x + subWidth) / imageSheet.image.width);
			vertexData.set(vertexStart+vertexSize*counter+texStride+vertexSize*1+1,subImage.y / imageSheet.image.height);
			if(rotStride > 0){
				vertexData.set(vertexStart+vertexSize*counter+rotStride+vertexSize*1,-angle);
			}
			
			vertexData.set(vertexStart+vertexSize*counter+posStride+vertexSize*2+0,blX);
			vertexData.set(vertexStart+vertexSize*counter+posStride+vertexSize*2+1,blY);
			vertexData.set(vertexStart+vertexSize*counter+texStride+vertexSize*2+0,subImage.x / imageSheet.image.width );
			vertexData.set(vertexStart+vertexSize*counter+texStride+vertexSize*2+1,(subImage.y + subHeight) / imageSheet.image.height);
			if(rotStride > 0){
				vertexData.set(vertexStart+vertexSize*counter+rotStride+vertexSize*2,-angle);
			}
			
			vertexData.set(vertexStart+vertexSize*counter+posStride+vertexSize*3+0,brX);
			vertexData.set(vertexStart+vertexSize*counter+posStride+vertexSize*3+1,brY);
			vertexData.set(vertexStart+vertexSize*counter+texStride+vertexSize*3+0,(subImage.x + subWidth) / imageSheet.image.width );
			vertexData.set(vertexStart+vertexSize*counter+texStride+vertexSize*3+1,(subImage.y + subHeight) / imageSheet.image.height);
			if(rotStride > 0){
				vertexData.set(vertexStart+vertexSize*counter+rotStride+vertexSize*3,-angle);
			}
			
			counter +=4;
			
			
			//writing index data
			
			indexData[indexStart+indexCounter+0] = vertexIndex+0;
			indexData[indexStart+indexCounter+1] = vertexIndex+1;
			indexData[indexStart+indexCounter+2] = vertexIndex+2;
			indexData[indexStart+indexCounter+3] = vertexIndex+2;
			indexData[indexStart+indexCounter+4] = vertexIndex+1;
			indexData[indexStart+indexCounter+5] = vertexIndex+3;  
			indexCounter += 6;
			vertexIndex += 4;
			
			current +=entity.sprites.structSize;
			
			
		}
		return vertexIndex;
	}

}
