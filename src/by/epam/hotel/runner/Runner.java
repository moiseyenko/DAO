package by.epam.hotel.runner;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.LinkedList;
import java.util.List;

import by.epam.hotel.dao.DaoFieldType;
import by.epam.hotel.dao.TransactionHelper;
import by.epam.hotel.dao.exception.DaoException;
import by.epam.hotel.dao.impl.AccountDao;
import by.epam.hotel.dao.impl.ClientDao;
import by.epam.hotel.dao.impl.NationalityDao;
import by.epam.hotel.dao.impl.OrderDao;
import by.epam.hotel.dao.impl.RoomDao;
import by.epam.hotel.entity.Account;
import by.epam.hotel.entity.ClassRoomType;
import by.epam.hotel.entity.Client;
import by.epam.hotel.entity.Nationality;
import by.epam.hotel.entity.Order;
import by.epam.hotel.entity.Room;

public class Runner {
	public static void main(String[] args) throws ParseException, DaoException {
		boolean i = false;
		boolean j = false;
		List<Account> list = new LinkedList<>();
		AccountDao accountDao = new AccountDao();
		ClientDao clientDao = new ClientDao();
		OrderDao orderDao = new OrderDao();
		RoomDao roomDao = new RoomDao();
		NationalityDao nationalityDao = new NationalityDao();
		TransactionHelper helper = new TransactionHelper();
		helper.beginTransaction(roomDao, orderDao, nationalityDao, clientDao, accountDao);
		//list = accountDao.findAll();
		//System.out.println(accountDao.findEntityById(150));
		//helper.beginTransaction(orderDao);
		//list = orderDao.findAll();
		//System.out.println(roomDao.create(new Room(57, ClassRoomType.BUSINESS, 100, new BigDecimal(1000))));
		Account oldACcount = accountDao.findEntityById(2);
		System.out.println(accountDao.update(new Account(oldACcount.getId(), "user", true)));
		/*Order order = orderDao.findEntityById(13);
		if(order != null) {
			System.out.println("order " + orderDao.changeRemoved(order));
		}
		Room room = roomDao.findEntityById(11);
		if(room != null) {
			System.out.println("room "+roomDao.changeRemoved(room));
		}*/
//		Client client = clientDao.findEntityById(1);
//		System.out.println(clientDao.update(new Client(client.getId(), "Лось", "Костыль", "у13", "BY", client.isRemoved())));
//		System.out.println(clientDao.changeRemoved(client));
		//update(client, clien1t));
				//create(new Room(51, ClassRoomType.BUSINESS, 100, new BigDecimal(1000))));
				//update(51, new Room(51, ClassRoomType.FAMILY, 5, new BigDecimal(200))));
				//isExistingRoom(6));
				//delete(new Room(51, null, 0, null)));
				//findAll();
		// System.out.println();

		// System.out.println(nationalitDao.findNationality("GB"));
		helper.commit();
		helper.endTransaction();
//		sSystem.out.println(LocalDate.parse("2018-02-21"));
//		for(Account item:list) {
//			System.out.println(item);
//		}
		//System.out.println(roomDao.create(new Room(59, ClassRoomType.BUSINESS, 100, new BigDecimal(1000))));
	}
}
