Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D281B380460
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 09:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233182AbhENHfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 03:35:54 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2659 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbhENHfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 03:35:50 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FhKvh5wgJzQnKr;
        Fri, 14 May 2021 15:31:12 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 14 May 2021 15:34:37 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 14 May 2021 15:34:36 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <lipeng321@huawei.com>,
        <tanhuazhong@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 2/4] net: hns: fix some code style issue about space
Date:   Fri, 14 May 2021 15:31:40 +0800
Message-ID: <1620977502-27236-3-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1620977502-27236-1-git-send-email-huangguangbin2@huawei.com>
References: <1620977502-27236-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

Spaces at the start of a line will cause checkpatch warning.
This patch replaces the spaces by tab at the start of a line.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c | 70 +++++++++++-----------
 1 file changed, 35 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
index 325e81d..4f7684a 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
@@ -56,31 +56,31 @@ static u32 dsaf_read_sub(struct dsaf_device *dsaf_dev, u32 reg)
 }
 
 static void hns_dsaf_acpi_ledctrl_by_port(struct hns_mac_cb *mac_cb, u8 op_type,
-                                      u32 link, u32 port, u32 act)
+					  u32 link, u32 port, u32 act)
 {
-       union acpi_object *obj;
-       union acpi_object obj_args[3], argv4;
+	union acpi_object *obj;
+	union acpi_object obj_args[3], argv4;
 
-       obj_args[0].integer.type = ACPI_TYPE_INTEGER;
-       obj_args[0].integer.value = link;
-       obj_args[1].integer.type = ACPI_TYPE_INTEGER;
-       obj_args[1].integer.value = port;
-       obj_args[2].integer.type = ACPI_TYPE_INTEGER;
-       obj_args[2].integer.value = act;
+	obj_args[0].integer.type = ACPI_TYPE_INTEGER;
+	obj_args[0].integer.value = link;
+	obj_args[1].integer.type = ACPI_TYPE_INTEGER;
+	obj_args[1].integer.value = port;
+	obj_args[2].integer.type = ACPI_TYPE_INTEGER;
+	obj_args[2].integer.value = act;
 
-       argv4.type = ACPI_TYPE_PACKAGE;
-       argv4.package.count = 3;
-       argv4.package.elements = obj_args;
+	argv4.type = ACPI_TYPE_PACKAGE;
+	argv4.package.count = 3;
+	argv4.package.elements = obj_args;
 
-       obj = acpi_evaluate_dsm(ACPI_HANDLE(mac_cb->dev),
-                               &hns_dsaf_acpi_dsm_guid, 0, op_type, &argv4);
-       if (!obj) {
-               dev_warn(mac_cb->dev, "ledctrl fail, link:%d port:%d act:%d!\n",
-                        link, port, act);
-               return;
-       }
+	obj = acpi_evaluate_dsm(ACPI_HANDLE(mac_cb->dev),
+				&hns_dsaf_acpi_dsm_guid, 0, op_type, &argv4);
+	if (!obj) {
+		dev_warn(mac_cb->dev, "ledctrl fail, link:%d port:%d act:%d!\n",
+			 link, port, act);
+		return;
+	}
 
-       ACPI_FREE(obj);
+	ACPI_FREE(obj);
 }
 
 static void hns_dsaf_acpi_locate_ledctrl_by_port(struct hns_mac_cb *mac_cb,
@@ -151,15 +151,15 @@ static void hns_cpld_set_led(struct hns_mac_cb *mac_cb, int link_status,
 }
 
 static void hns_cpld_set_led_acpi(struct hns_mac_cb *mac_cb, int link_status,
-                            u16 speed, int data)
+				  u16 speed, int data)
 {
-       if (!mac_cb) {
-               pr_err("cpld_led_set mac_cb is null!\n");
-               return;
-       }
+	if (!mac_cb) {
+		pr_err("cpld_led_set mac_cb is null!\n");
+		return;
+	}
 
-       hns_dsaf_acpi_ledctrl_by_port(mac_cb, HNS_OP_LED_SET_FUNC,
-               link_status, mac_cb->mac_id, data);
+	hns_dsaf_acpi_ledctrl_by_port(mac_cb, HNS_OP_LED_SET_FUNC,
+				      link_status, mac_cb->mac_id, data);
 }
 
 static void cpld_led_reset(struct hns_mac_cb *mac_cb)
@@ -174,16 +174,16 @@ static void cpld_led_reset(struct hns_mac_cb *mac_cb)
 
 static void cpld_led_reset_acpi(struct hns_mac_cb *mac_cb)
 {
-       if (!mac_cb) {
-               pr_err("cpld_led_reset mac_cb is null!\n");
-               return;
-       }
+	if (!mac_cb) {
+		pr_err("cpld_led_reset mac_cb is null!\n");
+		return;
+	}
 
-       if (mac_cb->media_type != HNAE_MEDIA_TYPE_FIBER)
-                return;
+	if (mac_cb->media_type != HNAE_MEDIA_TYPE_FIBER)
+		return;
 
-       hns_dsaf_acpi_ledctrl_by_port(mac_cb, HNS_OP_LED_SET_FUNC,
-               0, mac_cb->mac_id, 0);
+	hns_dsaf_acpi_ledctrl_by_port(mac_cb, HNS_OP_LED_SET_FUNC,
+				      0, mac_cb->mac_id, 0);
 }
 
 static int cpld_set_led_id(struct hns_mac_cb *mac_cb,
-- 
2.7.4

