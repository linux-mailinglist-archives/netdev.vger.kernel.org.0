Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B912CD61E
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 13:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730612AbgLCMvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 07:51:48 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:32951 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730503AbgLCMur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 07:50:47 -0500
Received: from orion.localdomain ([95.118.71.13]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1Mrfgi-1kPmZ03hwK-00nkW5; Thu, 03 Dec 2020 13:48:07 +0100
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     rspringer@google.com, toddpoynor@google.com, benchan@chromium.org,
        rcy@google.com, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, f.fainelli@gmail.com, rjui@broadcom.com,
        sbranden@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        nsaenzjulienne@suse.de, speakup@linux-speakup.org,
        devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 03/11] drivers: staging: gdm724x: remove unneeded MODULE_VERSION() call
Date:   Thu,  3 Dec 2020 13:47:55 +0100
Message-Id: <20201203124803.23390-3-info@metux.net>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20201203124803.23390-1-info@metux.net>
References: <20201203124803.23390-1-info@metux.net>
X-Provags-ID: V03:K1:y/GRYT+te7Xvb7tqixaHWNKlrsFAQsktrzB4LZEe1ypwz1DoS68
 HNy5FLm7U6iklFSixKOCHtXY2kF48DiVaeuPrLGmy0DXsQZyGMBuHVtCM4C5T04ORFcmFb9
 1QNyTCBTBB861jFXXj1JCfg22dQDfhM52ieKjGpOtFqygA1jxZCid554JQBNmBAL1CCYJAD
 Xllzu1X8tGbIRTfaM6k7w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:f24F5x+x0sk=:/niJrw9CbZxm8SsYM0Uqyt
 54SI3myUUg/yESet1Neh6kEryUvzRVV3D0etBZG1U06WU041rOie57lSUYeSpCaCPH4n56OD8
 s9Lklkmj/Ci16AIN+3FKW8HBz1z41XUzntXRkm4uT6ZHah3Yq31iG8aXQLCQmmfVaRIwxZom9
 B4kCaZVaCKyWrxvVoVM814L+H+SJjk+qy7fStVwXdn1AlegP5MuSjQhNw7KJy7Z+a/nJoDVQL
 XHya0MD8jPFKQrJsem41b3YKrCluMZqOU9ZeXI7mIg8TDcQidGv/7ur3I/buC/U5nlZEGcX1z
 Watp+frjGAYm8TtIboTE9++3BRc/Rlbi77wRIro32Fwg9VjGRd9q3pS2srkwZLZKWOF9LjCQr
 bq3XFUNXcAOhVeYgObI7ew9jNXoEuYKcCVgbB85Zm+CLTJk+Ph9L3wBKvp68P
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove MODULE_VERSION(), as it doesn't seem to serve any practical purpose.
For in-kernel drivers, the kernel version matters. And the code has received
lots of changes, without the version ever been touched (remained constant
since landing in the mainline tree), so it doesn't seem to have any practical
meaning anymore.

Signed-off-by: Enrico Weigelt <info@metux.net>
---
 drivers/staging/gdm724x/gdm_lte.h | 1 -
 drivers/staging/gdm724x/gdm_usb.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/staging/gdm724x/gdm_lte.h b/drivers/staging/gdm724x/gdm_lte.h
index f2143a6e0e99..bf6478ab05dd 100644
--- a/drivers/staging/gdm724x/gdm_lte.h
+++ b/drivers/staging/gdm724x/gdm_lte.h
@@ -11,7 +11,6 @@
 
 #define MAX_NIC_TYPE		4
 #define MAX_RX_SUBMIT_COUNT	3
-#define DRIVER_VERSION		"3.7.17.0"
 
 enum TX_ERROR_CODE {
 	TX_NO_ERROR = 0,
diff --git a/drivers/staging/gdm724x/gdm_usb.c b/drivers/staging/gdm724x/gdm_usb.c
index dc4da66c3695..aa6f08396396 100644
--- a/drivers/staging/gdm724x/gdm_usb.c
+++ b/drivers/staging/gdm724x/gdm_usb.c
@@ -1003,6 +1003,5 @@ static void __exit gdm_usb_lte_exit(void)
 module_init(gdm_usb_lte_init);
 module_exit(gdm_usb_lte_exit);
 
-MODULE_VERSION(DRIVER_VERSION);
 MODULE_DESCRIPTION("GCT LTE USB Device Driver");
 MODULE_LICENSE("GPL");
-- 
2.11.0

