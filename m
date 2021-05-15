Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 060B33817F7
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 12:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbhEOK6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 06:58:11 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3768 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233077AbhEOKzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 06:55:55 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Fj2J34tlSzmgZJ;
        Sat, 15 May 2021 18:51:15 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Sat, 15 May 2021 18:54:30 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 31/34] net: realtek: rtlwifi: Fix wrong function name in comments
Date:   Sat, 15 May 2021 18:53:56 +0800
Message-ID: <1621076039-53986-32-git-send-email-shenyang39@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621076039-53986-1-git-send-email-shenyang39@huawei.com>
References: <1621076039-53986-1-git-send-email-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c:124: warning: expecting prototype for writeLLT(). Prototype was for rtl92c_llt_write() instead
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c:154: warning: expecting prototype for rtl92c_init_LLT_table(). Prototype was for rtl92c_init_llt_table() instead

Cc: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c
index 8d2c6d8..4ff0d41 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c
@@ -112,7 +112,7 @@ void rtl92c_read_chip_version(struct ieee80211_hw *hw)
 }
 
 /**
- * writeLLT - LLT table write access
+ * rtl92c_llt_write - LLT table write access
  * @hw: Pointer to the ieee80211_hw structure.
  * @address: LLT logical address.
  * @data: LLT data content
@@ -144,7 +144,7 @@ bool rtl92c_llt_write(struct ieee80211_hw *hw, u32 address, u32 data)
 }
 
 /**
- * rtl92c_init_LLT_table - Init LLT table
+ * rtl92c_init_llt_table - Init LLT table
  * @hw: Pointer to the ieee80211_hw structure.
  * @boundary: Page boundary.
  *
-- 
2.7.4

