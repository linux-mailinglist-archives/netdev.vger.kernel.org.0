Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD62ECDCF
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 09:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbfKBI7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Nov 2019 04:59:31 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:41774 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727052AbfKBI7b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Nov 2019 04:59:31 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 4999FB6C81768D9A4095;
        Sat,  2 Nov 2019 16:59:27 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.439.0; Sat, 2 Nov 2019 16:59:18 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <kvalo@codeaurora.org>, <stas.yakovlev@gmail.com>,
        <simon.horman@netronome.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <zhongjiang@huawei.com>
Subject: [PATCH v3 2/2] iwlegacy: Remove redundant variable "ret"
Date:   Sat, 2 Nov 2019 16:55:22 +0800
Message-ID: <1572684922-61805-3-git-send-email-zhongjiang@huawei.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1572684922-61805-1-git-send-email-zhongjiang@huawei.com>
References: <1572684922-61805-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

local variable "ret" is not used. hence it is safe to remove and
just return 0.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/net/wireless/intel/iwlegacy/4965-mac.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/4965-mac.c b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
index 51fdd7c..3664f56 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
@@ -3331,7 +3331,6 @@ struct il_mod_params il4965_mod_params = {
 				 struct ieee80211_key_conf *keyconf, u8 sta_id)
 {
 	unsigned long flags;
-	int ret = 0;
 	__le16 key_flags = 0;
 
 	key_flags |= (STA_KEY_FLG_TKIP | STA_KEY_FLG_MAP_KEY_MSK);
@@ -3368,7 +3367,7 @@ struct il_mod_params il4965_mod_params = {
 
 	spin_unlock_irqrestore(&il->sta_lock, flags);
 
-	return ret;
+	return 0;
 }
 
 void
-- 
1.7.12.4

