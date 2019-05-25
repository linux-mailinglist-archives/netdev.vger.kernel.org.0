Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD572A46F
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 14:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbfEYMqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 08:46:11 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:52810 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726585AbfEYMqL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 May 2019 08:46:11 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id E42F518765FCF115AD0F;
        Sat, 25 May 2019 20:46:07 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Sat, 25 May 2019
 20:45:59 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <vishal@chelsio.com>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] cxgb4: Make t4_get_tp_e2c_map static
Date:   Sat, 25 May 2019 20:45:10 +0800
Message-ID: <20190525124510.13864-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix sparse warning:

drivers/net/ethernet/chelsio/cxgb4/t4_hw.c:6216:14:
 warning: symbol 't4_get_tp_e2c_map' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 8c17d1c75e84..a0a2eefc4687 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -6213,7 +6213,7 @@ unsigned int t4_get_mps_bg_map(struct adapter *adapter, int pidx)
  *      @adapter: the adapter
  *      @pidx: the port index
  */
-unsigned int t4_get_tp_e2c_map(struct adapter *adapter, int pidx)
+static unsigned int t4_get_tp_e2c_map(struct adapter *adapter, int pidx)
 {
 	unsigned int nports;
 	u32 param, val = 0;
-- 
2.17.1


