Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D419484CC3
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 04:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234537AbiAEDPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 22:15:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235819AbiAEDPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 22:15:44 -0500
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2688C061784
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 19:15:44 -0800 (PST)
Received: by mail-qv1-xf30.google.com with SMTP id p12so12161000qvj.6
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 19:15:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O/dsKuO43cK9cNbV3OYotS75x4p4oMy+vmubtnF0vUE=;
        b=GpbmEwoheqRvuUwVH4HcfDjgo36HMMMFYXPgyUfrjxLC8JdD9aceDZmNAWQQ4Y3p07
         NFWhk67If1HQdfJTaTf7T+ARAWe+KujWEP8jQ6lt0NFTLkm7dxN8URHHsVGGR7sfd4Zj
         X0HkcoUFwTbJfBwNxZF5lxKN+SUVQt1JQtLVcjJli4bKoqBXUSe++IR0WUt+3/JaNCYD
         rGEcZfzVq4Kn56gdfv4nYh8UDSlMiEabEVt/XRHCHLkS86L61PpOFqdsXpWi/BeZasX6
         WwSNvNGSaCyV/OY0dYqcY5FSW1zNcu8cyyy2yfjJsF1Clcij4cXzplZnOGV/RHt8wdWH
         y9jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O/dsKuO43cK9cNbV3OYotS75x4p4oMy+vmubtnF0vUE=;
        b=T6EWRh0hC+gpvynoYdVWmyRCyYv2v/0fHfWeBz3g465tFOhzuvPiDtWVFIvHHxXp57
         gUT8lIm+TwhhmWxM2jLFNHC/Lge5XhQo7QsrAazeB3OUUGqqQxjdfO0O+M5tDydkLQRv
         RTTT+gzW8DiNwz469T3dOqDcJnEo+PuN7XdNi94CgXI2PLp8MVPpgdJbTwh3t9UaSK/s
         N0ge43QpUDcrpuYJAV65OOBT3LMIiGm9CaGLS8CQK/5xsphhxvPnTJSxtGYE35Ca2dmc
         OX6aSpcxXcWn8FYNGwGTXp7DoX6uTKi+dGD64y8l3iOr0ezu5RUMuhhSNMAxONRCG09l
         EmDA==
X-Gm-Message-State: AOAM532Lk0EkIVX6U7ZtW1Msuxp8oYP0m3NCD8xUiPdej673mVNn+hjd
        /AKH4/LDd8NaTkCWXoRxNS5y8EvLIktfwTCD
X-Google-Smtp-Source: ABdhPJyNsrMq+E8TXbZnYP7VBQHBar5GNugI5BLo+EyV9xm+yBQhyn98vAAW5uj/jJYlj84hUwA7qg==
X-Received: by 2002:a05:6214:da1:: with SMTP id h1mr49180090qvh.23.1641352543618;
        Tue, 04 Jan 2022 19:15:43 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id t11sm32607629qkp.56.2022.01.04.19.15.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 19:15:43 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com, frank-w@public-files.de,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v4 01/11] net: dsa: realtek-smi: move to subdirectory
