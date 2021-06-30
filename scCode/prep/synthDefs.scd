

~bufDur = 3;
~buf = Buffer.alloc(s, s.sampleRate * ~bufDur);
~stageCtl.sendMsg("/rectime", 3);


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

SynthDef(\input, {
    var in, phase, bufnum;
    bufnum = \buf.kr(0);
    in = SoundIn.ar(0);
    phase = Line.ar(0, BufFrames.kr(bufnum), BufDur.kr(bufnum), doneAction:2);
    BufWr.ar(in, \buf.kr(0), phase, 0);
    // Send the current time of recording in seconds (every second) and total dur of buffer.
    SendReply.kr(Impulse.kr(1.0), '/rectime', [ phase * SampleRate.ir().reciprocal, BufDur.kr(bufnum) ] );
    SendReply.ar(phase >= BufFrames.kr(bufnum), '/recstop', BufDur.kr(bufnum) );
    // RecordBuf.ar(in, \buf.kr(0), loop: 0.0, trigger: 1.0, doneAction: 2);
}).add;

Sweep