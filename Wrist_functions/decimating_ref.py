import geomagic.app.v3
from geomagic.app.v3.imports import *
import os

par_dir = 'P:/Data/2025-04-09 Carpometacarpal Pilot/preprocessing/reference/Models/IV'

bones = next(os.walk(par_dir), (None, None, []))[2]
	
output_dir = "P:/Data/2025-04-09 Carpometacarpal Pilot/preprocessing/reference/Models/geomagic_upsampled"

for j in range(len(bones)):
    geoapp.openFile(par_dir + "/" + bones[j])
    activeModel = geoapp.getActiveModel()
    myMesh = geoapp.getMesh(activeModel)
    numPtsBefore = myMesh.numTriangles

    # Step: Decimate the mesh
    decimator = Decimate(myMesh)

    bone_name = bones[j].lower()

    if "rad" in bone_name:
        decimator.targetNumTriangles = 23500
    elif "uln" in bone_name:
        decimator.targetNumTriangles = 8500		
    elif "sca" in bone_name:
        decimator.targetNumTriangles = 8500
    elif "lun" in bone_name:
        decimator.targetNumTriangles = 5500
    elif "trq" in bone_name:
        decimator.targetNumTriangles = 8000  
    elif "pis" in bone_name:
        decimator.targetNumTriangles = 4000  
    elif "tpd" in bone_name:
        decimator.targetNumTriangles = 7500  
    elif "tpm" in bone_name:
        decimator.targetNumTriangles = 12500  
    elif "cap" in bone_name:
        decimator.targetNumTriangles = 10600  			
    elif "ham" in bone_name:
        decimator.targetNumTriangles = 15000
    elif "mc2" in bone_name or "mc3" in bone_name:
        decimator.targetNumTriangles = 27500
    elif "mc" in bone_name:
        decimator.targetNumTriangles = 15000
    elif "pp5" in bone_name:
        decimator.targetNumTriangles = 8000  		
    elif "pp" in bone_name:
        decimator.targetNumTriangles = 11250  
    elif "mp5" in bone_name:
        decimator.targetNumTriangles = 4500 		
    elif "mp2" in bone_name:
        decimator.targetNumTriangles = 7500 		
    elif "mp" in bone_name:
        decimator.targetNumTriangles = 9000 
    elif "dp1" in bone_name:
        decimator.targetNumTriangles = 7500 
    elif "dp" in bone_name:
        decimator.targetNumTriangles = 2250 
    else:
        decimator.targetNumTriangles = 1500  # default fallback	
 
    decimator.run()
    numPtsAfter = myMesh.numTriangles

    saveOptions = FileSaveOptions()
    saveOptions.units = Length.Millimeters
    fileWriter = WriteFile()
    fileWriter.filename = output_dir + "/" + bones[j]
    fileWriter.mesh = myMesh
    fileWriter.options = saveOptions 
    fileWriter.run()
    print(bones[j] + " smoothed, decimated, and saved")
    print("Number of points before: " + str(numPtsBefore))
    print("Number of points after: " + str(numPtsAfter))
