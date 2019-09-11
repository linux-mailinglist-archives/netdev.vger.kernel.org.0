Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE4E4AFE8C
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 16:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbfIKOSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 10:18:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58307 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfIKOSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 10:18:14 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1i83Rj-00084o-Kb; Wed, 11 Sep 2019 14:18:11 +0000
From:   Colin King <colin.king@canonical.com>
To:     Tariq Toukan <tariqt@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mlx4: fix spelling mistake "veify" -> "verify"
Date:   Wed, 11 Sep 2019 15:18:11 +0100
Message-Id: <20190911141811.8370-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a mlx4_err error message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/mellanox/mlx4/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 07c204bd3fc4..a48a40c1278e 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -2240,7 +2240,7 @@ static int mlx4_validate_optimized_steering(struct mlx4_dev *dev)
 	for (i = 1; i <= dev->caps.num_ports; i++) {
 		if (mlx4_dev_port(dev, i, &port_cap)) {
 			mlx4_err(dev,
-				 "QUERY_DEV_CAP command failed, can't veify DMFS high rate steering.\n");
+				 "QUERY_DEV_CAP command failed, can't verify DMFS high rate steering.\n");
 		} else if ((dev->caps.dmfs_high_steer_mode !=
 			    MLX4_STEERING_DMFS_A0_DEFAULT) &&
 			   (port_cap.dmfs_optimized_state ==
-- 
2.20.1

