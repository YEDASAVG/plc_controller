PROGRAM relay_control
  VAR
    cmd1 AT %MW0 : INT;            (* Holding Register 1024: command from app *)
    cmd2 AT %MW1 : INT;            (* Holding Register 1025 *)
    cmd3 AT %MW2 : INT;            (* Holding Register 1026 *)
    cmd4 AT %MW3 : INT;            (* Holding Register 1027 *)

    state1 AT %MW4 : INT;          (* Holding Register 1028: actual state feedback *)
    state2 AT %MW5 : INT;          (* Holding Register 1029 *)
    state3 AT %MW6 : INT;          (* Holding Register 1030 *)
    state4 AT %MW7 : INT;          (* Holding Register 1031 *)

    relay1_out AT %QX0.0 : BOOL;   (* GPIO output - Relay 1 *)
    relay2_out AT %QX0.1 : BOOL;   (* GPIO output - Relay 2 *)
    relay3_out AT %QX0.2 : BOOL;   (* GPIO output - Relay 3 *)
    relay4_out AT %QX0.3 : BOOL;   (* GPIO output - Relay 4 *)
  END_VAR

  (* Relay 1 & 2: Direct control - no restrictions *)
  relay1_out := NOT (cmd1 > 0);
  relay2_out := NOT (cmd2 > 0);

  (* Relay 3 & 4: Safety interlock - only one can be ON at a time *)
  IF (cmd3 > 0) AND (cmd4 > 0) THEN
    relay3_out := FALSE;   (* FALSE = LOW = relay ON for active-low *)
    relay4_out := TRUE;    (* TRUE = HIGH = relay OFF *)
  ELSE
    relay3_out := NOT (cmd3 > 0);
    relay4_out := NOT (cmd4 > 0);
  END_IF;

  (* Write actual output states back to feedback registers *)
  (* NOT inverted: relay_out=FALSE means relay is ON *)
  IF NOT relay1_out THEN state1 := 1; ELSE state1 := 0; END_IF;
  IF NOT relay2_out THEN state2 := 1; ELSE state2 := 0; END_IF;
  IF NOT relay3_out THEN state3 := 1; ELSE state3 := 0; END_IF;
  IF NOT relay4_out THEN state4 := 1; ELSE state4 := 0; END_IF;

END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms, PRIORITY := 0);
    PROGRAM instance0 WITH task0 : relay_control;
  END_RESOURCE
END_CONFIGURATION
