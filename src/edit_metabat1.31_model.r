# Script to correct WL/RG reactions to models generated by gapseq.
# Usage:
# Rscript edit_metabat1.31_model.R input_model output_model
# input_model --> Full path to original RDS draft model
# output_model --> Full path where the modified RDS model is going to be stored

library("sybil")

input_model <- args[1] # path to draft model
model <- readRDS(input_model)

# Add missing reactions
model <- addReact(model, id = "rxn00371_c0",
    met = c("cpd00003[c0]", "cpd00047[c0]", "cpd00004[c0]", "cpd00011[c0]"),
    Scoef = c(-1, -1, 1, 1), metComp = c("c0", "c0", "c0", "c0"),
    gprAssoc = paste0("metabat1.31__contig44_402 or metabat1.31__contig81_166 ",
    "or metabat1.31__contig81_167"),
    reversible = TRUE, lb = -1000, ub = 1000, obj = 0)
model <- addReact(model, id = "rxn13974_c0",
    met = c("cpd00011[c0]", "cpd00022[c0]", "cpd00067[c0]", "cpd11620[c0]",
    "cpd00010[c0]", "cpd00020[c0]", "cpd11621[c0]"),
    Scoef = c(-1, -1, -1, -2, 1, 1, 2), metComp = c("c0", "c0", "c0", "c0", "c0", "c0", "c0"),
    gprAssoc = "metabat1.31__contig44_340 or metabat1.31__contig38_1128",
    reversible = TRUE, lb = -1000, ub = 1000, obj = 0)
model <- addReact(model, id = "rxn00165_c0",
    met = c("cpd00054[c0]", "cpd00013[c0]", "cpd00020[c0]"),
    Scoef = c(-1, 1, 1), metComp = c("c0", "c0", "c0"),
    gprAssoc = "metabat1.31__contig81_274 and metabat1.31__contig81_275",
    reversible = TRUE, lb = -1000, ub = 1000, obj = 0)

# Fix GPRs
allGenes(model) <- append(allGenes(model), c("metabat1.31__contig44_343",
    "metabat1.31__contig44_344", "metabat1.31__contig44_342"))
rxnGeneMat(model) <- cbind(rxnGeneMat(model), matrix(FALSE, nrow = nrow(rxnGeneMat(model)), ncol = 3))
model <- changeGPR(model, "rxn11676_c0",
    gprRules = paste0("(metabat1.31__contig44_343 ",
    "or metabat1.31__contig44_344) and metabat1.31__contig44_342 ",
    "and metabat1.31__contig44_345 and metabat1.31__contig44_347"),
    verboseMode = 0)
allGenes(model) <- append(allGenes(model), "metabat1.31__contig44_476")
rxnGeneMat(model) <- cbind(rxnGeneMat(model), rep(FALSE, nrow(rxnGeneMat(model))))
model <- changeGPR(model, "rxn00157_c0",
    gprRules = "metabat1.31__contig44_476 and metabat1.31__contig44_477",
    verboseMode = 0)
allGenes(model) <- append(allGenes(model), "metabat1.31__contig81_26")
rxnGeneMat(model) <- cbind(rxnGeneMat(model), rep(FALSE, nrow(rxnGeneMat(model))))
model <- changeGPR(model, "rxn00908_c0",
    gprRules = paste0("(metabat1.31__contig81_27 ",
    "and metabat1.31__contig81_28) or (metabat1.31__contig81_25 ",
    "and metabat1.31__contig81_26 and metabat1.31__18014_16) ",
    "or (metabat1.31__contig81_25 and metabat1.31__contig81_26 ",
    "and metabat1.31__contig44_260)"),
    verboseMode = 0)

# Fix directionalities
model <- changeBounds(model, "rxn00690_c0", lb = -1000, ub = 1000)
model <- changeBounds(model, "rxn00103_c0", lb = -1000, ub = 1000)
model <- changeBounds(model, "rxn00154_c0", lb = -1000, ub = 1000)

output_model <- args[2] # path to curated draft model
saveRDS(model, output_model)
