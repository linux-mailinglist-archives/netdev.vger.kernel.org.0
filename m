Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A96451936CF
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 04:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727751AbgCZDY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 23:24:29 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:47238 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727560AbgCZDY3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 23:24:29 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B3CDE53E932DA8590320;
        Thu, 26 Mar 2020 11:24:03 +0800 (CST)
Received: from localhost (10.173.223.234) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Thu, 26 Mar 2020
 11:23:54 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <jcliburn@gmail.com>, <chris.snook@gmail.com>,
        <davem@davemloft.net>, <yuehaibing@huawei.com>,
        <hkallweit1@gmail.com>, <mhabets@solarflare.com>,
        <huangfq.daxian@gmail.com>, <leon@kernel.org>,
        <colin.king@canonical.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] atl2: remove unused variable 'atl2_driver_string'
Date:   Thu, 26 Mar 2020 11:21:50 +0800
Message-ID: <20200326032150.15568-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.223.234]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/ethernet/atheros/atlx/atl2.c:40:19: warning: ‘atl2_driver_string’ defined but not used [-Wunused-const-variable=]
 static const char atl2_driver_string[] = "Atheros(R) L2 Ethernet Driver";
                   ^~~~~~~~~~~~~~~~~~

commit ea973742140b ("net/atheros: Clean atheros code from driver version")
left behind this, remove it.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/atheros/atlx/atl2.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/atlx/atl2.c b/drivers/net/ethernet/atheros/atlx/atl2.c
index 7c52b92b599d..c915852b8892 100644
--- a/drivers/net/ethernet/atheros/atlx/atl2.c
+++ b/drivers/net/ethernet/atheros/atlx/atl2.c
@@ -37,7 +37,6 @@
 #include "atl2.h"
 
 static const char atl2_driver_name[] = "atl2";
-static const char atl2_driver_string[] = "Atheros(R) L2 Ethernet Driver";
 static const struct ethtool_ops atl2_ethtool_ops;
 
 MODULE_AUTHOR("Atheros Corporation <xiong.huang@atheros.com>, Chris Snook <csnook@redhat.com>");
-- 
2.17.1


