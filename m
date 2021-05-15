Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4233817E9
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 12:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234926AbhEOK5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 06:57:32 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3548 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232975AbhEOKzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 06:55:54 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fj2Jn4zHHzsRHC;
        Sat, 15 May 2021 18:51:53 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Sat, 15 May 2021 18:54:28 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Francois Romieu <romieu@fr.zoreil.com>
Subject: [PATCH 22/34] net: via: Fix wrong function name in comments
Date:   Sat, 15 May 2021 18:53:47 +0800
Message-ID: <1621076039-53986-23-git-send-email-shenyang39@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621076039-53986-1-git-send-email-shenyang39@huawei.com>
References: <1621076039-53986-1-git-send-email-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
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
index fecc4d7..88426b5 100644
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
2.7.4

