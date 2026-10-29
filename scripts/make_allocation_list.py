"""Make the condition allocation list for Emotion Utility Beliefs.

Run ONCE on the Stimulus PC, from the repo folder:
    python scripts/make_allocation_list.py

Writes experiment/task/data/allocation.csv (not in git; backed up to Box with the data).
The list is made of blocks of 12: every combination of group (timing, strategy) and
loopOrder (6 orders of Control/Up/Down) appears once per block, in random order.
So whenever data collection stops, each of the 12 conditions is within one
participant of every other.

It will not overwrite an existing list. Never delete or regenerate the list
during data collection: the experiment reads the next free row from it.
"""
import csv
import itertools
import os
import random
import sys

N_BLOCKS = 15          # 15 x 12 = 180 slots (target is 100+)
SEED = 20261029        # fixed so the list can be regenerated and checked

GROUPS = ['timing', 'strategy']
ORDERS = ['ControlUpDown', 'ControlDownUp', 'UpDownControl',
          'UpControlDown', 'DownControlUp', 'DownUpControl']

here = os.path.dirname(os.path.abspath(__file__))
out_path = os.path.join(here, '..', 'experiment', 'task', 'data', 'allocation.csv')
out_path = os.path.normpath(out_path)

if os.path.exists(out_path):
    sys.exit('Allocation list already exists, not overwriting: ' + out_path)

rng = random.Random(SEED)
cells = list(itertools.product(GROUPS, ORDERS))
rows = []
for block in range(1, N_BLOCKS + 1):
    block_cells = cells[:]
    rng.shuffle(block_cells)
    for group, order in block_cells:
        rows.append({'slot': len(rows) + 1, 'block': block, 'group': group,
                     'loopOrder': order, 'participant': '', 'claimed_at': ''})

os.makedirs(os.path.dirname(out_path), exist_ok=True)
with open(out_path, 'w', newline='', encoding='utf-8') as f:
    w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
    w.writeheader()
    w.writerows(rows)
print('Wrote', len(rows), 'slots to', out_path)
