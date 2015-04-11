# SQL Operator Precedence reference

Here is a reference for SQL operator precedence on different databases:

[MySQL](https://dev.mysql.com/doc/refman/5.0/en/operator-precedence.html) | [PostgreSQL](http://www.postgresql.org/docs/9.2/static/sql-syntax-lexical.html#SQL-PRECEDENCE) | [Oracle 11g](cs.oracle.com/cd/B28359_01/server.111/b28286/operators001.htm#SQLRF51149) | [SQLite](https://www.sqlite.org/lang_expr.html)
-------- | ---
| INTERVAL | | |
| | | | ~ (unary bit inversion)
| BINARY, COLLATE | | | COLLATE
| | . | |
| | \:\: | |
| | [] | |
| ! | | | 
| \- (unary minus), ~ (unary bit inversion) | \- (unary minus), + (unary plus) | \- (unary minus), + (unary plus), PRIOR, CONNECT_BY_ROOT | \- (unary minus), + (unary plus)
| ^ | ^ | |
| | | | \|\| (concatenation)
| \*, /, DIV, %, MOD | \*, / | \*, / | \*, /, %
| \-, + | \-, + | \-, +, \|\| (concatenation) | \-, +
| <<, >> | | | <<, >>, &, \|
| & |
| \| |
| = (comparison), <=>, >=, >, <=, <, <>, !=, IS, LIKE, REGEXP, IN | IS | =, !=, <, >, <=, >= | <, <=, >, >=
| | | | = (comparison), ==, !=, <>, IS, IS NO, IN, LIKE, GLOB, MATCH, REGEXP
| | | IS [NOT] NULL, LIKE, [NOT] BETWEEN, [NOT] IN, EXISTS, IS OF type
| | ISNULL | 
| | NOTNULL |
| | (any other) |
| | IN |
| | BETWEEN |
| | OVERLAPS |
| | LIKE, ILIKE, SIMILAR |
| | <, > |
| | = (comparison) |
| BETWEEN, CASE, WHEN, THEN, ELSE | |
| NOT | NOT | NOT
| AND, && | AND | AND | AND
| XOR | |
|OR, \|\| | OR | OR | OR
| = (assignment), := | |

TODO:
- PostgreSQL: <=, >=
