Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB18E3817EF
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 12:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235247AbhEOK5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 06:57:51 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3550 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233048AbhEOKzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 06:55:55 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fj2Jn66XPzsRHn;
        Sat, 15 May 2021 18:51:53 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Sat, 15 May 2021 18:54:25 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>, Jon Mason <jdmason@kudzu.us>
Subject: [PATCH 16/34] net: neterion: vxge: Fix wrong function name in comments
Date:   Sat, 15 May 2021 18:53:41 +0800
Message-ID: <1621076039-53986-17-git-send-email-shenyang39@huawei.com>
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

 drivers/net/ethernet/neterion/vxge/vxge-config.c:4895: warning: expecting prototype for vxge_hw_vpath_rx_doorbell_post(). Prototype was for vxge_hw_vpath_rx_doorbell_init() instead
 drivers/net/ethernet/neterion/vxge/vxge-main.c:1814: warning: expecting prototype for vxge_poll(). Prototype was for vxge_poll_msix() instead
 drivers/net/ethernet/neterion/vxge/vxge-main.c:4761: warning: expecting prototype for vxge_rem_nic(). Prototype was for vxge_remove() instead

Cc: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
---
 drivers/net/ethernet/neterion/vxge/vxge-config.c | 2 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.c   | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-config.c b/drivers/net/ethernet/neterion/vxge/vxge-config.c
index 5162b93..38a273c 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-config.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-config.c
@@ -4884,7 +4884,7 @@ vxge_hw_vpath_open(struct __vxge_hw_device *hldev,
 }
 
 /**
- * vxge_hw_vpath_rx_doorbell_post - Close the handle got from previous vpath
+ * vxge_hw_vpath_rx_doorbell_init - Close the handle got from previous vpath
  * (vpath) open
  * @vp: Handle got from previous vpath open
  *
diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index 87892bd..b113c15 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -1799,7 +1799,7 @@ static void vxge_reset(struct work_struct *work)
 }
 
 /**
- * vxge_poll - Receive handler when Receive Polling is used.
+ * vxge_poll_msix - Receive handler when Receive Polling is used.
  * @napi: pointer to the napi structure.
  * @budget: Number of packets budgeted to be processed in this iteration.
  *
@@ -4752,7 +4752,7 @@ vxge_probe(struct pci_dev *pdev, const struct pci_device_id *pre)
 }
 
 /**
- * vxge_rem_nic - Free the PCI device
+ * vxge_remove - Free the PCI device
  * @pdev: structure containing the PCI related information of the device.
  * Description: This function is called by the Pci subsystem to release a
  * PCI device and free up all resource held up by the device.
-- 
2.7.4

