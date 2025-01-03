# Space Invaders Radar

**Space Invaders Radar** is a Ruby gem that scans a textual "radar" sample for ASCII "invader" patterns.
[Text of the assignment](ASSIGNMENT.md)

## Installation (Optional)
If you prefer **not** to install the gem system-wide, you can skip this section (see **Usage** examples below).
```ruby
gem build space_invaders_radar.gemspec
gem install space_invaders_radar-0.1.0.gem
```

## Usage

You can run the gem directly from the exe/ folder if you don’t want to install::
```bash
exe/space_invaders_radar \
  'spec/fixtures/valid_radar_sample.txt' \
  'spec/fixtures/valid_invader_1.txt' \
  'spec/fixtures/valid_invader_2.txt' \
  --accuracy 0.75 \
  --visibility 0.25
```

If you installed the gem globally or in a gemset, simply use the command:
```bash
space_invaders_radar \
  'spec/fixtures/valid_radar_sample.txt' \
  'spec/fixtures/valid_invader_1.txt' \
  'spec/fixtures/valid_invader_2.txt' \
  --accuracy 0.75 \
  --visibility 0.25
```

## Required arguments

- `radar_sample_path`: Path to the radar sample file.
- `invader_pattern_paths`: Multiple paths to invader pattern files.

## Available Options

### `--accuracy=VALUE`
- **Default**: 0.8
- **Range**: [0.0..1.0]
- **Meaning**: Controls how similar the radar subsection must be to the invader pattern, measured by a Jaccard Index. A higher accuracy (e.g., 0.9) means you only accept very close matches, while a lower accuracy (e.g., 0.5) might treat partial or noisy overlaps as valid.

### `--visibility=VALUE`
- **Default**: 0.25  
- **Range**: [0.0..1.0]
- **Meaning**: Specifies what fraction of the invader pattern must be visible in the radar (i.e., not off the edge). For example, 0.25 means at least 25% of the invader must be within the radar boundaries to be considered for matching; 1.0 means the invader must be fully visible.

### Example Output:
![example output](/output_example.png)
