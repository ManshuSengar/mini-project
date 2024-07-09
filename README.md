import React, { useState, useEffect } from 'react';
import { Formik, Form, Field } from 'formik';
import * as Yup from 'yup';
import { editUser, addUser, getUsersById, deleteUser } from '../../../features/common/commonApi';
import {
  TextField,
  Checkbox,
  FormControlLabel,
  Button,
  Grid,
  Typography,
  Box,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Select,
  MenuItem,
  InputLabel,
  FormControl,
  Card,
  Link,
  Tooltip,
  Divider,
  Radio,
  RadioGroup
} from '@mui/material';
import { DataGrid } from '@mui/x-data-grid';
import EditIcon from '@mui/icons-material/Edit';
import DeleteIcon from '@mui/icons-material/Delete';
import { getUsersLists, getFetchNBFCPartners } from 'features/common/commonApi';
import { toast } from 'react-toastify';

const validationSchema = Yup.object().shape({
  userName: Yup.string().required('Username is required'),
  email: Yup.string().email('Invalid email').required('Email is required'),
  mobileNo: Yup.string()
    .matches(/^[0-9]{10}$/, 'Mobile number must be 10 digits')
    .required('Mobile number is required'),
  address: Yup.string().required('Address is required'),
  city: Yup.string().required('City is required'),
  regType: Yup.string().required('User Type is required'),
  district: Yup.string().required('District is required'),
  state: Yup.string().required('State is required'),
  pincode: Yup.string()
    .matches(/^[0-9]{6}$/, 'Pincode must be 6 digits')
    .required('Pincode is required'),
  nbfcName: Yup.string().required('NBFC Name is required'),
  portalRoles: Yup.array().min(1, 'At least one portal role must be selected')
});

const initialValues = {
  userName: '',
  email: '',
  mobileNo: '',
  address: '',
  city: '',
  district: '',
  state: '',
  pincode: '',
  nbfcName: '',
  portalRoles: [],
  regType: ''
};

