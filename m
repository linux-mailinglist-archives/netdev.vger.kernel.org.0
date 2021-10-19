Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93014433040
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 09:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234584AbhJSH5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 03:57:17 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:40583 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230365AbhJSH5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 03:57:16 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R441e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UstTzXf_1634630100;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UstTzXf_1634630100)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 19 Oct 2021 15:55:01 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pkshih@realtek.com, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH -next] rtw89: remove unneeded semicolon
Date:   Tue, 19 Oct 2021 15:54:54 +0800
Message-Id: <1634630094-1156-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eliminate the following coccicheck warning:
./drivers/net/wireless/realtek/rtw89/pci.c:1348:2-3: Unneeded semicolon

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Fixes: e3ec7017f6a2 ("rtw89: add Realtek 802.11ax driver")
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/wireless/realtek/rtw89/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/pci.c b/drivers/net/wireless/realtek/rtw89/pci.c
index e973101..2c94762 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -1345,7 +1345,7 @@ static int rtw89_pci_check_mdio(struct rtw89_dev *rtwdev, u8 addr, u8 speed, u16
 	default:
 		rtw89_err(rtwdev, "[ERR]Error Speed %d!\n", speed);
 		return -EINVAL;
-	};
+	}
 	rtw89_write16(rtwdev, R_AX_MDIO_CFG, val);
 	rtw89_write16_set(rtwdev, R_AX_MDIO_CFG, rw_bit);
 
-- 
1.8.3.1

