Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7C134B9F3
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 23:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbhC0WeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 18:34:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47647 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbhC0Wdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 18:33:40 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lQHUs-0003fP-QV; Sat, 27 Mar 2021 22:33:34 +0000
From:   Colin King <colin.king@canonical.com>
To:     Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] mlxsw: spectrum_router: remove redundant initialization of variable force
Date:   Sat, 27 Mar 2021 22:33:34 +0000
Message-Id: <20210327223334.24655-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable force is being initialized with a value that is
never read and it is being updated later with a new value. The
initialization is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 6ccaa194733b..ff240e3c29f7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5059,7 +5059,7 @@ mlxsw_sp_nexthop_obj_bucket_adj_update(struct mlxsw_sp *mlxsw_sp,
 {
 	u16 bucket_index = info->nh_res_bucket->bucket_index;
 	struct netlink_ext_ack *extack = info->extack;
-	bool force = info->nh_res_bucket->force;
+	bool force;
 	char ratr_pl_new[MLXSW_REG_RATR_LEN];
 	char ratr_pl[MLXSW_REG_RATR_LEN];
 	u32 adj_index;
-- 
2.30.2

