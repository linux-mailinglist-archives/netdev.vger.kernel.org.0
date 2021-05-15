Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA77C3817FC
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 12:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235301AbhEOK6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 06:58:23 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3541 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233163AbhEOKz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 06:55:56 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fj2Jn6nrVzsRJX;
        Sat, 15 May 2021 18:51:53 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Sat, 15 May 2021 18:54:26 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Shahed Shaikh <shshaikh@marvell.com>,
        Manish Chopra <manishc@marvell.com>
Subject: [PATCH 18/34] net: calxeda: Fix wrong function name in comments
Date:   Sat, 15 May 2021 18:53:43 +0800
Message-ID: <1621076039-53986-19-git-send-email-shenyang39@huawei.com>
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

 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c:761: warning: expecting prototype for qlcnic_83xx_idc_cold_state(). Prototype was for qlcnic_83xx_idc_cold_state_handler() instead
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_vnic.c:192: warning: expecting prototype for qlcnic_83xx_vnic_opmode(). Prototype was for qlcnic_83xx_config_vnic_opmode() instead

Cc: Shahed Shaikh <shshaikh@marvell.com>
Cc: Manish Chopra <manishc@marvell.com>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c | 2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_vnic.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
index d2c1907..0a2f34f 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
@@ -746,7 +746,7 @@ static int qlcnic_83xx_idc_unknown_state(struct qlcnic_adapter *adapter)
 }
 
 /**
- * qlcnic_83xx_idc_cold_state
+ * qlcnic_83xx_idc_cold_state_handler
  *
  * @adapter: adapter structure
  *
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_vnic.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_vnic.c
index c4297ae..7116095 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_vnic.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_vnic.c
@@ -180,7 +180,7 @@ static int qlcnic_83xx_init_non_privileged_vnic(struct qlcnic_adapter *adapter)
 }
 
 /**
- * qlcnic_83xx_vnic_opmode
+ * qlcnic_83xx_config_vnic_opmode
  *
  * @adapter: adapter structure
  * Identify virtual NIC operational modes.
-- 
2.7.4