const UserForm = () => {
  const [users, setUsers] = useState([]);
  const [nbfcs, setNbfcs] = useState([]);
  const [openDialog, setOpenDialog] = useState(false);
  const [editingUser, setEditingUser] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');

  const getNbfcName = async () => {
    try {
      const response = await getFetchNBFCPartners();
      setNbfcs(response?.data);
    } catch (err) {
      toast.error('something went wrong. while fetching Nbfc');
    }
  };

  const getUsersList = async () => {
    try {
      const response = await getUsersLists();
      setUsers(response?.data);
    } catch (err) {
      toast.error('something went wrong.');
    }
  };

  useEffect(() => {
    getUsersList();
    getNbfcName();
  }, []);

  const handleSubmit = async (values, { setSubmitting, resetForm }) => {
    setSubmitting(false);
    try {
      const updatedValues = {
        userMobileNo: values.mobileNo,
        nbfcChannelPartnerCode: values.nbfcName,
        regType: values.regType,
        emailId: values.email,
        userName: values.userName,
        roles: values?.portalRoles?.join(','),
        addressDto: {
          address: values.address,
          city: values.city,
          district: values.district,
          addState: values.state,
          pinCode: values.pincode
        }
      };

      if (editingUser) {
        await editUser({ ...updatedValues, userId: values.userId });
        toast.success('User updated successfully.');
      } else {
        await addUser({ ...updatedValues, userType: 'NBFC' });
        toast.success('User added successfully.');
      }
      await new Promise((resolve) => setTimeout(resolve, 2000));
      getUsersList();
      resetForm();
      setOpenDialog(false);
      setEditingUser(null);
    } catch (error) {
      toast.error('something went wrong.');
    }
  };

  const handleEdit = async (userDetail) => {
    try {
      const result = await getUsersById(userDetail.userId);
      if (result.statusCode == 200) {
        const user = result.data;
        console.log('enter');
        const userData = {
          userId: user?.userId,
          userType: user?.userType,
          mobileNo: user.userMobileNo,
          nbfcName: user.nbfcChannelPartnerCode,
          regType: user.regType,
          email: user.emailId,
          userName: user.userName,
          address: user?.addressDto?.address,
          city: user?.addressDto?.city,
          district: user?.addressDto?.district,
          state: user?.addressDto?.addState,
          pincode: user?.addressDto?.pinCode,
          addressTypeId: user?.addressDto?.addressTypeId,
          addressType: user?.addressDto?.addressType,
          portalRoles: user?.roles?.split(',') || []
        };

        setEditingUser(userData);
        setOpenDialog(true);
      } else {
        toast.error('something went wrong.');
      }
    } catch (err) {
      toast.error('something went wrong.');
    }
  };

  const handleDelete = async (userDetail) => {
    try {
      const result = await deleteUser(userDetail.userId);
      if (result.statusCode == 200) {
        toast.success('User delete successfully. ');
        getUsersList();
      } else {
        toast.error('something went wrong.');
      }
    } catch (err) {
      toast.error('something went wrong.');
    }
  };

  const filteredUsers =
    users &&
    users?.filter(
      (user) =>
        user?.userName?.toLowerCase().includes(searchTerm?.toLowerCase()) ||
        user?.nbfcChannelPartnerCode?.toLowerCase().includes(searchTerm?.toLowerCase()) ||
        user?.emailId?.toLowerCase().includes(searchTerm?.toLowerCase())
    );

  const columns = [
    { field: 'userName', headerName: 'User Name', width: 130 },
    { field: 'nbfcPartnerName', headerName: 'NBFC Name', width: 250 },
    { field: 'emailId', headerName: 'Email Id', width: 180 },
    { field: 'userMobileNo', headerName: 'Mobile No', width: 150 },
    {
      field: 'roles',
      headerName: 'Portal Roles',
      width: 250
      //   valueGetter: (params) => params.row?.portalRoles?.join(', ')
    },
    {
      field: 'actions',
      headerName: 'Actions',
      width: 120,
      renderCell: (params) => (
        <>
          <Tooltip title="Edit">
            <Link onClick={() => handleEdit(params.row)} sx={{ marginRight: 2 }}>
              <EditIcon className="colorRed icon-size" />
            </Link>
          </Tooltip>
          <Tooltip title="Delete">
            <Link onClick={() => handleDelete(params.row)}>
              <DeleteIcon className="colorRed icon-size" style={{ color: 'red' }}/>
            </Link>
          </Tooltip>
        </>
      )
    }
  ];

  return (
    <Box className="wrap-admin-table">
      <Card className="wrap-top-head">
        <Box display="flex" justifyContent="space-between" alignItems="center">
          <div className="custome-form wrap-text">
            <TextField
              label="Search by Username or NBFC Name"
              variant="outlined"
              value={searchTerm}
              size="small"
              onChange={(e) => setSearchTerm(e.target.value)}
              fullWidth
            />
          </div>
          <Button
            variant="contained"
            size="small"
            className="add-button"
            onClick={() => {
              setOpenDialog(true);
              setEditingUser('');
            }}
          >
            Add User
          </Button>
        </Box>
      </Card>
      <Card className="wrap-table-body">
        <Box height={400}>
          <DataGrid
            rows={filteredUsers}
            className="custom-grid-table not-show-header-option on-row-selection"
            columns={columns}
            pageSize={5}
            rowsPerPageOptions={[5]}
            getRowId={(row) => row.userName + row.emailId}
          />
        </Box>
      </Card>

      <Dialog open={openDialog} onClose={() => setOpenDialog(false)}>
        <DialogTitle>{editingUser ? 'Edit User' : 'Add User'}</DialogTitle>
        <Formik
          validationSchema={validationSchema}
          enableReinitialize={true}
          initialValues={editingUser || initialValues}
          onSubmit={handleSubmit}
        >
          {({ errors, touched, values, handleChange }) => (
            <>
              <DialogContent>
                <Form className="custome-form mt-13">
                  <Grid container spacing={2}>
                    <Grid item xs={12}>
                      <Field
                        as={TextField}
                        fullWidth
                        name="userName"
                        label="Username"
                        size="small"
                        error={touched.username && errors.username}
                        helperText={touched.username && errors.username}
                        disabled={editingUser ? true : false}
                      />
                    </Grid>
                    <Grid item xs={12}>
                      <Field
                        as={TextField}
                        fullWidth
                        name="email"
                        label="Email"
                        size="small"
                        error={touched.email && errors.email}
                        helperText={touched.email && errors.email}
                        disabled={editingUser ? true : false}
                      />
                    </Grid>
                    <Grid item xs={12}>
                      <Field
                        as={TextField}
                        fullWidth
                        name="mobileNo"
                        label="Mobile Number"
                        size="small"
                        error={touched.mobileNo && errors.mobileNo}
                        helperText={touched.mobileNo && errors.mobileNo}
                        disabled={editingUser ? true : false}
                      />
                    </Grid>
                    <Grid item xs={12}>
                      <FormControl fullWidth error={touched.nbfcName && errors.nbfcName}>
                        <InputLabel className="select-label" id="nbfcName">
                          NBFC Name
                        </InputLabel>
                        <Select
                          labelId="nbfc-select-label"
                          id="nbfcName"
                          value={values.nbfcName}
                          label="NBFC Name"
                          onChange={handleChange}
                          name="nbfcName"
                          size="small"
                          disabled={editingUser ? true : false}
                        >
                          {nbfcs.map((nbfc) => (
                            <MenuItem key={nbfc.NBFC_CODE} value={nbfc.NBFC_CODE}>
                              {nbfc.NBFC_DESC}
                            </MenuItem>
                          ))}
                        </Select>
                        {touched.nbfcName && errors.nbfcName && <Typography color="error">{errors.nbfcName}</Typography>}
                      </FormControl>
                    </Grid>
                    <Grid item xs={12}>
                      <Divider className="custome-divider mb-4" textAlign="left">
                        Address
                      </Divider>
                    </Grid>
                    <Grid item xs={12}>
                      <Field
                        as={TextField}
                        fullWidth
                        name="address"
                        size="small"
                        label="Address"
                        error={touched.address && errors.address}
                        helperText={touched.address && errors.address}
                        disabled={editingUser ? true : false}
                      />
                    </Grid>
                    <Grid item xs={6}>
                      <Field
                        as={TextField}
                        fullWidth
                        name="city"
                        size="small"
                        label="City"
                        error={touched.city && errors.city}
                        helperText={touched.city && errors.city}
                        disabled={editingUser ? true : false}
                      />
                    </Grid>
                    <Grid item xs={6}>
                      <Field
                        as={TextField}
                        fullWidth
                        name="district"
                        size="small"
                        label="District"
                        error={touched.district && errors.district}
                        helperText={touched.district && errors.district}
                        disabled={editingUser ? true : false}
                      />
                    </Grid>
                    <Grid item xs={6}>
                      <Field
                        as={TextField}
                        fullWidth
                        name="state"
                        label="State"
                        size="small"
                        error={touched.state && errors.state}
                        helperText={touched.state && errors.state}
                        disabled={editingUser ? true : false}
                      />
                    </Grid>
                    <Grid item xs={6}>
                      <Field
                        as={TextField}
                        fullWidth
                        name="pincode"
                        label="Pincode"
                        size="small"
                        error={touched.pincode && errors.pincode}
                        helperText={touched.pincode && errors.pincode}
                        disabled={editingUser ? true : false}
                      />
                    </Grid>
                    <Grid item xs={12}>
                      <Divider className="custome-divider mb-4" textAlign="left">
                        Portal Roles
                      </Divider>
                    </Grid>
                    <Grid item xs={12}>
                      <FormControlLabel
                        className="custom-check"
                        control={
                          <Checkbox
                            checked={values?.portalRoles && values?.portalRoles?.includes('NBFC_REF_USER')}
                            onChange={handleChange}
                            name="portalRoles"
                            value="NBFC_REF_USER"
                          />
                        }
                        label="Refinance"
                      />
                      <FormControlLabel
                        className="custom-check"
                        control={
                          <Checkbox
                            checked={values.portalRoles.includes('CDA_USER')}
                            onChange={handleChange}
                            name="portalRoles"
                            value="CDA_USER"
                          />
                        }
                        label="CDA"
                      />
                      <FormControlLabel
                        className="custom-check"
                        control={
                          <Checkbox
                            checked={values.portalRoles.includes('CL_USER')}
                            onChange={handleChange}
                            name="portalRoles"
                            value="CL_USER"
                          />
                        }
                        label="Colending"
                      />
                      {touched.portalRoles && errors.portalRoles && <Typography color="error">{errors.portalRoles}</Typography>}
                    </Grid>
                    <Grid item xs={12}>
                      <Divider className="custome-divider mb-4" textAlign="left">
                        User Type
                      </Divider>
                    </Grid>
                    <Grid item xs={12}>
                      <RadioGroup name="regType" value={values?.regType} onChange={handleChange}>
                        <FormControlLabel className="custom-check" control={<Radio value="Maker" label="Maker" />} label="Maker" />
                        <FormControlLabel className="custom-check" control={<Radio value="Checker" />} label="Checker" />
                      </RadioGroup>
                    </Grid>
                  </Grid>

                  <DialogActions>
                    <Button
                      size="small"
                      onClick={() => {
                        setOpenDialog(false);
                        setEditingUser(null);
                      }}
                    >
                      Cancel
                    </Button>
                    <Button size="small" className="add-button" type="submit" variant="contained" color="primary">
                      {editingUser ? 'Update' : 'Submit'}
                    </Button>
                  </DialogActions>
                </Form>
              </DialogContent>
            </>
          )}
        </Formik>
      </Dialog>
    </Box>
  );
};

export default UserForm;
