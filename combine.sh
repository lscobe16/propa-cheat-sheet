cat header.md > full.md

echo "Sourcecode: https://github.com/lscobe16/propa-cheat-sheet ; Version: " >> full.md
date +%FT%H:%M >> full.md
echo "\n\n" >> full.md

cat content/haskell.md >> full.md
cat content/prolog.md >> full.md
cat content/unifikation.md >> full.md
cat content/lambda.md >> full.md
cat content/types.md >> full.md
cat content/parallel_processing.md >> full.md
cat content/java.md >> full.md
cat content/compiler.md >> full.md
cat content/learnings.md >> full.md

pandoc -H preamble.tex -o full.pdf -f markdown full.md
