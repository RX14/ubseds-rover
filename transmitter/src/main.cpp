#include <LoRa.h>

#define LoRa_IRQ 26
#define LoRa_RST 14
#define LoRa_SCK 5
#define LoRa_SS 18
#define LoRa_MISO 19
#define LoRa_MOSI 27

void setup() {
    Serial.begin(115200);
    Serial.println(" INFO: Waiting 250ms for console");
    delay(250);
    Serial.println(" INFO: Begin Setup");

    Serial.println("DEBUG: Begin SPI");
    SPI.begin(LoRa_SCK, LoRa_MISO, LoRa_MOSI, LoRa_SS);

    Serial.println("DEBUG: Begin LoRa");
    LoRa.setPins(LoRa_SS, LoRa_RST, LoRa_IRQ);
    if (LoRa.begin(433E6)) {
        Serial.println("DEBUG: Enabling LoRa CRC");
        LoRa.enableCrc();
    } else {
        Serial.println("ERROR: Starting LoRa failed");
        while (true);
    }

    Serial.println(" INFO: Setup complete");
}

void loop() {
    Serial.println(" INFO: Sending value 0x56");
    LoRa.beginPacket(/* implicitHeader: */ true);
    LoRa.write(0x56);
    LoRa.endPacket();

    delay(1000);
}
