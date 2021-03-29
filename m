Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A763434C60E
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 10:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbhC2IEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 04:04:49 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15085 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232084AbhC2IDx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 04:03:53 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F84mD6wWzz19Js5;
        Mon, 29 Mar 2021 16:01:48 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.498.0; Mon, 29 Mar 2021 16:03:42 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <sebastian.hesselbarth@gmail.com>, <thomas.petazzoni@bootlin.com>,
        <mlindner@marvell.com>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>, <linuxarm@huawei.com>,
        Yangyang Li <liyangyang20@huawei.com>,
        Weihang Li <liweihang@huawei.com>
Subject: [PATCH net-next 4/4] net: marvell: Fix an alignment problem
Date:   Mon, 29 Mar 2021 16:01:12 +0800
Message-ID: <1617004872-38974-5-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1617004872-38974-1-git-send-email-liweihang@huawei.com>
References: <1617004872-38974-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yangyang Li <liyangyang20@huawei.com>

Use tab instead of space to align the code.

Signed-off-by: Yangyang Li <liyangyang20@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/net/ethernet/marvell/skge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/marvell/skge.c
index 69072dd..d4bb27b 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -3850,7 +3850,7 @@ static struct net_device *skge_devinit(struct skge_hw *hw, int port,
 
 	/* Only used for Genesis XMAC */
 	if (is_genesis(hw))
-	    timer_setup(&skge->link_timer, xm_link_timer, 0);
+		timer_setup(&skge->link_timer, xm_link_timer, 0);
 	else {
 		dev->hw_features = NETIF_F_IP_CSUM | NETIF_F_SG |
 		                   NETIF_F_RXCSUM;
-- 
2.8.1

