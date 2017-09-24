using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Media;
using System.Windows.Media.Imaging;

namespace GrayscaleConverter
{
    public class ByteArrayComparer : IEqualityComparer<byte[]>
    {
        public bool Equals(byte[] left, byte[] right)
        {
            if (left == null || right == null)
            {
                return left == right;
            }
            if (left.Length != right.Length)
            {
                return false;
            }

            for (int i = 0; i < left.Length; i++)
            {
                if (left[i] != right[i])
                {
                    return false;
                }
            }
            return true;
        }

        public int GetHashCode(byte[] key)
        {
            if (key == null)
                throw new ArgumentNullException("key");

            int sum = 0;
            foreach (byte cur in key)
            {
                sum += cur;
            }
            return sum;
        }
    }

    class Program
    {
        static private byte[] BitmapSourceToArray(BitmapSource bitmapSource)
        {
            int stride = (int)bitmapSource.PixelWidth * (bitmapSource.Format.BitsPerPixel / 8);
            byte[] pixels = new byte[(int)bitmapSource.PixelHeight * stride];
            bitmapSource.CopyPixels(pixels, stride, 0);
            return pixels;
        }

        static private BitmapSource BitmapSourceFromArray(byte[] pixels, int width, int height)
        {
            WriteableBitmap bitmap = new WriteableBitmap(width, height, 96, 96, PixelFormats.Bgra32, null);
            bitmap.WritePixels(new Int32Rect(0, 0, width, height), pixels, width * (bitmap.Format.BitsPerPixel / 8), 0);
            return bitmap;
        }

        static private BitmapFrame LoadTiff(string src)
        {
            var grayscale = new FileStream(src, FileMode.Open, FileAccess.Read, FileShare.Read);
            var decoder = new TiffBitmapDecoder(grayscale, BitmapCreateOptions.PreservePixelFormat, BitmapCacheOption.Default);
            var source = decoder.Frames[0];
            return source;
        }
        
        static void Main(string[] args)
        {
            var grayscaleSource = LoadTiff("../../grayscale.tiff");
            byte[] grayscalePixels = BitmapSourceToArray(grayscaleSource);

            var colorSource = LoadTiff("../../colormap.tiff");
            byte[] colorPixels = BitmapSourceToArray(colorSource);

            Dictionary<byte[], byte[]> swap = new Dictionary<byte[], byte[]>(new ByteArrayComparer());
            for(int i=0; i<224*4; i+=4)
            {
                var srcPixel = new byte[] {
                    colorPixels[i],
                    colorPixels[i+1],
                    colorPixels[i+2],
                    colorPixels[i+3]
                };

                var dstPixel = new byte[] {
                    grayscalePixels[i],
                    grayscalePixels[i+1],
                    grayscalePixels[i+2],
                    grayscalePixels[i+3]
                };
                
                if(!swap.ContainsKey(srcPixel))
                    swap.Add(srcPixel, dstPixel);
            }

            var convertImage = LoadTiff("../../colored.tiff");
            var convertPixels = BitmapSourceToArray(convertImage);            
            var dstImage = new byte[convertImage.PixelWidth * convertImage.PixelHeight * 4];
            for (int i = 0; i < convertImage.PixelWidth * convertImage.PixelHeight * 4; i += 4)
            {
                var srcPixel = new byte[] {
                    convertPixels[i],
                    convertPixels[i+1],
                    convertPixels[i+2],
                    convertPixels[i+3]
                };

                if (!swap.ContainsKey(srcPixel))
                    return;

                var swapPixel = swap[srcPixel];
                dstImage[i] = swapPixel[0];
                dstImage[i+1] = swapPixel[1];
                dstImage[i+2] = swapPixel[2];
                dstImage[i+3] = swapPixel[3];
            }
            var saveBitmap = BitmapSourceFromArray(dstImage, convertImage.PixelWidth, convertImage.PixelHeight);
            using (var fileStream = new FileStream("../../converted.png", FileMode.Create))
            {
                BitmapEncoder encoder = new PngBitmapEncoder();
                encoder.Frames.Add(BitmapFrame.Create(saveBitmap));
                encoder.Save(fileStream);
            }
        }
    }
}
