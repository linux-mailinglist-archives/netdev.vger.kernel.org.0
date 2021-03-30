Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA7B34E1B1
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 09:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbhC3HDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 03:03:52 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15037 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbhC3HDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 03:03:49 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F8gMp634MzPmlb;
        Tue, 30 Mar 2021 15:01:10 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Tue, 30 Mar 2021 15:03:42 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 3/4] net: phy: remove repeated word
Date:   Tue, 30 Mar 2021 15:04:05 +0800
Message-ID: <1617087846-14270-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1617087846-14270-1-git-send-email-tanhuazhong@huawei.com>
References: <1617087846-14270-1-git-send-email-tanhuazhong@huawei.com>
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

