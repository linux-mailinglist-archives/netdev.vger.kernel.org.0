Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 012B75E05D
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 10:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbfGCI6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 04:58:19 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:32985 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbfGCI6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 04:58:19 -0400
Received: by mail-lf1-f68.google.com with SMTP id y17so1218959lfe.0;
        Wed, 03 Jul 2019 01:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2mMVMreh3hJKLJhjIAM6H3oxpyFnkoyLmzafE6hiSIY=;
        b=UXws+LNoc7XAqzFvu2ppbTf8wVcwsxHXrk3Ud4xWb0tXIqA2dh9Wp/KRTsplhNpRra
         3WSW3yODUK1V9ndVDC9S0J6MBtc1GPi5ahtLaAYAKhDtboQW6norrPX3/3ptnODRgxVb
         1RENdrzUS8xvpaQs/4AXCXevjmtWNfMSJK4dN0PGACa+e8x7JenM0wNjajQBSSJLkly8
         ++qulESU0o8WGAvfC1i5XM+oHspsEodECy/e+RLr+JdzCnGgF8FIs5VeUZsW39sMEx5/
         Th1TPtOXN5SlEdR9r1eoGlOSD+b/u0ImwZZvIrvIp7D2UrC2YP1PjNf/6DJLIvxmngBS
         39iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2mMVMreh3hJKLJhjIAM6H3oxpyFnkoyLmzafE6hiSIY=;
        b=CVjy36jew3MVJPqq+6DzSoscckJeYorTFczHqSpDc4D6Zn2WWJUAAaAkroo97RS27O
         9yTqoCkeOvJjNB4ELHJ1BUIifM/RqmTYK/wWc5jD9NfGHvniYQsdNHNQ3nlYQ3FlkVKc
         bSTRVn0KM1lx8Z2EPCrZTbAwwOpckfCHnoh8r1pdCHSvraW6+vlBTDQuwq3E5+RFAAzC
         f7PQnTctjZpqrFS667krlmH85MgkAy6q0w1k5fFEHi5hD42RYyyEvzdtZhL5DDF2AX47
         XZlKAWzNZJeQ/vFvYb36RgIsg3E3SYI2KflHYSyXDSCX6t7WBiQS/CV8oQutPCraRjZ7
         5lUQ==
X-Gm-Message-State: APjAAAWZuD9+HJs52Fm8Sd0uPCY3wy0MXd+spw3Gv7uI6zOhLMQbO1Lk
        BcSiG5LGA5kvDVWTl8jKHp4=
X-Google-Smtp-Source: APXvYqzBE5JWkQEYewzfdunGupYNiyEuR9qo8QLMdsdBwvBsO19vdVFSYv3J+rTIfOgB9HV+S9xlKg==
X-Received: by 2002:a19:80c4:: with SMTP id b187mr2931361lfd.122.1562144297227;
        Wed, 03 Jul 2019 01:58:17 -0700 (PDT)
Received: from krolik-desktop.lan ([91.238.216.6])
        by smtp.gmail.com with ESMTPSA id p76sm348625ljb.49.2019.07.03.01.58.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 01:58:16 -0700 (PDT)
From:   Pawel Dembicki <paweldembicki@gmail.com>
Cc:     paweldembicki@gmail.com, linus.walleij@linaro.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] net: dsa: Change DT bindings for Vitesse VSC73xx switches
Date:   Wed,  3 Jul 2019 10:57:56 +0200
Message-Id: <20190703085757.1027-1-paweldembicki@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190701152723.624-1-paweldembicki@gmail.com>
References: <20190701152723.624-1-paweldembicki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit introduce how to use vsc73xx platform driver.

Signed-off-by: Pawel Dembicki <paweldembicki@gmail.com>
---
Changes in v2:
- Drop -spi and -platform suffix
- Change commit message

 .../bindings/net/dsa/vitesse,vsc73xx.txt      | 57 +++++++++++++++++--
 1 file changed, 53 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/vitesse,vsc73xx.txt b/Documentation/devicetree/bindings/net/dsa/vitesse,vsc73xx.txt
index ed4710c40641..c55e0148657d 100644
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
@@ -11,8 +11,13 @@ Vitesse VSC7388 SparX-G8 8-port Integrated Gigabit Ethernet Switch
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
 
@@ -38,6 +43,7 @@ and subnodes of DSA switches.
 
 Examples:
 
+SPI:
 switch@0 {
 	compatible = "vitesse,vsc7395";
 	reg = <0>;
@@ -79,3 +85,46 @@ switch@0 {
 		};
 	};
 };
+
+Platform:
+switch@2,0 {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	compatible = "vitesse,vsc7385";
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

