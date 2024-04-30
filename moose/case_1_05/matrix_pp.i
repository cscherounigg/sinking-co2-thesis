# CASE 01 - MATRIX ONLY
# C. Scherounigg
# Master Thesis 2024
# Injection into matrix only
# Parameters
enable_production = true
gravitational_acceleration = -9.81 # m/s²
initial_pressure_water = 25.0e6 # Pa
initial_pressure_gas = 25.1e6 # Pa
initial_temperature = 773.15 # K
# injection_pressure = 40e6 # Pa
injection_rate = 15 # kg/s
injection_temperature = 373.15 # K
production_pressure = 10e6 # Pa
injection_point = '0 400 -2500'
production_point = '800 400 -2500'
water_fluid_properties = tabulated_water # Options: tabulated_water, eos_water
gas_fluid_properties = tabulated_gas # Options: tabulated_gas, eos_gas
simulation_time = 1.576800e+09 # s; 50 years
permeability = 1e-13
porosity = 0.1
output_only_selected_timesteps = true
# Script
[Mesh]
  uniform_refine = 0
  [matrix_mesh]
    type = GeneratedMeshGenerator
    dim = 3
    nx = 20
    xmin = 0
    xmax = 800
    ny = 20
    ymin = 0
    ymax = 800
    nz = 40
    zmin = -3000
    zmax = -2000
  []
  [injector_refinement_block]
    type = SubdomainBoundingBoxGenerator
    input = matrix_mesh
    bottom_left = '0 350 -2550'
    top_right = '50 450 -2450'
    block_id = 1
  []
  [producer_refinement_block]
    type = SubdomainBoundingBoxGenerator
    input = injector_refinement_block
    bottom_left = '750 350 -2550'
    top_right = '800 450 -2450'
    block_id = 2
    show_info = false
  []
  [mesh_refinement]
    type = RefineBlockGenerator
    input = producer_refinement_block
    block = '1 2'
    refinement = '2 2' # Double the amount of elements
  []
  [injection_node]
    input = mesh_refinement
    type = ExtraNodesetGenerator
    new_boundary = injection_node
    coord = '0 400 -2500'
  []
  # [injection_node]
  #   input = matrix_mesh
  #   type = ExtraNodesetGenerator
  #   new_boundary = injection_node
  #   coord = '0 400 -2500'
  # []
[]
[GlobalParams]
  PorousFlowDictator = dictator
[]
[Variables]
  [matrix_pressure_water]
    initial_condition = ${initial_pressure_water}
  []
  [matrix_temperature]
    initial_condition = ${initial_temperature}
    scaling = 1e-6 # Enthalpy is in the range of 1e-6
  []
  [matrix_pressure_gas]
    initial_condition = ${initial_pressure_gas}
  []
[]
[Kernels]
  [matrix_mass_water_dot]
    type = PorousFlowMassTimeDerivative
    fluid_component = 0
    variable = matrix_pressure_water
  []
  [matrix_flux_water]
    type = PorousFlowAdvectiveFlux
    fluid_component = 0
    variable = matrix_pressure_water
    gravity = '0 0 ${gravitational_acceleration}'
  []
  [matrix_mass_gas_dot]
    type = PorousFlowMassTimeDerivative
    fluid_component = 1
    variable = matrix_pressure_gas
  []
  [matrix_flux_co2]
    type = PorousFlowAdvectiveFlux
    fluid_component = 1
    variable = matrix_pressure_gas
    gravity = '0 0 ${gravitational_acceleration}'
  []
  [energy_dot]
    type = PorousFlowEnergyTimeDerivative
    variable = matrix_temperature
  []
  [advection]
    type = PorousFlowHeatAdvection
    variable = matrix_temperature
    gravity = '0 0 ${gravitational_acceleration}'
  []
  [conduction]
    type = PorousFlowHeatConduction
    variable = matrix_temperature
  []
[]
[DiracKernels]
  [injection]
    type = PorousFlowSquarePulsePointSource
    mass_flux = ${injection_rate}
    point = ${injection_point}
    variable = matrix_pressure_gas
  []
  # [gas_injection]
  #   type = PorousFlowPeacemanBorehole
  #   SumQuantityUO = mass_gas_injected
  #   variable = matrix_pressure_gas
  #   function_of = pressure
  #   bottom_p_or_t = ${injection_pressure}
  #   character = -1
  #   #line_length = 1
  #   #line_direction = '0 0 1'
  #   point_file = injector.traj
  #   unit_weight = '0 0 0'
  #   fluid_phase = 1
  #   use_mobility = true
  #   #line_base = ${production_point}
  #   #point_not_found_behavior = WARNING
  # []
  [water_production]
    type = PorousFlowPeacemanBorehole
    SumQuantityUO = mass_water_produced
    variable = matrix_pressure_water
    function_of = pressure
    bottom_p_or_t = ${production_pressure}
    character = 1
    #line_length = 1
    #line_direction = '0 0 1'
    point_file = producer.traj
    unit_weight = '0 0 0'
    fluid_phase = 0
    use_mobility = true
    enable = ${enable_production}
    #line_base = ${production_point}
    #point_not_found_behavior = WARNING
  []
  [gas_production]
    type = PorousFlowPeacemanBorehole
    SumQuantityUO = mass_gas_produced
    variable = matrix_pressure_gas
    function_of = pressure
    bottom_p_or_t = ${production_pressure}
    character = 1
    #line_length = 1
    #line_direction = '0 0 1'
    point_file = producer.traj
    unit_weight = '0 0 0'
    fluid_phase = 1
    use_mobility = true
    enable = ${enable_production}
    #line_base = ${production_point}
    #point_not_found_behavior = WARNING
  []
  [heat_production_water]
    type = PorousFlowPeacemanBorehole
    SumQuantityUO = heat_water_produced
    variable = matrix_temperature
    function_of = pressure
    bottom_p_or_t = ${production_pressure}
    character = 1
    #line_length = 1
    #line_direction = '0 0 1'
    point_file = producer.traj
    unit_weight = '0 0 0'
    fluid_phase = 0
    use_mobility = true
    use_enthalpy = true
    enable = ${enable_production}
    #line_base = ${production_point}
    #point_not_found_behavior = WARNING
  []
  [heat_production_gas]
    type = PorousFlowPeacemanBorehole
    SumQuantityUO = heat_gas_produced
    variable = matrix_temperature
    function_of = pressure
    bottom_p_or_t = ${production_pressure}
    character = 1
    #line_length = 1
    #line_direction = '0 0 1'
    point_file = producer.traj
    unit_weight = '0 0 0'
    fluid_phase = 1
    use_mobility = true
    use_enthalpy = true
    enable = ${enable_production}
    #line_base = ${production_point}
    #point_not_found_behavior = WARNING
  []
[]
[AuxVariables]
  [matrix_massfraction_ph0_sp0] # Phase 0, Species 0; Water
    initial_condition = 1
  []
  [matrix_massfraction_ph1_sp0] # Phase 1, Species 0; Gas
    initial_condition = 0
  []
  [matrix_saturation_gas]
    order = FIRST
    family = MONOMIAL
  []
  [matrix_saturation_water]
    order = FIRST
    family = MONOMIAL
  []
  [matrix_density_water]
    order = CONSTANT
    family = MONOMIAL
  []
  [matrix_density_gas]
    order = CONSTANT
    family = MONOMIAL
  []
  [matrix_viscosity_water]
    order = CONSTANT
    family = MONOMIAL
  []
  [matrix_viscosity_gas]
    order = CONSTANT
    family = MONOMIAL
  []
  [matrix_enthalpy_gas]
    order = CONSTANT
    family = MONOMIAL
  []
  [matrix_enthalpy_water]
    order = CONSTANT
    family = MONOMIAL
  []
[]
[AuxKernels]
  [matrix_saturation_gas]
    type = PorousFlowPropertyAux
    property = saturation
    phase = 1
    variable = matrix_saturation_gas
  []
  [matrix_saturation_water]
    type = PorousFlowPropertyAux
    property = saturation
    phase = 0
    variable = matrix_saturation_water
  []
  [matrix_enthalpy_gas]
    type = PorousFlowPropertyAux
    property = enthalpy
    phase = 1
    variable = matrix_enthalpy_gas
  []
  [matrix_enthalpy_water]
    type = PorousFlowPropertyAux
    property = enthalpy
    phase = 0
    variable = matrix_enthalpy_water
  []
  [matrix_density_water]
    type = PorousFlowPropertyAux
    property = density
    phase = 0
    variable = matrix_density_water
  []
  [matrix_density_gas]
    type = PorousFlowPropertyAux
    property = density
    phase = 1
    variable = matrix_density_gas
  []
  [matrix_viscosity_water]
    type = PorousFlowPropertyAux
    property = viscosity
    phase = 0
    variable = matrix_viscosity_water
  []
  [matrix_viscosity_gas]
    type = PorousFlowPropertyAux
    property = viscosity
    phase = 1
    variable = matrix_viscosity_gas
  []
[]
[Materials]
  [matrix_temperature]
    type = PorousFlowTemperature
    temperature = matrix_temperature
  []
  [pore_pressures]
    type = PorousFlow2PhasePP
    phase0_porepressure = matrix_pressure_water
    phase1_porepressure = matrix_pressure_gas
    capillary_pressure = capillary_pressure
  []
  [massfrac]
    type = PorousFlowMassFraction
    mass_fraction_vars = 'matrix_massfraction_ph0_sp0 matrix_massfraction_ph1_sp0'
  []
  [water]
    type = PorousFlowSingleComponentFluid
    fp = ${water_fluid_properties} # Fluid properties
    phase = 0
  []
  [gas]
    type = PorousFlowSingleComponentFluid
    fp = ${gas_fluid_properties} # Fluid properties
    phase = 1
  []
  [relative_permeability_water]
    type = PorousFlowRelativePermeabilityCorey
    n = 2
    phase = 0
    s_res = 0.1
    sum_s_res = 0.1
  []
  [relative_permeability_gas]
    type = PorousFlowRelativePermeabilityCorey
    n = 2
    phase = 1
  []
  [porosity]
    type = PorousFlowPorosityConst
    porosity = ${porosity}
  []
  [biot_modulus]
    type = PorousFlowConstantBiotModulus
    solid_bulk_compliance = 1E-10
    fluid_bulk_modulus = 2E9
  []
  [permeability]
    type = PorousFlowPermeabilityConst
    permeability = '${permeability} 0 0   0 ${permeability} 0   0 0 ${permeability}'
  []
  [thermal_expansion]
    type = PorousFlowConstantThermalExpansionCoefficient
    fluid_coefficient = 5E-6
    drained_coefficient = 2E-4
  []
  [thermal_conductivity]
    type = PorousFlowThermalConductivityIdeal
    dry_thermal_conductivity = '1 0 0  0 1 0  0 0 1'
    wet_thermal_conductivity = '3 0 0  0 3 0  0 0 3'
  []
  [rock_heat]
    type = PorousFlowMatrixInternalEnergy
    density = 2500.0
    specific_heat_capacity = 1200.0
  []
