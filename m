Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFBCF4821F5
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 05:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242677AbhLaEe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 23:34:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbhLaEe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 23:34:28 -0500
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B13C061574
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 20:34:28 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id q3so23869576qvc.7
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 20:34:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wDVfJy23ZnTNE6eahp5qchHBkXE7kYf+/snVCIiRndA=;
        b=SamLentdvDblbMuv2CvI1ZFUzdrWBYrTRL8CLj2JQAxdZI1sZ7CgdeoFY6csWgGjxD
         QoJDDdJ1oc16T/LB2RAPr2SR46OMA2QsOVUNXNCrgurbrn+e+gnpwfEZWIyLtsvpzMJA
         lv91rVh7wnzUv139uDEfyHKmH17OzQmkZWf6L0qud1Dz1Wv0D3GlCCPiPxeq/l5JWblL
         7AtHVRKbeF4M5O/fCQwBIsnOpMMzaWrM2jhYUfKKTqyRJfZxmdqdCdCNacYqs8BGB8y8
         QZSqWEEQ7+zkw80ELPycb9D7nVIq+viK4ows4UUvWUCHwxvGjDjz0PpInhhapC3xnPOY
         9Z9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wDVfJy23ZnTNE6eahp5qchHBkXE7kYf+/snVCIiRndA=;
        b=pxrr0Zz7vxdp9/4jLZdWl+TFirRkzieqRdUOd4gD7AjsW1FRwLIYzCJvIgA1CzD9ut
         XRE1QCriH4S1x3jjpiFzhBoov9ZajowLD4UYHStKMOgsTEsf7pclmT/Dq2cXvchNliiZ
         Ein2LjpbuU30LmlrMgz+IGpNM/tD4H08ji03wf9q0XuUvg/6J4F4THaMwIOW2NEP059N
         zw1KTTt05VGKgBJP0xk7xWCkNCdMXY3pCTH3vaO0m4oax/dcGH+O3PFpvsOq6m/gYDAD
         4S4YsKteEozI5K+OozTGXfwLhqnThYviiF/hJL4b1SlKT+QbYAbDACrYjuGF7bmpxPSJ
         Cfiw==
X-Gm-Message-State: AOAM530gjrB21kIoov+b/TVYple2c2/DHRV8ubDpvC/7ATc5KojDWlRL
        3+0elE+reSHbH/GTrgO2B9kLqZkYA6NjvFoS
X-Google-Smtp-Source: ABdhPJw7oiGjZLMVR13jSQASDSxQbokCfUhv7UY6KjcvCXwXQ6DAy/NpBHKtpgulsVu4t6sN4GbcqQ==
X-Received: by 2002:a05:6214:4013:: with SMTP id kd19mr29765538qvb.39.1640925267458;
        Thu, 30 Dec 2021 20:34:27 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id i5sm8020030qti.27.2021.12.30.20.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 20:34:26 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com, frank-w@public-files.de,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v3 01/11] net: dsa: realtek-smi: move to subdirectory
Date:   Fri, 31 Dec 2021 01:32:56 -0300
Message-Id: <20211231043306.12322-2-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211231043306.12322-1-luizluca@gmail.com>
References: <20211231043306.12322-1-luizluca@gmail.com>
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

