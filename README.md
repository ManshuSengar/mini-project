import { useEffect, useState } from "react";
import {
    Grid,
    Table,
    TableBody,
    TableRow,
    TableCell,
    TextField,
    Button,
    Box,
    TableHead
} from '@mui/material'
import {
    Formik,
    Form,
    Field
} from "formik"
import { initialValues, validateSchema } from "../../../models/risk_concern/riskConcern"
import { useGetRiskMasterQuery } from "../../../features/risk/api"
import "../../../styles/appraisal.scss";
import Section from "../../nbfc/Section";


const RiskConcern = () => {

    //  const[saveRiskConcern] = useSaveRiskConcernDetailMutation();

    const [riskId, setRiskId] = useState<number>(0);
    const [appId, setAppId] = useState<string>("12345");
    const [riskCode, setRiskCode] = useState([])
    const [riskName, setRiskName] = useState([]);
    const [riskComment, setRiskComment] = useState([]);
    const [ramRisk, setRamRisk] = useState([]);
    const [rmRiskComment, setRmRiskComment] = useState<string>("");



    const { data: riskData,
        isLoading,
        error: getQueryError, } = useGetRiskMasterQuery();
    console.log("riskData", riskData);

    useEffect(() => {
        console.log("riskData--> ", riskData, isLoading)
    }, [])

    return (
        <>
            <div className="wrap-appraisal-area">
                <Section>
                    <div className="inner-top-heading text-center">
                        Risk Concern
                    </div>
                    <Box className="wrap-tabs" sx={{ width: '100%' }}>
                        <Formik initialValues={initialValues}
                            validationSchema={validateSchema}
                            onSubmit={(values, { resetForm, setSubmitting }) => {
                                try {
                                    setTimeout(() => {
                                        console.log(JSON.stringify(values, null, 2));
                                        setSubmitting(false)
                                    }, 5000)
                                } catch (error) {
                                    console.log(error)
                                } finally {
                                    resetForm();
                                }
                            }}>
                            {({ isSubmitting, handleSubmit }) => (
                                <Form onSubmit={handleSubmit}>
                                    <div className="wrap-inner-table">
                                        <Table sx={{ minWidth: 650 }} aria-label="simple table">
                                            <TableHead>
                                                <TableRow>
                                                    <TableCell sx={{ width: 60 }}>Sr.No. </TableCell>
                                                    <TableCell>Facility Name</TableCell>
                                                    <TableCell>Single Scale Obligator Rating</TableCell>
                                                    <TableCell>Combined Rating Grade</TableCell>
                                                </TableRow>
                                            </TableHead>
                                            <TableBody>
                                                <TableRow>
                                                    <TableCell colSpan={4}>No data Avaliable</TableCell>
                                                </TableRow>
                                            </TableBody>
                                        </Table>
                                    </div>
                                    <div className="wrap-inner-table">
                                        <Table sx={{ minWidth: 650 }} aria-label="simple table">
                                            <TableHead>
                                                <TableRow>
                                                    <TableCell sx={{ width: 60 }}>Sr.No. </TableCell>
                                                    <TableCell sx={{ width: 500 }}>Risk Concern</TableCell>
                                                    <TableCell>User Given Comments</TableCell>
                                                </TableRow>
                                            </TableHead>
                                            <TableBody>
                                                <TableRow>
                                                    <TableCell colSpan={3}>
                                                        <b>A.
                                                            Major weakness/risk concerns indicated in external rating report</b>
                                                    </TableCell>
                                                </TableRow>
                                                {riskData?.map((appInfo: any, index: any) => (
                                                    <>
                                                        {appInfo?.riskCode === "02" ? (
                                                            <TableRow>
                                                                <TableCell>{index}</TableCell>
                                                                <TableCell>{appInfo.risk}</TableCell>
                                                                <TableCell>
                                                                    <Field name="majorWeaknessComment">
                                                                        {({ field, meta }: { field: any; meta: any }) => (
                                                                            <TextField
                                                                                {...field}
                                                                                type="text" placeholder="comments"
                                                                                value={appInfo.riskComment}
                                                                                fullWidth
                                                                                multiline
                                                                                rows={2}
                                                                                error={meta.touched && Boolean(meta.error)}
                                                                                helperText={meta.touched && meta.error} />
                                                                        )}
                                                                    </Field>
                                                                </TableCell>
                                                            </TableRow>
                                                        ) : " "}
                                                    </>
                                                ))}

                                                <TableRow>
                                                    <TableCell colSpan={3}>
                                                        <b>B. Risk Concerns</b>
                                                    </TableCell>
                                                </TableRow>
                                                {riskData?.map((appInfo: any, index: any) => (
                                                    <>
                                                        {appInfo?.riskCode === "01" ? (
                                                            <TableRow>
                                                                <TableCell>{index}</TableCell>
                                                                <TableCell>{appInfo.risk}</TableCell>
                                                                <TableCell>
                                                                    <Field name="riskConcernComment">
                                                                        {({ field, meta }: { field: any; meta: any }) => (
                                                                            <TextField type="text" placeholder="comments"
                                                                                {...field}
                                                                                multiline
                                                                                value={appInfo.riskComment}
                                                                                rows={2}
                                                                                fullWidth
                                                                                error={meta.touched && Boolean(meta.error)}
                                                                                helperText={meta.touched && meta.error} />
                                                                        )}
                                                                    </Field>
                                                                </TableCell>
                                                            </TableRow>
                                                        ) : " "}
                                                    </>
                                                ))}

                                                <TableRow>
                                                    <TableCell colSpan={3}>
                                                        <b>C.
                                                            Other important comments / risk concerns covered in DAN [In Brief]
                                                        </b>
                                                    </TableCell>
                                                </TableRow>

                                                {riskData?.map((appInfo: any, index: any) => (
                                                    <>
                                                        {appInfo?.riskCode === "03" ? (
                                                            <TableRow>
                                                                <TableCell>{index}</TableCell>
                                                                <TableCell>{appInfo.risk}</TableCell>
                                                                <TableCell>
                                                                    <Field name="otherImportantComment">
                                                                        {({ field, meta }: { field: any; meta: any }) => (
                                                                            <TextField
                                                                                {...field}
                                                                                type="text"
                                                                                placeholder="comments" fullWidth
                                                                                value={appInfo.riskComment}
                                                                                rows={2} multiline
                                                                                maxRows={4}
                                                                                error={meta.touched && Boolean(meta.error)}
                                                                                helperText={meta.touched && meta.error} />
                                                                        )}
                                                                    </Field>
                                                                </TableCell>
                                                            </TableRow>
                                                        ) : " "}
                                                    </>
                                                ))}


                                                <TableRow>
                                                    <TableCell colSpan={3}>
                                                        <b>D.
                                                        Deviation from norms other than those captured in DAN
                                                        </b>
                                                    </TableCell>
                                                </TableRow>

                                                <TableRow>
                                                    <TableCell sx={{ width: 60 }}>D</TableCell>
                                                    <TableCell colSpan={2}>
                                                        Deviation from norms other than those captured in DAN
                                                    </TableCell>
                                                </TableRow>
                                                {riskData?.map((appInfo: any, index: any) => (
                                                    <>
                                                        {appInfo?.riskCode === "04" ? (
                                                            <TableRow>
                                                                <TableCell>{index}</TableCell>
                                                                <TableCell width={600}>{appInfo.risk}</TableCell>
                                                                <TableCell>
                                                                    <Field name="deviationNormsComment">
                                                                        {({ field, meta }: { field: any; meta: any }) => (
                                                                            <TextField
                                                                                {...field}
                                                                                type="text"
                                                                                placeholder="comments" fullWidth
                                                                                value={appInfo.riskComment}
                                                                                rows={2} multiline
                                                                                maxRows={4}

                                                                                error={meta.touched && Boolean(meta.error)}
                                                                                helperText={meta.touched && meta.error} />
                                                                        )}
                                                                    </Field>
                                                                </TableCell>
                                                            </TableRow>
                                                        ) : " "}
                                                    </>
                                                ))}
                                            </TableBody>
                                        </Table>
                                    </div>

                                    <div className='custome-form'>
                                        <Grid
                                            spacing={2}
                                            padding={4}
                                            container
                                            className='form-grid'
                                        >
                                            <Grid item xs={12} sm={12} md={12} lg={12} mt={1}>
                                                <Field name="rmRiskComment">
                                                    {({ field, meta }: { field: any; meta: any }) => (
                                                        <TextField
                                                            {...field}
                                                            type="text" label="Comments of BO/ ELSC"
                                                            multiline
                                                            fullWidth
                                                            rows={3}
                                                            error={meta.touched && Boolean(meta.error)}
                                                            helperText={meta.touched && meta.error}

                                                        />
                                                    )}
                                                </Field>
                                            </Grid>
                                        </Grid>
                                    </div>
                                    {/* <Grid display="flex" direction="column" justifyContent="center" alignItems="center">
                            <Box mt={1.5}>
                                 <Button variant="contained" color="success" className="me-2"
                                    startIcon={<CheckCircleIcon />}
                                >Save as Draft</Button> 
                            </Box>
                        </Grid> */}

                                    <div className="form-submit">
                                        <Button className="text-capitalize" variant="contained" type='submit' disabled={isSubmitting}>Submit</Button>
                                    </div>

                                </Form>
                            )}
                        </Formik>
                    </Box>
                </Section>
            </div>
        </>
    )
};
export default RiskConcern;
