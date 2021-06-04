"".resolveRelative.postln;

~stageCtl = NetAddr("localhost", 56666);
~stageCtl.sendMsg("/octave", 4);


Buffer.freeAll;

~buf = Buffer.alloc(s, s.sampleRate * 3);

SynthDef(\input, {
    var in;
    in = SoundIn.ar(0);
    RecordBuf.ar(in, \buf.kr(0), loop: 0.0, trigger: 1.0, doneAction: 2);
}).add;

OSCdef(\rec, {
    "Rec!!!".postln;
    ~recSynth = Synth(\input, [\buf, ~buf]);
}, "/rec");

OSCdef(\amp, {
    arg msg;
    ("Amp is " ++ msg[1]).postln;
    ~recSynth = Synth(\input, [\buf, ~buf]);
    ~gran.set(\amp, msg[1]);
}, "/amp");

SynthDef(\granule, {
    var sig, trigger, frensity;
    frensity = \frensity.kr(30);
    trigger = Select.ar(\sync.kr(0), [Dust.ar(frensity), LFPulse.ar(frensity)]);
    sig = GrainBuf.ar(
        numChannels: 2,
        trigger: trigger,
        dur: \dur.kr(0.1),
        sndbuf: \buf.kr(0),
        rate: \rate.kr(1.0),
        pos: \pos.kr(0.1),
        interp: 2,
        pan: Gendy1.ar(initCPs: 6, knum:3),
        envbufnum: -1
    );
    Out.ar(\out.kr(0), sig * \amp.kr(1.0));
}).add;


// ~buf.play;
//
//
//
// ~gran = Synth(\granule);
//
// ~gran.set(\sync, 1, \frensity, 69.midicps, \dur, 0.01, \pos, 0.276, \amp, 1.0);
//
//
//
// Ajouter des Gendy dans les arguments.
// Ajouter une interface touchOSC pour le contrôle.
// Pis quoi d'autre?


