# Archived experiments (before 29 Oct 2026)

These are the two original experiments, replaced by `../emotion_utility_beliefs.psyexp`:

- `experiment_timing.psyexp`: belief instructions only
- `experiment_strategy.psyexp`: belief instructions plus the regulation-strategy paragraph

In these versions the researcher chose the experiment, through the desktop shortcut, and the loopOrder, from the start-up drop-down. The merged experiment assigns both automatically from `data/allocation.csv`.

**Don't run them from this folder.** They use `../` paths from `experiment/task/`, so the stimuli won't load from here, and their data would save into `archive/data/`.

## Reinstating them

From the repo folder:

```
git mv experiment/task/archive/experiment_timing.psyexp experiment/task/
git mv experiment/task/archive/experiment_strategy.psyexp experiment/task/
git commit -m "Reinstate original timing and strategy experiments"
```

Then point the desktop shortcuts back at them and put the loopOrder steps back in the checklist. The git tag `pre-merge` also marks the last commit before the change.
