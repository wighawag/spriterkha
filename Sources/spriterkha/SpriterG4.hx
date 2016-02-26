package spriterkha;

import kha.graphics4.Graphics;
import kha.math.FastMatrix3;
import spriter.EntityInstance;
import kha.Color;
import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;

import imagesheet.ImageSheet;

class SpriterG4 {
	
	public static function drawSpriter(vertexBuffer : VertexBuffer, vertexStart : Int, vertexSize : Int, posStride : Int, texStride : Int, indexBuffer : IndexBuffer, indexStart : Int,  imageSheet : ImageSheet, entity : EntityInstance, x : Float, y : Float){
		var sprites = entity.sprites;
		var current = sprites.start;
		var counter = 0;
		var indexCounter = 0;
		var vData = vertexBuffer.lock();
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
			
			// g2.drawScaledSubImage(imageSheet.image, subImage.x, subImage.y, subWidth, subHeight,0,0,subWidth, subHeight);
			
			var x = locationX;
			var y = locationY;
			
			var dx = - originX * scaleX;
			var dy = - originY * scaleY;
			
			var cos = Math.cos(angle);
			var sin = Math.sin(angle);
			
			var w = width * scaleX;
			var h = height * scaleY;
			
			var tlX = x + dx * cos - dy * sin;
			var tlY = y + dx * sin + dy * cos;
			
			var trX = x + (dx + w) * cos - dy * sin;
			var trY = y + (dx + w) * sin + dy * cos;
			
			var blX = x + dx * cos - (dy + h) * sin;
			var blY = y + dx * sin + (dy + h) * cos;
			
			var brX = x + (dx + w) * cos - (dy + h) * sin;
			var brY = y + (dx + w) * sin + (dy + h) * cos;
			
			
			vData.set(vertexStart+vertexSize*counter+posStride+0,tlX);
			vData.set(vertexStart+vertexSize*counter+posStride+1,tlY);
			vData.set(vertexStart+vertexSize*counter+texStride+0,subImage.x);
			vData.set(vertexStart+vertexSize*counter+texStride+1,subImage.y);
			
			vData.set(vertexStart+vertexSize*counter+posStride+2,trX);
			vData.set(vertexStart+vertexSize*counter+posStride+3,trY);
			vData.set(vertexStart+vertexSize*counter+texStride+2,subImage.x + subWidth);
			vData.set(vertexStart+vertexSize*counter+texStride+3,subImage.y);
			
			
			//TODO more
			
			//TODO indexBuffer.set(indexStart+0,);
			
			current +=entity.sprites.structSize;
			counter +=4;
			indexCounter += 6;
		}
		vertexBuffer.unlock();
	}

}
