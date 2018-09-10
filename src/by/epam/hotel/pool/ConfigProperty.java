package by.epam.hotel.pool;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Properties;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class ConfigProperty {
	private static final Logger LOG = LogManager.getLogger(ConfigProperty.class);
	private static final String PROPS_PATH = "source/config.properties";

	public static Properties getProperties() {
		Properties properties = new Properties();
		try (FileInputStream input = new FileInputStream(new File(PROPS_PATH))) {
			properties.load(input);
		} catch (FileNotFoundException e) {
			LOG.fatal("Props file not found {}", e);
			throw new RuntimeException();
		} catch (IOException e) {
			LOG.fatal("Error occurred when reading from the input stream {}", e);
			throw new RuntimeException();
		}
		return properties;
	}
}
