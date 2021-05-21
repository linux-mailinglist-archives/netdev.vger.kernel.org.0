Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7A4838BF4D
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 08:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232363AbhEUG3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 02:29:51 -0400
Received: from m12-18.163.com ([220.181.12.18]:54345 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232311AbhEUG3t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 02:29:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=Rhnhj
        iT9k248UagWQ8RXe+JXBBW1bHfcTDld8M9m2fk=; b=og01eyemV+7Avk2eZ5EKM
        dJdzoeccrZXqBWMFCagg2n7c9ijNwevtMb9ZEypdlWf/Z+rQznIBhgdWEJYPMTPb
        X8aRT1m0376PGJ9Vx5ze2I2mTSIS8Q25kpUmBdYMYnyLnbc6ejSeQ/crDFfrjlWJ
        LuXjmggXVSxfnBN2H0Hm4s=
Received: from COOL-20201222LC.ccdomain.com (unknown [218.94.48.178])
        by smtp14 (Coremail) with SMTP id EsCowACXgrLxUqdg3vTFkg--.19470S2;
        Fri, 21 May 2021 14:28:03 +0800 (CST)
From:   dingsenjie@163.com
To:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ding Senjie <dingsenjie@yulong.com>
Subject: [PATCH] net: wireless/realtek: Fix spelling of 'download'
Date:   Fri, 21 May 2021 14:27:34 +0800
Message-Id: <20210521062734.21284-1-dingsenjie@163.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EsCowACXgrLxUqdg3vTFkg--.19470S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrur1rCrWUGFy5Zry5CF4rZrb_yoWDXrg_Cw
        409wsxAF18t3yj9rW8ZFWfZ3yFy3yDWw4fXFZ2qrWfGr45ZrWvvr95ua47Jr1UGFyfuF9r
        CwnxGFy0y348ZjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8O_-PUUUUU==
X-Originating-IP: [218.94.48.178]
X-CM-SenderInfo: 5glqw25hqmxvi6rwjhhfrp/xtbBRROZyFPAL7BH6QAAsl
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ding Senjie <dingsenjie@yulong.com>

downlaod -> download

Signed-off-by: Ding Senjie <dingsenjie@yulong.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c
index 3803410..e474b4e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c
@@ -513,7 +513,7 @@ void rtl92se_tx_fill_cmddesc(struct ieee80211_hw *hw, u8 *pdesc8,
 
 	/* This bit indicate this packet is used for FW download. */
 	if (tcb_desc->cmd_or_init == DESC_PACKET_TYPE_INIT) {
-		/* For firmware downlaod we only need to set LINIP */
+		/* For firmware download we only need to set LINIP */
 		set_tx_desc_linip(pdesc, tcb_desc->last_inipkt);
 
 		/* 92SE must set as 1 for firmware download HW DMA error */
-- 
1.9.1


