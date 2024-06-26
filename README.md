import * as React from "react";
import axios from "axios";
import { useEffect, useState } from "react";
import base_url from "../service/microapi";
import Card from "@mui/material/Card";
import { TextField } from "@mui/material";
import CardContent from "@mui/material/CardContent";
import Button from "@mui/material/Button";
import { DataGrid } from "@mui/x-data-grid";
import { Grid, Typography, Select, MenuItem } from "@mui/material";
import { Link } from "react-router-dom";
import Chip from "@mui/material/Chip";
import Tooltip from "@mui/material/Tooltip";
import CdaSnackbar from "../Modal/CdaSnackbar";
import Skeleton from "@mui/material/Skeleton";
import DeleteModel from "../Modal/DeleteModal";
import ViewReportModel from "../Modal/ViewReportModel";
import InputLabel from "@mui/material/InputLabel";
import FormControl from "@mui/material/FormControl";
import { DatePicker } from "@mui/x-date-pickers/DatePicker";
import Sidebar from "../Modal/Sidebar";


function Dashboard({ userId, handleSetCustomerId }) {
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const [deleteId, setDeleteId] = useState();
  const [showViewModal, setShowViewModal] = useState(false);
  const [isServerDown, setServerDown] = useState(false);
  const [reportData, setReportData] = useState();
  const [tableTitle, setTableTitle] = useState("Total Application");
  const [partners, setPartners] = useState([]);
  const [openDrawer, setDrawerOpen] = React.useState(false);
  const [appData, setData] = React.useState({});

  // search table
  const [startDate, setStartDate] = useState(null);
  const [endDate, setEndDate] = useState(null);
  const [searchText, setSearchText] = useState("");
  const [states, setStates] = useState([]);
  const [selectedStates, setSelectedStates] = useState("");
  const [selectPartner, setSelectPartner] = useState("");

  useEffect(() => {
    getStateMaster();
    getPartnerMaster();
  }, []);

  const getStateMaster = () => {
    setloading(true);
    axios
      .get(`${base_url}/dash/getStateMaster`)
      .then((res) => {
        if (res.data.status === 200 && res.data.result !== null) {
          setStates(res.data.result);
        }
        setloading(false);
      })
      .catch((err) => {
        if (err.response === undefined) {
          setServerDown(true);
          setOpenSnacknar(true);
          setSnackMsg("Server is Down. Contact to support. !");
          setSeverity("error");
        } else {
          setloading(false);
        }
      });
  };

  const getPartnerMaster = () => {
    setloading(true);
    axios
      .get(`${base_url}/dash/getPlatMastr`)
      .then((res) => {
        if (res.data.status === 200 && res.data.result !== null) {
          setPartners(res.data.result);
        }
        setloading(false);
      })
      .catch((err) => {
        if (err.response === undefined) {
          setServerDown(true);
          setOpenSnacknar(true);
          setSnackMsg("Server is Down. Contact to support. !");
          setSeverity("error");
        } else {
          setloading(false);
        }
      });
  };

  const commonGridColumns = [
    {
      field: "id",
      headerName: "S N",
      width: 40,
      renderCell: (params) => {
        return <Link className="in-clickable" onClick={() => handleApplicationDetails(params, true)}>{params.row.id}</Link>;
      },
    },
    {
      field: "borw",
      headerName: "Borrower Name",
      width: 100,
      editable: false,
      renderCell: (params) => {
        return <Tooltip title={params.row.borw}>
          <Link className="in-clickable" onClick={() => handleApplicationDetails(params, true)}>{params.row.borw}</Link>
          </Tooltip>;
      },
    },
    {
      field: "loanReqid",
      headerName: "Loan Request",
      width: 150,
      editable: false,
      renderCell: (params) => {
        return <Tooltip title={params.row.loanReqid}>
          <Link className="in-clickable" onClick={() => copyClipboard(params.row.loanReqid)}>{params.row.loanReqid}</Link>
          </Tooltip>;
      },
    },
    {
      field: "inwardNo",
      headerName: "Inward No.",
      width: 100,
      editable: false,
      renderCell: (params) => {
        return <Tooltip title={params.row.inwardNo}><Link className="in-clickable" onClick={() => handleApplicationDetails(params, true)}>{params.row.inwardNo}</Link>
      </Tooltip>;
      },
    },
    {
      field: "state",
      headerName: "State",
      width: 100,
      editable: false,
      renderCell: (params) => {
        return <Tooltip title={params.row.state}><Link className="in-clickable" onClick={() => handleApplicationDetails(params, true)}>{params.row.state}</Link>
        </Tooltip>;
      },
    },
    {
      field: "asstntAmount",
      headerName: "Applied Amount",
      width: 80,
      editable: false,
      renderCell: (params) => {
        return <Tooltip title={params.row.asstntAmount}><Link className="in-clickable" onClick={() => handleApplicationDetails(params, true)}>{params.row.asstntAmount}</Link>
        </Tooltip>;
      },
    },
    // {
    //   field: "pan",
    //   headerName: "Pan",
    //   width: 100,
    //   sortable: false,
    //   editable: false,
    //   renderCell: (params) => {
    //     return <Link className="in-clickable" onClick={() => handleApplicationDetails(params, true)}>{params.row.pan}</Link>;
    //   },
    // },
    {
      field: "karmaPartner",
      headerName: "Partner",
      width: 60,
      sortable: false,
      editable: false,
      renderCell: (params) => {
        return <Tooltip title={params.row.karmaPartner}><Link className="in-clickable" onClick={() => handleApplicationDetails(params, true)}>{params.row.karmaPartner}</Link>
        </Tooltip>;
      },
    },
    {
      field: "iDate",
      headerName: "Inward Date",
      width: 100,
      sortable: false,
      editable: false,
      renderCell: (params) => {
        return <Tooltip title={params.row.idate}>
          <Link className="in-clickable" onClick={() => handleApplicationDetails(params, true)}>{params.row.idate}</Link>
          </Tooltip>;
      },
    },
    {
      field: "asstSought",
      headerName: "Sanction Amount",
      sortable: true,
      width: 100,
      renderCell: (params) => {
        return <Tooltip title={params.row.asstSought}>
          <Link onClick={() => handleApplicationDetails(params, true)} className="in-clickable">{params.row.asstSought}</Link>
          </Tooltip>;
      },
    },
    {
      field: "applStatus",
      headerName: "Status",
      width: 170,
      sortable: true,
      renderCell: (params) => {
        return (
          <Link onClick={() => handleApplicationDetails(params, true)}>
            <Tooltip title={params.row.labelStatus}>
            <Chip
              label={params.row.labelStatus}
              size="small"
              className="table-chip"
              color={
                params.row.applStatus === "DISBURSED"
                  ? "success"
                  : params.row.applStatus === "DFS_APPL_CREATED" ||
                    params.row.applStatus === "BRE_SUCCESS" ||
                    params.row.applStatus === "SANCTIONED" ||
                    params.row.applStatus === "LOAN_ACCT_CREATED"
                    ? "warning"
                    : params.row.applStatus === "SANCTION_FAILED" ||
                      params.row.applStatus === "BRE_FAILED" ||
                      params.row.applStatus === "ESIGN_NOT_AFFIXED" ||
                      params.row.applStatus === "KYC_VERIFICATION_FAILED"
                      ? "error"
                      : "primary"
              }
              variant="outlined"
            />
            </Tooltip>
          </Link>
        );
      },
    },
  ];

  // rejected
  const [rejectedColumns, setRejectedColumns] = useState([]);
  const [rejectModal, setRejectModal] = React.useState(false);
  const rejectModalOpen = () => setRejectModal(true);
  const rejectModalClose = () => setRejectModal(false);
  const [rejectedApplicationCount, setRejectedApplicationCount] = useState("0");
  // rejected end

  // pending
  const [pendingColumns, setPendingColumns] = useState([]);
  const [pendingModal, setPendingModal] = React.useState(false);
  const pendingModalOpen = () => setPendingModal(true);
  const pendingModalClose = () => setPendingModal(false);
  const [pendingApplicationCount, setPendingApplicationCount] = useState("0");
  // pending end

  //
  // total
  const [totalAppColumns, setTotalAppColumns] = useState([]);
  const [totalAppModal, setTotalAppModal] = React.useState(false);
  const totalAppModalOpen = () => setTotalAppModal(true);
  const totalAppModalClose = () => setTotalAppModal(false);
  const [totalAppApplicationCount, setTotalApplicationCount] = useState("0");
  // total end

  // completed
  const [completedColumns, setCompletedColumns] = useState([]);
  const [completedApplicationCount, setCompletedApplicationCount] =
    useState("0");
  const [openComplete, setCompleteOpen] = useState(false);
  const completeModalOpen = () => setCompleteOpen(true);
  const completeModalClose = () => setCompleteOpen(false);

  // completed end

  const [openSnacknar, setOpenSnacknar] = useState(false);
  const [snackMsg, setSnackMsg] = useState("");
  const [severity, setSeverity] = useState("success");
  const [loading, setloading] = useState(false);
  const handleSnackClose = () => {
    setOpenSnacknar(false);
  };

  // const [showTable, setTable] = useState(false);

  const handleTable = (code) => {
    switch (code) {
      case "01":
        getTotalApplication("Total Application");
        break;
      case "02":
        getApplicationData(code, "Under Process Application");
        break;
      case "03":
        getApplicationData(code, "Rejected Application");
        break;
      case "04":
        getApplicationData(code, "Completed Application");
        break;
      default:
      // code block
    }
  };

  const getTotalApplicationCount = () => {
    setloading(true);
    axios
      .get(`${base_url}/dash/getTotalApplication`)
      .then((res) => {
        if (res.data.status === 200 && res.data.result !== null) {
          setTotalApplicationCount(res.data.result);
        }
        setloading(false);
      })
      .catch((err) => {
        if (err.response === undefined) {
          setServerDown(true);
          setOpenSnacknar(true);
          setSnackMsg("Server is Down. Contact to support. !");
          setSeverity("error");
        } else {
          setloading(false);
        }
      });
  };

  const getUnderProcessCount = () => {
    setloading(true);
    axios
      .get(`${base_url}/dash/getPendingAppl`)
      .then((res) => {
        if (res.data.status === 200 && res.data.result !== null) {
          setPendingApplicationCount(res.data.result);
        }
        setloading(false);
      })
      .catch((err) => {
        if (err.response === undefined) {
          setServerDown(true);
          setOpenSnacknar(true);
          setSnackMsg("Server is Down. Contact to support. !");
          setSeverity("error");
        } else {
          setloading(false);
        }
      });
  };

  const getCompleteApplicationCount = () => {
    setloading(true);
    axios
      .get(`${base_url}/dash/getSubmittedAppl`)
      .then((res) => {
        if (res.data.status === 200 && res.data.result !== null) {
          setCompletedApplicationCount(res.data.result);
        }
        setloading(false);
      })
      .catch((err) => {
        if (err.response === undefined) {
          setServerDown(true);
          setOpenSnacknar(true);
          setSnackMsg("Server is Down. Contact to support. !");
          setSeverity("error");
        } else {
          setloading(false);
        }
      });
  };

  const getRejectedApplicationCount = () => {
    setloading(true);
    axios
      .get(`${base_url}/dash/getErrorAppl`)
      .then((res) => {
        if (res.data.status === 200 && res.data.result !== null) {
          setRejectedApplicationCount(res.data.result);
        }
        setloading(false);
      })
      .catch((err) => {
        if (err.response === undefined) {
          setServerDown(true);
          setOpenSnacknar(true);
          setSnackMsg("Server is Down. Contact to support. !");
          setSeverity("error");
        } else {
          setloading(false);
        }
      });
  };

  const getTotalApplication = (title, index) => {
    setloading(true);
    axios
      .get(`${base_url}/dash/getListOfAppl`)
      .then((res) => {
        if (res.data.status === 200 && res.data.result !== null) {
          const columnName = Object.keys(res.data.result);
          let getColumn = columnName.map((key, index) => {
            const column = res.data.result[key];
            return {
              id: +key + +1,
              loanReqid: column.loanReqid,
              inwardNo: column.inwardNo,
              state: column.state,
              asstntAmount: column.asstntAmount,
              pan: column.pan,
              idate: column.idate,
              asstSought: column.asstSought,
              acknow: column.acknow,
              borw: column.borw,
              karmaPartner: column.karmaPartner,
              applStatus: column.applStatus,
              labelStatus : column?.applStatus?.replace( /_/g, " " )
            };
          });
          setTableTitle(title);
          setTotalAppColumns(getColumn);
        }
        setloading(false);
      })
      .catch((err) => {
        if (err.response === undefined) {
          setServerDown(true);
          setOpenSnacknar(true);
          setSnackMsg("Server is Down. Contact to support. !");
          setSeverity("error");
        } else {
          setloading(false);
        }
      });
  };

  const filteredRows = totalAppColumns.filter((row) => {
    const dateVisible =
      (!startDate || new Date(row.idate) >= new Date(startDate)) &&
      (!endDate || new Date(row.idate) <= new Date(endDate));
    const stateVisible =
      selectedStates.length === 0 || selectedStates.includes(row.state);
    const partnerVisible =
      selectPartner.length === 0 || selectPartner.includes(row.karmaPartner);
    const loanReqVisible =
      typeof row.loanReqid === "string"
        ? row.loanReqid.toLowerCase().includes(searchText.toLowerCase())
        : false;

    const panVisible =
      typeof row.pan === "string"
        ? row.pan.toLowerCase().includes(searchText.toLowerCase())
        : false;

    const nameVisible =
      typeof row.borw === "string"
        ? row.borw.toLowerCase().includes(searchText.toLowerCase())
        : false;

    return (
      dateVisible &&
      stateVisible &&
      partnerVisible &&
      (loanReqVisible || panVisible || nameVisible)
    );
  });

  ///-->  Rejected-->
  const getApplicationData = (code, title) => {
    setloading(true);
    axios
      .get(`${base_url}/dash/getListOfApplStatusWise?status=${code}`)
      .then((res) => {
        if (res.data.status === 200 && res.data.result !== null) {
          const columnName = Object.keys(res.data.result);
          let getColumn = columnName.map((key, index) => {
            const column = res.data.result[key];
            return {
              id: +key + +1,
              loanReqid: column.loanReqid,
              inwardNo: column.inwardNo,
              // loanAcctNo: column.loanAcctNo,
              state: column.state,
              idate: column.idate,
              asstntAmount: column.asstntAmount,
              pan: column.pan,
              asstSought: column.asstSought,  
              acknow: column.acknow,
              applStatus: column.applStatus,
              labelStatus : column?.applStatus?.replace( /_/g, " " ),
              borw: column.borw,
              karmaPartner: column.karmaPartner,
            };
          });
          console.log("getColumn123", getColumn);
          setTableTitle(title);
          setTotalAppColumns(getColumn);
        }
        setloading(false);
      })
      .catch((err) => {
        if (err.response === undefined) {
          setServerDown(true);
          setOpenSnacknar(true);
          setSnackMsg("Server is Down. Contact to support. !");
          setSeverity("error");
        } else {
          setloading(false);
        }
      });
  };

  // completed
  const getCompletedApplication = () => {
    setloading(true);
    axios
      .get(`${base_url}/dash/getListOfApplStatusWise?status=04`)
      .then((res) => {
        if (res.data.status === 200 && res.data.result !== null) {
          setCompletedApplicationCount(res.data.result.length);
          const columnName = Object.keys(res.data.result);
          console.log("columnName12", columnName);
          let getColumn = columnName.map((key) => {
            const column = res.data.result[key];
            return {
              id: +key + +1,
              loanReqid: column.loanReqid,
              inwardNo: column.inwardNo,
              loanAcctNo: column.loanAcctNo,
              asstntAmount: column.asstntAmount,
              pan: column.pan,
              acknow: column.acknow,
              applStatus: column.applStatus,
            };
          });
          console.log("getColumn123", getColumn);
          setTotalAppColumns(getColumn);
        }
        setloading(false);
      })
      .catch((err) => {
        if (err.response === undefined) {
          setServerDown(true);
          setOpenSnacknar(true);
          setSnackMsg("Server is Down. Contact to support. !");
          setSeverity("error");
        } else {
          setloading(false);
        }
      });
  };

  // pending

  const getPendingApplication = () => {
    setloading(true);
    axios
      .get(`${base_url}/dash/getListOfApplStatusWise?status=02`)
      .then((res) => {
        if (res.data.status === 200 && res.data.result !== null) {
          setPendingApplicationCount(res.data.result.length);
          const columnName = Object.keys(res.data.result);
          console.log("columnName12", columnName);
          let getColumn = columnName.map((key) => {
            const column = res.data.result[key];
            return {
              id: +key + +1,
              loanReqid: column.loanReqid,
              inwardNo: column.inwardNo,
              loanAcctNo: column.loanAcctNo,
              asstntAmount: column.asstntAmount,
              pan: column.pan,
              acknow: column.acknow,
              applStatus: column.applStatus,
            };
          });
          console.log("getColumn123", getColumn);
          setTotalAppColumns(getColumn);
        }
        setloading(false);
      })
      .catch((err) => {
        if (err.response === undefined) {
          setServerDown(true);
          setOpenSnacknar(true);
          setSnackMsg("Server is Down. Contact to support. !");
          setSeverity("error");
        } else {
          setloading(false);
        }
      });
  };

  useEffect(() => {
    getTotalApplication("Total Application");
    getTotalApplicationCount();
    getUnderProcessCount();
    getRejectedApplicationCount();
    getCompleteApplicationCount();
  }, []);

  const handleShowDeleteModal = (id) => {
    setShowDeleteModal(true);
    setDeleteId(id);
  };

  const handleDeleteClose = (status, reason, id) => {
    if (reason !== "backdropClick") {
      setShowDeleteModal(false);
    }
    if (status) {
      handleNewAppDelete(id);
    }
  };

  const handleNewAppDelete = (cdaAppId) => {
    setloading(true);
    axios
      .delete(`${base_url}/deleteNewApplication?cdaAppId=` + cdaAppId)
      .then((res) => {
        if (res.data.status === 200) {
          setOpenSnacknar(true);
          setSnackMsg("Record has been deleted !");
          setSeverity("success");
          // getNewApplication();
          setloading(false);
        }
      })
      .catch((err) => {
        setOpenSnacknar(true);
        setSnackMsg("Something went wrong !");
        setSeverity("error");
        setloading(false);
      });
  };

  const handleModelViewClose = (status) => {
    setShowViewModal(false);
  };

  const handleReset = () => {
    setEndDate(null);
    setStartDate(null);
    setSearchText("");
    setSelectedStates("");
    setSelectPartner("");
  };

  const handleApplicationDetails = (data, newOpen) => {
    setData(data);
    setDrawerOpen(newOpen);
  }

  const copyClipboard = (loanId) =>{
    navigator.clipboard.writeText(loanId);
    setOpenSnacknar(true);
    setSnackMsg("Copy LoanId : " + loanId);
    setSeverity("success");
  }

  return (
    <>
      <Grid container spacing={2}>
        <Grid className="py-0 pb-2" item xs={8}>
          <Typography noWrap variant="subtitle1" component="div">
            Dashboard
          </Typography>
        </Grid>
        <Grid
          className="py-0 pb-2"
          item
          xs={4}
          display="flex"
          justifyContent="end"
        ></Grid>
      </Grid>
      <Grid container rowSpacing={4.5} columnSpacing={2.75}>
        <Grid item xs={12} sm={6} md={3} lg={3}>
          <Card
            onClick={() => handleTable("01")}
            className={
              tableTitle === "Total Application"
                ? "customize-card total_application opend-box show-box"
                : "customize-card total_application opend-box"
            }
            sx={{ maxWidth: 345 }}
          >
            {loading ? (
              <Skeleton animation="wave" variant="rectangular" height={80} />
            ) : (
              <>
                {" "}
                <CardContent className="pb-3">
                  <Typography
                    gutterBottom
                    variant="h5"
                    component="div"
                    className="wrap-header-title"
                  >
                    Total Application
                  </Typography>
                  <Typography variant="body2" className="wrap-subtitle">
                    {totalAppApplicationCount}
                  </Typography>
                </CardContent>
                {/* <CardActions>
                  <Button
                    disabled={totalAppApplicationCount <= 0}
                    className="text-capital px-2"
                    onClick={() => handleTable("01")}
                    size="small"
                  >
                    See More
                  </Button>
                </CardActions> */}
              </>
            )}
          </Card>
        </Grid>
        <Grid item xs={12} sm={6} md={3} lg={3}>
          <Card
            onClick={() => handleTable("04")}
            className={
              tableTitle === "Completed Application"
                ? "customize-card completed opend-box show-box"
                : "customize-card completed opend-box"
            }
            sx={{ maxWidth: 345 }}
          >
            {loading ? (
              <Skeleton animation="wave" variant="rectangular" height={80} />
            ) : (
              <>
                <CardContent className="pb-3">
                  <Typography
                    gutterBottom
                    variant="h5"
                    component="div"
                    className="wrap-header-title"
                  >
                    Completed Application
                  </Typography>
                  <Typography variant="body2" className="wrap-subtitle">
                    {completedApplicationCount}
                  </Typography>
                </CardContent>
                {/* <CardActions>
                  <Button
                    disabled={completedApplicationCount <= 0}
                    className="text-capital px-2"
                    
                    size="small"
                  >
                    See More
                  </Button>
                </CardActions> */}
              </>
            )}
          </Card>
        </Grid>
        <Grid item xs={12} sm={6} md={3} lg={3}>
          <Card
            onClick={() => handleTable("02")}
            className={
              tableTitle === "Under Process Application"
                ? "customize-card Under-Process opend-box show-box"
                : "customize-card Under-Process opend-box"
            }
            sx={{ maxWidth: 345 }}
          >
            {loading ? (
              <Skeleton animation="wave" variant="rectangular" height={80} />
            ) : (
              <>
                <CardContent className="pb-3">
                  <Typography
                    gutterBottom
                    variant="h5"
                    component="div"
                    className="wrap-header-title"
                  >
                    Under Process Application
                  </Typography>
                  <Typography variant="body2" className="wrap-subtitle">
                    {pendingApplicationCount}
                  </Typography>
                </CardContent>
                {/* <CardActions>
                  <Button
                    disabled={pendingApplicationCount <= 0}
                    className="text-capital px-2"
                    size="small"
                  >
                    See More
                  </Button>
                </CardActions> */}
              </>
            )}
          </Card>
        </Grid>
        <Grid item xs={12} sm={6} md={3} lg={3}>
          <Card
            onClick={() => handleTable("03")}
            className={
              tableTitle === "Rejected Application"
                ? "customize-card rejected opend-box show-box"
                : "customize-card rejected opend-box"
            }
            sx={{ maxWidth: 345 }}
          >
            {loading ? (
              <Skeleton animation="wave" variant="rectangular" height={80} />
            ) : (
              <>
                <CardContent className="pb-3">
                  <Typography
                    gutterBottom
                    variant="h5"
                    component="div"
                    className="wrap-header-title"
                  >
                    Rejected Application
                  </Typography>
                  <Typography variant="body2" className="wrap-subtitle">
                    {rejectedApplicationCount}
                  </Typography>
                </CardContent>
                {/* <CardActions>
                  <Button
                    disabled={rejectedApplicationCount <= 0}
                    className="text-capital px-2"
                   
                    size="small"
                  >
                    See More
                  </Button>
                </CardActions> */}
              </>
            )}
          </Card>
        </Grid>
      </Grid>

      <Grid container spacing={2} className="my-3">
        <Grid className="py-0 pb-2" item xs={8}>
          <Typography noWrap variant="subtitle1" component="div">
            {tableTitle}
          </Typography>
        </Grid>
      </Grid>

      <Card className="customize-card px-3 py-4 my-2">
        {loading ? (
          <Skeleton animation="wave" variant="rectangular" height={300} />
        ) : (
          <>
            <div
              className="custome-form"
              style={{
                display: "flex",
                alignItems: "center",
                marginBottom: "16px",
                "& > *": {
                  marginRight: "16px",
                },
              }}
            >
              <DatePicker
                label="Start Date"
                value={startDate}
                onChange={(newValue) => setStartDate(newValue)}
                renderInput={(params) => <TextField {...params} />}
                inputFormat="DD/MM/YYYY"
                mask="__/__/____"
                className="wrap-custome-picker"
                sx={{ marginRight: "10px" }}
              />
              <DatePicker
                label="End Date"
                value={endDate}
                onChange={(newValue) => setEndDate(newValue)}
                renderInput={(params) => <TextField {...params} />}
                inputFormat="DD/MM/YYYY"
                mask="__/__/____"
                className="wrap-custome-picker"
                sx={{ marginRight: "10px" }}
              />
              {/* <TextField
                label="Start Date"
                type="date"
                value={startDate}
                size="small"
                onChange={(e) => setStartDate(e.target.value)}
                InputLabelProps={{
                  shrink: true,
                }}
                sx={{ height: "40px", width: "250px", margin: "10px" }}
              />
              <TextField
                label="End Date"
                type="date"
                size="small"
                value={endDate}
                onChange={(e) => setEndDate(e.target.value)}
                InputLabelProps={{
                  shrink: true,
                }}
                sx={{ height: "40px", width: "250px", margin: "10px" }}
              /> */}
              <FormControl sx={{ width: "230px" }}>
                <InputLabel className="select-label" id="state1">
                  State
                </InputLabel>
                <Select
                  labelId="state1"
                  value={selectedStates}
                  placeholder="State"
                  label="State"
                  onChange={(e) => setSelectedStates(e.target.value)}
                  size="small"
                  sx={{ marginRight: "10px" }}
                // renderValue={(selected) => selected.join(", ")}
                >
                  {/* <MenuItem key="" value="">
                  {" "}
                  Select State
                </MenuItem> */}
                  {states.map((state) => (
                    <MenuItem key={state.stateCode} value={state.stateName}>
                      {state.stateName}
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>

              <FormControl sx={{ width: "230px" }}>
                <InputLabel className="select-label" id="partner">
                  Partner
                </InputLabel>
                <Select
                  labelId="partner"
                  value={selectPartner}
                  placeholder="Partner"
                  label="Partner"
                  onChange={(e) => setSelectPartner(e.target.value)}
                  size="small"
                  sx={{ marginRight: "10px" }}
                >
                  {partners.map((partner) => (
                    <MenuItem
                      key={partner.partnerCode}
                      value={partner.partnerName}
                    >
                      {partner.partnerName}
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>

              <TextField
                label="Search"
                value={searchText}
                size="small"
                onChange={(e) => setSearchText(e.target.value)}
                sx={{ height: "40px", marginRight: "10px" }}
              />
              <Button
                variant="contained"
                size="small"
                className="text-capital inner-link-btn btn-with-icon"
                onClick={handleReset}
              >
                Reset
              </Button>
            </div>
            <div style={{ width: "100%" }}>
              <DataGrid
                className="custom-grid-table not-show-header-option on-row-selection"
                rows={filteredRows}
                columns={commonGridColumns}
                initialState={{
                  pagination: {
                    paginationModel: { page: 0, pageSize: 10 },
                  },
                }}
                pageSizeOptions={[10, 20]}
              />
            </div>
          </>
        )}
      </Card>

      <DeleteModel
        show={showDeleteModal}
        handleDeleteClose={handleDeleteClose}
        deleteId={deleteId}
      />
      <CdaSnackbar
        open={openSnacknar}
        msg={snackMsg}
        severity={severity}
        handleSnackClose={handleSnackClose}
      />
      <ViewReportModel
        show={showViewModal}
        reportData={reportData}
        handleModelViewClose={handleModelViewClose}
      />
      {openDrawer ? 
       <Sidebar openDrawer={openDrawer} getdata={appData} handleCloseSidebar={handleApplicationDetails} />
       : ''}

    </>
  );
}

export default Dashboard;
