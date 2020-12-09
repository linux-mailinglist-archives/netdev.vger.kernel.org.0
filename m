Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 297182D3BA9
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 07:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728248AbgLIGuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 01:50:54 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9135 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728238AbgLIGuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 01:50:54 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CrSMg5lRGz15ZbZ;
        Wed,  9 Dec 2020 14:49:35 +0800 (CST)
Received: from linux-lmwb.huawei.com (10.175.103.112) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Wed, 9 Dec 2020 14:50:01 +0800
From:   Zou Wei <zou_wei@huawei.com>
To:     <saeedm@nvidia.com>, <leon@kernel.org>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Zou Wei <zou_wei@huawei.com>
Subject: [PATCH -next v2] net/mlx5_core: remove unused including <generated/utsrelease.h>
Date:   Wed, 9 Dec 2020 15:01:32 +0800
Message-ID: <1607497292-121156-1-git-send-email-zou_wei@huawei.com>
X-Mailer: git-send-email 2.6.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.103.112]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove including <generated/utsrelease.h> that don't need it.

Fixes: 17a7612b99e6 ("net/mlx5_core: Clean driver version and name")
Signed-off-by: Zou Wei <zou_wei@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 989c70c..82ecc161 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -30,7 +30,6 @@
  * SOFTWARE.
  */
 
-#include <generated/utsrelease.h>
 #include <linux/mlx5/fs.h>
 #include <net/switchdev.h>
 #include <net/pkt_cls.h>
-- 
2.6.2

