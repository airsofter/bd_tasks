WITH RECURSIVE Subordinates AS (
    SELECT EmployeeID, Name, ManagerID, DepartmentID, RoleID
    FROM Employees
    WHERE EmployeeID = 1
    
    UNION ALL
    
    SELECT e.EmployeeID, e.Name, e.ManagerID, e.DepartmentID, e.RoleID
    FROM Employees e
    JOIN Subordinates s ON e.ManagerID = s.EmployeeID
),
EmployeeDetails AS (
    SELECT
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        d.DepartmentName,
        r.RoleName,
        e.DepartmentID,
        e.RoleID
    FROM Subordinates s
    JOIN Employees e ON e.EmployeeID = s.EmployeeID
    JOIN Departments d ON e.DepartmentID = d.DepartmentID
    JOIN Roles r ON e.RoleID = r.RoleID
),
ProjectsAndTasks AS (
    SELECT
        t.AssignedTo,
        STRING_AGG(DISTINCT p.ProjectName, ', ') AS project_names,
        STRING_AGG(DISTINCT t.TaskName, ', ') AS task_names,
        COUNT(t.TaskID) AS total_tasks
    FROM Tasks t
    LEFT JOIN Projects p ON t.ProjectID = p.ProjectID
    GROUP BY t.AssignedTo
),
SubordinateCount AS (
    SELECT
        e.ManagerID,
        COUNT(*) AS subordinate_count
    FROM Employees e
    GROUP BY e.ManagerID
)

SELECT
    ed.EmployeeID as employee_id,
    ed.Name,
    ed.ManagerID as manager_id,
    ed.DepartmentName as department_name,
    ed.RoleName as role_name,
    pat.project_names,
    pat.task_names,
    pat.total_tasks,
    sc.subordinate_count
FROM EmployeeDetails ed
LEFT JOIN ProjectsAndTasks pat ON ed.EmployeeID = pat.AssignedTo
LEFT JOIN SubordinateCount sc ON ed.EmployeeID = sc.ManagerID
ORDER BY ed.Name;
