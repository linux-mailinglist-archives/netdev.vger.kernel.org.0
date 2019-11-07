Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C025F2C35
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 11:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388313AbfKGKbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 05:31:40 -0500
Received: from mo4-p04-ob.smtp.rzone.de ([85.215.255.121]:23709 "EHLO
        mo4-p04-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388099AbfKGKb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 05:31:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1573122682;
        s=strato-dkim-0002; d=goldelico.com;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=k/zXWRFysUONFZ8EurLJhf/GewzB0f/HPeuH2i53BF8=;
        b=pZOUupdbd3F4t3DIfxbncArRzsWF+b9I5HGtSDdQwahSWg6uDOW6DGFZ/wUJDqzzig
        ZoQoqAY3yKzGUsDVYMkKQbclc1/O8mHG07Ujgai/3a/9gltKL7J0Ypqk6sHTKhJqvVbs
        6ft8fftmNH0DYBiCJjlov4Rq/RR87hi72vkDVbv5Gsmb4ytkyiPqNGmNwwOREdP4thSC
        hYDJQLO9b67CI0hy06ZYjk488xkjh2lefrizLqeV//XI0ktj03LlyZM58vf1u7Qozir2
        zXt6SJs+2sXG8bY/LHZpSyesTKr1GR+i8D7iHraWcFU/HCozbNlCGtP117t0HTQwujJt
        vftA==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o1OAA2UNf2M7PR5/L9P0"
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 44.29.0 DYNA|AUTH)
        with ESMTPSA id L09db3vA7AUvdS5
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Thu, 7 Nov 2019 11:30:57 +0100 (CET)
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
To:     =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        David Sterba <dsterba@suse.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Petr Mladek <pmladek@suse.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Yangtao Li <tiny.windzz@gmail.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, letux-kernel@openphoenux.org,
        kernel@pyra-handheld.com, stable@vger.kernel.org
Subject: [PATCH v3 12/12] net: wireless: ti: remove local VENDOR_ID and DEVICE_ID definitions
Date:   Thu,  7 Nov 2019 11:30:45 +0100
Message-Id: <3f2a982b3be2c90e5e0af5869df8580793b39882.1573122644.git.hns@goldelico.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <cover.1573122644.git.hns@goldelico.com>
References: <cover.1573122644.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

They are already included from mmc/sdio_ids.h and do not need
a local definition.

Fixes: 884f38607897 ("mmc: core: move some sdio IDs out of quirks file")

Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Acked-by: Kalle Valo <kvalo@codeaurora.org>
Cc: <stable@vger.kernel.org> # 4.11.0
---
 drivers/net/wireless/ti/wl1251/sdio.c | 8 --------
 drivers/net/wireless/ti/wlcore/sdio.c | 8 --------
 2 files changed, 16 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/sdio.c b/drivers/net/wireless/ti/wl1251/sdio.c
index 42b55f3a50df..3c4d5e38c66c 100644
--- a/drivers/net/wireless/ti/wl1251/sdio.c
+++ b/drivers/net/wireless/ti/wl1251/sdio.c
@@ -22,14 +22,6 @@
 
 #include "wl1251.h"
 
-#ifndef SDIO_VENDOR_ID_TI
-#define SDIO_VENDOR_ID_TI		0x104c
-#endif
-
-#ifndef SDIO_DEVICE_ID_TI_WL1251
-#define SDIO_DEVICE_ID_TI_WL1251	0x9066
-#endif
-
 struct wl1251_sdio {
 	struct sdio_func *func;
 	u32 elp_val;
diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index 7afaf35f2453..9fd8cf2d270c 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -26,14 +26,6 @@
 #include "wl12xx_80211.h"
 #include "io.h"
 
-#ifndef SDIO_VENDOR_ID_TI
-#define SDIO_VENDOR_ID_TI		0x0097
-#endif
-
-#ifndef SDIO_DEVICE_ID_TI_WL1271
-#define SDIO_DEVICE_ID_TI_WL1271	0x4076
-#endif
-
 static bool dump = false;
 
 struct wl12xx_sdio_glue {
-- 
2.23.0

