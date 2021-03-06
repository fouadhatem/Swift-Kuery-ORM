import XCTest

@testable import SwiftKueryORM
import Foundation
import KituraContracts

class TestTable: XCTestCase {
    static var allTests: [(String, (TestTable) -> () throws -> Void)] {
        return [
            ("testCreateTable", testCreateTable),
            ("testDropTable", testDropTable),
            ("testCreateTableWithFieldAsId", testCreateTableWithFieldAsId),
            ("testCreateTableWithCustomIdNameAndType", testCreateTableWithCustomIdNameAndType),
        ]
    }

    struct User: Model {
        var username: String
        var password: String
    }

    /**
      Testing that the correct SQL Query is created to create a table
    */
    func testCreateTable() {
        let connection: TestConnection = createConnection(.returnEmpty)
        Database.default = Database(single: connection)
        performTest(asyncTasks: { expectation in
            User.createTable { result, error in
                XCTAssertNil(error, "Table Creation Failed: \(String(describing: error))")
                XCTAssertNotNil(connection.raw, "Table Creation Failed: Query is nil")
                if let raw = connection.raw {
                let expectedQuery = "CREATE TABLE \"Users\" (\"username\" type NOT NULL, \"password\" type NOT NULL, \"id\" type AUTO_INCREMENT PRIMARY KEY)"
                  XCTAssertEqual(raw, expectedQuery, "Table Creation Failed: Invalid query")
                }
                expectation.fulfill()
            }
        })
    }

    /**
     Testing that the correct SQL Query is created to create a table when using a non-default database
     */
    func testCreateTableUsingDB() {
        let connection: TestConnection = createConnection(.returnEmpty)
        let db = Database(single: connection)
        performTest(asyncTasks: { expectation in
            User.createTable(using: db) { result, error in
                XCTAssertNil(error, "Table Creation Failed: \(String(describing: error))")
                XCTAssertNotNil(connection.raw, "Table Creation Failed: Query is nil")
                if let raw = connection.raw {
                    let expectedQuery = "CREATE TABLE \"Users\" (\"username\" type NOT NULL, \"password\" type NOT NULL, \"id\" type AUTO_INCREMENT PRIMARY KEY)"
                    XCTAssertEqual(raw, expectedQuery, "Table Creation Failed: Invalid query")
                }
                expectation.fulfill()
            }
        })
    }

    /**
      Testing that the correct SQL Query is created to drop a table
    */
    func testDropTable() {
        let connection: TestConnection = createConnection(.returnEmpty)
        Database.default = Database(single: connection)
        performTest(asyncTasks: { expectation in
            User.dropTable { result, error in
                XCTAssertNil(error, "Table Drop Failed: \(String(describing: error))")
                XCTAssertNotNil(connection.query, "Table Drop Failed: Query is nil")
                if let query = connection.query {
                  let expectedQuery = "DROP TABLE \"Users\""
                  let resultQuery = connection.descriptionOf(query: query)
                  XCTAssertEqual(resultQuery, expectedQuery, "Table Drop Failed: Invalid query")
                }
                expectation.fulfill()
            }
        })
    }

    /**
     Testing that the correct SQL Query is created to drop a table when using a non-default database
     */
    func testDropTableUsingDB() {
        let connection: TestConnection = createConnection(.returnEmpty)
        let db = Database(single: connection)
        performTest(asyncTasks: { expectation in
            User.dropTable(using: db) { result, error in
                XCTAssertNil(error, "Table Drop Failed: \(String(describing: error))")
                XCTAssertNotNil(connection.query, "Table Drop Failed: Query is nil")
                if let query = connection.query {
                    let expectedQuery = "DROP TABLE \"Users\""
                    let resultQuery = connection.descriptionOf(query: query)
                    XCTAssertEqual(resultQuery, expectedQuery, "Table Drop Failed: Invalid query")
                }
                expectation.fulfill()
            }
        })
    }

    struct Meal: Model {
        static var idColumnName = "name"
        var name: String
        var rating: Int
    }

    /**
      Testing that the correct SQL Query is created to create a table with the field as the PRIMARY KEY of the table
    */
    func testCreateTableWithFieldAsId() {
        let connection: TestConnection = createConnection(.returnEmpty)
        Database.default = Database(single: connection)
        performTest(asyncTasks: { expectation in
            Meal.createTable { result, error in
                XCTAssertNil(error, "Table Creation Failed: \(String(describing: error))")
                XCTAssertNotNil(connection.raw, "Table Creation Failed: Query is nil")
                if let raw = connection.raw {
                    let expectedQuery = "CREATE TABLE \"Meals\" (\"name\" type PRIMARY KEY NOT NULL, \"rating\" type NOT NULL)"
                    XCTAssertEqual(raw, expectedQuery, "Table Creation Failed: Invalid query")
                }
                expectation.fulfill()
            }
        })
    }

    struct Grade: Model {
        static var idColumnName = "MyId"
        static var idColumnType: SQLDataType.Type = Int64.self
        var grade: Double
        var course: String
    }

    /**
      Testing that the correct SQL Query is created to create a table with the PRIMARY KEY having a specific name and type
    */
    func testCreateTableWithCustomIdNameAndType() {
        let connection: TestConnection = createConnection(.returnEmpty)
        Database.default = Database(single: connection)
        performTest(asyncTasks: { expectation in
            Grade.createTable { result, error in
                XCTAssertNil(error, "Table Creation Failed: \(String(describing: error))")
                XCTAssertNotNil(connection.raw, "Table Creation Failed: Query is nil")
                if let raw = connection.raw {
                    let expectedQuery = "CREATE TABLE \"Grades\" (\"grade\" type NOT NULL, \"course\" type NOT NULL, \"MyId\" type AUTO_INCREMENT PRIMARY KEY)"
                    XCTAssertEqual(raw, expectedQuery, "Table Creation Failed: Invalid query")
                }
                expectation.fulfill()
            }
        })
    }
}
