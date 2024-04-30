import frackit.geometry as geometry
import random
import math

from re import findall

from frackit.sampling import makeUniformPointSampler
from frackit.sampling import QuadrilateralSampler
from frackit.entitynetwork import EntityNetworkConstraints, \
    ContainedEntityNetworkBuilder
from frackit.common import Id
from frackit.sampling import SamplingStatus
from frackit.occutilities import getFaces, getShells, getShape, \
    getEdges, getWires, getVertices, getSolids
from frackit.occutilities import intersect as intersectShapes
from frackit.geometry import computeMagnitude, \
    computeContainedMagnitude, computeDistanceToBoundary, intersect
from frackit.io import GmshWriter

# PARAMETERS

# Domain
xmin = 0.0
xmax = 800.0
ymin = 0.0
ymax = 800.0
zmin = -3000.0
zmax = -2000.0
include_domain = False  # Include bounding domain in output
domain_mesh_size = 100  # Size of domain mesh

# Fractures
number_of_fractures = 15  # Number of fractures to create
# strike_angle_mean = math.radians(90.0) # deg; Mean angle between x and intersection with xy-plane (strike)
# strike_angle_std = math.radians(0.0) # deg; Standard deviation of angle
strike_angles = [math.radians(0.0), math.radians(90.0)]
strike_angles_injector = [math.radians(0.0), math.radians(90.0)]
strike_angles_producer = [math.radians(0.0), math.radians(90.0)]
strike_angles_seed = [math.radians(90.0)]
strike_length_min = 600.0  # Minimum length in strike direction
strike_length_max = 700.0  # Maximum length in strike direction
dip_angle_mean = math.radians(90.0)
dip_angle_std = math.radians(0.0)
dip_length_min = 600.0  # Minimum length in dip direction
dip_length_max = 700.0  # Maximum length in dip direction
min_distance = 50  # Minimum distance between fractures (ignoring intersections)
min_intersect_angle = math.radians(
    10.0)  # Minimum angle between two intersecting fractures
min_intersect_length = 50  # Minimum length of intersection line
min_intersect_distance = 10  # Minimum distance between two intersection lines
fracture_mesh_size = 100  # Size of fracture mesh
well_mesh_factor = 2  # Mesh refinement around injector and producer
seed_enable = False

# Injector
injection_x = 100.0  # Injector x
injection_y = 400.0  # Injector y
injection_z = -2500.0  # Injector z
injector_gmsh_point_id = 99998  # Identifier for Gmsh point

# Producer
production_x = 700.0  # Producer x
production_y = 400.0  # Producer y
production_z = -2500.0  # Producer z
producer_gmsh_point_id = 99999  # Identifier for Gmsh point

# Seed fracture
# Places a fracture initially at the selected point to improve performance generation performance
seed_x = xmin + (xmax - xmin) / 2  # Seed x
seed_y = ymin + (ymax - ymin) / 2  # Seed y
seed_z = zmin + (zmax - zmin) / 2  # Seed z

# Output
output_filename = "network"


# FUNCTIONS

# Returns a sampler for a Gaussian distribution based on mean and standard deviation
def gaussian_sampler(mean, std):
    def sample(): return random.gauss(mean, std)

    return sample


# Returns a sampler for a uniform distribution based on mininmum and maximum
def uniform_sampler(mininmum, maximum):
    def sample(): return random.uniform(mininmum, maximum)

    return sample


def discrete_sampler(numbers):
    def sample(): return random.choice(numbers)

    return sample


# Checks whether a created entity is fully within the bounding domain
def is_within_domain(entity, domain_boundary):
    intersect_result = intersectShapes(entity, domain_boundary,
                                       1e-6)
    intersect_faces = getFaces(intersect_result)
    intersect_face_area = computeMagnitude(intersect_faces[0])
    entity_area = computeMagnitude(getShape(entity))
    return not intersect_face_area < entity_area  # Make sure an entity candidate is fully inside the domain


# Checks whether an entity is intersecting the network
def is_intersecting_network(entity, network_entity_set):
    for e in network_entity_set:
        if is_intersecting(e, entity):
            return True
    return False


