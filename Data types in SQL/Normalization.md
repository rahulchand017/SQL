Data Normalization (RDBMS)
1. Why can't a single table hold all  the data?
Data redundancy and dependency.
Anomaly occur
1. Insert Anomaly
2. Deletion anomaly
3. Update Anomaly

Solution -> Thats why we use Normalization.
Normalization is used to minimize data redundancy and dependencies.
Normalization is achieved through a series of progressively stricter rules known as normal forms:

1NF (First Normal Form):
Eliminates repeating groups of columns and ensures each column contains atomic values (single, indivisible pieces of information). 


2NF (Second Normal Form):
Must be in 1NF and all non-key attributes must be fully functionally dependent on the primary key. 
Should not be partially dependent.
Partially dependencies occur when a non key attribute is dependent on only a part of the primary keu instead of the entire key. 


3NF (Third Normal Form):
Must be in 2NF and eliminate transitive dependencies (where a non-key attribute is dependent on another non-key attribute). 
non-key attribute are columns other than primary key.


BCNF (Boyce-Codd Normal Form):
A stricter version of 3NF, often considered when there are complex dependencies