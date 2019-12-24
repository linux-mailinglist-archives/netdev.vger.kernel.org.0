Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57C0D12A1FE
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 15:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbfLXOJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 09:09:06 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:46950 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726183AbfLXOJF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Dec 2019 09:09:05 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 7EADC7E081840E20FA98;
        Tue, 24 Dec 2019 22:08:55 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Tue, 24 Dec 2019
 22:08:46 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <yhchuang@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH -next 2/6] cw1200: use true,false for bool variable
Date:   Tue, 24 Dec 2019 22:16:02 +0800
Message-ID: <1577196966-84926-3-git-send-email-zhengbin13@huawei.com>
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

drivers/net/wireless/st/cw1200/txrx.c:718:6-16: WARNING: Assignment of 0/1 to bool variable

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/net/wireless/st/cw1200/txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/st/cw1200/txrx.c b/drivers/net/wireless/st/cw1200/txrx.c
index 2dfcdb1..400dd58 100644
--- a/drivers/net/wireless/st/cw1200/txrx.c
+++ b/drivers/net/wireless/st/cw1200/txrx.c
@@ -715,7 +715,7 @@ void cw1200_tx(struct ieee80211_hw *dev,
 	};
 	struct ieee80211_sta *sta;
 	struct wsm_tx *wsm;
-	bool tid_update = 0;
+	bool tid_update = false;
 	u8 flags = 0;
 	int ret;

--
2.7.4

