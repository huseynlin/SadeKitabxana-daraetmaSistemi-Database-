using System;
using System.Data;
using System.Data.SqlClient;

namespace SadeKitabxanaIdaraetmaSistemi_Database_.Helper
{
    public class Tools
    {
        private readonly string connectionstring = "Data Source=.;Initial Catalog=DB_BMU;Integrated Security=True;TrustServerCertificate=True";

        public DataTable ExecuteReader(string sql, params SqlParameter[] parameters)
        {
            DataTable dataTable = new DataTable();
            using (SqlConnection sqlConnection = new SqlConnection(connectionstring))
            using (SqlCommand sqlCommand = new SqlCommand(sql, sqlConnection))
            {
                if (parameters != null && parameters.Length > 0)
                {
                    sqlCommand.Parameters.AddRange(parameters);
                }

                sqlConnection.Open();
                using (var reader = sqlCommand.ExecuteReader())
                {
                    dataTable.Load(reader);
                }
            }

            return dataTable;
        }

        public int ExecuteNonQuery(string sql, params SqlParameter[] parameters)
        {
            using (SqlConnection sqlConnection = new SqlConnection(connectionstring))
            using (SqlCommand sqlCommand = new SqlCommand(sql, sqlConnection))
            {
                if (parameters != null && parameters.Length > 0)
                {
                    sqlCommand.Parameters.AddRange(parameters);
                }

                sqlConnection.Open();
                return sqlCommand.ExecuteNonQuery();
            }
        }

        public void EnsureSchema()
        {
            string sql = @"
IF OBJECT_ID('Books', 'U') IS NULL
BEGIN
    CREATE TABLE Books (
        BookID INT PRIMARY KEY IDENTITY(1,1),
        Title NVARCHAR(200) NOT NULL,
        Author NVARCHAR(100) NOT NULL,
        Year INT,
        Genre NVARCHAR(50)
    );
END
ELSE
BEGIN
    IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Books') AND name = 'Id')
    BEGIN
        EXEC sp_rename 'dbo.Books.Id', 'BookID', 'COLUMN';
    END
END

IF OBJECT_ID('Users', 'U') IS NULL
BEGIN
    CREATE TABLE Users (
        UserID INT PRIMARY KEY IDENTITY(1,1),
        Username NVARCHAR(50) UNIQUE NOT NULL,
        Password NVARCHAR(100) NOT NULL,
        Email NVARCHAR(100) NOT NULL
    );
END

IF (SELECT COUNT(*) FROM Books) = 0
BEGIN
    INSERT INTO Books (Title, Author, Year, Genre) 
    VALUES (N'The Great Gatsby', N'F. Scott Fitzgerald', 1925, N'Classic');
END
";

            try
            {
                ExecuteNonQuery(sql);
            }
            catch (Exception)
            {
                throw;
            }
        }
    }
}
