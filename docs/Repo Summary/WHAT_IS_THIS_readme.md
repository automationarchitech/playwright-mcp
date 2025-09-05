test output for summarizing the repo:

the following prompts were used to create High and Low level summaries of the repo as well as a list of files the user should generate 20 tier summaries for:

PROMTS: 

HIGH:
I want you to make a high level summary of this repo and make a human readable file named: "GPT_HIGH_readme.md" in the docs/Summary_tests/GPT5_VRAG folder. It should tell the user how this repo functions what are the main files and what file references what other files. The goal is to have the user understand the high level structure of the repo so they know where and how to guide an LLM for making features effectively and efficiently.

Mid:

can we go a little deeper into the structure? now that we have a high level overview make a more detailed document for someone creating a new tool. Be sure to detail the interactions in between files, type constraints, and other factors. Make this file in the same folder named GPT_MID_readme.md

file list: 

make a granular list of the files that the user would need to summarize in order to provide a virtualized rag system for implementing features. the list should consider that these summaries will be used in context for chats and should be concise yet effective with proper signal over noise considerations. make this list a file: GPT_Summary_Files.md in the docs folder

-----

prompts were tested against:
    regular CO-Pilot using Sonnet 3.7:            CoPilot_sonnet3.7
    augmented instructions and VRAG system:       GPT5_VRAG
    claude code:                                  Claude_code


VRAG instructions: /.github/instructions/project instructions.instructions.md
VRAG file base: /docs/playbook

