Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A1C2289F9
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 22:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730930AbgGUUeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 16:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730482AbgGUUeW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 16:34:22 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12148C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 13:34:22 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id s189so12453976pgc.13
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 13:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Cq9IndfYDBrYLmUddjgBx0Nvzf74FXIb0izEIR6F5XI=;
        b=bxCineDmwjONHrNxQBJ4xeBSE07627YigMR77xskFdqp3PTng9Vwc32NiIEQQCHnWg
         qv7csO4RAZyIIKIUt5Ai6onBNDlAMntPibggGl8uxL3fSEvDN3uJOQF4ymWEUEK1zgeX
         e1Md+yWx0wGn91dbwBV6JNhWrAvxA6Y5bU+jF11CMkvByc+wCo+WxKF4wF62qcd3xKjo
         krAbLLwsNEp5Bosa54HWciHLR4oMhAI5Kzp3jsvDIbLTN1Xhw70xXkoPVJCpe7PCIxj7
         gvKs3c9TdyVYf5b/CuvO9xwyd0da1dEBxWGfea6qxha14xR3skpt+lxVdYVeq1Keur/J
         SCww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Cq9IndfYDBrYLmUddjgBx0Nvzf74FXIb0izEIR6F5XI=;
        b=DFqBHuHiDAGDN5rrnVffFIwgVwAqaR69YsnsJlvOzE2Qr+W7kLjAOaMZ+JUNEoQ6uI
         7jnk+R1PmWhTIgeYXXEXyv+pNKeJmlUxgfN/yh/g08Snx1981TLa0GO0ql/rm9K3yGC9
         zXSn74GJvi5HcZ1QKuCqMzTMIsMQG5tyXHnpkaw+SHmTRhkMzONiHawPhDZwOFmv806y
         ADWxSo5CVYWYepvNs7tPYwk6VnCGvfbyyLq0ngys64IQSu6zj6rGbr/mDJk+X8ccW9tb
         8Ez+bTO8v+C/hYy7l+GM2/Qg+Lz8MSidQYoYxqJ9ZmCh6cyNTuLcpQE6bzYdRscg+rbR
         drCg==
X-Gm-Message-State: AOAM533HbOYzteQszEORSOaGDmbOO4TFBaqEU4Ai4CGPi+EXynRmf1jr
        +R18QatwB/d7uk2vhGgles5bLSD3l2Y=
X-Google-Smtp-Source: ABdhPJy1m54k3mCX0cBmTybX95V+DqOAUB7PuOjTJznugzQlklcnEV/N+RPu4Fg5VpzhcnS+SsvMFQ==
X-Received: by 2002:a63:6744:: with SMTP id b65mr24466014pgc.42.1595363661102;
        Tue, 21 Jul 2020 13:34:21 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id p11sm4075107pjb.3.2020.07.21.13.34.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jul 2020 13:34:20 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 6/6] ionic: interface file updates
Date:   Tue, 21 Jul 2020 13:34:09 -0700
Message-Id: <20200721203409.3432-7-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721203409.3432-1-snelson@pensando.io>
References: <20200721203409.3432-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add some new interface values and update a few more descriptions.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_if.h    | 88 ++++++++++++++-----
 1 file changed, 68 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_if.h b/drivers/net/ethernet/pensando/ionic/ionic_if.h
