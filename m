Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEECF2A5060
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729774AbgKCTsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:48:19 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:9535 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729763AbgKCTsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 14:48:17 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa1b4040000>; Tue, 03 Nov 2020 11:48:20 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 3 Nov
 2020 19:48:16 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Saeed Mahameed" <saeedm@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [net-next 11/12] net/mlx5: Cleanup kernel-doc warnings
Date:   Tue, 3 Nov 2020 11:47:37 -0800
Message-ID: <20201103194738.64061-12-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103194738.64061-1-saeedm@nvidia.com>
References: <20201103194738.64061-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604432900; bh=rgDi8dHholG3cnQHfzhODsW0MLg0HUjZtTw4IEypu3A=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=pqfyLOgKO0rNpdFyC3XzUmhCPND5u85P+xZtP9khJZ32N0fEbs0PSdNj9EVj2eHyn
         KI8we3RkIvswueiyiFK2HNIPOy4QAQ8WhySkE1tC6os0Tqj3E+9GiShakG5agvmxRs
         xtoVTVW9gNkrZRqO9FXKy7vbcIal20XjWExXn/rFrVszE6tUkYFcoYS91KgOvEtuF6
         qZp1czqZ3/ydRF/jJB7el0SIbmZwU3+F+C7Y90FgiMcFGtDayWfKM+h+cyOcRwHZIr
         qSw4//hpKIYSmfFsHC1jJjWhF2P/ELGDPBQN5iPilSb/2mJSitpew4IyoPJGicVjIr
         i1Wx187PTVfPQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

$ git ls-files *.[ch] | egrep drivers/net/ethernet/mellanox/ | \
        xargs scripts/kernel-doc -none

drivers/net/ethernet/mellanox/mlx5/core/fpga/sdk.h:57:
warning: Enum value 'MLX5_FPGA_ACCESS_TYPE_I2C' not described ...
drivers/net/ethernet/mellanox/mlx5/core/fpga/sdk.h:57:
warning: Enum value 'MLX5_FPGA_ACCESS_TYPE_DONTCARE' not described ...
drivers/net/ethernet/mellanox/mlx5/core/fpga/sdk.h:118:
warning: Function parameter or member 'cb_arg' not described ...
drivers/net/ethernet/mellanox/mlx5/core/fpga/sdk.h:160:
warning: Function parameter or member 'conn' not described ...
drivers/net/ethernet/mellanox/mlx5/core/fpga/sdk.h:160:
warning: Excess function parameter 'fdev' description ...

Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reported-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fpga/sdk.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/sdk.h b/drivers/n=
et/ethernet/mellanox/mlx5/core/fpga/sdk.h
index 656f96be6e20..89ef592656c8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/sdk.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/sdk.h
@@ -47,11 +47,12 @@
 /**
  * enum mlx5_fpga_access_type - Enumerated the different methods possible =
for
  * accessing the device memory address space
+ *
+ * @MLX5_FPGA_ACCESS_TYPE_I2C: Use the slow CX-FPGA I2C bus
+ * @MLX5_FPGA_ACCESS_TYPE_DONTCARE: Use the fastest available method
  */
 enum mlx5_fpga_access_type {
-	/** Use the slow CX-FPGA I2C bus */
 	MLX5_FPGA_ACCESS_TYPE_I2C =3D 0x0,
-	/** Use the fastest available method */
 	MLX5_FPGA_ACCESS_TYPE_DONTCARE =3D 0x0,
 };
=20
@@ -113,6 +114,7 @@ struct mlx5_fpga_conn_attr {
 	 * subsequent receives.
 	 */
 	void (*recv_cb)(void *cb_arg, struct mlx5_fpga_dma_buf *buf);
+	/** @cb_arg: A context to be passed to recv_cb callback */
 	void *cb_arg;
 };
=20
@@ -145,7 +147,7 @@ void mlx5_fpga_sbu_conn_destroy(struct mlx5_fpga_conn *=
conn);
=20
 /**
  * mlx5_fpga_sbu_conn_sendmsg() - Queue the transmission of a packet
- * @fdev: An FPGA SBU connection
+ * @conn: An FPGA SBU connection
  * @buf: The packet buffer
  *
  * Queues a packet for transmission over an FPGA SBU connection.
--=20
2.26.2

