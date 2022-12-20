mutable struct Person
    name::String
    age::Float64
    isActive::Bool

    function Person(name, age)
        new(name, age, true)
    end
end

logan = Person("Logan", 27)

function birthday(person::Person)
    person.age += 1
end

birthday(logan)
logan