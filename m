Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15D14A926B
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731819AbfIDTiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 15:38:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37453 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730197AbfIDTip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 15:38:45 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1i5b73-0003Lx-OF; Wed, 04 Sep 2019 19:38:41 +0000
From:   Colin King <colin.king@canonical.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net/mlx5: fix spelling mistake "offlaods" -> "offloads"
Date:   Wed,  4 Sep 2019 20:38:41 +0100
Message-Id: <20190904193841.20138-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a NL_SET_ERR_MSG_MOD error message.
Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 7bf7b6fbc776..381925c90d94 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -133,7 +133,7 @@ static int mlx5_devlink_fs_mode_validate(struct devlink *devlink, u32 id,
 
 		else if (eswitch_mode == MLX5_ESWITCH_OFFLOADS) {
 			NL_SET_ERR_MSG_MOD(extack,
-					   "Software managed steering is not supported when eswitch offlaods enabled.");
+					   "Software managed steering is not supported when eswitch offloads enabled.");
 			err = -EOPNOTSUPP;
 		}
 	} else {
-- 
2.20.1

