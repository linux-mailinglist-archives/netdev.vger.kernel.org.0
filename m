Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351DD261311
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 16:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730054AbgIHOzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 10:55:36 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56758 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729027AbgIHOYw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 10:24:52 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 973783CAAE98B997207F;
        Tue,  8 Sep 2020 22:04:42 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Tue, 8 Sep 2020
 22:04:36 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <aelior@marvell.com>, <skalluru@marvell.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] bnx2x: Fix some kernel-doc warnings
Date:   Tue, 8 Sep 2020 22:01:58 +0800
Message-ID: <20200908140158.23540-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c:4238: warning: Excess function parameter 'netdev' description in 'bnx2x_setup_tc'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c:4238: warning: Excess function parameter 'tc' description in 'bnx2x_setup_tc'

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index e3d92e4f2193..2c0ccd4fba9b 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -4229,8 +4229,8 @@ void bnx2x_get_c2s_mapping(struct bnx2x *bp, u8 *c2s_map, u8 *c2s_default)
 /**
  * bnx2x_setup_tc - routine to configure net_device for multi tc
  *
- * @netdev: net device to configure
- * @tc: number of traffic classes to enable
+ * @dev: net device to configure
+ * @num_tc: number of traffic classes to enable
  *
  * callback connected to the ndo_setup_tc function pointer
  */
-- 
2.17.1

