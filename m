Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13AA067D967
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 00:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbjAZXJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 18:09:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjAZXI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 18:08:58 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD9023C7F;
        Thu, 26 Jan 2023 15:08:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 89CB9CE2600;
        Thu, 26 Jan 2023 23:08:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857A1C433EF;
        Thu, 26 Jan 2023 23:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674774530;
        bh=aquaMVeMXB0h3Vf8z+4298wBuSTpoxbxCwFK+T80ho0=;
        h=From:To:Cc:Subject:Date:From;
        b=DPBJOyVSoiowjC8IxkRatfhFtIKvS+EfHqmtMW/MLJOnFZOJ0TwViPQJMpRIidkGg
         cmoGFaNoeN0/jjIgH3KI3iJ62nRmpIEGZBiCmUFSlKRd6nNUBF7zvaWzZ0uZVL5OGR
         X7j6Vc2X1DalB3QkdRoAZ9uSHwT1jUwWfT9tsRqIxecKV6KdCNX+FFBTcqpU+Yb3QH
         cQph3zImk03H4URkIQaB6s/91wzRkK2vdBiwVDEM776uK80PA78SGk53AplA+mchua
         qi8weO4TNpS0XLS3fC7ISqCQ2Za1piu4JIVY7ecYtd6dIYQRbGnB9fAyzWEjjr3W4O
         poMVXWsJbhRCw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, linux-rdma@vger.kernel.org,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeed@kernel.org>
Subject: pull-request: mlx5-next 2023-01-24 V2
Date:   Thu, 26 Jan 2023 15:08:15 -0800
Message-Id: <20230126230815.224239-1-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, 

This pulls mlx5-next branch which includes changes from [1]:

1) From Jiri: fixe a deadlock in mlx5_ib's netdev notifier unregister.
2) From Mark and Patrisious: add IPsec RoCEv2 support.

[1] https://lore.kernel.org/netdev/20230105041756.677120-1-saeed@kernel.org/

Please pull into net-next and rdma-next.

v1-v2:
 - fix the pr command to use the branch name rather than the commit sha

Thanks,
Saeed.

The following changes since commit b7bfaa761d760e72a969d116517eaa12e404c262:

  Linux 6.2-rc3 (2023-01-08 11:49:43 -0600)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git mlx5-next

for you to fetch changes up to c4d508fbe54af3119e01672299514bfc83dfd59f:

  net/mlx5: Configure IPsec steering for egress RoCEv2 traffic (2023-01-18 00:12:58 -0800)

----------------------------------------------------------------
Jiri Pirko (3):
      net/mlx5e: Fix trap event handling
      net/mlx5e: Propagate an internal event in case uplink netdev changes
      RDMA/mlx5: Track netdev to avoid deadlock during netdev notifier unregister

Mark Zhang (4):
      net/mlx5: Implement new destination type TABLE_TYPE
      net/mlx5: Add IPSec priorities in RDMA namespaces
      net/mlx5: Configure IPsec steering for ingress RoCEv2 traffic
      net/mlx5: Configure IPsec steering for egress RoCEv2 traffic

Patrisious Haddad (2):
      net/mlx5: Introduce CQE error syndrome
      net/mlx5: Introduce new destination type TABLE_TYPE

 drivers/infiniband/hw/mlx5/main.c                  |  78 +++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.h  |   5 +
 .../mellanox/mlx5/core/diag/fs_tracepoint.c        |   4 +
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |   1 +
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.h   |   1 +
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         |  59 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  15 +-
 drivers/net/ethernet/mellanox/mlx5/core/events.c   |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  44 ++-
 .../mellanox/mlx5/core/lib/ipsec_fs_roce.c         | 372 +++++++++++++++++++++
 .../mellanox/mlx5/core/lib/ipsec_fs_roce.h         |  20 ++
 drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h |   5 -
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  20 ++
 include/linux/mlx5/device.h                        |   1 +
 include/linux/mlx5/driver.h                        |   5 +
 include/linux/mlx5/fs.h                            |   3 +
 include/linux/mlx5/mlx5_ifc.h                      |  59 +++-
 21 files changed, 656 insertions(+), 58 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.h

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index c669ef6e47e7..dc32e4518a28 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3012,26 +3012,63 @@ static void mlx5_eth_lag_cleanup(struct mlx5_ib_dev *dev)
 	}
 }
 
-static int mlx5_add_netdev_notifier(struct mlx5_ib_dev *dev, u32 port_num)
+static void mlx5_netdev_notifier_register(struct mlx5_roce *roce,
+					  struct net_device *netdev)
 {
 	int err;
 
-	dev->port[port_num].roce.nb.notifier_call = mlx5_netdev_event;
-	err = register_netdevice_notifier(&dev->port[port_num].roce.nb);
-	if (err) {
-		dev->port[port_num].roce.nb.notifier_call = NULL;
-		return err;
-	}
+	if (roce->tracking_netdev)
+		return;
+	roce->tracking_netdev = netdev;
+	roce->nb.notifier_call = mlx5_netdev_event;
+	err = register_netdevice_notifier_dev_net(netdev, &roce->nb, &roce->nn);
+	WARN_ON(err);
+}
 
-	return 0;
+static void mlx5_netdev_notifier_unregister(struct mlx5_roce *roce)
+{
+	if (!roce->tracking_netdev)
+		return;
+	unregister_netdevice_notifier_dev_net(roce->tracking_netdev, &roce->nb,
+					      &roce->nn);
+	roce->tracking_netdev = NULL;
 }
 
