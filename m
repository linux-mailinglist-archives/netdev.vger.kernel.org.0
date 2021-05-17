Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB403825F2
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 09:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235488AbhEQIAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 04:00:12 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2988 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232919AbhEQIAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 04:00:11 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FkBJF1tJCzQpWB;
        Mon, 17 May 2021 15:55:25 +0800 (CST)
Received: from dggema704-chm.china.huawei.com (10.3.20.68) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 17 May 2021 15:58:53 +0800
Received: from localhost.localdomain (10.67.165.2) by
 dggema704-chm.china.huawei.com (10.3.20.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 17 May 2021 15:58:52 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Chris Snook <chris.snook@gmail.com>
Subject: [PATCH v2 03/24] net: atheros: atl1e: Fix wrong function name in comments
Date:   Mon, 17 May 2021 12:45:14 +0800
Message-ID: <20210517044535.21473-4-shenyang39@huawei.com>
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

 drivers/net/ethernet/atheros/atl1e/atl1e_main.c:367: warning: expecting prototype for atl1e_set_mac(). Prototype was for atl1e_set_mac_addr() instead
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c:796: warning: expecting prototype for atl1e_setup_mem_resources(). Prototype was for atl1e_setup_ring_resources() instead

Cc: Chris Snook <chris.snook@gmail.com>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index ff9f96de74b8..2eb0a2ab69f6 100644
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
2.17.1

