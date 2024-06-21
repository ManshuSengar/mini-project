import {
    Grid,
    Typography,
    Stack,
} from '@mui/material';
import Divider from '@mui/material/Divider';
import { FormSubmit, SubmitableForm } from '../../../components/framework/FormSubmit';
import React, { useEffect, useState } from 'react';
import ErrorMessageGlobal from '../../../components/framework/ErrorMessageGlobal';
import EntityForm from '../../../components/framework/EntityForm';
import { DropDownField } from '../../../components/framework/DropDownField';
import { TextBoxField } from '../../../components/framework/TextBoxField';
import { defaultMarketIntelligenceInformation, marketIntelligenceInformationSchema } from '../../../models/markete-intelligence/marketIntelligence';
import { useAddMirMutation, useGetMirQuery, useUpdateMirMutation } from '../../../features/mir/api';
import { defaultPnfInformation, pnfInformationSchema } from '../../../models/pnf/pnf';
import { useAddPnfMutation, useGetPnfQuery, useUpdatePnfMutation } from '../../../features/pnf/api';
import ErrorMessageGlobar from '../../../components/framework/ErrorMessageGlobal';
import { useAppDispatch, useAppSelector } from '../../../app/hooks';
import { setDrawerState } from '../../../features/lead/leadSlice';


export type propsType = {
    pnfId?: string
}

const PnfForm = React.forwardRef<SubmitableForm, propsType>((props, ref) => {
    const [pnfId, updatePnfId] = useState(Number(props.pnfId));
    const [error, setError] = useState<any>();
    const [isLoading, setIsLoading] = useState(false);
    const receivePnfId = (id: number) => {
        updatePnfId(id);
    };
    const { pnfStatus } = useAppSelector((state) => state.leadStore);
    const dispatch = useAppDispatch();

    useEffect(() => {
        if (window.location.pathname.split("/")[2] === 'pnf') {
          dispatch(setDrawerState(false));
        }
      }, [])
      
    return (
        <>
            <ErrorMessageGlobar status={error} />
            <div className='custome-form' >
                <EntityForm
                    id={pnfId}
                    defaultItem={defaultPnfInformation}
                    itemSchema={pnfInformationSchema}
                    useAddItemMutation={useAddPnfMutation}
                    useUpdateItemMutation={useUpdatePnfMutation}
                    useGetItemQuery={useGetPnfQuery}
                    setError={setError}
                    setIsLoading={setIsLoading}
                    setItemId={receivePnfId}
                    status={pnfStatus}
                >
                    <Grid
                        spacing={2}
                        padding={4}
                        container
                        className='form-grid'
                    >
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
                                <span className='seperator-ui'>Details of Nominated Personnel</span></Divider>
                        </Grid>

                        <Grid item xs={12} lg={4}>
                            <TextBoxField label="Name *" name="nominationName" />
                        </Grid>

                        <Grid item xs={12} lg={4}>
                            <TextBoxField name="nominationType" label="Type of Employee"
                            />
                        </Grid>

                        <Grid item xs={12} lg={4}>
                            <TextBoxField name="nominationDesgn" label="Designation *" />
                        </Grid>

                        <Grid item xs={12} lg={4}>
                            <TextBoxField name="nominationEmpId" label="Employee Id *"
                            />
                        </Grid>

                        <Grid item xs={12} lg={4}>
                            <TextBoxField name="nominationBehalf" label="Acting on Behalf of *"
                            />
                        </Grid>
                        <Grid item xs={12} lg={4}>
                            <TextBoxField name="nominationEmailId" label="Official Email Id *"
                            />
                        </Grid>
                        <Grid item xs={12} lg={4}>
                            <TextBoxField name="nominationMobileNo" label="Official Mobile No *"
                            />
                        </Grid>
                        <Grid item xs={12} lg={4}>
                            <TextBoxField name="nominationPan" label="Pan Number *"
                            />
                        </Grid>
                        <Grid item xs={12} lg={4}>
                            <TextBoxField name="nominationAuthBy" label="Authorized By *"
                            />
                        </Grid>
                        <Grid item xs={12} lg={12}>
                            <Divider className='mb-3' textAlign="left">
                                <span className='seperator-ui'>Details of Authorized Signatory (As Per Board Resolution)</span></Divider>
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
                        <FormSubmit ref={ref} />
                    </Grid>
                </EntityForm>
            </div>
        </>
    )
})
export default PnfForm;
