Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3352CD5FF
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 13:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389070AbgLCMuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 07:50:54 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:55711 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389044AbgLCMuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 07:50:52 -0500
Received: from orion.localdomain ([95.118.71.13]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MCoYS-1ktdjX0ukS-008w2z; Thu, 03 Dec 2020 13:48:11 +0100
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     rspringer@google.com, toddpoynor@google.com, benchan@chromium.org,
        rcy@google.com, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, f.fainelli@gmail.com, rjui@broadcom.com,
        sbranden@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        nsaenzjulienne@suse.de, speakup@linux-speakup.org,
        devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 09/11] drivers: staging: rtl8192e: remove unneeded MODULE_VERSION() call
Date:   Thu,  3 Dec 2020 13:48:01 +0100
Message-Id: <20201203124803.23390-9-info@metux.net>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20201203124803.23390-1-info@metux.net>
References: <20201203124803.23390-1-info@metux.net>
X-Provags-ID: V03:K1:TWPmkvMRLe+RvSvuPagbKMS63HtX/xzJmb8w2MTfTkQSWtN8MuE
 d7qBVuYtmwsjFJW9rVHBB94Z/d4wpwb0RbxgZhF7DW1Pd4B5YrB7GVqudc3Okkrs/cbk0hb
 wpEPKqD7q5Npkh3McC87Qc2PnpfO4QTfipZwhrOTyZIuO3P4vIPgtk5IzMpWFUwIaYhfJLL
 KY9a+bUX9nduw5vCyGp8g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:K6oID9tUrnQ=:CM//xMqa9mV7ETaJ0BNeUg
 6ZNSYbSTHSCeQ84menR9DiDAANTYKHy0oR5ehOCMfO7zii6wlMymLiOGzPGNVhBa7QX9CB+Bm
 UdErWAcIwvwTzBrpWc013DMY8ZreOtvRNI12e5bs7eOAYgEKgUPrLOGwgSFRyl8Ax0f9Ky+di
 3abr8qqDymyiRc8Sqj5is7sSmWlmBY3tB6mwhcD0Zlk9PAdHJ1DPa1R+gxNfiVE3nPklz1Bcf
 CbJS3qDyEEpBDch0Hpx4EYGpl6daNjJN5z8xij/f1+KOYMXVMWNxzyNQPuJ+zw1oZ9EeO1C1w
 A9A8zAKnUSM5FKNxVSH9Fj3iWXTO8FJt1knNt4HCiwLmo5PVRaYghHwp2BHpSud9C+SFobpId
 UYYCDI/0DGBq/Mda6lfbUYujYw39f/VCvrjqEuQStLGT82Z/PGIgwe+XiLr02
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove MODULE_VERSION(), as it doesn't seem to have any practical purpose:
the driver has received lots of changes, while the module version remained
constant. Unmaintained version numbers aren't actually useful.

Signed-off-by: Enrico Weigelt <info@metux.net>
---
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
index 663675efcfe4..e316f920657b 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
@@ -2635,7 +2635,6 @@ void rtl92e_check_rfctrl_gpio_timer(struct timer_list *t)
  ***************************************************************************/
 MODULE_DESCRIPTION("Linux driver for Realtek RTL819x WiFi cards");
 MODULE_AUTHOR(DRV_COPYRIGHT " " DRV_AUTHOR);
-MODULE_VERSION(DRV_VERSION);
 MODULE_LICENSE("GPL");
 MODULE_FIRMWARE(RTL8192E_BOOT_IMG_FW);
 MODULE_FIRMWARE(RTL8192E_MAIN_IMG_FW);
-- 
2.11.0

