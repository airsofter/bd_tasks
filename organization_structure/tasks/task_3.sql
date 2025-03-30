WITH RECURSIVE Subordinates AS (
    SELECT EmployeeID, ManagerID
    FROM Employees
    WHERE ManagerID IS NOT NULL
    
    UNION ALL
    
    SELECT e.EmployeeID, e.ManagerID
    FROM Employees e
    JOIN Subordinates s ON e.ManagerID = s.EmployeeID
),
ManagerDetails AS (
    SELECT
        e.EmployeeID,
        e.Name AS EmployeeName,
        e.ManagerID,
        d.DepartmentName,
        r.RoleName,
        e.DepartmentID,
        e.RoleID,
        COUNT(s.EmployeeID) AS TotalSubordinates
    FROM Employees e
    JOIN Departments d ON e.DepartmentID = d.DepartmentID
    JOIN Roles r ON e.RoleID = r.RoleID
    LEFT JOIN Subordinates s ON e.EmployeeID = s.ManagerID
    WHERE r.RoleName = 'Менеджер'
    GROUP BY e.EmployeeID, e.Name, e.ManagerID, d.DepartmentName, r.RoleName, e.DepartmentID, e.RoleID
    HAVING COUNT(s.EmployeeID) > 0
),
ProjectsAndTasks AS (
    SELECT
        t.AssignedTo,
        STRING_AGG(DISTINCT p.ProjectName, ', ') AS ProjectNames,
        STRING_AGG(DISTINCT t.TaskName, ', ') AS TaskNames
    FROM Tasks t
    LEFT JOIN Projects p ON t.ProjectID = p.ProjectID
    GROUP BY t.AssignedTo
)

SELECT
    md.EmployeeID AS employee_id,
    md.EmployeeName AS employee_name,
    md.ManagerID AS manager_id,
    md.DepartmentName AS department_name,
    md.RoleName AS role_name,
    pat.ProjectNames AS project_names,
    pat.TaskNames AS task_names,
    md.TotalSubordinates AS total_subordinates
FROM ManagerDetails md
LEFT JOIN ProjectsAndTasks pat ON md.EmployeeID = pat.AssignedTo
ORDER BY md.EmployeeName;