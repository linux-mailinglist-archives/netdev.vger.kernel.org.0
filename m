Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D81A3AC0D3
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 04:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233676AbhFRChu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 22:37:50 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:8267 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231654AbhFRChr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 22:37:47 -0400
Received: from dggeme755-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G5jZf0WCFz1BNmQ;
        Fri, 18 Jun 2021 10:30:34 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggeme755-chm.china.huawei.com (10.3.19.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 18 Jun 2021 10:35:37 +0800
From:   Peng Li <lipeng321@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>
Subject: [PATCH V2 net-next 2/7] net: hostess_sv11: move out assignment in if condition
Date:   Fri, 18 Jun 2021 10:32:19 +0800
Message-ID: <1623983544-39879-3-git-send-email-lipeng321@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623983544-39879-1-git-send-email-lipeng321@huawei.com>
References: <1623983544-39879-1-git-send-email-lipeng321@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme755-chm.china.huawei.com (10.3.19.101)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Should not use assignment in if condition.

Signed-off-by: Peng Li <lipeng321@huawei.com>
---
 drivers/net/wan/hostess_sv11.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wan/hostess_sv11.c b/drivers/net/wan/hostess_sv11.c
index a18c09d..8dce8b1 100644
--- a/drivers/net/wan/hostess_sv11.c
+++ b/drivers/net/wan/hostess_sv11.c
@@ -340,7 +340,8 @@ static struct z8530_dev *sv11_unit;
 
 int init_module(void)
 {
-	if ((sv11_unit = sv11_init(io, irq)) == NULL)
+	sv11_unit = sv11_init(io, irq);
+	if (!sv11_unit)
 		return -ENODEV;
 	return 0;
 }
-- 
2.8.1

