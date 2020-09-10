Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50F7265058
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgIJULp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:11:45 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:57152 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731156AbgIJO7Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 10:59:25 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 8EDC6AD778990F2F308B;
        Thu, 10 Sep 2020 22:59:18 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Thu, 10 Sep 2020
 22:59:08 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <snelson@pensando.io>,
        <colin.king@canonical.com>, <maz@kernel.org>, <luobin9@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 3/6] net: hns: Fix some kernel-doc warnings in hns_dsaf_xgmac.c
Date:   Thu, 10 Sep 2020 22:56:17 +0800
Message-ID: <20200910145620.27470-4-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910145620.27470-1-wanghai38@huawei.com>
References: <20200910145620.27470-1-wanghai38@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c:137: warning: Excess function parameter 'drv' description in 'hns_xgmac_enable'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c:497: warning: Excess function parameter 'cmd' description in 'hns_xgmac_get_regs'

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c
index 0a3dbab2dfc9..d832cd018c1c 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c
@@ -130,7 +130,7 @@ static void hns_xgmac_lf_rf_control_init(struct mac_driver *mac_drv)
 
 /**
  *hns_xgmac_enable - enable xgmac port
- *@drv: mac driver
+ *@mac_drv: mac driver
  *@mode: mode of mac port
  */
 static void hns_xgmac_enable(void *mac_drv, enum mac_commom_mode mode)
@@ -490,7 +490,6 @@ static void hns_xgmac_get_link_status(void *mac_drv, u32 *link_stat)
 /**
  *hns_xgmac_get_regs - dump xgmac regs
  *@mac_drv: mac driver
- *@cmd:ethtool cmd
  *@data:data for value of regs
  */
 static void hns_xgmac_get_regs(void *mac_drv, void *data)
-- 
2.17.1

