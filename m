Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFB9D1368FC
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 09:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbgAJI3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 03:29:36 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:42196 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbgAJI3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 03:29:36 -0500
Received: by mail-lf1-f68.google.com with SMTP id y19so797980lfl.9
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 00:29:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sFutGcrrh/hQJaQ4Eee8Dh8Xm/R1r/Lfh3IwOeBx/5U=;
        b=BgFId1bzzZBXpeJwPBZf35c0gHTUg2tLqxVI89gl7SR0CatVS8PSVMT5hQV2cyTSDh
         O2VnZ2KSavbSU4umG5CZoGpvVnIRNc7Yjpa2e6fTH8cZ7lFMTpzWvTmYcVzMufPfNQjP
         AyYN6PNPBVYhTHgnqfcvAbNLhWFkGf9DfbdepmLXVyzWJyEejs76/qq/AXHZhR/DE1Us
         7auiM6cAKP8+8FMvu/yiZTUUNWoitNaNh5SbQNGwEOJZcK9jSoo6Q6Itn/yNrvL2oRxn
         nhjNUUuGafYJMk16IrV6hjEpZyVzUJFYjX3EKUw9Bug+ggBRv/FpnMf2avcLqtjF3Fil
         4PKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sFutGcrrh/hQJaQ4Eee8Dh8Xm/R1r/Lfh3IwOeBx/5U=;
        b=fssWxN6+KB/GUYkf/v0hw8RhYJQsLs3f67yTjpGR+t71y3nfZJd3SNgzBVmJS6gGtP
         kcUrpJUZLmgzbvQpWfFUUzOAOgxEbbtBcISwdBeoF7lMyh0BimUuyzUzWPfyREzVxiRF
         7lRa4S7ar6ZsrihUzBzUbqVYhwS0WKmMH/CNcCsJP7jyYCmmQ58I7hP7FDbF4FwrABhd
         QWe4b8Bv6CM1NUY1wjiuA/AV+hCJmgkM8JbSAaViAXxkrDo+txohxqHn5ALZERpKKVQl
         STFUEFYXmGCc6/caDeGQYCAIcXl7Z/B79UbQZgUv0bzMVF1M5fYY/u766JPLJcq6SFdm
         tgWg==
X-Gm-Message-State: APjAAAU3b4QBOUY9knXJEWfqfnu10FbPXA9KYk4RAqrT+tYQia9u7AnK
        zPQtElHvnYiLML1kdRxxngm6CaYWjYJgAw==
X-Google-Smtp-Source: APXvYqyB0IbxbV/R7dm0/cmWC9pivMAomT2C0uh9f8IpPWZ6uJtTEOYamKQS1mFGWT1ue4YaoQ3unw==
X-Received: by 2002:a05:6512:40e:: with SMTP id u14mr1433265lfk.161.1578644973356;
        Fri, 10 Jan 2020 00:29:33 -0800 (PST)
Received: from linux.local (c-5ac9225c.014-348-6c756e10.bbcust.telenor.se. [92.34.201.90])
        by smtp.gmail.com with ESMTPSA id g24sm606464lfb.85.2020.01.10.00.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 00:29:32 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 4/9 v4] ixp4xx_eth: move platform_data definition
Date:   Fri, 10 Jan 2020 09:28:32 +0100
Message-Id: <20200110082837.11473-5-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200110082837.11473-1-linus.walleij@linaro.org>
References: <20200110082837.11473-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The platform data is needed to compile the driver as standalone,
so move it to a global location along with similar files.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v3->v4:
- Drop a stable tag and rebubmit.
ChangeLog v2->v3:
- Rebased on v5.5-rc1
ChangeLog v1->v2:
- Rebased on the rest of the series.
---
 arch/arm/mach-ixp4xx/include/mach/platform.h  | 13 +------------
 .../xscale/{ptp_ixp46x.h => ixp46x_ts.h}      |  0
 drivers/net/ethernet/xscale/ixp4xx_eth.c      |  1 +
 include/linux/platform_data/eth_ixp4xx.h      | 19 +++++++++++++++++++
 4 files changed, 21 insertions(+), 12 deletions(-)
 rename drivers/net/ethernet/xscale/{ptp_ixp46x.h => ixp46x_ts.h} (100%)
 create mode 100644 include/linux/platform_data/eth_ixp4xx.h

diff --git a/arch/arm/mach-ixp4xx/include/mach/platform.h b/arch/arm/mach-ixp4xx/include/mach/platform.h
index 04ef8025accc..6d403fe0bf52 100644
--- a/arch/arm/mach-ixp4xx/include/mach/platform.h
+++ b/arch/arm/mach-ixp4xx/include/mach/platform.h
@@ -15,6 +15,7 @@
 #ifndef __ASSEMBLY__
 
 #include <linux/reboot.h>
+#include <linux/platform_data/eth_ixp4xx.h>
 
 #include <asm/types.h>
 
@@ -92,18 +93,6 @@ struct ixp4xx_pata_data {
 	void __iomem	*cs1;
 };
 
-#define IXP4XX_ETH_NPEA		0x00
-#define IXP4XX_ETH_NPEB		0x10
-#define IXP4XX_ETH_NPEC		0x20
-
-/* Information about built-in Ethernet MAC interfaces */
-struct eth_plat_info {
-	u8 phy;		/* MII PHY ID, 0 - 31 */
-	u8 rxq;		/* configurable, currently 0 - 31 only */
-	u8 txreadyq;
-	u8 hwaddr[6];
-};
-
 /*
  * Frequency of clock used for primary clocksource
  */
diff --git a/drivers/net/ethernet/xscale/ptp_ixp46x.h b/drivers/net/ethernet/xscale/ixp46x_ts.h
similarity index 100%
rename from drivers/net/ethernet/xscale/ptp_ixp46x.h
rename to drivers/net/ethernet/xscale/ixp46x_ts.h
diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index 0075ecdb21f4..e811bf0d23cb 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -29,6 +29,7 @@
 #include <linux/net_tstamp.h>
 #include <linux/of.h>
 #include <linux/phy.h>
+#include <linux/platform_data/eth_ixp4xx.h>
 #include <linux/platform_device.h>
 #include <linux/ptp_classify.h>
 #include <linux/slab.h>
diff --git a/include/linux/platform_data/eth_ixp4xx.h b/include/linux/platform_data/eth_ixp4xx.h
new file mode 100644
index 000000000000..6f652ea0c6ae
--- /dev/null
+++ b/include/linux/platform_data/eth_ixp4xx.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __PLATFORM_DATA_ETH_IXP4XX
+#define __PLATFORM_DATA_ETH_IXP4XX
+
+#include <linux/types.h>
+
+#define IXP4XX_ETH_NPEA		0x00
+#define IXP4XX_ETH_NPEB		0x10
+#define IXP4XX_ETH_NPEC		0x20
+
+/* Information about built-in Ethernet MAC interfaces */
+struct eth_plat_info {
+	u8 phy;		/* MII PHY ID, 0 - 31 */
+	u8 rxq;		/* configurable, currently 0 - 31 only */
+	u8 txreadyq;
+	u8 hwaddr[6];
+};
+
+#endif
-- 
2.21.0

