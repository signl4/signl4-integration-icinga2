# Mobile Alarmierung per App, SMS und Anruf für Icinga2

## Warum SIGNL4

Wenn kritische Systeme ausfallen, ist SIGNL4 der schnellste Weg, Ihre Mitarbeiter, Ingenieure, IT-Administratoren in Bereitschaft zu alarmieren, egal, wo sich diese befinden. SIGNL4 bietet zuverlässige Benachrichtigungen per App-Push, SMS und Sprachanruf mit Nachverfolgung, Eskalationen und Dienst-Planung.

![SIGNL4](signl4-icinga2.png)

Icinga2 ist ein Monitoring-Tool, das Verfügbarkeit und Leistung überwacht. Es bietet Ihnen einfachen Zugriff auf relevante Daten. SIGNL4 ermöglicht es Icinga2, mobile Teams vor Ort oder in Bereitschaft in Echtzeit zu benachrichtigen. Dies beschleunigt ihre Reaktion erheblich und setzt Ressourcen in den Einsätzen frei.

Durch die Integration von Icinga2 mit SIGNL4 können Sie Ihre täglichen Abläufe verbessern, indem Ihre Teams in kritischen Situationen informiert werden, wo auch immer es sich befinden.

## So funktioniert es

SIGNL4 alarmiert Teams und Rufbereitschaften auf ihren mobilen Endgeräten, wenn IT-Störungen von Icinga2 erkannt werden. Persistente Benachrichtigungen, Bestätigungen und Eskalationen stellen sicher, dass die Probleme behandelt werden, bevor es zu spät ist.

## Integrations-Fähigkeiten

- IT-Mitarbeiter werden per mobilem Push, SMS und Anruf benachrichtigt
- Mitarbeiter können kritische Alarme bestätigen und übernehmen
- Alarme werden eskaliert, wenn keine Antwort erfolgt
- Mobiler Chat erlaubt den Austausch mit Kollegen in Echtzeit über die Störungsbeseitigung
- Icinga2 sendet Event-Daten per Webhook an SIGNL4

## Szenarien

- Systemüberwachung
- Applikationsüberwachung
- Netzwerk-Überwachung
- Datenbank-Monitoring

## Integration von SIGNL4 mit Icinga2

Wir stellen eine fertige Alarmierungs-Integration für Icinga2 zur Verfügung. Die Integration erlaubt es Ihnen, direkt und automatisch Alarme an Ihr SIGNL4-Team zu senden, wenn Icinga2 Probleme erkannt hat.

### Voraussetzungen

Ein SIGNL4 (https://www.signl4.com) Konto  
Eine Icinga2 (https://icinga.com) Installation

### Integrations-Schritte

Im Folgenden beschreiben wir die nötigen Schritte, um die SIGNL4 mit Icinga2 zu integrieren.

### 1. SIGNL4-Skript

Auf der Kommandozeile fügen wir als erstes das SIGNL4-Sende-Skript hinzu. Dazu wird dieses heruntergeladen und in das entsprechende Verzeichnis verschoben:

wget https://raw.githubusercontent.com/signl4/sign4-integration-icinga2/master/signl4-notification.sh
chmod +x signl4-notification.sh
mv signl4-notification.sh /etc/icinga2/scripts/

### 2. SIGNL4-Konfiguration

Nun fügen wir die Konfigurations-Datei hinzu und passen diese entsprechend an.

wget https://raw.githubusercontent.com/signl4/sign4-integration-icinga2/master/signl4-icinga2.conf
mv signl4-icinga2.conf /etc/icinga2/conf.d/
Diese Datei stellt die Alarmierungs-Logik bereit und legt den Nutzer “signl4” an. In diesem Nutzer müssen Sie noch Ihre SIGNL4-Team-Geheimnis im Feld “pager” eintragen. Das ist der letzte Teil Ihre Webhook-URL oder der erste Teil Ihrer SIGNL4-E-Mail-Adresse. Dazu müssen Sie die folgende Zeile entsprechend anpassen.

```
pager = "team-secret"
```

### 3. Aktivierung der SIGNL4-Alarmierung

In der Datei “templates.conf” im Verzeichnis “/etc/icinga2/conf.d/” gibt es die Einträge “template Host” für “generic-host” und “generic-service”. Hier fügen Sie jeweils die folgende Zeile hinzu:

```
vars.enable_signl4 = true
```

Also zum Beispiel so:

```
template Host "generic-host" {
vars.enable_signl4 = true
}
```

```
template Host "generic-service" {
vars.enable_signl4 = true
} 
```

### 4. Dienst Neustart

Nun können Sie den Icinga2 Dienst neu starten um die Änderungen wirksam zu machen.

```
service icinga2 restart
```

### 5. Testen Sie es

Das ist alles und nun können Sie die Alarmierung testen. Im einfachsten Fall können Sie das einfach manuell tun. Gehen Sie dazu in Ihr Icinga2 Dashboard und dort zum Beispiel auf einen Service. Auf der linken Seite unter Notifications können Sie nun eine Notifikation senden. Bitte aktivieren Sie dazu die Option “Forced”. Sie sollten nun eine Alarmierung in Ihrer SIGNL4 App erhalten.

Weitere Informationen finden Sie auf GitHub unter https://github.com/signl4/signl4-integration-icinga2.
