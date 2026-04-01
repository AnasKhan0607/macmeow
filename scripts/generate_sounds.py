#!/usr/bin/env python3
"""
Sound Asset Generator for Sentient
===================================
Uses Fish.audio TTS to generate personality voice lines.

Usage:
  python generate_sounds.py --all
  python generate_sounds.py --personality dramatic
  python generate_sounds.py --list

Requirements:
  pip install requests

Set FISH_API_KEY environment variable or edit the script.
"""

import os
import sys
import json
import time
import argparse
import requests
from pathlib import Path

# Fish.audio API
FISH_API_KEY = os.environ.get("FISH_API_KEY", "40288fd705db4ac08078d3d908687ba9")
FISH_API_URL = "https://api.fish.audio/v1/tts"

# Voice options (Fish.audio reference IDs) - using known working voices
VOICES = {
    "dramatic": "e91c4f5974f149478a35affe820d02ac",  # Stewie - expressive/dramatic
    "hungry": "54e3a85ac9594ffa83264b8a494b901b",    # SpongeBob - whiny/cute
    "judgmental": "76bb6ae7b26c41fbbd484514fdb014c2",  # Morgan Freeman - disappointed
    "needy": "e91c4f5974f149478a35affe820d02ac",     # Stewie - dramatic/pleading
}

# Sound lines to generate
SOUND_LINES = {
    "dramatic": {
        "scream_1": "AAAAHHH!",
        "scream_2": "AHHHHHHH!",
        "gasp_1": "*gasp*",
        "gasp_2": "*loud gasp* Oh no!",
        "why_would_you": "Why would you do this to me?!",
        "careful": "Careful! Careful!",
        "whoa": "Whoa whoa whoa!",
        "hey": "Hey! Watch it!",
        "ouch": "Ouch! That hurt!",
        "ow": "Ow!",
        "stop_it": "Stop it! Please!",
        "im_gonna_be_sick": "I'm gonna be sick...",
        "why": "Why?! WHY?!",
        "phew": "Phew... okay...",
        "okay": "Okay... okay... we're fine...",
        "thats_better": "That's better. Please don't do that again.",
        "what_was_that": "What was that?!",
    },
    "hungry": {
        "stomach_growl_soft": "*quiet rumbling* Hmm, I could eat...",
        "stomach_growl": "*stomach growling* Getting hungry here...",
        "stomach_growl_loud": "*LOUD GROWLING* SO HUNGRY!",
        "little_hungry": "I'm feeling a little hungry...",
        "getting_hungry": "Getting hungry over here!",
        "could_use_snack": "I could really use a snack right about now.",
        "hmm_hungry": "Hmm... when's dinner?",
        "hungry": "I'm hungry...",
        "feed_me": "Feed me! Please!",
        "so_hungry": "So... hungry...",
        "starving": "I'm STARVING! Please plug me in!",
        "please_feed_me": "Please... feed me...",
        "dying": "I'm... dying... need... power...",
        "help_me": "Help me... so weak...",
        "so_weak": "Can't... hold on... much longer...",
        "goodbye_world": "Goodbye... world...",
        "finally_food": "Finally! FOOD!",
        "yes_feed_me": "Yes! Yes! Feed me!",
        "thank_you": "Thank you! Thank you so much!",
        "ahh_satisfied": "Ahhh... that hits the spot.",
        "yummy": "Mmmm, yummy electricity!",
        "thats_the_stuff": "That's the stuff!",
        "too_full": "Okay okay, I'm full! Stop!",
        "cant_eat_more": "I can't eat anymore!",
        "stuffed": "Ugh... so stuffed...",
    },
    "judgmental": {
        "sigh_1": "*deep disappointed sigh*",
        "sigh_2": "*sigh* Really?",
        "sigh_3": "*long exhale* Here we go again...",
        "really": "Really? This app? Again?",
        "again": "Again? You were just on this.",
        "disappointed": "I'm not mad, I'm just disappointed.",
        "tsk_tsk": "Tsk tsk tsk...",
        "i_expected_better": "I expected better from you.",
        "here_we_go": "Aaand here we go again.",
        "productive": "Very productive use of your time.",
        "sure_why_not": "Sure. Why not. It's not like you have things to do.",
    },
    "needy": {
        "dont_leave": "Don't leave me! Please!",
        "miss_you": "I miss you already...",
        "where_are_you": "Where are you? Hello?",
        "so_lonely": "It's so lonely here...",
        "come_back": "Come back! Please come back!",
        "sad_whimper": "*sad whimper*",
        "youre_back": "You're back! I'm so happy!",
        "hello": "Hello! I missed you!",
        "finally": "Finally! You're here!",
        "i_was_worried": "I was so worried! Don't leave me again!",
        "yay": "Yay! You're back!",
    },
}


def generate_sound(text: str, output_path: Path, voice_id: str) -> bool:
    """Generate a single sound file using Fish.audio TTS."""
    
    headers = {
        "Authorization": f"Bearer {FISH_API_KEY}",
        "Content-Type": "application/json",
    }
    
    payload = {
        "text": text,
        "reference_id": voice_id,
        "format": "mp3",
    }
    
    try:
        response = requests.post(FISH_API_URL, headers=headers, json=payload)
        response.raise_for_status()
        
        output_path.parent.mkdir(parents=True, exist_ok=True)
        output_path.write_bytes(response.content)
        print(f"✅ Generated: {output_path.name}")
        return True
        
    except requests.exceptions.RequestException as e:
        print(f"❌ Failed: {output_path.name} - {e}")
        return False


def generate_personality(personality: str, output_dir: Path):
    """Generate all sounds for a personality."""
    
    if personality not in SOUND_LINES:
        print(f"❌ Unknown personality: {personality}")
        return
    
    voice_id = VOICES.get(personality, VOICES["dramatic"])
    lines = SOUND_LINES[personality]
    
    print(f"\n🎭 Generating {personality} sounds ({len(lines)} files)...")
    
    success = 0
    for name, text in lines.items():
        output_path = output_dir / personality / f"{name}.mp3"
        if generate_sound(text, output_path, voice_id):
            success += 1
        time.sleep(0.5)  # Rate limiting
    
    print(f"✅ Generated {success}/{len(lines)} sounds for {personality}")


def list_sounds():
    """List all sounds that would be generated."""
    total = 0
    for personality, lines in SOUND_LINES.items():
        print(f"\n{personality.upper()} ({len(lines)} sounds):")
        for name, text in lines.items():
            print(f"  - {name}: \"{text}\"")
            total += 1
    print(f"\nTotal: {total} sound files")


def main():
    parser = argparse.ArgumentParser(description="Generate sound assets for Sentient")
    parser.add_argument("--all", action="store_true", help="Generate all sounds")
    parser.add_argument("--personality", type=str, help="Generate sounds for specific personality")
    parser.add_argument("--list", action="store_true", help="List all sounds")
    parser.add_argument("--output", type=str, default="Sentient/Resources/Sounds", help="Output directory")
    args = parser.parse_args()
    
    if args.list:
        list_sounds()
        return
    
    output_dir = Path(args.output)
    
    if args.all:
        for personality in SOUND_LINES.keys():
            generate_personality(personality, output_dir)
    elif args.personality:
        generate_personality(args.personality, output_dir)
    else:
        parser.print_help()


if __name__ == "__main__":
    main()
