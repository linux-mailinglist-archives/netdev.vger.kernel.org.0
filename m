Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B8742EF1A
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 12:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238088AbhJOKwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 06:52:14 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:41668
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229690AbhJOKwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 06:52:12 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 10FA43F22D;
        Fri, 15 Oct 2021 10:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1634295005;
        bh=X4YwiosBIxIOm7QIAfV/oUAM58MbArX1kagItuGPD/A=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=cyQR5Nu0KTe4743+qpozHm1TuFbgKrGIYGCDH/8HuXUpCaHAi3hhLLpc3XWv1wm0b
         e9CXzE7xEMy/UP+EZdSdumFMCQ4FiO9hQZbxbvp5+5RD/4d+eNmLwLn2qE9BfWxysc
         43DnhOZn2tt028Ve/2YPanHwhTrpTJ4hQuuLzxVaW2DaPMR/C/4F/wo9k7qR0A9tcQ
         gUjrLxnOzWwa3Kgr9w8tER0qftLga73Py7UHcwagmpHGi9mJVTAjmQskEBqqkaeBTc
         qQovsLRVgfvdM5VcNYBSUxqvsj9CFqLih95dqzE1hyJQYshZJnQoYMdGAPJjCKn7oz
         NB2rKFpd+oX9Q==
From:   Colin King <colin.king@canonical.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] rtw89: Fix two spelling mistakes in debug messages
Date:   Fri, 15 Oct 2021 11:50:04 +0100
Message-Id: <20211015105004.11817-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are two spelling mistakes in rtw89_debug messages. Fix them.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/realtek/rtw89/phy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/phy.c b/drivers/net/wireless/realtek/rtw89/phy.c
index 53c36cc82c57..ab134856baac 100644
--- a/drivers/net/wireless/realtek/rtw89/phy.c
+++ b/drivers/net/wireless/realtek/rtw89/phy.c
@@ -1715,7 +1715,7 @@ static s32 rtw89_phy_multi_sta_cfo_calc(struct rtw89_dev *rtwdev)
 			target_cfo = clamp(cfo_avg, max_cfo_lb, min_cfo_ub);
 		} else {
 			rtw89_debug(rtwdev, RTW89_DBG_CFO,
-				    "No intersection of cfo torlence windows\n");
+				    "No intersection of cfo tolerance windows\n");
 			target_cfo = phy_div(cfo_khz_all, (s32)sta_cnt);
 		}
 		for (i = 0; i < CFO_TRACK_MAX_USER; i++)
@@ -2749,7 +2749,7 @@ static void rtw89_phy_dig_dyn_pd_th(struct rtw89_dev *rtwdev, u8 rssi,
 			    dig->igi_rssi, final_rssi, under_region, val);
 	} else {
 		rtw89_debug(rtwdev, RTW89_DBG_DIG,
-			    "Dynamic PD th dsiabled, Set PD_low_bd=0\n");
+			    "Dynamic PD th disabled, Set PD_low_bd=0\n");
 	}
 
 	rtw89_phy_write32_mask(rtwdev, R_SEG0R_PD, B_SEG0R_PD_LOWER_BOUND_MSK,
-- 
2.32.0

