(
~stageCtl = NetAddr("localhost", 56666);
~stageCtl.sendMsg("/octave", 3);
~stageCtlPath = "C:/Users/User/Documents/open-stage-control-1.9.7-win32-x64/";
(~stageCtlPath ++ "open-stage-control.exe -- --port 5555 --send localhost:57120 --osc-port 56666 --load " ++ "../zest01.json".resolveRelative).unixCmd;
)

(
Server.default.waitForBoot({
    Buffer.freeAll;
    "prep/synthDefs.scd".loadRelative;
    "prep/oscDefs.scd".loadRelative;
});
)





~buf.play;
//
//
//
~gran = Synth(\granule);
//
~gran.set(\sync, 1, \frensity, 50.midicps, \dur, 0.01, \pos, 0.276, \amp, 1.0);
//
//
//
// Ajouter des Gendy dans les arguments.
// Ajouter une interface touchOSC pour le contrôle.
// Pis quoi d'autre?
