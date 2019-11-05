Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCD80F0059
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 15:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388976AbfKEOyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 09:54:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49716 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728180AbfKEOyV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 09:54:21 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iS0Do-0002VU-Gw; Tue, 05 Nov 2019 14:54:16 +0000
From:   Colin King <colin.king@canonical.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net/mlx5: fix spelling mistake "metdata" -> "metadata"
Date:   Tue,  5 Nov 2019 14:54:16 +0000
Message-Id: <20191105145416.60451-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a esw_warn warning message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index bd9fd59d8233..1c3fdee87588 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1877,7 +1877,7 @@ static int esw_vport_create_ingress_acl_group(struct mlx5_eswitch *esw,
 	if (IS_ERR(g)) {
 		ret = PTR_ERR(g);
 		esw_warn(esw->dev,
-			 "Failed to create vport[%d] ingress metdata group, err(%d)\n",
+			 "Failed to create vport[%d] ingress metadata group, err(%d)\n",
 			 vport->vport, ret);
 		goto grp_err;
 	}
-- 
2.20.1

