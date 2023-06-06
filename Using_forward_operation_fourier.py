import numpy as np
import nibabel as nib
import qsm

# Load GT susceptiblity values volume

volume = nib.load("DRO_Susceptibility_GT.nii.gz")
data = volume.get_fdata()
print(data.shape)

# QSM class
qsm_operation = qsm.QSM(voxel_size=(0.7, 0.7, 0.7), b_vec=(0, 0, 1))

# Dipole kernel
kernel = qsm_operation.get_dipole_kernel_fourier(data.shape)
print(kernel.shape)
nib.save(nib.Nifti1Image(kernel, volume.affine, volume.header), "DRO_cont_kernel.nii.gz")

# Forward model
fw = qsm_operation.forward_operation_fourier(np.array([np.expand_dims(data, axis=-1)]), kernel).numpy()
print(fw.shape)
nib.save(nib.Nifti1Image(fw[0,:,:,:,0], volume.affine, volume.header), "DRO_fm_freq.nii.gz")