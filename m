Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABF49DDA28
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 20:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbfJSSlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 14:41:51 -0400
Received: from mo4-p04-ob.smtp.rzone.de ([85.215.255.124]:11081 "EHLO
        mo4-p04-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbfJSSlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 14:41:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1571510508;
        s=strato-dkim-0002; d=goldelico.com;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=m5FFZdsdBCqqg1hmXc2h2EqcsFELI7K5BJyc80+siFs=;
        b=INxsEi6iU3Mm6GQAZ5Aguf97myydAd51gUmLrzjxCrjS7V0gMDdvC+vFH0X9J4+ofi
        zefVz056kZSByXOJi/YFY/pcydIbTHIQYk9Guy0CJoEXo1lglCsQceKlSPyJBUgEr642
        l505Ogx4K9ohlj5RcFU9ySFr6oL3h2OJRp11BQMeL9bQ56MA6yKU5N76vgBtcd+lCRyP
        NHkIRHhKGg/YynMUFTMQYSiBWbvWCJi83tGzKMVy82mTIyvdAirFXlcvRas8PZhGlFqV
        OHDznFx/j0dB+8AUncVnU0u4SxZ9aWFXdOqJXnTollgpUbQBOsqnr8gwmJp/m7Fj5eHQ
        D//A==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o12DNOsPj0pAyXkHTz8="
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 44.28.1 DYNA|AUTH)
        with ESMTPSA id R0b2a8v9JIfbFMV
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Sat, 19 Oct 2019 20:41:37 +0200 (CEST)
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
Subject: [PATCH v2 10/11] net: wireless: ti: wl1251 use new SDIO_VENDOR_ID_TI_WL1251 definition
Date:   Sat, 19 Oct 2019 20:41:25 +0200
Message-Id: <e6624c904e767924911068c2c169d078eae35839.1571510481.git.hns@goldelico.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1571510481.git.hns@goldelico.com>
References: <cover.1571510481.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SDIO_VENDOR_ID_TI_WL1251 is now defined in mmc/sdio_ids.h separately
from SDIO_VENDOR_ID_TI for wl1271.

Fixes: 884f38607897 ("mmc: core: move some sdio IDs out of quirks file")

Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Acked-by: Kalle Valo <kvalo@codeaurora.org>
Cc: <stable@vger.kernel.org> # 4.11.0
---
 drivers/net/wireless/ti/wl1251/sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl1251/sdio.c b/drivers/net/wireless/ti/wl1251/sdio.c
index c54a273713ed..42b55f3a50df 100644
--- a/drivers/net/wireless/ti/wl1251/sdio.c
+++ b/drivers/net/wireless/ti/wl1251/sdio.c
@@ -52,7 +52,7 @@ static void wl1251_sdio_interrupt(struct sdio_func *func)
 }
 
 static const struct sdio_device_id wl1251_devices[] = {
-	{ SDIO_DEVICE(SDIO_VENDOR_ID_TI, SDIO_DEVICE_ID_TI_WL1251) },
+	{ SDIO_DEVICE(SDIO_VENDOR_ID_TI_WL1251, SDIO_DEVICE_ID_TI_WL1251) },
 	{}
 };
 MODULE_DEVICE_TABLE(sdio, wl1251_devices);
-- 
2.19.1

