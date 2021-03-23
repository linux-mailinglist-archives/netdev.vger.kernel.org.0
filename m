Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA0BF3458F8
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 08:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbhCWHlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 03:41:42 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:14430 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbhCWHlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 03:41:08 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4F4NYB0SCBzkdV5;
        Tue, 23 Mar 2021 15:39:26 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Tue, 23 Mar 2021 15:40:52 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Yonglong Liu <liuyonglong@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 7/8] net: hns: remove unnecessary !! operation in hns_mac_config_sds_loopback_acpi()
Date:   Tue, 23 Mar 2021 15:41:08 +0800
Message-ID: <1616485269-57044-8-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1616485269-57044-1-git-send-email-tanhuazhong@huawei.com>
References: <1616485269-57044-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

The !! operation of variable en in hns_mac_config_sds_loopback_acpi()
is redundant, so remove it.

Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
index 173d696..325e81d 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
@@ -686,7 +686,7 @@ hns_mac_config_sds_loopback_acpi(struct hns_mac_cb *mac_cb, bool en)
 	obj_args[0].integer.type = ACPI_TYPE_INTEGER;
 	obj_args[0].integer.value = mac_cb->mac_id;
 	obj_args[1].integer.type = ACPI_TYPE_INTEGER;
-	obj_args[1].integer.value = !!en;
+	obj_args[1].integer.value = en;
 
 	argv4.type = ACPI_TYPE_PACKAGE;
 	argv4.package.count = 2;
-- 
2.7.4

