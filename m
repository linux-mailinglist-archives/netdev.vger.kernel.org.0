Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5BD8B12ED
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 18:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730592AbfILQoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 12:44:44 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:52384 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725972AbfILQoo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Sep 2019 12:44:44 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 43CC7E7633E1EFF97E39;
        Fri, 13 Sep 2019 00:44:40 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.439.0; Fri, 13 Sep 2019 00:44:34 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <kvalo@codeaurora.org>
CC:     <davem@davemloft.net>, <zhongjiang@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] brcmsmac: Remove unneeded variable and make function to be void
Date:   Fri, 13 Sep 2019 00:41:30 +0800
Message-ID: <1568306492-42998-2-git-send-email-zhongjiang@huawei.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1568306492-42998-1-git-send-email-zhongjiang@huawei.com>
References: <1568306492-42998-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

brcms_c_set_mac  do not need return value to cope with different
cases. And change functon return type to void.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
index 080e829..ddc4d47 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
@@ -3776,17 +3776,14 @@ static void brcms_c_set_ps_ctrl(struct brcms_c_info *wlc)
  * Write this BSS config's MAC address to core.
  * Updates RXE match engine.
  */
-static int brcms_c_set_mac(struct brcms_bss_cfg *bsscfg)
+static void brcms_c_set_mac(struct brcms_bss_cfg *bsscfg)
 {
-	int err = 0;
 	struct brcms_c_info *wlc = bsscfg->wlc;
 
 	/* enter the MAC addr into the RXE match registers */
 	brcms_c_set_addrmatch(wlc, RCM_MAC_OFFSET, wlc->pub->cur_etheraddr);
 
 	brcms_c_ampdu_macaddr_upd(wlc);
-
-	return err;
 }
 
 /* Write the BSS config's BSSID address to core (set_bssid in d11procs.tcl).
-- 
1.7.12.4

