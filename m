Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E30773A3C1C
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 08:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbhFKGma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 02:42:30 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3957 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbhFKGm2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 02:42:28 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G1WNh3dHfz6xdf;
        Fri, 11 Jun 2021 14:37:24 +0800 (CST)
Received: from dggema753-chm.china.huawei.com (10.1.198.195) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 11 Jun 2021 14:40:15 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggema753-chm.china.huawei.com (10.1.198.195) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 11 Jun 2021 14:40:15 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Weihang Li <liweihang@huawei.com>
Subject: [PATCH net-next 6/8] net: phy: print the function name by __func__ instead of an fixed string
Date:   Fri, 11 Jun 2021 14:36:57 +0800
Message-ID: <1623393419-2521-7-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623393419-2521-1-git-send-email-liweihang@huawei.com>
References: <1623393419-2521-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggema753-chm.china.huawei.com (10.1.198.195)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wenpeng Liang <liangwenpeng@huawei.com>

It's better to use __func__ than a fixed string to print a
function's name.

Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/net/phy/mdio_device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/mdio_device.c b/drivers/net/phy/mdio_device.c
index 0837319..c94cb53 100644
--- a/drivers/net/phy/mdio_device.c
+++ b/drivers/net/phy/mdio_device.c
@@ -77,7 +77,7 @@ int mdio_device_register(struct mdio_device *mdiodev)
 {
 	int err;
 
-	dev_dbg(&mdiodev->dev, "mdio_device_register\n");
+	dev_dbg(&mdiodev->dev, "%s\n", __func__);
 
 	err = mdiobus_register_device(mdiodev);
 	if (err)
@@ -188,7 +188,7 @@ int mdio_driver_register(struct mdio_driver *drv)
 	struct mdio_driver_common *mdiodrv = &drv->mdiodrv;
 	int retval;
 
-	pr_debug("mdio_driver_register: %s\n", mdiodrv->driver.name);
+	pr_debug("%s: %s\n", __func__, mdiodrv->driver.name);
 
 	mdiodrv->driver.bus = &mdio_bus_type;
 	mdiodrv->driver.probe = mdio_probe;
-- 
2.8.1

