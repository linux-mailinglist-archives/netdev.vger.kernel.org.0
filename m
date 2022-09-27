Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEB225ECE4E
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 22:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233090AbiI0UUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 16:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232548AbiI0UTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 16:19:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A606258;
        Tue, 27 Sep 2022 13:19:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01D8961B44;
        Tue, 27 Sep 2022 20:19:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A5CC433D6;
        Tue, 27 Sep 2022 20:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664309961;
        bh=A7eF1j+biTdRgqRNX0qGKa2bjf0b8UCd7cgzLt0/tZg=;
        h=From:To:Cc:Subject:Date:From;
        b=PIO4ObVXG+BVmDs6QjVJy+998hZXEI+pZ+oIlHlZhn2AjmaWX1L1Z6vf8LtyYEouL
         BtNIUHcSxj4q806B5Cn+ZZo0v8m9lITdSDi/ixyRKCmnnYsDfMb/YymqzO8IUXrR76
         FSZUFxAze3/42ispxRtm+Iuhd63M4tQWV6gLPYHOwjmPK3gM9Ay4FNNycFNIA2+UnT
         pSDmpDwj9cw7WrPoPCa/J+FuOPZIG6kx2MWcNRN2jlT9PHSMEgKvh2qvYNyLBkWxdi
         14MbstUeMnyz0hAFASYwb7T8Oz6RqFxoCoC6eNdMWCqG1EQ0ZUrzbDj3kQydIu/nIX
         VW+pxPogkWpjA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, linux-rdma@vger.kernel.org,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org
Subject: [GIT PULL][V2] updates from mlx5-next 2022-09-24
Date:   Tue, 27 Sep 2022 13:19:06 -0700
Message-Id: <20220927201906.234015-1-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Please pull mlx5-next branch

v1->v2: 
  - tossed already applied rdma commit.

Updates form mlx5-next including[1]:

1) HW definitions and support for NPPS clock settings.

2) various cleanups

3) Enable hash mode by default for all NICs

4) page tracker and advanced virtualization HW definitions for vfio

[1] https://lore.kernel.org/netdev/20220907233636.388475-1-saeed@kernel.org/

Note: This PR will introduce a minor contextual conflict with net-next, to
resolve, accept changes from both trees.


The following changes since commit 7e18e42e4b280c85b76967a9106a13ca61c16179:

  Linux 6.0-rc4 (2022-09-04 13:10:01 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git mlx5-next

for you to fetch changes up to 9175d8103780084e70bc89f2040ea62dc30f6f60:

  net/mlx5: Remove from FPGA IFC file not-needed definitions (2022-09-27 12:50:27 -0700)

----------------------------------------------------------------
Aya Levin (2):
      net/mlx5: Expose NPPS related registers
      net/mlx5: Add support for NPPS with real time mode

Chris Mi (1):
      RDMA/mlx5: Move function mlx5_core_query_ib_ppcnt() to mlx5_ib

Gal Pressman (2):
      net/mlx5: Remove unused functions
      net/mlx5: Remove unused structs

Leon Romanovsky (2):
      Merge branch 'mlx5-vfio' into mlx5-next
      net/mlx5: Remove from FPGA IFC file not-needed definitions

Liu, Changcheng (5):
      net/mlx5: add IFC bits for bypassing port select flow table
      RDMA/mlx5: Don't set tx affinity when lag is in hash mode
      net/mlx5: Lag, set active ports if support bypass port select flow table
      net/mlx5: Lag, enable hash mode by default for all NICs
      net/mlx5: detect and enable bypass port select flow table

Yishai Hadas (2):
      net/mlx5: Introduce ifc bits for page tracker
      net/mlx5: Query ADV_VIRTUALIZATION capabilities

 drivers/infiniband/hw/mlx5/mad.c                   |  25 +++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |  12 ++
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h       |   5 -
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |   7 --
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |  91 ++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    | 139 ++++++++++++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  35 ++++++
 drivers/net/ethernet/mellanox/mlx5/core/port.c     |  23 ----
 .../mellanox/mlx5/core/steering/dr_types.h         |  14 ---
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.h   |   4 -
 include/linux/mlx5/device.h                        |  20 ++-
 include/linux/mlx5/driver.h                        |  11 +-
 include/linux/mlx5/fs_helpers.h                    |  48 -------
 include/linux/mlx5/mlx5_ifc.h                      | 126 +++++++++++++++++--
 include/linux/mlx5/mlx5_ifc_fpga.h                 |  24 ----
 16 files changed, 406 insertions(+), 184 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mad.c b/drivers/infiniband/hw/mlx5/mad.c
index 293ed709e5ed..d834ec13b1b3 100644
--- a/drivers/infiniband/hw/mlx5/mad.c
+++ b/drivers/infiniband/hw/mlx5/mad.c
@@ -147,6 +147,28 @@ static void pma_cnt_assign(struct ib_pma_portcounters *pma_cnt,
 			     vl_15_dropped);
 }
 
