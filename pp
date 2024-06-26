import {
    Grid,
    Typography,
    Stack,
    Divider,
    Button,
} from '@mui/material';
import React, { useEffect, useState } from 'react';
import { Formik, Form, useFormikContext, FormikProps } from 'formik';
import * as Yup from 'yup';
import ErrorMessageGlobal from '../../../components/framework/ErrorMessageGlobal';
import { DropDownField } from '../../../components/framework/DropDownField';
import { TextBoxField } from '../../../components/framework/TextBoxField';
import { defaultPnfInformation, pnfInformationSchema } from '../../../models/pnf/pnf';
import { useAddPnfMutation, useGetPnfQuery, useUpdatePnfMutation } from '../../../features/pnf/api';
import { useAppDispatch, useAppSelector } from '../../../app/hooks';
import { setDrawerState, setPnfStatus } from '../../../features/lead/leadSlice';
import { useNavigate, useParams } from 'react-router-dom';
import { AiOutlineCheck, AiOutlineClose } from "react-icons/ai";

const PnfForm = () => {
    const [pnfId, updatePnfId] = useState<number | null>(null);
    const [error, setError] = useState<any>();
    const [isLoading, setIsLoading] = useState(false);
    const { id: pnfIdParam } = useParams<{ id: string }>();
    const { pnfStatus } = useAppSelector((state) => state.leadStore);
    const dispatch = useAppDispatch();
    const navigate = useNavigate();
    const [addPnf] = useAddPnfMutation();
    const [updatePnf] = useUpdatePnfMutation();
    const { data: initialData, isLoading: isInitialLoading } = useGetPnfQuery(Number(pnfIdParam), {
        skip: !pnfIdParam,
    });

    useEffect(() => {
        if (window.location.pathname.split("/")[2] === 'pnf') {
            dispatch(setDrawerState(false));
        }
    }, []);

    useEffect(() => {
        if (pnfIdParam) {
            updatePnfId(Number(pnfIdParam));
        }
    }, [pnfIdParam]);

    const handleSave = async (status: string, values: any) => {
        setIsLoading(true);
        setError(null);
        try {
            if (pnfId) {
                await updatePnf({ ...values, id: pnfId, status }).unwrap();
            } else {
                const response = await addPnf({ ...values, status }).unwrap();
                updatePnfId(response.id);
            }
            navigate('/los/pnf-dashboard');
        } catch (error) {
            setError(error);
        } finally {
            setIsLoading(false);
        }
    };

    if (isInitialLoading) {
        return <Typography>Loading...</Typography>;
    }

    interface IFormValues {
        myInput: string;
    }

    const handleButtonClick = async (
        status: "01" | "02" | "03" | "04",
        formikProps: FormikProps<IFormValues>
    ) => {
        console.log("status", status);
        const { values, submitForm, setSubmitting } = formikProps;
        setIsLoading(true);
        setError(null);
        submitForm();
        try {
            if (pnfId) {
                await updatePnf({ ...values, id: pnfId, status }).unwrap();
            } else {
                const response = await addPnf({ ...values, status }).unwrap();
                updatePnfId(response.id);
            }
            setSubmitting(false);
            dispatch(setPnfStatus(status));
            navigate('/los/pnf-dashboard');
        } catch (error) {
            setSubmitting(false);
            setError(error);

        } finally {
            setIsLoading(false);
        }
    };

    return (
        <>
            <ErrorMessageGlobal status={error} />
            <div className='custome-form'>
                <Formik
                    initialValues={initialData || defaultPnfInformation}
                    validationSchema={pnfInformationSchema}
                    onSubmit={() => console.log("do nothing here.")}
                    enableReinitialize={true}
                >
                    {formikProps => {
                        const {
                            values,
                            handleBlur,
                            handleChange,
                            isSubmitting,
                            submitCount
                        } = formikProps;
                        return (
                            <Form>
                                <Grid spacing={2} padding={4} container className='form-grid'>
                                    <Grid item xs={12} sm={6} md={3} lg={3}>
                                        <DropDownField
                                            label="Name of Mir: *"
                                            name="mirId"
                                            domain="mir/getMirPnfList"
                                        />
                                    </Grid>
                                    <Grid item xs={12} sm={6} md={3} lg={3}>
                                        <DropDownField
                                            label="Name of Borrower: *"
                                            name="customerName"
                                            domain="mstr/getNbfcMaster"
                                        />
                                    </Grid>
                                    <Grid item xs={12} sm={6} md={3} lg={3}>
                                        <DropDownField
                                            label="Nature of Business: * "
                                            name="businessNature"
                                            domain="mstr/businessNature"
                                        />
                                    </Grid>
                                    <Grid item xs={12} sm={6} md={3} lg={3}>
                                        <Stack spacing={1}>
                                            <DropDownField
                                                label="Purpose of Loan: * "
                                                name="loanPurpose"
                                                domain="mstr/loanPurpose"
                                            />
                                        </Stack>
                                    </Grid>
                                    <Grid item xs={12} lg={12}>
                                        <Divider className='mb-3' textAlign="left">
                                            <span className='seperator-ui'>Details of Nominated Personnel</span>
                                        </Divider>
                                    </Grid>
                                    <Grid item xs={12} lg={4}>
                                        <TextBoxField label="Name *" name="nominationName" />
                                    </Grid>
                                    <Grid item xs={12} lg={4}>
                                        <TextBoxField name="nominationType" label="Type of Employee" />
                                    </Grid>
                                    <Grid item xs={12} lg={4}>
                                        <TextBoxField name="nominationDesgn" label="Designation *" />
                                    </Grid>
                                    <Grid item xs={12} lg={4}>
                                        <TextBoxField name="nominationEmpId" label="Employee Id *" />
                                    </Grid>
                                    <Grid item xs={12} lg={4}>
                                        <TextBoxField name="nominationBehalf" label="Acting on Behalf of *" />
                                    </Grid>
                                    <Grid item xs={12} lg={4}>
                                        <TextBoxField name="nominationEmailId" label="Official Email Id *" />
                                    </Grid>
                                    <Grid item xs={12} lg={4}>
                                        <TextBoxField name="nominationMobileNo" label="Official Mobile No *" />
                                    </Grid>
                                    <Grid item xs={12} lg={4}>
                                        <TextBoxField name="nominationPan" label="Pan Number *" />
                                    </Grid>
                                    <Grid item xs={12} lg={4}>
                                        <TextBoxField name="nominationAuthBy" label="Authorized By *" />
                                    </Grid>
                                    <Grid item xs={12} lg={12}>
                                        <Divider className='mb-3' textAlign="left">
                                            <span className='seperator-ui'>Details of Authorized Signatory (As Per Board Resolution)</span>
                                        </Divider>
                                    </Grid>
                                    <Grid item xs={12} lg={6}>
                                        <TextBoxField name="authName" label="Name *" />
                                    </Grid>
                                    <Grid item xs={12} lg={6}>
                                        <TextBoxField name="authType" label="Type of Employee" />
                                    </Grid>
                                    <Grid item xs={12} lg={6}>
                                        <TextBoxField name="authDesgn" label="Designation *" />
                                    </Grid>
                                    <Grid item xs={12} lg={6}>
                                        <TextBoxField name="authEmpId" label="Employee Id *" />
                                    </Grid>
                                    <Grid item xs={12} lg={6}>
                                        <TextBoxField name="authBehalf" label="Acting on Behalf of *" />
                                    </Grid>
                                    <Grid item xs={12} lg={6}>
                                        <TextBoxField name="authEmailId" label="Official Email Id *" />
                                    </Grid>
                                    <Grid item xs={12} lg={6}>
                                        <TextBoxField name="authMobileNo" label="Official Mobile No *" />
                                    </Grid>
                                    <Grid item xs={12} lg={6}>
                                        <TextBoxField name="authPan" label="Pan Number *" />
                                    </Grid>
                                    <Grid item xs={12} lg={6}>
                                        <TextBoxField name="authAuthBy" label="Authorized By *" />
                                    </Grid>
                                    <Grid item xs={12} textAlign="right">
                                        {values.status == 1 ? <><Button
                                            startIcon={<AiOutlineCheck />}
                                            variant="contained"
                                            color="success"
                                            onClick={() => handleButtonClick("01", formikProps)}
                                            disabled={isSubmitting}
                                        >
                                            Save as draft
                                        </Button>
                                            <Button
                                                startIcon={<AiOutlineCheck />}
                                                variant="contained"
                                                color="success"
                                                onClick={() => handleButtonClick("02", formikProps)}
                                                disabled={isSubmitting}
                                            >
                                                Submit
                                            </Button></> : <><Button
                                                startIcon={<AiOutlineCheck />}
                                                variant="contained"
                                                color="success"
                                                onClick={() => handleButtonClick("03", formikProps)}
                                                disabled={isSubmitting}
                                            >
                                                Approve
                                            </Button>
                                            <Button
                                                startIcon={<AiOutlineCheck />}
                                                variant="contained"
                                                color="success"
                                                onClick={() => handleButtonClick("04", formikProps)}
                                                disabled={isSubmitting}
                                            >
                                                Reject
                                            </Button></>}

                                    </Grid>
                                </Grid>
                            </Form>
                        )
                    }}
                </Formik>
            </div>
        </>
    );
}

export default PnfForm;
