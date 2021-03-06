if (chi_location_id == 0) then
    print("############################################### LuaTest")
end
--dofile(CHI_LIBRARY)




--############################################### Setup mesh
chiMeshHandlerCreate()

newSurfMesh = chiSurfaceMeshCreate();
chiSurfaceMeshImportFromOBJFile(newSurfMesh,
        "XMesh_Test2.obj",true)

--############################################### Extract edges from surface mesh
loops,loop_count = chiSurfaceMeshGetEdgeLoopsPoly(newSurfMesh)

line_mesh = {};
line_mesh_count = 0;

for k=1,loop_count do
    split_loops,split_count = chiEdgeLoopSplitByAngle(loops,k-1,0.1);
    for m=1,split_count do
        line_mesh_count = line_mesh_count + 1;
        line_mesh[line_mesh_count] = chiLineMeshCreateFromLoop(split_loops,m-1);
    end

end

--############################################### Setup Regions
region1 = chiRegionCreate()
chiRegionAddSurfaceBoundary(region1,newSurfMesh);
for k=1,line_mesh_count do
    chiRegionAddLineBoundary(region1,line_mesh[k]);
end

--############################################### Create meshers
chiSurfaceMesherCreate(SURFACEMESHER_PREDEFINED);
chiVolumeMesherCreate(VOLUMEMESHER_EXTRUDER);

chiSurfaceMesherSetProperty(MAX_AREA,20/20/1.0)
chiSurfaceMesherSetProperty(PARTITION_X,3)
chiSurfaceMesherSetProperty(PARTITION_Y,1)
chiSurfaceMesherSetProperty(CUT_X,-3.33)
chiSurfaceMesherSetProperty(CUT_X,3.33)


NZ=2
chiVolumeMesherSetProperty(EXTRUSION_LAYER,0.5,NZ,"Charlie");
chiVolumeMesherSetProperty(EXTRUSION_LAYER,0.5,NZ,"Charlie");

chiVolumeMesherSetProperty(PARTITION_Z,4)
--chiVolumeMesherSetProperty(PARTITION_Z,1)

--############################################### Execute meshing
chiSurfaceMesherExecute();
chiVolumeMesherExecute();

chiRegionExportMeshToPython(region1,"YMesh_Test2.py",true)

if (chi_location_id == 0) then
    local handle = io.popen("python YMesh_Test2.py")
    print("Execution completed")
end