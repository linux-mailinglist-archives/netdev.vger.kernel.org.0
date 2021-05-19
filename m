Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBA0F3886A3
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 07:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245129AbhESFh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 01:37:28 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3592 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242343AbhESFfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 01:35:55 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FlM1c3rrTzsR5X;
        Wed, 19 May 2021 13:31:48 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 13:34:34 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 19 May 2021 13:34:33 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hui Tang <tanghui20@huawei.com>,
        Steffen Klassert <klassert@kernel.org>
Subject: [PATCH 01/20] net: 3com: remove leading spaces before tabs
Date:   Wed, 19 May 2021 13:30:34 +0800
Message-ID: <1621402253-27200-2-git-send-email-tanghui20@huawei.com>
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

There are a few leading space before tabs and remove it by running the
following commard:

	$ find . -name '*.c' | xargs sed -r -i 's/^[ ]+\t/\t/'
	$ find . -name '*.h' | xargs sed -r -i 's/^[ ]+\t/\t/'

Cc: Steffen Klassert <klassert@kernel.org>
Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/net/ethernet/3com/3c59x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/3com/3c59x.c b/drivers/net/ethernet/3com/3c59x.c
index 741c67e..7d7d3ff 100644
--- a/drivers/net/ethernet/3com/3c59x.c
+++ b/drivers/net/ethernet/3com/3c59x.c
@@ -1464,7 +1464,7 @@ static int vortex_probe1(struct device *gendev, void __iomem *ioaddr, int irq,
 	if (pdev) {
 		vp->pm_state_valid = 1;
 		pci_save_state(pdev);
- 		acpi_set_WOL(dev);
+		acpi_set_WOL(dev);
 	}
 	retval = register_netdev(dev);
 	if (retval == 0)
-- 
2.8.1

