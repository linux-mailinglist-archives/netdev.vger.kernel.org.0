Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA72B307A9F
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 17:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232531AbhA1QXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 11:23:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45447 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232237AbhA1QWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 11:22:53 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1l5A3Y-0002sn-Qn; Thu, 28 Jan 2021 16:22:06 +0000
From:   Colin King <colin.king@canonical.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] libertas: remove redundant initialization of variable ret
Date:   Thu, 28 Jan 2021 16:22:02 +0000
Message-Id: <20210128162202.642848-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable ret is being initialized with a value that is never read
and it is being updated later with a new value.  The initialization is
redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/marvell/libertas/if_sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/libertas/if_sdio.c b/drivers/net/wireless/marvell/libertas/if_sdio.c
index 44fbd0acb87a..a63c5e622ee3 100644
--- a/drivers/net/wireless/marvell/libertas/if_sdio.c
+++ b/drivers/net/wireless/marvell/libertas/if_sdio.c
@@ -981,7 +981,7 @@ static int if_sdio_host_to_card(struct lbs_private *priv,
 
 static int if_sdio_enter_deep_sleep(struct lbs_private *priv)
 {
-	int ret = -1;
+	int ret;
 	struct cmd_header cmd;
 
 	memset(&cmd, 0, sizeof(cmd));
-- 
2.29.2

