Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64F1D15D97F
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 15:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387430AbgBNOac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 09:30:32 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:38455 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729347AbgBNOab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 09:30:31 -0500
Received: from localhost (lfbn-lyo-1-1670-129.w90-65.abo.wanadoo.fr [90.65.102.129])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 82C6D20000A;
        Fri, 14 Feb 2020 14:30:29 +0000 (UTC)
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Boris Pismenny <borisp@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/mlx5: fix spelling mistake "reserverd" -> "reserved"
Date:   Fri, 14 Feb 2020 15:30:01 +0100
Message-Id: <20200214143002.23140-1-alexandre.belloni@bootlin.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The reserved member should be named reserved.

Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
---
 include/linux/mlx5/mlx5_ifc_fpga.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc_fpga.h b/include/linux/mlx5/mlx5_ifc_fpga.h
index 37e065a80a43..07d77323f78a 100644
--- a/include/linux/mlx5/mlx5_ifc_fpga.h
+++ b/include/linux/mlx5/mlx5_ifc_fpga.h
@@ -608,7 +608,7 @@ struct mlx5_ifc_tls_cmd_bits {
 struct mlx5_ifc_tls_resp_bits {
 	u8         syndrome[0x20];
 	u8         stream_id[0x20];
-	u8         reserverd[0x40];
+	u8         reserved[0x40];
 };
 
 #define MLX5_TLS_COMMAND_SIZE (0x100)
-- 
2.24.1

