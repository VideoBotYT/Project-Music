package components;

import openfl.geom.Rectangle;
import lime.media.AudioBuffer;
import haxe.io.Bytes;
import haxe.ui.backend.flixel.components.SpriteWrapper;
import flixel.FlxG;
import flixel.sound.FlxSound;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

import flixel.FlxSprite;

class Waveform extends SpriteWrapper{
    var data:Array<Array<Array<Float>>>;
    var wavesprite:FlxSprite;
    var sound:FlxSound;

    public function new(sound:FlxSound){
        super();

        this.sound = sound;
        wavesprite = new FlxSprite(0, 0).makeGraphic(1, 1, 0x00FFFFFF);
        this.sprite = wavesprite;
    }

	function waveformData(buffer:AudioBuffer, bytes:Bytes, time:Float, endTime:Float, multiply:Float = 1, ?array:Array<Array<Array<Float>>>,
			?steps:Float):Array<Array<Array<Float>>> {
		if (buffer == null || buffer.data == null)
			return [[[0], [0]], [[0], [0]]];

		var khz:Float = (buffer.sampleRate / 1000);
		var channels:Int = buffer.channels;

		var index:Int = Std.int(time * khz);

		var samples:Float = ((endTime - time) * khz);

		if (steps == null)
			steps = 1280;

		var samplesPerRow:Float = samples / steps;
		var samplesPerRowI:Int = Std.int(samplesPerRow);

		var gotIndex:Int = 0;

		var lmin:Float = 0;
		var lmax:Float = 0;

		var rmin:Float = 0;
		var rmax:Float = 0;

		var rows:Float = 0;

		var simpleSample:Bool = true; // samples > 17200;
		var v1:Bool = false;

		if (array == null)
			array = [[[0], [0]], [[0], [0]]];

		while (index < (bytes.length - 1)) {
			if (index >= 0) {
				var byte:Int = bytes.getUInt16(index * channels * 2);

				if (byte > 65535 / 2)
					byte -= 65535;

				var sample:Float = (byte / 65535);

				if (sample > 0)
					if (sample > lmax)
						lmax = sample;
					else if (sample < 0)
						if (sample < lmin)
							lmin = sample;

				if (channels >= 2) {
					byte = bytes.getUInt16((index * channels * 2) + 2);

					if (byte > 65535 / 2)
						byte -= 65535;

					sample = (byte / 65535);

					if (sample > 0) {
						if (sample > rmax)
							rmax = sample;
					} else if (sample < 0) {
						if (sample < rmin)
							rmin = sample;
					}
				}
			}

			v1 = samplesPerRowI > 0 ? (index % samplesPerRowI == 0) : false;
			while (simpleSample ? v1 : rows >= samplesPerRow) {
				v1 = false;
				rows -= samplesPerRow;

				gotIndex++;

				var lRMin:Float = Math.abs(lmin) * multiply;
				var lRMax:Float = lmax * multiply;

				var rRMin:Float = Math.abs(rmin) * multiply;
				var rRMax:Float = rmax * multiply;

				if (gotIndex > array[0][0].length)
					array[0][0].push(lRMin);
				else
					array[0][0][gotIndex - 1] = array[0][0][gotIndex - 1] + lRMin;

				if (gotIndex > array[0][1].length)
					array[0][1].push(lRMax);
				else
					array[0][1][gotIndex - 1] = array[0][1][gotIndex - 1] + lRMax;

				if (channels >= 2) {
					if (gotIndex > array[1][0].length)
						array[1][0].push(rRMin);
					else
						array[1][0][gotIndex - 1] = array[1][0][gotIndex - 1] + rRMin;

					if (gotIndex > array[1][1].length)
						array[1][1].push(rRMax);
					else
						array[1][1][gotIndex - 1] = array[1][1][gotIndex - 1] + rRMax;
				} else {
					if (gotIndex > array[1][0].length)
						array[1][0].push(lRMin);
					else
						array[1][0][gotIndex - 1] = array[1][0][gotIndex - 1] + lRMin;

					if (gotIndex > array[1][1].length)
						array[1][1].push(lRMax);
					else
						array[1][1][gotIndex - 1] = array[1][1][gotIndex - 1] + lRMax;
				}

				lmin = 0;
				lmax = 0;

				rmin = 0;
				rmax = 0;
			}

			index++;
			rows++;
			if (gotIndex > steps)
				break;
		}

		return array;
	}

    function updateWaveform(){
        var width:Int = FlxG.width;
        var height:Int = FlxG.height;

        if (Std.int(wavesprite.height) != height && wavesprite.pixels != null){
            wavesprite.pixels.dispose();
            wavesprite.pixels.disposeImage();
            wavesprite.makeGraphic(width, height, 0x00FFFFFF);
        }
        wavesprite.pixels.fillRect(new Rectangle(0, 0, width, height), 0x00FFFFFF);

        data[0][0].resize(0);
        data[0][1].resize(0);
        data[1][0].resize(0);
        data[1][1].resize(0);

        @:privateAccess
        if (sound != null && sound._sound != null && sound._sound.__buffer != null){
            var bytes:Bytes = sound._sound.__buffer.data.toBytes();
            data = waveformData(sound._sound.__buffer, bytes, 0, sound.length, 1, data, 1);

            var size:Float = 1;

            var leftLength:Int = (data[0][0].length > data[0][1].length ? data[0][0].length : data[0][1].length);
            var rightLength:Int = (data[1][0].length > data[1][1].length ? data[1][0].length : data[1][1].length);

            var length:Int = leftLength > rightLength ? leftLength : rightLength;

            for (i in 0...length){
				var lmin:Float = FlxMath.bound(((i < data[0][0].length && i >= 0) ? data[0][0][i] : 0), 0, FlxG.height) / 2;
				var lmax:Float = FlxMath.bound(((i < data[0][1].length && i >= 0) ? data[0][1][i] : 0), 0, FlxG.height) / 2;

				var rmin:Float = FlxMath.bound(((i < data[1][0].length && i >= 0) ? data[1][0][i] : 0), 0, FlxG.height) / 2;
				var rmax:Float = FlxMath.bound(((i < data[1][1].length && i >= 0) ? data[1][1][i] : 0), 0, FlxG.height) / 2;

				wavesprite.pixels.fillRect(new Rectangle(FlxG.height - (lmin + rmin), i * size, (lmin+rmin) + (lmax+rmax), size), FlxColor.WHITE);
            }
        }
    }
}