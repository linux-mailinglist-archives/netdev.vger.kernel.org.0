Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A04CA38261B
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 10:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235891AbhEQIBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 04:01:03 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:2939 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235498AbhEQIAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 04:00:13 -0400
Received: from dggems702-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FkBK731nlzCtWf;
        Mon, 17 May 2021 15:56:11 +0800 (CST)
Received: from dggema704-chm.china.huawei.com (10.3.20.68) by
 dggems702-chm.china.huawei.com (10.3.19.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 17 May 2021 15:58:56 +0800
Received: from localhost.localdomain (10.67.165.2) by
 dggema704-chm.china.huawei.com (10.3.20.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 17 May 2021 15:58:55 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Francois Romieu <romieu@fr.zoreil.com>
Subject: [PATCH v2 22/24] net: via: Fix wrong function name in comments
Date:   Mon, 17 May 2021 12:45:33 +0800
Message-ID: <20210517044535.21473-23-shenyang39@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210517044535.21473-1-shenyang39@huawei.com>
References: <20210517044535.21473-1-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.2]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggema704-chm.china.huawei.com (10.3.20.68)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/ethernet/via/via-velocity.c:1908: warning: expecting prototype for tx_srv(). Prototype was for velocity_tx_srv() instead
 drivers/net/ethernet/via/via-velocity.c:2466: warning: expecting prototype for velocity_get_status(). Prototype was for velocity_get_stats() instead
 drivers/net/ethernet/via/via-velocity.c:3734: warning: expecting prototype for velocity_cleanup(). Prototype was for velocity_cleanup_module() instead

Cc: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
---
 drivers/net/ethernet/via/via-velocity.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/via/via-velocity.c b/drivers/net/ethernet/via/via-velocity.c
index fecc4d7b00b0..88426b5e410b 100644
--- a/drivers/net/ethernet/via/via-velocity.c
+++ b/drivers/net/ethernet/via/via-velocity.c
@@ -1897,7 +1897,7 @@ static void velocity_error(struct velocity_info *vptr, int status)
 }
 
 /**
- *	tx_srv		-	transmit interrupt service
+ *	velocity_tx_srv		-	transmit interrupt service
  *	@vptr: Velocity
  *
  *	Scan the queues looking for transmitted packets that
@@ -2453,7 +2453,7 @@ static int velocity_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 }
 
 /**
- *	velocity_get_status	-	statistics callback
+ *	velocity_get_stats	-	statistics callback
  *	@dev: network device
  *
  *	Callback from the network layer to allow driver statistics
@@ -3723,7 +3723,7 @@ static int __init velocity_init_module(void)
 }
 
 /**
- *	velocity_cleanup	-	module unload
+ *	velocity_cleanup_module		-	module unload
  *
  *	When the velocity hardware is unloaded this function is called.
  *	It will clean up the notifiers and the unregister the PCI
-- 
2.17.1

