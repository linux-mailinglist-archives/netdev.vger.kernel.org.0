Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 306853033C5
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731084AbhAZFFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:05:00 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:11441 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728365AbhAYMti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 07:49:38 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DPTcR3HSVzjBx8;
        Mon, 25 Jan 2021 20:26:15 +0800 (CST)
Received: from linux-lmwb.huawei.com (10.175.103.112) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Mon, 25 Jan 2021 20:27:02 +0800
From:   Zou Wei <zou_wei@huawei.com>
To:     <saeedm@nvidia.com>, <leon@kernel.org>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Zou Wei <zou_wei@huawei.com>
Subject: [PATCH -next] net/mlx5: Remove unused including <linux/version.h>
Date:   Mon, 25 Jan 2021 20:38:04 +0800
Message-ID: <1611578284-42974-1-git-send-email-zou_wei@huawei.com>
X-Mailer: git-send-email 2.6.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.103.112]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following versioncheck warning:

drivers/net/ethernet/mellanox/mlx5/core/main.c:53:1: unused including <linux/version.h>

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 5c52021..50999da 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -50,7 +50,6 @@
 #ifdef CONFIG_RFS_ACCEL
 #include <linux/cpu_rmap.h>
 #endif
-#include <linux/version.h>
 #include <net/devlink.h>
 #include "mlx5_core.h"
 #include "lib/eq.h"
-- 
2.6.2

