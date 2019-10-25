Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB6DE46C2
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 11:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393394AbfJYJKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 05:10:15 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:48262 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391119AbfJYJKO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 05:10:14 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 8E46DF2825DCC22BF7E3;
        Fri, 25 Oct 2019 17:10:12 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Fri, 25 Oct 2019
 17:10:04 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <jiri@mellanox.com>, <idosch@mellanox.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] mlxsw: spectrum_buffers: remove unneeded semicolon
Date:   Fri, 25 Oct 2019 17:09:48 +0800
Message-ID: <20191025090948.13668-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove excess semicolon after closing parenthesis.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
index b9eeae37..5d77cb3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
@@ -1021,12 +1021,12 @@ int mlxsw_sp_sb_pool_set(struct mlxsw_core *mlxsw_core,
 	if (pr->freeze_mode && pr->mode != mode) {
 		NL_SET_ERR_MSG_MOD(extack, "Changing this pool's threshold type is forbidden");
 		return -EINVAL;
-	};
+	}
 
 	if (pr->freeze_size && pr->size != size) {
 		NL_SET_ERR_MSG_MOD(extack, "Changing this pool's size is forbidden");
 		return -EINVAL;
-	};
+	}
 
 	return mlxsw_sp_sb_pr_write(mlxsw_sp, pool_index, mode,
 				    pool_size, false);
-- 
2.7.4


