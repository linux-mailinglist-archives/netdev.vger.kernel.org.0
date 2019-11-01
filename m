Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C113EC36D
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 14:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbfKANCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 09:02:41 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:38204 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727085AbfKANCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 09:02:40 -0400
Received: by mail-lf1-f65.google.com with SMTP id q28so7192901lfa.5
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 06:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fC3l+99+MK7bv8CZSBvWRePbspAxuFq+FAjKHtOpPDw=;
        b=RRahzDy9ZxtumMt3mGy7SDUZ5VKVa6x4XD491bg8aJEbfEGYep3o74FuPHXNOufrzh
         CpZ6Q3Sk+uYqTSSmjfs1iMSH+iIeODcjBImBDcd1ERrO7sNiXlhymoL1ZnZIMUnaq2Zm
         +aIW/ZMUYTEDwbRC0uRR1aV+lw7X5dRg1b1O8yk647csDrZIcza2oQkxL2KspxEx5C7t
         TR1u6Lc/PQyS0Ges2eFopfOhyl9mx+ycQeyw+c7PbaH/bvvmHzBm+DfjJlzQP3TB8Zhq
         GtHAyVjNPAE8wqP0FzfxeZNnjAs6D9GaVKmg7t80mwjzT2zf11+XIVACqBEd/vFsO1VY
         4A4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fC3l+99+MK7bv8CZSBvWRePbspAxuFq+FAjKHtOpPDw=;
        b=Wa953jfyspALcyT6UcoppUDQCBa9Dtp/CYNididC8y2YsEvTyQu3I+zKSIeucfuAjC
         UoOYG+wzyOnt4+cOdQ4prlqOFQIaFBffW7RamOcFfozROKEm3m8msLWl255m7KLSzbof
         y4W565+sN3JdvpfteQxawIOdPmR3U+Dk+0s86+29lVtVoiMOoVpAtqkLhCY6k0n8Px9x
         pgb1OBUbR2fCkB579V4E8MWkIdpeHBlNsd1BBw2hZuTnAUXZ3QgMRH5QIgs4erume3Fz
         tEXiCNee2rGbFPC4wgJvhv+iInOcTa9U1/n+aKvJjTKiveJ+L7jkg+nFqR8zzuYmc5aN
         mj9w==
X-Gm-Message-State: APjAAAUfIDqbMvKf0ZXLHMXwbbFN41V3uVsLX7718OEv4cQ69sL9j2E5
        92Pqmv6oPnHWN+NgYqp+ePc2i8fjh9zsDg==
X-Google-Smtp-Source: APXvYqyEpgx3CfeqNxcpzpnpjbyiU4JA3zju8wAI8MrViFlS4wI927Emju2ZEGe93sE0nBNvKU9bag==
X-Received: by 2002:a19:41c8:: with SMTP id o191mr7276833lfa.101.1572613358142;
        Fri, 01 Nov 2019 06:02:38 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-79c8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.200.121])
        by smtp.gmail.com with ESMTPSA id c3sm2516749lfi.32.2019.11.01.06.02.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 06:02:36 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 04/10 v2] ixp4xx_eth: move platform_data definition
Date:   Fri,  1 Nov 2019 14:02:18 +0100
Message-Id: <20191101130224.7964-5-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191101130224.7964-1-linus.walleij@linaro.org>
References: <20191101130224.7964-1-linus.walleij@linaro.org>
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

