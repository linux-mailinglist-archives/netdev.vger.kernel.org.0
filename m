Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E072C3886A6
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 07:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245397AbhESFhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 01:37:38 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4670 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242470AbhESFfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 01:35:55 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FlM1c6v4Mz1BP5Z;
        Wed, 19 May 2021 13:31:48 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 13:34:34 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 19 May 2021 13:34:33 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hui Tang <tanghui20@huawei.com>,
        Jes Sorensen <jes@trained-monkey.org>
Subject: [PATCH 02/20] net: alteon: remove leading spaces before tabs
Date:   Wed, 19 May 2021 13:30:35 +0800
Message-ID: <1621402253-27200-3-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621402253-27200-1-git-send-email-tanghui20@huawei.com>
References: <1621402253-27200-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggemi760-chm.china.huawei.com (10.1.198.146)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few leading spaces before tabs and remove it by running the
following commard:

	$ find . -name '*.c' | xargs sed -r -i 's/^[ ]+\t/\t/'
	$ find . -name '*.h' | xargs sed -r -i 's/^[ ]+\t/\t/'

Cc: Jes Sorensen <jes@trained-monkey.org>
Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/net/ethernet/alteon/acenic.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/alteon/acenic.c b/drivers/net/ethernet/alteon/acenic.c
index 1a7e4df..9dc12b1 100644
--- a/drivers/net/ethernet/alteon/acenic.c
+++ b/drivers/net/ethernet/alteon/acenic.c
@@ -1883,16 +1883,16 @@ static u32 ace_handle_event(struct net_device *dev, u32 evtcsm, u32 evtprd)
 				}
 			}
 
- 			if (ACE_IS_TIGON_I(ap)) {
- 				struct cmd cmd;
- 				cmd.evt = C_SET_RX_JUMBO_PRD_IDX;
- 				cmd.code = 0;
- 				cmd.idx = 0;
- 				ace_issue_cmd(ap->regs, &cmd);
- 			} else {
- 				writel(0, &((ap->regs)->RxJumboPrd));
- 				wmb();
- 			}
+			if (ACE_IS_TIGON_I(ap)) {
+				struct cmd cmd;
+				cmd.evt = C_SET_RX_JUMBO_PRD_IDX;
+				cmd.code = 0;
+				cmd.idx = 0;
+				ace_issue_cmd(ap->regs, &cmd);
+			} else {
+				writel(0, &((ap->regs)->RxJumboPrd));
+				wmb();
+			}
 
 			ap->jumbo = 0;
 			ap->rx_jumbo_skbprd = 0;
@@ -2489,9 +2489,9 @@ static netdev_tx_t ace_start_xmit(struct sk_buff *skb,
 		}
 	}
 
- 	wmb();
- 	ap->tx_prd = idx;
- 	ace_set_txprd(regs, ap, idx);
+	wmb();
+	ap->tx_prd = idx;
+	ace_set_txprd(regs, ap, idx);
 
 	if (flagsize & BD_FLG_COAL_NOW) {
 		netif_stop_queue(dev);
-- 
2.8.1

