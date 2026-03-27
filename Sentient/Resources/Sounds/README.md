# Sound Assets

This directory contains audio files for each personality.

## Structure

```
Sounds/
├── dramatic/     # Screams, gasps, panic sounds
├── hungry/       # Stomach growls, feeding sounds
├── judgmental/   # Sighs, disappointed sounds
└── needy/        # Sad, happy, pleading sounds
```

## Generating Sounds

Use the generation script:

```bash
# Install dependencies (in a venv)
pip install requests

# Set your Fish.audio API key
export FISH_API_KEY="your_api_key"

# Generate all sounds
python scripts/generate_sounds.py --all

# Generate for one personality
python scripts/generate_sounds.py --personality dramatic

# List all sounds that will be generated
python scripts/generate_sounds.py --list
```

## Manual Recording

You can also record sounds manually. Each file should be:
- Format: MP3 or M4A
- Sample rate: 44100 Hz
- Duration: 0.5 - 3 seconds
- Named exactly as expected by the personality code

## Required Files

### Dramatic
- scream_1.mp3, scream_2.mp3
- gasp_1.mp3, gasp_2.mp3
- why_would_you.mp3, careful.mp3, whoa.mp3, hey.mp3
- ouch.mp3, ow.mp3
- stop_it.mp3, im_gonna_be_sick.mp3, why.mp3
- phew.mp3, okay.mp3, thats_better.mp3, what_was_that.mp3

### Hungry
- stomach_growl_soft.mp3, stomach_growl.mp3, stomach_growl_loud.mp3
- little_hungry.mp3, getting_hungry.mp3, could_use_snack.mp3, hmm_hungry.mp3
- hungry.mp3, feed_me.mp3, so_hungry.mp3, starving.mp3, please_feed_me.mp3
- dying.mp3, help_me.mp3, so_weak.mp3, goodbye_world.mp3
- finally_food.mp3, yes_feed_me.mp3, thank_you.mp3
- ahh_satisfied.mp3, yummy.mp3, thats_the_stuff.mp3
- too_full.mp3, cant_eat_more.mp3, stuffed.mp3

### Judgmental
- sigh_1.mp3, sigh_2.mp3, sigh_3.mp3
- really.mp3, again.mp3, disappointed.mp3, tsk_tsk.mp3
- i_expected_better.mp3, here_we_go.mp3, productive.mp3, sure_why_not.mp3

### Needy
- dont_leave.mp3, miss_you.mp3, where_are_you.mp3, so_lonely.mp3, come_back.mp3
- sad_whimper.mp3
- youre_back.mp3, hello.mp3, finally.mp3, i_was_worried.mp3, yay.mp3
