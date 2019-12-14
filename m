Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2DA611F159
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 11:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbfLNKPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 05:15:25 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8124 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725872AbfLNKPZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Dec 2019 05:15:25 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 41337527F6D14078B992;
        Sat, 14 Dec 2019 18:15:20 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Sat, 14 Dec 2019
 18:15:12 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>,
        <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH -next] ath11k: Remove unneeded semicolon
Date:   Sat, 14 Dec 2019 18:22:34 +0800
Message-ID: <1576318954-40658-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes coccicheck warning:

drivers/net/wireless/ath/ath11k/wmi.h:2570:2-3: Unneeded semicolon

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/net/wireless/ath/ath11k/wmi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.h b/drivers/net/wireless/ath/ath11k/wmi.h
index 4a518d4..22c887a 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.h
+++ b/drivers/net/wireless/ath/ath11k/wmi.h
@@ -2567,7 +2567,7 @@ static inline const char *ath11k_wmi_phymode_str(enum wmi_phy_mode mode)
 		/* no default handler to allow compiler to check that the
 		 * enum is fully handled
 		 */
-	};
+	}

 	return "<unknown>";
 }
--
2.7.4

