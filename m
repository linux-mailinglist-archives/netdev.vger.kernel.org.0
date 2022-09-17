Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03A3B5BB7DC
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 12:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiIQKju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 06:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiIQKjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 06:39:41 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D230FFD4;
        Sat, 17 Sep 2022 03:39:31 -0700 (PDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MV6lh2PpSzlVjW;
        Sat, 17 Sep 2022 18:35:28 +0800 (CST)
Received: from kwepemm600013.china.huawei.com (7.193.23.68) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 17 Sep 2022 18:39:30 +0800
Received: from localhost.localdomain (10.67.165.2) by
 kwepemm600013.china.huawei.com (7.193.23.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 17 Sep 2022 18:39:29 +0800
From:   Haoyue Xu <xuhaoyue1@hisilicon.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <michal.simek@xilinx.com>
CC:     <huangdaode@huawei.com>, <liyangyang20@huawei.com>,
        <xuhaoyue1@hisilicon.com>, <huangjunxian6@hisilicon.com>,
        <linuxarm@huawei.com>, <liangwenpeng@huawei.com>
Subject: [PATCH net-next 5/7] net: ll_temac: fix the missing spaces around '='
Date:   Sat, 17 Sep 2022 18:38:41 +0800
Message-ID: <20220917103843.526877-6-xuhaoyue1@hisilicon.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20220917103843.526877-1-xuhaoyue1@hisilicon.com>
References: <20220917103843.526877-1-xuhaoyue1@hisilicon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.2]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600013.china.huawei.com (7.193.23.68)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: huangjunxian <huangjunxian6@hisilicon.com>

Cleaning some static warnings of missing spaces around '='.

Signed-off-by: huangjunxian <huangjunxian6@hisilicon.com>
Signed-off-by: Haoyue Xu <xuhaoyue1@hisilicon.com>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 22 ++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 15d7b7ed0830..256cb294f0b7 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -529,66 +529,66 @@ static struct temac_option {
 	{
 		.opt = XTE_OPTION_JUMBO,
 		.reg = XTE_RXC1_OFFSET,
-		.m_or =XTE_RXC1_RXJMBO_MASK,
+		.m_or = XTE_RXC1_RXJMBO_MASK,
 	},
 	/* Turn on VLAN packet support for both Rx and Tx */
 	{
 		.opt = XTE_OPTION_VLAN,
 		.reg = XTE_TXC_OFFSET,
-		.m_or =XTE_TXC_TXVLAN_MASK,
+		.m_or = XTE_TXC_TXVLAN_MASK,
 	},
 	{
 		.opt = XTE_OPTION_VLAN,
 		.reg = XTE_RXC1_OFFSET,
-		.m_or =XTE_RXC1_RXVLAN_MASK,
+		.m_or = XTE_RXC1_RXVLAN_MASK,
 	},
 	/* Turn on FCS stripping on receive packets */
 	{
 		.opt = XTE_OPTION_FCS_STRIP,
 		.reg = XTE_RXC1_OFFSET,
-		.m_or =XTE_RXC1_RXFCS_MASK,
+		.m_or = XTE_RXC1_RXFCS_MASK,
 	},
 	/* Turn on FCS insertion on transmit packets */
 	{
 		.opt = XTE_OPTION_FCS_INSERT,
 		.reg = XTE_TXC_OFFSET,
-		.m_or =XTE_TXC_TXFCS_MASK,
+		.m_or = XTE_TXC_TXFCS_MASK,
 	},
 	/* Turn on length/type field checking on receive packets */
 	{
 		.opt = XTE_OPTION_LENTYPE_ERR,
 		.reg = XTE_RXC1_OFFSET,
-		.m_or =XTE_RXC1_RXLT_MASK,
+		.m_or = XTE_RXC1_RXLT_MASK,
 	},
 	/* Turn on flow control */
 	{
 		.opt = XTE_OPTION_FLOW_CONTROL,
 		.reg = XTE_FCC_OFFSET,
-		.m_or =XTE_FCC_RXFLO_MASK,
+		.m_or = XTE_FCC_RXFLO_MASK,
 	},
 	/* Turn on flow control */
 	{
 		.opt = XTE_OPTION_FLOW_CONTROL,
 		.reg = XTE_FCC_OFFSET,
-		.m_or =XTE_FCC_TXFLO_MASK,
+		.m_or = XTE_FCC_TXFLO_MASK,
 	},
 	/* Turn on promiscuous frame filtering (all frames are received ) */
 	{
 		.opt = XTE_OPTION_PROMISC,
 		.reg = XTE_AFM_OFFSET,
-		.m_or =XTE_AFM_EPPRM_MASK,
+		.m_or = XTE_AFM_EPPRM_MASK,
 	},
 	/* Enable transmitter if not already enabled */
 	{
 		.opt = XTE_OPTION_TXEN,
 		.reg = XTE_TXC_OFFSET,
-		.m_or =XTE_TXC_TXEN_MASK,
+		.m_or = XTE_TXC_TXEN_MASK,
 	},
 	/* Enable receiver? */
 	{
 		.opt = XTE_OPTION_RXEN,
 		.reg = XTE_RXC1_OFFSET,
-		.m_or =XTE_RXC1_RXEN_MASK,
+		.m_or = XTE_RXC1_RXEN_MASK,
 	},
 	{}
 };
-- 
2.30.0

