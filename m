Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5402CD5FA
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 13:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389018AbgLCMuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 07:50:50 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:37063 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730527AbgLCMut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 07:50:49 -0500
Received: from orion.localdomain ([95.118.71.13]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MsaeR-1jsPzT2mwF-00tyos; Thu, 03 Dec 2020 13:48:12 +0100
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     rspringer@google.com, toddpoynor@google.com, benchan@chromium.org,
        rcy@google.com, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, f.fainelli@gmail.com, rjui@broadcom.com,
        sbranden@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        nsaenzjulienne@suse.de, speakup@linux-speakup.org,
        devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 11/11] drivers: staging: rtl8723bs: remove unneeded MODULE_VERSION() call
Date:   Thu,  3 Dec 2020 13:48:03 +0100
Message-Id: <20201203124803.23390-11-info@metux.net>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20201203124803.23390-1-info@metux.net>
References: <20201203124803.23390-1-info@metux.net>
X-Provags-ID: V03:K1:K37+eyIhv0Jb/MzK3jnMGWBmLWepPJuiKdD1EOq0NyyZs+7YC10
 jE5E0O/ntftFAhWSpM6FBNp32u3g80+Y4PIwebTKvt5maocGGGDlttLPphBTnwemY9iA8P0
 Ea4YxF/NhpPtBLgkJnp+yOkmLcdgXZZYuMsiL86C1siiIxDdT7ySmroAcuRa8yKj912uvsa
 qTDf9K/Ihh8mumSlgcyiQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:qfkFQp5hoTE=:VCgOPZqPOsCzjVT2ig9+gx
 7c88PXwrJDy9bnQNZJel1Drz5LJfxrl+YLIyLCB8nQVheLEW+gNWDMcmEQwWXw3ORRnqU5Hq9
 sxLclY3Xas4uzGXxVbmNpsobNlDji0ie5fwBeZUeOUlIUWp6KHkpjwF/O96nj63n2iboEOxHB
 yoco/hULUQ7NYOaBzmh79eg58EFKG9ijM2U8cvlOuy2ka96guUAbtEH/PhksJB42t5yjlk2+0
 h9wzj7QMUnhvOt8yeRz0YoNUZf20XdOt43sKan/UTZ3uYMadWV5Bk+zOlwHNspxKsC1jPQCxZ
 c1ApsrHuA4tWHmbvquJz4EVxZ6y0EOZ5XBQ/oOqqYTEbdgiJjLXeYe6Vd2YpEOG7JfmLamlFA
 /7v8kDK1B2CRtvUIOY3nbiuHFwtwoBjCi9yJiiu19qWJnu4UieoAmFLxiKLUg
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove MODULE_VERSION(), as it doesn't seem to serve any practical purpose.
The driver received lots of changes, but module remained constant since
it landed in mainline, several years ago.

Signed-off-by: Enrico Weigelt <info@metux.net>
---
 drivers/staging/rtl8723bs/os_dep/os_intfs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/os_intfs.c b/drivers/staging/rtl8723bs/os_dep/os_intfs.c
index 27f990a01a23..0a94bab4fdcb 100644
--- a/drivers/staging/rtl8723bs/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8723bs/os_dep/os_intfs.c
@@ -13,7 +13,6 @@
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Realtek Wireless Lan Driver");
 MODULE_AUTHOR("Realtek Semiconductor Corp.");
-MODULE_VERSION(DRIVERVERSION);
 
 /* module param defaults */
 static int rtw_chip_version;
-- 
2.11.0

