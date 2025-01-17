; Probe Z- macro (set workspace Z0)

; Define macro variables
#<probe_dist>=15.0   ; Distance the probe will move before failing
#<probe_feed>=100.0  ; Speed at which it probes

; Save current modals
#<units_mode> = #<_metric>
#<distance_mode> = #<_incremental>
#<wcs_num> = [#<_coord_system> / 10 ]

; Set macro modals
G91 ; Set incremental
G21 ; Set metric

; Save starting position 
#<saved_z>=#5422

; Probe toward
G38.2 F#<probe_feed> Z[0 - #<probe_dist>]
#<probed_toward> = #5063 ; save the probe location
;(print, Probe toward Z value: #<probed_toward>)

; Pause for a bit
G4 P0.25

; Probe away
G38.4 F#<probe_feed> Z1.0
#<probed_away> = #5063 ; save the probe location
;(print, Probe away Z value: #<probed_away>)

; Return to starting position
G90 G0 Z#<saved_z>

; Compute average probed value
#<probed_average> = [[#<probed_toward> + #<probed_away>] / 2]
; compensate for difference between when TLO is measured for probe vs solid tool
#<probed_average> = [#<probed_average> + 0.075]

; Set workspace Z0 using the average value
(print, Saving average probed G%.1f#<wcs_num>  Z offset: %f#<probed_average>)
G10 L2 Z#<probed_average>

; Restore modals
G[90 + #<distance_mode>] ; restore the distance mode
G[20 + #<units_mode>] ; restore the units mode
