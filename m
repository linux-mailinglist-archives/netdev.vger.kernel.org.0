Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC3981AEACA
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 10:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbgDRIP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 04:15:56 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:58852 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725801AbgDRIP4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Apr 2020 04:15:56 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id DB7FBF9A1AF9E0E6A130;
        Sat, 18 Apr 2020 16:15:52 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Sat, 18 Apr 2020
 16:15:46 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <davem@davemloft.net>, <tglx@linutronix.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] net: hns: use true,false for bool variables
Date:   Sat, 18 Apr 2020 16:42:12 +0800
Message-ID: <20200418084212.26012-1-yanaijie@huawei.com>
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

drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c:700:2-8: WARNING:
Assignment of 0/1 to bool variable
drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c:702:2-8: WARNING:
Assignment of 0/1 to bool variable

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
index 8aace2de0cc9..9a907947ba19 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
@@ -697,9 +697,9 @@ hns_mac_register_phydev(struct mii_bus *mdio, struct hns_mac_cb *mac_cb,
 		return rc;
 
 	if (!strcmp(phy_type, phy_modes(PHY_INTERFACE_MODE_XGMII)))
-		is_c45 = 1;
+		is_c45 = true;
 	else if (!strcmp(phy_type, phy_modes(PHY_INTERFACE_MODE_SGMII)))
-		is_c45 = 0;
+		is_c45 = false;
 	else
 		return -ENODATA;
 
-- 
2.21.1

