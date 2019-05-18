Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 650022211F
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 03:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbfERBPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 21:15:02 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39932 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727260AbfERBPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 21:15:02 -0400
Received: by mail-pl1-f196.google.com with SMTP id g9so4093912plm.6
        for <netdev@vger.kernel.org>; Fri, 17 May 2019 18:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references:to;
        bh=a/YWlBQAaMsMP46Bem0O65dvMh/6zNAC0LweOl3PBGo=;
        b=YBO/fOKYWggoGVZsPmscz7sNW0B2vAQq9K5Fm3XOyMr4DPiyAgUhWJPErpnpID/tkm
         7Bkbd39LIOyWYfjlnKrLwx3SRuHAM+4dIi0U3BDDAJjOlrFKqEWzPLC9IAOJEb13X9sY
         IWgHMQepeRI4WAjBH6mLq0KGF3JOJPiDK20ebrrojWlVtuGisDyMgd6Zj9zpxtHFHAjo
         tV3/BB2rz5LAtpTFEiMdZw4CUwRy5Tb38Z/O3r9IoKJxTAr9bGXUlvRSNIyWHu7OnuYx
         2+0y6tOlcCajF0C/2uEppP2KIDm+PYbXQRYASgeafUtIzusBj1PyhhLMp8UC8M/xLaRv
         dxig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:to;
        bh=a/YWlBQAaMsMP46Bem0O65dvMh/6zNAC0LweOl3PBGo=;
        b=dSFfe+8iCr6E8QvJQ0n85MoWRmQG7fJ1iKFH1q5tV8D9jRAqGXMg3aok9DI7vkWcqE
         s8z2CYspfHRvfLBNRqH8w1rckPlSIxMI03JZveVdNRIEEy0KBwHgvUpx+8A6d4SmhpJX
         m4zisInRJvx0ystACLhYZFVbwgfCQMmtzmW5LuFfT/sVtKpawPNSyzgacpuSp7niT74G
         ZcLZ7vwrXdnArVmhqNhIC34ORSTdQEnpMykKulA2kCeYR1gasj3KnVgtIyeTHSyaoaUu
         8ZXXmNnONSjdLmVmMAYVJpgLFm8zqSBoUek0NtgEhXB5n6TIiWZcBFkz/wRqB10iF3rD
         hbLQ==
X-Gm-Message-State: APjAAAXyhp+VWnd1/aPo5vP4pvxWynkd3hsgr4QVZJV2UiroZVmhmFnw
        cN5gUeWzwgPMV5S8YVscIhk=
X-Google-Smtp-Source: APXvYqyv3LTzEUxkB0fisiWaY4ZAv9E8LOqkq0WjQEPRvCB15yA1BjKqAL647N3TVqKVLPlPDGEOJA==
X-Received: by 2002:a17:902:2bc9:: with SMTP id l67mr24126622plb.171.1558142101406;
        Fri, 17 May 2019 18:15:01 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (122-58-182-39-adsl.sparkbb.co.nz. [122.58.182.39])
        by smtp.gmail.com with ESMTPSA id v2sm9299850pgr.2.2019.05.17.18.15.00
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Fri, 17 May 2019 18:15:00 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id C9158360079; Sat, 18 May 2019 13:14:56 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     netdev@vger.kernel.org
Cc:     schmitz@debian.org, Michael Schmitz <schmitzmic@gmail.com>,
        andrew@lunn.ch, davem@davemloft.net, sfr@canb.auug.org.au
Subject: [PATCH v2] net: phy: rename Asix Electronics PHY driver
Date:   Sat, 18 May 2019 13:14:55 +1200
Message-Id: <1558142095-20307-1-git-send-email-schmitzmic@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20190514105649.512267cd@canb.auug.org.au>
References: <20190514105649.512267cd@canb.auug.org.au>
To:     netdev@vger.kernel-org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 31dd83b96641 ("net-next: phy: new Asix Electronics PHY driver")
introduced a new PHY driver drivers/net/phy/asix.c that causes a module
name conflict with a pre-existiting driver (drivers/net/usb/asix.c).

The PHY driver is used by the X-Surf 100 ethernet card driver, and loaded
by that driver via its PHY ID. A rename of the driver looks unproblematic.

Rename PHY driver to ax88796b.c in order to resolve name conflict.

Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
Fixes: 31dd83b96641 ("net-next: phy: new Asix Electronics PHY driver")
---

Changes from v1:

- merge into single commit (suggested by Andrew Lunn)
---
 drivers/net/ethernet/8390/Kconfig |  2 +-
 drivers/net/phy/Kconfig           |  2 +-
 drivers/net/phy/Makefile          |  2 +-
 drivers/net/phy/asix.c            | 57 ---------------------------------------
 drivers/net/phy/ax88796b.c        | 57 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 60 insertions(+), 60 deletions(-)

diff --git a/drivers/net/ethernet/8390/Kconfig b/drivers/net/ethernet/8390/Kconfig
index f2f0264..443b34e 100644
--- a/drivers/net/ethernet/8390/Kconfig
+++ b/drivers/net/ethernet/8390/Kconfig
@@ -49,7 +49,7 @@ config XSURF100
 	tristate "Amiga XSurf 100 AX88796/NE2000 clone support"
 	depends on ZORRO
 	select AX88796
-	select ASIX_PHY
+	select AX88796B_PHY
 	help
 	  This driver is for the Individual Computers X-Surf 100 Ethernet
 	  card (based on the Asix AX88796 chip). If you have such a card,
diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index d629971..5496e5c 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -253,7 +253,7 @@ config AQUANTIA_PHY
 	---help---
 	  Currently supports the Aquantia AQ1202, AQ2104, AQR105, AQR405
 
-config ASIX_PHY
+config AX88796B_PHY
 	tristate "Asix PHYs"
 	help
 	  Currently supports the Asix Electronics PHY found in the X-Surf 100
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index 27d7f9f..5b5c866 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -52,7 +52,7 @@ ifdef CONFIG_HWMON
 aquantia-objs			+= aquantia_hwmon.o
 endif
 obj-$(CONFIG_AQUANTIA_PHY)	+= aquantia.o
-obj-$(CONFIG_ASIX_PHY)		+= asix.o
+obj-$(CONFIG_AX88796B_PHY)	+= ax88796b.o
 obj-$(CONFIG_AT803X_PHY)	+= at803x.o
 obj-$(CONFIG_BCM63XX_PHY)	+= bcm63xx.o
 obj-$(CONFIG_BCM7XXX_PHY)	+= bcm7xxx.o
diff --git a/drivers/net/phy/asix.c b/drivers/net/phy/asix.c
deleted file mode 100644
index 79bf7ef..0000000
--- a/drivers/net/phy/asix.c
+++ /dev/null
@@ -1,57 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0+
-/* Driver for Asix PHYs
- *
- * Author: Michael Schmitz <schmitzmic@gmail.com>
- */
-#include <linux/kernel.h>
-#include <linux/errno.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/mii.h>
-#include <linux/phy.h>
-
-#define PHY_ID_ASIX_AX88796B		0x003b1841
-
-MODULE_DESCRIPTION("Asix PHY driver");
-MODULE_AUTHOR("Michael Schmitz <schmitzmic@gmail.com>");
-MODULE_LICENSE("GPL");
-
-/**
- * asix_soft_reset - software reset the PHY via BMCR_RESET bit
- * @phydev: target phy_device struct
- *
- * Description: Perform a software PHY reset using the standard
- * BMCR_RESET bit and poll for the reset bit to be cleared.
- * Toggle BMCR_RESET bit off to accommodate broken AX8796B PHY implementation
- * such as used on the Individual Computers' X-Surf 100 Zorro card.
- *
- * Returns: 0 on success, < 0 on failure
- */
-static int asix_soft_reset(struct phy_device *phydev)
-{
-	int ret;
-
-	/* Asix PHY won't reset unless reset bit toggles */
-	ret = phy_write(phydev, MII_BMCR, 0);
-	if (ret < 0)
-		return ret;
-
-	return genphy_soft_reset(phydev);
-}
-
-static struct phy_driver asix_driver[] = { {
-	.phy_id		= PHY_ID_ASIX_AX88796B,
-	.name		= "Asix Electronics AX88796B",
-	.phy_id_mask	= 0xfffffff0,
-	/* PHY_BASIC_FEATURES */
-	.soft_reset	= asix_soft_reset,
-} };
-
-module_phy_driver(asix_driver);
-
-static struct mdio_device_id __maybe_unused asix_tbl[] = {
-	{ PHY_ID_ASIX_AX88796B, 0xfffffff0 },
-	{ }
-};
-
-MODULE_DEVICE_TABLE(mdio, asix_tbl);
diff --git a/drivers/net/phy/ax88796b.c b/drivers/net/phy/ax88796b.c
new file mode 100644
index 0000000..79bf7ef
--- /dev/null
+++ b/drivers/net/phy/ax88796b.c
@@ -0,0 +1,57 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Driver for Asix PHYs
+ *
+ * Author: Michael Schmitz <schmitzmic@gmail.com>
+ */
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/mii.h>
+#include <linux/phy.h>
+
+#define PHY_ID_ASIX_AX88796B		0x003b1841
+
+MODULE_DESCRIPTION("Asix PHY driver");
+MODULE_AUTHOR("Michael Schmitz <schmitzmic@gmail.com>");
+MODULE_LICENSE("GPL");
+
+/**
+ * asix_soft_reset - software reset the PHY via BMCR_RESET bit
+ * @phydev: target phy_device struct
+ *
+ * Description: Perform a software PHY reset using the standard
+ * BMCR_RESET bit and poll for the reset bit to be cleared.
+ * Toggle BMCR_RESET bit off to accommodate broken AX8796B PHY implementation
+ * such as used on the Individual Computers' X-Surf 100 Zorro card.
+ *
+ * Returns: 0 on success, < 0 on failure
+ */
+static int asix_soft_reset(struct phy_device *phydev)
+{
+	int ret;
+
+	/* Asix PHY won't reset unless reset bit toggles */
+	ret = phy_write(phydev, MII_BMCR, 0);
+	if (ret < 0)
+		return ret;
+
+	return genphy_soft_reset(phydev);
+}
+
+static struct phy_driver asix_driver[] = { {
+	.phy_id		= PHY_ID_ASIX_AX88796B,
+	.name		= "Asix Electronics AX88796B",
+	.phy_id_mask	= 0xfffffff0,
+	/* PHY_BASIC_FEATURES */
+	.soft_reset	= asix_soft_reset,
+} };
+
+module_phy_driver(asix_driver);
+
+static struct mdio_device_id __maybe_unused asix_tbl[] = {
+	{ PHY_ID_ASIX_AX88796B, 0xfffffff0 },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(mdio, asix_tbl);
-- 
1.9.1

