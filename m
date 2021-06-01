Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3F2B396D57
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 08:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232915AbhFAG3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 02:29:30 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:6102 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbhFAG33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 02:29:29 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FvMb32HV9zYpKl;
        Tue,  1 Jun 2021 14:25:03 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 1 Jun 2021 14:27:42 +0800
Received: from thunder-town.china.huawei.com (10.174.177.72) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 1 Jun 2021 14:27:42 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 1/1] fjes: Use DEFINE_RES_MEM() and DEFINE_RES_IRQ() to simplify code
Date:   Tue, 1 Jun 2021 14:27:36 +0800
Message-ID: <20210601062736.9777-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.177.72]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No functional change.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/net/fjes/fjes_main.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/net/fjes/fjes_main.c b/drivers/net/fjes/fjes_main.c
index 466622664424dcd..d098b1fcf0067b1 100644
--- a/drivers/net/fjes/fjes_main.c
+++ b/drivers/net/fjes/fjes_main.c
@@ -90,16 +90,8 @@ static struct platform_driver fjes_driver = {
 };
 
 static struct resource fjes_resource[] = {
-	{
-		.flags = IORESOURCE_MEM,
-		.start = 0,
-		.end = 0,
-	},
-	{
-		.flags = IORESOURCE_IRQ,
-		.start = 0,
-		.end = 0,
-	},
+	DEFINE_RES_MEM(0, 1),
+	DEFINE_RES_IRQ(0)
 };
 
 static bool is_extended_socket_device(struct acpi_device *device)
-- 
2.26.0.106.g9fadedd


