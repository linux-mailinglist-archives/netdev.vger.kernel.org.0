Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D14E15BFC5
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 17:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728158AbfGAP2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 11:28:48 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:35682 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfGAP2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 11:28:48 -0400
Received: by mail-lf1-f66.google.com with SMTP id a25so9117905lfg.2;
        Mon, 01 Jul 2019 08:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kUd6oC4CwkGinXIZBT21shD4mEDfRTY5MFw4kwCcA7A=;
        b=sxo+grIwj+RDKTj5IQga0vgl0SUNb60398r0MGLEWRrLcnQMSZbyd9lpMBYIyndTDn
         lfC4N4B3RL3JwrKcqIxzemHHg4ZmG8qpA5kyZ4DXwxU2H7AHlcUz/8Aih5B1gL3wxiYM
         FDLHVOfDGK6LehxteO/R/TsPkmzOoTHl9lJEul2zjFE6hMJsMWccO+ssQcbUIJmyZMiv
         SHUVxhHA9vVrJJSY+nI0+e5Ckv2f6UuaqauAlWDCV6v/DFA9NlCljrzfVuMMLx6AV9GV
         R0wjb+P2ZORQsRqWhQztJXuuWq8ER6wophYRZ4wZTOT3b3bV6DZYvEG+z3eOIizTzJjh
         wLwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kUd6oC4CwkGinXIZBT21shD4mEDfRTY5MFw4kwCcA7A=;
        b=sQ2HkKY5ltVQ2MqazxvExEbIJV7YPpK+cHxgmTVTKKbISEejBVq+WKACsXgkN5TAiE
         /loHrhCxF2K1MxiyRhtbAVEW/45erzSMLWrRfoN6gH2GsxZ40os3Ls/mKE1WPMQnBELv
         KCCHYT54ZezxrRpI60hBz2A2aWjzMD2fWAlUkI3pv0ibAhU+UbV3wCMBPMXgERb/9jAS
         ZTA7oHA5ELh5DQCp6PvrZk2Ac5j9iD+4KiQztiaeMULT/wEe6qM2fNDehhHEaKVdctBF
         Ttr+oPWhHr+3Xj0RNhfqy86IDb3xlM84JZ9rK0niazlLYxQh7qKjMbZDKNmscXlM2ctc
         HGJg==
X-Gm-Message-State: APjAAAWXLI2/N8rlirQejT4gTp5TZOIEVe04L/FTG8ajWItSFrR0DpVL
        Z0ZcXVEkiKo1pqnJ03Gj5pc=
X-Google-Smtp-Source: APXvYqxDTii3yJ4bBdiHt9sIlPIY5iGYZ62DDU86Mw1IpkpA9xguaiRzVZOW1HsLB8ExJlCiH/8pUQ==
X-Received: by 2002:a19:230f:: with SMTP id j15mr11609319lfj.122.1561994925933;
        Mon, 01 Jul 2019 08:28:45 -0700 (PDT)
Received: from localhost.localdomain ([91.238.216.6])
        by smtp.gmail.com with ESMTPSA id e12sm2561626lfb.66.2019.07.01.08.28.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 08:28:45 -0700 (PDT)
From:   Pawel Dembicki <paweldembicki@gmail.com>
Cc:     linus.walleij@linaro.org, paweldembicki@gmail.com,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] net: dsa: Change DT bindings for Vitesse VSC73xx switches
Date:   Mon,  1 Jul 2019 17:27:20 +0200
Message-Id: <20190701152723.624-1-paweldembicki@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit document changes after split vsc73xx driver into core and
spi part. The change of DT bindings is required for support the same
vsc73xx chip, which need PI bus to communicate with CPU. It also
introduce how to use vsc73xx platform driver.

Signed-off-by: Pawel Dembicki <paweldembicki@gmail.com>
---
 .../bindings/net/dsa/vitesse,vsc73xx.txt      | 74 ++++++++++++++++---
 1 file changed, 64 insertions(+), 10 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/vitesse,vsc73xx.txt b/Documentation/devicetree/bindings/net/dsa/vitesse,vsc73xx.txt
