Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B072B1A9602
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 10:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2635746AbgDOIQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 04:16:30 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2325 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2635729AbgDOIQ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 04:16:29 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 9B6F514C4C5638BB6EEE;
        Wed, 15 Apr 2020 16:16:27 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Wed, 15 Apr 2020
 16:16:20 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <davem@davemloft.net>, <snelson@pensando.io>, <kuba@kernel.org>,
        <hkallweit1@gmail.com>, <leon@kernel.org>, <yanaijie@huawei.com>,
        <mst@redhat.com>, <netdev@vger.kernel.org>,
        <linux-parisc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] net: tulip: make early_486_chipsets static
Date:   Wed, 15 Apr 2020 16:42:48 +0800
Message-ID: <20200415084248.24378-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following sparse warning:

drivers/net/ethernet/dec/tulip/tulip_core.c:1280:28: warning: symbol
'early_486_chipsets' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/ethernet/dec/tulip/tulip_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/dec/tulip/tulip_core.c b/drivers/net/ethernet/dec/tulip/tulip_core.c
index 48ea658aa1a6..15efc294f513 100644
--- a/drivers/net/ethernet/dec/tulip/tulip_core.c
+++ b/drivers/net/ethernet/dec/tulip/tulip_core.c
@@ -1277,7 +1277,7 @@ static const struct net_device_ops tulip_netdev_ops = {
 #endif
 };
 
-const struct pci_device_id early_486_chipsets[] = {
+static const struct pci_device_id early_486_chipsets[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82424) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_SI, PCI_DEVICE_ID_SI_496) },
 	{ },
-- 
2.21.1

