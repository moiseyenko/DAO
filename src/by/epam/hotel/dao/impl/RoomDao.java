package by.epam.hotel.dao.impl;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.LinkedList;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import by.epam.hotel.dao.AbstractDao;
import by.epam.hotel.dao.DaoFieldType;
import by.epam.hotel.dao.exception.DaoException;
import by.epam.hotel.entity.ClassRoomType;
import by.epam.hotel.entity.Room;

public class RoomDao extends AbstractDao<Integer, Room> {
	private static final Logger LOG = LogManager.getLogger(RoomDao.class);
	private final String FIND_ALL = "SELECT `room`.`number`, `room`.`class`, `room`.`capacity`,\\r\\n\"\r\n"
			+ "			+ \"`room`.`price`, `room`.`removed` FROM `room`;";
	private final String INSERT_ROOM = "INSERT INTO `hotel`.`room` (`number`, `class`, `capacity`, `price`) VALUE\r\n"
			+ "(?,?, ?, ?);";
	private final String FIND_ROOM_BY_ID = "SELECT `room`.`number`, `room`.`class`, `room`.`capacity`, "
			+ "			+ `room`.`price`, `room`.`removed` FROM `room` WHERE `room`.`number` = ?;";
	private final String DELETE_ROOM = "DELETE FROM `room` WHERE `room`.`number` = ?;";
	private final String UPDATE_ROOM = "UPDATE `room` SET `room`.`class` = ?, "
			+ "`room`.`capacity` = ?, `room`.`price` = ? WHERE `room`.`number` = ?;";
	private final String CHANGE_REMOVED = "UPDATE `room` SET `room`.`removed` = ? WHERE `room`.`number` = ?;";

	@Override
	public List<Room> findAll() throws DaoException {
		List<Room> rooms = new LinkedList<>();
		try {
			try (Statement statement = connection.createStatement()) {
				ResultSet result = statement.executeQuery(FIND_ALL);
				while (result.next()) {
					int number = result.getInt(DaoFieldType.NUMBER.getField());
					String roomClass = result.getString(DaoFieldType.CLASS.getField());
					int capasity = result.getInt(DaoFieldType.PRICE.getField());
					BigDecimal price = result.getBigDecimal(DaoFieldType.PRICE.getField());
					boolean removed = result.getBoolean(DaoFieldType.REMOVED.getField());
					rooms.add(new Room(number, ClassRoomType.fromValue(roomClass), capasity, price, removed));
				}
			}
		} catch (SQLException e) {
			for (Throwable exc : e) {
				LOG.error("Finding all rooms error: {}", exc);
				throw new DaoException("Finding all rooms error", exc);
			}
		}
		return rooms;
	}

	@Override
	public Room findEntityById(Integer id) throws DaoException {
		try {
			try (PreparedStatement statement = connection.prepareStatement(FIND_ROOM_BY_ID)) {
				statement.setInt(1, id);
				ResultSet result = statement.executeQuery();
				if (result.next()) {
					String roomClass = result.getString(DaoFieldType.CLASS.getField());
					int capasity = result.getInt(DaoFieldType.PRICE.getField());
					BigDecimal price = result.getBigDecimal(DaoFieldType.PRICE.getField());
					boolean removed = result.getBoolean(DaoFieldType.REMOVED.getField());
					return new Room(id, ClassRoomType.fromValue(roomClass), capasity, price, removed);
				}
			}
		} catch (SQLException e) {
			for (Throwable exc : e) {
				LOG.error("Finding room error: {}", exc);
				throw new DaoException("Finding room error", exc);
			}
		}
		return null;
	}

	@Override
	public boolean delete(Integer id) throws DaoException {
		try {
			try (PreparedStatement statement = connection.prepareStatement(DELETE_ROOM)) {
				statement.setInt(1, id);
				if (statement.executeUpdate() > 0) {
					return true;
				}
			}
		} catch (SQLException e) {
			for (Throwable exc : e) {
				LOG.error("Deletion room error: {}", exc);
				throw new DaoException("Deletion room error", exc);
			}
		}
		return false;
	}

	@Override
	public boolean delete(Room room) throws DaoException {
		try {
			try (PreparedStatement statement = connection.prepareStatement(DELETE_ROOM)) {
				statement.setInt(1, room.getNumber());
				if (statement.executeUpdate() > 0) {
					return true;
				}
			}
		} catch (SQLException e) {
			for (Throwable exc : e) {
				LOG.error("Deletion room error: {}", exc);
				throw new DaoException("Deletion room error", exc);
			}
		}
		return false;
	}

	@Override
	public boolean create(Room room) throws DaoException {
		try {
			try (PreparedStatement statement = connection.prepareStatement(INSERT_ROOM)) {
				statement.setInt(1, room.getNumber());
				statement.setString(2, room.getClassRoom().getName());
				statement.setInt(3, room.getCapacity());
				statement.setBigDecimal(4, room.getPrice());
				if (statement.executeUpdate() > 0) {
					return true;
				}
			}
		} catch (SQLException e) {
			for (Throwable exc : e) {
				LOG.error("Creation room error: {}", exc);
				throw new DaoException("Creation room error", exc);
			}
		}
		return false;
	}

	@Override
	public boolean update(Room room) throws DaoException {
		try {
			try (PreparedStatement statement = connection.prepareStatement(UPDATE_ROOM)) {
				statement.setString(1, room.getClassRoom().getName());
				statement.setInt(2, room.getCapacity());
				statement.setBigDecimal(3, room.getPrice());
				statement.setInt(4, room.getNumber());
				if (statement.executeUpdate() > 0) {
					return true;
				}
			}
		} catch (SQLException e) {
			for (Throwable exc : e) {
				LOG.error("Update room error: {}", exc);
				throw new DaoException("Update room error", exc);
			}
		}
		return false;
	}

	@Override
	public boolean changeRemoved(Room entity) throws DaoException {
		try {
			try (PreparedStatement statement = connection.prepareStatement(CHANGE_REMOVED)) {
				statement.setInt(1, (entity.isRemoved() ? 0 : 1));
				statement.setInt(2, entity.getNumber());
				if (statement.executeUpdate() > 0) {
					return true;
				}
			}
		} catch (SQLException e) {
			for (Throwable exc : e) {
				LOG.error("Change room removed flag error: {}", exc);
				throw new DaoException("Change room removed flag error", exc);
			}
		}
		return false;
	}

}
