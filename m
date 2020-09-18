Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1268C26FA5D
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 12:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgIRKSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 06:18:49 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56814 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726365AbgIRKSZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 06:18:25 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 59EF5D12FDCE2785E4E9;
        Fri, 18 Sep 2020 18:18:20 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Fri, 18 Sep 2020
 18:18:11 +0800
From:   Zheng Bin <zhengbin13@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH -next 1/9] rtlwifi: rtl8192ee: fix comparison to bool warning in hw.c
Date:   Fri, 18 Sep 2020 18:24:57 +0800
Message-ID: <20200918102505.16036-2-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.26.0.106.g9fadedd
In-Reply-To: <20200918102505.16036-1-zhengbin13@huawei.com>
References: <20200918102505.16036-1-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes coccicheck warning:

drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c:797:6-33: WARNING: Comparison to bool

Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
index 473296e808ba..88fa2e593fef 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
@@ -794,7 +794,7 @@ static bool _rtl92ee_init_mac(struct ieee80211_hw *hw)
 	rtl_write_word(rtlpriv, REG_CR, 0x2ff);

 	if (!rtlhal->mac_func_enable) {
-		if (_rtl92ee_llt_table_init(hw) == false) {
+		if (!_rtl92ee_llt_table_init(hw)) {
 			rtl_dbg(rtlpriv, COMP_INIT, DBG_LOUD,
 				"LLT table init fail\n");
 			return false;
--
2.26.0.106.g9fadedd

