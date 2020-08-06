Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC6D723DC1C
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 18:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729316AbgHFQqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 12:46:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50768 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729255AbgHFQpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 12:45:52 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1k3e9G-0000ii-Bs; Thu, 06 Aug 2020 11:33:26 +0000
From:   Colin King <colin.king@canonical.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] wl1251, wlcore: fix spelling mistake "buld" -> "build"
Date:   Thu,  6 Aug 2020 12:33:26 +0100
Message-Id: <20200806113326.53779-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are spelling mistakes in warning messages. Fix these.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ti/wl1251/main.c | 2 +-
 drivers/net/wireless/ti/wlcore/cmd.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index 480a8d084878..136a0d3b23c9 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -558,7 +558,7 @@ static int wl1251_build_null_data(struct wl1251 *wl)
 out:
 	dev_kfree_skb(skb);
 	if (ret)
-		wl1251_warning("cmd buld null data failed: %d", ret);
+		wl1251_warning("cmd build null data failed: %d", ret);
 
 	return ret;
 }
diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 6ef8fc9ae627..93424a1dffc9 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -1080,7 +1080,7 @@ int wl12xx_cmd_build_null_data(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 out:
 	dev_kfree_skb(skb);
 	if (ret)
-		wl1271_warning("cmd buld null data failed %d", ret);
+		wl1271_warning("cmd build null data failed %d", ret);
 
 	return ret;
 
-- 
2.27.0

