Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDFE712A1F8
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 15:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbfLXOI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 09:08:58 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:50222 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726183AbfLXOI5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Dec 2019 09:08:57 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id AA9C113BE3FAB42D3B6C;
        Tue, 24 Dec 2019 22:08:55 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Tue, 24 Dec 2019
 22:08:46 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <yhchuang@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH -next 1/6] rtw88: use true,false for bool variable
Date:   Tue, 24 Dec 2019 22:16:01 +0800
Message-ID: <1577196966-84926-2-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1577196966-84926-1-git-send-email-zhengbin13@huawei.com>
References: <1577196966-84926-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes coccicheck warning:

drivers/net/wireless/realtek/rtw88/phy.c:1437:1-24: WARNING: Assignment of 0/1 to bool variable

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/net/wireless/realtek/rtw88/phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/phy.c b/drivers/net/wireless/realtek/rtw88/phy.c
index a3e1e95..eea9d88 100644
--- a/drivers/net/wireless/realtek/rtw88/phy.c
+++ b/drivers/net/wireless/realtek/rtw88/phy.c
@@ -1434,7 +1434,7 @@ static void rtw_load_rfk_table(struct rtw_dev *rtwdev)

 	rtw_load_table(rtwdev, chip->rfk_init_tbl);

-	dpk_info->is_dpk_pwr_on = 1;
+	dpk_info->is_dpk_pwr_on = true;
 }

 void rtw_phy_load_tables(struct rtw_dev *rtwdev)
--
2.7.4

