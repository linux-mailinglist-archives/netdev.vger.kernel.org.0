Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 338CD354F4E
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 11:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244733AbhDFJAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 05:00:07 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15133 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244726AbhDFJAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 05:00:07 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FF1cT0Y2JzpVMc;
        Tue,  6 Apr 2021 16:57:13 +0800 (CST)
Received: from thunder-town.china.huawei.com (10.174.179.202) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Tue, 6 Apr 2021 16:59:47 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH v2 1/1] net/mlx5: Remove duplicated header file inclusion
Date:   Tue, 6 Apr 2021 16:58:54 +0800
Message-ID: <20210406085854.2424-2-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
In-Reply-To: <20210406085854.2424-1-thunder.leizhen@huawei.com>
References: <20210406085854.2424-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.179.202]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete one of the header files "esw/indir_table.h" that are included
twice, all included header files are then rearranged alphabetically.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 8694b83968b4c4f..e8307f5eae4cb6a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -33,21 +33,20 @@
 #include <linux/etherdevice.h>
 #include <linux/idr.h>
 #include <linux/mlx5/driver.h>
+#include <linux/mlx5/fs.h>
 #include <linux/mlx5/mlx5_ifc.h>
 #include <linux/mlx5/vport.h>
-#include <linux/mlx5/fs.h>
-#include "mlx5_core.h"
-#include "eswitch.h"
-#include "esw/indir_table.h"
+#include "en.h"
+#include "en_tc.h"
 #include "esw/acl/ofld.h"
 #include "esw/indir_table.h"
-#include "rdma.h"
-#include "en.h"
+#include "eswitch.h"
 #include "fs_core.h"
 #include "lib/devcom.h"
 #include "lib/eq.h"
 #include "lib/fs_chains.h"
-#include "en_tc.h"
+#include "mlx5_core.h"
+#include "rdma.h"
 
 /* There are two match-all miss flows, one for unicast dst mac and
  * one for multicast.
-- 
1.8.3


