Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF5102724EB
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 15:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbgIUNKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 09:10:31 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:42712 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727301AbgIUNK1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 09:10:27 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id ED9D4AE5DA830F33F2A2;
        Mon, 21 Sep 2020 21:10:17 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Mon, 21 Sep 2020 21:10:10 +0800
From:   Qinglang Miao <miaoqinglang@huawei.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Qinglang Miao <miaoqinglang@huawei.com>
Subject: [PATCH -next] ice: simplify the return expression of ice_finalize_update()
Date:   Mon, 21 Sep 2020 21:10:34 +0800
Message-ID: <20200921131034.92063-1-miaoqinglang@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the return expression.

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
---
 drivers/net/ethernet/intel/ice/ice_fw_update.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_fw_update.c b/drivers/net/ethernet/intel/ice/ice_fw_update.c
index deaefe00c..292d87b99 100644
--- a/drivers/net/ethernet/intel/ice/ice_fw_update.c
+++ b/drivers/net/ethernet/intel/ice/ice_fw_update.c
@@ -608,14 +608,9 @@ static int ice_finalize_update(struct pldmfw *context)
 	struct ice_fwu_priv *priv = container_of(context, struct ice_fwu_priv, context);
 	struct netlink_ext_ack *extack = priv->extack;
 	struct ice_pf *pf = priv->pf;
-	int err;
 
 	/* Finally, notify firmware to activate the written NVM banks */
-	err = ice_switch_flash_banks(pf, priv->activate_flags, extack);
-	if (err)
-		return err;
-
-	return 0;
+	return ice_switch_flash_banks(pf, priv->activate_flags, extack);
 }
 
 static const struct pldmfw_ops ice_fwu_ops = {
-- 
2.23.0

