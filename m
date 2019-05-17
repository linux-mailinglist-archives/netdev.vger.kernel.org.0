Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 710D821F11
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 22:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbfEQUZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 16:25:34 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35237 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727376AbfEQUZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 16:25:31 -0400
Received: by mail-pl1-f195.google.com with SMTP id g5so3842632plt.2
        for <netdev@vger.kernel.org>; Fri, 17 May 2019 13:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references:to;
        bh=e2vgPnRnTCYoItCyxvn2xwjezeEIGETgdgmjGUXnQ9w=;
        b=ccOMIxF20guZMcu+V7oGTqcoTvpdccAjkN10tYFxHS+yVDW4y4Ce9HW0Z9dtSIWOYR
         0DiTSqY0zkRkxl6LNLgLEpBaB+KnL5AuKGnSKP6Ev52iwCW1q7CXd3fIAI4mRrk9vcqx
         s6KWlGwWl7htHYVhIv6WYqdbF1iISMdyFA8L+6+dc7lKIAFX/MU6B6lGaDbN5nMjMT4a
         WftyvC9jBlOjF8UDGhrVkrFOFpGB2aI53cih2FGagztWfaR+zqL1yQJVM2/wIYXHNgqQ
         /spRzrCgP20l9xbjK5l8gVFP/Cq8uyf0KVwH1Pe0B2+b/3EeER4hzRbb5ICc/2t6wG6X
         HPRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references:to;
        bh=e2vgPnRnTCYoItCyxvn2xwjezeEIGETgdgmjGUXnQ9w=;
        b=Zo6hbcIvpQ8Y/B78pz9TUIO3glljeXuWyjAOmoMBoVPG3IxcDfS08A4l3khQFTyc34
         ehkGOaIEQsHqxuaqmLFnoAeri8XVL/wtua6IwuLLPGbQylsXt2pf2ZyHZsnYbaem74Zd
         94JrXWc2+Oyqn3vHUbZPy5qqYtq1b73fwkCt1iJ2Jn5grggaNp0tvLJ7lrZTuX5r4WVP
         jHjlMsI1TzOPOdo4xnt7P6GzB91z4EnO5VhzLbfXTc339dHwqymF6x2AN0oW7lfHUms7
         E4PDGkWqAvZOcQUy9l5FoTsEKZNGPNCUiXgsoprT/DTF8+iQnz4oQEWaN0WdpPMcz7rM
         a0AQ==
X-Gm-Message-State: APjAAAXUwJ1qC8w9ni0RsUKCd0y/svDbN+5Ez9RmvrvwNjgrsbqKKogN
        s3ru7DtMqRTY0CQXde7QMos=
X-Google-Smtp-Source: APXvYqzJuj1meNRBzyDlWDIpUpdwPKxYt2kQjwxddN2FN07vkW+0EO7y9GqWbqXxLdaTfUoL9ta6+Q==
X-Received: by 2002:a17:902:b949:: with SMTP id h9mr16337023pls.50.1558124731024;
        Fri, 17 May 2019 13:25:31 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (122-58-182-39-adsl.sparkbb.co.nz. [122.58.182.39])
        by smtp.gmail.com with ESMTPSA id s17sm10957839pfm.149.2019.05.17.13.25.30
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Fri, 17 May 2019 13:25:30 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id 8683D360079; Sat, 18 May 2019 08:25:27 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     netdev@vger.kernel.org
Cc:     schmitz@debian.org, Michael Schmitz <schmitzmic@gmail.com>,
        sfr@canb.auug.org.au, davem@davemloft.net
Subject: [PATCH 3/3] net: phy: remove old Asix Electronics PHY driver
Date:   Sat, 18 May 2019 08:25:18 +1200
Message-Id: <1558124718-19209-4-git-send-email-schmitzmic@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1558124718-19209-1-git-send-email-schmitzmic@gmail.com>
References: <1558124718-19209-1-git-send-email-schmitzmic@gmail.com>
In-Reply-To: <20190514105649.512267cd@canb.auug.org.au>
References: <20190514105649.512267cd@canb.auug.org.au>
To:     netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The asix.c driver name causes a module name conflict with a driver
of the same name in drivers/net/usb. Now that a new ax88796b.c driver
has been added, remove drivers/net/phy/asix.c.

Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
Fixes: 31dd83b96641 ("net-next: phy: new Asix Electronics PHY driver")
---
 drivers/net/phy/Kconfig  |  6 -----
 drivers/net/phy/Makefile |  1 -
 drivers/net/phy/asix.c   | 57 ------------------------------------------------
 3 files changed, 64 deletions(-)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 1647473..5496e5c 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -253,12 +253,6 @@ config AQUANTIA_PHY
 	---help---
 	  Currently supports the Aquantia AQ1202, AQ2104, AQR105, AQR405
 
-config ASIX_PHY
-	tristate "Asix PHYs"
-	help
-	  Currently supports the Asix Electronics PHY found in the X-Surf 100
-	  AX88796B package.
-
 config AX88796B_PHY
 	tristate "Asix PHYs"
 	help
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index cc5758a..5b5c866 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -52,7 +52,6 @@ ifdef CONFIG_HWMON
 aquantia-objs			+= aquantia_hwmon.o
 endif
 obj-$(CONFIG_AQUANTIA_PHY)	+= aquantia.o
-obj-$(CONFIG_ASIX_PHY)		+= asix.o
 obj-$(CONFIG_AX88796B_PHY)	+= ax88796b.o
 obj-$(CONFIG_AT803X_PHY)	+= at803x.o
 obj-$(CONFIG_BCM63XX_PHY)	+= bcm63xx.o
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
-- 
1.9.1

