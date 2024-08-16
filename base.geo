// Base.geo script for OpenFOAM rectangular mesh
// Define parameters
dx = 0.1;
originx = 31.8;
originy = 64.4;
originz = 30.0;
lx = 106.8 - originx;
ly = 134.4 - originy;
lz = 37.1 - originz;

// Define points
Point(1) = {originx, originy, originz};

// Extrude in y direction
back[] = Extrude {0, ly, 0} {
  Point{1}; Layers{Round(ly/dx)}; Recombine;
};

// Extrude in x direction
right[] = Extrude {lx, 0, 0} {
  Line{1}; Layers{Round(lx/dx)}; Recombine;
};

// Extrude in z direction
top[] = Extrude {0, 0, lz} {
  Surface{right[1]}; Layers{Round(lz/dx)}; Recombine;
};

// Ensure coherence
Coherence;

// Define physical groups
Physical Surface("atmosphere") = {top[0]};
Physical Surface("walls") = {back[1], right[1], top[2], top[3], top[4], top[5]};

// Define volume
Physical Volume("fluid") = {1};

// Ensure coherence again
Coherence;

// Mesh size field for visualization (optional)
Field[1] = Box;
Field[1].VIn = dx;
Field[1].VOut = dx;
Field[1].XMin = originx;
Field[1].XMax = originx + lx;
Field[1].YMin = originy;
Field[1].YMax = originy + ly;
Field[1].ZMin = originz;
Field[1].ZMax = originz + lz;

Background Field = 1;

// Mesh algorithm selection (optional)
Mesh.Algorithm = 6; // Frontal-Delaunay for 2D meshes
Mesh.Algorithm3D = 1; // Delaunay for 3D meshes

// Visualization options (optional)
Mesh.SurfaceFaces = 1;
Mesh.VolumeFaces = 0;
Mesh.SurfaceEdges = 1;
Mesh.VolumeEdges = 0;