+static int query_ib_ppcnt(struct mlx5_core_dev *dev, u8 port_num, void *out,
+			  size_t sz)
+{
+	u32 *in;
+	int err;
+
+	in  = kvzalloc(sz, GFP_KERNEL);
+	if (!in) {
+		err = -ENOMEM;
+		return err;
+	}
+
+	MLX5_SET(ppcnt_reg, in, local_port, port_num);
+
+	MLX5_SET(ppcnt_reg, in, grp, MLX5_INFINIBAND_PORT_COUNTERS_GROUP);
+	err = mlx5_core_access_reg(dev, in, sz, out,
+				   sz, MLX5_REG_PPCNT, 0, 0);
+
+	kvfree(in);
+	return err;
+}
+
 static int process_pma_cmd(struct mlx5_ib_dev *dev, u32 port_num,
 			   const struct ib_mad *in_mad, struct ib_mad *out_mad)
 {
@@ -202,8 +224,7 @@ static int process_pma_cmd(struct mlx5_ib_dev *dev, u32 port_num,
 			goto done;
 		}
 
-		err = mlx5_core_query_ib_ppcnt(mdev, mdev_port_num,
-					       out_cnt, sz);
+		err = query_ib_ppcnt(mdev, mdev_port_num, out_cnt, sz);
 		if (!err)
 			pma_cnt_assign(pma_cnt, out_cnt);
 	}
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 2e2ad3918385..c3e014283c41 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1540,6 +1540,18 @@ int mlx5_ib_test_wc(struct mlx5_ib_dev *dev);
 
 static inline bool mlx5_ib_lag_should_assign_affinity(struct mlx5_ib_dev *dev)
 {
+	/*
+	 * If the driver is in hash mode and the port_select_flow_table_bypass cap
+	 * is supported, it means that the driver no longer needs to assign the port
+	 * affinity by default. If a user wants to set the port affinity explicitly,
+	 * the user has a dedicated API to do that, so there is no need to assign
+	 * the port affinity by default.
+	 */
+	if (dev->lag_active &&
+	    mlx5_lag_mode_is_hash(dev->mdev) &&
+	    MLX5_CAP_PORT_SELECTION(dev->mdev, port_select_flow_table_bypass))
+		return 0;
+
 	return dev->lag_active ||
 		(MLX5_CAP_GEN(dev->mdev, num_lag_ports) > 1 &&
 		 MLX5_CAP_GEN(dev->mdev, lag_tx_port_affinity));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
index 0ae4e12ce528..efc43d25ef08 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
@@ -77,11 +77,6 @@ static inline bool mlx5_ipsec_is_rx_flow(struct mlx5_cqe64 *cqe)
 	return MLX5_IPSEC_METADATA_MARKER(be32_to_cpu(cqe->ft_metadata));
 }
 
-static inline bool mlx5e_ipsec_is_tx_flow(struct mlx5e_accel_tx_ipsec_state *ipsec_st)
-{
-	return ipsec_st->x;
-}
-
 static inline bool mlx5e_ipsec_eseg_meta(struct mlx5_wqe_eth_seg *eseg)
 {
 	return eseg->flow_table_metadata & cpu_to_be32(MLX5_ETH_WQE_FT_META_IPSEC);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
index 079fa44ada71..483a51870505 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -273,6 +273,12 @@ int mlx5_query_hca_caps(struct mlx5_core_dev *dev)
 			return err;
 	}
 
+	if (MLX5_CAP_GEN(dev, adv_virtualization)) {
+		err = mlx5_core_get_caps(dev, MLX5_CAP_ADV_VIRTUALIZATION);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index 2cf2c9948446..b7ef891836f0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -875,13 +875,6 @@ void mlx5_drain_health_wq(struct mlx5_core_dev *dev)
 	cancel_work_sync(&health->fatal_report_work);
 }
 
-void mlx5_health_flush(struct mlx5_core_dev *dev)
-{
-	struct mlx5_core_health *health = &dev->priv.health;
-
-	flush_workqueue(health->wq);
-}
-
 void mlx5_health_cleanup(struct mlx5_core_dev *dev)
 {
 	struct mlx5_core_health *health = &dev->priv.health;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 065102278cb8..a9f4ede4a9bf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -65,6 +65,21 @@ static int get_port_sel_mode(enum mlx5_lag_mode mode, unsigned long flags)
 	return MLX5_LAG_PORT_SELECT_MODE_QUEUE_AFFINITY;
 }
 
