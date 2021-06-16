Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B67A23A93CE
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 09:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbhFPH32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 03:29:28 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:4942 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbhFPH3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 03:29:02 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G4c9r6lbGz6yZh;
        Wed, 16 Jun 2021 15:23:44 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 15:26:54 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 16 Jun 2021 15:26:54 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 10/15] net: cosa: use BIT macro
Date:   Wed, 16 Jun 2021 15:23:36 +0800
Message-ID: <1623828221-48349-11-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623828221-48349-1-git-send-email-huangguangbin2@huawei.com>
References: <1623828221-48349-1-git-send-email-huangguangbin2@huawei.com>
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

This patch uses the BIT macro for setting individual bits,
to fix the following checkpatch.pl issue:
CHECK: Prefer using the BIT macro.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/cosa.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
index a6629dc..ade6da7 100644
--- a/drivers/net/wan/cosa.c
+++ b/drivers/net/wan/cosa.c
@@ -122,9 +122,9 @@ struct channel_data {
 };
 
 /* cosa->firmware_status bits */
-#define COSA_FW_RESET		(1<<0)	/* Is the ROM monitor active? */
-#define COSA_FW_DOWNLOAD	(1<<1)	/* Is the microcode downloaded? */
-#define COSA_FW_START		(1<<2)	/* Is the microcode running? */
+#define COSA_FW_RESET		BIT(0)	/* Is the ROM monitor active? */
+#define COSA_FW_DOWNLOAD	BIT(1)	/* Is the microcode downloaded? */
+#define COSA_FW_START		BIT(2)	/* Is the microcode running? */
 
 struct cosa_data {
 	int num;			/* Card number */
-- 
2.8.1

