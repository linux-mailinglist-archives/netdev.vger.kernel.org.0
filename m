Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66BA53886BD
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 07:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245224AbhESFjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 01:39:23 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3594 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243136AbhESFgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 01:36:03 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FlM1g6BzHzsRLH;
        Wed, 19 May 2021 13:31:51 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 13:34:37 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 19 May 2021 13:34:36 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hui Tang <tanghui20@huawei.com>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH 11/20] net: natsemi: remove leading spaces before tabs
Date:   Wed, 19 May 2021 13:30:44 +0800
Message-ID: <1621402253-27200-12-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621402253-27200-1-git-send-email-tanghui20@huawei.com>
References: <1621402253-27200-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggemi760-chm.china.huawei.com (10.1.198.146)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few leading spaces before tabs and remove it by running the
following commard:

	$ find . -name '*.c' | xargs sed -r -i 's/^[ ]+\t/\t/'
	$ find . -name '*.h' | xargs sed -r -i 's/^[ ]+\t/\t/'

Cc: Zheng Yongjun <zhengyongjun3@huawei.com>
Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/net/ethernet/natsemi/natsemi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/natsemi.c b/drivers/net/ethernet/natsemi/natsemi.c
index b81e148..51b4b25 100644
--- a/drivers/net/ethernet/natsemi/natsemi.c
+++ b/drivers/net/ethernet/natsemi/natsemi.c
@@ -969,7 +969,7 @@ static int natsemi_probe1(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return 0;
 
  err_create_file:
- 	unregister_netdev(dev);
+	unregister_netdev(dev);
 
  err_register_netdev:
 	iounmap(ioaddr);
@@ -3103,14 +3103,14 @@ static int netdev_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 	case SIOCSMIIREG:		/* Write MII PHY register. */
 		if (dev->if_port == PORT_TP) {
 			if ((data->phy_id & 0x1f) == np->phy_addr_external) {
- 				if ((data->reg_num & 0x1f) == MII_ADVERTISE)
+				if ((data->reg_num & 0x1f) == MII_ADVERTISE)
 					np->advertising = data->val_in;
 				mdio_write(dev, data->reg_num & 0x1f,
 							data->val_in);
 			}
 		} else {
 			if ((data->phy_id & 0x1f) == np->phy_addr_external) {
- 				if ((data->reg_num & 0x1f) == MII_ADVERTISE)
+				if ((data->reg_num & 0x1f) == MII_ADVERTISE)
 					np->advertising = data->val_in;
 			}
 			move_int_phy(dev, data->phy_id & 0x1f);
-- 
2.8.1