+static u8 lag_active_port_bits(struct mlx5_lag *ldev)
+{
+	u8 enabled_ports[MLX5_MAX_PORTS] = {};
+	u8 active_port = 0;
+	int num_enabled;
+	int idx;
+
+	mlx5_infer_tx_enabled(&ldev->tracker, ldev->ports, enabled_ports,
+			      &num_enabled);
+	for (idx = 0; idx < num_enabled; idx++)
+		active_port |= BIT_MASK(enabled_ports[idx]);
+
+	return active_port;
+}
+
 static int mlx5_cmd_create_lag(struct mlx5_core_dev *dev, u8 *ports, int mode,
 			       unsigned long flags)
 {
@@ -77,9 +92,21 @@ static int mlx5_cmd_create_lag(struct mlx5_core_dev *dev, u8 *ports, int mode,
 	lag_ctx = MLX5_ADDR_OF(create_lag_in, in, ctx);
 	MLX5_SET(create_lag_in, in, opcode, MLX5_CMD_OP_CREATE_LAG);
 	MLX5_SET(lagc, lag_ctx, fdb_selection_mode, fdb_sel_mode);
-	if (port_sel_mode == MLX5_LAG_PORT_SELECT_MODE_QUEUE_AFFINITY) {
+
+	switch (port_sel_mode) {
+	case MLX5_LAG_PORT_SELECT_MODE_QUEUE_AFFINITY:
 		MLX5_SET(lagc, lag_ctx, tx_remap_affinity_1, ports[0]);
 		MLX5_SET(lagc, lag_ctx, tx_remap_affinity_2, ports[1]);
+		break;
+	case MLX5_LAG_PORT_SELECT_MODE_PORT_SELECT_FT:
+		if (!MLX5_CAP_PORT_SELECTION(dev, port_select_flow_table_bypass))
+			break;
+
+		MLX5_SET(lagc, lag_ctx, active_port,
+			 lag_active_port_bits(mlx5_lag_dev(dev)));
+		break;
+	default:
+		break;
 	}
 	MLX5_SET(lagc, lag_ctx, port_select_mode, port_sel_mode);
 
@@ -386,12 +413,37 @@ static void mlx5_lag_drop_rule_setup(struct mlx5_lag *ldev,
 	}
 }
 
+static int mlx5_cmd_modify_active_port(struct mlx5_core_dev *dev, u8 ports)
+{
+	u32 in[MLX5_ST_SZ_DW(modify_lag_in)] = {};
+	void *lag_ctx;
+
+	lag_ctx = MLX5_ADDR_OF(modify_lag_in, in, ctx);
+
+	MLX5_SET(modify_lag_in, in, opcode, MLX5_CMD_OP_MODIFY_LAG);
+	MLX5_SET(modify_lag_in, in, field_select, 0x2);
+
+	MLX5_SET(lagc, lag_ctx, active_port, ports);
+
+	return mlx5_cmd_exec_in(dev, modify_lag, in);
+}
+
 static int _mlx5_modify_lag(struct mlx5_lag *ldev, u8 *ports)
 {
 	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
+	u8 active_ports;
+	int ret;
+
+	if (test_bit(MLX5_LAG_MODE_FLAG_HASH_BASED, &ldev->mode_flags)) {
+		ret = mlx5_lag_port_sel_modify(ldev, ports);
+		if (ret ||
+		    !MLX5_CAP_PORT_SELECTION(dev0, port_select_flow_table_bypass))
+			return ret;
 
-	if (test_bit(MLX5_LAG_MODE_FLAG_HASH_BASED, &ldev->mode_flags))
-		return mlx5_lag_port_sel_modify(ldev, ports);
+		active_ports = lag_active_port_bits(ldev);
+
+		return mlx5_cmd_modify_active_port(dev0, active_ports);
+	}
 	return mlx5_cmd_modify_lag(dev0, ldev->ports, ports);
 }
 
@@ -432,21 +484,22 @@ void mlx5_modify_lag(struct mlx5_lag *ldev,
 		mlx5_lag_drop_rule_setup(ldev, tracker);
 }
 
-#define MLX5_LAG_ROCE_HASH_PORTS_SUPPORTED 4
 static int mlx5_lag_set_port_sel_mode_roce(struct mlx5_lag *ldev,
 					   unsigned long *flags)
 {
-	struct lag_func *dev0 = &ldev->pf[MLX5_LAG_P1];
+	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
 
-	if (ldev->ports == MLX5_LAG_ROCE_HASH_PORTS_SUPPORTED) {
-		/* Four ports are support only in hash mode */
-		if (!MLX5_CAP_PORT_SELECTION(dev0->dev, port_select_flow_table))
-			return -EINVAL;
-		set_bit(MLX5_LAG_MODE_FLAG_HASH_BASED, flags);
+	if (!MLX5_CAP_PORT_SELECTION(dev0, port_select_flow_table)) {
 		if (ldev->ports > 2)
-			ldev->buckets = MLX5_LAG_MAX_HASH_BUCKETS;
+			return -EINVAL;
+		return 0;
 	}
 
+	if (ldev->ports > 2)
+		ldev->buckets = MLX5_LAG_MAX_HASH_BUCKETS;
+
+	set_bit(MLX5_LAG_MODE_FLAG_HASH_BASED, flags);
+
 	return 0;
 }
 
@@ -1275,6 +1328,22 @@ bool mlx5_lag_is_active(struct mlx5_core_dev *dev)
 }
 EXPORT_SYMBOL(mlx5_lag_is_active);
 
+bool mlx5_lag_mode_is_hash(struct mlx5_core_dev *dev)
+{
+	struct mlx5_lag *ldev;
+	unsigned long flags;
+	bool res = 0;
+
+	spin_lock_irqsave(&lag_lock, flags);
+	ldev = mlx5_lag_dev(dev);
+	if (ldev)
+		res = test_bit(MLX5_LAG_MODE_FLAG_HASH_BASED, &ldev->mode_flags);
+	spin_unlock_irqrestore(&lag_lock, flags);
+
+	return res;
+}
+EXPORT_SYMBOL(mlx5_lag_mode_is_hash);
+
 bool mlx5_lag_is_master(struct mlx5_core_dev *dev)
 {
 	struct mlx5_lag *ldev;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index 91e806c1aa21..d3a9ae80fd30 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -65,6 +65,8 @@ enum {
 	MLX5_MTPPS_FS_TIME_STAMP		= BIT(0x4),
 	MLX5_MTPPS_FS_OUT_PULSE_DURATION	= BIT(0x5),
 	MLX5_MTPPS_FS_ENH_OUT_PER_ADJ		= BIT(0x7),
+	MLX5_MTPPS_FS_NPPS_PERIOD               = BIT(0x9),
+	MLX5_MTPPS_FS_OUT_PULSE_DURATION_NS     = BIT(0xa),
 };
 
 static bool mlx5_real_time_mode(struct mlx5_core_dev *mdev)
@@ -72,6 +74,13 @@ static bool mlx5_real_time_mode(struct mlx5_core_dev *mdev)
 	return (mlx5_is_real_time_rq(mdev) || mlx5_is_real_time_sq(mdev));
 }
 
+static bool mlx5_npps_real_time_supported(struct mlx5_core_dev *mdev)
+{
+	return (mlx5_real_time_mode(mdev) &&
+		MLX5_CAP_MCAM_FEATURE(mdev, npps_period) &&
+		MLX5_CAP_MCAM_FEATURE(mdev, out_pulse_duration_ns));
+}
+
 static bool mlx5_modify_mtutc_allowed(struct mlx5_core_dev *mdev)
 {
 	return MLX5_CAP_MCAM_FEATURE(mdev, ptpcyc2realtime_modify);
@@ -459,9 +468,95 @@ static u64 perout_conf_internal_timer(struct mlx5_core_dev *mdev, s64 sec)
 	return find_target_cycles(mdev, target_ns);
 }
 
-static u64 perout_conf_real_time(s64 sec)
+static u64 perout_conf_real_time(s64 sec, u32 nsec)
+{
+	return (u64)nsec | (u64)sec << 32;
+}
+
+static int perout_conf_1pps(struct mlx5_core_dev *mdev, struct ptp_clock_request *rq,
+			    u64 *time_stamp, bool real_time)
+{
+	struct timespec64 ts;
+	s64 ns;
+
+	ts.tv_nsec = rq->perout.period.nsec;
+	ts.tv_sec = rq->perout.period.sec;
+	ns = timespec64_to_ns(&ts);
+
+	if ((ns >> 1) != 500000000LL)
+		return -EINVAL;
+
+	*time_stamp = real_time ? perout_conf_real_time(rq->perout.start.sec, 0) :
+		      perout_conf_internal_timer(mdev, rq->perout.start.sec);
+
+	return 0;
+}
+
+#define MLX5_MAX_PULSE_DURATION (BIT(__mlx5_bit_sz(mtpps_reg, out_pulse_duration_ns)) - 1)
+static int mlx5_perout_conf_out_pulse_duration(struct mlx5_core_dev *mdev,
+					       struct ptp_clock_request *rq,
+					       u32 *out_pulse_duration_ns)
 {
-	return (u64)sec << 32;
+	struct mlx5_pps *pps_info = &mdev->clock.pps_info;
+	u32 out_pulse_duration;
+	struct timespec64 ts;
+
+	if (rq->perout.flags & PTP_PEROUT_DUTY_CYCLE) {
+		ts.tv_sec = rq->perout.on.sec;
+		ts.tv_nsec = rq->perout.on.nsec;
+		out_pulse_duration = (u32)timespec64_to_ns(&ts);
+	} else {
+		/* out_pulse_duration_ns should be up to 50% of the
+		 * pulse period as default
+		 */
+		ts.tv_sec = rq->perout.period.sec;
+		ts.tv_nsec = rq->perout.period.nsec;
+		out_pulse_duration = (u32)timespec64_to_ns(&ts) >> 1;
+	}
+
+	if (out_pulse_duration < pps_info->min_out_pulse_duration_ns ||
+	    out_pulse_duration > MLX5_MAX_PULSE_DURATION) {
+		mlx5_core_err(mdev, "NPPS pulse duration %u is not in [%llu, %lu]\n",
+			      out_pulse_duration, pps_info->min_out_pulse_duration_ns,
+			      MLX5_MAX_PULSE_DURATION);
+		return -EINVAL;
+	}
+	*out_pulse_duration_ns = out_pulse_duration;
+
+	return 0;
+}
+
+static int perout_conf_npps_real_time(struct mlx5_core_dev *mdev, struct ptp_clock_request *rq,
+				      u32 *field_select, u32 *out_pulse_duration_ns,
+				      u64 *period, u64 *time_stamp)
+{
+	struct mlx5_pps *pps_info = &mdev->clock.pps_info;
+	struct ptp_clock_time *time = &rq->perout.start;
+	struct timespec64 ts;
+
+	ts.tv_sec = rq->perout.period.sec;
+	ts.tv_nsec = rq->perout.period.nsec;
+	if (timespec64_to_ns(&ts) < pps_info->min_npps_period) {
+		mlx5_core_err(mdev, "NPPS period is lower than minimal npps period %llu\n",
+			      pps_info->min_npps_period);
+		return -EINVAL;
+	}
+	*period = perout_conf_real_time(rq->perout.period.sec, rq->perout.period.nsec);
+
+	if (mlx5_perout_conf_out_pulse_duration(mdev, rq, out_pulse_duration_ns))
+		return -EINVAL;
+
+	*time_stamp = perout_conf_real_time(time->sec, time->nsec);
+	*field_select |= MLX5_MTPPS_FS_NPPS_PERIOD |
+			 MLX5_MTPPS_FS_OUT_PULSE_DURATION_NS;
+
+	return 0;
+}
+
+static bool mlx5_perout_verify_flags(struct mlx5_core_dev *mdev, unsigned int flags)
+{
+	return ((!mlx5_npps_real_time_supported(mdev) && flags) ||
+		(mlx5_npps_real_time_supported(mdev) && flags & ~PTP_PEROUT_DUTY_CYCLE));
 }
 
 static int mlx5_perout_configure(struct ptp_clock_info *ptp,
@@ -474,20 +569,20 @@ static int mlx5_perout_configure(struct ptp_clock_info *ptp,
 			container_of(clock, struct mlx5_core_dev, clock);
 	bool rt_mode = mlx5_real_time_mode(mdev);
 	u32 in[MLX5_ST_SZ_DW(mtpps_reg)] = {0};
-	struct timespec64 ts;
+	u32 out_pulse_duration_ns = 0;
 	u32 field_select = 0;
+	u64 npps_period = 0;
 	u64 time_stamp = 0;
 	u8 pin_mode = 0;
 	u8 pattern = 0;
 	int pin = -1;
 	int err = 0;
-	s64 ns;
 
 	if (!MLX5_PPS_CAP(mdev))
 		return -EOPNOTSUPP;
 
 	/* Reject requests with unsupported flags */
-	if (rq->perout.flags)
+	if (mlx5_perout_verify_flags(mdev, rq->perout.flags))
 		return -EOPNOTSUPP;
 
 	if (rq->perout.index >= clock->ptp_info.n_pins)
@@ -500,29 +595,25 @@ static int mlx5_perout_configure(struct ptp_clock_info *ptp,
 
 	if (on) {
 		bool rt_mode = mlx5_real_time_mode(mdev);
-		s64 sec = rq->perout.start.sec;
-
-		if (rq->perout.start.nsec)
-			return -EINVAL;
 
 		pin_mode = MLX5_PIN_MODE_OUT;
 		pattern = MLX5_OUT_PATTERN_PERIODIC;
-		ts.tv_sec = rq->perout.period.sec;
-		ts.tv_nsec = rq->perout.period.nsec;
-		ns = timespec64_to_ns(&ts);
 
-		if ((ns >> 1) != 500000000LL)
+		if (rt_mode &&  rq->perout.start.sec > U32_MAX)
 			return -EINVAL;
 
-		if (rt_mode && sec > U32_MAX)
-			return -EINVAL;
-
-		time_stamp = rt_mode ? perout_conf_real_time(sec) :
-				       perout_conf_internal_timer(mdev, sec);
-
 		field_select |= MLX5_MTPPS_FS_PIN_MODE |
 				MLX5_MTPPS_FS_PATTERN |
 				MLX5_MTPPS_FS_TIME_STAMP;
+
+		if (mlx5_npps_real_time_supported(mdev))
+			err = perout_conf_npps_real_time(mdev, rq, &field_select,
+							 &out_pulse_duration_ns, &npps_period,
+							 &time_stamp);
+		else
+			err = perout_conf_1pps(mdev, rq, &time_stamp, rt_mode);
+		if (err)
+			return err;
 	}
 
 	MLX5_SET(mtpps_reg, in, pin, pin);
@@ -531,7 +622,8 @@ static int mlx5_perout_configure(struct ptp_clock_info *ptp,
 	MLX5_SET(mtpps_reg, in, enable, on);
 	MLX5_SET64(mtpps_reg, in, time_stamp, time_stamp);
 	MLX5_SET(mtpps_reg, in, field_select, field_select);
-
+	MLX5_SET64(mtpps_reg, in, npps_period, npps_period);
+	MLX5_SET(mtpps_reg, in, out_pulse_duration_ns, out_pulse_duration_ns);
 	err = mlx5_set_mtpps(mdev, in, sizeof(in));
 	if (err)
 		return err;
@@ -687,6 +779,13 @@ static void mlx5_get_pps_caps(struct mlx5_core_dev *mdev)
 	clock->ptp_info.n_per_out = MLX5_GET(mtpps_reg, out,
 					     cap_max_num_of_pps_out_pins);
 
+	if (MLX5_CAP_MCAM_FEATURE(mdev, npps_period))
+		clock->pps_info.min_npps_period = 1 << MLX5_GET(mtpps_reg, out,
+								cap_log_min_npps_period);
+	if (MLX5_CAP_MCAM_FEATURE(mdev, out_pulse_duration_ns))
+		clock->pps_info.min_out_pulse_duration_ns = 1 << MLX5_GET(mtpps_reg, out,
+								cap_log_min_out_pulse_duration_ns);
+
 	clock->pps_info.pin_caps[0] = MLX5_GET(mtpps_reg, out, cap_pin_0_mode);
 	clock->pps_info.pin_caps[1] = MLX5_GET(mtpps_reg, out, cap_pin_1_mode);
 	clock->pps_info.pin_caps[2] = MLX5_GET(mtpps_reg, out, cap_pin_2_mode);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index c085b031abfc..319f5dd11f6d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -652,6 +652,33 @@ static int handle_hca_cap_roce(struct mlx5_core_dev *dev, void *set_ctx)
 	return err;
 }
 
+static int handle_hca_cap_port_selection(struct mlx5_core_dev *dev,
+					 void *set_ctx)
+{
+	void *set_hca_cap;
+	int err;
+
+	if (!MLX5_CAP_GEN(dev, port_selection_cap))
+		return 0;
+
+	err = mlx5_core_get_caps(dev, MLX5_CAP_PORT_SELECTION);
+	if (err)
+		return err;
+
+	if (MLX5_CAP_PORT_SELECTION(dev, port_select_flow_table_bypass) ||
+	    !MLX5_CAP_PORT_SELECTION_MAX(dev, port_select_flow_table_bypass))
+		return 0;
+
+	set_hca_cap = MLX5_ADDR_OF(set_hca_cap_in, set_ctx, capability);
+	memcpy(set_hca_cap, dev->caps.hca[MLX5_CAP_PORT_SELECTION]->cur,
+	       MLX5_ST_SZ_BYTES(port_selection_cap));
+	MLX5_SET(port_selection_cap, set_hca_cap, port_select_flow_table_bypass, 1);
+
+	err = set_caps(dev, set_ctx, MLX5_SET_HCA_CAP_OP_MODE_PORT_SELECTION);
+
+	return err;
+}
+
 static int set_hca_cap(struct mlx5_core_dev *dev)
 {
 	int set_sz = MLX5_ST_SZ_BYTES(set_hca_cap_in);
@@ -696,6 +723,13 @@ static int set_hca_cap(struct mlx5_core_dev *dev)
 		goto out;
 	}
 
+	memset(set_ctx, 0, set_sz);
+	err = handle_hca_cap_port_selection(dev, set_ctx);
+	if (err) {
+		mlx5_core_err(dev, "handle_hca_cap_port_selection failed\n");
+		goto out;
+	}
+
 out:
 	kfree(set_ctx);
 	return err;
@@ -1488,6 +1522,7 @@ static const int types[] = {
 	MLX5_CAP_IPSEC,
 	MLX5_CAP_PORT_SELECTION,
 	MLX5_CAP_DEV_SHAMPO,
+	MLX5_CAP_ADV_VIRTUALIZATION,
 };
 
 static void mlx5_hca_caps_free(struct mlx5_core_dev *dev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/port.c b/drivers/net/ethernet/mellanox/mlx5/core/port.c
index e1bd54574ea5..a1548e6bfb35 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -493,29 +493,6 @@ int mlx5_query_port_vl_hw_cap(struct mlx5_core_dev *dev,
 }
 EXPORT_SYMBOL_GPL(mlx5_query_port_vl_hw_cap);
 
-int mlx5_core_query_ib_ppcnt(struct mlx5_core_dev *dev,
-			     u8 port_num, void *out, size_t sz)
-{
-	u32 *in;
-	int err;
-
-	in  = kvzalloc(sz, GFP_KERNEL);
-	if (!in) {
-		err = -ENOMEM;
-		return err;
-	}
-
-	MLX5_SET(ppcnt_reg, in, local_port, port_num);
-
-	MLX5_SET(ppcnt_reg, in, grp, MLX5_INFINIBAND_PORT_COUNTERS_GROUP);
-	err = mlx5_core_access_reg(dev, in, sz, out,
-				   sz, MLX5_REG_PPCNT, 0, 0);
-
-	kvfree(in);
-	return err;
-}
-EXPORT_SYMBOL_GPL(mlx5_core_query_ib_ppcnt);
-
 static int mlx5_query_pfcc_reg(struct mlx5_core_dev *dev, u32 *out,
 			       u32 out_size)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 062c7c74a1f3..1777a1e508e7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -1294,20 +1294,6 @@ struct mlx5dr_cmd_gid_attr {
 	u32 roce_ver;
 };
 
-struct mlx5dr_cmd_qp_create_attr {
-	u32 page_id;
-	u32 pdn;
-	u32 cqn;
-	u32 pm_state;
-	u32 service_type;
-	u32 buff_umem_id;
-	u32 db_umem_id;
-	u32 sq_wqe_cnt;
-	u32 rq_wqe_cnt;
-	u32 rq_wqe_shift;
-	u8 isolate_vl_tc:1;
-};
-
 int mlx5dr_cmd_query_gid(struct mlx5_core_dev *mdev, u8 vhca_port_num,
 			 u16 index, struct mlx5dr_cmd_gid_attr *attr);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.h
index 1fb185d6ac7f..d168622063d5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.h
@@ -14,10 +14,6 @@ struct mlx5_fs_dr_action {
 	struct mlx5dr_action *dr_action;
 };
 
-struct mlx5_fs_dr_ns {
-	struct mlx5_dr_ns *dr_ns;
-};
-
 struct mlx5_fs_dr_rule {
 	struct mlx5dr_rule    *dr_rule;
 	/* Only actions created by fs_dr */
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index b5f58fd37a0f..753753f3ce12 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -874,12 +874,6 @@ static inline u8 get_cqe_opcode(struct mlx5_cqe64 *cqe)
 	return cqe->op_own >> 4;
 }
 
-static inline u8 get_cqe_enhanced_num_mini_cqes(struct mlx5_cqe64 *cqe)
-{
-	/* num_of_mini_cqes is zero based */
-	return get_cqe_opcode(cqe) + 1;
-}
-
 static inline u8 get_cqe_lro_tcppsh(struct mlx5_cqe64 *cqe)
 {
 	return (cqe->lro.tcppsh_abort_dupack >> 6) & 1;
@@ -890,11 +884,6 @@ static inline u8 get_cqe_l4_hdr_type(struct mlx5_cqe64 *cqe)
 	return (cqe->l4_l3_hdr_type >> 4) & 0x7;
 }
 
-static inline u8 get_cqe_l3_hdr_type(struct mlx5_cqe64 *cqe)
-{
-	return (cqe->l4_l3_hdr_type >> 2) & 0x3;
-}
-
 static inline bool cqe_is_tunneled(struct mlx5_cqe64 *cqe)
 {
 	return cqe->tls_outer_l3_tunneled & 0x1;
@@ -1200,6 +1189,7 @@ enum mlx5_cap_type {
 	MLX5_CAP_DEV_SHAMPO = 0x1d,
 	MLX5_CAP_GENERAL_2 = 0x20,
 	MLX5_CAP_PORT_SELECTION = 0x25,
+	MLX5_CAP_ADV_VIRTUALIZATION = 0x26,
 	/* NUM OF CAP Types */
 	MLX5_CAP_NUM
 };
@@ -1365,6 +1355,14 @@ enum mlx5_qcam_feature_groups {
 	MLX5_GET(port_selection_cap, \
 		 mdev->caps.hca[MLX5_CAP_PORT_SELECTION]->max, cap)
 
+#define MLX5_CAP_ADV_VIRTUALIZATION(mdev, cap) \
+	MLX5_GET(adv_virtualization_cap, \
+		 mdev->caps.hca[MLX5_CAP_ADV_VIRTUALIZATION]->cur, cap)
+
+#define MLX5_CAP_ADV_VIRTUALIZATION_MAX(mdev, cap) \
+	MLX5_GET(adv_virtualization_cap, \
+		 mdev->caps.hca[MLX5_CAP_ADV_VIRTUALIZATION]->max, cap)
+
 #define MLX5_CAP_FLOWTABLE_PORT_SELECTION(mdev, cap) \
 	MLX5_CAP_PORT_SELECTION(mdev, flow_table_properties_port_selection.cap)
 
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 7b7ce602c808..949feb7f889f 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -698,6 +698,8 @@ struct mlx5_pps {
 	struct work_struct         out_work;
 	u64                        start[MAX_PIN_NUM];
 	u8                         enabled;
+	u64                        min_npps_period;
+	u64                        min_out_pulse_duration_ns;
 };
 
 struct mlx5_timer {
@@ -855,11 +857,6 @@ struct mlx5_cmd_work_ent {
 	refcount_t              refcnt;
 };
 
-struct mlx5_pas {
-	u64	pa;
-	u8	log_sz;
-};
-
 enum phy_port_state {
 	MLX5_AAA_111
 };
@@ -1016,7 +1013,6 @@ int mlx5_cmd_exec_polling(struct mlx5_core_dev *dev, void *in, int in_size,
 bool mlx5_cmd_is_down(struct mlx5_core_dev *dev);
 
 int mlx5_core_get_caps(struct mlx5_core_dev *dev, enum mlx5_cap_type cap_type);
-void mlx5_health_flush(struct mlx5_core_dev *dev);
 void mlx5_health_cleanup(struct mlx5_core_dev *dev);
 int mlx5_health_init(struct mlx5_core_dev *dev);
 void mlx5_start_health_poll(struct mlx5_core_dev *dev);
@@ -1085,8 +1081,6 @@ int mlx5_core_destroy_psv(struct mlx5_core_dev *dev, int psv_num);
 void mlx5_core_put_rsc(struct mlx5_core_rsc_common *common);
 int mlx5_query_odp_caps(struct mlx5_core_dev *dev,
 			struct mlx5_odp_caps *odp_caps);
-int mlx5_core_query_ib_ppcnt(struct mlx5_core_dev *dev,
-			     u8 port_num, void *out, size_t sz);
 
 int mlx5_init_rl_table(struct mlx5_core_dev *dev);
 void mlx5_cleanup_rl_table(struct mlx5_core_dev *dev);
@@ -1153,6 +1147,7 @@ int mlx5_cmd_destroy_vport_lag(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_roce(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_sriov(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_active(struct mlx5_core_dev *dev);
+bool mlx5_lag_mode_is_hash(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_master(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_shared_fdb(struct mlx5_core_dev *dev);
 struct net_device *mlx5_lag_get_roce_netdev(struct mlx5_core_dev *dev);
diff --git a/include/linux/mlx5/fs_helpers.h b/include/linux/mlx5/fs_helpers.h
index 9db21cd0e92c..bc5125bc0561 100644
--- a/include/linux/mlx5/fs_helpers.h
+++ b/include/linux/mlx5/fs_helpers.h
@@ -38,46 +38,6 @@
 #define MLX5_FS_IPV4_VERSION 4
 #define MLX5_FS_IPV6_VERSION 6
 
-static inline bool mlx5_fs_is_ipsec_flow(const u32 *match_c)
-{
-	void *misc_params_c = MLX5_ADDR_OF(fte_match_param, match_c,
-					   misc_parameters);
-
-	return MLX5_GET(fte_match_set_misc, misc_params_c, outer_esp_spi);
-}
-
-static inline bool _mlx5_fs_is_outer_ipproto_flow(const u32 *match_c,
-						  const u32 *match_v, u8 match)
-{
-	const void *headers_c = MLX5_ADDR_OF(fte_match_param, match_c,
-					     outer_headers);
-	const void *headers_v = MLX5_ADDR_OF(fte_match_param, match_v,
-					     outer_headers);
-
-	return MLX5_GET(fte_match_set_lyr_2_4, headers_c, ip_protocol) == 0xff &&
-		MLX5_GET(fte_match_set_lyr_2_4, headers_v, ip_protocol) == match;
-}
-
-static inline bool mlx5_fs_is_outer_tcp_flow(const u32 *match_c,
-					     const u32 *match_v)
-{
-	return _mlx5_fs_is_outer_ipproto_flow(match_c, match_v, IPPROTO_TCP);
-}
-
-static inline bool mlx5_fs_is_outer_udp_flow(const u32 *match_c,
-					     const u32 *match_v)
-{
-	return _mlx5_fs_is_outer_ipproto_flow(match_c, match_v, IPPROTO_UDP);
-}
-
-static inline bool mlx5_fs_is_vxlan_flow(const u32 *match_c)
-{
-	void *misc_params_c = MLX5_ADDR_OF(fte_match_param, match_c,
-					   misc_parameters);
-
-	return MLX5_GET(fte_match_set_misc, misc_params_c, vxlan_vni);
-}
-
 static inline bool _mlx5_fs_is_outer_ipv_flow(struct mlx5_core_dev *mdev,
 					      const u32 *match_c,
 					      const u32 *match_v, int version)
@@ -131,12 +91,4 @@ mlx5_fs_is_outer_ipv6_flow(struct mlx5_core_dev *mdev, const u32 *match_c,
 					  MLX5_FS_IPV6_VERSION);
 }
 
-static inline bool mlx5_fs_is_outer_ipsec_flow(const u32 *match_c)
-{
-	void *misc_params_c =
-			MLX5_ADDR_OF(fte_match_param, match_c, misc_parameters);
-
-	return MLX5_GET(fte_match_set_misc, misc_params_c, outer_esp_spi);
-}
-
 #endif
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 4acd5610e96b..c25f2ce75734 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -68,6 +68,7 @@ enum {
 	MLX5_SET_HCA_CAP_OP_MOD_ODP                   = 0x2,
 	MLX5_SET_HCA_CAP_OP_MOD_ATOMIC                = 0x3,
 	MLX5_SET_HCA_CAP_OP_MOD_ROCE                  = 0x4,
+	MLX5_SET_HCA_CAP_OP_MODE_PORT_SELECTION       = 0x25,
 };
 
 enum {
@@ -89,6 +90,7 @@ enum {
 	MLX5_OBJ_TYPE_VIRTIO_NET_Q = 0x000d,
 	MLX5_OBJ_TYPE_VIRTIO_Q_COUNTERS = 0x001c,
 	MLX5_OBJ_TYPE_MATCH_DEFINER = 0x0018,
+	MLX5_OBJ_TYPE_PAGE_TRACK = 0x46,
 	MLX5_OBJ_TYPE_MKEY = 0xff01,
 	MLX5_OBJ_TYPE_QP = 0xff02,
 	MLX5_OBJ_TYPE_PSV = 0xff03,
@@ -476,6 +478,22 @@ struct mlx5_ifc_odp_per_transport_service_cap_bits {
 	u8         reserved_at_6[0x1a];
 };
 
+struct mlx5_ifc_ipv4_layout_bits {
+	u8         reserved_at_0[0x60];
+
+	u8         ipv4[0x20];
+};
+
+struct mlx5_ifc_ipv6_layout_bits {
+	u8         ipv6[16][0x8];
+};
+
+union mlx5_ifc_ipv6_layout_ipv4_layout_auto_bits {
+	struct mlx5_ifc_ipv6_layout_bits ipv6_layout;
+	struct mlx5_ifc_ipv4_layout_bits ipv4_layout;
+	u8         reserved_at_0[0x80];
+};
+
 struct mlx5_ifc_fte_match_set_lyr_2_4_bits {
 	u8         smac_47_16[0x20];
 
@@ -813,7 +831,9 @@ struct mlx5_ifc_flow_table_nic_cap_bits {
 struct mlx5_ifc_port_selection_cap_bits {
 	u8         reserved_at_0[0x10];
 	u8         port_select_flow_table[0x1];
-	u8         reserved_at_11[0xf];
+	u8         reserved_at_11[0x1];
+	u8         port_select_flow_table_bypass[0x1];
+	u8         reserved_at_13[0xd];
 
 	u8         reserved_at_20[0x1e0];
 
@@ -1733,7 +1753,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         max_geneve_tlv_options[0x8];
 	u8         reserved_at_568[0x3];
 	u8         max_geneve_tlv_option_data_len[0x5];
-	u8         reserved_at_570[0x10];
+	u8         reserved_at_570[0x9];
+	u8         adv_virtualization[0x1];
+	u8         reserved_at_57a[0x6];
 
 	u8	   reserved_at_580[0xb];
 	u8	   log_max_dci_stream_channels[0x5];
@@ -9789,7 +9811,9 @@ struct mlx5_ifc_pcam_reg_bits {
 struct mlx5_ifc_mcam_enhanced_features_bits {
 	u8         reserved_at_0[0x5d];
 	u8         mcia_32dwords[0x1];
-	u8         reserved_at_5e[0xc];
+	u8         out_pulse_duration_ns[0x1];
+	u8         npps_period[0x1];
+	u8         reserved_at_60[0xa];
 	u8         reset_state[0x1];
 	u8         ptpcyc2realtime_modify[0x1];
 	u8         reserved_at_6c[0x2];
@@ -10289,7 +10313,12 @@ struct mlx5_ifc_mtpps_reg_bits {
 	u8         reserved_at_18[0x4];
 	u8         cap_max_num_of_pps_out_pins[0x4];
 
-	u8         reserved_at_20[0x24];
+	u8         reserved_at_20[0x13];
+	u8         cap_log_min_npps_period[0x5];
+	u8         reserved_at_38[0x3];
+	u8         cap_log_min_out_pulse_duration_ns[0x5];
+
+	u8         reserved_at_40[0x4];
 	u8         cap_pin_3_mode[0x4];
 	u8         reserved_at_48[0x4];
 	u8         cap_pin_2_mode[0x4];
@@ -10308,7 +10337,9 @@ struct mlx5_ifc_mtpps_reg_bits {
 	u8         cap_pin_4_mode[0x4];
 
 	u8         field_select[0x20];
-	u8         reserved_at_a0[0x60];
+	u8         reserved_at_a0[0x20];
+
+	u8         npps_period[0x40];
 
 	u8         enable[0x1];
 	u8         reserved_at_101[0xb];
@@ -10317,7 +10348,8 @@ struct mlx5_ifc_mtpps_reg_bits {
 	u8         pin_mode[0x4];
 	u8         pin[0x8];
 
-	u8         reserved_at_120[0x20];
+	u8         reserved_at_120[0x2];
+	u8         out_pulse_duration_ns[0x1e];
 
 	u8         time_stamp[0x40];
 
@@ -10920,7 +10952,9 @@ struct mlx5_ifc_lagc_bits {
 	u8         reserved_at_18[0x5];
 	u8         lag_state[0x3];
 
-	u8         reserved_at_20[0x14];
+	u8         reserved_at_20[0xc];
+	u8         active_port[0x4];
+	u8         reserved_at_30[0x4];
 	u8         tx_remap_affinity_2[0x4];
 	u8         reserved_at_38[0x4];
 	u8         tx_remap_affinity_1[0x4];
@@ -11818,4 +11852,82 @@ struct mlx5_ifc_load_vhca_state_out_bits {
 	u8         reserved_at_40[0x40];
 };
 
+struct mlx5_ifc_adv_virtualization_cap_bits {
+	u8         reserved_at_0[0x3];
+	u8         pg_track_log_max_num[0x5];
+	u8         pg_track_max_num_range[0x8];
+	u8         pg_track_log_min_addr_space[0x8];
+	u8         pg_track_log_max_addr_space[0x8];
+
+	u8         reserved_at_20[0x3];
+	u8         pg_track_log_min_msg_size[0x5];
+	u8         reserved_at_28[0x3];
+	u8         pg_track_log_max_msg_size[0x5];
+	u8         reserved_at_30[0x3];
+	u8         pg_track_log_min_page_size[0x5];
+	u8         reserved_at_38[0x3];
+	u8         pg_track_log_max_page_size[0x5];
+
+	u8         reserved_at_40[0x7c0];
+};
+
+struct mlx5_ifc_page_track_report_entry_bits {
+	u8         dirty_address_high[0x20];
+
+	u8         dirty_address_low[0x20];
+};
+
+enum {
+	MLX5_PAGE_TRACK_STATE_TRACKING,
+	MLX5_PAGE_TRACK_STATE_REPORTING,
+	MLX5_PAGE_TRACK_STATE_ERROR,
+};
+
+struct mlx5_ifc_page_track_range_bits {
+	u8         start_address[0x40];
+
+	u8         length[0x40];
+};
+
+struct mlx5_ifc_page_track_bits {
+	u8         modify_field_select[0x40];
+
+	u8         reserved_at_40[0x10];
+	u8         vhca_id[0x10];
+
+	u8         reserved_at_60[0x20];
+
+	u8         state[0x4];
+	u8         track_type[0x4];
+	u8         log_addr_space_size[0x8];
+	u8         reserved_at_90[0x3];
+	u8         log_page_size[0x5];
+	u8         reserved_at_98[0x3];
+	u8         log_msg_size[0x5];
+
+	u8         reserved_at_a0[0x8];
+	u8         reporting_qpn[0x18];
+
+	u8         reserved_at_c0[0x18];
+	u8         num_ranges[0x8];
+
+	u8         reserved_at_e0[0x20];
+
+	u8         range_start_address[0x40];
+
+	u8         length[0x40];
+
+	struct     mlx5_ifc_page_track_range_bits track_range[0];
+};
+
+struct mlx5_ifc_create_page_track_obj_in_bits {
+	struct mlx5_ifc_general_obj_in_cmd_hdr_bits general_obj_in_cmd_hdr;
+	struct mlx5_ifc_page_track_bits obj_context;
+};
+
+struct mlx5_ifc_modify_page_track_obj_in_bits {
+	struct mlx5_ifc_general_obj_in_cmd_hdr_bits general_obj_in_cmd_hdr;
+	struct mlx5_ifc_page_track_bits obj_context;
+};
+
 #endif /* MLX5_IFC_H */
diff --git a/include/linux/mlx5/mlx5_ifc_fpga.h b/include/linux/mlx5/mlx5_ifc_fpga.h
index 45c7c0d67635..0596472923ad 100644
--- a/include/linux/mlx5/mlx5_ifc_fpga.h
+++ b/include/linux/mlx5/mlx5_ifc_fpga.h
@@ -32,30 +32,6 @@
 #ifndef MLX5_IFC_FPGA_H
 #define MLX5_IFC_FPGA_H
 
-struct mlx5_ifc_ipv4_layout_bits {
-	u8         reserved_at_0[0x60];
-
-	u8         ipv4[0x20];
-};
-
-struct mlx5_ifc_ipv6_layout_bits {
-	u8         ipv6[16][0x8];
-};
-
-union mlx5_ifc_ipv6_layout_ipv4_layout_auto_bits {
-	struct mlx5_ifc_ipv6_layout_bits ipv6_layout;
-	struct mlx5_ifc_ipv4_layout_bits ipv4_layout;
-	u8         reserved_at_0[0x80];
-};
-
-enum {
-	MLX5_FPGA_CAP_SANDBOX_VENDOR_ID_MLNX = 0x2c9,
-};
-
-enum {
-	MLX5_FPGA_CAP_SANDBOX_PRODUCT_ID_IPSEC    = 0x2,
-};
-
 struct mlx5_ifc_fpga_shell_caps_bits {
 	u8         max_num_qps[0x10];
 	u8         reserved_at_10[0x8];
