import geomagic.app.v3
from geomagic.app.v3.imports import *
import os

par_dir = 'P:/Data/2025-04-09 Carpometacarpal Pilot/preprocessing'
subjs = subjs = [name for name in os.listdir(par_dir)
         if os.path.isdir(os.path.join(par_dir, name)) and name.startswith("CMC")]


for i in range(len(subjs)): 
	mypath = par_dir + "/" + subjs[i]+ "/Models/IV/original" 
	bones = next(os.walk(mypath), (None, None, []))[2]
	output_dir = par_dir + "/" + subjs[i]+ "/Models/geomagic_upsampled"
	for j in range(len(bones)):
		geoapp.openFile(mypath + "/" + bones[j])
		activeModel = geoapp.getActiveModel()
		myMesh = geoapp.getMesh(activeModel)
		numPtsBefore = myMesh.numTriangles
		
		refiner = Refine(myMesh)
		refiner.subdivideBy = refiner.FourX; 
		refiner.run()
		refiner.subdivideBy = refiner.FourX; 
		refiner.run()
			
		decimator = Decimate(myMesh);

	# Set target number of triangles depending on the bone name
		bone_name = bones[j].lower()  # Make lowercase to be case-insensitive
		
		if "rad" in bone_name:
		    decimator.targetNumTriangles = 47000
		elif "uln" in bone_name:
		    decimator.targetNumTriangles = 17000		
		elif "sca" in bone_name:
		    decimator.targetNumTriangles = 17000
		elif "lun" in bone_name:
		    decimator.targetNumTriangles = 11000
		elif "trq" in bone_name:
		    decimator.targetNumTriangles = 16000  
		elif "pis" in bone_name:
			decimator.targetNumTriangles = 8000  
		elif "tpd" in bone_name:
			decimator.targetNumTriangles = 15000  
		elif "tpm" in bone_name:
			decimator.targetNumTriangles = 25000  
		elif "cap" in bone_name:
			decimator.targetNumTriangles = 21200  			
		elif "ham" in bone_name:
		    decimator.targetNumTriangles = 30000
		elif "mc2" in bone_name or "mc3" in bone_name:
		    decimator.targetNumTriangles = 54000
		elif "mc" in bone_name:
		    decimator.targetNumTriangles = 30000
		elif "pp5" in bone_name:
		    decimator.targetNumTriangles = 16000  		
		elif "pp" in bone_name:
		    decimator.targetNumTriangles = 22500  
		elif "mp5" in bone_name:
			decimator.targetNumTriangles = 9000 		
		elif "mp2" in bone_name:
			decimator.targetNumTriangles = 13000 		
		elif "mp" in bone_name:
			decimator.targetNumTriangles = 18000 
		elif "dp1" in bone_name:
			decimator.targetNumTriangles = 15000 
		elif "dp" in bone_name:
			decimator.targetNumTriangles = 5500 
		else:
			decimator.targetNumTriangles = 3000  # default fallback	
			
			
			
		decimator.run()
		numPtsAfter = myMesh.numTriangles
		
		saveOptions = FileSaveOptions()
		saveOptions.units = Length.Millimeters
		fileWriter = WriteFile()
		fileWriter.filename = output_dir + "/" + bones[j]
		fileWriter.mesh = myMesh
		fileWriter.options = saveOptions 
		fileWriter.run()
			
		print(bones[j] + " decimated and saved")
		print("Number of points before: " + str(numPtsBefore))
		print("Number of points after: " + str(numPtsAfter))
		