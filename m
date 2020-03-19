Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24D7318ACF9
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 07:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgCSGrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 02:47:31 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:35730 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726063AbgCSGrb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 02:47:31 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C2B2C19FDB0857EA0842;
        Thu, 19 Mar 2020 14:47:05 +0800 (CST)
Received: from localhost (10.173.223.234) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Thu, 19 Mar 2020
 14:46:58 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <claudiu.manoil@nxp.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <leonro@mellanox.com>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] enetc: Remove unused variable 'enetc_drv_name'
Date:   Thu, 19 Mar 2020 14:46:37 +0800
Message-ID: <20200319064637.45048-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.173.223.234]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit ed0a72e0de16 ("net/freescale: Clean drivers from static versions")
leave behind this, remove it .

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 1 -
 drivers/net/ethernet/freescale/enetc/enetc_vf.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 4e4a49179f0b..85e2b741df41 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -8,7 +8,6 @@
 #include "enetc_pf.h"
 
 #define ENETC_DRV_NAME_STR "ENETC PF driver"
-static const char enetc_drv_name[] = ENETC_DRV_NAME_STR;
 
 static void enetc_pf_get_primary_mac_addr(struct enetc_hw *hw, int si, u8 *addr)
 {
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_vf.c b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
index 28a786b2f3e7..f14576212a0e 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_vf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
@@ -5,7 +5,6 @@
 #include "enetc.h"
 
 #define ENETC_DRV_NAME_STR "ENETC VF driver"
-static const char enetc_drv_name[] = ENETC_DRV_NAME_STR;
 
 /* Messaging */
 static void enetc_msg_vsi_write_msg(struct enetc_hw *hw,
-- 
2.17.1


