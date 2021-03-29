Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C59F434D038
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 14:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbhC2MiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 08:38:10 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14947 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231442AbhC2Mhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 08:37:50 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F8BrJ0pBrzyNCK;
        Mon, 29 Mar 2021 20:35:44 +0800 (CST)
Received: from huawei.com (10.175.103.91) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.498.0; Mon, 29 Mar 2021
 20:37:44 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <andrew@lunn.ch>
Subject: [PATCH -next] net: phy: Correct function name mdiobus_register_board_info() in comment
Date:   Mon, 29 Mar 2021 20:40:46 +0800
Message-ID: <20210329124046.3272207-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following make W=1 kernel build warning:

 drivers/net/phy/mdio-boardinfo.c:63: warning: expecting prototype for mdio_register_board_info(). Prototype was for mdiobus_register_board_info() instead

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/phy/mdio-boardinfo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio-boardinfo.c b/drivers/net/phy/mdio-boardinfo.c
index 033df435f76c..2de679a68115 100644
--- a/drivers/net/phy/mdio-boardinfo.c
+++ b/drivers/net/phy/mdio-boardinfo.c
@@ -50,7 +50,7 @@ void mdiobus_setup_mdiodev_from_board_info(struct mii_bus *bus,
 EXPORT_SYMBOL(mdiobus_setup_mdiodev_from_board_info);
 
 /**
- * mdio_register_board_info - register MDIO devices for a given board
+ * mdiobus_register_board_info - register MDIO devices for a given board
  * @info: array of devices descriptors
  * @n: number of descriptors provided
  * Context: can sleep
-- 
2.25.1

