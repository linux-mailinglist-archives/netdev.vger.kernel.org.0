Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37C2F3817D9
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 12:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbhEOK4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 06:56:35 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3542 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232200AbhEOKzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 06:55:47 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fj2Jh5HHLzsRB8;
        Sat, 15 May 2021 18:51:48 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Sat, 15 May 2021 18:54:21 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Chris Snook <chris.snook@gmail.com>
Subject: [PATCH 03/34] net: atheros: atl1e: Fix wrong function name in comments
Date:   Sat, 15 May 2021 18:53:28 +0800
Message-ID: <1621076039-53986-4-git-send-email-shenyang39@huawei.com>
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

 drivers/net/ethernet/atheros/atl1e/atl1e_main.c:367: warning: expecting prototype for atl1e_set_mac(). Prototype was for atl1e_set_mac_addr() instead
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c:796: warning: expecting prototype for atl1e_setup_mem_resources(). Prototype was for atl1e_setup_ring_resources() instead

Cc: Chris Snook <chris.snook@gmail.com>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
---
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index ff9f96d..2eb0a2a 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -357,7 +357,7 @@ static void atl1e_restore_vlan(struct atl1e_adapter *adapter)
 }
 
 /**
- * atl1e_set_mac - Change the Ethernet Address of the NIC
+ * atl1e_set_mac_addr - Change the Ethernet Address of the NIC
  * @netdev: network interface device structure
  * @p: pointer to an address structure
  *
@@ -787,7 +787,7 @@ static void atl1e_free_ring_resources(struct atl1e_adapter *adapter)
 }
 
 /**
- * atl1e_setup_mem_resources - allocate Tx / RX descriptor resources
+ * atl1e_setup_ring_resources - allocate Tx / RX descriptor resources
  * @adapter: board private structure
  *
  * Return 0 on success, negative on failure
-- 
2.7.4

