Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D915270B88
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 09:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgISHpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 03:45:13 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13722 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726041AbgISHpN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Sep 2020 03:45:13 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 6C31A49D8235136040DF;
        Sat, 19 Sep 2020 15:45:06 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Sat, 19 Sep 2020
 15:44:56 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <vaibhavgupta40@gmail.com>, <netdev@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH net-next] 8139too: use true,false for bool variables
Date:   Sat, 19 Sep 2020 15:46:09 +0800
Message-ID: <20200919074609.3460496-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This addresses the following coccinelle warning:

drivers/net/ethernet/realtek/8139too.c:981:2-8: WARNING: Assignment of
0/1 to bool variable

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/ethernet/realtek/8139too.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/8139too.c b/drivers/net/ethernet/realtek/8139too.c
index 227139d42227..1e5a453dea14 100644
--- a/drivers/net/ethernet/realtek/8139too.c
+++ b/drivers/net/ethernet/realtek/8139too.c
@@ -978,7 +978,7 @@ static int rtl8139_init_one(struct pci_dev *pdev,
 	    pdev->subsystem_vendor == PCI_VENDOR_ID_ATHEROS &&
 	    pdev->subsystem_device == PCI_DEVICE_ID_REALTEK_8139) {
 		pr_info("OQO Model 2 detected. Forcing PIO\n");
-		use_io = 1;
+		use_io = true;
 	}
 
 	dev = rtl8139_init_board (pdev);
-- 
2.25.4

