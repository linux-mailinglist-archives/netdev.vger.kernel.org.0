Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 848313817DA
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 12:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235066AbhEOK4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 06:56:41 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3543 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232289AbhEOKzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 06:55:48 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fj2Jh3bxyzsR8d;
        Sat, 15 May 2021 18:51:48 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Sat, 15 May 2021 18:54:21 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Chris Snook <chris.snook@gmail.com>
Subject: [PATCH 02/34] net: atheros: atl1c: Fix wrong function name in comments
Date:   Sat, 15 May 2021 18:53:27 +0800
Message-ID: <1621076039-53986-3-git-send-email-shenyang39@huawei.com>
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

 drivers/net/ethernet/atheros/atl1c/atl1c_main.c:442: warning: expecting prototype for atl1c_set_mac(). Prototype was for atl1c_set_mac_addr() instead
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c:969: warning: expecting prototype for atl1c_setup_mem_resources(). Prototype was for atl1c_setup_ring_resources() instead
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c:1375: warning: expecting prototype for atl1c_configure(). Prototype was for atl1c_configure_mac() instead

Cc: Chris Snook <chris.snook@gmail.com>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 740127a..77da1c5 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -432,7 +432,7 @@ static void atl1c_restore_vlan(struct atl1c_adapter *adapter)
 }
 
 /**
- * atl1c_set_mac - Change the Ethernet Address of the NIC
+ * atl1c_set_mac_addr - Change the Ethernet Address of the NIC
  * @netdev: network interface device structure
  * @p: pointer to an address structure
  *
@@ -960,7 +960,7 @@ static void atl1c_free_ring_resources(struct atl1c_adapter *adapter)
 }
 
 /**
- * atl1c_setup_mem_resources - allocate Tx / RX descriptor resources
+ * atl1c_setup_ring_resources - allocate Tx / RX descriptor resources
  * @adapter: board private structure
  *
  * Return 0 on success, negative on failure
@@ -1366,7 +1366,7 @@ static void atl1c_set_aspm(struct atl1c_hw *hw, u16 link_speed)
 }
 
 /**
- * atl1c_configure - Configure Transmit&Receive Unit after Reset
+ * atl1c_configure_mac - Configure Transmit&Receive Unit after Reset
  * @adapter: board private structure
  *
  * Configure the Tx /Rx unit of the MAC after a reset.
-- 
2.7.4

