package com.leavemanagement.model;

import java.sql.Date;
import java.sql.Timestamp;

public class Leave {
    private int leaveId;
    private int userId;
    private String reason;
    private String description;
    private Date startDate;
    private Date endDate;
    private String status;
    private Timestamp appliedAt;
    private String userName;

    public Leave() {}

    public int getLeaveId()                  { return leaveId; }
    public void setLeaveId(int leaveId)      { this.leaveId = leaveId; }

    public int getUserId()                   { return userId; }
    public void setUserId(int userId)        { this.userId = userId; }

    public String getReason()                { return reason; }
    public void setReason(String reason)     { this.reason = reason; }

    public String getDescription()                   { return description; }
    public void setDescription(String description)   { this.description = description; }

    public Date getStartDate()               { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }

    public Date getEndDate()                 { return endDate; }
    public void setEndDate(Date endDate)     { this.endDate = endDate; }

    public String getStatus()                { return status; }
    public void setStatus(String status)     { this.status = status; }

    public Timestamp getAppliedAt()                  { return appliedAt; }
    public void setAppliedAt(Timestamp appliedAt)    { this.appliedAt = appliedAt; }

    public String getUserName()                  { return userName; }
    public void setUserName(String userName)     { this.userName = userName; }
}