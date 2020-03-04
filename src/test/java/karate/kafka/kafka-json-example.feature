Feature: Kafka Producer and Consumer using JSON

  # Demonstration of writing JSON to a Kafka topic and reading it back

  # No special configuration is required either on the consumer or producer side to handle JSON

  Background:

    # Remember that all the code in the Background section gets executed for every scenario
    * def KafkaProducer = Java.type('karate.kafka.KarateKafkaProducer')
    * def KafkaConsumer = Java.type('karate.kafka.KarateKafkaConsumer')
    * def topic = 'test-topic'

  Scenario: Print the default properties

    * def props = KafkaConsumer.getDefaultProperties()
    * print props

  Scenario: Write JSON to test-topic and read it back

    # Create a consumer. It starts listening to the topic as soon as it is created

    * def kp = new KafkaProducer()
    # Specify Json deserializers both for the key and value
    * def props = KafkaConsumer.getDefaultProperties()
    * def kc = new KafkaConsumer(topic,props)
    * def key = { id: 10 }
    * def value =
    """
    {
      id: 10,
      person : {
          firstName : "Santa",
          lastName : "Claus"
          },
      location : "North Pole"
    }
    """
    * kp.send(topic, key, value);
    # Read the data from the topic. At this point, this is a String, so we need to
    # convert it back to Json in order to do matches
    * def str = kc.take();
    * json output = str
    * match output.key == key
    * match output.value == value
    # Since this is json, we can do all the fancy matches ...
    * def keyout = output.key
    * def valueout = output.value
    * match keyout.id == 10
    * match valueout.person.firstName == 'Santa'
    # dont forget to close the consumer and producer
    * kp.close()
    * kc.close()
