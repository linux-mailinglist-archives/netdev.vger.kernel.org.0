Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC5038BB4F
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 03:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236313AbhEUBMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 21:12:46 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5707 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236071AbhEUBMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 21:12:39 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FmT404cGZzqVWP;
        Fri, 21 May 2021 09:07:44 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 21 May 2021 09:11:15 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 21 May 2021 09:11:15 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 5/6] net: wan: add braces {} to all arms of the statement
Date:   Fri, 21 May 2021 09:08:16 +0800
Message-ID: <1621559297-9651-6-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621559297-9651-1-git-send-email-huangguangbin2@huawei.com>
References: <1621559297-9651-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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
 drivers/net/wan/hd64572.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wan/hd64572.c b/drivers/net/wan/hd64572.c
index 34acea93efdf..7fccf23c8bef 100644
--- a/drivers/net/wan/hd64572.c
+++ b/drivers/net/wan/hd64572.c
@@ -374,8 +374,9 @@ static void sca_set_port(port_t *port)
 			tmc = 1;
 			br = 0;	/* For baud=CLOCK_BASE we use tmc=1 br=0 */
 			brv = 1;
-		} else if (tmc > 255)
+		} else if (tmc > 255) {
 			tmc = 256; /* tmc=0 means 256 - low baud rates */
+		}
 
 		port->settings.clock_rate = CLOCK_BASE / brv / tmc;
 	} else {
-- 
2.8.1

