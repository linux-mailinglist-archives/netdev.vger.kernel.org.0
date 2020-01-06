Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18A0C130E22
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 08:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgAFHrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 02:47:02 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:35970 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbgAFHrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 02:47:01 -0500
Received: by mail-lj1-f193.google.com with SMTP id r19so49980863ljg.3
        for <netdev@vger.kernel.org>; Sun, 05 Jan 2020 23:46:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L5br/Q1dPlb6jV9exYpxiZf0cUo4raQUyYwLmLJT4sg=;
        b=ebwYYZcEbXJOIx0Ryw1LdzXMtJSB9nar0f8jlptxZIJkXMg7FdMQbHzfxTRLm3G7ac
         ilF9Ke7yq/rmA1NJXJ052u2ziirPucyuFHcWwitlBN0Dh5ww+zzY8sEcJ6Ej7sm6mtxv
         3PZhANMQKAqNFtX3JHc/3wmMhePJvgXSfGb9S7qpbIBFiTQQfmiCnVdc5lcHXsHYd+xo
         /ZMjx/i9XsIjhR56Wjx9OP/AtJnWeZ7dTB9gWbVj1X7XJmRcztU1LXGrI/UPbHaQeg+S
         /ZwBMtpyRn8NjnPPuRNrOQecfbCjrWTaqHK1itrKDlkllmO7UWCoDJEGrw8ZJGgEuHgb
         3Emg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L5br/Q1dPlb6jV9exYpxiZf0cUo4raQUyYwLmLJT4sg=;
        b=Ke7mSy1Q5ND/2oO8ft0rgT9YfxDyEx58V59l1WgNxunm0vUV+QXp9idwyUP4/u7JCU
         94uUe7UR/M66C3Nkh4nh5kPUiiotnvyyt4QWky1t7gYS1ugmay9AWOWQJveboC61gpWo
         tFzW/cscmZKhkZWRVXZ5lZsG5rRMKLNW5xmUAtubrjxiVBQBZswriNEEMIO16KmHfix5
         voE8WcdkyhZ9qZ0DO12yLC+iQQFME5MVRAN4fBR4RKlCUphg0m5DYWLWWPIP7exOFqtl
         ZXYGvd1812UoEc9Y4dH+yHNCvCkneZnKO9BDgZ8IEdGoT8FDMcJtYUwDpb2bkIfEk4Dt
         /A9w==
X-Gm-Message-State: APjAAAUlezZfXXHXDRIPbo5xWQLU8SFqeYg+pZjauRry5sJ1Xu7fys42
        MqsgvB37bNCLLxnoZInUG5Bk68ZPmKuevg==
X-Google-Smtp-Source: APXvYqyEBjrgT3G0sBGxuvn6M4QE0Lgl6SiXy7BsSLCu91fQbcRnWFKfC61HJ7oDthk8l30CimrM9g==
X-Received: by 2002:a2e:2e14:: with SMTP id u20mr52128451lju.82.1578296818565;
        Sun, 05 Jan 2020 23:46:58 -0800 (PST)
Received: from localhost.bredbandsbolaget (c-5ac9225c.014-348-6c756e10.bbcust.telenor.se. [92.34.201.90])
        by smtp.gmail.com with ESMTPSA id n14sm28625551lfe.5.2020.01.05.23.46.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jan 2020 23:46:57 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 4/9 v3] ixp4xx_eth: move platform_data definition
Date:   Mon,  6 Jan 2020 08:46:42 +0100
Message-Id: <20200106074647.23771-5-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200106074647.23771-1-linus.walleij@linaro.org>
References: <20200106074647.23771-1-linus.walleij@linaro.org>
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
ChanegLog v2->v3:
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

