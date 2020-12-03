Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8775F2CD617
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 13:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730598AbgLCMvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 07:51:40 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:40453 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730509AbgLCMus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 07:50:48 -0500
Received: from orion.localdomain ([95.118.71.13]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1N8EdM-1k71GC1Duq-014BRB; Thu, 03 Dec 2020 13:48:08 +0100
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     rspringer@google.com, toddpoynor@google.com, benchan@chromium.org,
        rcy@google.com, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, f.fainelli@gmail.com, rjui@broadcom.com,
        sbranden@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        nsaenzjulienne@suse.de, speakup@linux-speakup.org,
        devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 05/11] drivers: staging: media: remove unneeded MODULE_VERSION() call
Date:   Thu,  3 Dec 2020 13:47:57 +0100
Message-Id: <20201203124803.23390-5-info@metux.net>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20201203124803.23390-1-info@metux.net>
References: <20201203124803.23390-1-info@metux.net>
X-Provags-ID: V03:K1:A0wBouam6WJUm1DquNPVyfLSDZ7oZQEPiMGhLxEU02kxYrt9m/l
 qBaYNXzkuBPYnfZdW8HRf0++cDR7uTmElGWf3KjE7uInz+SGrk+9h+AQnZPoRL8Hs+Dc+E+
 cFw4h1W+AVq4Q/AAYW9K1Fo9wicqhgYFQMkEWjYd1AubvyrTkPx5S7XDYIgdFwxfSfvgjLk
 U7bFCMDUb4rW9NeFC2W9w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:sO9KKuke2Hw=:L60L84285TFxRIHYc21T8G
 K6rv60i1By+bQFmxPzrd+amNhMCSH/fOMA0FnRTzI8xOznEc/+GJNK4dVHB/f4sV/YE5rNAMD
 nymnQs+vfE1VDd2hXfHdqqWgdPD+HOaCsqGneIIYd7jJzZuUfKWwirR0QiOEwaOAbrdPudDQ1
 0yUBlPieMWXwsPoIoYiIe7QbCS1Yweg5sNEUnSEpLsqCsbW+NpZaIVlxcV5l4q0kFNVPEKRbv
 KpHGkIFNC1FjlB4j2XltEq9p38IuJCnwjqOiTAzS+H3TxqJID5+bl0GCdJG+zs7fw/zP0fQiE
 35TMb3zEINkZARbtpsi80OwVO3XSuJ7dpISmazmU3Vh1W2MMeGazJedw6boswoEzI3xkUFTzU
 rmt6EOwk693/LGqL0GJtzI1QuSdk4LnKISEtmcign/pMG1B073KFeqx+lw2De
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove MODULE_VERSION(), as it doesn't seem to serve any practical purpose.
For in-tree drivers, the kernel version matters. The code received lots of
changes, but module version remained constant, since the driver landed in
mainline. So, this version doesn't seem have any practical meaning anymore.

Signed-off-by: Enrico Weigelt <info@metux.net>
---
 drivers/staging/media/omap4iss/iss.c       | 1 -
 drivers/staging/media/omap4iss/iss_video.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index e06ea7ea1e50..dae9073e7d3c 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -1349,4 +1349,3 @@ module_platform_driver(iss_driver);
 MODULE_DESCRIPTION("TI OMAP4 ISS driver");
 MODULE_AUTHOR("Sergio Aguirre <sergio.a.aguirre@gmail.com>");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(ISS_VIDEO_DRIVER_VERSION);
diff --git a/drivers/staging/media/omap4iss/iss_video.h b/drivers/staging/media/omap4iss/iss_video.h
index 8b3dd92021e1..526281bf0051 100644
--- a/drivers/staging/media/omap4iss/iss_video.h
+++ b/drivers/staging/media/omap4iss/iss_video.h
@@ -18,7 +18,6 @@
 #include <media/videobuf2-dma-contig.h>
 
 #define ISS_VIDEO_DRIVER_NAME		"issvideo"
-#define ISS_VIDEO_DRIVER_VERSION	"0.0.2"
 
 struct iss_device;
 struct iss_video;
-- 
2.11.0

