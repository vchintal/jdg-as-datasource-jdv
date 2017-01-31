## Prerequisites

1. JDK 1.8 installed, `JAVA_HOME` is set and `java` is on **PATH**
2. JDG 6.6.1 installed (6.6.0 with patch)
3. JDG 6.3 installed and patched 

## Setup 

* In the terminal set environment variables `JDG_HOME` and `JDV_HOME`
* Download the **JDG 6.6.1 Remote Client EAP Modules** binary as mentioned in [binaries/README.md](binaries/README.md) 
* Run `./install.sh` in the root folder of the project

## Testing

* Install and use __Squirrel SQL Client__ as described [here](http://blog.everythingjboss.org/articles/Using-Squirrel-JDV/)
* Use the JDBC connection string: `jdbc:teiid:People@mm://localhost:31100` (since the JDV server starts at an port-offset of 100)
* Run the following queries and enjoy!

```sql
insert into People.Person (id,firstName,lastName,age) values (1,'Bill', 'Clinton', 69);
select * from People.Person;
```

