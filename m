Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6A11138621
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 13:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732798AbgALMFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jan 2020 07:05:07 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:34459 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732774AbgALMFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jan 2020 07:05:05 -0500
Received: by mail-lf1-f67.google.com with SMTP id l18so4848992lfc.1
        for <netdev@vger.kernel.org>; Sun, 12 Jan 2020 04:05:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MixgobdfKveG9ge1VwQSvZFNCSbryox4dJdsf3OttWA=;
        b=Ba4BTjmaX9pcMmwZLe/yZAJnPBdYAusnGQYGMjO0o6h55KQjJX9FIEpKtTInS23IHS
         KJKBQMSpUKCXx9HexrSP6mZOx0Yvnp1rhs9HjJXbxgckP3X8teh8y4LqBi/usa/KBp3e
         cIq1zjKGg+0n2YvIRTwNzDW9UKJj0pPXL6ZsZ6M77ptE8Clm5PXLLXYSWK2+csQXy4QB
         6YweRqC1LO0qfMc9+wHxtkOGqweEKSUu+tVbWxNKQoyEVZOV/JQXmhlBDUkM4Fk0qaK+
         GpeZH5ehI37esvp9LrzLDrexhpozow1PwaDZM2EiWA6ym9ktUXSTvQJgY5LwKo1jKhHY
         OjQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MixgobdfKveG9ge1VwQSvZFNCSbryox4dJdsf3OttWA=;
        b=OsG8nyFnnh7s2LREJAfr0Ju67Zrli/vx+849CRl1QoBzbHUf6n9ypADZFgO7pw/Kxa
         zkYN4e+lXaw7fDwftb4qlbHNS30Ap+oBs7TrSJFqca+JFufQWDW98PJxnMPW2hj2MMN/
         58AAQJAxyWbbmDYLgwydUJsgQwbHyBK2weMWRr7zQ74m1aZLO1i2PEBgdSUjwXT8kMGq
         GHDs2tu4LXig8G9jRflwAwauikWm2R6clQjRSMix81x49JDw5hIWoYA/QsFBIDjwzzVJ
         1U5wJmFXpD8O4/Y+3veB1F6sAQtmU4HtHEC40h8MRRQBSaWYIkEAmd0aAq18ISgD1gsr
         NjUg==
X-Gm-Message-State: APjAAAVdygo+Wdxm+Ya5UQOHdXTAgV3jXQCaldY4DGqp+sYQooiHlLQa
        WKxMqh3Ywy1c/dX8WH6TJN5mvvZPLKeBrA==
X-Google-Smtp-Source: APXvYqws79y4ltSi1wSs26vGEt4sI8FugebLUqyw1w+ylAO9n4401BMoQsuXlIIvPWTxY9rqWkPzPw==
X-Received: by 2002:ac2:54b5:: with SMTP id w21mr6996491lfk.175.1578830703877;
        Sun, 12 Jan 2020 04:05:03 -0800 (PST)
Received: from localhost.bredbandsbolaget (c-5ac9225c.014-348-6c756e10.bbcust.telenor.se. [92.34.201.90])
        by smtp.gmail.com with ESMTPSA id z7sm4660347lfa.81.2020.01.12.04.05.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jan 2020 04:05:03 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 4/9 v5] ixp4xx_eth: move platform_data definition
Date:   Sun, 12 Jan 2020 13:04:45 +0100
Message-Id: <20200112120450.11874-5-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200112120450.11874-1-linus.walleij@linaro.org>
References: <20200112120450.11874-1-linus.walleij@linaro.org>
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
ChangeLog v4->v5:
- Renase onto the net-next tree
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

