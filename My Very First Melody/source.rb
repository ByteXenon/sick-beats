# ~My very first melody~
# Made by bytexenon, 2024
#  https://github.com/Bytexenon

use_bpm 128 # 128 cause I can :sunglasses: :catBlush:

# Define the melodies
melodies = [
  (ring :e3, :r, :e3, :r, :e3, :g3, :r, :e3),  # E minor pentatonic
  (ring :e3, :g3, :a3, :r, :e3, :g3, :a3, :r),  # A
  (ring :e3, :a3, :b3, :r, :e3, :a3, :b3, :r),  # B
  (ring :e3, :b3, :c4, :r, :e3, :b3, :c4, :r)   # C
]

# Create an octave-shifted version of each motif
high_toned_melodies = melodies.map { |melody| melody.map { |note| note == :r ? :r : note + 12 } }

# Define the rhythm as eighth notes
rhythm = (ring 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5)

# Bass line in E minor
bass_line = (ring :e1, :e2, :e3, :e1, :e2, :e3)

# Chords progression in E minor
chords = (ring chord(:e3, :minor), chord(:g3, :minor), chord(:a3, :minor), chord(:b3, :minor))

# TB-303 synth function to play the melodies
define :play_melody do |notes|
  use_synth :tb303
  play_pattern_timed notes, rhythm, amp: 0.7, release: 0.1, cutoff: 100
end

# Function to play the Amen break with *some effects*
define :amen_break do
  sample :bd_klub, amp: 0.3
  sleep 1
  4.times do |i|
    with_fx :reverb, room: 0.8 do
      with_fx :distortion, distort: (i/4.0) / 2.0 do
        with_fx :echo, mix: 0.3, phase: 1 + Math.sin(i / 4) do
          # I have autism
          sample :loop_amen, beat_stretch: 4, amp: 0.8, pitch: Math.sqrt(i + 1), rate: 1 * (1 + Math.sin(i / 8))
        end
      end
    end
    sleep 2
  end
  sleep 1
  sample :drum_cymbal_hard, amp: 0.8
  sleep 1
end

first_time = true
melody_index = 0

# loop, alternates between the original and octave-shifted motifs
live_loop :melody do
  if melody_index % (melodies.length * 2) < (melodies.length - 1) then
    play_melody melodies[melody_index % melodies.length]
  else
    play_melody high_toned_melodies[melody_index % melodies.length]
  end
  if first_time then
    amen_break
    first_time = false
  end
  melody_index += 1
end

# Bass loop
live_loop :bass, sync: :melody do
  use_synth :subpulse
  play_pattern_timed bass_line, rhythm, amp: 0.8
end

# Chords loop
live_loop :chords, sync: :melody do
  use_synth :saw
  play_pattern_timed chords, rhythm, amp: 0.6
end

# Drums loop
live_loop :drums, sync: :melody do
  sample :bd_haus
  sleep 1
end

# Hi-hats loop
live_loop :hihats, sync: :melody do
  sample :drum_cymbal_closed
  sleep 0.5
end

live_loop :pad, sync: :melody do
  use_synth :dark_ambience
  play chord(:e3, :m7), attack: 2, release: 4, amp: 0.3
  sleep 4
end

# Extra synth loop
live_loop :extra_synth, sync: :melody do
  use_synth :prophet
  play_pattern_timed chords, rhythm, amp: 0.5
  sleep 0.5
end

# Synth lead loop
live_loop :synth_lead, sync: :melody do
  use_synth :blade
  play_pattern_timed melodies[melody_index % melodies.length], rhythm, amp: 0.7
  sleep 0.5
end