Date:   Wed,  5 Jan 2022 00:15:05 -0300
Message-Id: <20220105031515.29276-2-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20220105031515.29276-1-luizluca@gmail.com>
References: <20220105031515.29276-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 MAINTAINERS                                   |  3 +--
 drivers/net/dsa/Kconfig                       | 12 +----------
 drivers/net/dsa/Makefile                      |  3 +--
 drivers/net/dsa/realtek/Kconfig               | 20 +++++++++++++++++++
 drivers/net/dsa/realtek/Makefile              |  3 +++
 .../net/dsa/{ => realtek}/realtek-smi-core.c  |  0
 .../net/dsa/{ => realtek}/realtek-smi-core.h  |  0
 drivers/net/dsa/{ => realtek}/rtl8365mb.c     |  0
 drivers/net/dsa/{ => realtek}/rtl8366.c       |  0
 drivers/net/dsa/{ => realtek}/rtl8366rb.c     |  0
 10 files changed, 26 insertions(+), 15 deletions(-)
 create mode 100644 drivers/net/dsa/realtek/Kconfig
 create mode 100644 drivers/net/dsa/realtek/Makefile
 rename drivers/net/dsa/{ => realtek}/realtek-smi-core.c (100%)
 rename drivers/net/dsa/{ => realtek}/realtek-smi-core.h (100%)
 rename drivers/net/dsa/{ => realtek}/rtl8365mb.c (100%)
 rename drivers/net/dsa/{ => realtek}/rtl8366.c (100%)
 rename drivers/net/dsa/{ => realtek}/rtl8366rb.c (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0b5fdb517c76..fc63d1e46798 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16161,8 +16161,7 @@ REALTEK RTL83xx SMI DSA ROUTER CHIPS
 M:	Linus Walleij <linus.walleij@linaro.org>
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
-F:	drivers/net/dsa/realtek-smi*
-F:	drivers/net/dsa/rtl83*
+F:	drivers/net/dsa/realtek/*
 
 REALTEK WIRELESS DRIVER (rtlwifi family)
 M:	Ping-Ke Shih <pkshih@realtek.com>
diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index 7b1457a6e327..1251caf0f638 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -67,17 +67,7 @@ config NET_DSA_QCA8K
 	  This enables support for the Qualcomm Atheros QCA8K Ethernet
 	  switch chips.
 
-config NET_DSA_REALTEK_SMI
-	tristate "Realtek SMI Ethernet switch family support"
-	select NET_DSA_TAG_RTL4_A
-	select NET_DSA_TAG_RTL8_4
-	select FIXED_PHY
-	select IRQ_DOMAIN
-	select REALTEK_PHY
-	select REGMAP
-	help
-	  This enables support for the Realtek SMI-based switch
-	  chips, currently only RTL8366RB.
+source "drivers/net/dsa/realtek/Kconfig"
 
 config NET_DSA_SMSC_LAN9303
 	tristate
diff --git a/drivers/net/dsa/Makefile b/drivers/net/dsa/Makefile
index 8da1569a34e6..e73838c12256 100644
--- a/drivers/net/dsa/Makefile
+++ b/drivers/net/dsa/Makefile
@@ -9,8 +9,6 @@ obj-$(CONFIG_NET_DSA_LANTIQ_GSWIP) += lantiq_gswip.o
 obj-$(CONFIG_NET_DSA_MT7530)	+= mt7530.o
 obj-$(CONFIG_NET_DSA_MV88E6060) += mv88e6060.o
 obj-$(CONFIG_NET_DSA_QCA8K)	+= qca8k.o
-obj-$(CONFIG_NET_DSA_REALTEK_SMI) += realtek-smi.o
-realtek-smi-objs		:= realtek-smi-core.o rtl8366.o rtl8366rb.o rtl8365mb.o
 obj-$(CONFIG_NET_DSA_SMSC_LAN9303) += lan9303-core.o
 obj-$(CONFIG_NET_DSA_SMSC_LAN9303_I2C) += lan9303_i2c.o
 obj-$(CONFIG_NET_DSA_SMSC_LAN9303_MDIO) += lan9303_mdio.o
@@ -23,5 +21,6 @@ obj-y				+= microchip/
 obj-y				+= mv88e6xxx/
 obj-y				+= ocelot/
 obj-y				+= qca/
+obj-y				+= realtek/
 obj-y				+= sja1105/
 obj-y				+= xrs700x/
diff --git a/drivers/net/dsa/realtek/Kconfig b/drivers/net/dsa/realtek/Kconfig
new file mode 100644
index 000000000000..1c62212fb0ec
--- /dev/null
+++ b/drivers/net/dsa/realtek/Kconfig
@@ -0,0 +1,20 @@
+# SPDX-License-Identifier: GPL-2.0-only
+menuconfig NET_DSA_REALTEK
+	tristate "Realtek Ethernet switch family support"
+	depends on NET_DSA
+	select NET_DSA_TAG_RTL4_A
+	select NET_DSA_TAG_RTL8_4
+	select FIXED_PHY
+	select IRQ_DOMAIN
+	select REALTEK_PHY
+	select REGMAP
+	help
+	  Select to enable support for Realtek Ethernet switch chips.
+
+config NET_DSA_REALTEK_SMI
+	tristate "Realtek SMI connected switch driver"
+	depends on NET_DSA_REALTEK
+	default y
+	help
+	  Select to enable support for registering switches connected
+	  through SMI.
diff --git a/drivers/net/dsa/realtek/Makefile b/drivers/net/dsa/realtek/Makefile
new file mode 100644
index 000000000000..323b921bfce0
--- /dev/null
+++ b/drivers/net/dsa/realtek/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_NET_DSA_REALTEK_SMI) 	+= realtek-smi.o
+realtek-smi-objs			:= realtek-smi-core.o rtl8366.o rtl8366rb.o rtl8365mb.o
diff --git a/drivers/net/dsa/realtek-smi-core.c b/drivers/net/dsa/realtek/realtek-smi-core.c
similarity index 100%
rename from drivers/net/dsa/realtek-smi-core.c
rename to drivers/net/dsa/realtek/realtek-smi-core.c
diff --git a/drivers/net/dsa/realtek-smi-core.h b/drivers/net/dsa/realtek/realtek-smi-core.h
similarity index 100%
rename from drivers/net/dsa/realtek-smi-core.h
rename to drivers/net/dsa/realtek/realtek-smi-core.h
diff --git a/drivers/net/dsa/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
similarity index 100%
rename from drivers/net/dsa/rtl8365mb.c
rename to drivers/net/dsa/realtek/rtl8365mb.c
diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/realtek/rtl8366.c
similarity index 100%
rename from drivers/net/dsa/rtl8366.c
rename to drivers/net/dsa/realtek/rtl8366.c
diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/realtek/rtl8366rb.c
similarity index 100%
rename from drivers/net/dsa/rtl8366rb.c
rename to drivers/net/dsa/realtek/rtl8366rb.c
-- 
2.34.0

