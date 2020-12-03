Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAA72CD615
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 13:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730524AbgLCMus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 07:50:48 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:52313 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730504AbgLCMur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 07:50:47 -0500
Received: from orion.localdomain ([95.118.71.13]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MjBNV-1kHDye2uNp-00fBnI; Thu, 03 Dec 2020 13:48:09 +0100
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     rspringer@google.com, toddpoynor@google.com, benchan@chromium.org,
        rcy@google.com, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, f.fainelli@gmail.com, rjui@broadcom.com,
        sbranden@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        nsaenzjulienne@suse.de, speakup@linux-speakup.org,
        devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 07/11] drivers: staging: vc04_services: remove unneeded MODULE_VERSION() call
Date:   Thu,  3 Dec 2020 13:47:59 +0100
Message-Id: <20201203124803.23390-7-info@metux.net>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20201203124803.23390-1-info@metux.net>
References: <20201203124803.23390-1-info@metux.net>
X-Provags-ID: V03:K1:9XsuyMzeLdDwbcF1TI1lSA8b7w/uiTMP9U8S++LIpCmkG+5ZaaW
 OgfN0w5eaNjNrS6rtIwWQFSJXftdzj5xIg0/UIhrd617VcTOZ40OrmHIYfOV+1mIj+qWIhq
 yt7IhsmUEbL4s7VgBNEBSW18KRm3jB+XOLxSehcPTHLTfcrCa8p2MfhX8b61wP9kUlRfibZ
 dCcmwi7HtfBAWyW88U39g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:SMJMDEo01Sk=:cGETZ8DbR9yWxRgclj+NVN
 66P3jQpMHZjs2vP7ZF15Ab0MfDViev8Wlkohud50g1Y5imMvaRnyeLpmYCjkJ2xtk/ewoPvSB
 yMI/lqFtNq6DkXiZl71X/Dn8r8kcNDHijlP6CAytUCHy4eDShv7/X4F2GQ4QC6oA6A5floJRc
 B9KZA8dpiR1WYEXVxqtipv4mTAVWbg4TdOOWPE6XKha1gE33veEKTbu/f8LXj7CvS80zkELh1
 mPv1m3Amm89j18y5onlwmBjNZ0I5ZhRyCEyNw2HLFaNGEZdYTYV3WKrS8VKtIxj/npquG+P/f
 Q5JfYMej52+8Pur2tBZilUZRvbhaEgnqDs6uvS2B/kxdQmWdfkZRUgP2aiMcMZ+KNbtCFb2qz
 LyjtOORKgEvU0J0fV+3Ss7pAQSdS5wfmWo7cWNidL3pPadq25hNGXyWQhcbga
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove MODULE_VERSION(), as it doesn't seem to have any practical purpose.
For in-tree drivers, the kernel version really matters. OTOH, the module
version doesn't seem to be actively maintained - the code received changes
while the version remained constant.

Signed-off-by: Enrico Weigelt <info@metux.net>
---
 drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c b/drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c
index df90c1f9d148..0b20dd51c340 100644
--- a/drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c
+++ b/drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c
@@ -2011,5 +2011,4 @@ module_platform_driver(bcm2835_camera_driver)
 MODULE_DESCRIPTION("Broadcom 2835 MMAL video capture");
 MODULE_AUTHOR("Vincent Sanders");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(BM2835_MMAL_VERSION);
 MODULE_ALIAS("platform:bcm2835-camera");
-- 
2.11.0

