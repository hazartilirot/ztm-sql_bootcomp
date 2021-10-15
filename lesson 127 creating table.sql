
-- the following extension is needed in order to generate UUID primary key in the student's table
-- we therefore have to install the extension before executing the next command.
create extension if not exists "uuid-ossp";

create table student (
    student_id uuid primary key default uuid_generate_v4(),
    first_name varchar(255) not null,
    last_name varchar(255) not null,
    email varchar(255) not null,
    date_of_birth date not null
);
-- a domain is a kind of alias to smallint, an extra feature we want to add to a main type
-- so that we may check a value in regard to predefined conditions
create domain Rating smallint
    check (value > 0 and value <=5);


create type Feedback as (
    student_id UUID,
    rating Rating,
    feedback text
);

create table teacher (
    teacher_id UUID default uuid_generate_v4(),
    first_name varchar(255) not null,
    last_name varchar(255) not null,
    email varchar(255) not null,
    date_of_birth date not null,
    constraint teacher_id_key primary key (teacher_id)
);

create table subject (
    subject_id UUID default uuid_generate_v4(),
    subject text,
    description text,
    constraint subject_id_key primary key (subject_id)
);

alter table subject alter column subject set not null;

create table course (
    course_id UUID default uuid_generate_v4(),
    "name" text not null,
    description text,
    subject_id uuid references subject(subject_id),
    teacher_id uuid references teacher(teacher_id),
    feedback feedback[],
    constraint course_id_key primary key (course_id)
);

create table enrollment (
    course_id uuid references course(course_id),
    student_id uuid references student(student_id),
    enrollment_date date not null,
    constraint enrollment_pk primary key (course_id, student_id)
);
-- if we separately don't specify an order regarding data insertion in parenthesis
-- it would take the order from schema by default
insert into student (first_name, last_name, email, date_of_birth)
    values  ('John', 'Doe', 'johndoe@gmail.com', '1990-01-01'::date);

insert into teacher (first_name, last_name, email, date_of_birth)
    values ('John', 'Smith', 'johnsmith@gmail.com','1992-01-02'::date);

insert into subject (subject, description)
    values ('SQL', 'A database management language');


insert into course ("name", description)
    values (
        'SQL Zero to mastery',
        'The art of SQL mastery'
    );

-- while creating a schema for a course we've unintentionally forgotten to set values of two columns
-- to not null it allowed us to insert values into course without error. We need to change behaviour.
-- Before changing restrictions we need to insert a value inside the column. It cannot be empty.
update course set subject_id = '7f4ad098-684f-469b-b962-5a504cc8824e'
    where "name" = 'SQL Zero to mastery';

alter table course alter column subject_id set not null;

-- The same we do for a teacher column. Add a random existing teacher_ id and then restrict the column
-- to a not null parameter.
update course set teacher_id = 'f4de9760-1de6-479a-8546-2d45ae087548'
    where "name" = 'SQL Zero to mastery';

alter table course alter column teacher_id set not null;

alter table enrollment alter column course_id set not null;
alter table enrollment alter column student_id set not null;

insert into enrollment (course_id, student_id, enrollment_date)
    values (
        '215b3871-6770-4a64-962f-80f18cd0390b',
        '8911ec5a-10d9-4f0c-a39c-da6c2788f228',
        now()::date
    );
-- begin of bad code
update course
set feedback = array_append(
    feedback,
    row (
        '8911ec5a-10d9-4f0c-a39c-da6c2788f228',
        5,
        'Great course!'
    )::feedback
)
where course_id = '215b3871-6770-4a64-962f-80f18cd0390b';

update course
set feedback = null
where course_id = '215b3871-6770-4a64-962f-80f18cd0390b';

alter type feedback rename to feedback_deprecated;

alter table course rename column feedback to feedback_deprecated;
-- end of bad code


create table feedback (
    student_id uuid not null references student(student_id),
    course_id uuid not null references course(course_id),
    feedback text not null,
    rating rating,
    constraint feedback_pk primary key (student_id, course_id)
);

insert into feedback (student_id, course_id, feedback, rating)
    values (
        '8911ec5a-10d9-4f0c-a39c-da6c2788f228',
        '215b3871-6770-4a64-962f-80f18cd0390b',
        'Great course!',
        5
    );