cat header.md > full.md
cat haskell.md >> full.md
cat lambda.md >> full.md
cat types.md >> full.md
cat prolog.md >> full.md
cat unifikation.md >> full.md
cat parallel_processing.md >> full.md
cat java.md >> full.md
cat compiler.md >> full.md

pandoc -o full.pdf -f markdown --toc full.md