def is_intersecting(entity_1, entity_2):
    # Intersect returns "Segment_3d" objet if there is an intersection, otherwise it returns "EmptyIntersection"
    return intersect(entity_1, entity_2,
                     1e-6).name() == "Segment_3d"


# Extracts a list of numbers between two curly brackets in an input string, e.g. "{1,2,3}" returns [1,2,3]
def extract_list(input_string):
    pattern = r'\{([\d,\s]+)\}'
    matches = findall(pattern, input_string)  # From the re package

    result = []
    for s in matches[0].split(','):
        s = s.strip()
        if s.isdigit():
            result.append(int(s))
    return result


# GEOMETRY
domain_bounding_box = geometry.Box(xmin=xmin, ymin=ymin, zmin=zmin,
                                   xmax=xmax, ymax=ymax, zmax=zmax)
injection_point = geometry.Box(xmin=injection_x, ymin=injection_y,
                               zmin=injection_z, xmax=injection_x,
                               ymax=injection_y,
                               zmax=injection_z)
production_point = geometry.Box(xmin=production_x,
                                ymin=production_y,
                                zmin=production_z,
                                xmax=production_x,
                                ymax=production_y,
                                zmax=production_z)
seed_point = geometry.Box(xmin=seed_x, ymin=seed_y, zmin=seed_z,
                          xmax=seed_x, ymax=seed_y, zmax=seed_z)

# SAMPLERS
injection_point_sampler = makeUniformPointSampler(injection_point)
production_point_sampler = makeUniformPointSampler(production_point)
seed_point_sampler = makeUniformPointSampler(seed_point)
point_sampler = makeUniformPointSampler(domain_bounding_box)

injection_fracture_sampler = QuadrilateralSampler(
    pointSampler=injection_point_sampler,
    # strikeAngleSampler  = gaussian_sampler(strike_angle_mean, strike_angle_std),
    strikeAngleSampler=discrete_sampler(strike_angles),
    dipAngleSampler=gaussian_sampler(dip_angle_mean, dip_angle_std),
    strikeLengthSampler=uniform_sampler(strike_length_min,
                                        strike_length_max),
    dipLengthSampler=uniform_sampler(dip_length_min,
                                     dip_length_max))
producer_fracture_sampler = QuadrilateralSampler(
    pointSampler=production_point_sampler,
    # strikeAngleSampler  = gaussian_sampler(strike_angle_mean, strike_angle_std),
    strikeAngleSampler=discrete_sampler(strike_angles_injector),
    dipAngleSampler=gaussian_sampler(dip_angle_mean, dip_angle_std),
    strikeLengthSampler=uniform_sampler(strike_length_min,
                                        strike_length_max),
    dipLengthSampler=uniform_sampler(dip_length_min,
                                     dip_length_max))
seed_fracture_sampler = QuadrilateralSampler(
    pointSampler=seed_point_sampler,
    # strikeAngleSampler  = gaussian_sampler(strike_angle_mean, strike_angle_std),
    strikeAngleSampler=discrete_sampler(strike_angles_seed),
    dipAngleSampler=gaussian_sampler(dip_angle_mean, dip_angle_std),
    strikeLengthSampler=uniform_sampler(strike_length_min,
                                        strike_length_max),
    dipLengthSampler=uniform_sampler(dip_length_min,
                                     dip_length_max))
fracture_sampler = QuadrilateralSampler(pointSampler=point_sampler,
                                        # strikeAngleSampler  = gaussian_sampler(strike_angle_mean, strike_angle_std),
                                        strikeAngleSampler=discrete_sampler(
                                            strike_angles_producer),
                                        dipAngleSampler=gaussian_sampler(
                                            dip_angle_mean,
                                            dip_angle_std),
                                        strikeLengthSampler=uniform_sampler(
                                            strike_length_min,
                                            strike_length_max),
                                        dipLengthSampler=uniform_sampler(
                                            dip_length_min,
                                            dip_length_max))

# CONSTRAINTS
constraints_between_fractures = EntityNetworkConstraints()
constraints_between_fractures.setMinDistance(min_distance)
constraints_between_fractures.setMinIntersectingAngle(
    min_intersect_angle)