-static void mlx5_remove_netdev_notifier(struct mlx5_ib_dev *dev, u32 port_num)
+static int mlx5e_mdev_notifier_event(struct notifier_block *nb,
+				     unsigned long event, void *data)
 {
-	if (dev->port[port_num].roce.nb.notifier_call) {
-		unregister_netdevice_notifier(&dev->port[port_num].roce.nb);
-		dev->port[port_num].roce.nb.notifier_call = NULL;
+	struct mlx5_roce *roce = container_of(nb, struct mlx5_roce, mdev_nb);
+	struct net_device *netdev = data;
+
+	switch (event) {
+	case MLX5_DRIVER_EVENT_UPLINK_NETDEV:
+		if (netdev)
+			mlx5_netdev_notifier_register(roce, netdev);
+		else
+			mlx5_netdev_notifier_unregister(roce);
+		break;
+	default:
+		return NOTIFY_DONE;
 	}
+
+	return NOTIFY_OK;
+}
+
+static void mlx5_mdev_netdev_track(struct mlx5_ib_dev *dev, u32 port_num)
+{
+	struct mlx5_roce *roce = &dev->port[port_num].roce;
+
+	roce->mdev_nb.notifier_call = mlx5e_mdev_notifier_event;
+	mlx5_blocking_notifier_register(dev->mdev, &roce->mdev_nb);
+	mlx5_core_uplink_netdev_event_replay(dev->mdev);
+}
+
+static void mlx5_mdev_netdev_untrack(struct mlx5_ib_dev *dev, u32 port_num)
+{
+	struct mlx5_roce *roce = &dev->port[port_num].roce;
+
+	mlx5_blocking_notifier_unregister(dev->mdev, &roce->mdev_nb);
+	mlx5_netdev_notifier_unregister(roce);
 }
 
 static int mlx5_enable_eth(struct mlx5_ib_dev *dev)
@@ -3138,7 +3175,7 @@ static void mlx5_ib_unbind_slave_port(struct mlx5_ib_dev *ibdev,
 	if (mpi->mdev_events.notifier_call)
 		mlx5_notifier_unregister(mpi->mdev, &mpi->mdev_events);
 	mpi->mdev_events.notifier_call = NULL;
-	mlx5_remove_netdev_notifier(ibdev, port_num);
+	mlx5_mdev_netdev_untrack(ibdev, port_num);
 	spin_lock(&port->mp.mpi_lock);
 
 	comps = mpi->mdev_refcnt;
@@ -3196,12 +3233,7 @@ static bool mlx5_ib_bind_slave_port(struct mlx5_ib_dev *ibdev,
 	if (err)
 		goto unbind;
 
-	err = mlx5_add_netdev_notifier(ibdev, port_num);
-	if (err) {
-		mlx5_ib_err(ibdev, "failed adding netdev notifier for port %u\n",
-			    port_num + 1);
-		goto unbind;
-	}
+	mlx5_mdev_netdev_track(ibdev, port_num);
 
 	mpi->mdev_events.notifier_call = mlx5_ib_event_slave_port;
 	mlx5_notifier_register(mpi->mdev, &mpi->mdev_events);
@@ -3909,9 +3941,7 @@ static int mlx5_ib_roce_init(struct mlx5_ib_dev *dev)
 		port_num = mlx5_core_native_port_num(dev->mdev) - 1;
 
 		/* Register only for native ports */
-		err = mlx5_add_netdev_notifier(dev, port_num);
-		if (err)
-			return err;
+		mlx5_mdev_netdev_track(dev, port_num);
 
 		err = mlx5_enable_eth(dev);
 		if (err)
@@ -3920,7 +3950,7 @@ static int mlx5_ib_roce_init(struct mlx5_ib_dev *dev)
 
 	return 0;
 cleanup:
-	mlx5_remove_netdev_notifier(dev, port_num);
+	mlx5_mdev_netdev_untrack(dev, port_num);
 	return err;
 }
 
@@ -3938,7 +3968,7 @@ static void mlx5_ib_roce_cleanup(struct mlx5_ib_dev *dev)
 		mlx5_disable_eth(dev);
 
 		port_num = mlx5_core_native_port_num(dev->mdev) - 1;
-		mlx5_remove_netdev_notifier(dev, port_num);
+		mlx5_mdev_netdev_untrack(dev, port_num);
 	}
 }
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 8b91babdd4c0..7394e7f36ba7 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -832,6 +832,9 @@ struct mlx5_roce {
 	rwlock_t		netdev_lock;
 	struct net_device	*netdev;
 	struct notifier_block	nb;
+	struct netdev_net_notifier nn;
+	struct notifier_block	mdev_nb;
+	struct net_device	*tracking_netdev;
 	atomic_t		tx_port_affinity;
 	enum ib_port_state last_port_state;
 	struct mlx5_ib_dev	*dev;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index cd4a1ab0ea78..8415a44fb965 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -97,7 +97,7 @@ mlx5_core-$(CONFIG_MLX5_EN_MACSEC) += en_accel/macsec.o en_accel/macsec_fs.o \
 
 mlx5_core-$(CONFIG_MLX5_EN_IPSEC) += en_accel/ipsec.o en_accel/ipsec_rxtx.o \
 				     en_accel/ipsec_stats.o en_accel/ipsec_fs.o \
-				     en_accel/ipsec_offload.o
+				     en_accel/ipsec_offload.o lib/ipsec_fs_roce.o
 
 mlx5_core-$(CONFIG_MLX5_EN_TLS) += en_accel/ktls_stats.o \
 				   en_accel/fs_tcp.o en_accel/ktls.o en_accel/ktls_txrx.o \
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 5bd83c0275f8..f641ff9bb3bb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -263,6 +263,7 @@ static int mlx5_devlink_trap_action_set(struct devlink *devlink,
 					struct netlink_ext_ack *extack)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	struct mlx5_devlink_trap_event_ctx trap_event_ctx;
 	enum devlink_trap_action action_orig;
 	struct mlx5_devlink_trap *dl_trap;
 	int err = 0;
@@ -289,10 +290,14 @@ static int mlx5_devlink_trap_action_set(struct devlink *devlink,
 
 	action_orig = dl_trap->trap.action;
 	dl_trap->trap.action = action;
+	trap_event_ctx.trap = &dl_trap->trap;
+	trap_event_ctx.err = 0;
 	err = mlx5_blocking_notifier_call_chain(dev, MLX5_DRIVER_EVENT_TYPE_TRAP,
-						&dl_trap->trap);
-	if (err)
+						&trap_event_ctx);
+	if (err == NOTIFY_BAD) {
 		dl_trap->trap.action = action_orig;
+		err = trap_event_ctx.err;
+	}
 out:
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.h b/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
index fd033df24856..b84cb70eb3ae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
@@ -24,6 +24,11 @@ struct mlx5_devlink_trap {
 	struct list_head list;
 };
 
+struct mlx5_devlink_trap_event_ctx {
+	struct mlx5_trap_ctx *trap;
+	int err;
+};
+
 struct mlx5_core_dev;
 void mlx5_devlink_trap_report(struct mlx5_core_dev *dev, int trap_id, struct sk_buff *skb,
 			      struct devlink_port *dl_port);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c
index 2732128e7a6e..6d73127b7217 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c
@@ -275,6 +275,10 @@ const char *parse_fs_dst(struct trace_seq *p,
 				 fs_dest_range_field_to_str(dst->range.field),
 				 dst->range.min, dst->range.max);
 		break;
+	case MLX5_FLOW_DESTINATION_TYPE_TABLE_TYPE:
+		trace_seq_printf(p, "flow_table_type=%u id:%u\n", dst->ft->type,
+				 dst->ft->id);
+		break;
 	case MLX5_FLOW_DESTINATION_TYPE_NONE:
 		trace_seq_printf(p, "none\n");
 		break;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index 379c6dc9a3be..d2149f0138d8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -87,6 +87,7 @@ enum {
 	MLX5E_ACCEL_FS_POL_FT_LEVEL = MLX5E_INNER_TTC_FT_LEVEL + 1,
 	MLX5E_ACCEL_FS_ESP_FT_LEVEL,
 	MLX5E_ACCEL_FS_ESP_FT_ERR_LEVEL,
+	MLX5E_ACCEL_FS_ESP_FT_ROCE_LEVEL,
 #endif
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index a92e19c4c499..a72261ce7598 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -141,6 +141,7 @@ struct mlx5e_ipsec {
 	struct mlx5e_ipsec_tx *tx;
 	struct mlx5e_ipsec_aso *aso;
 	struct notifier_block nb;
+	struct mlx5_ipsec_fs *roce_ipsec;
 };
 
 struct mlx5e_ipsec_esn_state {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 9f19f4b59a70..4de528687536 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -6,6 +6,7 @@
 #include "en/fs.h"
 #include "ipsec.h"
 #include "fs_core.h"
+#include "lib/ipsec_fs_roce.h"
 
 #define NUM_IPSEC_FTE BIT(15)
 
@@ -166,7 +167,8 @@ static int ipsec_miss_create(struct mlx5_core_dev *mdev,
 	return err;
 }
 
-static void rx_destroy(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_rx *rx)
+static void rx_destroy(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_rx *rx, u32 family,
+		       struct mlx5_ipsec_fs *roce_ipsec)
 {
 	mlx5_del_flow_rules(rx->pol.rule);
 	mlx5_destroy_flow_group(rx->pol.group);
@@ -179,6 +181,8 @@ static void rx_destroy(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_rx *rx)
 	mlx5_del_flow_rules(rx->status.rule);
 	mlx5_modify_header_dealloc(mdev, rx->status.modify_hdr);
 	mlx5_destroy_flow_table(rx->ft.status);
+
+	mlx5_ipsec_fs_roce_rx_destroy(roce_ipsec, family);
 }
 
 static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
@@ -186,18 +190,35 @@ static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 {
 	struct mlx5_flow_namespace *ns = mlx5e_fs_get_ns(ipsec->fs, false);
 	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(ipsec->fs, false);
+	struct mlx5_flow_destination default_dest;
 	struct mlx5_flow_destination dest[2];
 	struct mlx5_flow_table *ft;
 	int err;
 
+	default_dest = mlx5_ttc_get_default_dest(ttc, family2tt(family));
+	err = mlx5_ipsec_fs_roce_rx_create(ipsec->roce_ipsec, ns, &default_dest, family,
+					   MLX5E_ACCEL_FS_ESP_FT_ROCE_LEVEL, MLX5E_NIC_PRIO,
+					   ipsec->mdev);
+	if (err)
+		return err;
+
 	ft = ipsec_ft_create(ns, MLX5E_ACCEL_FS_ESP_FT_ERR_LEVEL,
 			     MLX5E_NIC_PRIO, 1);
-	if (IS_ERR(ft))
-		return PTR_ERR(ft);
+	if (IS_ERR(ft)) {
+		err = PTR_ERR(ft);
+		goto err_fs_ft_status;
+	}
 
 	rx->ft.status = ft;
 
-	dest[0] = mlx5_ttc_get_default_dest(ttc, family2tt(family));
+	ft = mlx5_ipsec_fs_roce_ft_get(ipsec->roce_ipsec, family);
+	if (ft) {
+		dest[0].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+		dest[0].ft = ft;
+	} else {
+		dest[0] = default_dest;
+	}
+
 	dest[1].type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
 	dest[1].counter_id = mlx5_fc_id(rx->fc->cnt);
 	err = ipsec_status_rule(mdev, rx, dest);
@@ -245,6 +266,8 @@ static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 	mlx5_modify_header_dealloc(mdev, rx->status.modify_hdr);
 err_add:
 	mlx5_destroy_flow_table(rx->ft.status);
+err_fs_ft_status:
+	mlx5_ipsec_fs_roce_rx_destroy(ipsec->roce_ipsec, family);
 	return err;
 }
 
@@ -304,7 +327,7 @@ static void rx_ft_put(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 	mlx5_ttc_fwd_default_dest(ttc, family2tt(family));
 
 	/* remove FT */
-	rx_destroy(mdev, rx);
+	rx_destroy(mdev, rx, family, ipsec->roce_ipsec);
 
 out:
 	mutex_unlock(&rx->ft.mutex);
@@ -343,6 +366,14 @@ static int tx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_tx *tx)
 	return err;
 }
 
+static void tx_destroy(struct mlx5e_ipsec_tx *tx)
+{
+	mlx5_del_flow_rules(tx->pol.rule);
+	mlx5_destroy_flow_group(tx->pol.group);
+	mlx5_destroy_flow_table(tx->ft.pol);
+	mlx5_destroy_flow_table(tx->ft.sa);
+}
+
 static struct mlx5e_ipsec_tx *tx_ft_get(struct mlx5_core_dev *mdev,
 					struct mlx5e_ipsec *ipsec)
 {
@@ -356,6 +387,13 @@ static struct mlx5e_ipsec_tx *tx_ft_get(struct mlx5_core_dev *mdev,
 	err = tx_create(mdev, tx);
 	if (err)
 		goto out;
+
+	err = mlx5_ipsec_fs_roce_tx_create(ipsec->roce_ipsec, tx->ft.pol, ipsec->mdev);
+	if (err) {
+		tx_destroy(tx);
+		goto out;
+	}
+
 skip:
 	tx->ft.refcnt++;
 out:
@@ -374,10 +412,9 @@ static void tx_ft_put(struct mlx5e_ipsec *ipsec)
 	if (tx->ft.refcnt)
 		goto out;
 
-	mlx5_del_flow_rules(tx->pol.rule);
-	mlx5_destroy_flow_group(tx->pol.group);
-	mlx5_destroy_flow_table(tx->ft.pol);
-	mlx5_destroy_flow_table(tx->ft.sa);
+	mlx5_ipsec_fs_roce_tx_destroy(ipsec->roce_ipsec);
+
+	tx_destroy(tx);
 out:
 	mutex_unlock(&tx->ft.mutex);
 }
@@ -1008,6 +1045,8 @@ void mlx5e_accel_ipsec_fs_cleanup(struct mlx5e_ipsec *ipsec)
 	if (!ipsec->tx)
 		return;
 
+	mlx5_ipsec_fs_roce_cleanup(ipsec->roce_ipsec);
+
 	ipsec_fs_destroy_counters(ipsec);
 	mutex_destroy(&ipsec->tx->ft.mutex);
 	WARN_ON(ipsec->tx->ft.refcnt);
@@ -1053,6 +1092,8 @@ int mlx5e_accel_ipsec_fs_init(struct mlx5e_ipsec *ipsec)
 	mutex_init(&ipsec->rx_ipv6->ft.mutex);
 	ipsec->tx->ns = ns;
 
+	ipsec->roce_ipsec = mlx5_ipsec_fs_roce_init(ipsec->mdev);
+
 	return 0;
 
 err_counters:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index cff5f2e29e1e..85b51039d2a6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -179,17 +179,21 @@ static void mlx5e_disable_async_events(struct mlx5e_priv *priv)
 static int blocking_event(struct notifier_block *nb, unsigned long event, void *data)
 {
 	struct mlx5e_priv *priv = container_of(nb, struct mlx5e_priv, blocking_events_nb);
+	struct mlx5_devlink_trap_event_ctx *trap_event_ctx = data;
 	int err;
 
 	switch (event) {
 	case MLX5_DRIVER_EVENT_TYPE_TRAP:
-		err = mlx5e_handle_trap_event(priv, data);
+		err = mlx5e_handle_trap_event(priv, trap_event_ctx->trap);
+		if (err) {
+			trap_event_ctx->err = err;
+			return NOTIFY_BAD;
+		}
 		break;
 	default:
-		netdev_warn(priv->netdev, "Sync event: Unknown event %ld\n", event);
-		err = -EINVAL;
+		return NOTIFY_DONE;
 	}
-	return err;
+	return NOTIFY_OK;
 }
 
 static void mlx5e_enable_blocking_events(struct mlx5e_priv *priv)
@@ -5957,7 +5961,7 @@ static int mlx5e_probe(struct auxiliary_device *adev,
 	}
 
 	mlx5e_dcbnl_init_app(priv);
-	mlx5_uplink_netdev_set(mdev, netdev);
+	mlx5_core_uplink_netdev_set(mdev, netdev);
 	mlx5e_params_print_info(mdev, &priv->channels.params);
 	return 0;
 
@@ -5977,6 +5981,7 @@ static void mlx5e_remove(struct auxiliary_device *adev)
 	struct mlx5e_priv *priv = auxiliary_get_drvdata(adev);
 	pm_message_t state = {};
 
+	mlx5_core_uplink_netdev_set(priv->mdev, NULL);
 	mlx5e_dcbnl_delete_app(priv);
 	unregister_netdev(priv->netdev);
 	mlx5e_suspend(adev, state);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/events.c b/drivers/net/ethernet/mellanox/mlx5/core/events.c
index 9459e56ee90a..718cf09c28ce 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/events.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/events.c
@@ -424,6 +424,7 @@ int mlx5_blocking_notifier_register(struct mlx5_core_dev *dev, struct notifier_b
 
 	return blocking_notifier_chain_register(&events->sw_nh, nb);
 }
+EXPORT_SYMBOL(mlx5_blocking_notifier_register);
 
 int mlx5_blocking_notifier_unregister(struct mlx5_core_dev *dev, struct notifier_block *nb)
 {
@@ -431,6 +432,7 @@ int mlx5_blocking_notifier_unregister(struct mlx5_core_dev *dev, struct notifier
 
 	return blocking_notifier_chain_unregister(&events->sw_nh, nb);
 }
+EXPORT_SYMBOL(mlx5_blocking_notifier_unregister);
 
 int mlx5_blocking_notifier_call_chain(struct mlx5_core_dev *dev, unsigned int event,
 				      void *data)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index 32d4c967469c..a3a9cc6f15ca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -653,6 +653,12 @@ static int mlx5_cmd_set_fte(struct mlx5_core_dev *dev,
 				id = dst->dest_attr.sampler_id;
 				ifc_type = MLX5_IFC_FLOW_DESTINATION_TYPE_FLOW_SAMPLER;
 				break;
+			case MLX5_FLOW_DESTINATION_TYPE_TABLE_TYPE:
+				MLX5_SET(dest_format_struct, in_dests,
+					 destination_table_type, dst->dest_attr.ft->type);
+				id = dst->dest_attr.ft->id;
+				ifc_type = MLX5_IFC_FLOW_DESTINATION_TYPE_TABLE_TYPE;
+				break;
 			default:
 				id = dst->dest_attr.tir_num;
 				ifc_type = MLX5_IFC_FLOW_DESTINATION_TYPE_TIR;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 5a85d8c1e797..cb28cdb59c17 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -111,8 +111,10 @@
 #define ETHTOOL_PRIO_NUM_LEVELS 1
 #define ETHTOOL_NUM_PRIOS 11
 #define ETHTOOL_MIN_LEVEL (KERNEL_MIN_LEVEL + ETHTOOL_NUM_PRIOS)
-/* Promiscuous, Vlan, mac, ttc, inner ttc, {UDP/ANY/aRFS/accel/{esp, esp_err}}, IPsec policy */
-#define KERNEL_NIC_PRIO_NUM_LEVELS 8
+/* Promiscuous, Vlan, mac, ttc, inner ttc, {UDP/ANY/aRFS/accel/{esp, esp_err}}, IPsec policy,
+ * IPsec RoCE policy
+ */
+#define KERNEL_NIC_PRIO_NUM_LEVELS 9
 #define KERNEL_NIC_NUM_PRIOS 1
 /* One more level for tc */
 #define KERNEL_MIN_LEVEL (KERNEL_NIC_PRIO_NUM_LEVELS + 1)
@@ -219,19 +221,30 @@ static struct init_tree_node egress_root_fs = {
 };
 
 enum {
+	RDMA_RX_IPSEC_PRIO,
 	RDMA_RX_COUNTERS_PRIO,
 	RDMA_RX_BYPASS_PRIO,
 	RDMA_RX_KERNEL_PRIO,
 };
 
+#define RDMA_RX_IPSEC_NUM_PRIOS 1
+#define RDMA_RX_IPSEC_NUM_LEVELS 2
+#define RDMA_RX_IPSEC_MIN_LEVEL  (RDMA_RX_IPSEC_NUM_LEVELS)
+
 #define RDMA_RX_BYPASS_MIN_LEVEL MLX5_BY_PASS_NUM_REGULAR_PRIOS
 #define RDMA_RX_KERNEL_MIN_LEVEL (RDMA_RX_BYPASS_MIN_LEVEL + 1)
 #define RDMA_RX_COUNTERS_MIN_LEVEL (RDMA_RX_KERNEL_MIN_LEVEL + 2)
 
 static struct init_tree_node rdma_rx_root_fs = {
 	.type = FS_TYPE_NAMESPACE,
-	.ar_size = 3,
+	.ar_size = 4,
 	.children = (struct init_tree_node[]) {
+		[RDMA_RX_IPSEC_PRIO] =
+		ADD_PRIO(0, RDMA_RX_IPSEC_MIN_LEVEL, 0,
+			 FS_CHAINING_CAPS,
+			 ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
+				ADD_MULTIPLE_PRIO(RDMA_RX_IPSEC_NUM_PRIOS,
+						  RDMA_RX_IPSEC_NUM_LEVELS))),
 		[RDMA_RX_COUNTERS_PRIO] =
 		ADD_PRIO(0, RDMA_RX_COUNTERS_MIN_LEVEL, 0,
 			 FS_CHAINING_CAPS,
@@ -254,15 +267,20 @@ static struct init_tree_node rdma_rx_root_fs = {
 
 enum {
 	RDMA_TX_COUNTERS_PRIO,
+	RDMA_TX_IPSEC_PRIO,
 	RDMA_TX_BYPASS_PRIO,
 };
 
 #define RDMA_TX_BYPASS_MIN_LEVEL MLX5_BY_PASS_NUM_PRIOS
 #define RDMA_TX_COUNTERS_MIN_LEVEL (RDMA_TX_BYPASS_MIN_LEVEL + 1)
 
+#define RDMA_TX_IPSEC_NUM_PRIOS 1
+#define RDMA_TX_IPSEC_PRIO_NUM_LEVELS 1
+#define RDMA_TX_IPSEC_MIN_LEVEL  (RDMA_TX_COUNTERS_MIN_LEVEL + RDMA_TX_IPSEC_NUM_PRIOS)
+
 static struct init_tree_node rdma_tx_root_fs = {
 	.type = FS_TYPE_NAMESPACE,
-	.ar_size = 2,
+	.ar_size = 3,
 	.children = (struct init_tree_node[]) {
 		[RDMA_TX_COUNTERS_PRIO] =
 		ADD_PRIO(0, RDMA_TX_COUNTERS_MIN_LEVEL, 0,
@@ -270,6 +288,13 @@ static struct init_tree_node rdma_tx_root_fs = {
 			 ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
 				ADD_MULTIPLE_PRIO(MLX5_RDMA_TX_NUM_COUNTERS_PRIOS,
 						  RDMA_TX_COUNTERS_PRIO_NUM_LEVELS))),
+		[RDMA_TX_IPSEC_PRIO] =
+		ADD_PRIO(0, RDMA_TX_IPSEC_MIN_LEVEL, 0,
+			 FS_CHAINING_CAPS,
+			 ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
+				ADD_MULTIPLE_PRIO(RDMA_TX_IPSEC_NUM_PRIOS,
+						  RDMA_TX_IPSEC_PRIO_NUM_LEVELS))),
+
 		[RDMA_TX_BYPASS_PRIO] =
 		ADD_PRIO(0, RDMA_TX_BYPASS_MIN_LEVEL, 0,
 			 FS_CHAINING_CAPS_RDMA_TX,
@@ -449,7 +474,8 @@ static bool is_fwd_dest_type(enum mlx5_flow_destination_type type)
 		type == MLX5_FLOW_DESTINATION_TYPE_VPORT ||
 		type == MLX5_FLOW_DESTINATION_TYPE_FLOW_SAMPLER ||
 		type == MLX5_FLOW_DESTINATION_TYPE_TIR ||
-		type == MLX5_FLOW_DESTINATION_TYPE_RANGE;
+		type == MLX5_FLOW_DESTINATION_TYPE_RANGE ||
+		type == MLX5_FLOW_DESTINATION_TYPE_TABLE_TYPE;
 }
 
 static bool check_valid_spec(const struct mlx5_flow_spec *spec)
@@ -2367,6 +2393,14 @@ struct mlx5_flow_namespace *mlx5_get_flow_namespace(struct mlx5_core_dev *dev,
 		root_ns = steering->rdma_tx_root_ns;
 		prio = RDMA_TX_COUNTERS_PRIO;
 		break;
+	case MLX5_FLOW_NAMESPACE_RDMA_RX_IPSEC:
+		root_ns = steering->rdma_rx_root_ns;
+		prio = RDMA_RX_IPSEC_PRIO;
+		break;
+	case MLX5_FLOW_NAMESPACE_RDMA_TX_IPSEC:
+		root_ns = steering->rdma_tx_root_ns;
+		prio = RDMA_TX_IPSEC_PRIO;
+		break;
 	default: /* Must be NIC RX */
 		WARN_ON(!is_nic_rx_ns(type));
 		root_ns = steering->root_ns;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.c
new file mode 100644
index 000000000000..2711892fd5cb
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.c
@@ -0,0 +1,372 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#include "fs_core.h"
+#include "lib/ipsec_fs_roce.h"
+#include "mlx5_core.h"
+
+struct mlx5_ipsec_miss {
+	struct mlx5_flow_group *group;
+	struct mlx5_flow_handle *rule;
+};
+
+struct mlx5_ipsec_rx_roce {
+	struct mlx5_flow_group *g;
+	struct mlx5_flow_table *ft;
+	struct mlx5_flow_handle *rule;
+	struct mlx5_ipsec_miss roce_miss;
+
+	struct mlx5_flow_table *ft_rdma;
+	struct mlx5_flow_namespace *ns_rdma;
+};
+
+struct mlx5_ipsec_tx_roce {
+	struct mlx5_flow_group *g;
+	struct mlx5_flow_table *ft;
+	struct mlx5_flow_handle *rule;
+	struct mlx5_flow_namespace *ns;
+};
+
+struct mlx5_ipsec_fs {
+	struct mlx5_ipsec_rx_roce ipv4_rx;
+	struct mlx5_ipsec_rx_roce ipv6_rx;
+	struct mlx5_ipsec_tx_roce tx;
+};
+
+static void ipsec_fs_roce_setup_udp_dport(struct mlx5_flow_spec *spec, u16 dport)
+{
+	spec->match_criteria_enable |= MLX5_MATCH_OUTER_HEADERS;
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.ip_protocol);
+	MLX5_SET(fte_match_param, spec->match_value, outer_headers.ip_protocol, IPPROTO_UDP);
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.udp_dport);
+	MLX5_SET(fte_match_param, spec->match_value, outer_headers.udp_dport, dport);
+}
+
+static int ipsec_fs_roce_rx_rule_setup(struct mlx5_flow_destination *default_dst,
+				       struct mlx5_ipsec_rx_roce *roce, struct mlx5_core_dev *mdev)
+{
+	struct mlx5_flow_destination dst = {};
+	MLX5_DECLARE_FLOW_ACT(flow_act);
+	struct mlx5_flow_handle *rule;
+	struct mlx5_flow_spec *spec;
+	int err = 0;
+
+	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
+	if (!spec)
+		return -ENOMEM;
+
+	ipsec_fs_roce_setup_udp_dport(spec, ROCE_V2_UDP_DPORT);
+
+	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+	dst.type = MLX5_FLOW_DESTINATION_TYPE_TABLE_TYPE;
+	dst.ft = roce->ft_rdma;
+	rule = mlx5_add_flow_rules(roce->ft, spec, &flow_act, &dst, 1);
+	if (IS_ERR(rule)) {
+		err = PTR_ERR(rule);
+		mlx5_core_err(mdev, "Fail to add RX roce ipsec rule err=%d\n",
+			      err);
+		goto fail_add_rule;
+	}
+
+	roce->rule = rule;
+
+	memset(spec, 0, sizeof(*spec));
+	rule = mlx5_add_flow_rules(roce->ft, spec, &flow_act, default_dst, 1);
+	if (IS_ERR(rule)) {
+		err = PTR_ERR(rule);
+		mlx5_core_err(mdev, "Fail to add RX roce ipsec miss rule err=%d\n",
+			      err);
+		goto fail_add_default_rule;
+	}
+
+	roce->roce_miss.rule = rule;
+
+	kvfree(spec);
+	return 0;
+
+fail_add_default_rule:
+	mlx5_del_flow_rules(roce->rule);
+fail_add_rule:
+	kvfree(spec);
+	return err;
+}
+
+static int ipsec_fs_roce_tx_rule_setup(struct mlx5_core_dev *mdev, struct mlx5_ipsec_tx_roce *roce,
+				       struct mlx5_flow_table *pol_ft)
+{
+	struct mlx5_flow_destination dst = {};
+	MLX5_DECLARE_FLOW_ACT(flow_act);
+	struct mlx5_flow_handle *rule;
+	int err = 0;
+
+	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+	dst.type = MLX5_FLOW_DESTINATION_TYPE_TABLE_TYPE;
+	dst.ft = pol_ft;
+	rule = mlx5_add_flow_rules(roce->ft, NULL, &flow_act, &dst,
+				   1);
+	if (IS_ERR(rule)) {
+		err = PTR_ERR(rule);
+		mlx5_core_err(mdev, "Fail to add TX roce ipsec rule err=%d\n",
+			      err);
+		goto out;
+	}
+	roce->rule = rule;
+
+out:
+	return err;
+}
+
+void mlx5_ipsec_fs_roce_tx_destroy(struct mlx5_ipsec_fs *ipsec_roce)
+{
+	struct mlx5_ipsec_tx_roce *tx_roce;
+
+	if (!ipsec_roce)
+		return;
+
+	tx_roce = &ipsec_roce->tx;
+
+	mlx5_del_flow_rules(tx_roce->rule);
+	mlx5_destroy_flow_group(tx_roce->g);
+	mlx5_destroy_flow_table(tx_roce->ft);
+}
+
+#define MLX5_TX_ROCE_GROUP_SIZE BIT(0)
+
+int mlx5_ipsec_fs_roce_tx_create(struct mlx5_ipsec_fs *ipsec_roce, struct mlx5_flow_table *pol_ft,
+				 struct mlx5_core_dev *mdev)
+{
+	struct mlx5_flow_table_attr ft_attr = {};
+	struct mlx5_ipsec_tx_roce *roce;
+	struct mlx5_flow_table *ft;
+	struct mlx5_flow_group *g;
+	int ix = 0;
+	int err;
+	u32 *in;
+
+	if (!ipsec_roce)
+		return 0;
+
+	roce = &ipsec_roce->tx;
+
+	in = kvzalloc(MLX5_ST_SZ_BYTES(create_flow_group_in), GFP_KERNEL);
+	if (!in)
+		return -ENOMEM;
+
+	ft_attr.max_fte = 1;
+	ft = mlx5_create_flow_table(roce->ns, &ft_attr);
+	if (IS_ERR(ft)) {
+		err = PTR_ERR(ft);
+		mlx5_core_err(mdev, "Fail to create ipsec tx roce ft err=%d\n", err);
+		return err;
+	}
+
+	roce->ft = ft;
+
+	MLX5_SET_CFG(in, start_flow_index, ix);
+	ix += MLX5_TX_ROCE_GROUP_SIZE;
+	MLX5_SET_CFG(in, end_flow_index, ix - 1);
+	g = mlx5_create_flow_group(ft, in);
+	if (IS_ERR(g)) {
+		err = PTR_ERR(g);
+		mlx5_core_err(mdev, "Fail to create ipsec tx roce group err=%d\n", err);
+		goto fail;
+	}
+	roce->g = g;
+
+	err = ipsec_fs_roce_tx_rule_setup(mdev, roce, pol_ft);
+	if (err) {
+		mlx5_core_err(mdev, "Fail to create ipsec tx roce rules err=%d\n", err);
+		goto rule_fail;
+	}
+
+	return 0;
+
+rule_fail:
+	mlx5_destroy_flow_group(roce->g);
+fail:
+	mlx5_destroy_flow_table(ft);
+	return err;
+}
+
+struct mlx5_flow_table *mlx5_ipsec_fs_roce_ft_get(struct mlx5_ipsec_fs *ipsec_roce, u32 family)
+{
+	struct mlx5_ipsec_rx_roce *rx_roce;
+
+	if (!ipsec_roce)
+		return NULL;
+
+	rx_roce = (family == AF_INET) ? &ipsec_roce->ipv4_rx :
+					&ipsec_roce->ipv6_rx;
+
+	return rx_roce->ft;
+}
+
+void mlx5_ipsec_fs_roce_rx_destroy(struct mlx5_ipsec_fs *ipsec_roce, u32 family)
+{
+	struct mlx5_ipsec_rx_roce *rx_roce;
+
+	if (!ipsec_roce)
+		return;
+
+	rx_roce = (family == AF_INET) ? &ipsec_roce->ipv4_rx :
+					&ipsec_roce->ipv6_rx;
+
+	mlx5_del_flow_rules(rx_roce->roce_miss.rule);
+	mlx5_del_flow_rules(rx_roce->rule);
+	mlx5_destroy_flow_table(rx_roce->ft_rdma);
+	mlx5_destroy_flow_group(rx_roce->roce_miss.group);
+	mlx5_destroy_flow_group(rx_roce->g);
+	mlx5_destroy_flow_table(rx_roce->ft);
+}
+
+#define MLX5_RX_ROCE_GROUP_SIZE BIT(0)
+
+int mlx5_ipsec_fs_roce_rx_create(struct mlx5_ipsec_fs *ipsec_roce, struct mlx5_flow_namespace *ns,
+				 struct mlx5_flow_destination *default_dst, u32 family, u32 level,
+				 u32 prio, struct mlx5_core_dev *mdev)
+{
+	struct mlx5_flow_table_attr ft_attr = {};
+	struct mlx5_ipsec_rx_roce *roce;
+	struct mlx5_flow_table *ft;
+	struct mlx5_flow_group *g;
+	void *outer_headers_c;
+	int ix = 0;
+	u32 *in;
+	int err;
+	u8 *mc;
+
+	if (!ipsec_roce)
+		return 0;
+
+	roce = (family == AF_INET) ? &ipsec_roce->ipv4_rx :
+				     &ipsec_roce->ipv6_rx;
+
+	ft_attr.max_fte = 2;
+	ft_attr.level = level;
+	ft_attr.prio = prio;
+	ft = mlx5_create_flow_table(ns, &ft_attr);
+	if (IS_ERR(ft)) {
+		err = PTR_ERR(ft);
+		mlx5_core_err(mdev, "Fail to create ipsec rx roce ft at nic err=%d\n", err);
+		return err;
+	}
+
+	roce->ft = ft;
+
+	in = kvzalloc(MLX5_ST_SZ_BYTES(create_flow_group_in), GFP_KERNEL);
+	if (!in) {
+		err = -ENOMEM;
+		goto fail_nomem;
+	}
+
+	mc = MLX5_ADDR_OF(create_flow_group_in, in, match_criteria);
+	outer_headers_c = MLX5_ADDR_OF(fte_match_param, mc, outer_headers);
+	MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, outer_headers_c, ip_protocol);
+	MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, outer_headers_c, udp_dport);
+
+	MLX5_SET_CFG(in, match_criteria_enable, MLX5_MATCH_OUTER_HEADERS);
+	MLX5_SET_CFG(in, start_flow_index, ix);
+	ix += MLX5_RX_ROCE_GROUP_SIZE;
+	MLX5_SET_CFG(in, end_flow_index, ix - 1);
+	g = mlx5_create_flow_group(ft, in);
+	if (IS_ERR(g)) {
+		err = PTR_ERR(g);
+		mlx5_core_err(mdev, "Fail to create ipsec rx roce group at nic err=%d\n", err);
+		goto fail_group;
+	}
+	roce->g = g;
+
+	memset(in, 0, MLX5_ST_SZ_BYTES(create_flow_group_in));
+	MLX5_SET_CFG(in, start_flow_index, ix);
+	ix += MLX5_RX_ROCE_GROUP_SIZE;
+	MLX5_SET_CFG(in, end_flow_index, ix - 1);
+	g = mlx5_create_flow_group(ft, in);
+	if (IS_ERR(g)) {
+		err = PTR_ERR(g);
+		mlx5_core_err(mdev, "Fail to create ipsec rx roce miss group at nic err=%d\n", err);
+		goto fail_mgroup;
+	}
+	roce->roce_miss.group = g;
+
+	memset(&ft_attr, 0, sizeof(ft_attr));
+	if (family == AF_INET)
+		ft_attr.level = 1;
+	ft = mlx5_create_flow_table(roce->ns_rdma, &ft_attr);
+	if (IS_ERR(ft)) {
+		err = PTR_ERR(ft);
+		mlx5_core_err(mdev, "Fail to create ipsec rx roce ft at rdma err=%d\n", err);
+		goto fail_rdma_table;
+	}
+
+	roce->ft_rdma = ft;
+
+	err = ipsec_fs_roce_rx_rule_setup(default_dst, roce, mdev);
+	if (err) {
+		mlx5_core_err(mdev, "Fail to create ipsec rx roce rules err=%d\n", err);
+		goto fail_setup_rule;
+	}
+
+	kvfree(in);
+	return 0;
+
+fail_setup_rule:
+	mlx5_destroy_flow_table(roce->ft_rdma);
+fail_rdma_table:
+	mlx5_destroy_flow_group(roce->roce_miss.group);
+fail_mgroup:
+	mlx5_destroy_flow_group(roce->g);
+fail_group:
+	kvfree(in);
+fail_nomem:
+	mlx5_destroy_flow_table(roce->ft);
+	return err;
+}
+
+void mlx5_ipsec_fs_roce_cleanup(struct mlx5_ipsec_fs *ipsec_roce)
+{
+	kfree(ipsec_roce);
+}
+
+#define NIC_RDMA_BOTH_DIRS_CAPS (MLX5_FT_NIC_RX_2_NIC_RX_RDMA | MLX5_FT_NIC_TX_RDMA_2_NIC_TX)
+
+struct mlx5_ipsec_fs *mlx5_ipsec_fs_roce_init(struct mlx5_core_dev *mdev)
+{
+	struct mlx5_ipsec_fs *roce_ipsec;
+	struct mlx5_flow_namespace *ns;
+
+	if (!mlx5_get_roce_state(mdev))
+		return NULL;
+
+	if ((MLX5_CAP_GEN_2(mdev, flow_table_type_2_type) &
+	     NIC_RDMA_BOTH_DIRS_CAPS) != NIC_RDMA_BOTH_DIRS_CAPS) {
+		mlx5_core_dbg(mdev, "Failed to init roce ipsec flow steering, capabilities not supported\n");
+		return NULL;
+	}
+
+	ns = mlx5_get_flow_namespace(mdev, MLX5_FLOW_NAMESPACE_RDMA_RX_IPSEC);
+	if (!ns) {
+		mlx5_core_err(mdev, "Failed to get roce rx ns\n");
+		return NULL;
+	}
+
+	roce_ipsec = kzalloc(sizeof(*roce_ipsec), GFP_KERNEL);
+	if (!roce_ipsec)
+		return NULL;
+
+	roce_ipsec->ipv4_rx.ns_rdma = ns;
+	roce_ipsec->ipv6_rx.ns_rdma = ns;
+
+	ns = mlx5_get_flow_namespace(mdev, MLX5_FLOW_NAMESPACE_RDMA_TX_IPSEC);
+	if (!ns) {
+		mlx5_core_err(mdev, "Failed to get roce tx ns\n");
+		goto err_tx;
+	}
+
+	roce_ipsec->tx.ns = ns;
+
+	return roce_ipsec;
+
+err_tx:
+	kfree(roce_ipsec);
+	return NULL;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.h
new file mode 100644
index 000000000000..4b69d4e34234
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#ifndef __MLX5_LIB_IPSEC_H__
+#define __MLX5_LIB_IPSEC_H__
+
+struct mlx5_ipsec_fs;
+
+struct mlx5_flow_table *mlx5_ipsec_fs_roce_ft_get(struct mlx5_ipsec_fs *ipsec_roce, u32 family);
+void mlx5_ipsec_fs_roce_rx_destroy(struct mlx5_ipsec_fs *ipsec_roce, u32 family);
+int mlx5_ipsec_fs_roce_rx_create(struct mlx5_ipsec_fs *ipsec_roce, struct mlx5_flow_namespace *ns,
+				 struct mlx5_flow_destination *default_dst, u32 family, u32 level,
+				 u32 prio, struct mlx5_core_dev *mdev);
+void mlx5_ipsec_fs_roce_tx_destroy(struct mlx5_ipsec_fs *ipsec_roce);
+int mlx5_ipsec_fs_roce_tx_create(struct mlx5_ipsec_fs *ipsec_roce, struct mlx5_flow_table *pol_ft,
+				 struct mlx5_core_dev *mdev);
+void mlx5_ipsec_fs_roce_cleanup(struct mlx5_ipsec_fs *ipsec_roce);
+struct mlx5_ipsec_fs *mlx5_ipsec_fs_roce_init(struct mlx5_core_dev *mdev);
+
+#endif /* __MLX5_LIB_IPSEC_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
index 032adb21ad4b..bfd3a1121ed8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
@@ -96,11 +96,6 @@ static inline struct net *mlx5_core_net(struct mlx5_core_dev *dev)
 	return devlink_net(priv_to_devlink(dev));
 }
 
-static inline void mlx5_uplink_netdev_set(struct mlx5_core_dev *mdev, struct net_device *netdev)
-{
-	mdev->mlx5e_res.uplink_netdev = netdev;
-}
-
 static inline struct net_device *mlx5_uplink_netdev_get(struct mlx5_core_dev *mdev)
 {
 	return mdev->mlx5e_res.uplink_netdev;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index df134f6d32dc..72716d1f8b37 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -336,6 +336,24 @@ static u16 to_fw_pkey_sz(struct mlx5_core_dev *dev, u32 size)
 	}
 }
 
+void mlx5_core_uplink_netdev_set(struct mlx5_core_dev *dev, struct net_device *netdev)
+{
+	mutex_lock(&dev->mlx5e_res.uplink_netdev_lock);
+	dev->mlx5e_res.uplink_netdev = netdev;
+	mlx5_blocking_notifier_call_chain(dev, MLX5_DRIVER_EVENT_UPLINK_NETDEV,
+					  netdev);
+	mutex_unlock(&dev->mlx5e_res.uplink_netdev_lock);
+}
+
+void mlx5_core_uplink_netdev_event_replay(struct mlx5_core_dev *dev)
+{
+	mutex_lock(&dev->mlx5e_res.uplink_netdev_lock);
+	mlx5_blocking_notifier_call_chain(dev, MLX5_DRIVER_EVENT_UPLINK_NETDEV,
+					  dev->mlx5e_res.uplink_netdev);
+	mutex_unlock(&dev->mlx5e_res.uplink_netdev_lock);
+}
+EXPORT_SYMBOL(mlx5_core_uplink_netdev_event_replay);
+
 static int mlx5_core_get_caps_mode(struct mlx5_core_dev *dev,
 				   enum mlx5_cap_type cap_type,
 				   enum mlx5_cap_mode cap_mode)
@@ -1608,6 +1626,7 @@ int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 	lockdep_register_key(&dev->lock_key);
 	mutex_init(&dev->intf_state_mutex);
 	lockdep_set_class(&dev->intf_state_mutex, &dev->lock_key);
+	mutex_init(&dev->mlx5e_res.uplink_netdev_lock);
 
 	mutex_init(&priv->bfregs.reg_head.lock);
 	mutex_init(&priv->bfregs.wc_head.lock);
@@ -1696,6 +1715,7 @@ void mlx5_mdev_uninit(struct mlx5_core_dev *dev)
 	mutex_destroy(&priv->alloc_mutex);
 	mutex_destroy(&priv->bfregs.wc_head.lock);
 	mutex_destroy(&priv->bfregs.reg_head.lock);
+	mutex_destroy(&dev->mlx5e_res.uplink_netdev_lock);
 	mutex_destroy(&dev->intf_state_mutex);
 	lockdep_unregister_key(&dev->lock_key);
 }
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 29d4b201c7b2..f2b271169daf 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -362,6 +362,7 @@ enum mlx5_event {
 
 enum mlx5_driver_event {
 	MLX5_DRIVER_EVENT_TYPE_TRAP = 0,
+	MLX5_DRIVER_EVENT_UPLINK_NETDEV,
 };
 
 enum {
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index d476255c9a3f..cc48aa308269 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -49,6 +49,7 @@
 #include <linux/notifier.h>
 #include <linux/refcount.h>
 #include <linux/auxiliary_bus.h>
+#include <linux/mutex.h>
 
 #include <linux/mlx5/device.h>
 #include <linux/mlx5/doorbell.h>
@@ -674,6 +675,7 @@ struct mlx5e_resources {
 	} hw_objs;
 	struct devlink_port dl_port;
 	struct net_device *uplink_netdev;
+	struct mutex uplink_netdev_lock;
 };
 
 enum mlx5_sw_icm_type {
@@ -1011,6 +1013,9 @@ int mlx5_cmd_exec_polling(struct mlx5_core_dev *dev, void *in, int in_size,
 			  void *out, int out_size);
 bool mlx5_cmd_is_down(struct mlx5_core_dev *dev);
 
+void mlx5_core_uplink_netdev_set(struct mlx5_core_dev *mdev, struct net_device *netdev);
+void mlx5_core_uplink_netdev_event_replay(struct mlx5_core_dev *mdev);
+
 int mlx5_core_get_caps(struct mlx5_core_dev *dev, enum mlx5_cap_type cap_type);
 void mlx5_health_cleanup(struct mlx5_core_dev *dev);
 int mlx5_health_init(struct mlx5_core_dev *dev);
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index ba6958b49a8e..d72a09a3798c 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -51,6 +51,7 @@ enum mlx5_flow_destination_type {
 	MLX5_FLOW_DESTINATION_TYPE_COUNTER,
 	MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE_NUM,
 	MLX5_FLOW_DESTINATION_TYPE_RANGE,
+	MLX5_FLOW_DESTINATION_TYPE_TABLE_TYPE,
 };
 
 enum {
@@ -102,6 +103,8 @@ enum mlx5_flow_namespace_type {
 	MLX5_FLOW_NAMESPACE_PORT_SEL,
 	MLX5_FLOW_NAMESPACE_RDMA_RX_COUNTERS,
 	MLX5_FLOW_NAMESPACE_RDMA_TX_COUNTERS,
+	MLX5_FLOW_NAMESPACE_RDMA_RX_IPSEC,
+	MLX5_FLOW_NAMESPACE_RDMA_TX_IPSEC,
 };
 
 enum {
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index a9ee7bc59c90..c3d3a2eef7d4 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -315,6 +315,11 @@ enum {
 	MLX5_CMD_OP_GENERAL_END = 0xd00,
 };
 
+enum {
+	MLX5_FT_NIC_RX_2_NIC_RX_RDMA = BIT(0),
+	MLX5_FT_NIC_TX_RDMA_2_NIC_TX = BIT(1),
+};
+
 struct mlx5_ifc_flow_table_fields_supported_bits {
 	u8         outer_dmac[0x1];
 	u8         outer_smac[0x1];
@@ -1496,7 +1501,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         null_mkey[0x1];
 	u8         log_max_klm_list_size[0x6];
 
-	u8         reserved_at_120[0xa];
+	u8         reserved_at_120[0x2];
+	u8	   qpc_extension[0x1];
+	u8	   reserved_at_123[0x7];
 	u8         log_max_ra_req_dc[0x6];
 	u8         reserved_at_130[0x2];
 	u8         eth_wqe_too_small[0x1];
@@ -1662,7 +1669,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 
 	u8         log_bf_reg_size[0x5];
 
-	u8         reserved_at_270[0x6];
+	u8         reserved_at_270[0x3];
+	u8	   qp_error_syndrome[0x1];
+	u8	   reserved_at_274[0x2];
 	u8         lag_dct[0x2];
 	u8         lag_tx_port_affinity[0x1];
 	u8         lag_native_fdb_selection[0x1];
@@ -1899,7 +1908,8 @@ struct mlx5_ifc_cmd_hca_cap_2_bits {
 
 	u8	   reserved_at_e0[0xc0];
 
-	u8	   reserved_at_1a0[0xb];
+	u8	   flow_table_type_2_type[0x8];
+	u8	   reserved_at_1a8[0x3];
 	u8	   log_min_mkey_entity_size[0x5];
 	u8	   reserved_at_1b0[0x10];
 
@@ -1923,6 +1933,7 @@ enum mlx5_ifc_flow_destination_type {
 	MLX5_IFC_FLOW_DESTINATION_TYPE_TIR          = 0x2,
 	MLX5_IFC_FLOW_DESTINATION_TYPE_FLOW_SAMPLER = 0x6,
 	MLX5_IFC_FLOW_DESTINATION_TYPE_UPLINK       = 0x8,
+	MLX5_IFC_FLOW_DESTINATION_TYPE_TABLE_TYPE   = 0xA,
 };
 
 enum mlx5_flow_table_miss_action {
@@ -1937,7 +1948,8 @@ struct mlx5_ifc_dest_format_struct_bits {
 
 	u8         destination_eswitch_owner_vhca_id_valid[0x1];
 	u8         packet_reformat[0x1];
-	u8         reserved_at_22[0xe];
+	u8         reserved_at_22[0x6];
+	u8         destination_table_type[0x8];
 	u8         destination_eswitch_owner_vhca_id[0x10];
 };
 
@@ -5342,6 +5354,37 @@ struct mlx5_ifc_query_rmp_in_bits {
 	u8         reserved_at_60[0x20];
 };
 
+struct mlx5_ifc_cqe_error_syndrome_bits {
+	u8         hw_error_syndrome[0x8];
+	u8         hw_syndrome_type[0x4];
+	u8         reserved_at_c[0x4];
+	u8         vendor_error_syndrome[0x8];
+	u8         syndrome[0x8];
+};
+
+struct mlx5_ifc_qp_context_extension_bits {
+	u8         reserved_at_0[0x60];
+
+	struct mlx5_ifc_cqe_error_syndrome_bits error_syndrome;
+
+	u8         reserved_at_80[0x580];
+};
+
+struct mlx5_ifc_qpc_extension_and_pas_list_in_bits {
+	struct mlx5_ifc_qp_context_extension_bits qpc_data_extension;
+
+	u8         pas[0][0x40];
+};
+
+struct mlx5_ifc_qp_pas_list_in_bits {
+	struct mlx5_ifc_cmd_pas_bits pas[0];
+};
+
+union mlx5_ifc_qp_pas_or_qpc_ext_and_pas_bits {
+	struct mlx5_ifc_qp_pas_list_in_bits qp_pas_list;
+	struct mlx5_ifc_qpc_extension_and_pas_list_in_bits qpc_ext_and_pas_list;
+};
+
 struct mlx5_ifc_query_qp_out_bits {
 	u8         status[0x8];
 	u8         reserved_at_8[0x18];
@@ -5358,7 +5401,7 @@ struct mlx5_ifc_query_qp_out_bits {
 
 	u8         reserved_at_800[0x80];
 
-	u8         pas[][0x40];
+	union mlx5_ifc_qp_pas_or_qpc_ext_and_pas_bits qp_pas_or_qpc_ext_and_pas;
 };
 
 struct mlx5_ifc_query_qp_in_bits {
@@ -5368,7 +5411,8 @@ struct mlx5_ifc_query_qp_in_bits {
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
 
-	u8         reserved_at_40[0x8];
+	u8         qpc_ext[0x1];
+	u8         reserved_at_41[0x7];
 	u8         qpn[0x18];
 
 	u8         reserved_at_60[0x20];
@@ -8571,7 +8615,8 @@ struct mlx5_ifc_create_qp_in_bits {
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
 
-	u8         reserved_at_40[0x8];
+	u8         qpc_ext[0x1];
+	u8         reserved_at_41[0x7];
 	u8         input_qpn[0x18];
 
 	u8         reserved_at_60[0x20];
