package org.everythingjboss.jdg.marshallers;

import java.io.IOException;

import org.everythingjboss.jdg.domain.Person;
import org.infinispan.protostream.MessageMarshaller;

public class PersonMarshaller implements MessageMarshaller<Person> {

    @Override
    public String getTypeName() {
        return "proto_files.Person";
    }

    @Override
    public Class<Person> getJavaClass() {
        return Person.class;
    }

    @Override
    public Person readFrom(ProtoStreamReader reader) throws IOException {
        long id = reader.readLong("id");
        String firstName = reader.readString("firstName");
        String lastName = reader.readString("lastName");
        int age = reader.readInt("age");

        Person person = new Person();
        person.setId(id);
        person.setFirstName(firstName);
        person.setLastName(lastName);
        person.setAge(age);
        return person;
    }

    @Override
    public void writeTo(ProtoStreamWriter writer, Person person)
            throws IOException {
        writer.writeLong("id", person.getId());
        writer.writeString("firstName", person.getFirstName());
        writer.writeString("lastName", person.getLastName());
        writer.writeInt("age", person.getAge());
    }
}