[]
[FluidProperties]
  [eos_water]
    type = Water97FluidProperties
  []
  [eos_gas]
    type = CO2FluidProperties
  []
  [tabulated_water]
    type = TabulatedBicubicFluidProperties
    fp = eos_water
    fluid_property_file = fluid_properties_water.csv
    interpolated_properties = 'density enthalpy internal_energy viscosity'
    temperature_min = 300 # K
    temperature_max = 900 # K
    pressure_min = 10e6 # Pa
    pressure_max = 50e6 # Pa
    num_T = 100
    num_p = 100
    error_on_out_of_bounds = False
  []
  [tabulated_gas]
    type = TabulatedBicubicFluidProperties
    fp = eos_gas
    fluid_property_file = fluid_properties_gas.csv
    interpolated_properties = 'density enthalpy internal_energy viscosity'
    temperature_min = 300 # K
    temperature_max = 900 # K
    pressure_min = 10e6 # Pa
    pressure_max = 50e6 # Pa
    num_T = 100
    num_p = 100
    error_on_out_of_bounds = False
  []
[]
[UserObjects]
  [mass_gas_injected]
    type = PorousFlowSumQuantity
  []
  [mass_water_produced]
    type = PorousFlowSumQuantity
  []
  [mass_gas_produced]
    type = PorousFlowSumQuantity
  []
  [heat_water_produced]
    type = PorousFlowSumQuantity
  []
  [heat_gas_produced]
    type = PorousFlowSumQuantity
  []
  [dictator]
    type = PorousFlowDictator
    porous_flow_vars = 'matrix_pressure_water matrix_temperature matrix_pressure_gas'
    number_fluid_phases = 2
    number_fluid_components = 2
  []
  [capillary_pressure]
    type = PorousFlowCapillaryPressureVG
    alpha = 1e-6
    m = 0.6
    s_scale = 0.9
  []
[]
[BCs]
  [pressure]
    type = DirichletBC
    variable = matrix_pressure_water
    value = ${initial_pressure_water}
    boundary = 'front' # Corresponds to top of reservoir
  []
  [temperature]
    type = DirichletBC
    variable = matrix_temperature
    value = ${initial_temperature}
    boundary = 'front back' # Corresponds to top and bottom of reservoir
  []
  [injection_temperature]
    type = DirichletBC
    variable = matrix_temperature
    value = ${injection_temperature}
    boundary = injection_node
  []
[]
[ICs]
  [injection_temperature]
    type = ConstantIC
    variable = matrix_temperature
    value = ${injection_temperature}
    boundary = injection_node
  []
[]
[Functions]
  [mass_rate_water_production]
    type = ParsedFunction
    symbol_values = 'dt mass_water_produced_pp'
    symbol_names = 'dt mass_water_produced_pp'
    expression = 'mass_water_produced_pp/dt'
  []
  [mass_rate_gas_production]
    type = ParsedFunction
    symbol_values = 'dt mass_gas_produced_pp'
    symbol_names = 'dt mass_gas_produced_pp'
    expression = 'mass_gas_produced_pp/dt'
  []
  [mass_rate_gas_injection]
    type = ParsedFunction
    symbol_values = 'dt mass_gas_injected_pp'
    symbol_names = 'dt mass_gas_injected_pp'
    expression = 'mass_gas_injected_pp/dt'
  []
[]
[Postprocessors]
  [dt]
    type = TimestepSize
    outputs = 'none'
  []
  [heat_water_produced_pp]
    type = PorousFlowPlotQuantity
    uo = heat_water_produced
    outputs = csv
  []
  [heat_gas_produced_pp]
    type = PorousFlowPlotQuantity
    uo = heat_gas_produced
    outputs = csv
  []
  [mass_gas_injected_pp]
    type = PorousFlowPlotQuantity
    uo = mass_gas_injected
    outputs = csv
  []
  [mass_water_produced_pp]
    type = PorousFlowPlotQuantity
    uo = mass_water_produced
    outputs = csv
  []
  [mass_gas_produced_pp]
    type = PorousFlowPlotQuantity
    uo = mass_gas_produced
    outputs = csv
  []
  [mass_rate_water_production]
    type = FunctionValuePostprocessor
    function = mass_rate_water_production
    outputs = csv
  []
  [mass_rate_gas_production]
    type = FunctionValuePostprocessor
    function = mass_rate_gas_production
    outputs = csv
  []
  [mass_rate_gas_injection]
    type = FunctionValuePostprocessor
    function = mass_rate_gas_injection
    outputs = csv
  []
  [production_saturation_gas]
    type = PointValue
    point = ${production_point}
    variable = matrix_saturation_gas
    outputs = csv
  []
  [injection_saturation_gas]
    type = PointValue
    point = ${injection_point}
    variable = matrix_saturation_gas
    outputs = csv
  []
  [production_pressure_water]
    type = PointValue
    point = ${production_point}
    variable = matrix_pressure_water
    outputs = csv
  []
  [production_pressure_gas]
    type = PointValue
    point = ${production_point}
    variable = matrix_pressure_gas
    outputs = csv
  []
  [injection_pressure_gas]
    type = PointValue
    point = ${production_point}
    variable = matrix_pressure_gas
    outputs = csv
  []
  [injection_density_gas]
    type = PointValue
    point = ${injection_point}
    variable = matrix_density_gas
    outputs = csv
  []
  [injection_density_water]
    type = PointValue
    point = ${injection_point}
    variable = matrix_density_water
    outputs = csv
  []
  [injection_temperature]
    type = PointValue
    point = ${injection_point}
    variable = matrix_temperature
    outputs = csv
  []
  [injection_viscosity_water]
    type = PointValue
    point = ${injection_point}
    variable = matrix_viscosity_water
    outputs = csv
  []
  [injection_viscosity_gas]
    type = PointValue
    point = ${injection_point}
    variable = matrix_viscosity_gas
    outputs = csv
  []
  [injection_enthalpy_water]
    type = PointValue
    point = ${injection_point}
    variable = matrix_enthalpy_water
    outputs = csv
  []
  [injection_enthalpy_gas]
    type = PointValue
    point = ${injection_point}
    variable = matrix_enthalpy_gas
    outputs = csv
  []
[]
[VectorPostprocessors]
[]
[Preconditioning]
  active = preferred_but_might_not_be_installed
  [basic]
    type = SMP
    full = true
    petsc_options = '-ksp_diagonal_scale -ksp_diagonal_scale_fix'
    petsc_options_iname = '-pc_type -sub_pc_type -sub_pc_factor_shift_type -pc_asm_overlap'
    petsc_options_value = ' asm      lu           NONZERO                   2'
  []
  [preferred_but_might_not_be_installed]
    type = SMP
    full = true
    petsc_options = ''
    petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
    petsc_options_value = ' lu       mumps                       '
  []
[]
[Executioner]
  type = Transient
  solve_type = NEWTON
  end_time = ${simulation_time}
  nl_max_its = 15 # Maximum number of non-linear iterations
  l_max_its = 1000
  nl_abs_tol = 1e-6
  #automatic_scaling = true
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 1000
    growth_factor = 1.5
    cutback_factor = 0.5
  []
