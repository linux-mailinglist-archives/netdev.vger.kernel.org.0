Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB79914601A
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 01:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgAWAvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 19:51:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52784 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgAWAvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 19:51:22 -0500
Received: from [82.43.126.140] (helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iuQiL-00072x-Tt; Thu, 23 Jan 2020 00:51:18 +0000
From:   Colin King <colin.king@canonical.com>
To:     gKalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] wcn36xx: rockchip: fix spelling mistake "to" -> "too"
Date:   Thu, 23 Jan 2020 00:51:17 +0000
Message-Id: <20200123005117.2833765-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a wcn36xx_err message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 523550f94a3f..77269ac7f352 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -1620,7 +1620,7 @@ int wcn36xx_smd_send_beacon(struct wcn36xx *wcn, struct ieee80211_vif *vif,
 	msg_body.beacon_length6 = msg_body.beacon_length + 6;
 
 	if (msg_body.beacon_length > BEACON_TEMPLATE_SIZE) {
-		wcn36xx_err("Beacon is to big: beacon size=%d\n",
+		wcn36xx_err("Beacon is too big: beacon size=%d\n",
 			      msg_body.beacon_length);
 		ret = -ENOMEM;
 		goto out;
-- 
2.24.0

