Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57A4038260C
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 10:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235751AbhEQIAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 04:00:41 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2991 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235396AbhEQIAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 04:00:12 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FkBJH3CptzQpWP;
        Mon, 17 May 2021 15:55:27 +0800 (CST)
Received: from dggema704-chm.china.huawei.com (10.3.20.68) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 17 May 2021 15:58:55 +0800
Received: from localhost.localdomain (10.67.165.2) by
 dggema704-chm.china.huawei.com (10.3.20.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 17 May 2021 15:58:54 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>, Jon Mason <jdmason@kudzu.us>
Subject: [PATCH v2 16/24] net: neterion: vxge: Fix wrong function name in comments
Date:   Mon, 17 May 2021 12:45:27 +0800
Message-ID: <20210517044535.21473-17-shenyang39@huawei.com>
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
index 5162b938a1ac..38a273c4d593 100644
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
index 87892bd992b1..b113c158d6e3 100644
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
2.17.1

