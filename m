Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9E234E231
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 09:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbhC3H2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 03:28:15 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:15819 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231341AbhC3H1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 03:27:50 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4F8gw76sMDz93jh;
        Tue, 30 Mar 2021 15:25:43 +0800 (CST)
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
Subject: [RESEND net-next 3/4] net: phy: remove repeated word
Date:   Tue, 30 Mar 2021 15:27:55 +0800
Message-ID: <1617089276-30268-4-git-send-email-tanhuazhong@huawei.com>
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

Remove repeated word "to".

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/phy/mdio_bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 8235185..dadf75f 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -510,7 +510,7 @@ static int mdiobus_create_device(struct mii_bus *bus,
  *   on a given bus, and attach them to the bus. Drivers should use
  *   mdiobus_register() rather than __mdiobus_register() unless they
  *   need to pass a specific owner module. MDIO devices which are not
- *   PHYs will not be brought up by this function. They are expected to
+ *   PHYs will not be brought up by this function. They are expected
  *   to be explicitly listed in DT and instantiated by of_mdiobus_register().
  *
  * Returns 0 on success or < 0 on error.
-- 
2.7.4