constraints_between_fractures.setMinIntersectionMagnitude(
    min_intersect_length)
constraints_between_fractures.setMinIntersectionDistance(
    min_intersect_distance)

# Identifies for sets of entities
default_id = Id(1)

# CREATE NETWORK
status = SamplingStatus()
status.setTargetCount(default_id,
                      number_of_fractures)  # Set number of fractures to create
entity_set = []

print("Start candidate search...")

while not status.finished():

    # Create injection fracture
    if status.getCount() == 0:
        candidate = injection_fracture_sampler()
    # Create producer fracture
    elif status.getCount() == 1:
        candidate = producer_fracture_sampler()
    # Create seed fracture
    elif status.getCount() == 2 and seed_enable:
        candidate = seed_fracture_sampler()
    # Create remaining fractures
    else:
        candidate = fracture_sampler()
        # Check if candidate is intersecting existing fractures
        if not is_intersecting_network(candidate, entity_set):
            status.increaseRejectedCounter()
            continue

    # Check if candidate is fully within domain
    if not is_within_domain(candidate, domain_bounding_box):
        status.increaseRejectedCounter()
        continue

    # Check if candidate violates any constraints
    if not constraints_between_fractures.evaluate(entity_set,
                                                  candidate):
        status.increaseRejectedCounter()
        continue

    # Add candidate to network
    entity_set.append(candidate)

    status.increaseCounter(default_id)
    status.print()

print("Candidate search completed.")

# BUILD NETWORK
print("Building network...", end="")
builder = ContainedEntityNetworkBuilder()
builder.addSubDomainEntities(entity_set, default_id)
if include_domain:
    builder.addSubDomain(domain_bounding_box, Id(1))
network = builder.build()
print("DONE")

# WRITE FILES
print("Writing .geo file...", end="")
writer = GmshWriter(network)
writer.setMeshSize(GmshWriter.GeometryTag.entity,
                   fracture_mesh_size)
writer.setMeshSize(GmshWriter.GeometryTag.subDomain,
                   domain_mesh_size)
# writer.setPhysical(GmshWriter.GeometryTag.entity, default_id)
# writer.setPhysical(GmshWriter.GeometryTag.entity, production_id)
writer.write(output_filename)  # Write .geo file
print("DONE")

# Configure Injection and Production point for mesh in geo file
print("Add injector/producer...", end="")
injection_surfaces = []
production_surfaces = []
with open(f'{output_filename}.geo', 'r') as f:
    for line in f:
        if "Physical Surface(1)" in line:
            injection_surfaces = extract_list(line)
            continue
        if "Physical Surface(2)" in line:
            production_surfaces = extract_list(line)

with open(f'{output_filename}.geo', 'a') as f:
    f.write(f'\n// INCLUDE INJECTOR/PRODUCER IN MESH\n')
    f.write('//+\n')
    f.write(
        f'Point({injector_gmsh_point_id}) = {{{injection_x}, {injection_y}, {injection_z}, {fracture_mesh_size / well_mesh_factor}}};\n')
    f.write('//+\n')
    f.write(
        f'Physical Point("injection_node", {injector_gmsh_point_id}) = {{{injector_gmsh_point_id}}};\n')
    f.write('//+\n')
    f.write(
        f'Point({producer_gmsh_point_id}) = {{{production_x}, {production_y}, {production_z}, {fracture_mesh_size / well_mesh_factor}}};\n')
    f.write('//+\n')
    f.write(
        f'Physical Point("production_node", {producer_gmsh_point_id}) = {{{producer_gmsh_point_id}}};\n')

    # Include injector in mesh
    for surface in injection_surfaces:
        f.write(f'// Add injector to surface\n')
        f.write(
            f'Point{{{injector_gmsh_point_id}}} In Surface{{{surface}}};\n')
    # Include producer in mesh
    for surface in production_surfaces:
        f.write(f'// Add producer to surface\n')
        f.write(
            f'Point{{{producer_gmsh_point_id}}} In Surface{{{surface}}};\n')

print("DONE")
print("Exiting")
