Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50E10464956
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 09:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347848AbhLAIRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 03:17:01 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41771 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347868AbhLAIQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 03:16:55 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id CA06A5C01DC;
        Wed,  1 Dec 2021 03:13:34 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 01 Dec 2021 03:13:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=LiB1conouIs+xjvfCkHs+k2wZ4hG++lkUo2zoiorwyE=; b=d9kJ2uBM
        HGxbpPLH3OnFlI8mCt/h50BHHOMYmzZmSnUYQG8naYib1E03OTQScbWE0FftWPGJ
        PXySkKdfwnBk+B5Jg+d/x6o/WUwyJjlwxDs2mBTUOyI/evgNen8N5KhbN292gPMd
        3ii/3dMxj28+IHvWQWZlZqKpit2UeLtz5vD20adpBWdWwrLhHtiSWPd+TSXnXeQP
        28UcpBZbUeNey8ECRJ7bmKP/DlV4i1b0ZoDSyIU219baXJz0K9VFHh6xA5LCFa/J
        vjYuwHhaApOKfmqkVT+esLo0RxD7SA/TRr+pn0GphsBzRDCeL4v5qi/+1pjlgBb4
        QRmBdMtcqTUMPw==
X-ME-Sender: <xms:ri6nYTid6EYjOAgPJ1yxncvCH2t6krdGdOiDVzMuLcP5CcOFWgTwXg>
    <xme:ri6nYQBd4fVCMfP91lymUPPJERJCWckuvYlaQrAzWOQcvLYBHkJzdW5GykawfVgpj
    O914sAlUmG_gd0>
X-ME-Received: <xmr:ri6nYTHx4t0fUzqF8vvpBciEkfDtrNyN2FXo0295Ng29VTxetQ_04fbcBNelctjIZ-VNvvrd8cYkJh7MTfdJN9HEyuTfs79UsYnRHGWLhwu_vQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddriedvgdduudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepudenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:ri6nYQQkYnry30ZrgRQMteQEheMWTct_NqFvpnA4nNkoqq_V0mzUfA>
    <xmx:ri6nYQyyGDCKsfCADBpoqPz2gPfoMRNzZaqrW_74-plS2dXbP1-0dQ>
    <xmx:ri6nYW4zcbbIMmgeYJGVLgDpntA3T3qJrfe0geu223kRQceZydwCjA>
    <xmx:ri6nYatpIi9gRr4CZgiuD-a9ILX6ktq00qBc8Hz65xqoDC96js5XFg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 1 Dec 2021 03:13:31 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 07/10] mlxsw: Use u16 for local_port field instead of u8
Date:   Wed,  1 Dec 2021 10:12:37 +0200
Message-Id: <20211201081240.3767366-8-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211201081240.3767366-1-idosch@idosch.org>
References: <20211201081240.3767366-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Currently, local_port field is saved as u8, which means that maximum 256
ports can be used.

As preparation for Spectrum-4, which will support more than 256 ports,
local_port field should be extended.

Save local_port as u16 to allow use of additional ports.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  42 +++----
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  44 +++----
 .../mellanox/mlxsw/core_acl_flex_actions.c    |  22 ++--
 .../mellanox/mlxsw/core_acl_flex_actions.h    |  16 +--
 drivers/net/ethernet/mellanox/mlxsw/minimal.c |  10 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 112 +++++++++---------
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  48 ++++----
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  20 ++--
 .../ethernet/mellanox/mlxsw/spectrum_acl.c    |   2 +-
 .../mlxsw/spectrum_acl_flex_actions.c         |  14 +--
 .../mellanox/mlxsw/spectrum_buffers.c         |  38 +++---
 .../mellanox/mlxsw/spectrum_ethtool.c         |   4 +-
 .../ethernet/mellanox/mlxsw/spectrum_fid.c    |  12 +-
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    |  12 +-
 .../ethernet/mellanox/mlxsw/spectrum_ptp.h    |  16 +--
 .../ethernet/mellanox/mlxsw/spectrum_router.c |   2 +-
 .../ethernet/mellanox/mlxsw/spectrum_span.c   |  20 ++--
 .../mellanox/mlxsw/spectrum_switchdev.c       |  10 +-
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   |  24 ++--
 19 files changed, 234 insertions(+), 234 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 0d1f08bbf631..7e89d5980d5e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -47,7 +47,7 @@ static struct workqueue_struct *mlxsw_owq;
 struct mlxsw_core_port {
 	struct devlink_port devlink_port;
 	void *port_driver_priv;
-	u8 local_port;
+	u16 local_port;
 };
 
 void *mlxsw_core_port_driver_priv(struct mlxsw_core_port *mlxsw_core_port)
@@ -77,7 +77,7 @@ struct mlxsw_core {
 		bool enable_string_tlv;
 	} emad;
 	struct {
-		u8 *mapping; /* lag_id+port_index to local_port mapping */
+		u16 *mapping; /* lag_id+port_index to local_port mapping */
 	} lag;
 	struct mlxsw_res res;
 	struct mlxsw_hwmon *hwmon;
@@ -718,7 +718,7 @@ static void mlxsw_emad_process_response(struct mlxsw_core *mlxsw_core,
 }
 
 /* called with rcu read lock held */