index 7e22ba4ed915..acc94b244cf3 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_if.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_if.h
@@ -59,6 +59,8 @@ enum ionic_cmd_opcode {
 	IONIC_CMD_QOS_CLASS_INIT		= 241,
 	IONIC_CMD_QOS_CLASS_RESET		= 242,
 	IONIC_CMD_QOS_CLASS_UPDATE		= 243,
+	IONIC_CMD_QOS_CLEAR_STATS		= 244,
+	IONIC_CMD_QOS_RESET			= 245,
 
 	/* Firmware commands */
 	IONIC_CMD_FW_DOWNLOAD			= 254,
@@ -90,8 +92,8 @@ enum ionic_status_code {
 	IONIC_RC_DEV_CMD	= 18,	/* Device cmd attempted on AdminQ */
 	IONIC_RC_ENOSUPP	= 19,	/* Operation not supported */
 	IONIC_RC_ERROR		= 29,	/* Generic error */
-
 	IONIC_RC_ERDMA		= 30,	/* Generic RDMA error */
+	IONIC_RC_EVFID		= 31,	/* VF ID does not exist */
 };
 
 enum ionic_notifyq_opcode {
@@ -103,7 +105,7 @@ enum ionic_notifyq_opcode {
 };
 
 /**
- * struct cmd - General admin command format
+ * struct ionic_admin_cmd - General admin command format
  * @opcode:     Opcode for the command
  * @lif_index:  LIF index
  * @cmd_data:   Opcode-specific command bytes
@@ -167,7 +169,7 @@ struct ionic_dev_init_cmd {
 };
 
 /**
- * struct init_comp - Device init command completion
+ * struct ionic_dev_init_comp - Device init command completion
  * @status: Status of the command (enum ionic_status_code)
  */
 struct ionic_dev_init_comp {
@@ -185,7 +187,7 @@ struct ionic_dev_reset_cmd {
 };
 
 /**
- * struct reset_comp - Reset command completion
+ * struct ionic_dev_reset_comp - Reset command completion
  * @status: Status of the command (enum ionic_status_code)
  */
 struct ionic_dev_reset_comp {
@@ -357,12 +359,12 @@ struct ionic_lif_logical_qtype {
  * enum ionic_lif_state - LIF state
  * @IONIC_LIF_DISABLE:     LIF disabled
  * @IONIC_LIF_ENABLE:      LIF enabled
- * @IONIC_LIF_HANG_RESET:  LIF hung, being reset
+ * @IONIC_LIF_QUIESCE:     LIF Quiesced
  */
 enum ionic_lif_state {
-	IONIC_LIF_DISABLE	= 0,
+	IONIC_LIF_QUIESCE	= 0,
 	IONIC_LIF_ENABLE	= 1,
-	IONIC_LIF_HANG_RESET	= 2,
+	IONIC_LIF_DISABLE	= 2,
 };
 
 /**
@@ -371,6 +373,7 @@ enum ionic_lif_state {
  * @name:           LIF name
  * @mtu:            MTU
  * @mac:            Station MAC address
+ * @vlan:           Default Vlan ID
  * @features:       Features (enum ionic_eth_hw_features)
  * @queue_count:    Queue counts per queue-type
  */
@@ -381,7 +384,7 @@ union ionic_lif_config {
 		char   name[IONIC_IFNAMSIZ];
 		__le32 mtu;
 		u8     mac[6];
-		u8     rsvd2[2];
+		__le16 vlan;
 		__le64 features;
 		__le32 queue_count[IONIC_QTYPE_MAX];
 	} __packed;
@@ -489,13 +492,13 @@ struct ionic_lif_init_comp {
 	u8 rsvd2[12];
 };
 
- /**
-  * struct ionic_q_identify_cmd - queue identify command
-  * @opcode:     opcode
-  * @lif_type:   LIF type (enum ionic_lif_type)
-  * @type:       Logical queue type (enum ionic_logical_qtype)
-  * @ver:        Highest queue type version that the driver supports
-  */
+/**
+ * struct ionic_q_identify_cmd - queue identify command
+ * @opcode:     opcode
+ * @lif_type:   LIF type (enum ionic_lif_type)
+ * @type:       Logical queue type (enum ionic_logical_qtype)
+ * @ver:        Highest queue type version that the driver supports
+ */
 struct ionic_q_identify_cmd {
 	u8     opcode;
 	u8     rsvd;
@@ -983,6 +986,14 @@ enum ionic_pkt_type {
 	IONIC_PKT_TYPE_IPV6       = 0x008,
 	IONIC_PKT_TYPE_IPV6_TCP   = 0x018,
 	IONIC_PKT_TYPE_IPV6_UDP   = 0x028,
+	/* below types are only used if encap offloads are enabled on lif */
+	IONIC_PKT_TYPE_ENCAP_NON_IP	= 0x40,
+	IONIC_PKT_TYPE_ENCAP_IPV4	= 0x41,
+	IONIC_PKT_TYPE_ENCAP_IPV4_TCP	= 0x43,
+	IONIC_PKT_TYPE_ENCAP_IPV4_UDP	= 0x45,
+	IONIC_PKT_TYPE_ENCAP_IPV6	= 0x48,
+	IONIC_PKT_TYPE_ENCAP_IPV6_TCP	= 0x58,
+	IONIC_PKT_TYPE_ENCAP_IPV6_UDP	= 0x68,
 };
 
 enum ionic_eth_hw_features {
@@ -1003,6 +1014,9 @@ enum ionic_eth_hw_features {
 	IONIC_ETH_HW_TSO_IPXIP6		= BIT(14),
 	IONIC_ETH_HW_TSO_UDP		= BIT(15),
 	IONIC_ETH_HW_TSO_UDP_CSUM	= BIT(16),
+	IONIC_ETH_HW_RX_CSUM_GENEVE	= BIT(17),
+	IONIC_ETH_HW_TX_CSUM_GENEVE	= BIT(18),
+	IONIC_ETH_HW_TSO_GENEVE		= BIT(19)
 };
 
 /**
@@ -1011,7 +1025,7 @@ enum ionic_eth_hw_features {
  * @type:       Queue type
  * @lif_index:  LIF index
  * @index:      Queue index
- * @oper:       Operation (enum q_control_oper)
+ * @oper:       Operation (enum ionic_q_control_oper)
  */
 struct ionic_q_control_cmd {
 	u8     opcode;
@@ -1172,7 +1186,7 @@ enum ionic_port_loopback_mode {
  * struct ionic_xcvr_status - Transceiver Status information
  * @state:    Transceiver status (enum ionic_xcvr_state)
  * @phy:      Physical connection type (enum ionic_phy_type)
- * @pid:      Transceiver link mode (enum pid)
+ * @pid:      Transceiver link mode (enum ionic_xcvr_pid)
  * @sprom:    Transceiver sprom contents
  */
 struct ionic_xcvr_status {
@@ -1186,7 +1200,7 @@ struct ionic_xcvr_status {
  * union ionic_port_config - Port configuration
  * @speed:              port speed (in Mbps)
  * @mtu:                mtu
- * @state:              port admin state (enum port_admin_state)
+ * @state:              port admin state (enum ionic_port_admin_state)
  * @an_enable:          autoneg enable
  * @fec_type:           fec type (enum ionic_port_fec_type)
  * @pause_type:         pause type (enum ionic_port_pause_type)
@@ -1874,12 +1888,14 @@ struct ionic_qos_identify_comp {
 };
 
 #define IONIC_QOS_TC_MAX		8
+#define IONIC_QOS_ALL_TC		0xFF
 /* Capri max supported, should be renamed. */
 #define IONIC_QOS_CLASS_MAX		7
 #define IONIC_QOS_PCP_MAX		8
 #define IONIC_QOS_CLASS_NAME_SZ	32
 #define IONIC_QOS_DSCP_MAX		64
 #define IONIC_QOS_ALL_PCP		0xFF
+#define IONIC_DSCP_BLOCK_SIZE		8
 
 /**
  * enum ionic_qos_class
@@ -1923,6 +1939,7 @@ enum ionic_qos_sched_type {
  *	IONIC_QOS_CONFIG_F_NO_DROP		drop/nodrop
  *	IONIC_QOS_CONFIG_F_RW_DOT1Q_PCP		enable dot1q pcp rewrite
  *	IONIC_QOS_CONFIG_F_RW_IP_DSCP		enable ip dscp rewrite
+ *	IONIC_QOS_CONFIG_F_NON_DISRUPTIVE	Non-disruptive TC update
  * @sched_type:		QoS class scheduling type (enum ionic_qos_sched_type)
  * @class_type:		QoS class type (enum ionic_qos_class_type)
  * @pause_type:		QoS pause type (enum ionic_qos_pause_type)
@@ -1944,6 +1961,8 @@ union ionic_qos_config {
 /* Used to rewrite PCP or DSCP value. */
 #define IONIC_QOS_CONFIG_F_RW_DOT1Q_PCP		BIT(2)
 #define IONIC_QOS_CONFIG_F_RW_IP_DSCP		BIT(3)
+/* Non-disruptive TC update */
+#define IONIC_QOS_CONFIG_F_NON_DISRUPTIVE	BIT(4)
 		u8      flags;
 		u8      sched_type;
 		u8      class_type;
@@ -2019,6 +2038,16 @@ struct ionic_qos_reset_cmd {
 	u8    rsvd[62];
 };
 
+/**
+ * struct ionic_qos_clear_port_stats_cmd - Qos config reset command
+ * @opcode:	Opcode
+ */
+struct ionic_qos_clear_stats_cmd {
+	u8    opcode;
+	u8    group_bitmap;
+	u8    rsvd[62];
+};
+
 typedef struct ionic_admin_comp ionic_qos_reset_comp;
 
 /**
@@ -2164,7 +2193,7 @@ struct ionic_notifyq_event {
  * struct ionic_link_change_event - Link change event notification
  * @eid:		event number
  * @ecode:		event code = IONIC_EVENT_LINK_CHANGE
- * @link_status:	link up or down, with error bits (enum port_status)
+ * @link_status:	link up/down, with error bits (enum ionic_port_status)
  * @link_speed:		speed of the network link
  *
  * Sent when the network link state changes between UP and DOWN
@@ -2377,6 +2406,16 @@ enum ionic_pb_buffer_drop_stats {
 	IONIC_BUFFER_DROP_MAX,
 };
 
+enum ionic_oflow_drop_stats {
+	IONIC_OFLOW_OCCUPANCY_DROP,
+	IONIC_OFLOW_EMERGENCY_STOP_DROP,
+	IONIC_OFLOW_WRITE_BUFFER_ACK_FILL_UP_DROP,
+	IONIC_OFLOW_WRITE_BUFFER_ACK_FULL_DROP,
+	IONIC_OFLOW_WRITE_BUFFER_FULL_DROP,
+	IONIC_OFLOW_CONTROL_FIFO_FULL_DROP,
+	IONIC_OFLOW_DROP_MAX,
+};
+
 /**
  * struct port_pb_stats - packet buffers system stats
  * uses ionic_pb_buffer_drop_stats for drop_counts[]
@@ -2390,12 +2429,20 @@ struct ionic_port_pb_stats {
 	__le64 input_queue_buffer_occupancy[IONIC_QOS_TC_MAX];
 	__le64 input_queue_port_monitor[IONIC_QOS_TC_MAX];
 	__le64 output_queue_port_monitor[IONIC_QOS_TC_MAX];
+	__le64 oflow_drop_counts[IONIC_OFLOW_DROP_MAX];
+	__le64 input_queue_good_pkts_in[IONIC_QOS_TC_MAX];
+	__le64 input_queue_good_pkts_out[IONIC_QOS_TC_MAX];
+	__le64 input_queue_err_pkts_in[IONIC_QOS_TC_MAX];
+	__le64 input_queue_fifo_depth[IONIC_QOS_TC_MAX];
+	__le64 input_queue_max_fifo_depth[IONIC_QOS_TC_MAX];
+	__le64 input_queue_peak_occupancy[IONIC_QOS_TC_MAX];
+	__le64 output_queue_buffer_occupancy[IONIC_QOS_TC_MAX];
 };
 
 /**
  * struct ionic_port_identity - port identity structure
  * @version:        identity structure version
- * @type:           type of port (enum port_type)
+ * @type:           type of port (enum ionic_port_type)
  * @num_lanes:      number of lanes for the port
  * @autoneg:        autoneg supported
  * @min_frame_size: minimum frame size supported
@@ -2637,6 +2684,7 @@ union ionic_dev_cmd {
 	struct ionic_qos_identify_cmd qos_identify;
 	struct ionic_qos_init_cmd qos_init;
 	struct ionic_qos_reset_cmd qos_reset;
+	struct ionic_qos_clear_stats_cmd qos_clear_stats;
 
 	struct ionic_q_identify_cmd q_identify;
 	struct ionic_q_init_cmd q_init;
-- 
2.17.1

