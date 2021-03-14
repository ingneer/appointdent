# Software Engineering excercise

## Hello you!

The goal of this excercise is to demonstrate and evaluate

- your coding proficiency
- how you organize your work
- whatever skill you want to flex

It also gives us something to talk about at the next stage of the hiring process.

You should have about 2-4 hours to do the excercise on your own time. If possible, submit your results within a week. You can spend less time, you can spend more time. Up to you.

Once you're done, package your results however you want and send them to us (Hint: Git is a valuable tool to us)

## The problem

This is an example of a task we recently encountered while working on a feature at Denteo.

Dentists like to keep their daily schedules tighly packed. They start working at 08:00 and stop working at 18:00, with a 1h lunchbreak from 12:00-13:00.
We want to let patients self-select a convenient time for their next dentist appointment, so we first have to figure out all times when the dentist is available.
Finally, we want to display possible appointment times in convenient 30 minute blocks.

## Code example

Here's some starter code and a little dataset to work with.

```javascript
// This is the range where our patient wants to have an appointment
const searchRange = { from: "2021-01-04", to: "2021-01-07" };

// The dentists' current appointments, these times are blocked.
const weeklyAppointments = [
  { from: "2021-01-04T10:15:00", to: "2021-01-04T10:30:00" },
  { from: "2021-01-05T11:00:00", to: "2021-01-05T11:30:00" },
  { from: "2021-01-05T15:30:00", to: "2021-01-05T16:30:00" },
  { from: "2021-01-06T10:00:00", to: "2021-01-06T10:30:00" },
  { from: "2021-01-06T11:00:00", to: "2021-01-06T12:30:00" },
  { from: "2021-01-06T17:30:00", to: "2021-01-06T18:00:00" },
];

// FIXME: actual date objects could be useful... (ಠ⌣ಠ)
const DAY_START = "08:00";
const DAY_END = "18:00";
const LUNCH_START = "12:00";
const LUNCH_END = "13:00";

// TODO: implement this
const findFreeTimeslots = () => [];
```

## Example

Given the dentist has unblocked time from 08:00 to 09:30, this would result in 3 possible appointment times for the patient: 08:00, 08:30 and 09:00.
That's it. Your result might be a list in the same/similar shape as `weeklyAppointments`.

## Outcome

We'd like to see the possible appointment times. You might just log them to stdout/console, create a little UI or some other interesting way to demonstrate your skills.
You are free to adapt this example however you think makes sense:

- Use a different language, some framework, any library, a database, a build tool, a test framework (Hint: we work with Ruby, JavaScript, SQL).
- Keep it simple in an HTML file or a command line script...
- ... or deploy a website, push a docker container, send a shell script, link a Codepen or come up with something we wouldn't think of.

Send us a link to your results within a week and we'll get back to you asap!
This should be a fun excercise, hopefully! If you think it isn't, we are open to feedback and will adapt if necessary.
