Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E491534C614
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 10:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231708AbhC2IEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 04:04:54 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15084 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232085AbhC2IDx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 04:03:53 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F84mD6g7nz19Js7;
        Mon, 29 Mar 2021 16:01:48 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.498.0; Mon, 29 Mar 2021 16:03:41 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <sebastian.hesselbarth@gmail.com>, <thomas.petazzoni@bootlin.com>,
        <mlindner@marvell.com>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>, <linuxarm@huawei.com>,
        Yangyang Li <liyangyang20@huawei.com>,
        Weihang Li <liweihang@huawei.com>
Subject: [PATCH net-next 3/4] net: marvell: Delete extra spaces
Date:   Mon, 29 Mar 2021 16:01:11 +0800
Message-ID: <1617004872-38974-4-git-send-email-liweihang@huawei.com>
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

Just delete three extra spaces.

Signed-off-by: Yangyang Li <liyangyang20@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/net/ethernet/marvell/mvneta.c | 2 +-
 drivers/net/ethernet/marvell/skge.c   | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 3c6f4db..dfa6281 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -1084,7 +1084,7 @@ static int mvneta_mbus_io_win_set(struct mvneta_port *pp, u32 base, u32 wsize,
 	return 0;
 }
 
-static  int mvneta_bm_port_mbus_init(struct mvneta_port *pp)
+static int mvneta_bm_port_mbus_init(struct mvneta_port *pp)
 {
 	u32 wsize;
 	u8 target, attr;
diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/marvell/skge.c
index c0882c7..69072dd 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -2959,8 +2959,9 @@ static void genesis_set_multicast(struct net_device *dev)
 
 static void yukon_add_filter(u8 filter[8], const u8 *addr)
 {
-	 u32 bit = ether_crc(ETH_ALEN, addr) & 0x3f;
-	 filter[bit/8] |= 1 << (bit%8);
+	u32 bit = ether_crc(ETH_ALEN, addr) & 0x3f;
+
+	filter[bit / 8] |= 1 << (bit % 8);
 }
 
 static void yukon_set_multicast(struct net_device *dev)
-- 
2.8.1

