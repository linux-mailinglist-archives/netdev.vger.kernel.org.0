Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A80B2CD60D
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 13:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730558AbgLCMvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 07:51:16 -0500
Received: from mout.kundenserver.de ([212.227.126.135]:58389 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389062AbgLCMuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 07:50:55 -0500
Received: from orion.localdomain ([95.118.71.13]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MC0HF-1ksnqw3rED-00CUou; Thu, 03 Dec 2020 13:48:12 +0100
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     rspringer@google.com, toddpoynor@google.com, benchan@chromium.org,
        rcy@google.com, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, f.fainelli@gmail.com, rjui@broadcom.com,
        sbranden@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        nsaenzjulienne@suse.de, speakup@linux-speakup.org,
        devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 10/11] drivers: staging: rtl8723bs: remove unneeded MODULE_VERSION() call
Date:   Thu,  3 Dec 2020 13:48:02 +0100
Message-Id: <20201203124803.23390-10-info@metux.net>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20201203124803.23390-1-info@metux.net>
References: <20201203124803.23390-1-info@metux.net>
X-Provags-ID: V03:K1:hQGIBq/BUgPqVCEvTnHhF20SdK3ePaui9xmOcpQzW4CBNAeGWxQ
 6dlSkT/baOy2QIyYpoUTMDbZ2qRYy4QjbRiOimlX7nHiu4rtmkCbU1n8XpdkUUpsT0mbrRL
 WBjJEIOolFjHbZbrlYh0Zk0i6Fx0S5oT7x3/eVUw+uDgdZQatf8trTDNYxSRVqcNyslMLb2
 XU8R0s82TL/NGrQRwrvFQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:6RGQO+J5kMs=:v3LsgrUhYwB/y2iFa9vQb0
 e9xMagAtqCzJZABxOcvKblZxcYBWxuUc24caTFsDorn7uMCod/SwqUO2GGuwV6TBgQkXbPO02
 D/JHB4OqicEPtdfEuyFV61vR/qSYC0VXf1xbLCMI5NgG/0uNcRw0Q2Xt8r0bI/Ddsh4dFnMF/
 urhCr2E9ERtkx29wO/7oRLcYIwvMJEuVAUoxZx1MnuXMGKnNmtX+jmn1olRVtuUNZ+B5dyblv
 fxVK8Run2oS5tkGetn/m/47SbXm4O55qofzlt88pIZ2jGmWEXM7GtghDJiyNnu6QkA8Vy5x3z
 g7FysiqrU9ZGLIEchhQubxA+p5Tgga9IvKv13o91HqKJn4vMEfWO1UIo7Q9497g5dmL45LILn
 BiOwG/cgPZos9Iz+uH3ci9MhBU1afUIuEH2Ov1SoqH098lBEXHRVhK4Zw2NcR
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove MODULE_VERSION(), as it doesn't seem to have any pratical purpose.
The code received lots of huge changes, but module version remained constant,
since it landed in mainline tree, back 11 years go. Unmaintained version
numbers aren't actually useful. For in-tree drivers, the kernel version
really matters.

Signed-off-by: Enrico Weigelt <info@metux.net>
---
 drivers/staging/rtl8192u/r8192U_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 27dc181c4c9b..da871f45042a 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -90,7 +90,6 @@ static const struct usb_device_id rtl8192_usb_id_tbl[] = {
 };
 
 MODULE_LICENSE("GPL");
-MODULE_VERSION("V 1.1");
 MODULE_DEVICE_TABLE(usb, rtl8192_usb_id_tbl);
 MODULE_DESCRIPTION("Linux driver for Realtek RTL8192 USB WiFi cards");
 
-- 
2.11.0

