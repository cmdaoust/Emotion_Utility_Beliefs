# Study variables: a guide for dissertation students

## Context

We often think of emotion regulation as something we do to try to feel better (more positive/less negative), but sometimes we may alter our emotions to achieve a goal. For example, an athlete might psych themselves up before a match to compete more aggressively, or someone might hold on to their anger to help them stand up for themselves in an argument.

Most research on emotion regulation has examined how people regulate their emotions when instructed to do so, but we know less about whether they do so spontaneously when they believe their emotions will help or hinder their performance.

Our project investigates this by asking participants to watch emotional videos before completing cognitive tasks, with their performance on those tasks determining the size of a financial reward. Before each set of videos, participants are told that experiencing intense emotions will improve, impair or have no effect on their performance on the next task. We then measure whether they try to change their emotional responses, and whether their responses actually change.

The study runs in two versions. In the *noStrategy* version, participants are told only how their emotions will affect the upcoming task. In the *strategy* version, they are also given a strategy for changing how intensely they feel. Comparing the two will help us understand whether people fail to regulate spontaneously because they lack the motivation to do so or because they don't know how.

## About this guide

This document lists the behavioural, physiological and questionnaire variables recorded in the study, so you can choose a research question the data can answer.

Participants first answer two questions about their general beliefs about emotion. They then complete three blocks, each made up of instructions, a set of emotional videos and a cognitive task. Before each block, they are told that intense emotions will improve their performance on the next task (Emotion-Beneficial), impair it (Emotion-Costly) or have no effect (Emotion-Neutral). Every participant completes all three conditions, in a counterbalanced order, and the session ends with an open question about what they thought the study was testing.

The variables are measured at three different levels:

- **Per video (trial):** measured after every video, so there are many observations per participant in each condition.
- **Per block (condition):** measured once per condition, so three observations per participant.
- **Per participant:** measured once, such as baseline beliefs, questionnaires, demographics and the end-of-session question.

## Study design variables

| Variable         | What it is                                                          | Values                                                 |
| ---------------- | ------------------------------------------------------------------- | ------------------------------------------------------ |
| participant_id  | Participant identifier                                              | sub-001, sub-002, ...                                  |
| version          | Which version of the study the participant completed                | noStrategy, strategy                                   |
| condition        | What participants were told about emotion's effect on the next task | Emotion_Beneficial, Emotion_Costly, Emotion_Neutral |
| condition_order | Position of the condition in the session                            | 1, 2, 3                                                |
| loopOrder        | Order of the three conditions for that participant                  | e.g. BeneficialCostlyNeutral, NeutralCostlyBeneficial  |
| video_id        | The specific video watched on that trial                            | file name, e.g. ng_78.mp4                             |
| Trial            | Video number within the session                                     | 1 upwards                                              |

Each condition is paired with a different cognitive task: Emotion-Beneficial with an emotional Stroop task (identifying facial emotions), Emotion-Costly with the Corsi block task (remembering sequences), and Emotion-Neutral with a colour Stroop task.

## Ratings after each video

After every video, participants rate how they felt while watching it. These are the main outcome measures for whether participants altered their emotional response.

| Variable                  | Question                                     | Scale                                                            |
| ------------------------- | -------------------------------------------- | ---------------------------------------------------------------- |
| valence_rating           | How did you feel whilst watching this video? | Continuous slider, 0–1 (unhappy to happy)                        |
| arousal_rating           | How did you feel whilst watching this video? | Continuous slider, 0–1 (sleepy to wide awake)                    |
| arousalConfidence_rating | How confident are you?                       | Slider, 0–100. Asked about the arousal rating only, not valence. |
| effort_rating            | How effortful was it to watch the video?     | Continuous slider, 0–1 (no effort to a lot of effort)            |

Each rating also has a response time in seconds: valence_ratingRT, arousal_ratingRT, arousalConfidence_ratingRT and effort_ratingRT. The valence and arousal ratings are shown in random order after each video.

## Ratings before the videos (once per condition)

These are collected after the condition instructions and before the videos, so there is one value per participant per condition.

| Variable                                    | Question                                                                                                                           | Scale                                                    |
| ------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| pre_emoInduction_valence_rating          | Current feeling before the videos                                                                                                  | Continuous slider, 0–1 (unhappy to happy)                |
| pre_emoInduction_arousal_rating          | Current feeling before the videos                                                                                                  | Continuous slider, 0–1 (sleepy to wide awake)            |
| motivation                                  | I am motivated to perform well in the upcoming cognitive task.                                                                     | 1–7, strongly disagree to strongly agree                 |
| told (instruct_told_slider.response)      | I was told that experiencing intense emotions while watching the upcoming set of videos would \_\_\_ my performance on the task.   | 1 = Impair, 2 = Have no effect on, 3 = Improve           |
| belief (instruct_believe_slider.response) | How do you think experiencing intense emotions while watching the upcoming set of videos will affect your performance on the task? | 1–7, greatly impairs to greatly improves (4 = no effect) |

The two pre-video ratings give a baseline mood for each condition. The told item checks whether participants registered what they were told; the belief item shows whether they accepted it. Both run from impair to improve, so they can separate all three conditions.

## Regulation questions after the videos (once per condition)

These are asked once the set of videos has finished and before the cognitive task, so there is one value per participant per condition.

