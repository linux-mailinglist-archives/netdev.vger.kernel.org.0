Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCA753817CD
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 12:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbhEOK4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 06:56:04 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2604 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbhEOKzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 06:55:45 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fj2Jh36W2zsR63;
        Sat, 15 May 2021 18:51:48 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Sat, 15 May 2021 18:54:24 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Raju Rangoju <rajur@chelsio.com>
Subject: [PATCH 10/34] net: chelsio: cxgb4: Fix wrong function name in comments
Date:   Sat, 15 May 2021 18:53:35 +0800
Message-ID: <1621076039-53986-11-git-send-email-shenyang39@huawei.com>
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

 drivers/net/ethernet/chelsio/cxgb3/sge.c:677: warning: expecting prototype for free_qset(). Prototype was for t3_free_qset() instead
 drivers/net/ethernet/chelsio/cxgb3/sge.c:1266: warning: expecting prototype for eth_xmit(). Prototype was for t3_eth_xmit() instead

Cc: Raju Rangoju <rajur@chelsio.com>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c | 2 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c     | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c
index 70dbee8..5bf117d 100644
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
index 9428ef1..ae3ad99 100644
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
2.7.4

