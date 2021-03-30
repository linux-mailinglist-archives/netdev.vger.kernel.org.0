Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A6734E22F
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 09:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbhC3H2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 03:28:14 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:15392 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbhC3H1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 03:27:45 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4F8gwV1NMyzqSKR;
        Tue, 30 Mar 2021 15:26:02 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Tue, 30 Mar 2021 15:27:37 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <jesse.brandeburg@intel.com>, <j.vosburgh@gmail.com>,
        <vfalico@gmail.com>, <andrew@lunn.ch>, <elder@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [RESEND net-next 2/4] net: bonding: remove repeated word
Date:   Tue, 30 Mar 2021 15:27:54 +0800
Message-ID: <1617089276-30268-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1617089276-30268-1-git-send-email-tanhuazhong@huawei.com>
References: <1617089276-30268-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

Remove repeated word "that".

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/bonding/bond_alb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index c3091e0..3455f2c 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -1098,7 +1098,7 @@ static void alb_fasten_mac_swap(struct bonding *bond, struct slave *slave1,
  * If @slave's permanent hw address is different both from its current
  * address and from @bond's address, then somewhere in the bond there's
  * a slave that has @slave's permanet address as its current address.
- * We'll make sure that that slave no longer uses @slave's permanent address.
+ * We'll make sure that slave no longer uses @slave's permanent address.
  *
  * Caller must hold RTNL and no other locks
  */
-- 
2.7.4