index ed4710c40641..c6a4cd85891c 100644
--- a/Documentation/devicetree/bindings/net/dsa/vitesse,vsc73xx.txt
+++ b/Documentation/devicetree/bindings/net/dsa/vitesse,vsc73xx.txt
@@ -2,8 +2,8 @@ Vitesse VSC73xx Switches
 ========================
 
 This defines device tree bindings for the Vitesse VSC73xx switch chips.
-The Vitesse company has been acquired by Microsemi and Microsemi in turn
-acquired by Microchip but retains this vendor branding.
+The Vitesse company has been acquired by Microsemi and Microsemi has
+been acquired Microchip but retains this vendor branding.
 
 The currently supported switch chips are:
 Vitesse VSC7385 SparX-G5 5+1-port Integrated Gigabit Ethernet Switch
@@ -11,16 +11,26 @@ Vitesse VSC7388 SparX-G8 8-port Integrated Gigabit Ethernet Switch
 Vitesse VSC7395 SparX-G5e 5+1-port Integrated Gigabit Ethernet Switch
 Vitesse VSC7398 SparX-G8e 8-port Integrated Gigabit Ethernet Switch
 
-The device tree node is an SPI device so it must reside inside a SPI bus
-device tree node, see spi/spi-bus.txt
+This switch could have two different management interface.
+
+If SPI interface is used, the device tree node is an SPI device so it must
+reside inside a SPI bus device tree node, see spi/spi-bus.txt
+
+If Platform driver is used, the device tree node is an platform device so it
+must reside inside a platform bus device tree node.
 
 Required properties:
 
-- compatible: must be exactly one of:
-	"vitesse,vsc7385"
-	"vitesse,vsc7388"
-	"vitesse,vsc7395"
-	"vitesse,vsc7398"
+- compatible (SPI): must be exactly one of:
+	"vitesse,vsc7385-spi"
+	"vitesse,vsc7388-spi"
+	"vitesse,vsc7395-spi"
+	"vitesse,vsc7398-spi"
+- compatible (Platform): must be exactly one of:
+	"vitesse,vsc7385-platform"
+	"vitesse,vsc7388-platform"
+	"vitesse,vsc7395-platform"
+	"vitesse,vsc7398-platform"
 - gpio-controller: indicates that this switch is also a GPIO controller,
   see gpio/gpio.txt
 - #gpio-cells: this must be set to <2> and indicates that we are a twocell
@@ -38,8 +48,9 @@ and subnodes of DSA switches.
 
 Examples:
 
+SPI:
 switch@0 {
-	compatible = "vitesse,vsc7395";
+	compatible = "vitesse,vsc7395-spi";
 	reg = <0>;
 	/* Specified for 2.5 MHz or below */
 	spi-max-frequency = <2500000>;
@@ -79,3 +90,46 @@ switch@0 {
 		};
 	};
 };
+
+Platform:
+switch@2,0 {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	compatible = "vitesse,vsc7385-platform";
+	reg = <0x2 0x0 0x20000>;
+	reset-gpios = <&gpio0 12 GPIO_ACTIVE_LOW>;
+
+	ports {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		port@0 {
+			reg = <0>;
+			label = "lan1";
+		};
+		port@1 {
+			reg = <1>;
+			label = "lan2";
+		};
+		port@2 {
+			reg = <2>;
+			label = "lan3";
+		};
+		port@3 {
+			reg = <3>;
+			label = "lan4";
+		};
+		vsc: port@6 {
+			reg = <6>;
+			label = "cpu";
+			ethernet = <&enet0>;
+			phy-mode = "rgmii";
+			fixed-link {
+				speed = <1000>;
+				full-duplex;
+				pause;
+			};
+		};
+	};
+
+};
-- 
2.20.1

