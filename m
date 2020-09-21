Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3F392724FB
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 15:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbgIUNMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 09:12:54 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13760 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727321AbgIUNKa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 09:10:30 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 89A28D6836BD7941DF21;
        Mon, 21 Sep 2020 21:10:21 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Mon, 21 Sep 2020 21:10:15 +0800
From:   Qinglang Miao <miaoqinglang@huawei.com>
To:     Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Qinglang Miao <miaoqinglang@huawei.com>
Subject: [PATCH -next] mlxsw: spectrum_acl_tcam: simplify the return expression of ishtp_cl_driver_register()
Date:   Mon, 21 Sep 2020 21:10:39 +0800
Message-ID: <20200921131039.92249-1-miaoqinglang@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the return expression.

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
index 5c0204033..5b4313991 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
@@ -289,17 +289,11 @@ static int
 mlxsw_sp_acl_tcam_group_add(struct mlxsw_sp_acl_tcam *tcam,
 			    struct mlxsw_sp_acl_tcam_group *group)
 {
-	int err;
-
 	group->tcam = tcam;
 	mutex_init(&group->lock);
 	INIT_LIST_HEAD(&group->region_list);
 
-	err = mlxsw_sp_acl_tcam_group_id_get(tcam, &group->id);
-	if (err)
-		return err;
-
-	return 0;
+	return mlxsw_sp_acl_tcam_group_id_get(tcam, &group->id);
 }
 
 static void mlxsw_sp_acl_tcam_group_del(struct mlxsw_sp_acl_tcam_group *group)
-- 
2.23.0

