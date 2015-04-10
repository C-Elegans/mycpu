transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/mnolan/Downloads {/home/mnolan/Downloads/mycpu.v}
vlog -vlog01compat -work work +incdir+/home/mnolan/projects/mycpu {/home/mnolan/projects/mycpu/ram2.v}
vlog -vlog01compat -work work +incdir+/home/mnolan/projects/mycpu {/home/mnolan/projects/mycpu/shift.v}

