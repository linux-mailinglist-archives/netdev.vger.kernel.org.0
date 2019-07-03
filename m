Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 212EC5EA4A
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 19:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbfGCRVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 13:21:19 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:46046 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbfGCRVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 13:21:18 -0400
Received: by mail-lj1-f195.google.com with SMTP id m23so3272603lje.12;
        Wed, 03 Jul 2019 10:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O7+UQ8rXFWnOcBrE9EBWwDmy+gGfrZKKmZ0BFJ8O6Qg=;
        b=lff+pQyfz/pQpvGeMoDeyAqNQSkcYBAnlV3f20ZgDLPBPVu6O2TCx4EAxFA+UtUx5X
         h0wESy5UGaZTKYN0nlNEHjhF5oafmcpnb6vouGJl/TkjCJZUtKsR6He2ZadaT9zTBnx+
         Lky8ym88ryNSbZMS5MJKmXxnWs2Ivx7DvkRwpiE26lILriPpQCCmIR6wBHnt//OcMIMK
         Jt7wEBIDfjM+nQLcvO37BiX7c4ENcMCYC06kxS93LA+FB0nR6aRRv4NmX76n3sRdOS54
         8Z7x63z0VjTVcVFJ0AfMp4nGNpBvaAkn5x7ZNkrW2Y6rDqu6QvhKlb3t7CNlrgRvEcgX
         wBhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O7+UQ8rXFWnOcBrE9EBWwDmy+gGfrZKKmZ0BFJ8O6Qg=;
        b=HbJ0M/WrMXTLqulhHb/JvGiaR07bTNWrbl33Vi45ICYlex2lZaaKMp7uwD0o1zpshg
         wdUWc9+yfVW9aExk7ish24I7I5aoUfSVcXx5YW9y3XuWHHflTN9sbNSq1NBFAsjVEkK5
         DdhqIW/heupsnDJ7qOqPWBt+C86clsN0GHZSJdmv0965zqwuafWHQQYiWiCmFLWrSBaU
         QGQEihZE1jYE5IPMPi7ckUk2cJbzTNf3nTThqB/8C9D/2OSlPHxryDNJcvC9awO/BuTV
         sJOSLmuK2Ox+rg+CthP26pytkSzwHG8zfd/IjNf3Gv0FqK6DJUx6jDgAIwKIdNHDHZee
         Wpzg==
X-Gm-Message-State: APjAAAUUFAM/dbNxVDsW/5+EKIiR0ca1yjNujspIsGx7ShBAYqH0IxCA
        lm3xXv0wVDKLXGzK9Bcpufk=
X-Google-Smtp-Source: APXvYqzqh2ic8ZGjl0mC6sskI7nSz1x4Sx9pCsFS5GnmqDO42TfnfxTjr72jHCXmMOzqfYwXrojsgw==
X-Received: by 2002:a2e:658e:: with SMTP id e14mr21615621ljf.147.1562174476851;
        Wed, 03 Jul 2019 10:21:16 -0700 (PDT)
Received: from krolik-desktop.lan ([91.238.216.6])
        by smtp.gmail.com with ESMTPSA id 11sm581165ljc.66.2019.07.03.10.21.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 10:21:16 -0700 (PDT)
From:   Pawel Dembicki <paweldembicki@gmail.com>
Cc:     Pawel Dembicki <paweldembicki@gmail.com>, linus.walleij@linaro.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] net: dsa: Change DT bindings for Vitesse VSC73xx switches
Date:   Wed,  3 Jul 2019 19:19:21 +0200
Message-Id: <20190703171924.31801-2-paweldembicki@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190703171924.31801-1-paweldembicki@gmail.com>
References: <20190703171924.31801-1-paweldembicki@gmail.com>
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

