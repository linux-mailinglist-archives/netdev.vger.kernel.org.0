Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D21971C4F63
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 09:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728486AbgEEHoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 03:44:38 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:56324 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725915AbgEEHoh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 03:44:37 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id E6E02866747BBFB15733;
        Tue,  5 May 2020 15:44:35 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Tue, 5 May 2020
 15:44:27 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <shshaikh@marvell.com>, <manishc@marvell.com>,
        <GR-Linux-NIC-Dev@marvell.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH net-next] qlcnic: use true,false for bool variable in qlcnic_sriov_common.c
Date:   Tue, 5 May 2020 15:43:49 +0800
Message-ID: <20200505074349.21578-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:

drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c:1585:3-25:
WARNING: Assignment of 0/1 to bool variable
drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c:1588:3-25:
WARNING: Assignment of 0/1 to bool variable

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
index f7c2f32237cb..7adbb03cb931 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
@@ -1582,10 +1582,10 @@ void qlcnic_sriov_vf_set_multi(struct net_device *netdev)
 		if (mode == VPORT_MISS_MODE_ACCEPT_ALL &&
 		    !adapter->fdb_mac_learn) {
 			qlcnic_alloc_lb_filters_mem(adapter);
-			adapter->drv_mac_learn = 1;
+			adapter->drv_mac_learn = true;
 			adapter->rx_mac_learn = true;
 		} else {
-			adapter->drv_mac_learn = 0;
+			adapter->drv_mac_learn = false;
 			adapter->rx_mac_learn = false;
 		}
 	}
-- 
2.21.1

