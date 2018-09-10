package by.epam.hotel.dao;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import by.epam.hotel.pool.ConnectionPool;

public class TransactionHelper {
	private static final Logger LOG = LogManager.getFormatterLogger(TransactionHelper.class);
	private Connection connection = ConnectionPool.getInstance().getConnection();
	private List<AbstractDao<?, ?>> daoList = new LinkedList<>();

	public void beginTransaction(AbstractDao<?, ?> dao, AbstractDao<?, ?>... daos) {
		try {
			connection.setAutoCommit(false);
		} catch (SQLException e) {
			for (Throwable exc : e) {
				LOG.error(exc);
			}
		}
		dao.setConnection(connection);
		daoList.add(dao);
		for (AbstractDao<?, ?> daoEntity : daos) {
			daoEntity.setConnection(connection);
			daoList.add(daoEntity);
		}
	}

	public void endTransaction() {
		for (AbstractDao<?, ?> dao : daoList) {
			dao.setConnection(null);
		}
		daoList.clear();
		ConnectionPool.getInstance().releaseConnection(connection);
	}

	public void commit() {
		try {
			connection.commit();
		} catch (SQLException e) {
			for (Throwable exc : e) {
				LOG.error(exc);
			}
		}
	}

	public void rollback() {
		try {
			connection.rollback();
		} catch (SQLException e) {
			for (Throwable exc : e) {
				LOG.error(exc);
			}
		}
	}
}
