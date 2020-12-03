Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91FD52CD60B
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 13:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389113AbgLCMvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 07:51:10 -0500
Received: from mout.kundenserver.de ([212.227.126.135]:57473 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389076AbgLCMuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 07:50:55 -0500
Received: from orion.localdomain ([95.118.71.13]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MZSJa-1khzyO1t2c-00WUVz; Thu, 03 Dec 2020 13:48:10 +0100
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     rspringer@google.com, toddpoynor@google.com, benchan@chromium.org,
        rcy@google.com, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, f.fainelli@gmail.com, rjui@broadcom.com,
        sbranden@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        nsaenzjulienne@suse.de, speakup@linux-speakup.org,
        devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 08/11] drivers: staging: rtl8188eu: remove unneeded MODULE_VERSION() call
Date:   Thu,  3 Dec 2020 13:48:00 +0100
Message-Id: <20201203124803.23390-8-info@metux.net>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20201203124803.23390-1-info@metux.net>
References: <20201203124803.23390-1-info@metux.net>
X-Provags-ID: V03:K1:1MQuKEnM71T5YF6xscjABxnKeVTYqBar5OW8Npo4jNGlsiQjuP+
 /rda2rr2UVdGioxR7J2JitRU7UNNpKt9hmwIqtTuSXWRoKu9UPiI9jJ80fnI6ioBVYmIJjp
 mKrv15PfkGRggVX+jaT5clh1yzdaBsFku+utkSx37mlc3l9Iec6uXljBFVpjcqBUhf2haIh
 TVeBgHnA/fhQgbnyEUZug==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:AzWa5wuY4Pg=:pQLme33YNK+Eu2A4O3Q+zg
 f4uvVbaGrAndTnPfz3x8TCOKOgDyyFjODoZB3JCTdibbaXFbqsojJIllGl2ld1SQED31ijaiy
 KLs5sw9C2GREl6oF6Kr99PvL4UzMKK6v/3dCypSn9wuanIM8qWDaAX1T3V2TlmKTxTA7iSC4w
 dCVEFNQW1VsHBkRDQiTXj2G5LkW6fujTkXZ3ZKmMv7Y+R0VIRgbghpq9DxpufhUOEI5ZuwRIg
 Qha0BXUyp7JU8LIZ7uAqEVvctZXScbL2kdc1/CVdgnBmhdZYbSozAMpHWqn3UNuJf2RUuNeYN
 OXlEaGrCwHnHLZdGpo0AIAnubOfjpgVeaNRThvT/RbHjh+oJjjtY8j6eAEy4p/915I/cW/iJU
 s5zjeGNYw8xfpBlRlsRmhPwJxX/IRsuRMrlNK5HGveIE7HLfRSzwvzc+HS1Y7
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove MODULE_VERSION(), as it doesn't seem to serve any practical purpose.
For in-kernel drivers, the kernel version matters most. The driver received
lots of changes, while module version remained constant, since it landed
in mainline, back 7 years ago.

Signed-off-by: Enrico Weigelt <info@metux.net>
---
 drivers/staging/rtl8188eu/os_dep/os_intfs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/os_intfs.c b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
index e291df87f620..258d7a13467a 100644
--- a/drivers/staging/rtl8188eu/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
@@ -18,7 +18,6 @@
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Realtek Wireless Lan Driver");
 MODULE_AUTHOR("Realtek Semiconductor Corp.");
-MODULE_VERSION(DRIVERVERSION);
 MODULE_FIRMWARE("rtlwifi/rtl8188eufw.bin");
 
 #define RTW_NOTCH_FILTER 0 /* 0:Disable, 1:Enable, */
-- 
2.11.0

