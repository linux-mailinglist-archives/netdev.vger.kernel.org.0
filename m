Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77F8BF2C8C
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 11:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388622AbfKGKcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 05:32:54 -0500
Received: from mo4-p04-ob.smtp.rzone.de ([81.169.146.179]:36314 "EHLO
        mo4-p04-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727562AbfKGKbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 05:31:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1573122675;
        s=strato-dkim-0002; d=goldelico.com;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=JUFEWkDIRP0azyEcP43GRVaRk4iFbYhlL/y4F2cv+sQ=;
        b=NaQWgx4socECQQcMeqoNVsR7xq3KLFGpjP3lt9KaWmv1KEN5FelfxJpJNSiYpHig+r
        g6hFmtautpWJSh5dcYVoTwdaUp2spqNSLENoE1aEYOyQtnTb/jacSf/jB3pcShnxp2SI
        Vd1zRbowhbiC7ekCwY5BUMieEFXL+mOGDl/LC/GK8ntVZAmIiYrS84TNnSUgioO87on7
        1Ahq+9hPpXOkeQUeH9ujqbhRpBgFkYX7G+oo6X7YIJnZkF9bH6tBiFQLTHmYchwilgHa
        uMVoCFx+iH8tWe24BR8U4sx7kh99D/u9Pex7hyvjrwV90h18LbsDtCLJdl4cl6dY2t6u
        WpOA==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o1OAA2UNf2M7PR5/L9P0"
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 44.29.0 DYNA|AUTH)
        with ESMTPSA id L09db3vA7AUudS4
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Thu, 7 Nov 2019 11:30:56 +0100 (CET)
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
Subject: [PATCH v3 11/12] net: wireless: ti: wl1251 use new SDIO_VENDOR_ID_TI_WL1251 definition
Date:   Thu,  7 Nov 2019 11:30:44 +0100
Message-Id: <c5cbf6b891fade1afe3b70eb33823d7170233302.1573122644.git.hns@goldelico.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <cover.1573122644.git.hns@goldelico.com>
References: <cover.1573122644.git.hns@goldelico.com>
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
2.23.0

