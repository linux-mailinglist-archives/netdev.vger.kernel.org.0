Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E27F2AA3EB
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 09:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728175AbgKGIky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 03:40:54 -0500
Received: from m176115.mail.qiye.163.com ([59.111.176.115]:64177 "EHLO
        m176115.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727833AbgKGIky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 03:40:54 -0500
Received: from vivo-HP-ProDesk-680-G4-PCI-MT.vivo.xyz (unknown [58.251.74.231])
        by m176115.mail.qiye.163.com (Hmail) with ESMTPA id B61B36665F9;
        Sat,  7 Nov 2020 16:40:49 +0800 (CST)
From:   Wang Qing <wangqing@vivo.com>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Joe Perches <joe@perches.com>,
        Zheng Bin <zhengbin13@huawei.com>,
        Wang Qing <wangqing@vivo.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] wireless: realtek: fix spelling typo of workaround
Date:   Sat,  7 Nov 2020 16:40:37 +0800
Message-Id: <1604738439-24794-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZSksYSEMdSk5JThpCVkpNS09MSENPTktJTEtVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKQ1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OVE6MCo4Fz8oARwyNRc5ITQs
        LEkaFE9VSlVKTUtPTEhDT05LTUNCVTMWGhIXVQwaFRwKEhUcOw0SDRRVGBQWRVlXWRILWUFZTkNV
        SU5KVUxPVUlISllXWQgBWUFJTktCNwY+
X-HM-Tid: 0a75a1dd82e89373kuwsb61b36665f9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

workarould -> workaround

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
index f41a764..b4628b4
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -62,7 +62,7 @@ static void rtl8812ae_fixspur(struct ieee80211_hw *hw,
 			rtl_set_bbreg(hw, RRFMOD, 0xC00, 0x2);
 			/* 0x8AC[11:10] = 2'b10*/
 
-		/* <20120914, Kordan> A workarould to resolve
+		/* <20120914, Kordan> A workaround to resolve
 		 * 2480Mhz spur by setting ADC clock as 160M. (Asked by Binson)
 		 */
 		if (band_width == HT_CHANNEL_WIDTH_20 &&
@@ -82,7 +82,7 @@ static void rtl8812ae_fixspur(struct ieee80211_hw *hw,
 			/*0x8C4[30] = 0*/
 		}
 	} else if (rtlhal->hw_type == HARDWARE_TYPE_RTL8812AE) {
-		/* <20120914, Kordan> A workarould to resolve
+		/* <20120914, Kordan> A workaround to resolve
 		 * 2480Mhz spur by setting ADC clock as 160M.
 		 */
 		if (band_width == HT_CHANNEL_WIDTH_20 &&
-- 
2.7.4

