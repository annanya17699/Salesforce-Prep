# Salesforce-Prep
Salesforce Interview Prep
1. Apex Trigger Scenarios 

| #        | BEFORE INSERT | AFTER INSERT  | BEFORE UPDATE | AFTER UPDATE  | BEFORE DELETE | AFTER DELETE  | AFTER UNDELETE |
|----------|---------------|---------------|---------------|---------------|---------------|---------------|----------------|
| NEW      |  Yes          | Yes           | Yes           | Yes           | No            | No            | Yes            |
| NEW MAP  |  No           | Yes           | Yes           | Yes           | No            | No            | Yes            |
| OLD      |  No           | No            | Yes           | Yes           | Yes           | Yes           | No             |   
| OLD MAP  |  No           | No            | Yes           | Yes           | Yes           | Yes           | No             | 