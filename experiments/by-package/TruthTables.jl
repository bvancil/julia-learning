using TruthTables

@truthtable p || q

@truthtable (p --> q) <--> (¬p ∨ q)

t = @truthtable (p --> q) <--> (¬p ∨ q)
