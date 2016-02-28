package spriterkha;

import kha.graphics4.Graphics;
import kha.math.FastMatrix3;
import spriter.EntityInstance;
import kha.Color;
import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;

import imagesheet.ImageSheet;
import kha.arrays.Float32Array;

class SpriterG4 {
	
	public static function drawSpriter(vertexData : Float32Array, vertexStart : Int, vertexSize : Int, posStride : Int, texStride : Int, indexData : Array<Int>, indexStart : Int, lastVertex : Int,  imageSheet : ImageSheet, entity : EntityInstance, x : Float, y : Float){
		var sprites = entity.sprites;
		var current = sprites.start;
		var counter = 0;
		var indexCounter = 0;
		while (current < sprites.top){
			var folderId = sprites.folderId(current);
			var fileId = sprites.fileId(current);
			var filename = entity.getFilename(folderId, fileId);
			var subImage = imageSheet.getSubImage(filename);
			
			if(subImage == null){
				//drawDebugSpriter(g2,entity, x,y);
				trace("cannot find subImage for " + filename);
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
			
			var subWidth = subImage.width;
			var subHeight = subImage.height;
			if(subImage.rotated){
				subWidth = subHeight;
				subHeight = subImage.width;
			}
			

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
			
			
			vertexData.set(vertexStart+vertexSize*counter+posStride+0,tlX);
			vertexData.set(vertexStart+vertexSize*counter+posStride+1,tlY);
			vertexData.set(vertexStart+vertexSize*counter+texStride+0,subImage.x / imageSheet.image.width);
			vertexData.set(vertexStart+vertexSize*counter+texStride+1,subImage.y / imageSheet.image.height);
			
			vertexData.set(vertexStart+vertexSize*counter+posStride+vertexSize*1+0,trX);
			vertexData.set(vertexStart+vertexSize*counter+posStride+vertexSize*1+1,trY);
			vertexData.set(vertexStart+vertexSize*counter+texStride+vertexSize*1+0,(subImage.x + subWidth) / imageSheet.image.width);
			vertexData.set(vertexStart+vertexSize*counter+texStride+vertexSize*1+1,subImage.y / imageSheet.image.height);
			
			vertexData.set(vertexStart+vertexSize*counter+posStride+vertexSize*2+0,blX);
			vertexData.set(vertexStart+vertexSize*counter+posStride+vertexSize*2+1,blY);
			vertexData.set(vertexStart+vertexSize*counter+texStride+vertexSize*2+0,subImage.x / imageSheet.image.width );
			vertexData.set(vertexStart+vertexSize*counter+texStride+vertexSize*2+1,(subImage.y + subHeight) / imageSheet.image.height);
			
			vertexData.set(vertexStart+vertexSize*counter+posStride+vertexSize*3+0,brX);
			vertexData.set(vertexStart+vertexSize*counter+posStride+vertexSize*3+1,brY);
			vertexData.set(vertexStart+vertexSize*counter+texStride+vertexSize*3+0,(subImage.x + subWidth) / imageSheet.image.width );
			vertexData.set(vertexStart+vertexSize*counter+texStride+vertexSize*3+1,(subImage.y + subHeight) / imageSheet.image.height);
			counter +=4;
			
			indexData[indexStart+indexCounter+0] = lastVertex+1;
			indexData[indexStart+indexCounter+1] = lastVertex+2;
			indexData[indexStart+indexCounter+2] = lastVertex+3;
			indexData[indexStart+indexCounter+3] = lastVertex+3;
			indexData[indexStart+indexCounter+4] = lastVertex+2;
			indexData[indexStart+indexCounter+5] = lastVertex+4;  
			indexCounter += 6;
			lastVertex += 4;
			
			current +=entity.sprites.structSize;
			
			
		}
	}

}
