Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E12845FE71
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 00:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbfGDW3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 18:29:30 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39856 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727440AbfGDW3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 18:29:30 -0400
Received: by mail-lj1-f195.google.com with SMTP id v18so7361155ljh.6;
        Thu, 04 Jul 2019 15:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=riJyJMP+f0jvVKrAvvWrE/3t4tKi8nKB63eh+YXmq9U=;
        b=f8MOUQ1AShdM65H0o9JMkv7KhWWJbfelKam1b3vX8FsTvh4vC/x5rKO85PysaX9FFv
         Zv4jp1wGp6Bz+fL30UeoxL2UsLwM5ppfEiIyGpsHbseJEgWvN6VrAd2jmJIvwxEUpR7u
         EfAtgX5qfvRbSBYJO2/KnjOFLYfXoaUzB9fZAGJPkCMOzU/ikpxB1la3EUwjntLhLUPN
         08cp3qJXRSDfgt4+vfyTzTY7dNt1qEDEF1VcVGnso6CVfC7NYpAiCdiJFSftlaD9ze0N
         V9qUkLvPEJHPzaq/gGnPmGJKm+6YJzxBlXCpZZE0j6/HvRa1ubXnCOlFPPTtOS7JYf3o
         5FXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=riJyJMP+f0jvVKrAvvWrE/3t4tKi8nKB63eh+YXmq9U=;
        b=MK32YLjLrD2ML4PY+AdUPj7eCHIhqg/lmZzJ7zfqetICtdWa2nfG3WhW0zIEpnAT1E
         9LrcATXRRI2OwlK07qcylHNahBhjzDDBqQTmPHMIy+VNdmerswKYD40U5k1EwX0yevFV
         SWSXR0g7lmkCTzMvIsZN/FRLjiSR3dXhI9fj9V9Og4xvBvwt3fZ0HcfNCJ28mekVBVps
         858uWu8qLMTXKbcb9B5sNicBoUqNcfgrr6pEeZQ4xqyE4hUMXeEU0kf3NjgueLpPDkwO
         uMKjqKMSKQ/rD52yoewqfSmXU0XTr+oXtAW968Ct4i0ioHbhCjG9cYwbk7IzQD6YridN
         MtTQ==
X-Gm-Message-State: APjAAAV4Biph5cb3E7PdS2hoNbVhZHwUgIlVrqhWgB23EZGFsl83Lbg9
        /4wJN0tMoX7C0MfS0lVev/8=
X-Google-Smtp-Source: APXvYqzfOeNVy4+dbpZJBS2UiztL0gVhVp3VRqC3+QjGxL5vo83ebuQVGVCa6aAs99HQTfhFJCduqQ==
X-Received: by 2002:a2e:9685:: with SMTP id q5mr216712lji.227.1562279367653;
        Thu, 04 Jul 2019 15:29:27 -0700 (PDT)
Received: from krolik-desktop.lan ([91.238.216.6])
        by smtp.gmail.com with ESMTPSA id t25sm403645lfg.7.2019.07.04.15.29.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 15:29:27 -0700 (PDT)
From:   Pawel Dembicki <paweldembicki@gmail.com>
Cc:     Pawel Dembicki <paweldembicki@gmail.com>, linus.walleij@linaro.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/4] net: dsa: Change DT bindings for Vitesse VSC73xx switches
Date:   Fri,  5 Jul 2019 00:29:04 +0200
Message-Id: <20190704222907.2888-2-paweldembicki@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190704222907.2888-1-paweldembicki@gmail.com>
References: <20190704222907.2888-1-paweldembicki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit introduce how to use vsc73xx platform driver.

Signed-off-by: Pawel Dembicki <paweldembicki@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../bindings/net/dsa/vitesse,vsc73xx.txt      | 58 +++++++++++++++++--
 1 file changed, 54 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/vitesse,vsc73xx.txt b/Documentation/devicetree/bindings/net/dsa/vitesse,vsc73xx.txt
index ed4710c40641..bbf4a13f6d75 100644
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
@@ -11,8 +11,14 @@ Vitesse VSC7388 SparX-G8 8-port Integrated Gigabit Ethernet Switch
 Vitesse VSC7395 SparX-G5e 5+1-port Integrated Gigabit Ethernet Switch
 Vitesse VSC7398 SparX-G8e 8-port Integrated Gigabit Ethernet Switch
 
-The device tree node is an SPI device so it must reside inside a SPI bus
-device tree node, see spi/spi-bus.txt
+This switch could have two different management interface.
+
+If SPI interface is used, the device tree node is an SPI device so it must
+reside inside a SPI bus device tree node, see spi/spi-bus.txt
+
+When the chip is connected to a parallel memory bus and work in memory-mapped
+I/O mode, a platform device is used to represent the vsc73xx. In this case it
+must reside inside a platform bus device tree node.
 
 Required properties:
 
@@ -38,6 +44,7 @@ and subnodes of DSA switches.
 
 Examples:
 
+SPI:
 switch@0 {
 	compatible = "vitesse,vsc7395";
 	reg = <0>;
@@ -79,3 +86,46 @@ switch@0 {
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

