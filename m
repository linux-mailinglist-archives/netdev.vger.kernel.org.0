Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2EED1DB435
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 14:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgETMye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 08:54:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:45536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726443AbgETMyd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 08:54:33 -0400
Received: from pali.im (pali.im [31.31.79.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9F3B2070A;
        Wed, 20 May 2020 12:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589979272;
        bh=W4N5wm88P16gmtjOPXeI9WQcMR68v97KzmHVFkAQ3CA=;
        h=From:To:Cc:Subject:Date:From;
        b=oEEGWQqoN5HomQUw17QHu6yLkj5O4iWeYmF0Tyl8Z0R2mCMT9oEXo1BLuriLhBVQ7
         v9Lf5kppmcd+gK6owBIMfLubl89NE+UAC2kKup+7xj2HBwioZDoCNuueg3ynD6Vhnn
         UefC7wXpYD/YjptErErIVaJ2o+dxKvdugRVMR2LM=
Received: by pali.im (Postfix)
        id 9D24365A; Wed, 20 May 2020 14:54:30 +0200 (CEST)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     Solomon Peachy <pizza@shaftnet.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] cw1200: Remove local sdio VENDOR and DEVICE id definitions
Date:   Wed, 20 May 2020 14:54:10 +0200
Message-Id: <20200520125410.31757-1-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

They are already present in linux/mmc/sdio_ids.h.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 drivers/net/wireless/st/cw1200/cw1200_sdio.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/wireless/st/cw1200/cw1200_sdio.c b/drivers/net/wireless/st/cw1200/cw1200_sdio.c
index 43e012073dbf..b65ec14136c7 100644
--- a/drivers/net/wireless/st/cw1200/cw1200_sdio.c
+++ b/drivers/net/wireless/st/cw1200/cw1200_sdio.c
@@ -14,6 +14,7 @@
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/card.h>
 #include <linux/mmc/sdio.h>
+#include <linux/mmc/sdio_ids.h>
 #include <net/mac80211.h>
 
 #include "cw1200.h"
@@ -48,14 +49,6 @@ struct hwbus_priv {
 	const struct cw1200_platform_data_sdio *pdata;
 };
 
-#ifndef SDIO_VENDOR_ID_STE
-#define SDIO_VENDOR_ID_STE		0x0020
-#endif
-
-#ifndef SDIO_DEVICE_ID_STE_CW1200
-#define SDIO_DEVICE_ID_STE_CW1200	0x2280
-#endif
-
 static const struct sdio_device_id cw1200_sdio_ids[] = {
 	{ SDIO_DEVICE(SDIO_VENDOR_ID_STE, SDIO_DEVICE_ID_STE_CW1200) },
 	{ /* end: all zeroes */			},
-- 
2.20.1

