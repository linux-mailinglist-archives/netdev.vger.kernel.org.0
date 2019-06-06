Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 157CF3771D
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 16:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728884AbfFFOtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 10:49:01 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:18111 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728782AbfFFOtB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 10:49:01 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 449519EDE45B1854AD72;
        Thu,  6 Jun 2019 22:48:48 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Thu, 6 Jun 2019
 22:48:42 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <alexandre.belloni@bootlin.com>, <UNGLinuxDriver@microchip.com>,
        <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net: mscc: ocelot: remove unused variable 'vcap_data_t'
Date:   Thu, 6 Jun 2019 22:46:49 +0800
Message-ID: <20190606144649.21368-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix sparse warning:

drivers/net/ethernet/mscc/ocelot_ace.c:96:3:
 warning: symbol 'vcap_data_t' was not declared. Should it be static?

'vcap_data_t' never used so can be removed

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/mscc/ocelot_ace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_ace.c b/drivers/net/ethernet/mscc/ocelot_ace.c
index 34d8260..f74b98f 100644
--- a/drivers/net/ethernet/mscc/ocelot_ace.c
+++ b/drivers/net/ethernet/mscc/ocelot_ace.c
@@ -93,7 +93,7 @@ struct vcap_data {
 	u32 counter_offset; /* Current counter offset */
 	u32 tg_value; /* Current type-group value */
 	u32 tg_mask; /* Current type-group mask */
-} vcap_data_t;
+};
 
 static u32 vcap_s2_read_update_ctrl(struct ocelot *oc)
 {
-- 
2.7.4


