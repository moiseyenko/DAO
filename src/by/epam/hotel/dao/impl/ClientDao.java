package by.epam.hotel.dao.impl;

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
import by.epam.hotel.entity.Client;

public class ClientDao extends AbstractDao<Integer, Client> {

	private static final Logger LOG = LogManager.getLogger(ClientDao.class);

	private static final String FIND_CLIENT = "SELECT `client`.`id`, `client`.`first_name`, `client`.`last_name`, "
			+ "`client`.`passport`, `client`.`nationality_id`, `client`.`removed` "
			+ "FROM `client` "
			+ "WHERE `client`.`first_name` = ? AND `client`.`last_name` = ? AND `client`.`passport` = ? "
			+ "AND `client`.`nationality_id` = ?;";
	private static final String FIND_CLIENT_BY_ID = "SELECT `client`.`id`, `client`.`first_name`, `client`.`last_name`, "
			+ "`client`.`passport`, `client`.`nationality_id`, `client`.`removed` "
			+ "FROM `client`" 
			+ "WHERE `client`.`id` = ?;";
	private static final String DELETE_CLIENT = "DELETE FROM `client` WHERE `client`.`id` = ?;";
	private static final String INSERT_CLIENT = "INSERT INTO`hotel`.`client`(`first_name`,`last_name`, `passport`, `nationality_id`) "
			+ "VALUE (?, ?, ?, ?);";
	private static final String UPDATE_CLIENT = "UPDATE `hotel`.`client` SET `client`.`first_name` = ?, `client`.`last_name` = ?, "
			+ "`client`.`passport` = ?,`client`.`nationality_id` = ? "
			+ "WHERE `client`.`id` = ?;";
	private static final String FIND_ALL = "SELECT `client`.`id`, `client`.`first_name`, `client`.`last_name`, "
			+ "`client`.`passport`, `client`.`nationality_id`, `client`.`removed` "
			+ "FROM `client`;";
	private final String CHANGE_REMOVED = "UPDATE `client` SET `client`.`removed` = ? " + "WHERE `client`.`id` = ?;";

	@Override
	public List<Client> findAll() throws DaoException {
		List<Client> clients = new LinkedList<>();
		try {
			try (Statement statement = connection.createStatement()) {
				ResultSet result = statement.executeQuery(FIND_ALL);
				while (result.next()) {
					int id = result.getInt(DaoFieldType.ID.getField());
					String first_name = result.getString(DaoFieldType.FIRST_NAME.getField());
					String last_name = result.getString(DaoFieldType.LAST_NAME.getField());
					String passport = result.getString(DaoFieldType.PASSPORT.getField());
					String nationality_id = result.getString(DaoFieldType.NATIONALITY_ID.getField());
					boolean removed = result.getBoolean(DaoFieldType.REMOVED.getField());
					clients.add(new Client(id, first_name, last_name, passport, nationality_id, removed));
				}
			}
		} catch (SQLException e) {
			for (Throwable exc : e) {
				LOG.error("Finding all clients error: {}", exc);
				throw new DaoException("Finding all clients error", exc);
			}
		}
		return clients;
	}
	
	@Override
	public Client findEntityById(Integer id) throws DaoException {
		try {
			try (PreparedStatement statement = connection.prepareStatement(FIND_CLIENT_BY_ID)) {
				statement.setInt(1, id);
				ResultSet result = statement.executeQuery();
				if (result.next()) {
					String first_name = result.getString(DaoFieldType.FIRST_NAME.getField());
					String last_name = result.getString(DaoFieldType.LAST_NAME.getField());
					String passport = result.getString(DaoFieldType.PASSPORT.getField());
					String nationality_id = result.getString(DaoFieldType.NATIONALITY_ID.getField());
					boolean removed = result.getBoolean(DaoFieldType.REMOVED.getField());
					return new Client(id, first_name, last_name, passport, nationality_id, removed);
				}
			}
		} catch (SQLException e) {
			for (Throwable exc : e) {
				LOG.error("Finding client error: {}", exc);
				throw new DaoException("Finding client error", exc);
			}
		}
		return null;
	}

	@Override
	public boolean delete(Integer id) throws DaoException {
		try {
			try (PreparedStatement statement = connection.prepareStatement(DELETE_CLIENT)) {
				statement.setInt(1, id);
				if (statement.executeUpdate() > 0) {
					return true;
				}
			}
		} catch (SQLException e) {
			for (Throwable exc : e) {
				LOG.error("Deletion client error: {}", exc);
				throw new DaoException("Deletion client error", exc);
			}
		}
		return false;
	}
	
	@Override
	public boolean delete(Client entity) throws DaoException {
		try {
			try (PreparedStatement statement = connection.prepareStatement(DELETE_CLIENT)) {
				statement.setInt(1, entity.getId());
				if (statement.executeUpdate() > 0) {
					return true;
				}
			}
		} catch (SQLException e) {
			for (Throwable exc : e) {
				LOG.error("Deletion client error: {}", exc);
				throw new DaoException("Deletion client error", exc);
			}
		}
		return false;
	}

	@Override
	public boolean create(Client entity) throws DaoException {
		try {
			try (PreparedStatement statement = connection.prepareStatement(INSERT_CLIENT)) {
				statement.setString(1, entity.getFirstName());
				statement.setString(2, entity.getLastName());
				statement.setString(3, entity.getPassport());
				statement.setString(4, entity.getNationality());
				if (statement.executeUpdate() > 0) {
					return true;
				}
			}
		} catch (SQLException e) {
			for (Throwable exc : e) {
				LOG.error("Creation client error: {}", exc);
				throw new DaoException("Creation client error", exc);
			}
		}
		return false;
	}

	@Override
	public boolean update(Client entity) throws DaoException {
		try {
			try (PreparedStatement statement = connection.prepareStatement(UPDATE_CLIENT)) {
				statement.setString(1, entity.getFirstName());
				statement.setString(2, entity.getLastName());
				statement.setString(3, entity.getPassport());
				statement.setString(4, entity.getNationality());
				statement.setInt(5, entity.getId());
				if (statement.executeUpdate() > 0) {
					return true;
				}
			}
		} catch (SQLException e) {
			for (Throwable exc : e) {
				LOG.error("Update client error: {}", exc);
				throw new DaoException("Update client error", exc);
			}
		}
		return false;
	}

	@Override
	public boolean changeRemoved(Client entity) throws DaoException {
		try {
			try (PreparedStatement statement = connection.prepareStatement(CHANGE_REMOVED)) {
				statement.setInt(1, entity.isRemoved() ? 0 : 1);
				statement.setInt(2, entity.getId());
				if (statement.executeUpdate() > 0) {
					return true;
				}
			}
		} catch (SQLException e) {
			for (Throwable exc : e) {
				LOG.error("Change client removed flag error: {}", exc);
				throw new DaoException("Change client removed flag error", exc);
			}
		}
		return false;
	}
	
	public Client findClient(Client entity) throws DaoException {
		try {
			try (PreparedStatement statement = connection.prepareStatement(FIND_CLIENT)) {
				statement.setString(1, entity.getFirstName());
				statement.setString(2, entity.getLastName());
				statement.setString(3, entity.getPassport());
				statement.setString(4, entity.getNationality());
				ResultSet result = statement.executeQuery();
				if(result.next()) {
					return entity;
				}
			}
		} catch (SQLException e) {
			for (Throwable exc : e) {
				LOG.error("Finding client error: {}", exc);
				throw new DaoException("Finding client error", exc);
			}
		}
		return null;
	}
}
