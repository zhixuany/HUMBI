# Note: it is expected that you place this code inside <directory_contain_smpl_code>/SMPL_python_v.1.0.0/smpl/smpl_webuser/hello_world/

import numpy as np
import sys
sys.path.append("../")
from serialization import load_model
from lbs import verts_core as _verts_core
import chumpy as ch

def write_simple_obj( mesh_v, mesh_f, filepath):
    with open( filepath, 'w') as fp:
        for v in mesh_v:

            fp.write( 'v %f %f %f\n' % ( v[0], v[1], v[2]) )
        for f in mesh_f+1:
            fp.write( 'f %d %d %d\n' %  (f[0], f[1], f[2]) )
        print ('mesh saved to: ', filepath)

# -------------- modify this part accordingly -----------------------
dataset_path = '/home/zhixuan/data1/HUMBI/HUMBI_uploaded/Body_81_140';
subject = 82
frame = 1
outmesh_path = './smpl_mesh.obj'
model_path = '../../models/basicModel_neutral_lbs_10_207_0_v1.0.0.pkl'
# -------------------------------------------------------------------
val = np.loadtxt('{}/subject_{}/body/{:08d}/reconstruction/smpl_parameter.txt'.format(dataset_path, subject, frame))
scale = val[0]
trans = val[1:4]
m = load_model(model_path)
m.pose[:] = val[4:76]
m.betas[:] = val[76:]

[v,Jtr]=_verts_core(m.pose, m.v_posed, m.J, m.weights, m.kintree_table, want_Jtr=True, xp=ch)
Jtr=Jtr*scale+trans
v=v*scale+trans

write_simple_obj(mesh_v=v, mesh_f=m.f, filepath=outmesh_path )

