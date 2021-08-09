Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B61D3E4808
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 16:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234815AbhHIOyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 10:54:51 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:16999 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234244AbhHIOyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 10:54:49 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GjzXl2WJRzZyrJ;
        Mon,  9 Aug 2021 22:50:47 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 9 Aug 2021 22:54:25 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 9 Aug 2021 22:54:24 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 3/4] net: hns3: add header file hns3_ethtoo.h
Date:   Mon, 9 Aug 2021 22:50:41 +0800
Message-ID: <1628520642-30839-4-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1628520642-30839-1-git-send-email-huangguangbin2@huawei.com>
References: <1628520642-30839-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new file hns3_ethtool.h, and move struct type definitions from
hns3_ethtool.c to hns3_ethtool.h.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 16 +-------------
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.h | 25 ++++++++++++++++++++++
 2 files changed, 26 insertions(+), 15 deletions(-)
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.h

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 82061ab6930f..b7ba5f780c5e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -7,21 +7,7 @@
 #include <linux/sfp.h>
 
 #include "hns3_enet.h"
-
-struct hns3_stats {
-	char stats_string[ETH_GSTRING_LEN];
-	int stats_offset;
-};
-
-struct hns3_sfp_type {
-	u8 type;
-	u8 ext_type;
-};
-
-struct hns3_pflag_desc {
-	char name[ETH_GSTRING_LEN];
-	void (*handler)(struct net_device *netdev, bool enable);
-};
+#include "hns3_ethtool.h"
 
 /* tqp related stats */
 #define HNS3_TQP_STAT(_string, _member)	{			\
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.h b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.h
new file mode 100644
index 000000000000..2f186607c6e0
--- /dev/null
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+// Copyright (c) 2021 Hisilicon Limited.
+
+#ifndef __HNS3_ETHTOOL_H
+#define __HNS3_ETHTOOL_H
+
+#include <linux/ethtool.h>
+#include <linux/netdevice.h>
+
+struct hns3_stats {
+	char stats_string[ETH_GSTRING_LEN];
+	int stats_offset;
+};
+
+struct hns3_sfp_type {
+	u8 type;
+	u8 ext_type;
+};
+
+struct hns3_pflag_desc {
+	char name[ETH_GSTRING_LEN];
+	void (*handler)(struct net_device *netdev, bool enable);
+};
+
+#endif
-- 
2.8.1

