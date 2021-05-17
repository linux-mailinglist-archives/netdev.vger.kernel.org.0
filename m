Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 284CD38261A
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 10:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235638AbhEQIBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 04:01:01 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3712 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235507AbhEQIAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 04:00:13 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FkBK72NKFz16QfF;
        Mon, 17 May 2021 15:56:11 +0800 (CST)
Received: from dggema704-chm.china.huawei.com (10.3.20.68) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 17 May 2021 15:58:55 +0800
Received: from localhost.localdomain (10.67.165.2) by
 dggema704-chm.china.huawei.com (10.3.20.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 17 May 2021 15:58:55 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Shahed Shaikh <shshaikh@marvell.com>,
        Manish Chopra <manishc@marvell.com>
Subject: [PATCH v2 18/24] net: calxeda: Fix wrong function name in comments
Date:   Mon, 17 May 2021 12:45:29 +0800
Message-ID: <20210517044535.21473-19-shenyang39@huawei.com>
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
index d2c190732d3e..0a2f34fc8b24 100644
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
index c4297aea7d15..711609503ba6 100644
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
2.17.1

