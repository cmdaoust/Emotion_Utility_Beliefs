# Emotion Utility Beliefs

Follow-up to the ER_Physiology study. It tests whether telling participants that intense emotion will improve, impair or have no effect on an upcoming task changes their beliefs, emotion regulation and physiological arousal.

Two PsychoPy experiments (in `experiment/`):

- `experiment_timing.psyexp`: belief instructions only
- `experiment_strategy.psyexp`: the same instructions plus a regulation-strategy paragraph

**PsychoPy version: 2024.2.1.** Use the same version on every machine. Opening and saving in another version can change the `.psyexp` files.

## Folder layout

```
Emotion_Utility_Beliefs/
├── experiment/            .psyexp files and condition/instruction .xlsx files
├── video_stimuli          NOT in git: link or copy (see below)
├── bw_image               NOT in git: face images for the emotional Stroop; link or copy (see below)
├── slider_images_light/   affect slider images
├── volume_test/           volume check media
└── click_to_continue.png
```

The experiments use `../` paths from `experiment/`, so the stimuli must sit at the repo root with exactly these names.

## Setting up a new machine

1. Install PsychoPy 2024.2.1.
2. Clone the repo:
   `git clone https://github.com/cmdaoust/Emotion_Utility_Beliefs.git`
3. Add the `video_stimuli` and `bw_image` folders at the repo root, either:
   - **link** to an existing copy (no extra space), in Command Prompt:
     `mklink /J "<repo>\video_stimuli" "<path to>\ER_Physiology\experiment\video_stimuli"`
     `mklink /J "<repo>\bw_image" "<path to>\ER_Physiology\experiment\bw_image"`
   - or **copy** both folders from ER_Physiology into the repo root.
4. Open `experiment/experiment_timing.psyexp` in PsychoPy and do a test run.

## Workflow (own PC to lab computer)

- Edit the experiment on your own PC, then commit and push.
- On the lab computer, run `git pull` before every session.
- Don't edit the experiment on the lab computer. If you have to, commit and push before leaving, or you'll get merge conflicts in the `.psyexp` XML.

## Not in this repo

- `video_stimuli/` and `bw_image/`: stimulus sets kept in ER_Physiology; see setup.
- `experiment/data/`: participant data never goes on GitHub. Back it up separately, following the ethics approval.
- `*_lastrun.py`: PsychoPy regenerates these.
