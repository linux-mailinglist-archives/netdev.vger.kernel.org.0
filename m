Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA74382602
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 10:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235653AbhEQIA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 04:00:26 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2990 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232813AbhEQIAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 04:00:11 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FkBJG3C4XzQpVH;
        Mon, 17 May 2021 15:55:26 +0800 (CST)
Received: from dggema704-chm.china.huawei.com (10.3.20.68) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 17 May 2021 15:58:54 +0800
Received: from localhost.localdomain (10.67.165.2) by
 dggema704-chm.china.huawei.com (10.3.20.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 17 May 2021 15:58:53 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Raju Rangoju <rajur@chelsio.com>
Subject: [PATCH v2 10/24] net: chelsio: cxgb4: Fix wrong function name in comments
Date:   Mon, 17 May 2021 12:45:21 +0800
Message-ID: <20210517044535.21473-11-shenyang39@huawei.com>
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

 drivers/net/ethernet/chelsio/cxgb3/sge.c:677: warning: expecting prototype for free_qset(). Prototype was for t3_free_qset() instead
 drivers/net/ethernet/chelsio/cxgb3/sge.c:1266: warning: expecting prototype for eth_xmit(). Prototype was for t3_eth_xmit() instead

Cc: Raju Rangoju <rajur@chelsio.com>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c | 2 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c     | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c
index 70dbee89118e..5bf117d2179f 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c
@@ -446,7 +446,7 @@ void cxgb4_ptp_init(struct adapter *adapter)
 }
 
 /**
- * cxgb4_ptp_remove - disable PTP device and stop the overflow check
+ * cxgb4_ptp_stop - disable PTP device and stop the overflow check
  * @adapter: board private structure
  *
  * Stop the PTP support.
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 9428ef1f04a8..ae3ad99fbd06 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -6983,7 +6983,7 @@ int t4_fw_bye(struct adapter *adap, unsigned int mbox)
 }
 
 /**
- *	t4_init_cmd - ask FW to initialize the device
+ *	t4_early_init - ask FW to initialize the device
  *	@adap: the adapter
  *	@mbox: mailbox to use for the FW command
  *
@@ -10224,7 +10224,7 @@ int t4_load_cfg(struct adapter *adap, const u8 *cfg_data, unsigned int size)
 }
 
 /**
- *	t4_set_vf_mac - Set MAC address for the specified VF
+ *	t4_set_vf_mac_acl - Set MAC address for the specified VF
  *	@adapter: The adapter
  *	@vf: one of the VFs instantiated by the specified PF
  *	@naddr: the number of MAC addresses
-- 
2.17.1