| Variable                     | Question                                                                        | Scale                                                                        |
| ---------------------------- | ------------------------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| pv_attempt_slider.response | While watching the videos, did you try to change how intensely you felt?        | 1 = Tried to feel less, 2 = Did not try to change it, 3 = Tried to feel more |
| pv_effort_slider.response  | How much effort did you put into changing how you felt?                         | 1–7, none to a great deal                                                    |
| pv_strategy_box.text       | What, if anything, did you do to change how you felt while watching the videos? | Free text                                                                    |

These show whether people tried to change their emotions, separately from whether their video ratings actually changed. The strategy answers can be coded, for example to compare the strategies used in the two versions.

## Beliefs and end-of-session questions (once per participant)

The two belief questions come at the start of the session, before any instructions about the conditions. The open question comes at the very end.

| Variable                           | Question                                                                                     | Scale                                                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| baseline_belief_slider.response  | How do you think experiencing intense emotions affects your performance on tasks like these? | 1–7, greatly impairs to greatly improves (4 = no effect) |
| baseline_control_slider.response | How much can people control how intensely they feel emotions?                                | 1–7, not at all to completely                            |
| demand_box_1.text                | What do you think this study was testing?                                                    | Free text                                                |

The prior belief is useful as a baseline for the condition belief ratings, and controllability as a possible moderator of whether people try to regulate. The open question can be used to identify participants who guessed the hypothesis.

## Questionnaires

Each participant completes these once. They are useful as individual-difference predictors or moderators, for example whether people who habitually reappraise regulate more in the Emotion-Beneficial and Emotion-Costly conditions. Scores are item means for each subscale, plus an overall mean (_Overall).

| Questionnaire                                                                   | What it measures                                      | Items and scale   | Subscale variables                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| ------------------------------------------------------------------------------- | ----------------------------------------------------- | ----------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ERQ (Emotion Regulation Questionnaire)                                          | Habitual use of two emotion regulation strategies     | 10 items, 1–7     | ERQ_Reappraisal, ERQ_Suppression, ERQ_Overall                                                                                                                                                                                                                                                                                                                                                                                                     |
| MAIA-2 (Multidimensional Assessment of Interoceptive Awareness)                 | Awareness of, and attitude towards, bodily sensations | 37 items, 0–5     | MAIA_Noticing, MAIA_Not_Distracting, MAIA_Not_Worrying, MAIA_Attention_Regulation, MAIA_Emotional_Awareness, MAIA_Self_Regulation, MAIA_Body_Listening, MAIA_Trusting, MAIA_Overall                                                                                                                                                                                                                                                   |
| CERQ (Cognitive Emotion Regulation Questionnaire; labelled CERQ_S in the data) | Thoughts people use after negative events             | 36 items, 1–5     | CERQ_S_Self_Blame, CERQ_S_Acceptance, CERQ_S_Rumination, CERQ_S_Positive_Refocusing, CERQ_S_Refocus_On_Planning, CERQ_S_Positive_Reappraisal, CERQ_S_Putting_Into_Perspective, CERQ_S_Catastrophising, CERQ_S_Other_Blame, CERQ_S_Overall                                                                                                                                                                                |
| MINT (interoception questionnaire)                                              | Self-reported sensitivity to specific bodily signals  | 45 items, 7-point | MINT_Cardiac_Confusion, MINT_Urointestinal_Inaccuracy, MINT_Dermatoception, MINT_Cardiorespiratory_Noticing, MINT_Satiety_Noticing, MINT_Sexual_Arousal_Sensitivity, MINT_State_Specificity, MINT_Sexual_Organs_Sensitivity, MINT_Expulsion_Accuracy, MINT_Relaxation_Awareness, MINT_Respiroception, MINT_Cardioception, MINT_Gastroception, MINT_Olfactory_Compensation, MINT_Urointestinal_Sensitivity, MINT_Overall |
| Demographics                                                                    | Age and sex                                           | 2 items           | age, sex                                                                                                                                                                                                                                                                                                                                                                                                                                             |

Individual item responses are also in the data (Q1_… for ERQ, Q2_… MAIA-2, Q3_… CERQ, Q4_… MINT), with reverse-scored MAIA-2 items already reversed.

## Physiological measures

Skin conductance (EDA) and heart data (ECG) are recorded throughout the session. Most measures are available for **each individual video** and **averaged across each block** (Emotion-Beneficial, Emotion-Costly, Emotion-Neutral); heart rate variability is per block only, because the videos are too short to calculate this accurately.

### Skin conductance (EDA)

Link to Ledalab documentation

| Variable    | What it is                                                    | Level           |
| ----------- | ------------------------------------------------------------- | --------------- |
| CDA.nSCR    | Number of skin conductance responses (SCRs)                   | Video and block |
| CDA.AmpSum  | Summed amplitude of the SCRs (µS)                             | Video and block |
| CDA.SCR     | Average phasic (fast-changing) skin conductance activity (µS) | Video and block |

### Heart rate (ECG)

| Variable   | What it is                                                            | Level           |
| ---------- | --------------------------------------------------------------------- | --------------- |
| HR_mean   | Mean heart rate (bpm)                                                 | Video and block |
| HR_change | Change in heart rate from the fixation before the video (bpm)         | Video and block |
| HRV_RMSSD | Heart rate variability (RMSSD, ms), calculated across the whole block | Block only      |

## Notes for planning analyses

- **Performance** on the cognitive tasks (Stroop, emotional Stroop, Corsi) may not be analysable – TBC.
