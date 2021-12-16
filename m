Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A52D477D22
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 21:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241174AbhLPUOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 15:14:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240623AbhLPUOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 15:14:18 -0500
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90159C061574
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 12:14:17 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id t83so77974qke.8
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 12:14:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z1LxRgYPH4dSY5KH7ONVFKs9LemzJDJSixQwKamOflY=;
        b=Rs/ze+ZuGq9HUsp4snIQrpkhJHhTqwZHWHJgJVxXgk7c9/rPDFfuMDoPKryAFPlBPr
         yMliWzhjFZj1/jK6yAxy7FwtpkjRm7EXX3dgqolZA4tUeDsW9pj+Pl8sKvAMkxpMjTXW
         5W49W1xmkGJzSQZ3WjVb/4HTdaOLebQK6z5pafakMk+aMPAi9sxMxOifPu3vitpJpX2M
         AHFqgxoXLfn6Z+9WAfTnPDSSquUUgR1EnZbhPziEbF7j03fveoraNTstfCLEjOHEoEjG
         +tTzM+cWEQ8DttKeIwR4Lqq+Z9ThgwWCKfCQ94h3bIPBp6wyZMHapnUEhxQnIVmzx60Q
         Y5NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z1LxRgYPH4dSY5KH7ONVFKs9LemzJDJSixQwKamOflY=;
        b=4cTmfNd7PoDgCeLfxeacA28cnlQehPAfSznD8QzNdLhpdZvosn5dnt+XN0JmJaTQMa
         EqQdVmsKFO7CacRCaUjdsLXCr1ygQtHZ0vWnBlBHuD7d5E/SKh//II5a7mo0QNTWV8pn
         6gIFXa+ZaYYJXNpZ+zrjurN1MP61LV61H6p4dUxEGszbhgkv3BBbs5BM2x1ppt8Lv6/t
         MmVpnieUAQG4zuR82nkP5o6qAm+IX1JCvDFDhT+VqghhKDiMwCQiJZpWeQFgEXzIG/cw
         PAXAGdTTXL9t8yaK4CeTeG5VEZ3BaXBNsm2S0u6NxMVOXwKysNaLBfAZXeAvG3U4TLy6
         otxQ==
X-Gm-Message-State: AOAM532vXn+3cBIj2JV3XRN40RAqN3mUXNtWplHuA9zs37OY83BaTz0U
        ALzp1nksSEQChIiSFi+kSqIZ4CVh0GTBDQ==
X-Google-Smtp-Source: ABdhPJwfDU/6OjHpH4A/siKW9LTT1MIffxAq6alOfJGz6LUULUzvxlSAwCgDVFQMhoU0UQMs2vBseA==
X-Received: by 2002:a37:9fce:: with SMTP id i197mr13634392qke.67.1639685656450;
        Thu, 16 Dec 2021 12:14:16 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id a15sm5110266qtb.5.2021.12.16.12.14.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 12:14:16 -0800 (PST)
From:   luizluca@gmail.com
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next 02/13] net: dsa: realtek-smi: move to subdirectory
Date:   Thu, 16 Dec 2021 17:13:31 -0300
Message-Id: <20211216201342.25587-3-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211216201342.25587-1-luizluca@gmail.com>
References: <20211216201342.25587-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Angelo Daros de Luca <luizluca@gmail.com>

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 MAINTAINERS                                   |  3 +--
 drivers/net/dsa/Kconfig                       | 12 +-----------
 drivers/net/dsa/Makefile                      |  3 +--
 drivers/net/dsa/realtek/Kconfig               | 19 +++++++++++++++++++
 drivers/net/dsa/realtek/Makefile              |  3 +++
 .../net/dsa/{ => realtek}/realtek-smi-core.c  |  0
 .../net/dsa/{ => realtek}/realtek-smi-core.h  |  0
 drivers/net/dsa/{ => realtek}/rtl8365mb.c     |  0
 drivers/net/dsa/{ => realtek}/rtl8366.c       |  0
 drivers/net/dsa/{ => realtek}/rtl8366rb.c     |  0
 10 files changed, 25 insertions(+), 15 deletions(-)
 create mode 100644 drivers/net/dsa/realtek/Kconfig
 create mode 100644 drivers/net/dsa/realtek/Makefile
 rename drivers/net/dsa/{ => realtek}/realtek-smi-core.c (100%)
 rename drivers/net/dsa/{ => realtek}/realtek-smi-core.h (100%)
 rename drivers/net/dsa/{ => realtek}/rtl8365mb.c (100%)
 rename drivers/net/dsa/{ => realtek}/rtl8366.c (100%)
 rename drivers/net/dsa/{ => realtek}/rtl8366rb.c (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 19d6fccf1205..a8f949b368a8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16153,8 +16153,7 @@ REALTEK RTL83xx SMI DSA ROUTER CHIPS
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
index 000000000000..bbc6e918baa6
--- /dev/null
+++ b/drivers/net/dsa/realtek/Kconfig
@@ -0,0 +1,19 @@
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
+	  Select to enable support for registering switches connected through SMI.
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

