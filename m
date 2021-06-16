Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0237F3A93C4
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 09:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbhFPH3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 03:29:13 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7454 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbhFPH3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 03:29:01 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G4cB651YxzZgwT;
        Wed, 16 Jun 2021 15:23:58 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 15:26:54 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 16 Jun 2021 15:26:53 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 07/15] net: cosa: add braces {} to all arms of the statement
Date:   Wed, 16 Jun 2021 15:23:33 +0800
Message-ID: <1623828221-48349-8-git-send-email-huangguangbin2@huawei.com>
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

Braces {} should be used on all arms of this statement.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/cosa.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
index c09c079..b3dab61 100644
--- a/drivers/net/wan/cosa.c
+++ b/drivers/net/wan/cosa.c
@@ -468,11 +468,11 @@ static int cosa_probe(int base, int irq, int dma)
 	}
 
 	/* Test the validity of identification string */
-	if (!strncmp(cosa->id_string, "SRP", 3))
+	if (!strncmp(cosa->id_string, "SRP", 3)) {
 		cosa->type = "srp";
-	else if (!strncmp(cosa->id_string, "COSA", 4))
+	} else if (!strncmp(cosa->id_string, "COSA", 4)) {
 		cosa->type = is_8bit(cosa)? "cosa8": "cosa16";
-	else {
+	} else {
 /* Print a warning only if we are not autoprobing */
 #ifndef COSA_ISA_AUTOPROBE
 		pr_info("valid signature not found at 0x%x\n", base);
-- 
2.8.1

