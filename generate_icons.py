#!/usr/bin/env python3
"""
iOS App Icon Generator
Generates all required icon sizes from a 1024x1024 source image
"""

from PIL import Image
import os

# iOS App Icon sizes required
ICON_SIZES = {
    # iPhone
    "20x20@2x": 40,      # 40x40px
    "20x20@3x": 60,      # 60x60px
    "29x29@2x": 58,      # 58x58px
    "29x29@3x": 87,      # 87x87px
    "40x40@2x": 80,      # 80x80px
    "40x40@3x": 120,     # 120x120px
    "60x60@2x": 120,     # 120x120px
    "60x60@3x": 180,     # 180x180px
    
    # iPad (if supporting iPad)
    "20x20@1x": 20,      # 20x20px
    "29x29@1x": 29,      # 29x29px
    "40x40@1x": 40,      # 40x40px
    "76x76@1x": 76,      # 76x76px
    "76x76@2x": 152,     # 152x152px
    "83.5x83.5@2x": 167, # 167x167px
    
    # App Store
    "1024x1024@1x": 1024, # 1024x1024px
}

def generate_icons():
    """Generate all iOS app icon sizes"""
    
    # Source image path
    source_path = "Note Now/Assets.xcassets/AppIcon.appiconset/App Icon.png"
    
    # Check if source image exists
    if not os.path.exists(source_path):
        print(f"❌ Source image not found: {source_path}")
        return False
    
    try:
        # Open source image
        with Image.open(source_path) as source_img:
            print(f"✅ Source image loaded: {source_img.size[0]}x{source_img.size[1]}")
            
            # Create output directory if it doesn't exist
            output_dir = "Note Now/Assets.xcassets/AppIcon.appiconset"
            os.makedirs(output_dir, exist_ok=True)
            
            # Generate each icon size
            for name, size in ICON_SIZES.items():
                # Resize image with high quality
                resized = source_img.resize((size, size), Image.Resampling.LANCZOS)
                
                # Create filename
                filename = f"{name}.png"
                filepath = os.path.join(output_dir, filename)
                
                # Save icon
                resized.save(filepath, "PNG", optimize=True)
                print(f"✅ Generated: {filename} ({size}x{size})")
            
            print(f"\n🎉 Successfully generated {len(ICON_SIZES)} icon variations!")
            return True
            
    except Exception as e:
        print(f"❌ Error generating icons: {e}")
        return False

if __name__ == "__main__":
    print("🚀 iOS App Icon Generator")
    print("=" * 40)
    generate_icons()
