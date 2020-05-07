Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 269881C8411
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 09:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgEGH7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 03:59:33 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:46846 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725879AbgEGH7d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 03:59:33 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 56786EBB9CFDFC6BB918;
        Thu,  7 May 2020 15:59:31 +0800 (CST)
Received: from huawei.com (10.175.113.25) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Thu, 7 May 2020
 15:59:23 +0800
From:   Zheng Zengkai <zhengzengkai@huawei.com>
To:     <andrew@lunn.ch>, <davem@davemloft.net>, <rjui@broadcom.com>
CC:     <f.fainelli@gmail.com>, <bcm-kernel-feedback-list@broadcom.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <zhengzengkai@huawei.com>
Subject: [PATCH net-next] net: phy: Make iproc_mdio_resume static
Date:   Thu, 7 May 2020 16:03:26 +0800
Message-ID: <20200507080326.111896-1-zhengzengkai@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix sparse warnings:

drivers/net/phy/mdio-bcm-iproc.c:182:5: warning:
 symbol 'iproc_mdio_resume' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zheng Zengkai <zhengzengkai@huawei.com>
---
 drivers/net/phy/mdio-bcm-iproc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio-bcm-iproc.c b/drivers/net/phy/mdio-bcm-iproc.c
index f1ded03f0229..89bdfcc0e506 100644
--- a/drivers/net/phy/mdio-bcm-iproc.c
+++ b/drivers/net/phy/mdio-bcm-iproc.c
@@ -179,7 +179,7 @@ static int iproc_mdio_remove(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_PM_SLEEP
-int iproc_mdio_resume(struct device *dev)
+static int iproc_mdio_resume(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct iproc_mdio_priv *priv = platform_get_drvdata(pdev);
-- 
2.20.1