-static void mlxsw_emad_rx_listener_func(struct sk_buff *skb, u8 local_port,
+static void mlxsw_emad_rx_listener_func(struct sk_buff *skb, u16 local_port,
 					void *priv)
 {
 	struct mlxsw_core *mlxsw_core = priv;
@@ -1959,7 +1959,7 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 
 	if (MLXSW_CORE_RES_VALID(mlxsw_core, MAX_LAG) &&
 	    MLXSW_CORE_RES_VALID(mlxsw_core, MAX_LAG_MEMBERS)) {
-		alloc_size = sizeof(u8) *
+		alloc_size = sizeof(*mlxsw_core->lag.mapping) *
 			MLXSW_CORE_RES_GET(mlxsw_core, MAX_LAG) *
 			MLXSW_CORE_RES_GET(mlxsw_core, MAX_LAG_MEMBERS);
 		mlxsw_core->lag.mapping = kzalloc(alloc_size, GFP_KERNEL);
@@ -2130,7 +2130,7 @@ int mlxsw_core_skb_transmit(struct mlxsw_core *mlxsw_core, struct sk_buff *skb,
 EXPORT_SYMBOL(mlxsw_core_skb_transmit);
 
 void mlxsw_core_ptp_transmitted(struct mlxsw_core *mlxsw_core,
-				struct sk_buff *skb, u8 local_port)
+				struct sk_buff *skb, u16 local_port)
 {
 	if (mlxsw_core->driver->ptp_transmitted)
 		mlxsw_core->driver->ptp_transmitted(mlxsw_core, skb,
@@ -2208,7 +2208,7 @@ mlxsw_core_rx_listener_state_set(struct mlxsw_core *mlxsw_core,
 	rxl_item->enabled = enabled;
 }
 
-static void mlxsw_core_event_listener_func(struct sk_buff *skb, u8 local_port,
+static void mlxsw_core_event_listener_func(struct sk_buff *skb, u16 local_port,
 					   void *priv)
 {
 	struct mlxsw_event_listener_item *event_listener_item = priv;
@@ -2641,7 +2641,7 @@ void mlxsw_core_skb_receive(struct mlxsw_core *mlxsw_core, struct sk_buff *skb,
 {
 	struct mlxsw_rx_listener_item *rxl_item;
 	const struct mlxsw_rx_listener *rxl;
-	u8 local_port;
+	u16 local_port;
 	bool found = false;
 
 	if (rx_info->is_lag) {
@@ -2699,7 +2699,7 @@ static int mlxsw_core_lag_mapping_index(struct mlxsw_core *mlxsw_core,
 }
 
 void mlxsw_core_lag_mapping_set(struct mlxsw_core *mlxsw_core,
-				u16 lag_id, u8 port_index, u8 local_port)
+				u16 lag_id, u8 port_index, u16 local_port)
 {
 	int index = mlxsw_core_lag_mapping_index(mlxsw_core,
 						 lag_id, port_index);
@@ -2708,8 +2708,8 @@ void mlxsw_core_lag_mapping_set(struct mlxsw_core *mlxsw_core,
 }
 EXPORT_SYMBOL(mlxsw_core_lag_mapping_set);
 
-u8 mlxsw_core_lag_mapping_get(struct mlxsw_core *mlxsw_core,
-			      u16 lag_id, u8 port_index)
+u16 mlxsw_core_lag_mapping_get(struct mlxsw_core *mlxsw_core,
+			       u16 lag_id, u8 port_index)
 {
 	int index = mlxsw_core_lag_mapping_index(mlxsw_core,
 						 lag_id, port_index);
@@ -2719,7 +2719,7 @@ u8 mlxsw_core_lag_mapping_get(struct mlxsw_core *mlxsw_core,
 EXPORT_SYMBOL(mlxsw_core_lag_mapping_get);
 
 void mlxsw_core_lag_mapping_clear(struct mlxsw_core *mlxsw_core,
-				  u16 lag_id, u8 local_port)
+				  u16 lag_id, u16 local_port)
 {
 	int i;
 
@@ -2747,7 +2747,7 @@ u64 mlxsw_core_res_get(struct mlxsw_core *mlxsw_core,
 }
 EXPORT_SYMBOL(mlxsw_core_res_get);
 
-static int __mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
+static int __mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u16 local_port,
 				  enum devlink_port_flavour flavour,
 				  u32 port_number, bool split,
 				  u32 split_port_subnumber,
@@ -2778,7 +2778,7 @@ static int __mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
 	return err;
 }
 
-static void __mlxsw_core_port_fini(struct mlxsw_core *mlxsw_core, u8 local_port)
+static void __mlxsw_core_port_fini(struct mlxsw_core *mlxsw_core, u16 local_port)
 {
 	struct mlxsw_core_port *mlxsw_core_port =
 					&mlxsw_core->ports[local_port];
@@ -2788,7 +2788,7 @@ static void __mlxsw_core_port_fini(struct mlxsw_core *mlxsw_core, u8 local_port)
 	memset(mlxsw_core_port, 0, sizeof(*mlxsw_core_port));
 }
 
-int mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
+int mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u16 local_port,
 			 u32 port_number, bool split,
 			 u32 split_port_subnumber,
 			 bool splittable, u32 lanes,
@@ -2810,7 +2810,7 @@ int mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
 }
 EXPORT_SYMBOL(mlxsw_core_port_init);
 
-void mlxsw_core_port_fini(struct mlxsw_core *mlxsw_core, u8 local_port)
+void mlxsw_core_port_fini(struct mlxsw_core *mlxsw_core, u16 local_port)
 {
 	atomic_dec(&mlxsw_core->active_ports_count);
 
@@ -2845,7 +2845,7 @@ void mlxsw_core_cpu_port_fini(struct mlxsw_core *mlxsw_core)
 }
 EXPORT_SYMBOL(mlxsw_core_cpu_port_fini);
 
-void mlxsw_core_port_eth_set(struct mlxsw_core *mlxsw_core, u8 local_port,
+void mlxsw_core_port_eth_set(struct mlxsw_core *mlxsw_core, u16 local_port,
 			     void *port_driver_priv, struct net_device *dev)
 {
 	struct mlxsw_core_port *mlxsw_core_port =
@@ -2857,7 +2857,7 @@ void mlxsw_core_port_eth_set(struct mlxsw_core *mlxsw_core, u8 local_port,
 }
 EXPORT_SYMBOL(mlxsw_core_port_eth_set);
 
-void mlxsw_core_port_ib_set(struct mlxsw_core *mlxsw_core, u8 local_port,
+void mlxsw_core_port_ib_set(struct mlxsw_core *mlxsw_core, u16 local_port,
 			    void *port_driver_priv)
 {
 	struct mlxsw_core_port *mlxsw_core_port =
@@ -2869,7 +2869,7 @@ void mlxsw_core_port_ib_set(struct mlxsw_core *mlxsw_core, u8 local_port,
 }
 EXPORT_SYMBOL(mlxsw_core_port_ib_set);
 
-void mlxsw_core_port_clear(struct mlxsw_core *mlxsw_core, u8 local_port,
+void mlxsw_core_port_clear(struct mlxsw_core *mlxsw_core, u16 local_port,
 			   void *port_driver_priv)
 {
 	struct mlxsw_core_port *mlxsw_core_port =
@@ -2882,7 +2882,7 @@ void mlxsw_core_port_clear(struct mlxsw_core *mlxsw_core, u8 local_port,
 EXPORT_SYMBOL(mlxsw_core_port_clear);
 
 enum devlink_port_type mlxsw_core_port_type_get(struct mlxsw_core *mlxsw_core,
-						u8 local_port)
+						u16 local_port)
 {
 	struct mlxsw_core_port *mlxsw_core_port =
 					&mlxsw_core->ports[local_port];
@@ -2895,7 +2895,7 @@ EXPORT_SYMBOL(mlxsw_core_port_type_get);
 
 struct devlink_port *
 mlxsw_core_port_devlink_port_get(struct mlxsw_core *mlxsw_core,
-				 u8 local_port)
+				 u16 local_port)
 {
 	struct mlxsw_core_port *mlxsw_core_port =
 					&mlxsw_core->ports[local_port];
@@ -2905,7 +2905,7 @@ mlxsw_core_port_devlink_port_get(struct mlxsw_core *mlxsw_core,
 }
 EXPORT_SYMBOL(mlxsw_core_port_devlink_port_get);
 
-bool mlxsw_core_port_is_xm(const struct mlxsw_core *mlxsw_core, u8 local_port)
+bool mlxsw_core_port_is_xm(const struct mlxsw_core *mlxsw_core, u16 local_port)
 {
 	const struct mlxsw_bus_info *bus_info = mlxsw_core->bus_info;
 	int i;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 12023a550007..f30bb8614e69 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -54,7 +54,7 @@ int mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 void mlxsw_core_bus_device_unregister(struct mlxsw_core *mlxsw_core, bool reload);
 
 struct mlxsw_tx_info {
-	u8 local_port;
+	u16 local_port;
 	bool is_emad;
 };
 
@@ -67,7 +67,7 @@ struct mlxsw_rx_md_info {
 		u16 tx_sys_port;
 		u16 tx_lag_id;
 	};
-	u8 tx_lag_port_index; /* Valid when 'tx_port_is_lag' is set. */
+	u16 tx_lag_port_index; /* Valid when 'tx_port_is_lag' is set. */
 	u8 tx_tc;
 	u8 latency_valid:1,
 	   tx_congestion_valid:1,
@@ -82,11 +82,11 @@ bool mlxsw_core_skb_transmit_busy(struct mlxsw_core *mlxsw_core,
 int mlxsw_core_skb_transmit(struct mlxsw_core *mlxsw_core, struct sk_buff *skb,
 			    const struct mlxsw_tx_info *tx_info);
 void mlxsw_core_ptp_transmitted(struct mlxsw_core *mlxsw_core,
-				struct sk_buff *skb, u8 local_port);
+				struct sk_buff *skb, u16 local_port);
 
 struct mlxsw_rx_listener {
-	void (*func)(struct sk_buff *skb, u8 local_port, void *priv);
-	u8 local_port;
+	void (*func)(struct sk_buff *skb, u16 local_port, void *priv);
+	u16 local_port;
 	u8 mirror_reason;
 	u16 trap_id;
 };
@@ -209,7 +209,7 @@ struct mlxsw_rx_info {
 		u16 sys_port;
 		u16 lag_id;
 	} u;
-	u8 lag_port_index;
+	u16 lag_port_index;
 	u8 mirror_reason;
 	int trap_id;
 };
@@ -218,36 +218,36 @@ void mlxsw_core_skb_receive(struct mlxsw_core *mlxsw_core, struct sk_buff *skb,
 			    struct mlxsw_rx_info *rx_info);
 
 void mlxsw_core_lag_mapping_set(struct mlxsw_core *mlxsw_core,
-				u16 lag_id, u8 port_index, u8 local_port);
-u8 mlxsw_core_lag_mapping_get(struct mlxsw_core *mlxsw_core,
-			      u16 lag_id, u8 port_index);
+				u16 lag_id, u8 port_index, u16 local_port);
+u16 mlxsw_core_lag_mapping_get(struct mlxsw_core *mlxsw_core,
+			       u16 lag_id, u8 port_index);
 void mlxsw_core_lag_mapping_clear(struct mlxsw_core *mlxsw_core,
-				  u16 lag_id, u8 local_port);
+				  u16 lag_id, u16 local_port);
 
 void *mlxsw_core_port_driver_priv(struct mlxsw_core_port *mlxsw_core_port);
-int mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
+int mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u16 local_port,
 			 u32 port_number, bool split, u32 split_port_subnumber,
 			 bool splittable, u32 lanes,
 			 const unsigned char *switch_id,
 			 unsigned char switch_id_len);
-void mlxsw_core_port_fini(struct mlxsw_core *mlxsw_core, u8 local_port);
+void mlxsw_core_port_fini(struct mlxsw_core *mlxsw_core, u16 local_port);
 int mlxsw_core_cpu_port_init(struct mlxsw_core *mlxsw_core,
 			     void *port_driver_priv,
 			     const unsigned char *switch_id,
 			     unsigned char switch_id_len);
 void mlxsw_core_cpu_port_fini(struct mlxsw_core *mlxsw_core);
-void mlxsw_core_port_eth_set(struct mlxsw_core *mlxsw_core, u8 local_port,
+void mlxsw_core_port_eth_set(struct mlxsw_core *mlxsw_core, u16 local_port,
 			     void *port_driver_priv, struct net_device *dev);
-void mlxsw_core_port_ib_set(struct mlxsw_core *mlxsw_core, u8 local_port,
+void mlxsw_core_port_ib_set(struct mlxsw_core *mlxsw_core, u16 local_port,
 			    void *port_driver_priv);
-void mlxsw_core_port_clear(struct mlxsw_core *mlxsw_core, u8 local_port,
+void mlxsw_core_port_clear(struct mlxsw_core *mlxsw_core, u16 local_port,
 			   void *port_driver_priv);
 enum devlink_port_type mlxsw_core_port_type_get(struct mlxsw_core *mlxsw_core,
-						u8 local_port);
+						u16 local_port);
 struct devlink_port *
 mlxsw_core_port_devlink_port_get(struct mlxsw_core *mlxsw_core,
-				 u8 local_port);
-bool mlxsw_core_port_is_xm(const struct mlxsw_core *mlxsw_core, u8 local_port);
+				 u16 local_port);
+bool mlxsw_core_port_is_xm(const struct mlxsw_core *mlxsw_core, u16 local_port);
 struct mlxsw_env *mlxsw_core_env(const struct mlxsw_core *mlxsw_core);
 
 int mlxsw_core_schedule_dw(struct delayed_work *dwork, unsigned long delay);
@@ -316,11 +316,11 @@ struct mlxsw_driver {
 		    struct netlink_ext_ack *extack);
 	void (*fini)(struct mlxsw_core *mlxsw_core);
 	int (*basic_trap_groups_set)(struct mlxsw_core *mlxsw_core);
-	int (*port_type_set)(struct mlxsw_core *mlxsw_core, u8 local_port,
+	int (*port_type_set)(struct mlxsw_core *mlxsw_core, u16 local_port,
 			     enum devlink_port_type new_type);
-	int (*port_split)(struct mlxsw_core *mlxsw_core, u8 local_port,
+	int (*port_split)(struct mlxsw_core *mlxsw_core, u16 local_port,
 			  unsigned int count, struct netlink_ext_ack *extack);
-	int (*port_unsplit)(struct mlxsw_core *mlxsw_core, u8 local_port,
+	int (*port_unsplit)(struct mlxsw_core *mlxsw_core, u16 local_port,
 			    struct netlink_ext_ack *extack);
 	int (*sb_pool_get)(struct mlxsw_core *mlxsw_core,
 			   unsigned int sb_index, u16 pool_index,
@@ -394,7 +394,7 @@ struct mlxsw_driver {
 	 * is responsible for freeing the passed-in SKB.
 	 */
 	void (*ptp_transmitted)(struct mlxsw_core *mlxsw_core,
-				struct sk_buff *skb, u8 local_port);
+				struct sk_buff *skb, u16 local_port);
 
 	u8 txhdr_len;
 	const struct mlxsw_config_profile *profile;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
index 78d9c0196f2b..77e82e6cf6e8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
@@ -113,7 +113,7 @@ static const struct rhashtable_params mlxsw_afa_set_ht_params = {
 };
 
 struct mlxsw_afa_fwd_entry_ht_key {
-	u8 local_port;
+	u16 local_port;
 };
 
 struct mlxsw_afa_fwd_entry {
@@ -555,7 +555,7 @@ int mlxsw_afa_block_terminate(struct mlxsw_afa_block *block)
 EXPORT_SYMBOL(mlxsw_afa_block_terminate);
 
 static struct mlxsw_afa_fwd_entry *
-mlxsw_afa_fwd_entry_create(struct mlxsw_afa *mlxsw_afa, u8 local_port)
+mlxsw_afa_fwd_entry_create(struct mlxsw_afa *mlxsw_afa, u16 local_port)
 {
 	struct mlxsw_afa_fwd_entry *fwd_entry;
 	int err;
@@ -598,7 +598,7 @@ static void mlxsw_afa_fwd_entry_destroy(struct mlxsw_afa *mlxsw_afa,
 }
 
 static struct mlxsw_afa_fwd_entry *
-mlxsw_afa_fwd_entry_get(struct mlxsw_afa *mlxsw_afa, u8 local_port)
+mlxsw_afa_fwd_entry_get(struct mlxsw_afa *mlxsw_afa, u16 local_port)
 {
 	struct mlxsw_afa_fwd_entry_ht_key ht_key = {0};
 	struct mlxsw_afa_fwd_entry *fwd_entry;
@@ -647,7 +647,7 @@ mlxsw_afa_fwd_entry_ref_destructor(struct mlxsw_afa_block *block,
 }
 
 static struct mlxsw_afa_fwd_entry_ref *
-mlxsw_afa_fwd_entry_ref_create(struct mlxsw_afa_block *block, u8 local_port)
+mlxsw_afa_fwd_entry_ref_create(struct mlxsw_afa_block *block, u16 local_port)
 {
 	struct mlxsw_afa_fwd_entry_ref *fwd_entry_ref;
 	struct mlxsw_afa_fwd_entry *fwd_entry;
@@ -1352,7 +1352,7 @@ EXPORT_SYMBOL(mlxsw_afa_block_append_trap_and_forward);
 struct mlxsw_afa_mirror {
 	struct mlxsw_afa_resource resource;
 	int span_id;
-	u8 local_in_port;
+	u16 local_in_port;
 	bool ingress;
 };
 
@@ -1379,7 +1379,7 @@ mlxsw_afa_mirror_destructor(struct mlxsw_afa_block *block,
 }
 
 static struct mlxsw_afa_mirror *
-mlxsw_afa_mirror_create(struct mlxsw_afa_block *block, u8 local_in_port,
+mlxsw_afa_mirror_create(struct mlxsw_afa_block *block, u16 local_in_port,
 			const struct net_device *out_dev, bool ingress)
 {
 	struct mlxsw_afa_mirror *mirror;
@@ -1423,7 +1423,7 @@ mlxsw_afa_block_append_allocated_mirror(struct mlxsw_afa_block *block,
 }
 
 int
-mlxsw_afa_block_append_mirror(struct mlxsw_afa_block *block, u8 local_in_port,
+mlxsw_afa_block_append_mirror(struct mlxsw_afa_block *block, u16 local_in_port,
 			      const struct net_device *out_dev, bool ingress,
 			      struct netlink_ext_ack *extack)
 {
@@ -1663,7 +1663,7 @@ mlxsw_afa_forward_pack(char *payload, enum mlxsw_afa_forward_type type,
 }
 
 int mlxsw_afa_block_append_fwd(struct mlxsw_afa_block *block,
-			       u8 local_port, bool in_port,
+			       u16 local_port, bool in_port,
 			       struct netlink_ext_ack *extack)
 {
 	struct mlxsw_afa_fwd_entry_ref *fwd_entry_ref;
@@ -2038,7 +2038,7 @@ static void mlxsw_afa_sampler_pack(char *payload, u8 mirror_agent, u32 rate)
 struct mlxsw_afa_sampler {
 	struct mlxsw_afa_resource resource;
 	int span_id;
-	u8 local_port;
+	u16 local_port;
 	bool ingress;
 };
 
@@ -2061,7 +2061,7 @@ static void mlxsw_afa_sampler_destructor(struct mlxsw_afa_block *block,
 }
 
 static struct mlxsw_afa_sampler *
-mlxsw_afa_sampler_create(struct mlxsw_afa_block *block, u8 local_port,
+mlxsw_afa_sampler_create(struct mlxsw_afa_block *block, u16 local_port,
 			 struct psample_group *psample_group, u32 rate,
 			 u32 trunc_size, bool truncate, bool ingress,
 			 struct netlink_ext_ack *extack)
@@ -2104,7 +2104,7 @@ mlxsw_afa_block_append_allocated_sampler(struct mlxsw_afa_block *block,
 	return 0;
 }
 
-int mlxsw_afa_block_append_sampler(struct mlxsw_afa_block *block, u8 local_port,
+int mlxsw_afa_block_append_sampler(struct mlxsw_afa_block *block, u16 local_port,
 				   struct psample_group *psample_group,
 				   u32 rate, u32 trunc_size, bool truncate,
 				   bool ingress,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h
index b65bf98eb5ab..16cbd6acbb01 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h
@@ -17,24 +17,24 @@ struct mlxsw_afa_ops {
 	void (*kvdl_set_del)(void *priv, u32 kvdl_index, bool is_first);
 	int (*kvdl_set_activity_get)(void *priv, u32 kvdl_index,
 				     bool *activity);
-	int (*kvdl_fwd_entry_add)(void *priv, u32 *p_kvdl_index, u8 local_port);
+	int (*kvdl_fwd_entry_add)(void *priv, u32 *p_kvdl_index, u16 local_port);
 	void (*kvdl_fwd_entry_del)(void *priv, u32 kvdl_index);
 	int (*counter_index_get)(void *priv, unsigned int *p_counter_index);
 	void (*counter_index_put)(void *priv, unsigned int counter_index);
-	int (*mirror_add)(void *priv, u8 local_in_port,
+	int (*mirror_add)(void *priv, u16 local_in_port,
 			  const struct net_device *out_dev,
 			  bool ingress, int *p_span_id);
-	void (*mirror_del)(void *priv, u8 local_in_port, int span_id,
+	void (*mirror_del)(void *priv, u16 local_in_port, int span_id,
 			   bool ingress);
 	int (*policer_add)(void *priv, u64 rate_bytes_ps, u32 burst,
 			   u16 *p_policer_index,
 			   struct netlink_ext_ack *extack);
 	void (*policer_del)(void *priv, u16 policer_index);
-	int (*sampler_add)(void *priv, u8 local_port,
+	int (*sampler_add)(void *priv, u16 local_port,
 			   struct psample_group *psample_group, u32 rate,
 			   u32 trunc_size, bool truncate, bool ingress,
 			   int *p_span_id, struct netlink_ext_ack *extack);
-	void (*sampler_del)(void *priv, u8 local_port, int span_id,
+	void (*sampler_del)(void *priv, u16 local_port, int span_id,
 			    bool ingress);
 	bool dummy_first_set;
 };
@@ -62,12 +62,12 @@ int mlxsw_afa_block_append_trap(struct mlxsw_afa_block *block, u16 trap_id);
 int mlxsw_afa_block_append_trap_and_forward(struct mlxsw_afa_block *block,
 					    u16 trap_id);
 int mlxsw_afa_block_append_mirror(struct mlxsw_afa_block *block,
-				  u8 local_in_port,
+				  u16 local_in_port,
 				  const struct net_device *out_dev,
 				  bool ingress,
 				  struct netlink_ext_ack *extack);
 int mlxsw_afa_block_append_fwd(struct mlxsw_afa_block *block,
-			       u8 local_port, bool in_port,
+			       u16 local_port, bool in_port,
 			       struct netlink_ext_ack *extack);
 int mlxsw_afa_block_append_vlan_modify(struct mlxsw_afa_block *block,
 				       u16 vid, u8 pcp, u8 et,
@@ -98,7 +98,7 @@ int mlxsw_afa_block_append_police(struct mlxsw_afa_block *block,
 				  u32 fa_index, u64 rate_bytes_ps, u32 burst,
 				  u16 *p_policer_index,
 				  struct netlink_ext_ack *extack);
-int mlxsw_afa_block_append_sampler(struct mlxsw_afa_block *block, u8 local_port,
+int mlxsw_afa_block_append_sampler(struct mlxsw_afa_block *block, u16 local_port,
 				   struct psample_group *psample_group,
 				   u32 rate, u32 trunc_size, bool truncate,
 				   bool ingress,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index 5d4dfa5ddbb5..10d13f5f9c7d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -38,7 +38,7 @@ struct mlxsw_m {
 struct mlxsw_m_port {
 	struct net_device *dev;
 	struct mlxsw_m *mlxsw_m;
-	u8 local_port;
+	u16 local_port;
 	u8 module;
 };
 
@@ -180,7 +180,7 @@ static const struct ethtool_ops mlxsw_m_port_ethtool_ops = {
 };
 
 static int
-mlxsw_m_port_module_info_get(struct mlxsw_m *mlxsw_m, u8 local_port,
+mlxsw_m_port_module_info_get(struct mlxsw_m *mlxsw_m, u16 local_port,
 			     u8 *p_module, u8 *p_width)
 {
 	char pmlp_pl[MLXSW_REG_PMLP_LEN];
@@ -214,7 +214,7 @@ mlxsw_m_port_dev_addr_get(struct mlxsw_m_port *mlxsw_m_port)
 }
 
 static int
-mlxsw_m_port_create(struct mlxsw_m *mlxsw_m, u8 local_port, u8 module)
+mlxsw_m_port_create(struct mlxsw_m *mlxsw_m, u16 local_port, u8 module)
 {
 	struct mlxsw_m_port *mlxsw_m_port;
 	struct net_device *dev;
@@ -277,7 +277,7 @@ mlxsw_m_port_create(struct mlxsw_m *mlxsw_m, u8 local_port, u8 module)
 	return err;
 }
 
-static void mlxsw_m_port_remove(struct mlxsw_m *mlxsw_m, u8 local_port)
+static void mlxsw_m_port_remove(struct mlxsw_m *mlxsw_m, u16 local_port)
 {
 	struct mlxsw_m_port *mlxsw_m_port = mlxsw_m->ports[local_port];
 
@@ -288,7 +288,7 @@ static void mlxsw_m_port_remove(struct mlxsw_m *mlxsw_m, u8 local_port)
 	mlxsw_core_port_fini(mlxsw_m->core, local_port);
 }
 
-static int mlxsw_m_port_module_map(struct mlxsw_m *mlxsw_m, u8 local_port,
+static int mlxsw_m_port_module_map(struct mlxsw_m *mlxsw_m, u16 local_port,
 				   u8 *last_module)
 {
 	unsigned int max_ports = mlxsw_core_max_ports(mlxsw_m->core);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index e908abb4b802..1e182069ba91 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -161,7 +161,7 @@ MLXSW_ITEM32(reg, sspr, sub_port, 0x00, 8, 8);
  */
 MLXSW_ITEM32(reg, sspr, system_port, 0x04, 0, 16);
 
-static inline void mlxsw_reg_sspr_pack(char *payload, u8 local_port)
+static inline void mlxsw_reg_sspr_pack(char *payload, u16 local_port)
 {
 	MLXSW_REG_ZERO(sspr, payload);
 	mlxsw_reg_sspr_m_set(payload, 1);
@@ -407,7 +407,7 @@ static inline void mlxsw_reg_sfd_uc_pack(char *payload, int rec_index,
 					 enum mlxsw_reg_sfd_rec_policy policy,
 					 const char *mac, u16 fid_vid,
 					 enum mlxsw_reg_sfd_rec_action action,
-					 u8 local_port)
+					 u16 local_port)
 {
 	mlxsw_reg_sfd_rec_pack(payload, rec_index,
 			       MLXSW_REG_SFD_REC_TYPE_UNICAST, mac, action);
@@ -674,7 +674,7 @@ MLXSW_ITEM32_INDEXED(reg, sfn, mac_system_port, MLXSW_REG_SFN_BASE_LEN, 0, 16,
 
 static inline void mlxsw_reg_sfn_mac_unpack(char *payload, int rec_index,
 					    char *mac, u16 *p_vid,
-					    u8 *p_local_port)
+					    u16 *p_local_port)
 {
 	mlxsw_reg_sfn_rec_mac_memcpy_from(payload, rec_index, mac);
 	*p_vid = mlxsw_reg_sfn_mac_fid_get(payload, rec_index);
@@ -782,7 +782,7 @@ enum mlxsw_reg_spms_state {
  */
 MLXSW_ITEM_BIT_ARRAY(reg, spms, state, 0x04, 0x400, 2);
 
-static inline void mlxsw_reg_spms_pack(char *payload, u8 local_port)
+static inline void mlxsw_reg_spms_pack(char *payload, u16 local_port)
 {
 	MLXSW_REG_ZERO(spms, payload);
 	mlxsw_reg_spms_local_port_set(payload, local_port);
@@ -850,7 +850,7 @@ MLXSW_ITEM32(reg, spvid, et_vlan, 0x04, 16, 2);
  */
 MLXSW_ITEM32(reg, spvid, pvid, 0x04, 0, 12);
 
-static inline void mlxsw_reg_spvid_pack(char *payload, u8 local_port, u16 pvid,
+static inline void mlxsw_reg_spvid_pack(char *payload, u16 local_port, u16 pvid,
 					u8 et_vlan)
 {
 	MLXSW_REG_ZERO(spvid, payload);
@@ -941,7 +941,7 @@ MLXSW_ITEM32_INDEXED(reg, spvm, rec_vid,
 		     MLXSW_REG_SPVM_BASE_LEN, 0, 12,
 		     MLXSW_REG_SPVM_REC_LEN, 0, false);
 
-static inline void mlxsw_reg_spvm_pack(char *payload, u8 local_port,
+static inline void mlxsw_reg_spvm_pack(char *payload, u16 local_port,
 				       u16 vid_begin, u16 vid_end,
 				       bool is_member, bool untagged)
 {
@@ -1003,7 +1003,7 @@ MLXSW_ITEM32(reg, spaft, allow_prio_tagged, 0x04, 30, 1);
  */
 MLXSW_ITEM32(reg, spaft, allow_tagged, 0x04, 29, 1);
 
-static inline void mlxsw_reg_spaft_pack(char *payload, u8 local_port,
+static inline void mlxsw_reg_spaft_pack(char *payload, u16 local_port,
 					bool allow_untagged)
 {
 	MLXSW_REG_ZERO(spaft, payload);
@@ -1329,7 +1329,7 @@ MLXSW_ITEM32(reg, sldr, num_ports, 0x04, 24, 8);
 MLXSW_ITEM32_INDEXED(reg, sldr, system_port, 0x08, 0, 16, 4, 0, false);
 
 static inline void mlxsw_reg_sldr_lag_add_port_pack(char *payload, u8 lag_id,
-						    u8 local_port)
+						    u16 local_port)
 {
 	MLXSW_REG_ZERO(sldr, payload);
 	mlxsw_reg_sldr_op_set(payload, MLXSW_REG_SLDR_OP_LAG_ADD_PORT_LIST);
@@ -1339,7 +1339,7 @@ static inline void mlxsw_reg_sldr_lag_add_port_pack(char *payload, u8 lag_id,
 }
 
 static inline void mlxsw_reg_sldr_lag_remove_port_pack(char *payload, u8 lag_id,
-						       u8 local_port)
+						       u16 local_port)
 {
 	MLXSW_REG_ZERO(sldr, payload);
 	mlxsw_reg_sldr_op_set(payload, MLXSW_REG_SLDR_OP_LAG_REMOVE_PORT_LIST);
@@ -1513,7 +1513,7 @@ MLXSW_ITEM32(reg, slcor, lag_id, 0x00, 0, 10);
 MLXSW_ITEM32(reg, slcor, port_index, 0x04, 0, 10);
 
 static inline void mlxsw_reg_slcor_pack(char *payload,
-					u8 local_port, u16 lag_id,
+					u16 local_port, u16 lag_id,
 					enum mlxsw_reg_slcor_col col)
 {
 	MLXSW_REG_ZERO(slcor, payload);
@@ -1523,7 +1523,7 @@ static inline void mlxsw_reg_slcor_pack(char *payload,
 }
 
 static inline void mlxsw_reg_slcor_port_add_pack(char *payload,
-						 u8 local_port, u16 lag_id,
+						 u16 local_port, u16 lag_id,
 						 u8 port_index)
 {
 	mlxsw_reg_slcor_pack(payload, local_port, lag_id,
@@ -1532,21 +1532,21 @@ static inline void mlxsw_reg_slcor_port_add_pack(char *payload,
 }
 
 static inline void mlxsw_reg_slcor_port_remove_pack(char *payload,
-						    u8 local_port, u16 lag_id)
+						    u16 local_port, u16 lag_id)
 {
 	mlxsw_reg_slcor_pack(payload, local_port, lag_id,
 			     MLXSW_REG_SLCOR_COL_LAG_REMOVE_PORT);
 }
 
 static inline void mlxsw_reg_slcor_col_enable_pack(char *payload,
-						   u8 local_port, u16 lag_id)
+						   u16 local_port, u16 lag_id)
 {
 	mlxsw_reg_slcor_pack(payload, local_port, lag_id,
 			     MLXSW_REG_SLCOR_COL_LAG_COLLECTOR_ENABLED);
 }
 
 static inline void mlxsw_reg_slcor_col_disable_pack(char *payload,
-						    u8 local_port, u16 lag_id)
+						    u16 local_port, u16 lag_id)
 {
 	mlxsw_reg_slcor_pack(payload, local_port, lag_id,
 			     MLXSW_REG_SLCOR_COL_LAG_COLLECTOR_ENABLED);
@@ -1593,7 +1593,7 @@ enum mlxsw_reg_spmlr_learn_mode {
  */
 MLXSW_ITEM32(reg, spmlr, learn_mode, 0x04, 30, 2);
 
-static inline void mlxsw_reg_spmlr_pack(char *payload, u8 local_port,
+static inline void mlxsw_reg_spmlr_pack(char *payload, u16 local_port,
 					enum mlxsw_reg_spmlr_learn_mode mode)
 {
 	MLXSW_REG_ZERO(spmlr, payload);
@@ -1678,7 +1678,7 @@ MLXSW_ITEM32(reg, svfa, counter_set_type, 0x08, 24, 8);
  */
 MLXSW_ITEM32(reg, svfa, counter_index, 0x08, 0, 24);
 
-static inline void mlxsw_reg_svfa_pack(char *payload, u8 local_port,
+static inline void mlxsw_reg_svfa_pack(char *payload, u16 local_port,
 				       enum mlxsw_reg_svfa_mt mt, bool valid,
 				       u16 fid, u16 vid)
 {
@@ -1785,7 +1785,7 @@ enum mlxsw_reg_spvtr_epvid_mode {
 MLXSW_ITEM32(reg, spvtr, epvid_mode, 0x04, 0, 4);
 
 static inline void mlxsw_reg_spvtr_pack(char *payload, bool tport,
-					u8 local_port,
+					u16 local_port,
 					enum mlxsw_reg_spvtr_ipvid_mode ipvid_mode)
 {
 	MLXSW_REG_ZERO(spvtr, payload);
@@ -1820,7 +1820,7 @@ MLXSW_ITEM32_LP(reg, svpe, 0x00, 16, 0x00, 12);
  */
 MLXSW_ITEM32(reg, svpe, vp_en, 0x00, 8, 1);
 
-static inline void mlxsw_reg_svpe_pack(char *payload, u8 local_port,
+static inline void mlxsw_reg_svpe_pack(char *payload, u16 local_port,
 				       bool enable)
 {
 	MLXSW_REG_ZERO(svpe, payload);
@@ -1953,7 +1953,7 @@ MLXSW_ITEM32_INDEXED(reg, spvmlr, rec_learn_enable, MLXSW_REG_SPVMLR_BASE_LEN,
 MLXSW_ITEM32_INDEXED(reg, spvmlr, rec_vid, MLXSW_REG_SPVMLR_BASE_LEN, 0, 12,
 		     MLXSW_REG_SPVMLR_REC_LEN, 0x00, false);
 
-static inline void mlxsw_reg_spvmlr_pack(char *payload, u8 local_port,
+static inline void mlxsw_reg_spvmlr_pack(char *payload, u16 local_port,
 					 u16 vid_begin, u16 vid_end,
 					 bool learn_enable)
 {
@@ -2056,7 +2056,7 @@ MLXSW_ITEM32(reg, spvc, inner_et0, 0x08, 1, 1);
  */
 MLXSW_ITEM32(reg, spvc, et0, 0x08, 0, 1);
 
-static inline void mlxsw_reg_spvc_pack(char *payload, u8 local_port, bool et1,
+static inline void mlxsw_reg_spvc_pack(char *payload, u16 local_port, bool et1,
 				       bool et0)
 {
 	MLXSW_REG_ZERO(spvc, payload);
@@ -2097,7 +2097,7 @@ MLXSW_ITEM32_LP(reg, spevet, 0x00, 16, 0x00, 12);
  */
 MLXSW_ITEM32(reg, spevet, et_vlan, 0x04, 16, 2);
 
-static inline void mlxsw_reg_spevet_pack(char *payload, u8 local_port,
+static inline void mlxsw_reg_spevet_pack(char *payload, u16 local_port,
 					 u8 et_vlan)
 {
 	MLXSW_REG_ZERO(spevet, payload);
@@ -2155,7 +2155,7 @@ MLXSW_ITEM32_INDEXED(reg, cwtp, profile_max, MLXSW_REG_CWTP_BASE_LEN,
 #define MLXSW_REG_CWTP_MAX_PROFILE 2
 #define MLXSW_REG_CWTP_DEFAULT_PROFILE 1
 
-static inline void mlxsw_reg_cwtp_pack(char *payload, u8 local_port,
+static inline void mlxsw_reg_cwtp_pack(char *payload, u16 local_port,
 				       u8 traffic_class)
 {
 	int i;
@@ -2273,7 +2273,7 @@ MLXSW_ITEM32(reg, cwtpm, ntcp_r, 64, 0, 2);
 
 #define MLXSW_REG_CWTPM_RESET_PROFILE 0
 
-static inline void mlxsw_reg_cwtpm_pack(char *payload, u8 local_port,
+static inline void mlxsw_reg_cwtpm_pack(char *payload, u16 local_port,
 					u8 traffic_class, u8 profile,
 					bool wred, bool ecn)
 {
@@ -2364,7 +2364,7 @@ MLXSW_ITEM32(reg, ppbt, acl_info, 0x10, 0, 16);
 
 static inline void mlxsw_reg_ppbt_pack(char *payload, enum mlxsw_reg_pxbt_e e,
 				       enum mlxsw_reg_pxbt_op op,
-				       u8 local_port, u16 acl_info)
+				       u16 local_port, u16 acl_info)
 {
 	MLXSW_REG_ZERO(ppbt, payload);
 	mlxsw_reg_ppbt_e_set(payload, e);
@@ -3508,7 +3508,7 @@ enum mlxsw_reg_qpts_trust_state {
  */
 MLXSW_ITEM32(reg, qpts, trust_state, 0x04, 0, 3);
 
-static inline void mlxsw_reg_qpts_pack(char *payload, u8 local_port,
+static inline void mlxsw_reg_qpts_pack(char *payload, u16 local_port,
 				       enum mlxsw_reg_qpts_trust_state ts)
 {
 	MLXSW_REG_ZERO(qpts, payload);
@@ -3724,7 +3724,7 @@ MLXSW_ITEM32(reg, qtct, switch_prio, 0x00, 0, 4);
  */
 MLXSW_ITEM32(reg, qtct, tclass, 0x04, 0, 4);
 
-static inline void mlxsw_reg_qtct_pack(char *payload, u8 local_port,
+static inline void mlxsw_reg_qtct_pack(char *payload, u16 local_port,
 				       u8 switch_prio, u8 tclass)
 {
 	MLXSW_REG_ZERO(qtct, payload);
@@ -3891,7 +3891,7 @@ MLXSW_ITEM32(reg, qeec, max_shaper_bs, 0x1C, 0, 6);
 #define MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP2	11
 #define MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP3	11
 
-static inline void mlxsw_reg_qeec_pack(char *payload, u8 local_port,
+static inline void mlxsw_reg_qeec_pack(char *payload, u16 local_port,
 				       enum mlxsw_reg_qeec_hr hr, u8 index,
 				       u8 next_index)
 {
@@ -3902,7 +3902,7 @@ static inline void mlxsw_reg_qeec_pack(char *payload, u8 local_port,
 	mlxsw_reg_qeec_next_element_index_set(payload, next_index);
 }
 
-static inline void mlxsw_reg_qeec_ptps_pack(char *payload, u8 local_port,
+static inline void mlxsw_reg_qeec_ptps_pack(char *payload, u16 local_port,
 					    bool ptps)
 {
 	MLXSW_REG_ZERO(qeec, payload);
@@ -3940,7 +3940,7 @@ MLXSW_ITEM32(reg, qrwe, dscp, 0x04, 1, 1);
  */
 MLXSW_ITEM32(reg, qrwe, pcp, 0x04, 0, 1);
 
-static inline void mlxsw_reg_qrwe_pack(char *payload, u8 local_port,
+static inline void mlxsw_reg_qrwe_pack(char *payload, u16 local_port,
 				       bool rewrite_pcp, bool rewrite_dscp)
 {
 	MLXSW_REG_ZERO(qrwe, payload);
@@ -4020,7 +4020,7 @@ MLXSW_ITEM32_INDEXED(reg, qpdsm, prio_entry_color2_dscp,
 		     MLXSW_REG_QPDSM_BASE_LEN, 8, 6,
 		     MLXSW_REG_QPDSM_PRIO_ENTRY_REC_LEN, 0x00, false);
 
-static inline void mlxsw_reg_qpdsm_pack(char *payload, u8 local_port)
+static inline void mlxsw_reg_qpdsm_pack(char *payload, u16 local_port)
 {
 	MLXSW_REG_ZERO(qpdsm, payload);
 	mlxsw_reg_qpdsm_local_port_set(payload, local_port);
@@ -4061,7 +4061,7 @@ MLXSW_ITEM32_LP(reg, qpdp, 0x00, 16, 0x00, 12);
  */
 MLXSW_ITEM32(reg, qpdp, switch_prio, 0x04, 0, 4);
 
-static inline void mlxsw_reg_qpdp_pack(char *payload, u8 local_port,
+static inline void mlxsw_reg_qpdp_pack(char *payload, u16 local_port,
 				       u8 switch_prio)
 {
 	MLXSW_REG_ZERO(qpdp, payload);
@@ -4107,7 +4107,7 @@ MLXSW_ITEM16_INDEXED(reg, qpdpm, dscp_entry_prio,
 		     MLXSW_REG_QPDPM_BASE_LEN, 0, 4,
 		     MLXSW_REG_QPDPM_DSCP_ENTRY_REC_LEN, 0x00, false);
 
-static inline void mlxsw_reg_qpdpm_pack(char *payload, u8 local_port)
+static inline void mlxsw_reg_qpdpm_pack(char *payload, u16 local_port)
 {
 	MLXSW_REG_ZERO(qpdpm, payload);
 	mlxsw_reg_qpdpm_local_port_set(payload, local_port);
@@ -4149,7 +4149,7 @@ MLXSW_ITEM32_LP(reg, qtctm, 0x00, 16, 0x00, 12);
 MLXSW_ITEM32(reg, qtctm, mc, 0x04, 0, 1);
 
 static inline void
-mlxsw_reg_qtctm_pack(char *payload, u8 local_port, bool mc)
+mlxsw_reg_qtctm_pack(char *payload, u16 local_port, bool mc)
 {
 	MLXSW_REG_ZERO(qtctm, payload);
 	mlxsw_reg_qtctm_local_port_set(payload, local_port);
@@ -4313,7 +4313,7 @@ MLXSW_ITEM32_INDEXED(reg, pmlp, tx_lane, 0x04, 16, 4, 0x04, 0x00, false);
  */
 MLXSW_ITEM32_INDEXED(reg, pmlp, rx_lane, 0x04, 24, 4, 0x04, 0x00, false);
 
-static inline void mlxsw_reg_pmlp_pack(char *payload, u8 local_port)
+static inline void mlxsw_reg_pmlp_pack(char *payload, u16 local_port)
 {
 	MLXSW_REG_ZERO(pmlp, payload);
 	mlxsw_reg_pmlp_local_port_set(payload, local_port);
@@ -4360,7 +4360,7 @@ MLXSW_ITEM32(reg, pmtu, admin_mtu, 0x08, 16, 16);
  */
 MLXSW_ITEM32(reg, pmtu, oper_mtu, 0x0C, 16, 16);
 
-static inline void mlxsw_reg_pmtu_pack(char *payload, u8 local_port,
+static inline void mlxsw_reg_pmtu_pack(char *payload, u16 local_port,
 				       u16 new_mtu)
 {
 	MLXSW_REG_ZERO(pmtu, payload);
@@ -4554,7 +4554,7 @@ enum mlxsw_reg_ptys_connector_type {
  */
 MLXSW_ITEM32(reg, ptys, connector_type, 0x2C, 0, 4);
 
-static inline void mlxsw_reg_ptys_eth_pack(char *payload, u8 local_port,
+static inline void mlxsw_reg_ptys_eth_pack(char *payload, u16 local_port,
 					   u32 proto_admin, bool autoneg)
 {
 	MLXSW_REG_ZERO(ptys, payload);
@@ -4564,7 +4564,7 @@ static inline void mlxsw_reg_ptys_eth_pack(char *payload, u8 local_port,
 	mlxsw_reg_ptys_an_disable_admin_set(payload, !autoneg);
 }
 
-static inline void mlxsw_reg_ptys_ext_eth_pack(char *payload, u8 local_port,
+static inline void mlxsw_reg_ptys_ext_eth_pack(char *payload, u16 local_port,
 					       u32 proto_admin, bool autoneg)
 {
 	MLXSW_REG_ZERO(ptys, payload);
@@ -4606,7 +4606,7 @@ static inline void mlxsw_reg_ptys_ext_eth_unpack(char *payload,
 			mlxsw_reg_ptys_ext_eth_proto_oper_get(payload);
 }
 
-static inline void mlxsw_reg_ptys_ib_pack(char *payload, u8 local_port,
+static inline void mlxsw_reg_ptys_ib_pack(char *payload, u16 local_port,
 					  u16 proto_admin, u16 link_width)
 {
 	MLXSW_REG_ZERO(ptys, payload);
@@ -4664,7 +4664,7 @@ MLXSW_ITEM32_LP(reg, ppad, 0x00, 16, 0x00, 24);
 MLXSW_ITEM_BUF(reg, ppad, mac, 0x02, 6);
 
 static inline void mlxsw_reg_ppad_pack(char *payload, bool single_base_mac,
-				       u8 local_port)
+				       u16 local_port)
 {
 	MLXSW_REG_ZERO(ppad, payload);
 	mlxsw_reg_ppad_single_base_mac_set(payload, !!single_base_mac);
@@ -4738,7 +4738,7 @@ MLXSW_ITEM32(reg, paos, ee, 0x04, 30, 1);
  */
 MLXSW_ITEM32(reg, paos, e, 0x04, 0, 2);
 
-static inline void mlxsw_reg_paos_pack(char *payload, u8 local_port,
+static inline void mlxsw_reg_paos_pack(char *payload, u16 local_port,
 				       enum mlxsw_port_admin_status status)
 {
 	MLXSW_REG_ZERO(paos, payload);
@@ -4881,7 +4881,7 @@ static inline void mlxsw_reg_pfcc_prio_pack(char *payload, u8 pfc_en)
 	mlxsw_reg_pfcc_pfcrx_set(payload, pfc_en);
 }
 
-static inline void mlxsw_reg_pfcc_pack(char *payload, u8 local_port)
+static inline void mlxsw_reg_pfcc_pack(char *payload, u16 local_port)
 {
 	MLXSW_REG_ZERO(pfcc, payload);
 	mlxsw_reg_pfcc_local_port_set(payload, local_port);
@@ -5392,7 +5392,7 @@ MLXSW_ITEM64(reg, ppcnt, wred_discard,
 MLXSW_ITEM64(reg, ppcnt, ecn_marked_tc,
 	     MLXSW_REG_PPCNT_COUNTERS_OFFSET + 0x08, 0, 64);
 
-static inline void mlxsw_reg_ppcnt_pack(char *payload, u8 local_port,
+static inline void mlxsw_reg_ppcnt_pack(char *payload, u16 local_port,
 					enum mlxsw_reg_ppcnt_grp grp,
 					u8 prio_tc)
 {
@@ -5504,7 +5504,7 @@ MLXSW_ITEM_BIT_ARRAY(reg, pptb, prio_to_buff_msb, 0x0C, 0x04, 4);
 
 #define MLXSW_REG_PPTB_ALL_PRIO 0xFF
 
-static inline void mlxsw_reg_pptb_pack(char *payload, u8 local_port)
+static inline void mlxsw_reg_pptb_pack(char *payload, u16 local_port)
 {
 	MLXSW_REG_ZERO(pptb, payload);
 	mlxsw_reg_pptb_mm_set(payload, MLXSW_REG_PPTB_MM_UM);
@@ -5601,7 +5601,7 @@ MLXSW_ITEM32_INDEXED(reg, pbmc, buf_xoff_threshold, 0x0C, 16, 16,
 MLXSW_ITEM32_INDEXED(reg, pbmc, buf_xon_threshold, 0x0C, 0, 16,
 		     0x08, 0x04, false);
 
-static inline void mlxsw_reg_pbmc_pack(char *payload, u8 local_port,
+static inline void mlxsw_reg_pbmc_pack(char *payload, u16 local_port,
 				       u16 xoff_timer_value, u16 xoff_refresh)
 {
 	MLXSW_REG_ZERO(pbmc, payload);
@@ -5659,7 +5659,7 @@ MLXSW_ITEM32_LP(reg, pspa, 0x00, 16, 0x00, 0);
  */
 MLXSW_ITEM32(reg, pspa, sub_port, 0x00, 8, 8);
 
-static inline void mlxsw_reg_pspa_pack(char *payload, u8 swid, u8 local_port)
+static inline void mlxsw_reg_pspa_pack(char *payload, u8 swid, u16 local_port)
 {
 	MLXSW_REG_ZERO(pspa, payload);
 	mlxsw_reg_pspa_swid_set(payload, swid);
@@ -5774,7 +5774,7 @@ MLXSW_ITEM32_LP(reg, pplr, 0x00, 16, 0x00, 12);
  */
 MLXSW_ITEM32(reg, pplr, lb_en, 0x04, 0, 8);
 
-static inline void mlxsw_reg_pplr_pack(char *payload, u8 local_port,
+static inline void mlxsw_reg_pplr_pack(char *payload, u16 local_port,
 				       bool phy_local)
 {
 	MLXSW_REG_ZERO(pplr, payload);
@@ -5933,7 +5933,7 @@ MLXSW_ITEM32(reg, pddr, trblsh_group_opcode, 0x08, 0, 16);
  */
 MLXSW_ITEM32(reg, pddr, trblsh_status_opcode, 0x0C, 0, 16);
 
-static inline void mlxsw_reg_pddr_pack(char *payload, u8 local_port,
+static inline void mlxsw_reg_pddr_pack(char *payload, u16 local_port,
 				       u8 page_select)
 {
 	MLXSW_REG_ZERO(pddr, payload);
@@ -6023,7 +6023,7 @@ MLXSW_ITEM32(reg, pllp, split_num, 0x04, 0, 4);
  */
 MLXSW_ITEM32(reg, pllp, slot_index, 0x08, 0, 4);
 
-static inline void mlxsw_reg_pllp_pack(char *payload, u8 local_port)
+static inline void mlxsw_reg_pllp_pack(char *payload, u16 local_port)
 {
 	MLXSW_REG_ZERO(pllp, payload);
 	mlxsw_reg_pllp_local_port_set(payload, local_port);
@@ -10271,7 +10271,7 @@ MLXSW_ITEM32(reg, mpar, pa_id, 0x04, 0, 4);
  */
 MLXSW_ITEM32(reg, mpar, probability_rate, 0x08, 0, 32);
 
-static inline void mlxsw_reg_mpar_pack(char *payload, u8 local_port,
+static inline void mlxsw_reg_mpar_pack(char *payload, u16 local_port,
 				       enum mlxsw_reg_mpar_i_e i_e,
 				       bool enable, u8 pa_id,
 				       u32 probability_rate)
@@ -10394,7 +10394,7 @@ MLXSW_ITEM32(reg, mlcr, beacon_duration, 0x04, 0, 16);
  */
 MLXSW_ITEM32(reg, mlcr, beacon_remain, 0x08, 0, 16);
 
-static inline void mlxsw_reg_mlcr_pack(char *payload, u8 local_port,
+static inline void mlxsw_reg_mlcr_pack(char *payload, u16 local_port,
 				       bool active)
 {
 	MLXSW_REG_ZERO(mlcr, payload);
@@ -10784,7 +10784,7 @@ MLXSW_ITEM32(reg, mpsc, e, 0x04, 30, 1);
  */
 MLXSW_ITEM32(reg, mpsc, rate, 0x08, 0, 32);
 
-static inline void mlxsw_reg_mpsc_pack(char *payload, u8 local_port, bool e,
+static inline void mlxsw_reg_mpsc_pack(char *payload, u16 local_port, bool e,
 				       u32 rate)
 {
 	MLXSW_REG_ZERO(mpsc, payload);
@@ -11019,7 +11019,7 @@ MLXSW_ITEM32(reg, momte, type, 0x04, 0, 8);
  */
 MLXSW_ITEM_BIT_ARRAY(reg, momte, tclass_en, 0x08, 0x08, 1);
 
-static inline void mlxsw_reg_momte_pack(char *payload, u8 local_port,
+static inline void mlxsw_reg_momte_pack(char *payload, u16 local_port,
 					enum mlxsw_reg_momte_type type)
 {
 	MLXSW_REG_ZERO(momte, payload);
@@ -11689,7 +11689,7 @@ MLXSW_ITEM32_LP(reg, tnqdr, 0x00, 16, 0x00, 12);
  */
 MLXSW_ITEM32(reg, tnqdr, dscp, 0x04, 0, 6);
 
-static inline void mlxsw_reg_tnqdr_pack(char *payload, u8 local_port)
+static inline void mlxsw_reg_tnqdr_pack(char *payload, u16 local_port)
 {
 	MLXSW_REG_ZERO(tnqdr, payload);
 	mlxsw_reg_tnqdr_local_port_set(payload, local_port);
@@ -12071,7 +12071,7 @@ MLXSW_ITEM32(reg, sbcm, max_buff, 0x1C, 0, 24);
  */
 MLXSW_ITEM32(reg, sbcm, pool, 0x24, 0, 4);
 
-static inline void mlxsw_reg_sbcm_pack(char *payload, u8 local_port, u8 pg_buff,
+static inline void mlxsw_reg_sbcm_pack(char *payload, u16 local_port, u8 pg_buff,
 				       enum mlxsw_reg_sbxx_dir dir,
 				       u32 min_buff, u32 max_buff,
 				       bool infi_max, u8 pool)
@@ -12157,7 +12157,7 @@ MLXSW_ITEM32(reg, sbpm, min_buff, 0x18, 0, 24);
  */
 MLXSW_ITEM32(reg, sbpm, max_buff, 0x1C, 0, 24);
 
-static inline void mlxsw_reg_sbpm_pack(char *payload, u8 local_port, u8 pool,
+static inline void mlxsw_reg_sbpm_pack(char *payload, u16 local_port, u8 pool,
 				       enum mlxsw_reg_sbxx_dir dir, bool clr,
 				       u32 min_buff, u32 max_buff)
 {
@@ -12352,7 +12352,7 @@ MLXSW_ITEM32_LP(reg, sbib, 0x00, 16, 0x00, 12);
  */
 MLXSW_ITEM32(reg, sbib, buff_size, 0x08, 0, 24);
 
-static inline void mlxsw_reg_sbib_pack(char *payload, u8 local_port,
+static inline void mlxsw_reg_sbib_pack(char *payload, u16 local_port,
 				       u32 buff_size)
 {
 	MLXSW_REG_ZERO(sbib, payload);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 08ae099de147..fb06b2ddfd6d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -352,7 +352,7 @@ static int mlxsw_sp_port_mtu_set(struct mlxsw_sp_port *mlxsw_sp_port, u16 mtu)
 }
 
 static int mlxsw_sp_port_swid_set(struct mlxsw_sp *mlxsw_sp,
-				  u8 local_port, u8 swid)
+				  u16 local_port, u8 swid)
 {
 	char pspa_pl[MLXSW_REG_PSPA_LEN];
 
@@ -483,7 +483,7 @@ mlxsw_sp_port_system_port_mapping_set(struct mlxsw_sp_port *mlxsw_sp_port)
 }
 
 static int
-mlxsw_sp_port_module_info_get(struct mlxsw_sp *mlxsw_sp, u8 local_port,
+mlxsw_sp_port_module_info_get(struct mlxsw_sp *mlxsw_sp, u16 local_port,
 			      struct mlxsw_sp_port_mapping *port_mapping)
 {
 	char pmlp_pl[MLXSW_REG_PMLP_LEN];
@@ -535,7 +535,7 @@ mlxsw_sp_port_module_info_get(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 }
 
 static int
-mlxsw_sp_port_module_map(struct mlxsw_sp *mlxsw_sp, u8 local_port,
+mlxsw_sp_port_module_map(struct mlxsw_sp *mlxsw_sp, u16 local_port,
 			 const struct mlxsw_sp_port_mapping *port_mapping)
 {
 	char pmlp_pl[MLXSW_REG_PMLP_LEN];
@@ -560,7 +560,7 @@ mlxsw_sp_port_module_map(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 	return err;
 }
 
-static void mlxsw_sp_port_module_unmap(struct mlxsw_sp *mlxsw_sp, u8 local_port,
+static void mlxsw_sp_port_module_unmap(struct mlxsw_sp *mlxsw_sp, u16 local_port,
 				       u8 module)
 {
 	char pmlp_pl[MLXSW_REG_PMLP_LEN];
@@ -1474,7 +1474,7 @@ mlxsw_sp_port_vlan_classification_set(struct mlxsw_sp_port *mlxsw_sp_port,
 }
 
 static int mlxsw_sp_port_label_info_get(struct mlxsw_sp *mlxsw_sp,
-					u8 local_port, u8 *port_number,
+					u16 local_port, u8 *port_number,
 					u8 *split_port_subnumber,
 					u8 *slot_index)
 {
@@ -1490,7 +1490,7 @@ static int mlxsw_sp_port_label_info_get(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 }
 
-static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
+static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u16 local_port,
 				bool split,
 				struct mlxsw_sp_port_mapping *port_mapping)
 {
@@ -1781,7 +1781,7 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 	return err;
 }
 
-static void mlxsw_sp_port_remove(struct mlxsw_sp *mlxsw_sp, u8 local_port)
+static void mlxsw_sp_port_remove(struct mlxsw_sp *mlxsw_sp, u16 local_port)
 {
 	struct mlxsw_sp_port *mlxsw_sp_port = mlxsw_sp->ports[local_port];
 	u8 module = mlxsw_sp_port->mapping.module;
@@ -1848,12 +1848,12 @@ static void mlxsw_sp_cpu_port_remove(struct mlxsw_sp *mlxsw_sp)
 	kfree(mlxsw_sp_port);
 }
 
-static bool mlxsw_sp_local_port_valid(u8 local_port)
+static bool mlxsw_sp_local_port_valid(u16 local_port)
 {
 	return local_port != MLXSW_PORT_CPU_PORT;
 }
 
-static bool mlxsw_sp_port_created(struct mlxsw_sp *mlxsw_sp, u8 local_port)
+static bool mlxsw_sp_port_created(struct mlxsw_sp *mlxsw_sp, u16 local_port)
 {
 	if (!mlxsw_sp_local_port_valid(local_port))
 		return false;
@@ -1971,7 +1971,7 @@ mlxsw_sp_port_split_create(struct mlxsw_sp *mlxsw_sp,
 	split_port_mapping = *port_mapping;
 	split_port_mapping.width /= count;
 	for (i = 0; i < count; i++) {
-		u8 s_local_port = mlxsw_reg_pmtdb_port_num_get(pmtdb_pl, i);
+		u16 s_local_port = mlxsw_reg_pmtdb_port_num_get(pmtdb_pl, i);
 
 		if (!mlxsw_sp_local_port_valid(s_local_port))
 			continue;
@@ -1987,7 +1987,7 @@ mlxsw_sp_port_split_create(struct mlxsw_sp *mlxsw_sp,
 
 err_port_create:
 	for (i--; i >= 0; i--) {
-		u8 s_local_port = mlxsw_reg_pmtdb_port_num_get(pmtdb_pl, i);
+		u16 s_local_port = mlxsw_reg_pmtdb_port_num_get(pmtdb_pl, i);
 
 		if (mlxsw_sp_port_created(mlxsw_sp, s_local_port))
 			mlxsw_sp_port_remove(mlxsw_sp, s_local_port);
@@ -2004,7 +2004,7 @@ static void mlxsw_sp_port_unsplit_create(struct mlxsw_sp *mlxsw_sp,
 
 	/* Go over original unsplit ports in the gap and recreate them. */
 	for (i = 0; i < count; i++) {
-		u8 local_port = mlxsw_reg_pmtdb_port_num_get(pmtdb_pl, i);
+		u16 local_port = mlxsw_reg_pmtdb_port_num_get(pmtdb_pl, i);
 
 		port_mapping = mlxsw_sp->port_mapping[local_port];
 		if (!port_mapping || !mlxsw_sp_local_port_valid(local_port))
@@ -2015,14 +2015,14 @@ static void mlxsw_sp_port_unsplit_create(struct mlxsw_sp *mlxsw_sp,
 }
 
 static struct mlxsw_sp_port *
-mlxsw_sp_port_get_by_local_port(struct mlxsw_sp *mlxsw_sp, u8 local_port)
+mlxsw_sp_port_get_by_local_port(struct mlxsw_sp *mlxsw_sp, u16 local_port)
 {
 	if (mlxsw_sp->ports && mlxsw_sp->ports[local_port])
 		return mlxsw_sp->ports[local_port];
 	return NULL;
 }
 
-static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u8 local_port,
+static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u16 local_port,
 			       unsigned int count,
 			       struct netlink_ext_ack *extack)
 {
@@ -2065,7 +2065,7 @@ static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u8 local_port,
 	port_mapping = mlxsw_sp_port->mapping;
 
 	for (i = 0; i < count; i++) {
-		u8 s_local_port = mlxsw_reg_pmtdb_port_num_get(pmtdb_pl, i);
+		u16 s_local_port = mlxsw_reg_pmtdb_port_num_get(pmtdb_pl, i);
 
 		if (mlxsw_sp_port_created(mlxsw_sp, s_local_port))
 			mlxsw_sp_port_remove(mlxsw_sp, s_local_port);
@@ -2085,7 +2085,7 @@ static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u8 local_port,
 	return err;
 }
 
-static int mlxsw_sp_port_unsplit(struct mlxsw_core *mlxsw_core, u8 local_port,
+static int mlxsw_sp_port_unsplit(struct mlxsw_core *mlxsw_core, u16 local_port,
 				 struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
@@ -2121,7 +2121,7 @@ static int mlxsw_sp_port_unsplit(struct mlxsw_core *mlxsw_core, u8 local_port,
 	}
 
 	for (i = 0; i < count; i++) {
-		u8 s_local_port = mlxsw_reg_pmtdb_port_num_get(pmtdb_pl, i);
+		u16 s_local_port = mlxsw_reg_pmtdb_port_num_get(pmtdb_pl, i);
 
 		if (mlxsw_sp_port_created(mlxsw_sp, s_local_port))
 			mlxsw_sp_port_remove(mlxsw_sp, s_local_port);
@@ -2148,7 +2148,7 @@ static void mlxsw_sp_pude_event_func(const struct mlxsw_reg_info *reg,
 	struct mlxsw_sp_port *mlxsw_sp_port;
 	enum mlxsw_reg_pude_oper_status status;
 	unsigned int max_ports;
-	u8 local_port;
+	u16 local_port;
 
 	max_ports = mlxsw_core_max_ports(mlxsw_sp->core);
 	local_port = mlxsw_reg_pude_local_port_get(pude_pl);
@@ -2174,7 +2174,7 @@ static void mlxsw_sp_pude_event_func(const struct mlxsw_reg_info *reg,
 static void mlxsw_sp1_ptp_fifo_event_func(struct mlxsw_sp *mlxsw_sp,
 					  char *mtpptr_pl, bool ingress)
 {
-	u8 local_port;
+	u16 local_port;
 	u8 num_rec;
 	int i;
 
@@ -2212,7 +2212,7 @@ static void mlxsw_sp1_ptp_egr_fifo_event_func(const struct mlxsw_reg_info *reg,
 }
 
 void mlxsw_sp_rx_listener_no_mark_func(struct sk_buff *skb,
-				       u8 local_port, void *priv)
+				       u16 local_port, void *priv)
 {
 	struct mlxsw_sp *mlxsw_sp = priv;
 	struct mlxsw_sp_port *mlxsw_sp_port = mlxsw_sp->ports[local_port];
@@ -2236,7 +2236,7 @@ void mlxsw_sp_rx_listener_no_mark_func(struct sk_buff *skb,
 	netif_receive_skb(skb);
 }
 
-static void mlxsw_sp_rx_listener_mark_func(struct sk_buff *skb, u8 local_port,
+static void mlxsw_sp_rx_listener_mark_func(struct sk_buff *skb, u16 local_port,
 					   void *priv)
 {
 	skb->offload_fwd_mark = 1;
@@ -2244,7 +2244,7 @@ static void mlxsw_sp_rx_listener_mark_func(struct sk_buff *skb, u8 local_port,
 }
 
 static void mlxsw_sp_rx_listener_l3_mark_func(struct sk_buff *skb,
-					      u8 local_port, void *priv)
+					      u16 local_port, void *priv)
 {
 	skb->offload_l3_fwd_mark = 1;
 	skb->offload_fwd_mark = 1;
@@ -2252,7 +2252,7 @@ static void mlxsw_sp_rx_listener_l3_mark_func(struct sk_buff *skb,
 }
 
 void mlxsw_sp_ptp_receive(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
-			  u8 local_port)
+			  u16 local_port)
 {
 	mlxsw_sp->ptp_ops->receive(mlxsw_sp, skb, local_port);
 }
@@ -3486,7 +3486,7 @@ static void mlxsw_sp2_params_unregister(struct mlxsw_core *mlxsw_core)
 }
 
 static void mlxsw_sp_ptp_transmitted(struct mlxsw_core *mlxsw_core,
-				     struct sk_buff *skb, u8 local_port)
+				     struct sk_buff *skb, u16 local_port)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 32fdd37657dd..ef4188e203a0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -217,13 +217,13 @@ struct mlxsw_sp_ptp_ops {
 	 * is responsible for freeing the passed-in SKB.
 	 */
 	void (*receive)(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
-			u8 local_port);
+			u16 local_port);
 
 	/* Notify a driver that a timestamped packet was transmitted. Driver
 	 * is responsible for freeing the passed-in SKB.
 	 */
 	void (*transmitted)(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
-			    u8 local_port);
+			    u16 local_port);
 
 	int (*hwtstamp_get)(struct mlxsw_sp_port *mlxsw_sp_port,
 			    struct hwtstamp_config *config);
@@ -261,7 +261,7 @@ enum mlxsw_sp_sample_trigger_type {
 
 struct mlxsw_sp_sample_trigger {
 	enum mlxsw_sp_sample_trigger_type type;
-	u8 local_port; /* Reserved when trigger type is not ingress / egress. */
+	u16 local_port; /* Reserved when trigger type is not ingress / egress. */
 };
 
 struct mlxsw_sp_sample_params {
@@ -308,7 +308,7 @@ struct mlxsw_sp_port {
 	struct net_device *dev;
 	struct mlxsw_sp_port_pcpu_stats __percpu *pcpu_stats;
 	struct mlxsw_sp *mlxsw_sp;
-	u8 local_port;
+	u16 local_port;
 	u8 lagged:1,
 	   split:1;
 	u16 pvid;
@@ -370,7 +370,7 @@ struct mlxsw_sp_port_type_speed_ops {
 	u32 (*to_ptys_speed_lanes)(struct mlxsw_sp *mlxsw_sp, u8 width,
 				   const struct ethtool_link_ksettings *cmd);
 	void (*reg_ptys_eth_pack)(struct mlxsw_sp *mlxsw_sp, char *payload,
-				  u8 local_port, u32 proto_admin, bool autoneg);
+				  u16 local_port, u32 proto_admin, bool autoneg);
 	void (*reg_ptys_eth_unpack)(struct mlxsw_sp *mlxsw_sp, char *payload,
 				    u32 *p_eth_proto_cap,
 				    u32 *p_eth_proto_admin,
@@ -441,7 +441,7 @@ static inline struct mlxsw_sp_port *
 mlxsw_sp_port_lagged_get(struct mlxsw_sp *mlxsw_sp, u16 lag_id, u8 port_index)
 {
 	struct mlxsw_sp_port *mlxsw_sp_port;
-	u8 local_port;
+	u16 local_port;
 
 	local_port = mlxsw_core_lag_mapping_get(mlxsw_sp->core,
 						lag_id, port_index);
@@ -621,9 +621,9 @@ extern struct notifier_block mlxsw_sp_switchdev_notifier;
 
 /* spectrum.c */
 void mlxsw_sp_rx_listener_no_mark_func(struct sk_buff *skb,
-				       u8 local_port, void *priv);
+				       u16 local_port, void *priv);
 void mlxsw_sp_ptp_receive(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
-			  u8 local_port);
+			  u16 local_port);
 int mlxsw_sp_port_speed_get(struct mlxsw_sp_port *mlxsw_sp_port, u32 *speed);
 int mlxsw_sp_port_ets_set(struct mlxsw_sp_port *mlxsw_sp_port,
 			  enum mlxsw_reg_qeec_hr hr, u8 index, u8 next_index,
@@ -729,7 +729,7 @@ void mlxsw_sp_rif_destroy_by_dev(struct mlxsw_sp *mlxsw_sp,
 bool mlxsw_sp_rif_exists(struct mlxsw_sp *mlxsw_sp,
 			 const struct net_device *dev);
 u16 mlxsw_sp_rif_vid(struct mlxsw_sp *mlxsw_sp, const struct net_device *dev);
-u8 mlxsw_sp_router_port(const struct mlxsw_sp *mlxsw_sp);
+u16 mlxsw_sp_router_port(const struct mlxsw_sp *mlxsw_sp);
 int mlxsw_sp_router_nve_promote_decap(struct mlxsw_sp *mlxsw_sp, u32 ul_tb_id,
 				      enum mlxsw_sp_l3proto ul_proto,
 				      const union mlxsw_sp_l3addr *ul_sip,
@@ -1222,7 +1222,7 @@ bool mlxsw_sp_fid_vni_is_set(const struct mlxsw_sp_fid *fid);
 void mlxsw_sp_fid_fdb_clear_offload(const struct mlxsw_sp_fid *fid,
 				    const struct net_device *nve_dev);
 int mlxsw_sp_fid_flood_set(struct mlxsw_sp_fid *fid,
-			   enum mlxsw_sp_flood_type packet_type, u8 local_port,
+			   enum mlxsw_sp_flood_type packet_type, u16 local_port,
 			   bool member);
 int mlxsw_sp_fid_port_vid_map(struct mlxsw_sp_fid *fid,
 			      struct mlxsw_sp_port *mlxsw_sp_port, u16 vid);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
index 67cedfa76f78..70c11bfac08f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
@@ -406,7 +406,7 @@ int mlxsw_sp_acl_rulei_act_fwd(struct mlxsw_sp *mlxsw_sp,
 			       struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp_port *mlxsw_sp_port;
-	u8 local_port;
+	u16 local_port;
 	bool in_port;
 
 	if (out_dev) {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_actions.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_actions.c
index c72aa38424dc..50806594d977 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_actions.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_actions.c
@@ -83,7 +83,7 @@ static int mlxsw_sp2_act_kvdl_set_activity_get(void *priv, u32 kvdl_index,
 }
 
 static int mlxsw_sp_act_kvdl_fwd_entry_add(void *priv, u32 *p_kvdl_index,
-					   u8 local_port)
+					   u16 local_port)
 {
 	struct mlxsw_sp *mlxsw_sp = priv;
 	char ppbs_pl[MLXSW_REG_PPBS_LEN];
@@ -132,7 +132,7 @@ mlxsw_sp_act_counter_index_put(void *priv, unsigned int counter_index)
 }
 
 static int
-mlxsw_sp_act_mirror_add(void *priv, u8 local_in_port,
+mlxsw_sp_act_mirror_add(void *priv, u16 local_in_port,
 			const struct net_device *out_dev,
 			bool ingress, int *p_span_id)
 {
@@ -159,7 +159,7 @@ mlxsw_sp_act_mirror_add(void *priv, u8 local_in_port,
 }
 
 static void
-mlxsw_sp_act_mirror_del(void *priv, u8 local_in_port, int span_id, bool ingress)
+mlxsw_sp_act_mirror_del(void *priv, u16 local_in_port, int span_id, bool ingress)
 {
 	struct mlxsw_sp_port *mlxsw_sp_port;
 	struct mlxsw_sp *mlxsw_sp = priv;
@@ -192,7 +192,7 @@ static void mlxsw_sp_act_policer_del(void *priv, u16 policer_index)
 			     policer_index);
 }
 
-static int mlxsw_sp1_act_sampler_add(void *priv, u8 local_port,
+static int mlxsw_sp1_act_sampler_add(void *priv, u16 local_port,
 				     struct psample_group *psample_group,
 				     u32 rate, u32 trunc_size, bool truncate,
 				     bool ingress, int *p_span_id,
@@ -202,7 +202,7 @@ static int mlxsw_sp1_act_sampler_add(void *priv, u8 local_port,
 	return -EOPNOTSUPP;
 }
 
-static void mlxsw_sp1_act_sampler_del(void *priv, u8 local_port, int span_id,
+static void mlxsw_sp1_act_sampler_del(void *priv, u16 local_port, int span_id,
 				      bool ingress)
 {
 	WARN_ON_ONCE(1);
@@ -224,7 +224,7 @@ const struct mlxsw_afa_ops mlxsw_sp1_act_afa_ops = {
 	.sampler_del		= mlxsw_sp1_act_sampler_del,
 };
 
-static int mlxsw_sp2_act_sampler_add(void *priv, u8 local_port,
+static int mlxsw_sp2_act_sampler_add(void *priv, u16 local_port,
 				     struct psample_group *psample_group,
 				     u32 rate, u32 trunc_size, bool truncate,
 				     bool ingress, int *p_span_id,
@@ -272,7 +272,7 @@ static int mlxsw_sp2_act_sampler_add(void *priv, u8 local_port,
 	return err;
 }
 
-static void mlxsw_sp2_act_sampler_del(void *priv, u8 local_port, int span_id,
+static void mlxsw_sp2_act_sampler_del(void *priv, u16 local_port, int span_id,
 				      bool ingress)
 {
 	struct mlxsw_sp_sample_trigger trigger = {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
index d78cf5a7220a..ad250b301d7e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
@@ -160,7 +160,7 @@ static bool mlxsw_sp_sb_cm_exists(u8 pg_buff, enum mlxsw_reg_sbxx_dir dir)
 }
 
 static struct mlxsw_sp_sb_cm *mlxsw_sp_sb_cm_get(struct mlxsw_sp *mlxsw_sp,
-						 u8 local_port, u8 pg_buff,
+						 u16 local_port, u8 pg_buff,
 						 enum mlxsw_reg_sbxx_dir dir)
 {
 	struct mlxsw_sp_sb_port *sb_port = &mlxsw_sp->sb->ports[local_port];
@@ -173,7 +173,7 @@ static struct mlxsw_sp_sb_cm *mlxsw_sp_sb_cm_get(struct mlxsw_sp *mlxsw_sp,
 }
 
 static struct mlxsw_sp_sb_pm *mlxsw_sp_sb_pm_get(struct mlxsw_sp *mlxsw_sp,
-						 u8 local_port, u16 pool_index)
+						 u16 local_port, u16 pool_index)
 {
 	return &mlxsw_sp->sb->ports[local_port].pms[pool_index];
 }
@@ -202,7 +202,7 @@ static int mlxsw_sp_sb_pr_write(struct mlxsw_sp *mlxsw_sp, u16 pool_index,
 	return 0;
 }
 
-static int mlxsw_sp_sb_cm_write(struct mlxsw_sp *mlxsw_sp, u8 local_port,
+static int mlxsw_sp_sb_cm_write(struct mlxsw_sp *mlxsw_sp, u16 local_port,
 				u8 pg_buff, u32 min_buff, u32 max_buff,
 				bool infi_max, u16 pool_index)
 {
@@ -232,7 +232,7 @@ static int mlxsw_sp_sb_cm_write(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 	return 0;
 }
 
-static int mlxsw_sp_sb_pm_write(struct mlxsw_sp *mlxsw_sp, u8 local_port,
+static int mlxsw_sp_sb_pm_write(struct mlxsw_sp *mlxsw_sp, u16 local_port,
 				u16 pool_index, u32 min_buff, u32 max_buff)
 {
 	const struct mlxsw_sp_sb_pool_des *des =
@@ -253,7 +253,7 @@ static int mlxsw_sp_sb_pm_write(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 	return 0;
 }
 
-static int mlxsw_sp_sb_pm_occ_clear(struct mlxsw_sp *mlxsw_sp, u8 local_port,
+static int mlxsw_sp_sb_pm_occ_clear(struct mlxsw_sp *mlxsw_sp, u16 local_port,
 				    u16 pool_index, struct list_head *bulk_list)
 {
 	const struct mlxsw_sp_sb_pool_des *des =
@@ -279,7 +279,7 @@ static void mlxsw_sp_sb_pm_occ_query_cb(struct mlxsw_core *mlxsw_core,
 	mlxsw_reg_sbpm_unpack(sbpm_pl, &pm->occ.cur, &pm->occ.max);
 }
 
-static int mlxsw_sp_sb_pm_occ_query(struct mlxsw_sp *mlxsw_sp, u8 local_port,
+static int mlxsw_sp_sb_pm_occ_query(struct mlxsw_sp *mlxsw_sp, u16 local_port,
 				    u16 pool_index, struct list_head *bulk_list)
 {
 	const struct mlxsw_sp_sb_pool_des *des =
@@ -919,7 +919,7 @@ mlxsw_sp_sb_pool_is_static(struct mlxsw_sp *mlxsw_sp, u16 pool_index)
 	return pr->mode == MLXSW_REG_SBPR_MODE_STATIC;
 }
 
-static int __mlxsw_sp_sb_cms_init(struct mlxsw_sp *mlxsw_sp, u8 local_port,
+static int __mlxsw_sp_sb_cms_init(struct mlxsw_sp *mlxsw_sp, u16 local_port,
 				  enum mlxsw_reg_sbxx_dir dir,
 				  const struct mlxsw_sp_sb_cm *cms,
 				  size_t cms_len)
@@ -1037,7 +1037,7 @@ static const struct mlxsw_sp_sb_pm mlxsw_sp_cpu_port_sb_pms[] = {
 	MLXSW_SP_SB_PM(0, MLXSW_REG_SBXX_DYN_MAX_BUFF_MAX),
 };
 
-static int mlxsw_sp_sb_pms_init(struct mlxsw_sp *mlxsw_sp, u8 local_port,
+static int mlxsw_sp_sb_pms_init(struct mlxsw_sp *mlxsw_sp, u16 local_port,
 				const struct mlxsw_sp_sb_pm *pms,
 				bool skip_ingress)
 {
@@ -1416,7 +1416,7 @@ int mlxsw_sp_sb_port_pool_get(struct mlxsw_core_port *mlxsw_core_port,
 	struct mlxsw_sp_port *mlxsw_sp_port =
 			mlxsw_core_port_driver_priv(mlxsw_core_port);
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	u8 local_port = mlxsw_sp_port->local_port;
+	u16 local_port = mlxsw_sp_port->local_port;
 	struct mlxsw_sp_sb_pm *pm = mlxsw_sp_sb_pm_get(mlxsw_sp, local_port,
 						       pool_index);
 
@@ -1432,7 +1432,7 @@ int mlxsw_sp_sb_port_pool_set(struct mlxsw_core_port *mlxsw_core_port,
 	struct mlxsw_sp_port *mlxsw_sp_port =
 			mlxsw_core_port_driver_priv(mlxsw_core_port);
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	u8 local_port = mlxsw_sp_port->local_port;
+	u16 local_port = mlxsw_sp_port->local_port;
 	u32 max_buff;
 	int err;
 
@@ -1458,7 +1458,7 @@ int mlxsw_sp_sb_tc_pool_bind_get(struct mlxsw_core_port *mlxsw_core_port,
 	struct mlxsw_sp_port *mlxsw_sp_port =
 			mlxsw_core_port_driver_priv(mlxsw_core_port);
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	u8 local_port = mlxsw_sp_port->local_port;
+	u16 local_port = mlxsw_sp_port->local_port;
 	u8 pg_buff = tc_index;
 	enum mlxsw_reg_sbxx_dir dir = (enum mlxsw_reg_sbxx_dir) pool_type;
 	struct mlxsw_sp_sb_cm *cm = mlxsw_sp_sb_cm_get(mlxsw_sp, local_port,
@@ -1479,7 +1479,7 @@ int mlxsw_sp_sb_tc_pool_bind_set(struct mlxsw_core_port *mlxsw_core_port,
 	struct mlxsw_sp_port *mlxsw_sp_port =
 			mlxsw_core_port_driver_priv(mlxsw_core_port);
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	u8 local_port = mlxsw_sp_port->local_port;
+	u16 local_port = mlxsw_sp_port->local_port;
 	const struct mlxsw_sp_sb_cm *cm;
 	u8 pg_buff = tc_index;
 	enum mlxsw_reg_sbxx_dir dir = (enum mlxsw_reg_sbxx_dir) pool_type;
@@ -1526,7 +1526,7 @@ int mlxsw_sp_sb_tc_pool_bind_set(struct mlxsw_core_port *mlxsw_core_port,
 
 struct mlxsw_sp_sb_sr_occ_query_cb_ctx {
 	u8 masked_count;
-	u8 local_port_1;
+	u16 local_port_1;
 };
 
 static void mlxsw_sp_sb_sr_occ_query_cb(struct mlxsw_core *mlxsw_core,
@@ -1536,7 +1536,7 @@ static void mlxsw_sp_sb_sr_occ_query_cb(struct mlxsw_core *mlxsw_core,
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
 	struct mlxsw_sp_sb_sr_occ_query_cb_ctx cb_ctx;
 	u8 masked_count;
-	u8 local_port;
+	u16 local_port;
 	int rec_index = 0;
 	struct mlxsw_sp_sb_cm *cm;
 	int i;
@@ -1587,8 +1587,8 @@ int mlxsw_sp_sb_occ_snapshot(struct mlxsw_core *mlxsw_core,
 	LIST_HEAD(bulk_list);
 	char *sbsr_pl;
 	u8 masked_count;
-	u8 local_port_1;
-	u8 local_port;
+	u16 local_port_1;
+	u16 local_port;
 	int i;
 	int err;
 	int err2;
@@ -1654,7 +1654,7 @@ int mlxsw_sp_sb_occ_max_clear(struct mlxsw_core *mlxsw_core,
 	LIST_HEAD(bulk_list);
 	char *sbsr_pl;
 	unsigned int masked_count;
-	u8 local_port;
+	u16 local_port;
 	int i;
 	int err;
 	int err2;
@@ -1715,7 +1715,7 @@ int mlxsw_sp_sb_occ_port_pool_get(struct mlxsw_core_port *mlxsw_core_port,
 	struct mlxsw_sp_port *mlxsw_sp_port =
 			mlxsw_core_port_driver_priv(mlxsw_core_port);
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	u8 local_port = mlxsw_sp_port->local_port;
+	u16 local_port = mlxsw_sp_port->local_port;
 	struct mlxsw_sp_sb_pm *pm = mlxsw_sp_sb_pm_get(mlxsw_sp, local_port,
 						       pool_index);
 
@@ -1732,7 +1732,7 @@ int mlxsw_sp_sb_occ_tc_port_bind_get(struct mlxsw_core_port *mlxsw_core_port,
 	struct mlxsw_sp_port *mlxsw_sp_port =
 			mlxsw_core_port_driver_priv(mlxsw_core_port);
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	u8 local_port = mlxsw_sp_port->local_port;
+	u16 local_port = mlxsw_sp_port->local_port;
 	u8 pg_buff = tc_index;
 	enum mlxsw_reg_sbxx_dir dir = (enum mlxsw_reg_sbxx_dir) pool_type;
 	struct mlxsw_sp_sb_cm *cm = mlxsw_sp_sb_cm_get(mlxsw_sp, local_port,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index 84d4460f3dcd..20530712eadb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -1491,7 +1491,7 @@ static u32 mlxsw_sp1_to_ptys_speed_lanes(struct mlxsw_sp *mlxsw_sp, u8 width,
 
 static void
 mlxsw_sp1_reg_ptys_eth_pack(struct mlxsw_sp *mlxsw_sp, char *payload,
-			    u8 local_port, u32 proto_admin, bool autoneg)
+			    u16 local_port, u32 proto_admin, bool autoneg)
 {
 	mlxsw_reg_ptys_eth_pack(payload, local_port, proto_admin, autoneg);
 }
@@ -1969,7 +1969,7 @@ static u32 mlxsw_sp2_to_ptys_speed_lanes(struct mlxsw_sp *mlxsw_sp, u8 width,
 
 static void
 mlxsw_sp2_reg_ptys_eth_pack(struct mlxsw_sp *mlxsw_sp, char *payload,
-			    u8 local_port, u32 proto_admin,
+			    u16 local_port, u32 proto_admin,
 			    bool autoneg)
 {
 	mlxsw_reg_ptys_ext_eth_pack(payload, local_port, proto_admin, autoneg);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index 004c42274e48..d5e9af064ee6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -317,7 +317,7 @@ mlxsw_sp_fid_flood_table_lookup(const struct mlxsw_sp_fid *fid,
 }
 
 int mlxsw_sp_fid_flood_set(struct mlxsw_sp_fid *fid,
-			   enum mlxsw_sp_flood_type packet_type, u8 local_port,
+			   enum mlxsw_sp_flood_type packet_type, u16 local_port,
 			   bool member)
 {
 	struct mlxsw_sp_fid_family *fid_family = fid->fid_family;
@@ -439,7 +439,7 @@ static int mlxsw_sp_fid_vni_op(struct mlxsw_sp *mlxsw_sp, u16 fid_index,
 }
 
 static int __mlxsw_sp_fid_port_vid_map(struct mlxsw_sp *mlxsw_sp, u16 fid_index,
-				       u8 local_port, u16 vid, bool valid)
+				       u16 local_port, u16 vid, bool valid)
 {
 	enum mlxsw_reg_svfa_mt mt = MLXSW_REG_SVFA_MT_PORT_VID_TO_FID;
 	char svfa_pl[MLXSW_REG_SVFA_LEN];
@@ -573,7 +573,7 @@ static int mlxsw_sp_fid_8021d_port_vid_map(struct mlxsw_sp_fid *fid,
 					   u16 vid)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	u8 local_port = mlxsw_sp_port->local_port;
+	u16 local_port = mlxsw_sp_port->local_port;
 	int err;
 
 	err = __mlxsw_sp_fid_port_vid_map(mlxsw_sp, fid->fid_index,
@@ -601,7 +601,7 @@ mlxsw_sp_fid_8021d_port_vid_unmap(struct mlxsw_sp_fid *fid,
 				  struct mlxsw_sp_port *mlxsw_sp_port, u16 vid)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	u8 local_port = mlxsw_sp_port->local_port;
+	u16 local_port = mlxsw_sp_port->local_port;
 
 	if (mlxsw_sp->fid_core->port_fid_mappings[local_port] == 1)
 		mlxsw_sp_port_vlan_mode_trans(mlxsw_sp_port);
@@ -784,7 +784,7 @@ static int mlxsw_sp_fid_rfid_port_vid_map(struct mlxsw_sp_fid *fid,
 					  u16 vid)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	u8 local_port = mlxsw_sp_port->local_port;
+	u16 local_port = mlxsw_sp_port->local_port;
 	int err;
 
 	/* We only need to transition the port to virtual mode since
@@ -808,7 +808,7 @@ mlxsw_sp_fid_rfid_port_vid_unmap(struct mlxsw_sp_fid *fid,
 				 struct mlxsw_sp_port *mlxsw_sp_port, u16 vid)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	u8 local_port = mlxsw_sp_port->local_port;
+	u16 local_port = mlxsw_sp_port->local_port;
 
 	if (mlxsw_sp->fid_core->port_fid_mappings[local_port] == 1)
 		mlxsw_sp_port_vlan_mode_trans(mlxsw_sp_port);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index 1a180384e7e8..0ff163fbc775 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -36,7 +36,7 @@ struct mlxsw_sp_ptp_state {
 };
 
 struct mlxsw_sp1_ptp_key {
-	u8 local_port;
+	u16 local_port;
 	u8 message_type;
 	u16 sequence_id;
 	u8 domain_number;
@@ -406,7 +406,7 @@ mlxsw_sp1_ptp_unmatched_remove(struct mlxsw_sp *mlxsw_sp,
  *    This case is similar to 2) above.
  */
 static void mlxsw_sp1_ptp_packet_finish(struct mlxsw_sp *mlxsw_sp,
-					struct sk_buff *skb, u8 local_port,
+					struct sk_buff *skb, u16 local_port,
 					bool ingress,
 					struct skb_shared_hwtstamps *hwtstamps)
 {
@@ -524,7 +524,7 @@ static void mlxsw_sp1_ptp_got_piece(struct mlxsw_sp *mlxsw_sp,
 }
 
 static void mlxsw_sp1_ptp_got_packet(struct mlxsw_sp *mlxsw_sp,
-				     struct sk_buff *skb, u8 local_port,
+				     struct sk_buff *skb, u16 local_port,
 				     bool ingress)
 {
 	struct mlxsw_sp_port *mlxsw_sp_port;
@@ -564,7 +564,7 @@ static void mlxsw_sp1_ptp_got_packet(struct mlxsw_sp *mlxsw_sp,
 }
 
 void mlxsw_sp1_ptp_got_timestamp(struct mlxsw_sp *mlxsw_sp, bool ingress,
-				 u8 local_port, u8 message_type,
+				 u16 local_port, u8 message_type,
 				 u8 domain_number, u16 sequence_id,
 				 u64 timestamp)
 {
@@ -599,14 +599,14 @@ void mlxsw_sp1_ptp_got_timestamp(struct mlxsw_sp *mlxsw_sp, bool ingress,
 }
 
 void mlxsw_sp1_ptp_receive(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
-			   u8 local_port)
+			   u16 local_port)
 {
 	skb_reset_mac_header(skb);
 	mlxsw_sp1_ptp_got_packet(mlxsw_sp, skb, local_port, true);
 }
 
 void mlxsw_sp1_ptp_transmitted(struct mlxsw_sp *mlxsw_sp,
-			       struct sk_buff *skb, u8 local_port)
+			       struct sk_buff *skb, u16 local_port)
 {
 	mlxsw_sp1_ptp_got_packet(mlxsw_sp, skb, local_port, false);
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
index 1d43a3755285..c06cd1384bca 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
@@ -31,13 +31,13 @@ struct mlxsw_sp_ptp_state *mlxsw_sp1_ptp_init(struct mlxsw_sp *mlxsw_sp);
 void mlxsw_sp1_ptp_fini(struct mlxsw_sp_ptp_state *ptp_state);
 
 void mlxsw_sp1_ptp_receive(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
-			   u8 local_port);
+			   u16 local_port);
 
 void mlxsw_sp1_ptp_transmitted(struct mlxsw_sp *mlxsw_sp,
-			       struct sk_buff *skb, u8 local_port);
+			       struct sk_buff *skb, u16 local_port);
 
 void mlxsw_sp1_ptp_got_timestamp(struct mlxsw_sp *mlxsw_sp, bool ingress,
-				 u8 local_port, u8 message_type,
+				 u16 local_port, u8 message_type,
 				 u8 domain_number, u16 sequence_id,
 				 u64 timestamp);
 
@@ -80,20 +80,20 @@ static inline void mlxsw_sp1_ptp_fini(struct mlxsw_sp_ptp_state *ptp_state)
 }
 
 static inline void mlxsw_sp1_ptp_receive(struct mlxsw_sp *mlxsw_sp,
-					 struct sk_buff *skb, u8 local_port)
+					 struct sk_buff *skb, u16 local_port)
 {
 	mlxsw_sp_rx_listener_no_mark_func(skb, local_port, mlxsw_sp);
 }
 
 static inline void mlxsw_sp1_ptp_transmitted(struct mlxsw_sp *mlxsw_sp,
-					     struct sk_buff *skb, u8 local_port)
+					     struct sk_buff *skb, u16 local_port)
 {
 	dev_kfree_skb_any(skb);
 }
 
 static inline void
 mlxsw_sp1_ptp_got_timestamp(struct mlxsw_sp *mlxsw_sp, bool ingress,
-			    u8 local_port, u8 message_type,
+			    u16 local_port, u8 message_type,
 			    u8 domain_number,
 			    u16 sequence_id, u64 timestamp)
 {
@@ -159,13 +159,13 @@ static inline void mlxsw_sp2_ptp_fini(struct mlxsw_sp_ptp_state *ptp_state)
 }
 
 static inline void mlxsw_sp2_ptp_receive(struct mlxsw_sp *mlxsw_sp,
-					 struct sk_buff *skb, u8 local_port)
+					 struct sk_buff *skb, u16 local_port)
 {
 	mlxsw_sp_rx_listener_no_mark_func(skb, local_port, mlxsw_sp);
 }
 
 static inline void mlxsw_sp2_ptp_transmitted(struct mlxsw_sp *mlxsw_sp,
-					     struct sk_buff *skb, u8 local_port)
+					     struct sk_buff *skb, u16 local_port)
 {
 	dev_kfree_skb_any(skb);
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 98df6e8fa45f..2af0c6382609 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -9340,7 +9340,7 @@ static int mlxsw_sp_rif_vlan_fid_op(struct mlxsw_sp_rif *rif,
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ritr), ritr_pl);
 }
 
-u8 mlxsw_sp_router_port(const struct mlxsw_sp *mlxsw_sp)
+u16 mlxsw_sp_router_port(const struct mlxsw_sp *mlxsw_sp)
 {
 	return mlxsw_core_max_ports(mlxsw_sp->core) + 1;
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index f5f819aa9a65..f9671cc53002 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -37,7 +37,7 @@ struct mlxsw_sp_span {
 struct mlxsw_sp_span_analyzed_port {
 	struct list_head list; /* Member of analyzed_ports_list */
 	refcount_t ref_count;
-	u8 local_port;
+	u16 local_port;
 	bool ingress;
 };
 
@@ -46,7 +46,7 @@ struct mlxsw_sp_span_trigger_entry {
 	struct mlxsw_sp_span *span;
 	const struct mlxsw_sp_span_trigger_ops *ops;
 	refcount_t ref_count;
-	u8 local_port;
+	u16 local_port;
 	enum mlxsw_sp_span_trigger trigger;
 	struct mlxsw_sp_span_trigger_parms parms;
 };
@@ -179,7 +179,7 @@ mlxsw_sp_span_entry_phys_configure(struct mlxsw_sp_span_entry *span_entry,
 {
 	struct mlxsw_sp_port *dest_port = sparms.dest_port;
 	struct mlxsw_sp *mlxsw_sp = dest_port->mlxsw_sp;
-	u8 local_port = dest_port->local_port;
+	u16 local_port = dest_port->local_port;
 	char mpat_pl[MLXSW_REG_MPAT_LEN];
 	int pa_id = span_entry->id;
 
@@ -199,7 +199,7 @@ mlxsw_sp_span_entry_deconfigure_common(struct mlxsw_sp_span_entry *span_entry,
 {
 	struct mlxsw_sp_port *dest_port = span_entry->parms.dest_port;
 	struct mlxsw_sp *mlxsw_sp = dest_port->mlxsw_sp;
-	u8 local_port = dest_port->local_port;
+	u16 local_port = dest_port->local_port;
 	char mpat_pl[MLXSW_REG_MPAT_LEN];
 	int pa_id = span_entry->id;
 
@@ -480,7 +480,7 @@ mlxsw_sp_span_entry_gretap4_configure(struct mlxsw_sp_span_entry *span_entry,
 {
 	struct mlxsw_sp_port *dest_port = sparms.dest_port;
 	struct mlxsw_sp *mlxsw_sp = dest_port->mlxsw_sp;
-	u8 local_port = dest_port->local_port;
+	u16 local_port = dest_port->local_port;
 	char mpat_pl[MLXSW_REG_MPAT_LEN];
 	int pa_id = span_entry->id;
 
@@ -584,7 +584,7 @@ mlxsw_sp_span_entry_gretap6_configure(struct mlxsw_sp_span_entry *span_entry,
 {
 	struct mlxsw_sp_port *dest_port = sparms.dest_port;
 	struct mlxsw_sp *mlxsw_sp = dest_port->mlxsw_sp;
-	u8 local_port = dest_port->local_port;
+	u16 local_port = dest_port->local_port;
 	char mpat_pl[MLXSW_REG_MPAT_LEN];
 	int pa_id = span_entry->id;
 
@@ -650,7 +650,7 @@ mlxsw_sp_span_entry_vlan_configure(struct mlxsw_sp_span_entry *span_entry,
 {
 	struct mlxsw_sp_port *dest_port = sparms.dest_port;
 	struct mlxsw_sp *mlxsw_sp = dest_port->mlxsw_sp;
-	u8 local_port = dest_port->local_port;
+	u16 local_port = dest_port->local_port;
 	char mpat_pl[MLXSW_REG_MPAT_LEN];
 	int pa_id = span_entry->id;
 
@@ -997,7 +997,7 @@ static void mlxsw_sp_span_port_buffer_disable(struct mlxsw_sp_port *mlxsw_sp_por
 }
 
 static struct mlxsw_sp_span_analyzed_port *
-mlxsw_sp_span_analyzed_port_find(struct mlxsw_sp_span *span, u8 local_port,
+mlxsw_sp_span_analyzed_port_find(struct mlxsw_sp_span *span, u16 local_port,
 				 bool ingress)
 {
 	struct mlxsw_sp_span_analyzed_port *analyzed_port;
@@ -1165,7 +1165,7 @@ int mlxsw_sp_span_analyzed_port_get(struct mlxsw_sp_port *mlxsw_sp_port,
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	struct mlxsw_sp_span_analyzed_port *analyzed_port;
-	u8 local_port = mlxsw_sp_port->local_port;
+	u16 local_port = mlxsw_sp_port->local_port;
 	int err = 0;
 
 	mutex_lock(&mlxsw_sp->span->analyzed_ports_lock);
@@ -1193,7 +1193,7 @@ void mlxsw_sp_span_analyzed_port_put(struct mlxsw_sp_port *mlxsw_sp_port,
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	struct mlxsw_sp_span_analyzed_port *analyzed_port;
-	u8 local_port = mlxsw_sp_port->local_port;
+	u16 local_port = mlxsw_sp_port->local_port;
 
 	mutex_lock(&mlxsw_sp->span->analyzed_ports_lock);
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 81c7e8a7fcf5..6eb54cd082d0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -980,7 +980,7 @@ mlxsw_sp_port_vlan_fid_join(struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan,
 {
 	struct mlxsw_sp_port *mlxsw_sp_port = mlxsw_sp_port_vlan->mlxsw_sp_port;
 	struct mlxsw_sp_bridge_device *bridge_device;
-	u8 local_port = mlxsw_sp_port->local_port;
+	u16 local_port = mlxsw_sp_port->local_port;
 	u16 vid = mlxsw_sp_port_vlan->vid;
 	struct mlxsw_sp_fid *fid;
 	int err;
@@ -1029,7 +1029,7 @@ mlxsw_sp_port_vlan_fid_leave(struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan)
 {
 	struct mlxsw_sp_port *mlxsw_sp_port = mlxsw_sp_port_vlan->mlxsw_sp_port;
 	struct mlxsw_sp_fid *fid = mlxsw_sp_port_vlan->fid;
-	u8 local_port = mlxsw_sp_port->local_port;
+	u16 local_port = mlxsw_sp_port->local_port;
 	u16 vid = mlxsw_sp_port_vlan->vid;
 
 	mlxsw_sp_port_vlan->fid = NULL;
@@ -1335,7 +1335,7 @@ static int mlxsw_sp_port_fdb_tunnel_uc_op(struct mlxsw_sp *mlxsw_sp,
 	return err;
 }
 
-static int __mlxsw_sp_port_fdb_uc_op(struct mlxsw_sp *mlxsw_sp, u8 local_port,
+static int __mlxsw_sp_port_fdb_uc_op(struct mlxsw_sp *mlxsw_sp, u16 local_port,
 				     const char *mac, u16 fid, bool adding,
 				     enum mlxsw_reg_sfd_rec_action action,
 				     enum mlxsw_reg_sfd_rec_policy policy)
@@ -1363,7 +1363,7 @@ static int __mlxsw_sp_port_fdb_uc_op(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 	return err;
 }
 
-static int mlxsw_sp_port_fdb_uc_op(struct mlxsw_sp *mlxsw_sp, u8 local_port,
+static int mlxsw_sp_port_fdb_uc_op(struct mlxsw_sp *mlxsw_sp, u16 local_port,
 				   const char *mac, u16 fid, bool adding,
 				   bool dynamic)
 {
@@ -2536,7 +2536,7 @@ static void mlxsw_sp_fdb_notify_mac_process(struct mlxsw_sp *mlxsw_sp,
 	struct mlxsw_sp_port *mlxsw_sp_port;
 	enum switchdev_notifier_type type;
 	char mac[ETH_ALEN];
-	u8 local_port;
+	u16 local_port;
 	u16 vid, fid;
 	bool do_notification = true;
 	int err;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 26d01adbedad..47b061b99160 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -60,7 +60,7 @@ enum {
 };
 
 static int mlxsw_sp_rx_listener(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
-				u8 local_port,
+				u16 local_port,
 				struct mlxsw_sp_port *mlxsw_sp_port)
 {
 	struct mlxsw_sp_port_pcpu_stats *pcpu_stats;
@@ -85,7 +85,7 @@ static int mlxsw_sp_rx_listener(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
 	return 0;
 }
 
-static void mlxsw_sp_rx_drop_listener(struct sk_buff *skb, u8 local_port,
+static void mlxsw_sp_rx_drop_listener(struct sk_buff *skb, u16 local_port,
 				      void *trap_ctx)
 {
 	struct devlink_port *in_devlink_port;
@@ -109,7 +109,7 @@ static void mlxsw_sp_rx_drop_listener(struct sk_buff *skb, u8 local_port,
 	consume_skb(skb);
 }
 
-static void mlxsw_sp_rx_acl_drop_listener(struct sk_buff *skb, u8 local_port,
+static void mlxsw_sp_rx_acl_drop_listener(struct sk_buff *skb, u16 local_port,
 					  void *trap_ctx)
 {
 	u32 cookie_index = mlxsw_skb_cb(skb)->rx_md_info.cookie_index;
@@ -138,7 +138,7 @@ static void mlxsw_sp_rx_acl_drop_listener(struct sk_buff *skb, u8 local_port,
 	consume_skb(skb);
 }
 
-static int __mlxsw_sp_rx_no_mark_listener(struct sk_buff *skb, u8 local_port,
+static int __mlxsw_sp_rx_no_mark_listener(struct sk_buff *skb, u16 local_port,
 					  void *trap_ctx)
 {
 	struct devlink_port *in_devlink_port;
@@ -164,7 +164,7 @@ static int __mlxsw_sp_rx_no_mark_listener(struct sk_buff *skb, u8 local_port,
 	return 0;
 }
 
-static void mlxsw_sp_rx_no_mark_listener(struct sk_buff *skb, u8 local_port,
+static void mlxsw_sp_rx_no_mark_listener(struct sk_buff *skb, u16 local_port,
 					 void *trap_ctx)
 {
 	int err;
@@ -176,14 +176,14 @@ static void mlxsw_sp_rx_no_mark_listener(struct sk_buff *skb, u8 local_port,
 	netif_receive_skb(skb);
 }
 
-static void mlxsw_sp_rx_mark_listener(struct sk_buff *skb, u8 local_port,
+static void mlxsw_sp_rx_mark_listener(struct sk_buff *skb, u16 local_port,
 				      void *trap_ctx)
 {
 	skb->offload_fwd_mark = 1;
 	mlxsw_sp_rx_no_mark_listener(skb, local_port, trap_ctx);
 }
 
-static void mlxsw_sp_rx_l3_mark_listener(struct sk_buff *skb, u8 local_port,
+static void mlxsw_sp_rx_l3_mark_listener(struct sk_buff *skb, u16 local_port,
 					 void *trap_ctx)
 {
 	skb->offload_l3_fwd_mark = 1;
@@ -191,7 +191,7 @@ static void mlxsw_sp_rx_l3_mark_listener(struct sk_buff *skb, u8 local_port,
 	mlxsw_sp_rx_no_mark_listener(skb, local_port, trap_ctx);
 }
 
-static void mlxsw_sp_rx_ptp_listener(struct sk_buff *skb, u8 local_port,
+static void mlxsw_sp_rx_ptp_listener(struct sk_buff *skb, u16 local_port,
 				     void *trap_ctx)
 {
 	struct mlxsw_sp *mlxsw_sp = devlink_trap_ctx_priv(trap_ctx);
@@ -212,7 +212,7 @@ static struct mlxsw_sp_port *
 mlxsw_sp_sample_tx_port_get(struct mlxsw_sp *mlxsw_sp,
 			    const struct mlxsw_rx_md_info *rx_md_info)
 {
-	u8 local_port;
+	u16 local_port;
 
 	if (!rx_md_info->tx_port_valid)
 		return NULL;
@@ -257,7 +257,7 @@ static void mlxsw_sp_psample_md_init(struct mlxsw_sp *mlxsw_sp,
 	md->latency <<= MLXSW_SP_MIRROR_LATENCY_SHIFT;
 }
 
-static void mlxsw_sp_rx_sample_listener(struct sk_buff *skb, u8 local_port,
+static void mlxsw_sp_rx_sample_listener(struct sk_buff *skb, u16 local_port,
 					void *trap_ctx)
 {
 	struct mlxsw_sp *mlxsw_sp = devlink_trap_ctx_priv(trap_ctx);
@@ -293,7 +293,7 @@ static void mlxsw_sp_rx_sample_listener(struct sk_buff *skb, u8 local_port,
 	consume_skb(skb);
 }
 
-static void mlxsw_sp_rx_sample_tx_listener(struct sk_buff *skb, u8 local_port,
+static void mlxsw_sp_rx_sample_tx_listener(struct sk_buff *skb, u16 local_port,
 					   void *trap_ctx)
 {
 	struct mlxsw_rx_md_info *rx_md_info = &mlxsw_skb_cb(skb)->rx_md_info;
@@ -343,7 +343,7 @@ static void mlxsw_sp_rx_sample_tx_listener(struct sk_buff *skb, u8 local_port,
 	consume_skb(skb);
 }
 
-static void mlxsw_sp_rx_sample_acl_listener(struct sk_buff *skb, u8 local_port,
+static void mlxsw_sp_rx_sample_acl_listener(struct sk_buff *skb, u16 local_port,
 					    void *trap_ctx)
 {
 	struct mlxsw_sp *mlxsw_sp = devlink_trap_ctx_priv(trap_ctx);
-- 
2.31.1

