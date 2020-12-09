Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03AB92D435A
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 14:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732461AbgLINfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 08:35:52 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9567 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732043AbgLINfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 08:35:52 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CrdLq3SvszLmR8;
        Wed,  9 Dec 2020 21:34:27 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Wed, 9 Dec 2020 21:35:02 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-afs@lists.infradead.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <yisen.zhuang@huawei.com>,
        <salil.mehta@huawei.com>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] hisilicon/hns: convert comma to semicolon
Date:   Wed, 9 Dec 2020 21:35:31 +0800
Message-ID: <20201209133531.1177-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace a comma between expression statements by a semicolon.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
index a9aca8c24e90..173d6966c1a3 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
@@ -546,9 +546,9 @@ static phy_interface_t hns_mac_get_phy_if_acpi(struct hns_mac_cb *mac_cb)
 	obj_args.integer.type = ACPI_TYPE_INTEGER;
 	obj_args.integer.value = mac_cb->mac_id;
 
-	argv4.type = ACPI_TYPE_PACKAGE,
-	argv4.package.count = 1,
-	argv4.package.elements = &obj_args,
+	argv4.type = ACPI_TYPE_PACKAGE;
+	argv4.package.count = 1;
+	argv4.package.elements = &obj_args;
 
 	obj = acpi_evaluate_dsm(ACPI_HANDLE(mac_cb->dev),
 				&hns_dsaf_acpi_dsm_guid, 0,
@@ -593,9 +593,9 @@ static int hns_mac_get_sfp_prsnt_acpi(struct hns_mac_cb *mac_cb, int *sfp_prsnt)
 	obj_args.integer.type = ACPI_TYPE_INTEGER;
 	obj_args.integer.value = mac_cb->mac_id;
 
-	argv4.type = ACPI_TYPE_PACKAGE,
-	argv4.package.count = 1,
-	argv4.package.elements = &obj_args,
+	argv4.type = ACPI_TYPE_PACKAGE;
+	argv4.package.count = 1;
+	argv4.package.elements = &obj_args;
 
 	obj = acpi_evaluate_dsm(ACPI_HANDLE(mac_cb->dev),
 				&hns_dsaf_acpi_dsm_guid, 0,
-- 
2.22.0