[]
[Outputs]
  print_linear_residuals = false
  checkpoint = true # Add checkpoint files for recovering simulation
  [out]
    type = Exodus
    sync_times = '0.000000e+00 8.640000e+05 1.728000e+06 2.592000e+06 3.456000e+06 4.320000e+06 5.184000e+06 6.048000e+06 6.912000e+06 7.776000e+06 8.640000e+06 9.504000e+06 1.036800e+07 1.123200e+07 1.209600e+07 1.296000e+07 1.382400e+07 1.468800e+07 1.555200e+07 1.641600e+07 1.728000e+07 1.814400e+07 1.900800e+07 1.987200e+07 2.073600e+07 2.160000e+07 2.246400e+07 2.332800e+07 2.419200e+07 2.505600e+07 2.592000e+07 2.678400e+07 2.764800e+07 2.851200e+07 2.937600e+07 3.024000e+07 3.110400e+07 3.196800e+07 3.283200e+07 3.369600e+07 3.456000e+07 3.542400e+07 3.628800e+07 3.715200e+07 3.801600e+07 3.888000e+07 3.974400e+07 4.060800e+07 4.147200e+07 4.233600e+07 4.320000e+07 4.406400e+07 4.492800e+07 4.579200e+07 4.665600e+07 4.752000e+07 4.838400e+07 4.924800e+07 5.011200e+07 5.097600e+07 5.184000e+07 5.270400e+07 5.356800e+07 5.443200e+07 5.529600e+07 5.616000e+07 5.702400e+07 5.788800e+07 5.875200e+07 5.961600e+07 6.048000e+07 6.134400e+07 6.220800e+07 6.307200e+07 6.393600e+07 6.480000e+07 6.566400e+07 6.652800e+07 6.739200e+07 6.825600e+07 6.912000e+07 6.998400e+07 7.084800e+07 7.171200e+07 7.257600e+07 7.344000e+07 7.430400e+07 7.516800e+07 7.603200e+07 7.689600e+07 7.776000e+07 7.862400e+07 7.948800e+07 8.035200e+07 8.121600e+07 8.208000e+07 8.294400e+07 8.380800e+07 8.467200e+07 8.553600e+07 8.640000e+07 8.726400e+07 8.812800e+07 8.899200e+07 8.985600e+07 9.072000e+07 9.158400e+07 9.244800e+07 9.331200e+07 9.417600e+07 9.504000e+07 9.590400e+07 9.676800e+07 9.763200e+07 9.849600e+07 9.936000e+07 1.002240e+08 1.010880e+08 1.019520e+08 1.028160e+08 1.036800e+08 1.045440e+08 1.054080e+08 1.062720e+08 1.071360e+08 1.080000e+08 1.088640e+08 1.097280e+08 1.105920e+08 1.114560e+08 1.123200e+08 1.131840e+08 1.140480e+08 1.149120e+08 1.157760e+08 1.166400e+08 1.175040e+08 1.183680e+08 1.192320e+08 1.200960e+08 1.209600e+08 1.218240e+08 1.226880e+08 1.235520e+08 1.244160e+08 1.252800e+08 1.261440e+08 1.270080e+08 1.278720e+08 1.287360e+08 1.296000e+08 1.304640e+08 1.313280e+08 1.321920e+08 1.330560e+08 1.339200e+08 1.347840e+08 1.356480e+08 1.365120e+08 1.373760e+08 1.382400e+08 1.391040e+08 1.399680e+08 1.408320e+08 1.416960e+08 1.425600e+08 1.434240e+08 1.442880e+08 1.451520e+08 1.460160e+08 1.468800e+08 1.477440e+08 1.486080e+08 1.494720e+08 1.503360e+08 1.512000e+08 1.520640e+08 1.529280e+08 1.537920e+08 1.546560e+08 1.555200e+08 1.563840e+08 1.572480e+08 1.581120e+08 1.589760e+08 1.598400e+08 1.607040e+08 1.615680e+08 1.624320e+08 1.632960e+08 1.641600e+08 1.650240e+08 1.658880e+08 1.667520e+08 1.676160e+08 1.684800e+08 1.693440e+08 1.702080e+08 1.710720e+08 1.719360e+08 1.728000e+08 1.736640e+08 1.745280e+08 1.753920e+08 1.762560e+08 1.771200e+08 1.779840e+08 1.788480e+08 1.797120e+08 1.805760e+08 1.814400e+08 1.823040e+08 1.831680e+08 1.840320e+08 1.848960e+08 1.857600e+08 1.866240e+08 1.874880e+08 1.883520e+08 1.892160e+08 1.900800e+08 1.909440e+08 1.918080e+08 1.926720e+08 1.935360e+08 1.944000e+08 1.952640e+08 1.961280e+08 1.969920e+08 1.978560e+08 1.987200e+08 1.995840e+08 2.004480e+08 2.013120e+08 2.021760e+08 2.030400e+08 2.039040e+08 2.047680e+08 2.056320e+08 2.064960e+08 2.073600e+08 2.082240e+08 2.090880e+08 2.099520e+08 2.108160e+08 2.116800e+08 2.125440e+08 2.134080e+08 2.142720e+08 2.151360e+08 2.160000e+08 2.168640e+08 2.177280e+08 2.185920e+08 2.194560e+08 2.203200e+08 2.211840e+08 2.220480e+08 2.229120e+08 2.237760e+08 2.246400e+08 2.255040e+08 2.263680e+08 2.272320e+08 2.280960e+08 2.289600e+08 2.298240e+08 2.306880e+08 2.315520e+08 2.324160e+08 2.332800e+08 2.341440e+08 2.350080e+08 2.358720e+08 2.367360e+08 2.376000e+08 2.384640e+08 2.393280e+08 2.401920e+08 2.410560e+08 2.419200e+08 2.427840e+08 2.436480e+08 2.445120e+08 2.453760e+08 2.462400e+08 2.471040e+08 2.479680e+08 2.488320e+08 2.496960e+08 2.505600e+08 2.514240e+08 2.522880e+08 2.531520e+08 2.540160e+08 2.548800e+08 2.557440e+08 2.566080e+08 2.574720e+08 2.583360e+08 2.592000e+08 2.600640e+08 2.609280e+08 2.617920e+08 2.626560e+08 2.635200e+08 2.643840e+08 2.652480e+08 2.661120e+08 2.669760e+08 2.678400e+08 2.687040e+08 2.695680e+08 2.704320e+08 2.712960e+08 2.721600e+08 2.730240e+08 2.738880e+08 2.747520e+08 2.756160e+08 2.764800e+08 2.773440e+08 2.782080e+08 2.790720e+08 2.799360e+08 2.808000e+08 2.816640e+08 2.825280e+08 2.833920e+08 2.842560e+08 2.851200e+08 2.859840e+08 2.868480e+08 2.877120e+08 2.885760e+08 2.894400e+08 2.903040e+08 2.911680e+08 2.920320e+08 2.928960e+08 2.937600e+08 2.946240e+08 2.954880e+08 2.963520e+08 2.972160e+08 2.980800e+08 2.989440e+08 2.998080e+08 3.006720e+08 3.015360e+08 3.024000e+08 3.032640e+08 3.041280e+08 3.049920e+08 3.058560e+08 3.067200e+08 3.075840e+08 3.084480e+08 3.093120e+08 3.101760e+08 3.110400e+08 3.119040e+08 3.127680e+08 3.136320e+08 3.144960e+08 3.153600e+08 3.162240e+08 3.170880e+08 3.179520e+08 3.188160e+08 3.196800e+08 3.205440e+08 3.214080e+08 3.222720e+08 3.231360e+08 3.240000e+08 3.248640e+08 3.257280e+08 3.265920e+08 3.274560e+08 3.283200e+08 3.291840e+08 3.300480e+08 3.309120e+08 3.317760e+08 3.326400e+08 3.335040e+08 3.343680e+08 3.352320e+08 3.360960e+08 3.369600e+08 3.378240e+08 3.386880e+08 3.395520e+08 3.404160e+08 3.412800e+08 3.421440e+08 3.430080e+08 3.438720e+08 3.447360e+08 3.456000e+08 3.464640e+08 3.473280e+08 3.481920e+08 3.490560e+08 3.499200e+08 3.507840e+08 3.516480e+08 3.525120e+08 3.533760e+08 3.542400e+08 3.551040e+08 3.559680e+08 3.568320e+08 3.576960e+08 3.585600e+08 3.594240e+08 3.602880e+08 3.611520e+08 3.620160e+08 3.628800e+08 3.637440e+08 3.646080e+08 3.654720e+08 3.663360e+08 3.672000e+08 3.680640e+08 3.689280e+08 3.697920e+08 3.706560e+08 3.715200e+08 3.723840e+08 3.732480e+08 3.741120e+08 3.749760e+08 3.758400e+08 3.767040e+08 3.775680e+08 3.784320e+08 3.792960e+08 3.801600e+08 3.810240e+08 3.818880e+08 3.827520e+08 3.836160e+08 3.844800e+08 3.853440e+08 3.862080e+08 3.870720e+08 3.879360e+08 3.888000e+08 3.896640e+08 3.905280e+08 3.913920e+08 3.922560e+08 3.931200e+08 3.939840e+08 3.948480e+08 3.957120e+08 3.965760e+08 3.974400e+08 3.983040e+08 3.991680e+08 4.000320e+08 4.008960e+08 4.017600e+08 4.026240e+08 4.034880e+08 4.043520e+08 4.052160e+08 4.060800e+08 4.069440e+08 4.078080e+08 4.086720e+08 4.095360e+08 4.104000e+08 4.112640e+08 4.121280e+08 4.129920e+08 4.138560e+08 4.147200e+08 4.155840e+08 4.164480e+08 4.173120e+08 4.181760e+08 4.190400e+08 4.199040e+08 4.207680e+08 4.216320e+08 4.224960e+08 4.233600e+08 4.242240e+08 4.250880e+08 4.259520e+08 4.268160e+08 4.276800e+08 4.285440e+08 4.294080e+08 4.302720e+08 4.311360e+08 4.320000e+08 4.328640e+08 4.337280e+08 4.345920e+08 4.354560e+08 4.363200e+08 4.371840e+08 4.380480e+08 4.389120e+08 4.397760e+08 4.406400e+08 4.415040e+08 4.423680e+08 4.432320e+08 4.440960e+08 4.449600e+08 4.458240e+08 4.466880e+08 4.475520e+08 4.484160e+08 4.492800e+08 4.501440e+08 4.510080e+08 4.518720e+08 4.527360e+08 4.536000e+08 4.544640e+08 4.553280e+08 4.561920e+08 4.570560e+08 4.579200e+08 4.587840e+08 4.596480e+08 4.605120e+08 4.613760e+08 4.622400e+08 4.631040e+08 4.639680e+08 4.648320e+08 4.656960e+08 4.665600e+08 4.674240e+08 4.682880e+08 4.691520e+08 4.700160e+08 4.708800e+08 4.717440e+08 4.726080e+08 4.734720e+08 4.743360e+08 4.752000e+08 4.760640e+08 4.769280e+08 4.777920e+08 4.786560e+08 4.795200e+08 4.803840e+08 4.812480e+08 4.821120e+08 4.829760e+08 4.838400e+08 4.847040e+08 4.855680e+08 4.864320e+08 4.872960e+08 4.881600e+08 4.890240e+08 4.898880e+08 4.907520e+08 4.916160e+08 4.924800e+08 4.933440e+08 4.942080e+08 4.950720e+08 4.959360e+08 4.968000e+08 4.976640e+08 4.985280e+08 4.993920e+08 5.002560e+08 5.011200e+08 5.019840e+08 5.028480e+08 5.037120e+08 5.045760e+08 5.054400e+08 5.063040e+08 5.071680e+08 5.080320e+08 5.088960e+08 5.097600e+08 5.106240e+08 5.114880e+08 5.123520e+08 5.132160e+08 5.140800e+08 5.149440e+08 5.158080e+08 5.166720e+08 5.175360e+08 5.184000e+08 5.192640e+08 5.201280e+08 5.209920e+08 5.218560e+08 5.227200e+08 5.235840e+08 5.244480e+08 5.253120e+08 5.261760e+08 5.270400e+08 5.279040e+08 5.287680e+08 5.296320e+08 5.304960e+08 5.313600e+08 5.322240e+08 5.330880e+08 5.339520e+08 5.348160e+08 5.356800e+08 5.365440e+08 5.374080e+08 5.382720e+08 5.391360e+08 5.400000e+08 5.408640e+08 5.417280e+08 5.425920e+08 5.434560e+08 5.443200e+08 5.451840e+08 5.460480e+08 5.469120e+08 5.477760e+08 5.486400e+08 5.495040e+08 5.503680e+08 5.512320e+08 5.520960e+08 5.529600e+08 5.538240e+08 5.546880e+08 5.555520e+08 5.564160e+08 5.572800e+08 5.581440e+08 5.590080e+08 5.598720e+08 5.607360e+08 5.616000e+08 5.624640e+08 5.633280e+08 5.641920e+08 5.650560e+08 5.659200e+08 5.667840e+08 5.676480e+08 5.685120e+08 5.693760e+08 5.702400e+08 5.711040e+08 5.719680e+08 5.728320e+08 5.736960e+08 5.745600e+08 5.754240e+08 5.762880e+08 5.771520e+08 5.780160e+08 5.788800e+08 5.797440e+08 5.806080e+08 5.814720e+08 5.823360e+08 5.832000e+08 5.840640e+08 5.849280e+08 5.857920e+08 5.866560e+08 5.875200e+08 5.883840e+08 5.892480e+08 5.901120e+08 5.909760e+08 5.918400e+08 5.927040e+08 5.935680e+08 5.944320e+08 5.952960e+08 5.961600e+08 5.970240e+08 5.978880e+08 5.987520e+08 5.996160e+08 6.004800e+08 6.013440e+08 6.022080e+08 6.030720e+08 6.039360e+08 6.048000e+08 6.056640e+08 6.065280e+08 6.073920e+08 6.082560e+08 6.091200e+08 6.099840e+08 6.108480e+08 6.117120e+08 6.125760e+08 6.134400e+08 6.143040e+08 6.151680e+08 6.160320e+08 6.168960e+08 6.177600e+08 6.186240e+08 6.194880e+08 6.203520e+08 6.212160e+08 6.220800e+08 6.229440e+08 6.238080e+08 6.246720e+08 6.255360e+08 6.264000e+08 6.272640e+08 6.281280e+08 6.289920e+08 6.298560e+08 6.307200e+08 6.315840e+08 6.324480e+08 6.333120e+08 6.341760e+08 6.350400e+08 6.359040e+08 6.367680e+08 6.376320e+08 6.384960e+08 6.393600e+08 6.402240e+08 6.410880e+08 6.419520e+08 6.428160e+08 6.436800e+08 6.445440e+08 6.454080e+08 6.462720e+08 6.471360e+08 6.480000e+08 6.488640e+08 6.497280e+08 6.505920e+08 6.514560e+08 6.523200e+08 6.531840e+08 6.540480e+08 6.549120e+08 6.557760e+08 6.566400e+08 6.575040e+08 6.583680e+08 6.592320e+08 6.600960e+08 6.609600e+08 6.618240e+08 6.626880e+08 6.635520e+08 6.644160e+08 6.652800e+08 6.661440e+08 6.670080e+08 6.678720e+08 6.687360e+08 6.696000e+08 6.704640e+08 6.713280e+08 6.721920e+08 6.730560e+08 6.739200e+08 6.747840e+08 6.756480e+08 6.765120e+08 6.773760e+08 6.782400e+08 6.791040e+08 6.799680e+08 6.808320e+08 6.816960e+08 6.825600e+08 6.834240e+08 6.842880e+08 6.851520e+08 6.860160e+08 6.868800e+08 6.877440e+08 6.886080e+08 6.894720e+08 6.903360e+08 6.912000e+08 6.920640e+08 6.929280e+08 6.937920e+08 6.946560e+08 6.955200e+08 6.963840e+08 6.972480e+08 6.981120e+08 6.989760e+08 6.998400e+08 7.007040e+08 7.015680e+08 7.024320e+08 7.032960e+08 7.041600e+08 7.050240e+08 7.058880e+08 7.067520e+08 7.076160e+08 7.084800e+08 7.093440e+08 7.102080e+08 7.110720e+08 7.119360e+08 7.128000e+08 7.136640e+08 7.145280e+08 7.153920e+08 7.162560e+08 7.171200e+08 7.179840e+08 7.188480e+08 7.197120e+08 7.205760e+08 7.214400e+08 7.223040e+08 7.231680e+08 7.240320e+08 7.248960e+08 7.257600e+08 7.266240e+08 7.274880e+08 7.283520e+08 7.292160e+08 7.300800e+08 7.309440e+08 7.318080e+08 7.326720e+08 7.335360e+08 7.344000e+08 7.352640e+08 7.361280e+08 7.369920e+08 7.378560e+08 7.387200e+08 7.395840e+08 7.404480e+08 7.413120e+08 7.421760e+08 7.430400e+08 7.439040e+08 7.447680e+08 7.456320e+08 7.464960e+08 7.473600e+08 7.482240e+08 7.490880e+08 7.499520e+08 7.508160e+08 7.516800e+08 7.525440e+08 7.534080e+08 7.542720e+08 7.551360e+08 7.560000e+08 7.568640e+08 7.577280e+08 7.585920e+08 7.594560e+08 7.603200e+08 7.611840e+08 7.620480e+08 7.629120e+08 7.637760e+08 7.646400e+08 7.655040e+08 7.663680e+08 7.672320e+08 7.680960e+08 7.689600e+08 7.698240e+08 7.706880e+08 7.715520e+08 7.724160e+08 7.732800e+08 7.741440e+08 7.750080e+08 7.758720e+08 7.767360e+08 7.776000e+08 7.784640e+08 7.793280e+08 7.801920e+08 7.810560e+08 7.819200e+08 7.827840e+08 7.836480e+08 7.845120e+08 7.853760e+08 7.862400e+08 7.871040e+08 7.879680e+08 7.888320e+08 7.896960e+08 7.905600e+08 7.914240e+08 7.922880e+08 7.931520e+08 7.940160e+08 7.948800e+08 7.957440e+08 7.966080e+08 7.974720e+08 7.983360e+08 7.992000e+08 8.000640e+08 8.009280e+08 8.017920e+08 8.026560e+08 8.035200e+08 8.043840e+08 8.052480e+08 8.061120e+08 8.069760e+08 8.078400e+08 8.087040e+08 8.095680e+08 8.104320e+08 8.112960e+08 8.121600e+08 8.130240e+08 8.138880e+08 8.147520e+08 8.156160e+08 8.164800e+08 8.173440e+08 8.182080e+08 8.190720e+08 8.199360e+08 8.208000e+08 8.216640e+08 8.225280e+08 8.233920e+08 8.242560e+08 8.251200e+08 8.259840e+08 8.268480e+08 8.277120e+08 8.285760e+08 8.294400e+08 8.303040e+08 8.311680e+08 8.320320e+08 8.328960e+08 8.337600e+08 8.346240e+08 8.354880e+08 8.363520e+08 8.372160e+08 8.380800e+08 8.389440e+08 8.398080e+08 8.406720e+08 8.415360e+08 8.424000e+08 8.432640e+08 8.441280e+08 8.449920e+08 8.458560e+08 8.467200e+08 8.475840e+08 8.484480e+08 8.493120e+08 8.501760e+08 8.510400e+08 8.519040e+08 8.527680e+08 8.536320e+08 8.544960e+08 8.553600e+08 8.562240e+08 8.570880e+08 8.579520e+08 8.588160e+08 8.596800e+08 8.605440e+08 8.614080e+08 8.622720e+08 8.631360e+08 8.640000e+08 8.648640e+08 8.657280e+08 8.665920e+08 8.674560e+08 8.683200e+08 8.691840e+08 8.700480e+08 8.709120e+08 8.717760e+08 8.726400e+08 8.735040e+08 8.743680e+08 8.752320e+08 8.760960e+08 8.769600e+08 8.778240e+08 8.786880e+08 8.795520e+08 8.804160e+08 8.812800e+08 8.821440e+08 8.830080e+08 8.838720e+08 8.847360e+08 8.856000e+08 8.864640e+08 8.873280e+08 8.881920e+08 8.890560e+08 8.899200e+08 8.907840e+08 8.916480e+08 8.925120e+08 8.933760e+08 8.942400e+08 8.951040e+08 8.959680e+08 8.968320e+08 8.976960e+08 8.985600e+08 8.994240e+08 9.002880e+08 9.011520e+08 9.020160e+08 9.028800e+08 9.037440e+08 9.046080e+08 9.054720e+08 9.063360e+08 9.072000e+08 9.080640e+08 9.089280e+08 9.097920e+08 9.106560e+08 9.115200e+08 9.123840e+08 9.132480e+08 9.141120e+08 9.149760e+08 9.158400e+08 9.167040e+08 9.175680e+08 9.184320e+08 9.192960e+08 9.201600e+08 9.210240e+08 9.218880e+08 9.227520e+08 9.236160e+08 9.244800e+08 9.253440e+08 9.262080e+08 9.270720e+08 9.279360e+08 9.288000e+08 9.296640e+08 9.305280e+08 9.313920e+08 9.322560e+08 9.331200e+08 9.339840e+08 9.348480e+08 9.357120e+08 9.365760e+08 9.374400e+08 9.383040e+08 9.391680e+08 9.400320e+08 9.408960e+08 9.417600e+08 9.426240e+08 9.434880e+08 9.443520e+08 9.452160e+08 9.460800e+08 9.469440e+08 9.478080e+08 9.486720e+08 9.495360e+08 9.504000e+08 9.512640e+08 9.521280e+08 9.529920e+08 9.538560e+08 9.547200e+08 9.555840e+08 9.564480e+08 9.573120e+08 9.581760e+08 9.590400e+08 9.599040e+08 9.607680e+08 9.616320e+08 9.624960e+08 9.633600e+08 9.642240e+08 9.650880e+08 9.659520e+08 9.668160e+08 9.676800e+08 9.685440e+08 9.694080e+08 9.702720e+08 9.711360e+08 9.720000e+08 9.728640e+08 9.737280e+08 9.745920e+08 9.754560e+08 9.763200e+08 9.771840e+08 9.780480e+08 9.789120e+08 9.797760e+08 9.806400e+08 9.815040e+08 9.823680e+08 9.832320e+08 9.840960e+08 9.849600e+08 9.858240e+08 9.866880e+08 9.875520e+08 9.884160e+08 9.892800e+08 9.901440e+08 9.910080e+08 9.918720e+08 9.927360e+08 9.936000e+08 9.944640e+08 9.953280e+08 9.961920e+08 9.970560e+08 9.979200e+08 9.987840e+08 9.996480e+08 1.000512e+09 1.001376e+09 1.002240e+09 1.003104e+09 1.003968e+09 1.004832e+09 1.005696e+09 1.006560e+09 1.007424e+09 1.008288e+09 1.009152e+09 1.010016e+09 1.010880e+09 1.011744e+09 1.012608e+09 1.013472e+09 1.014336e+09 1.015200e+09 1.016064e+09 1.016928e+09 1.017792e+09 1.018656e+09 1.019520e+09 1.020384e+09 1.021248e+09 1.022112e+09 1.022976e+09 1.023840e+09 1.024704e+09 1.025568e+09 1.026432e+09 1.027296e+09 1.028160e+09 1.029024e+09 1.029888e+09 1.030752e+09 1.031616e+09 1.032480e+09 1.033344e+09 1.034208e+09 1.035072e+09 1.035936e+09 1.036800e+09 1.037664e+09 1.038528e+09 1.039392e+09 1.040256e+09 1.041120e+09 1.041984e+09 1.042848e+09 1.043712e+09 1.044576e+09 1.045440e+09 1.046304e+09 1.047168e+09 1.048032e+09 1.048896e+09 1.049760e+09 1.050624e+09 1.051488e+09 1.052352e+09 1.053216e+09 1.054080e+09 1.054944e+09 1.055808e+09 1.056672e+09 1.057536e+09 1.058400e+09 1.059264e+09 1.060128e+09 1.060992e+09 1.061856e+09 1.062720e+09 1.063584e+09 1.064448e+09 1.065312e+09 1.066176e+09 1.067040e+09 1.067904e+09 1.068768e+09 1.069632e+09 1.070496e+09 1.071360e+09 1.072224e+09 1.073088e+09 1.073952e+09 1.074816e+09 1.075680e+09 1.076544e+09 1.077408e+09 1.078272e+09 1.079136e+09 1.080000e+09 1.080864e+09 1.081728e+09 1.082592e+09 1.083456e+09 1.084320e+09 1.085184e+09 1.086048e+09 1.086912e+09 1.087776e+09 1.088640e+09 1.089504e+09 1.090368e+09 1.091232e+09 1.092096e+09 1.092960e+09 1.093824e+09 1.094688e+09 1.095552e+09 1.096416e+09 1.097280e+09 1.098144e+09 1.099008e+09 1.099872e+09 1.100736e+09 1.101600e+09 1.102464e+09 1.103328e+09 1.104192e+09 1.105056e+09 1.105920e+09 1.106784e+09 1.107648e+09 1.108512e+09 1.109376e+09 1.110240e+09 1.111104e+09 1.111968e+09 1.112832e+09 1.113696e+09 1.114560e+09 1.115424e+09 1.116288e+09 1.117152e+09 1.118016e+09 1.118880e+09 1.119744e+09 1.120608e+09 1.121472e+09 1.122336e+09 1.123200e+09 1.124064e+09 1.124928e+09 1.125792e+09 1.126656e+09 1.127520e+09 1.128384e+09 1.129248e+09 1.130112e+09 1.130976e+09 1.131840e+09 1.132704e+09 1.133568e+09 1.134432e+09 1.135296e+09 1.136160e+09 1.137024e+09 1.137888e+09 1.138752e+09 1.139616e+09 1.140480e+09 1.141344e+09 1.142208e+09 1.143072e+09 1.143936e+09 1.144800e+09 1.145664e+09 1.146528e+09 1.147392e+09 1.148256e+09 1.149120e+09 1.149984e+09 1.150848e+09 1.151712e+09 1.152576e+09 1.153440e+09 1.154304e+09 1.155168e+09 1.156032e+09 1.156896e+09 1.157760e+09 1.158624e+09 1.159488e+09 1.160352e+09 1.161216e+09 1.162080e+09 1.162944e+09 1.163808e+09 1.164672e+09 1.165536e+09 1.166400e+09 1.167264e+09 1.168128e+09 1.168992e+09 1.169856e+09 1.170720e+09 1.171584e+09 1.172448e+09 1.173312e+09 1.174176e+09 1.175040e+09 1.175904e+09 1.176768e+09 1.177632e+09 1.178496e+09 1.179360e+09 1.180224e+09 1.181088e+09 1.181952e+09 1.182816e+09 1.183680e+09 1.184544e+09 1.185408e+09 1.186272e+09 1.187136e+09 1.188000e+09 1.188864e+09 1.189728e+09 1.190592e+09 1.191456e+09 1.192320e+09 1.193184e+09 1.194048e+09 1.194912e+09 1.195776e+09 1.196640e+09 1.197504e+09 1.198368e+09 1.199232e+09 1.200096e+09 1.200960e+09 1.201824e+09 1.202688e+09 1.203552e+09 1.204416e+09 1.205280e+09 1.206144e+09 1.207008e+09 1.207872e+09 1.208736e+09 1.209600e+09 1.210464e+09 1.211328e+09 1.212192e+09 1.213056e+09 1.213920e+09 1.214784e+09 1.215648e+09 1.216512e+09 1.217376e+09 1.218240e+09 1.219104e+09 1.219968e+09 1.220832e+09 1.221696e+09 1.222560e+09 1.223424e+09 1.224288e+09 1.225152e+09 1.226016e+09 1.226880e+09 1.227744e+09 1.228608e+09 1.229472e+09 1.230336e+09 1.231200e+09 1.232064e+09 1.232928e+09 1.233792e+09 1.234656e+09 1.235520e+09 1.236384e+09 1.237248e+09 1.238112e+09 1.238976e+09 1.239840e+09 1.240704e+09 1.241568e+09 1.242432e+09 1.243296e+09 1.244160e+09 1.245024e+09 1.245888e+09 1.246752e+09 1.247616e+09 1.248480e+09 1.249344e+09 1.250208e+09 1.251072e+09 1.251936e+09 1.252800e+09 1.253664e+09 1.254528e+09 1.255392e+09 1.256256e+09 1.257120e+09 1.257984e+09 1.258848e+09 1.259712e+09 1.260576e+09 1.261440e+09 1.262304e+09 1.263168e+09 1.264032e+09 1.264896e+09 1.265760e+09 1.266624e+09 1.267488e+09 1.268352e+09 1.269216e+09 1.270080e+09 1.270944e+09 1.271808e+09 1.272672e+09 1.273536e+09 1.274400e+09 1.275264e+09 1.276128e+09 1.276992e+09 1.277856e+09 1.278720e+09 1.279584e+09 1.280448e+09 1.281312e+09 1.282176e+09 1.283040e+09 1.283904e+09 1.284768e+09 1.285632e+09 1.286496e+09 1.287360e+09 1.288224e+09 1.289088e+09 1.289952e+09 1.290816e+09 1.291680e+09 1.292544e+09 1.293408e+09 1.294272e+09 1.295136e+09 1.296000e+09 1.296864e+09 1.297728e+09 1.298592e+09 1.299456e+09 1.300320e+09 1.301184e+09 1.302048e+09 1.302912e+09 1.303776e+09 1.304640e+09 1.305504e+09 1.306368e+09 1.307232e+09 1.308096e+09 1.308960e+09 1.309824e+09 1.310688e+09 1.311552e+09 1.312416e+09 1.313280e+09 1.314144e+09 1.315008e+09 1.315872e+09 1.316736e+09 1.317600e+09 1.318464e+09 1.319328e+09 1.320192e+09 1.321056e+09 1.321920e+09 1.322784e+09 1.323648e+09 1.324512e+09 1.325376e+09 1.326240e+09 1.327104e+09 1.327968e+09 1.328832e+09 1.329696e+09 1.330560e+09 1.331424e+09 1.332288e+09 1.333152e+09 1.334016e+09 1.334880e+09 1.335744e+09 1.336608e+09 1.337472e+09 1.338336e+09 1.339200e+09 1.340064e+09 1.340928e+09 1.341792e+09 1.342656e+09 1.343520e+09 1.344384e+09 1.345248e+09 1.346112e+09 1.346976e+09 1.347840e+09 1.348704e+09 1.349568e+09 1.350432e+09 1.351296e+09 1.352160e+09 1.353024e+09 1.353888e+09 1.354752e+09 1.355616e+09 1.356480e+09 1.357344e+09 1.358208e+09 1.359072e+09 1.359936e+09 1.360800e+09 1.361664e+09 1.362528e+09 1.363392e+09 1.364256e+09 1.365120e+09 1.365984e+09 1.366848e+09 1.367712e+09 1.368576e+09 1.369440e+09 1.370304e+09 1.371168e+09 1.372032e+09 1.372896e+09 1.373760e+09 1.374624e+09 1.375488e+09 1.376352e+09 1.377216e+09 1.378080e+09 1.378944e+09 1.379808e+09 1.380672e+09 1.381536e+09 1.382400e+09 1.383264e+09 1.384128e+09 1.384992e+09 1.385856e+09 1.386720e+09 1.387584e+09 1.388448e+09 1.389312e+09 1.390176e+09 1.391040e+09 1.391904e+09 1.392768e+09 1.393632e+09 1.394496e+09 1.395360e+09 1.396224e+09 1.397088e+09 1.397952e+09 1.398816e+09 1.399680e+09 1.400544e+09 1.401408e+09 1.402272e+09 1.403136e+09 1.404000e+09 1.404864e+09 1.405728e+09 1.406592e+09 1.407456e+09 1.408320e+09 1.409184e+09 1.410048e+09 1.410912e+09 1.411776e+09 1.412640e+09 1.413504e+09 1.414368e+09 1.415232e+09 1.416096e+09 1.416960e+09 1.417824e+09 1.418688e+09 1.419552e+09 1.420416e+09 1.421280e+09 1.422144e+09 1.423008e+09 1.423872e+09 1.424736e+09 1.425600e+09 1.426464e+09 1.427328e+09 1.428192e+09 1.429056e+09 1.429920e+09 1.430784e+09 1.431648e+09 1.432512e+09 1.433376e+09 1.434240e+09 1.435104e+09 1.435968e+09 1.436832e+09 1.437696e+09 1.438560e+09 1.439424e+09 1.440288e+09 1.441152e+09 1.442016e+09 1.442880e+09 1.443744e+09 1.444608e+09 1.445472e+09 1.446336e+09 1.447200e+09 1.448064e+09 1.448928e+09 1.449792e+09 1.450656e+09 1.451520e+09 1.452384e+09 1.453248e+09 1.454112e+09 1.454976e+09 1.455840e+09 1.456704e+09 1.457568e+09 1.458432e+09 1.459296e+09 1.460160e+09 1.461024e+09 1.461888e+09 1.462752e+09 1.463616e+09 1.464480e+09 1.465344e+09 1.466208e+09 1.467072e+09 1.467936e+09 1.468800e+09 1.469664e+09 1.470528e+09 1.471392e+09 1.472256e+09 1.473120e+09 1.473984e+09 1.474848e+09 1.475712e+09 1.476576e+09 1.477440e+09 1.478304e+09 1.479168e+09 1.480032e+09 1.480896e+09 1.481760e+09 1.482624e+09 1.483488e+09 1.484352e+09 1.485216e+09 1.486080e+09 1.486944e+09 1.487808e+09 1.488672e+09 1.489536e+09 1.490400e+09 1.491264e+09 1.492128e+09 1.492992e+09 1.493856e+09 1.494720e+09 1.495584e+09 1.496448e+09 1.497312e+09 1.498176e+09 1.499040e+09 1.499904e+09 1.500768e+09 1.501632e+09 1.502496e+09 1.503360e+09 1.504224e+09 1.505088e+09 1.505952e+09 1.506816e+09 1.507680e+09 1.508544e+09 1.509408e+09 1.510272e+09 1.511136e+09 1.512000e+09 1.512864e+09 1.513728e+09 1.514592e+09 1.515456e+09 1.516320e+09 1.517184e+09 1.518048e+09 1.518912e+09 1.519776e+09 1.520640e+09 1.521504e+09 1.522368e+09 1.523232e+09 1.524096e+09 1.524960e+09 1.525824e+09 1.526688e+09 1.527552e+09 1.528416e+09 1.529280e+09 1.530144e+09 1.531008e+09 1.531872e+09 1.532736e+09 1.533600e+09 1.534464e+09 1.535328e+09 1.536192e+09 1.537056e+09 1.537920e+09 1.538784e+09 1.539648e+09 1.540512e+09 1.541376e+09 1.542240e+09 1.543104e+09 1.543968e+09 1.544832e+09 1.545696e+09 1.546560e+09 1.547424e+09 1.548288e+09 1.549152e+09 1.550016e+09 1.550880e+09 1.551744e+09 1.552608e+09 1.553472e+09 1.554336e+09 1.555200e+09 1.556064e+09 1.556928e+09 1.557792e+09 1.558656e+09 1.559520e+09 1.560384e+09 1.561248e+09 1.562112e+09 1.562976e+09 1.563840e+09 1.564704e+09 1.565568e+09 1.566432e+09 1.567296e+09 1.568160e+09 1.569024e+09 1.569888e+09 1.570752e+09 1.571616e+09 1.572480e+09 1.573344e+09 1.574208e+09 1.575072e+09 1.575936e+09'
    sync_only = ${output_only_selected_timesteps}
  []
  [csv]
    type = CSV
    sync_times = '0.000000e+00 8.640000e+05 1.728000e+06 2.592000e+06 3.456000e+06 4.320000e+06 5.184000e+06 6.048000e+06 6.912000e+06 7.776000e+06 8.640000e+06 9.504000e+06 1.036800e+07 1.123200e+07 1.209600e+07 1.296000e+07 1.382400e+07 1.468800e+07 1.555200e+07 1.641600e+07 1.728000e+07 1.814400e+07 1.900800e+07 1.987200e+07 2.073600e+07 2.160000e+07 2.246400e+07 2.332800e+07 2.419200e+07 2.505600e+07 2.592000e+07 2.678400e+07 2.764800e+07 2.851200e+07 2.937600e+07 3.024000e+07 3.110400e+07 3.196800e+07 3.283200e+07 3.369600e+07 3.456000e+07 3.542400e+07 3.628800e+07 3.715200e+07 3.801600e+07 3.888000e+07 3.974400e+07 4.060800e+07 4.147200e+07 4.233600e+07 4.320000e+07 4.406400e+07 4.492800e+07 4.579200e+07 4.665600e+07 4.752000e+07 4.838400e+07 4.924800e+07 5.011200e+07 5.097600e+07 5.184000e+07 5.270400e+07 5.356800e+07 5.443200e+07 5.529600e+07 5.616000e+07 5.702400e+07 5.788800e+07 5.875200e+07 5.961600e+07 6.048000e+07 6.134400e+07 6.220800e+07 6.307200e+07 6.393600e+07 6.480000e+07 6.566400e+07 6.652800e+07 6.739200e+07 6.825600e+07 6.912000e+07 6.998400e+07 7.084800e+07 7.171200e+07 7.257600e+07 7.344000e+07 7.430400e+07 7.516800e+07 7.603200e+07 7.689600e+07 7.776000e+07 7.862400e+07 7.948800e+07 8.035200e+07 8.121600e+07 8.208000e+07 8.294400e+07 8.380800e+07 8.467200e+07 8.553600e+07 8.640000e+07 8.726400e+07 8.812800e+07 8.899200e+07 8.985600e+07 9.072000e+07 9.158400e+07 9.244800e+07 9.331200e+07 9.417600e+07 9.504000e+07 9.590400e+07 9.676800e+07 9.763200e+07 9.849600e+07 9.936000e+07 1.002240e+08 1.010880e+08 1.019520e+08 1.028160e+08 1.036800e+08 1.045440e+08 1.054080e+08 1.062720e+08 1.071360e+08 1.080000e+08 1.088640e+08 1.097280e+08 1.105920e+08 1.114560e+08 1.123200e+08 1.131840e+08 1.140480e+08 1.149120e+08 1.157760e+08 1.166400e+08 1.175040e+08 1.183680e+08 1.192320e+08 1.200960e+08 1.209600e+08 1.218240e+08 1.226880e+08 1.235520e+08 1.244160e+08 1.252800e+08 1.261440e+08 1.270080e+08 1.278720e+08 1.287360e+08 1.296000e+08 1.304640e+08 1.313280e+08 1.321920e+08 1.330560e+08 1.339200e+08 1.347840e+08 1.356480e+08 1.365120e+08 1.373760e+08 1.382400e+08 1.391040e+08 1.399680e+08 1.408320e+08 1.416960e+08 1.425600e+08 1.434240e+08 1.442880e+08 1.451520e+08 1.460160e+08 1.468800e+08 1.477440e+08 1.486080e+08 1.494720e+08 1.503360e+08 1.512000e+08 1.520640e+08 1.529280e+08 1.537920e+08 1.546560e+08 1.555200e+08 1.563840e+08 1.572480e+08 1.581120e+08 1.589760e+08 1.598400e+08 1.607040e+08 1.615680e+08 1.624320e+08 1.632960e+08 1.641600e+08 1.650240e+08 1.658880e+08 1.667520e+08 1.676160e+08 1.684800e+08 1.693440e+08 1.702080e+08 1.710720e+08 1.719360e+08 1.728000e+08 1.736640e+08 1.745280e+08 1.753920e+08 1.762560e+08 1.771200e+08 1.779840e+08 1.788480e+08 1.797120e+08 1.805760e+08 1.814400e+08 1.823040e+08 1.831680e+08 1.840320e+08 1.848960e+08 1.857600e+08 1.866240e+08 1.874880e+08 1.883520e+08 1.892160e+08 1.900800e+08 1.909440e+08 1.918080e+08 1.926720e+08 1.935360e+08 1.944000e+08 1.952640e+08 1.961280e+08 1.969920e+08 1.978560e+08 1.987200e+08 1.995840e+08 2.004480e+08 2.013120e+08 2.021760e+08 2.030400e+08 2.039040e+08 2.047680e+08 2.056320e+08 2.064960e+08 2.073600e+08 2.082240e+08 2.090880e+08 2.099520e+08 2.108160e+08 2.116800e+08 2.125440e+08 2.134080e+08 2.142720e+08 2.151360e+08 2.160000e+08 2.168640e+08 2.177280e+08 2.185920e+08 2.194560e+08 2.203200e+08 2.211840e+08 2.220480e+08 2.229120e+08 2.237760e+08 2.246400e+08 2.255040e+08 2.263680e+08 2.272320e+08 2.280960e+08 2.289600e+08 2.298240e+08 2.306880e+08 2.315520e+08 2.324160e+08 2.332800e+08 2.341440e+08 2.350080e+08 2.358720e+08 2.367360e+08 2.376000e+08 2.384640e+08 2.393280e+08 2.401920e+08 2.410560e+08 2.419200e+08 2.427840e+08 2.436480e+08 2.445120e+08 2.453760e+08 2.462400e+08 2.471040e+08 2.479680e+08 2.488320e+08 2.496960e+08 2.505600e+08 2.514240e+08 2.522880e+08 2.531520e+08 2.540160e+08 2.548800e+08 2.557440e+08 2.566080e+08 2.574720e+08 2.583360e+08 2.592000e+08 2.600640e+08 2.609280e+08 2.617920e+08 2.626560e+08 2.635200e+08 2.643840e+08 2.652480e+08 2.661120e+08 2.669760e+08 2.678400e+08 2.687040e+08 2.695680e+08 2.704320e+08 2.712960e+08 2.721600e+08 2.730240e+08 2.738880e+08 2.747520e+08 2.756160e+08 2.764800e+08 2.773440e+08 2.782080e+08 2.790720e+08 2.799360e+08 2.808000e+08 2.816640e+08 2.825280e+08 2.833920e+08 2.842560e+08 2.851200e+08 2.859840e+08 2.868480e+08 2.877120e+08 2.885760e+08 2.894400e+08 2.903040e+08 2.911680e+08 2.920320e+08 2.928960e+08 2.937600e+08 2.946240e+08 2.954880e+08 2.963520e+08 2.972160e+08 2.980800e+08 2.989440e+08 2.998080e+08 3.006720e+08 3.015360e+08 3.024000e+08 3.032640e+08 3.041280e+08 3.049920e+08 3.058560e+08 3.067200e+08 3.075840e+08 3.084480e+08 3.093120e+08 3.101760e+08 3.110400e+08 3.119040e+08 3.127680e+08 3.136320e+08 3.144960e+08 3.153600e+08 3.162240e+08 3.170880e+08 3.179520e+08 3.188160e+08 3.196800e+08 3.205440e+08 3.214080e+08 3.222720e+08 3.231360e+08 3.240000e+08 3.248640e+08 3.257280e+08 3.265920e+08 3.274560e+08 3.283200e+08 3.291840e+08 3.300480e+08 3.309120e+08 3.317760e+08 3.326400e+08 3.335040e+08 3.343680e+08 3.352320e+08 3.360960e+08 3.369600e+08 3.378240e+08 3.386880e+08 3.395520e+08 3.404160e+08 3.412800e+08 3.421440e+08 3.430080e+08 3.438720e+08 3.447360e+08 3.456000e+08 3.464640e+08 3.473280e+08 3.481920e+08 3.490560e+08 3.499200e+08 3.507840e+08 3.516480e+08 3.525120e+08 3.533760e+08 3.542400e+08 3.551040e+08 3.559680e+08 3.568320e+08 3.576960e+08 3.585600e+08 3.594240e+08 3.602880e+08 3.611520e+08 3.620160e+08 3.628800e+08 3.637440e+08 3.646080e+08 3.654720e+08 3.663360e+08 3.672000e+08 3.680640e+08 3.689280e+08 3.697920e+08 3.706560e+08 3.715200e+08 3.723840e+08 3.732480e+08 3.741120e+08 3.749760e+08 3.758400e+08 3.767040e+08 3.775680e+08 3.784320e+08 3.792960e+08 3.801600e+08 3.810240e+08 3.818880e+08 3.827520e+08 3.836160e+08 3.844800e+08 3.853440e+08 3.862080e+08 3.870720e+08 3.879360e+08 3.888000e+08 3.896640e+08 3.905280e+08 3.913920e+08 3.922560e+08 3.931200e+08 3.939840e+08 3.948480e+08 3.957120e+08 3.965760e+08 3.974400e+08 3.983040e+08 3.991680e+08 4.000320e+08 4.008960e+08 4.017600e+08 4.026240e+08 4.034880e+08 4.043520e+08 4.052160e+08 4.060800e+08 4.069440e+08 4.078080e+08 4.086720e+08 4.095360e+08 4.104000e+08 4.112640e+08 4.121280e+08 4.129920e+08 4.138560e+08 4.147200e+08 4.155840e+08 4.164480e+08 4.173120e+08 4.181760e+08 4.190400e+08 4.199040e+08 4.207680e+08 4.216320e+08 4.224960e+08 4.233600e+08 4.242240e+08 4.250880e+08 4.259520e+08 4.268160e+08 4.276800e+08 4.285440e+08 4.294080e+08 4.302720e+08 4.311360e+08 4.320000e+08 4.328640e+08 4.337280e+08 4.345920e+08 4.354560e+08 4.363200e+08 4.371840e+08 4.380480e+08 4.389120e+08 4.397760e+08 4.406400e+08 4.415040e+08 4.423680e+08 4.432320e+08 4.440960e+08 4.449600e+08 4.458240e+08 4.466880e+08 4.475520e+08 4.484160e+08 4.492800e+08 4.501440e+08 4.510080e+08 4.518720e+08 4.527360e+08 4.536000e+08 4.544640e+08 4.553280e+08 4.561920e+08 4.570560e+08 4.579200e+08 4.587840e+08 4.596480e+08 4.605120e+08 4.613760e+08 4.622400e+08 4.631040e+08 4.639680e+08 4.648320e+08 4.656960e+08 4.665600e+08 4.674240e+08 4.682880e+08 4.691520e+08 4.700160e+08 4.708800e+08 4.717440e+08 4.726080e+08 4.734720e+08 4.743360e+08 4.752000e+08 4.760640e+08 4.769280e+08 4.777920e+08 4.786560e+08 4.795200e+08 4.803840e+08 4.812480e+08 4.821120e+08 4.829760e+08 4.838400e+08 4.847040e+08 4.855680e+08 4.864320e+08 4.872960e+08 4.881600e+08 4.890240e+08 4.898880e+08 4.907520e+08 4.916160e+08 4.924800e+08 4.933440e+08 4.942080e+08 4.950720e+08 4.959360e+08 4.968000e+08 4.976640e+08 4.985280e+08 4.993920e+08 5.002560e+08 5.011200e+08 5.019840e+08 5.028480e+08 5.037120e+08 5.045760e+08 5.054400e+08 5.063040e+08 5.071680e+08 5.080320e+08 5.088960e+08 5.097600e+08 5.106240e+08 5.114880e+08 5.123520e+08 5.132160e+08 5.140800e+08 5.149440e+08 5.158080e+08 5.166720e+08 5.175360e+08 5.184000e+08 5.192640e+08 5.201280e+08 5.209920e+08 5.218560e+08 5.227200e+08 5.235840e+08 5.244480e+08 5.253120e+08 5.261760e+08 5.270400e+08 5.279040e+08 5.287680e+08 5.296320e+08 5.304960e+08 5.313600e+08 5.322240e+08 5.330880e+08 5.339520e+08 5.348160e+08 5.356800e+08 5.365440e+08 5.374080e+08 5.382720e+08 5.391360e+08 5.400000e+08 5.408640e+08 5.417280e+08 5.425920e+08 5.434560e+08 5.443200e+08 5.451840e+08 5.460480e+08 5.469120e+08 5.477760e+08 5.486400e+08 5.495040e+08 5.503680e+08 5.512320e+08 5.520960e+08 5.529600e+08 5.538240e+08 5.546880e+08 5.555520e+08 5.564160e+08 5.572800e+08 5.581440e+08 5.590080e+08 5.598720e+08 5.607360e+08 5.616000e+08 5.624640e+08 5.633280e+08 5.641920e+08 5.650560e+08 5.659200e+08 5.667840e+08 5.676480e+08 5.685120e+08 5.693760e+08 5.702400e+08 5.711040e+08 5.719680e+08 5.728320e+08 5.736960e+08 5.745600e+08 5.754240e+08 5.762880e+08 5.771520e+08 5.780160e+08 5.788800e+08 5.797440e+08 5.806080e+08 5.814720e+08 5.823360e+08 5.832000e+08 5.840640e+08 5.849280e+08 5.857920e+08 5.866560e+08 5.875200e+08 5.883840e+08 5.892480e+08 5.901120e+08 5.909760e+08 5.918400e+08 5.927040e+08 5.935680e+08 5.944320e+08 5.952960e+08 5.961600e+08 5.970240e+08 5.978880e+08 5.987520e+08 5.996160e+08 6.004800e+08 6.013440e+08 6.022080e+08 6.030720e+08 6.039360e+08 6.048000e+08 6.056640e+08 6.065280e+08 6.073920e+08 6.082560e+08 6.091200e+08 6.099840e+08 6.108480e+08 6.117120e+08 6.125760e+08 6.134400e+08 6.143040e+08 6.151680e+08 6.160320e+08 6.168960e+08 6.177600e+08 6.186240e+08 6.194880e+08 6.203520e+08 6.212160e+08 6.220800e+08 6.229440e+08 6.238080e+08 6.246720e+08 6.255360e+08 6.264000e+08 6.272640e+08 6.281280e+08 6.289920e+08 6.298560e+08 6.307200e+08 6.315840e+08 6.324480e+08 6.333120e+08 6.341760e+08 6.350400e+08 6.359040e+08 6.367680e+08 6.376320e+08 6.384960e+08 6.393600e+08 6.402240e+08 6.410880e+08 6.419520e+08 6.428160e+08 6.436800e+08 6.445440e+08 6.454080e+08 6.462720e+08 6.471360e+08 6.480000e+08 6.488640e+08 6.497280e+08 6.505920e+08 6.514560e+08 6.523200e+08 6.531840e+08 6.540480e+08 6.549120e+08 6.557760e+08 6.566400e+08 6.575040e+08 6.583680e+08 6.592320e+08 6.600960e+08 6.609600e+08 6.618240e+08 6.626880e+08 6.635520e+08 6.644160e+08 6.652800e+08 6.661440e+08 6.670080e+08 6.678720e+08 6.687360e+08 6.696000e+08 6.704640e+08 6.713280e+08 6.721920e+08 6.730560e+08 6.739200e+08 6.747840e+08 6.756480e+08 6.765120e+08 6.773760e+08 6.782400e+08 6.791040e+08 6.799680e+08 6.808320e+08 6.816960e+08 6.825600e+08 6.834240e+08 6.842880e+08 6.851520e+08 6.860160e+08 6.868800e+08 6.877440e+08 6.886080e+08 6.894720e+08 6.903360e+08 6.912000e+08 6.920640e+08 6.929280e+08 6.937920e+08 6.946560e+08 6.955200e+08 6.963840e+08 6.972480e+08 6.981120e+08 6.989760e+08 6.998400e+08 7.007040e+08 7.015680e+08 7.024320e+08 7.032960e+08 7.041600e+08 7.050240e+08 7.058880e+08 7.067520e+08 7.076160e+08 7.084800e+08 7.093440e+08 7.102080e+08 7.110720e+08 7.119360e+08 7.128000e+08 7.136640e+08 7.145280e+08 7.153920e+08 7.162560e+08 7.171200e+08 7.179840e+08 7.188480e+08 7.197120e+08 7.205760e+08 7.214400e+08 7.223040e+08 7.231680e+08 7.240320e+08 7.248960e+08 7.257600e+08 7.266240e+08 7.274880e+08 7.283520e+08 7.292160e+08 7.300800e+08 7.309440e+08 7.318080e+08 7.326720e+08 7.335360e+08 7.344000e+08 7.352640e+08 7.361280e+08 7.369920e+08 7.378560e+08 7.387200e+08 7.395840e+08 7.404480e+08 7.413120e+08 7.421760e+08 7.430400e+08 7.439040e+08 7.447680e+08 7.456320e+08 7.464960e+08 7.473600e+08 7.482240e+08 7.490880e+08 7.499520e+08 7.508160e+08 7.516800e+08 7.525440e+08 7.534080e+08 7.542720e+08 7.551360e+08 7.560000e+08 7.568640e+08 7.577280e+08 7.585920e+08 7.594560e+08 7.603200e+08 7.611840e+08 7.620480e+08 7.629120e+08 7.637760e+08 7.646400e+08 7.655040e+08 7.663680e+08 7.672320e+08 7.680960e+08 7.689600e+08 7.698240e+08 7.706880e+08 7.715520e+08 7.724160e+08 7.732800e+08 7.741440e+08 7.750080e+08 7.758720e+08 7.767360e+08 7.776000e+08 7.784640e+08 7.793280e+08 7.801920e+08 7.810560e+08 7.819200e+08 7.827840e+08 7.836480e+08 7.845120e+08 7.853760e+08 7.862400e+08 7.871040e+08 7.879680e+08 7.888320e+08 7.896960e+08 7.905600e+08 7.914240e+08 7.922880e+08 7.931520e+08 7.940160e+08 7.948800e+08 7.957440e+08 7.966080e+08 7.974720e+08 7.983360e+08 7.992000e+08 8.000640e+08 8.009280e+08 8.017920e+08 8.026560e+08 8.035200e+08 8.043840e+08 8.052480e+08 8.061120e+08 8.069760e+08 8.078400e+08 8.087040e+08 8.095680e+08 8.104320e+08 8.112960e+08 8.121600e+08 8.130240e+08 8.138880e+08 8.147520e+08 8.156160e+08 8.164800e+08 8.173440e+08 8.182080e+08 8.190720e+08 8.199360e+08 8.208000e+08 8.216640e+08 8.225280e+08 8.233920e+08 8.242560e+08 8.251200e+08 8.259840e+08 8.268480e+08 8.277120e+08 8.285760e+08 8.294400e+08 8.303040e+08 8.311680e+08 8.320320e+08 8.328960e+08 8.337600e+08 8.346240e+08 8.354880e+08 8.363520e+08 8.372160e+08 8.380800e+08 8.389440e+08 8.398080e+08 8.406720e+08 8.415360e+08 8.424000e+08 8.432640e+08 8.441280e+08 8.449920e+08 8.458560e+08 8.467200e+08 8.475840e+08 8.484480e+08 8.493120e+08 8.501760e+08 8.510400e+08 8.519040e+08 8.527680e+08 8.536320e+08 8.544960e+08 8.553600e+08 8.562240e+08 8.570880e+08 8.579520e+08 8.588160e+08 8.596800e+08 8.605440e+08 8.614080e+08 8.622720e+08 8.631360e+08 8.640000e+08 8.648640e+08 8.657280e+08 8.665920e+08 8.674560e+08 8.683200e+08 8.691840e+08 8.700480e+08 8.709120e+08 8.717760e+08 8.726400e+08 8.735040e+08 8.743680e+08 8.752320e+08 8.760960e+08 8.769600e+08 8.778240e+08 8.786880e+08 8.795520e+08 8.804160e+08 8.812800e+08 8.821440e+08 8.830080e+08 8.838720e+08 8.847360e+08 8.856000e+08 8.864640e+08 8.873280e+08 8.881920e+08 8.890560e+08 8.899200e+08 8.907840e+08 8.916480e+08 8.925120e+08 8.933760e+08 8.942400e+08 8.951040e+08 8.959680e+08 8.968320e+08 8.976960e+08 8.985600e+08 8.994240e+08 9.002880e+08 9.011520e+08 9.020160e+08 9.028800e+08 9.037440e+08 9.046080e+08 9.054720e+08 9.063360e+08 9.072000e+08 9.080640e+08 9.089280e+08 9.097920e+08 9.106560e+08 9.115200e+08 9.123840e+08 9.132480e+08 9.141120e+08 9.149760e+08 9.158400e+08 9.167040e+08 9.175680e+08 9.184320e+08 9.192960e+08 9.201600e+08 9.210240e+08 9.218880e+08 9.227520e+08 9.236160e+08 9.244800e+08 9.253440e+08 9.262080e+08 9.270720e+08 9.279360e+08 9.288000e+08 9.296640e+08 9.305280e+08 9.313920e+08 9.322560e+08 9.331200e+08 9.339840e+08 9.348480e+08 9.357120e+08 9.365760e+08 9.374400e+08 9.383040e+08 9.391680e+08 9.400320e+08 9.408960e+08 9.417600e+08 9.426240e+08 9.434880e+08 9.443520e+08 9.452160e+08 9.460800e+08 9.469440e+08 9.478080e+08 9.486720e+08 9.495360e+08 9.504000e+08 9.512640e+08 9.521280e+08 9.529920e+08 9.538560e+08 9.547200e+08 9.555840e+08 9.564480e+08 9.573120e+08 9.581760e+08 9.590400e+08 9.599040e+08 9.607680e+08 9.616320e+08 9.624960e+08 9.633600e+08 9.642240e+08 9.650880e+08 9.659520e+08 9.668160e+08 9.676800e+08 9.685440e+08 9.694080e+08 9.702720e+08 9.711360e+08 9.720000e+08 9.728640e+08 9.737280e+08 9.745920e+08 9.754560e+08 9.763200e+08 9.771840e+08 9.780480e+08 9.789120e+08 9.797760e+08 9.806400e+08 9.815040e+08 9.823680e+08 9.832320e+08 9.840960e+08 9.849600e+08 9.858240e+08 9.866880e+08 9.875520e+08 9.884160e+08 9.892800e+08 9.901440e+08 9.910080e+08 9.918720e+08 9.927360e+08 9.936000e+08 9.944640e+08 9.953280e+08 9.961920e+08 9.970560e+08 9.979200e+08 9.987840e+08 9.996480e+08 1.000512e+09 1.001376e+09 1.002240e+09 1.003104e+09 1.003968e+09 1.004832e+09 1.005696e+09 1.006560e+09 1.007424e+09 1.008288e+09 1.009152e+09 1.010016e+09 1.010880e+09 1.011744e+09 1.012608e+09 1.013472e+09 1.014336e+09 1.015200e+09 1.016064e+09 1.016928e+09 1.017792e+09 1.018656e+09 1.019520e+09 1.020384e+09 1.021248e+09 1.022112e+09 1.022976e+09 1.023840e+09 1.024704e+09 1.025568e+09 1.026432e+09 1.027296e+09 1.028160e+09 1.029024e+09 1.029888e+09 1.030752e+09 1.031616e+09 1.032480e+09 1.033344e+09 1.034208e+09 1.035072e+09 1.035936e+09 1.036800e+09 1.037664e+09 1.038528e+09 1.039392e+09 1.040256e+09 1.041120e+09 1.041984e+09 1.042848e+09 1.043712e+09 1.044576e+09 1.045440e+09 1.046304e+09 1.047168e+09 1.048032e+09 1.048896e+09 1.049760e+09 1.050624e+09 1.051488e+09 1.052352e+09 1.053216e+09 1.054080e+09 1.054944e+09 1.055808e+09 1.056672e+09 1.057536e+09 1.058400e+09 1.059264e+09 1.060128e+09 1.060992e+09 1.061856e+09 1.062720e+09 1.063584e+09 1.064448e+09 1.065312e+09 1.066176e+09 1.067040e+09 1.067904e+09 1.068768e+09 1.069632e+09 1.070496e+09 1.071360e+09 1.072224e+09 1.073088e+09 1.073952e+09 1.074816e+09 1.075680e+09 1.076544e+09 1.077408e+09 1.078272e+09 1.079136e+09 1.080000e+09 1.080864e+09 1.081728e+09 1.082592e+09 1.083456e+09 1.084320e+09 1.085184e+09 1.086048e+09 1.086912e+09 1.087776e+09 1.088640e+09 1.089504e+09 1.090368e+09 1.091232e+09 1.092096e+09 1.092960e+09 1.093824e+09 1.094688e+09 1.095552e+09 1.096416e+09 1.097280e+09 1.098144e+09 1.099008e+09 1.099872e+09 1.100736e+09 1.101600e+09 1.102464e+09 1.103328e+09 1.104192e+09 1.105056e+09 1.105920e+09 1.106784e+09 1.107648e+09 1.108512e+09 1.109376e+09 1.110240e+09 1.111104e+09 1.111968e+09 1.112832e+09 1.113696e+09 1.114560e+09 1.115424e+09 1.116288e+09 1.117152e+09 1.118016e+09 1.118880e+09 1.119744e+09 1.120608e+09 1.121472e+09 1.122336e+09 1.123200e+09 1.124064e+09 1.124928e+09 1.125792e+09 1.126656e+09 1.127520e+09 1.128384e+09 1.129248e+09 1.130112e+09 1.130976e+09 1.131840e+09 1.132704e+09 1.133568e+09 1.134432e+09 1.135296e+09 1.136160e+09 1.137024e+09 1.137888e+09 1.138752e+09 1.139616e+09 1.140480e+09 1.141344e+09 1.142208e+09 1.143072e+09 1.143936e+09 1.144800e+09 1.145664e+09 1.146528e+09 1.147392e+09 1.148256e+09 1.149120e+09 1.149984e+09 1.150848e+09 1.151712e+09 1.152576e+09 1.153440e+09 1.154304e+09 1.155168e+09 1.156032e+09 1.156896e+09 1.157760e+09 1.158624e+09 1.159488e+09 1.160352e+09 1.161216e+09 1.162080e+09 1.162944e+09 1.163808e+09 1.164672e+09 1.165536e+09 1.166400e+09 1.167264e+09 1.168128e+09 1.168992e+09 1.169856e+09 1.170720e+09 1.171584e+09 1.172448e+09 1.173312e+09 1.174176e+09 1.175040e+09 1.175904e+09 1.176768e+09 1.177632e+09 1.178496e+09 1.179360e+09 1.180224e+09 1.181088e+09 1.181952e+09 1.182816e+09 1.183680e+09 1.184544e+09 1.185408e+09 1.186272e+09 1.187136e+09 1.188000e+09 1.188864e+09 1.189728e+09 1.190592e+09 1.191456e+09 1.192320e+09 1.193184e+09 1.194048e+09 1.194912e+09 1.195776e+09 1.196640e+09 1.197504e+09 1.198368e+09 1.199232e+09 1.200096e+09 1.200960e+09 1.201824e+09 1.202688e+09 1.203552e+09 1.204416e+09 1.205280e+09 1.206144e+09 1.207008e+09 1.207872e+09 1.208736e+09 1.209600e+09 1.210464e+09 1.211328e+09 1.212192e+09 1.213056e+09 1.213920e+09 1.214784e+09 1.215648e+09 1.216512e+09 1.217376e+09 1.218240e+09 1.219104e+09 1.219968e+09 1.220832e+09 1.221696e+09 1.222560e+09 1.223424e+09 1.224288e+09 1.225152e+09 1.226016e+09 1.226880e+09 1.227744e+09 1.228608e+09 1.229472e+09 1.230336e+09 1.231200e+09 1.232064e+09 1.232928e+09 1.233792e+09 1.234656e+09 1.235520e+09 1.236384e+09 1.237248e+09 1.238112e+09 1.238976e+09 1.239840e+09 1.240704e+09 1.241568e+09 1.242432e+09 1.243296e+09 1.244160e+09 1.245024e+09 1.245888e+09 1.246752e+09 1.247616e+09 1.248480e+09 1.249344e+09 1.250208e+09 1.251072e+09 1.251936e+09 1.252800e+09 1.253664e+09 1.254528e+09 1.255392e+09 1.256256e+09 1.257120e+09 1.257984e+09 1.258848e+09 1.259712e+09 1.260576e+09 1.261440e+09 1.262304e+09 1.263168e+09 1.264032e+09 1.264896e+09 1.265760e+09 1.266624e+09 1.267488e+09 1.268352e+09 1.269216e+09 1.270080e+09 1.270944e+09 1.271808e+09 1.272672e+09 1.273536e+09 1.274400e+09 1.275264e+09 1.276128e+09 1.276992e+09 1.277856e+09 1.278720e+09 1.279584e+09 1.280448e+09 1.281312e+09 1.282176e+09 1.283040e+09 1.283904e+09 1.284768e+09 1.285632e+09 1.286496e+09 1.287360e+09 1.288224e+09 1.289088e+09 1.289952e+09 1.290816e+09 1.291680e+09 1.292544e+09 1.293408e+09 1.294272e+09 1.295136e+09 1.296000e+09 1.296864e+09 1.297728e+09 1.298592e+09 1.299456e+09 1.300320e+09 1.301184e+09 1.302048e+09 1.302912e+09 1.303776e+09 1.304640e+09 1.305504e+09 1.306368e+09 1.307232e+09 1.308096e+09 1.308960e+09 1.309824e+09 1.310688e+09 1.311552e+09 1.312416e+09 1.313280e+09 1.314144e+09 1.315008e+09 1.315872e+09 1.316736e+09 1.317600e+09 1.318464e+09 1.319328e+09 1.320192e+09 1.321056e+09 1.321920e+09 1.322784e+09 1.323648e+09 1.324512e+09 1.325376e+09 1.326240e+09 1.327104e+09 1.327968e+09 1.328832e+09 1.329696e+09 1.330560e+09 1.331424e+09 1.332288e+09 1.333152e+09 1.334016e+09 1.334880e+09 1.335744e+09 1.336608e+09 1.337472e+09 1.338336e+09 1.339200e+09 1.340064e+09 1.340928e+09 1.341792e+09 1.342656e+09 1.343520e+09 1.344384e+09 1.345248e+09 1.346112e+09 1.346976e+09 1.347840e+09 1.348704e+09 1.349568e+09 1.350432e+09 1.351296e+09 1.352160e+09 1.353024e+09 1.353888e+09 1.354752e+09 1.355616e+09 1.356480e+09 1.357344e+09 1.358208e+09 1.359072e+09 1.359936e+09 1.360800e+09 1.361664e+09 1.362528e+09 1.363392e+09 1.364256e+09 1.365120e+09 1.365984e+09 1.366848e+09 1.367712e+09 1.368576e+09 1.369440e+09 1.370304e+09 1.371168e+09 1.372032e+09 1.372896e+09 1.373760e+09 1.374624e+09 1.375488e+09 1.376352e+09 1.377216e+09 1.378080e+09 1.378944e+09 1.379808e+09 1.380672e+09 1.381536e+09 1.382400e+09 1.383264e+09 1.384128e+09 1.384992e+09 1.385856e+09 1.386720e+09 1.387584e+09 1.388448e+09 1.389312e+09 1.390176e+09 1.391040e+09 1.391904e+09 1.392768e+09 1.393632e+09 1.394496e+09 1.395360e+09 1.396224e+09 1.397088e+09 1.397952e+09 1.398816e+09 1.399680e+09 1.400544e+09 1.401408e+09 1.402272e+09 1.403136e+09 1.404000e+09 1.404864e+09 1.405728e+09 1.406592e+09 1.407456e+09 1.408320e+09 1.409184e+09 1.410048e+09 1.410912e+09 1.411776e+09 1.412640e+09 1.413504e+09 1.414368e+09 1.415232e+09 1.416096e+09 1.416960e+09 1.417824e+09 1.418688e+09 1.419552e+09 1.420416e+09 1.421280e+09 1.422144e+09 1.423008e+09 1.423872e+09 1.424736e+09 1.425600e+09 1.426464e+09 1.427328e+09 1.428192e+09 1.429056e+09 1.429920e+09 1.430784e+09 1.431648e+09 1.432512e+09 1.433376e+09 1.434240e+09 1.435104e+09 1.435968e+09 1.436832e+09 1.437696e+09 1.438560e+09 1.439424e+09 1.440288e+09 1.441152e+09 1.442016e+09 1.442880e+09 1.443744e+09 1.444608e+09 1.445472e+09 1.446336e+09 1.447200e+09 1.448064e+09 1.448928e+09 1.449792e+09 1.450656e+09 1.451520e+09 1.452384e+09 1.453248e+09 1.454112e+09 1.454976e+09 1.455840e+09 1.456704e+09 1.457568e+09 1.458432e+09 1.459296e+09 1.460160e+09 1.461024e+09 1.461888e+09 1.462752e+09 1.463616e+09 1.464480e+09 1.465344e+09 1.466208e+09 1.467072e+09 1.467936e+09 1.468800e+09 1.469664e+09 1.470528e+09 1.471392e+09 1.472256e+09 1.473120e+09 1.473984e+09 1.474848e+09 1.475712e+09 1.476576e+09 1.477440e+09 1.478304e+09 1.479168e+09 1.480032e+09 1.480896e+09 1.481760e+09 1.482624e+09 1.483488e+09 1.484352e+09 1.485216e+09 1.486080e+09 1.486944e+09 1.487808e+09 1.488672e+09 1.489536e+09 1.490400e+09 1.491264e+09 1.492128e+09 1.492992e+09 1.493856e+09 1.494720e+09 1.495584e+09 1.496448e+09 1.497312e+09 1.498176e+09 1.499040e+09 1.499904e+09 1.500768e+09 1.501632e+09 1.502496e+09 1.503360e+09 1.504224e+09 1.505088e+09 1.505952e+09 1.506816e+09 1.507680e+09 1.508544e+09 1.509408e+09 1.510272e+09 1.511136e+09 1.512000e+09 1.512864e+09 1.513728e+09 1.514592e+09 1.515456e+09 1.516320e+09 1.517184e+09 1.518048e+09 1.518912e+09 1.519776e+09 1.520640e+09 1.521504e+09 1.522368e+09 1.523232e+09 1.524096e+09 1.524960e+09 1.525824e+09 1.526688e+09 1.527552e+09 1.528416e+09 1.529280e+09 1.530144e+09 1.531008e+09 1.531872e+09 1.532736e+09 1.533600e+09 1.534464e+09 1.535328e+09 1.536192e+09 1.537056e+09 1.537920e+09 1.538784e+09 1.539648e+09 1.540512e+09 1.541376e+09 1.542240e+09 1.543104e+09 1.543968e+09 1.544832e+09 1.545696e+09 1.546560e+09 1.547424e+09 1.548288e+09 1.549152e+09 1.550016e+09 1.550880e+09 1.551744e+09 1.552608e+09 1.553472e+09 1.554336e+09 1.555200e+09 1.556064e+09 1.556928e+09 1.557792e+09 1.558656e+09 1.559520e+09 1.560384e+09 1.561248e+09 1.562112e+09 1.562976e+09 1.563840e+09 1.564704e+09 1.565568e+09 1.566432e+09 1.567296e+09 1.568160e+09 1.569024e+09 1.569888e+09 1.570752e+09 1.571616e+09 1.572480e+09 1.573344e+09 1.574208e+09 1.575072e+09 1.575936e+09'
    sync_only = ${output_only_selected_timesteps}
  []
[]
[Debug]
  show_var_residual_norms = true
[]
