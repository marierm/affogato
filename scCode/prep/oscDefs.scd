
OSCdef(\rec, {
    "Rec!!!".postln;
    ~recSynth = Synth(\input, [\buf, ~buf]);
}, "/rec");


// receives the total dur of buffer as argument to be able to reset the stage GUI at end of recording.
OSCdef(\recStop, {
    arg msg;
    var bufDur;
    bufDur = msg[3];
    "Rec stopped!!!".postln;
    ~stageCtl.sendMsg("/rec", 0); // change color of rec button
    ~stageCtl.sendMsg("/rectime", 0); // set time indicator to 0
    // 1.5 seconds later, set time indicator to duration of buffer.
    ~stageCtl.sendBundle( 1.5,
        ["/rectime", bufDur.asInteger]
    );
    // ~recSynth = Synth(\input, [\buf, ~buf]);
}, "/recstop");


// receives the current time in seconds and total dur of buffer.
OSCdef(\recTime, {
    arg msg;
    var bufDur, seconds;
    bufDur = msg[4];
    seconds = msg[3];
    msg.postln;
    ~stageCtl.sendMsg("/rectime", (bufDur - seconds).round.asInteger);
    // ~recSynth = Synth(\input, [\buf, ~buf]);
}, "/rectime");

OSCdef(\amp, {
    arg msg;
    ("Amp is " ++ msg[1]).postln;
    // ~recSynth = Synth(\input, [\buf, ~buf]);
    ~gran.set(\amp, msg[1]);
}, "/amp");

