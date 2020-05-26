Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 110061CE9E1
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 03:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbgELA74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 20:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728396AbgELA7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 20:59:55 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0A3C061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 17:59:53 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 18so5548016pfx.6
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 17:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sDqRUNNpVHWFtpzYexDvPfYHNRccQhdQu21LEkCkGrU=;
        b=pcLpF6embA90Wnph8wUQp0wv5bFmFBCJJ67zoLPNKZY7Ar0kysKKdMk+wOV8e1XnkE
         QXwxSz5nnBfhn0qh7quzE4dVjQAQIFS7INynxtPfBlZaJ4jPBMiMWDY09HyYvbh4GA6E
         296dB1JsTd55m9cFbbL+lPv/FDX8l6RqgLu4OmYmH4+Fc6GCIHBFCH5KgLnEQieQcLSe
         BlwvE1yM94lH4u24MzBarZjC0nwUYuCcatB3vtqJBysTnu61mUHsPq4bGYVTvt5jOIXi
         fYHuO46ss+p2C9XplkYrzSgU5Zysqx4klsd15H60P1hlc2DQUaT68Boj4ayXkt3CHJQr
         Fhpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sDqRUNNpVHWFtpzYexDvPfYHNRccQhdQu21LEkCkGrU=;
        b=YALpT0h6QXiWbjQ9/OueRPUGkYf5K5Vyxg+MqvVuUurUIfNJDZOL4ao/ENX786PGdb
         vhLJgpQg6rcA3zJ8PQ8BJyH9YZF7TFvN1rbpAusGaXcrxDreukRURVl+SqhXEAJCEyhC
         TWDbNe7KRPYRqt419fEYrF0SbXLCvuEXqkx5Odczcf/MW449iV66wgjwyJHaSUGyfoCJ
         a+7/uDgzvj8xvn5NIxQxGUJ3QSu/laHSbdzYkuhrjC5C7iixzqkprbikzSS8eFQYDszS
         46oBUrdKsVRIzptpPdaMPAw26oQwTUkZLxwoptofX3wiDnXdg555KKgqSPlEUDGNOl0F
         QTQQ==
X-Gm-Message-State: AGi0PuZg/4ZFPyKEBehGE6SHEw1o6kuy9Bink3+2L9EMo7eiyB3BVvny
        +DyP+EmyHPOEwn0K3HcJNbfPRDcpN4c=
X-Google-Smtp-Source: APiQypJH7DLI/n2zyCCO5B6zlhkH6gFesw4VpKn4rtZ1fTdfgSlA1GpfMfL/lo5LHQTvNVvlWhuVZQ==
X-Received: by 2002:a62:3241:: with SMTP id y62mr18219922pfy.194.1589245190858;
        Mon, 11 May 2020 17:59:50 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h17sm10171477pfk.13.2020.05.11.17.59.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 May 2020 17:59:50 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 02/10] ionic: updates to ionic FW api description
Date:   Mon, 11 May 2020 17:59:28 -0700
Message-Id: <20200512005936.14490-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200512005936.14490-1-snelson@pensando.io>
References: <20200512005936.14490-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lots of comment cleanup for better documentation, a few new
fields added, and a few minor mistakes fixed up.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_if.h    | 979 +++++++++++-------
 1 file changed, 576 insertions(+), 403 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_if.h b/drivers/net/ethernet/pensando/ionic/ionic_if.h
index 799f3ea599e9..7e22ba4ed915 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_if.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_if.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: (GPL-2.0 OR Linux-OpenIB) OR BSD-2-Clause */
-/* Copyright (c) 2017-2019 Pensando Systems, Inc.  All rights reserved. */
+/* Copyright (c) 2017-2020 Pensando Systems, Inc.  All rights reserved. */
 
 #ifndef _IONIC_IF_H_
 #define _IONIC_IF_H_
@@ -9,7 +9,7 @@
 #define IONIC_IFNAMSIZ				16
 
 /**
- * Commands
+ * enum ionic_cmd_opcode - Device commands
  */
 enum ionic_cmd_opcode {
 	IONIC_CMD_NOP				= 0,
@@ -58,6 +58,7 @@ enum ionic_cmd_opcode {
 	IONIC_CMD_QOS_CLASS_IDENTIFY		= 240,
 	IONIC_CMD_QOS_CLASS_INIT		= 241,
 	IONIC_CMD_QOS_CLASS_RESET		= 242,
+	IONIC_CMD_QOS_CLASS_UPDATE		= 243,
 
 	/* Firmware commands */
 	IONIC_CMD_FW_DOWNLOAD			= 254,
@@ -65,7 +66,7 @@ enum ionic_cmd_opcode {
 };
 
 /**
- * Command Return codes
+ * enum ionic_status_code - Device command return codes
  */
 enum ionic_status_code {
 	IONIC_RC_SUCCESS	= 0,	/* Success */
@@ -98,6 +99,7 @@ enum ionic_notifyq_opcode {
 	IONIC_EVENT_RESET		= 2,
 	IONIC_EVENT_HEARTBEAT		= 3,
 	IONIC_EVENT_LOG			= 4,
+	IONIC_EVENT_XCVR		= 5,
 };
 
 /**
@@ -115,12 +117,11 @@ struct ionic_admin_cmd {
 
 /**
  * struct ionic_admin_comp - General admin command completion format
- * @status:     The status of the command (enum status_code)
- * @comp_index: The index in the descriptor ring for which this
- *              is the completion.
- * @cmd_data:   Command-specific bytes.
- * @color:      Color bit.  (Always 0 for commands issued to the
- *              Device Cmd Registers.)
+ * @status:     Status of the command (enum ionic_status_code)
+ * @comp_index: Index in the descriptor ring for which this is the completion
+ * @cmd_data:   Command-specific bytes
+ * @color:      Color bit (Always 0 for commands issued to the
+ *              Device Cmd Registers)
  */
 struct ionic_admin_comp {
 	u8     status;
@@ -147,7 +148,7 @@ struct ionic_nop_cmd {
 
 /**
  * struct ionic_nop_comp - NOP command completion
- * @status: The status of the command (enum status_code)
+ * @status: Status of the command (enum ionic_status_code)
  */
 struct ionic_nop_comp {
 	u8 status;
@@ -157,7 +158,7 @@ struct ionic_nop_comp {
 /**
  * struct ionic_dev_init_cmd - Device init command
  * @opcode:    opcode
- * @type:      device type
+ * @type:      Device type
  */
 struct ionic_dev_init_cmd {
 	u8     opcode;
@@ -167,7 +168,7 @@ struct ionic_dev_init_cmd {
 
 /**
  * struct init_comp - Device init command completion
- * @status: The status of the command (enum status_code)
+ * @status: Status of the command (enum ionic_status_code)
  */
 struct ionic_dev_init_comp {
 	u8 status;
@@ -185,7 +186,7 @@ struct ionic_dev_reset_cmd {
 
 /**
  * struct reset_comp - Reset command completion
- * @status: The status of the command (enum status_code)
+ * @status: Status of the command (enum ionic_status_code)
  */
 struct ionic_dev_reset_comp {
 	u8 status;
@@ -206,8 +207,8 @@ struct ionic_dev_identify_cmd {
 };
 
 /**
- * struct dev_identify_comp - Driver/device identify command completion
- * @status: The status of the command (enum status_code)
+ * struct ionic_dev_identify_comp - Driver/device identify command completion
+ * @status: Status of the command (enum ionic_status_code)
  * @ver:    Version of identify returned by device
  */
 struct ionic_dev_identify_comp {
@@ -226,8 +227,8 @@ enum ionic_os_type {
 };
 
 /**
- * union drv_identity - driver identity information
- * @os_type:          OS type (see enum os_type)
+ * union ionic_drv_identity - driver identity information
+ * @os_type:          OS type (see enum ionic_os_type)
  * @os_dist:          OS distribution, numeric format
  * @os_dist_str:      OS distribution, string format
  * @kernel_ver:       Kernel version, numeric format
@@ -243,26 +244,26 @@ union ionic_drv_identity {
 		char   kernel_ver_str[32];
 		char   driver_ver_str[32];
 	};
-	__le32 words[512];
+	__le32 words[478];
 };
 
 /**
- * union dev_identity - device identity information
+ * union ionic_dev_identity - device identity information
  * @version:          Version of device identify
  * @type:             Identify type (0 for now)
  * @nports:           Number of ports provisioned
  * @nlifs:            Number of LIFs provisioned
  * @nintrs:           Number of interrupts provisioned
  * @ndbpgs_per_lif:   Number of doorbell pages per LIF
- * @intr_coal_mult:   Interrupt coalescing multiplication factor.
+ * @intr_coal_mult:   Interrupt coalescing multiplication factor
  *                    Scale user-supplied interrupt coalescing
  *                    value in usecs to device units using:
  *                    device units = usecs * mult / div
- * @intr_coal_div:    Interrupt coalescing division factor.
+ * @intr_coal_div:    Interrupt coalescing division factor
  *                    Scale user-supplied interrupt coalescing
  *                    value in usecs to device units using:
  *                    device units = usecs * mult / div
- *
+ * @eq_count:         Number of shared event queues
  */
 union ionic_dev_identity {
 	struct {
@@ -276,8 +277,9 @@ union ionic_dev_identity {
 		__le32 ndbpgs_per_lif;
 		__le32 intr_coal_mult;
 		__le32 intr_coal_div;
+		__le32 eq_count;
 	};
-	__le32 words[512];
+	__le32 words[478];
 };
 
 enum ionic_lif_type {
@@ -287,10 +289,10 @@ enum ionic_lif_type {
 };
 
 /**
- * struct ionic_lif_identify_cmd - lif identify command
+ * struct ionic_lif_identify_cmd - LIF identify command
  * @opcode:  opcode
- * @type:    lif type (enum lif_type)
- * @ver:     version of identify returned by device
+ * @type:    LIF type (enum ionic_lif_type)
+ * @ver:     Version of identify returned by device
  */
 struct ionic_lif_identify_cmd {
 	u8 opcode;
@@ -300,9 +302,9 @@ struct ionic_lif_identify_cmd {
 };
 
 /**
- * struct ionic_lif_identify_comp - lif identify command completion
- * @status:  status of the command (enum status_code)
- * @ver:     version of identify returned by device
+ * struct ionic_lif_identify_comp - LIF identify command completion
+ * @status:  Status of the command (enum ionic_status_code)
+ * @ver:     Version of identify returned by device
  */
 struct ionic_lif_identify_comp {
 	u8 status;
@@ -310,13 +312,24 @@ struct ionic_lif_identify_comp {
 	u8 rsvd2[14];
 };
 
+/**
+ * enum ionic_lif_capability - LIF capabilities
+ * @IONIC_LIF_CAP_ETH:     LIF supports Ethernet
+ * @IONIC_LIF_CAP_RDMA:    LIF support RDMA
+ */
 enum ionic_lif_capability {
 	IONIC_LIF_CAP_ETH        = BIT(0),
 	IONIC_LIF_CAP_RDMA       = BIT(1),
 };
 
 /**
- * Logical Queue Types
+ * enum ionic_logical_qtype - Logical Queue Types
+ * @IONIC_QTYPE_ADMINQ:    Administrative Queue
+ * @IONIC_QTYPE_NOTIFYQ:   Notify Queue
+ * @IONIC_QTYPE_RXQ:       Receive Queue
+ * @IONIC_QTYPE_TXQ:       Transmit Queue
+ * @IONIC_QTYPE_EQ:        Event Queue
+ * @IONIC_QTYPE_MAX:       Max queue type supported
  */
 enum ionic_logical_qtype {
 	IONIC_QTYPE_ADMINQ  = 0,
@@ -328,10 +341,10 @@ enum ionic_logical_qtype {
 };
 
 /**
- * struct ionic_lif_logical_qtype - Descriptor of logical to hardware queue type.
- * @qtype:          Hardware Queue Type.
- * @qid_count:      Number of Queue IDs of the logical type.
- * @qid_base:       Minimum Queue ID of the logical type.
+ * struct ionic_lif_logical_qtype - Descriptor of logical to HW queue type
+ * @qtype:          Hardware Queue Type
+ * @qid_count:      Number of Queue IDs of the logical type
+ * @qid_base:       Minimum Queue ID of the logical type
  */
 struct ionic_lif_logical_qtype {
 	u8     qtype;
@@ -340,6 +353,12 @@ struct ionic_lif_logical_qtype {
 	__le32 qid_base;
 };
 
+/**
+ * enum ionic_lif_state - LIF state
+ * @IONIC_LIF_DISABLE:     LIF disabled
+ * @IONIC_LIF_ENABLE:      LIF enabled
+ * @IONIC_LIF_HANG_RESET:  LIF hung, being reset
+ */
 enum ionic_lif_state {
 	IONIC_LIF_DISABLE	= 0,
 	IONIC_LIF_ENABLE	= 1,
@@ -347,13 +366,13 @@ enum ionic_lif_state {
 };
 
 /**
- * LIF configuration
- * @state:          lif state (enum lif_state)
- * @name:           lif name
- * @mtu:            mtu
- * @mac:            station mac address
- * @features:       features (enum ionic_eth_hw_features)
- * @queue_count:    queue counts per queue-type
+ * union ionic_lif_config - LIF configuration
+ * @state:          LIF state (enum ionic_lif_state)
+ * @name:           LIF name
+ * @mtu:            MTU
+ * @mac:            Station MAC address
+ * @features:       Features (enum ionic_eth_hw_features)
+ * @queue_count:    Queue counts per queue-type
  */
 union ionic_lif_config {
 	struct {
@@ -370,37 +389,36 @@ union ionic_lif_config {
 };
 
 /**
- * struct ionic_lif_identity - lif identity information (type-specific)
+ * struct ionic_lif_identity - LIF identity information (type-specific)
  *
- * @capabilities    LIF capabilities
+ * @capabilities:        LIF capabilities
  *
- * Ethernet:
- *     @version:          Ethernet identify structure version.
- *     @features:         Ethernet features supported on this lif type.
- *     @max_ucast_filters:  Number of perfect unicast addresses supported.
- *     @max_mcast_filters:  Number of perfect multicast addresses supported.
- *     @min_frame_size:   Minimum size of frames to be sent
- *     @max_frame_size:   Maximim size of frames to be sent
- *     @config:           LIF config struct with features, mtu, mac, q counts
+ * @eth:                    Ethernet identify structure
+ *     @version:            Ethernet identify structure version
+ *     @max_ucast_filters:  Number of perfect unicast addresses supported
+ *     @max_mcast_filters:  Number of perfect multicast addresses supported
+ *     @min_frame_size:     Minimum size of frames to be sent
+ *     @max_frame_size:     Maximim size of frames to be sent
+ *     @config:             LIF config struct with features, mtu, mac, q counts
  *
- * RDMA:
- *     @version:         RDMA version of opcodes and queue descriptors.
- *     @qp_opcodes:      Number of rdma queue pair opcodes supported.
- *     @admin_opcodes:   Number of rdma admin opcodes supported.
- *     @npts_per_lif:    Page table size per lif
- *     @nmrs_per_lif:    Number of memory regions per lif
- *     @nahs_per_lif:    Number of address handles per lif
- *     @max_stride:      Max work request stride.
- *     @cl_stride:       Cache line stride.
- *     @pte_stride:      Page table entry stride.
- *     @rrq_stride:      Remote RQ work request stride.
- *     @rsq_stride:      Remote SQ work request stride.
+ * @rdma:                RDMA identify structure
+ *     @version:         RDMA version of opcodes and queue descriptors
+ *     @qp_opcodes:      Number of RDMA queue pair opcodes supported
+ *     @admin_opcodes:   Number of RDMA admin opcodes supported
+ *     @npts_per_lif:    Page table size per LIF
+ *     @nmrs_per_lif:    Number of memory regions per LIF
+ *     @nahs_per_lif:    Number of address handles per LIF
+ *     @max_stride:      Max work request stride
+ *     @cl_stride:       Cache line stride
+ *     @pte_stride:      Page table entry stride
+ *     @rrq_stride:      Remote RQ work request stride
+ *     @rsq_stride:      Remote SQ work request stride
  *     @dcqcn_profiles:  Number of DCQCN profiles
- *     @aq_qtype:        RDMA Admin Qtype.
- *     @sq_qtype:        RDMA Send Qtype.
- *     @rq_qtype:        RDMA Receive Qtype.
- *     @cq_qtype:        RDMA Completion Qtype.
- *     @eq_qtype:        RDMA Event Qtype.
+ *     @aq_qtype:        RDMA Admin Qtype
+ *     @sq_qtype:        RDMA Send Qtype
+ *     @rq_qtype:        RDMA Receive Qtype
+ *     @cq_qtype:        RDMA Completion Qtype
+ *     @eq_qtype:        RDMA Event Qtype
  */
 union ionic_lif_identity {
 	struct {
@@ -440,15 +458,15 @@ union ionic_lif_identity {
 			struct ionic_lif_logical_qtype eq_qtype;
 		} __packed rdma;
 	} __packed;
-	__le32 words[512];
+	__le32 words[478];
 };
 
 /**
  * struct ionic_lif_init_cmd - LIF init command
- * @opcode:       opcode
- * @type:         LIF type (enum lif_type)
+ * @opcode:       Opcode
+ * @type:         LIF type (enum ionic_lif_type)
  * @index:        LIF index
- * @info_pa:      destination address for lif info (struct ionic_lif_info)
+ * @info_pa:      Destination address for LIF info (struct ionic_lif_info)
  */
 struct ionic_lif_init_cmd {
 	u8     opcode;
@@ -461,7 +479,8 @@ struct ionic_lif_init_cmd {
 
 /**
  * struct ionic_lif_init_comp - LIF init command completion
- * @status: The status of the command (enum status_code)
+ * @status:	Status of the command (enum ionic_status_code)
+ * @hw_index:	Hardware index of the initialized LIF
  */
 struct ionic_lif_init_comp {
 	u8 status;
@@ -534,10 +553,10 @@ union ionic_q_identity {
  * struct ionic_q_init_cmd - Queue init command
  * @opcode:       opcode
  * @type:         Logical queue type
- * @ver:          Queue version (defines opcode/descriptor scope)
+ * @ver:          Queue type version
  * @lif_index:    LIF index
- * @index:        (lif, qtype) relative admin queue index
- * @intr_index:   Interrupt control register index
+ * @index:        (LIF, qtype) relative admin queue index
+ * @intr_index:   Interrupt control register index, or Event queue index
  * @pid:          Process ID
  * @flags:
  *    IRQ:        Interrupt requested on completion
@@ -555,12 +574,11 @@ union ionic_q_identity {
  *                descriptors.  Values of ring_size <2 and >16 are
  *                reserved.
  *    EQ:         Enable the Event Queue
- * @cos:          Class of service for this queue.
+ * @cos:          Class of service for this queue
  * @ring_size:    Queue ring size, encoded as a log2(size)
  * @ring_base:    Queue ring base address
  * @cq_ring_base: Completion queue ring base address
  * @sg_ring_base: Scatter/Gather ring base address
- * @eq_index:	  Event queue index
  */
 struct ionic_q_init_cmd {
 	u8     opcode;
@@ -577,29 +595,27 @@ struct ionic_q_init_cmd {
 #define IONIC_QINIT_F_ENA	0x02	/* Enable the queue */
 #define IONIC_QINIT_F_SG	0x04	/* Enable scatter/gather on the queue */
 #define IONIC_QINIT_F_EQ	0x08	/* Enable event queue */
-#define IONIC_QINIT_F_DEBUG 0x80	/* Enable queue debugging */
+#define IONIC_QINIT_F_CMB	0x10	/* Enable cmb-based queue */
+#define IONIC_QINIT_F_DEBUG	0x80	/* Enable queue debugging */
 	u8     cos;
 	u8     ring_size;
 	__le64 ring_base;
 	__le64 cq_ring_base;
 	__le64 sg_ring_base;
-	__le32 eq_index;
-	u8     rsvd2[16];
+	u8     rsvd2[20];
 } __packed;
 
 /**
  * struct ionic_q_init_comp - Queue init command completion
- * @status:     The status of the command (enum status_code)
- * @ver:        Queue version (defines opcode/descriptor scope)
- * @comp_index: The index in the descriptor ring for which this
- *              is the completion.
+ * @status:     Status of the command (enum ionic_status_code)
+ * @comp_index: Index in the descriptor ring for which this is the completion
  * @hw_index:   Hardware Queue ID
  * @hw_type:    Hardware Queue type
  * @color:      Color
  */
 struct ionic_q_init_comp {
 	u8     status;
-	u8     ver;
+	u8     rsvd;
 	__le16 comp_index;
 	__le32 hw_index;
 	u8     hw_type;
@@ -620,10 +636,9 @@ enum ionic_txq_desc_opcode {
 
 /**
  * struct ionic_txq_desc - Ethernet Tx queue descriptor format
- * @opcode:       Tx operation, see TXQ_DESC_OPCODE_*:
+ * @cmd:          Tx operation, see IONIC_TXQ_DESC_OPCODE_*:
  *
  *                   IONIC_TXQ_DESC_OPCODE_CSUM_NONE:
- *
  *                      Non-offload send.  No segmentation,
  *                      fragmentation or checksum calc/insertion is
  *                      performed by device; packet is prepared
@@ -631,7 +646,6 @@ enum ionic_txq_desc_opcode {
  *                      no further manipulation from device.
  *
  *                   IONIC_TXQ_DESC_OPCODE_CSUM_PARTIAL:
- *
  *                      Offload 16-bit L4 checksum
  *                      calculation/insertion.  The device will
  *                      calculate the L4 checksum value and
@@ -640,14 +654,16 @@ enum ionic_txq_desc_opcode {
  *                      is calculated starting at @csum_start bytes
  *                      into the packet to the end of the packet.
  *                      The checksum insertion position is given
- *                      in @csum_offset.  This feature is only
- *                      applicable to protocols such as TCP, UDP
- *                      and ICMP where a standard (i.e. the
- *                      'IP-style' checksum) one's complement
- *                      16-bit checksum is used, using an IP
- *                      pseudo-header to seed the calculation.
- *                      Software will preload the L4 checksum
- *                      field with the IP pseudo-header checksum.
+ *                      in @csum_offset, which is the offset from
+ *                      @csum_start to the checksum field in the L4
+ *                      header.  This feature is only applicable to
+ *                      protocols such as TCP, UDP and ICMP where a
+ *                      standard (i.e. the 'IP-style' checksum)
+ *                      one's complement 16-bit checksum is used,
+ *                      using an IP pseudo-header to seed the
+ *                      calculation.  Software will preload the L4
+ *                      checksum field with the IP pseudo-header
+ *                      checksum.
  *
  *                      For tunnel encapsulation, @csum_start and
  *                      @csum_offset refer to the inner L4
@@ -663,7 +679,6 @@ enum ionic_txq_desc_opcode {
  *                      for more info).
  *
  *                   IONIC_TXQ_DESC_OPCODE_CSUM_HW:
- *
  *                      Offload 16-bit checksum computation to hardware.
  *                      If @csum_l3 is set then the packet's L3 checksum is
  *                      updated. Similarly, if @csum_l4 is set the the L4
@@ -671,7 +686,6 @@ enum ionic_txq_desc_opcode {
  *                      checksums are also updated.
  *
  *                   IONIC_TXQ_DESC_OPCODE_TSO:
- *
  *                      Device preforms TCP segmentation offload
  *                      (TSO).  @hdr_len is the number of bytes
  *                      to the end of TCP header (the offset to
@@ -698,40 +712,41 @@ enum ionic_txq_desc_opcode {
  *                      clear CWR in remaining segments.
  * @flags:
  *                vlan:
- *                    Insert an L2 VLAN header using @vlan_tci.
+ *                    Insert an L2 VLAN header using @vlan_tci
  *                encap:
- *                    Calculate encap header checksum.
+ *                    Calculate encap header checksum
  *                csum_l3:
- *                    Compute L3 header checksum.
+ *                    Compute L3 header checksum
  *                csum_l4:
- *                    Compute L4 header checksum.
+ *                    Compute L4 header checksum
  *                tso_sot:
  *                    TSO start
  *                tso_eot:
  *                    TSO end
  * @num_sg_elems: Number of scatter-gather elements in SG
  *                descriptor
- * @addr:         First data buffer's DMA address.
- *                (Subsequent data buffers are on txq_sg_desc).
+ * @addr:         First data buffer's DMA address
+ *                (Subsequent data buffers are on txq_sg_desc)
  * @len:          First data buffer's length, in bytes
  * @vlan_tci:     VLAN tag to insert in the packet (if requested
  *                by @V-bit).  Includes .1p and .1q tags
  * @hdr_len:      Length of packet headers, including
- *                encapsulating outer header, if applicable.
- *                Valid for opcodes TXQ_DESC_OPCODE_CALC_CSUM and
- *                TXQ_DESC_OPCODE_TSO.  Should be set to zero for
+ *                encapsulating outer header, if applicable
+ *                Valid for opcodes IONIC_TXQ_DESC_OPCODE_CALC_CSUM and
+ *                IONIC_TXQ_DESC_OPCODE_TSO.  Should be set to zero for
  *                all other modes.  For
- *                TXQ_DESC_OPCODE_CALC_CSUM, @hdr_len is length
+ *                IONIC_TXQ_DESC_OPCODE_CALC_CSUM, @hdr_len is length
  *                of headers up to inner-most L4 header.  For
- *                TXQ_DESC_OPCODE_TSO, @hdr_len is up to
+ *                IONIC_TXQ_DESC_OPCODE_TSO, @hdr_len is up to
  *                inner-most L4 payload, so inclusive of
  *                inner-most L4 header.
- * @mss:          Desired MSS value for TSO.  Only applicable for
- *                TXQ_DESC_OPCODE_TSO.
- * @csum_start:   Offset into inner-most L3 header of checksum
- * @csum_offset:  Offset into inner-most L4 header of checksum
+ * @mss:          Desired MSS value for TSO; only applicable for
+ *                IONIC_TXQ_DESC_OPCODE_TSO
+ * @csum_start:   Offset from packet to first byte checked in L4 checksum
+ * @csum_offset:  Offset from csum_start to L4 checksum field
  */
-
+struct ionic_txq_desc {
+	__le64  cmd;
 #define IONIC_TXQ_DESC_OPCODE_MASK		0xf
 #define IONIC_TXQ_DESC_OPCODE_SHIFT		4
 #define IONIC_TXQ_DESC_FLAGS_MASK		0xf
@@ -753,8 +768,6 @@ enum ionic_txq_desc_opcode {
 #define IONIC_TXQ_DESC_FLAG_TSO_SOT		0x4
 #define IONIC_TXQ_DESC_FLAG_TSO_EOT		0x8
 
-struct ionic_txq_desc {
-	__le64  cmd;
 	__le16  len;
 	union {
 		__le16  vlan_tci;
@@ -823,10 +836,9 @@ struct ionic_txq_sg_desc_v1 {
 
 /**
  * struct ionic_txq_comp - Ethernet transmit queue completion descriptor
- * @status:     The status of the command (enum status_code)
- * @comp_index: The index in the descriptor ring for which this
- *                 is the completion.
- * @color:      Color bit.
+ * @status:     Status of the command (enum ionic_status_code)
+ * @comp_index: Index in the descriptor ring for which this is the completion
+ * @color:      Color bit
  */
 struct ionic_txq_comp {
 	u8     status;
@@ -843,16 +855,15 @@ enum ionic_rxq_desc_opcode {
 
 /**
  * struct ionic_rxq_desc - Ethernet Rx queue descriptor format
- * @opcode:       Rx operation, see RXQ_DESC_OPCODE_*:
- *
- *                   RXQ_DESC_OPCODE_SIMPLE:
+ * @opcode:       Rx operation, see IONIC_RXQ_DESC_OPCODE_*:
  *
+ *                   IONIC_RXQ_DESC_OPCODE_SIMPLE:
  *                      Receive full packet into data buffer
  *                      starting at @addr.  Results of
  *                      receive, including actual bytes received,
  *                      are recorded in Rx completion descriptor.
  *
- * @len:          Data buffer's length, in bytes.
+ * @len:          Data buffer's length, in bytes
  * @addr:         Data buffer's DMA address
  */
 struct ionic_rxq_desc {
@@ -863,7 +874,7 @@ struct ionic_rxq_desc {
 };
 
 /**
- * struct ionic_rxq_sg_desc - Receive scatter-gather (SG) descriptor element
+ * struct ionic_rxq_sg_elem - Receive scatter-gather (SG) descriptor element
  * @addr:      DMA address of SG element data buffer
  * @len:       Length of SG element data buffer, in bytes
  */
@@ -885,12 +896,11 @@ struct ionic_rxq_sg_desc {
 
 /**
  * struct ionic_rxq_comp - Ethernet receive queue completion descriptor
- * @status:       The status of the command (enum status_code)
+ * @status:       Status of the command (enum ionic_status_code)
  * @num_sg_elems: Number of SG elements used by this descriptor
- * @comp_index:   The index in the descriptor ring for which this
- *                is the completion.
+ * @comp_index:   Index in the descriptor ring for which this is the completion
  * @rss_hash:     32-bit RSS hash
- * @csum:         16-bit sum of the packet's L2 payload.
+ * @csum:         16-bit sum of the packet's L2 payload
  *                If the packet's L2 payload is odd length, an extra
  *                zero-value byte is included in the @csum calculation but
  *                not included in @len.
@@ -898,33 +908,51 @@ struct ionic_rxq_sg_desc {
  *                set.  Includes .1p and .1q tags.
  * @len:          Received packet length, in bytes.  Excludes FCS.
  * @csum_calc     L2 payload checksum is computed or not
- * @csum_tcp_ok:  The TCP checksum calculated by the device
- *                matched the checksum in the receive packet's
- *                TCP header
- * @csum_tcp_bad: The TCP checksum calculated by the device did
- *                not match the checksum in the receive packet's
- *                TCP header.
- * @csum_udp_ok:  The UDP checksum calculated by the device
- *                matched the checksum in the receive packet's
- *                UDP header
- * @csum_udp_bad: The UDP checksum calculated by the device did
- *                not match the checksum in the receive packet's
- *                UDP header.
- * @csum_ip_ok:   The IPv4 checksum calculated by the device
- *                matched the checksum in the receive packet's
- *                first IPv4 header.  If the receive packet
- *                contains both a tunnel IPv4 header and a
- *                transport IPv4 header, the device validates the
- *                checksum for the both IPv4 headers.
- * @csum_ip_bad:  The IPv4 checksum calculated by the device did
- *                not match the checksum in the receive packet's
- *                first IPv4 header. If the receive packet
- *                contains both a tunnel IPv4 header and a
- *                transport IPv4 header, the device validates the
- *                checksum for both IP headers.
- * @VLAN:         VLAN header was stripped and placed in @vlan_tci.
- * @pkt_type:     Packet type
- * @color:        Color bit.
+ * @csum_flags:   See IONIC_RXQ_COMP_CSUM_F_*:
+ *
+ *                  IONIC_RXQ_COMP_CSUM_F_TCP_OK:
+ *                    The TCP checksum calculated by the device
+ *                    matched the checksum in the receive packet's
+ *                    TCP header.
+ *
+ *                  IONIC_RXQ_COMP_CSUM_F_TCP_BAD:
+ *                    The TCP checksum calculated by the device did
+ *                    not match the checksum in the receive packet's
+ *                    TCP header.
+ *
+ *                  IONIC_RXQ_COMP_CSUM_F_UDP_OK:
+ *                    The UDP checksum calculated by the device
+ *                    matched the checksum in the receive packet's
+ *                    UDP header
+ *
+ *                  IONIC_RXQ_COMP_CSUM_F_UDP_BAD:
+ *                    The UDP checksum calculated by the device did
+ *                    not match the checksum in the receive packet's
+ *                    UDP header.
+ *
+ *                  IONIC_RXQ_COMP_CSUM_F_IP_OK:
+ *                    The IPv4 checksum calculated by the device
+ *                    matched the checksum in the receive packet's
+ *                    first IPv4 header.  If the receive packet
+ *                    contains both a tunnel IPv4 header and a
+ *                    transport IPv4 header, the device validates the
+ *                    checksum for the both IPv4 headers.
+ *
+ *                  IONIC_RXQ_COMP_CSUM_F_IP_BAD:
+ *                    The IPv4 checksum calculated by the device did
+ *                    not match the checksum in the receive packet's
+ *                    first IPv4 header. If the receive packet
+ *                    contains both a tunnel IPv4 header and a
+ *                    transport IPv4 header, the device validates the
+ *                    checksum for both IP headers.
+ *
+ *                  IONIC_RXQ_COMP_CSUM_F_VLAN:
+ *                    The VLAN header was stripped and placed in @vlan_tci.
+ *
+ *                  IONIC_RXQ_COMP_CSUM_F_CALC:
+ *                    The checksum was calculated by the device.
+ *
+ * @pkt_type_color: Packet type and color bit; see IONIC_RXQ_COMP_PKT_TYPE_MASK
  */
 struct ionic_rxq_comp {
 	u8     status;
@@ -971,8 +999,8 @@ enum ionic_eth_hw_features {
 	IONIC_ETH_HW_TSO_ECN		= BIT(10),
 	IONIC_ETH_HW_TSO_GRE		= BIT(11),
 	IONIC_ETH_HW_TSO_GRE_CSUM	= BIT(12),
-	IONIC_ETH_HW_TSO_IPXIP4	= BIT(13),
-	IONIC_ETH_HW_TSO_IPXIP6	= BIT(14),
+	IONIC_ETH_HW_TSO_IPXIP4		= BIT(13),
+	IONIC_ETH_HW_TSO_IPXIP6		= BIT(14),
 	IONIC_ETH_HW_TSO_UDP		= BIT(15),
 	IONIC_ETH_HW_TSO_UDP_CSUM	= BIT(16),
 };
@@ -1003,7 +1031,10 @@ enum q_control_oper {
 };
 
 /**
- * Physical connection type
+ * enum ionic_phy_type - Physical connection type
+ * @IONIC_PHY_TYPE_NONE:    No PHY installed
+ * @IONIC_PHY_TYPE_COPPER:  Copper PHY
+ * @IONIC_PHY_TYPE_FIBER:   Fiber PHY
  */
 enum ionic_phy_type {
 	IONIC_PHY_TYPE_NONE	= 0,
@@ -1012,18 +1043,23 @@ enum ionic_phy_type {
 };
 
 /**
- * Transceiver status
+ * enum ionic_xcvr_state - Transceiver status
+ * @IONIC_XCVR_STATE_REMOVED:        Transceiver removed
+ * @IONIC_XCVR_STATE_INSERTED:       Transceiver inserted
+ * @IONIC_XCVR_STATE_PENDING:        Transceiver pending
+ * @IONIC_XCVR_STATE_SPROM_READ:     Transceiver data read
+ * @IONIC_XCVR_STATE_SPROM_READ_ERR: Transceiver data read error
  */
 enum ionic_xcvr_state {
 	IONIC_XCVR_STATE_REMOVED	 = 0,
 	IONIC_XCVR_STATE_INSERTED	 = 1,
 	IONIC_XCVR_STATE_PENDING	 = 2,
 	IONIC_XCVR_STATE_SPROM_READ	 = 3,
-	IONIC_XCVR_STATE_SPROM_READ_ERR  = 4,
+	IONIC_XCVR_STATE_SPROM_READ_ERR	 = 4,
 };
 
 /**
- * Supported link modes
+ * enum ionic_xcvr_pid - Supported link modes
  */
 enum ionic_xcvr_pid {
 	IONIC_XCVR_PID_UNKNOWN           = 0,
@@ -1057,64 +1093,83 @@ enum ionic_xcvr_pid {
 	IONIC_XCVR_PID_SFP_10GBASE_CU   = 68,
 	IONIC_XCVR_PID_QSFP_100G_CWDM4  = 69,
 	IONIC_XCVR_PID_QSFP_100G_PSM4   = 70,
+	IONIC_XCVR_PID_SFP_25GBASE_ACC  = 71,
 };
 
 /**
- * Port types
+ * enum ionic_port_type - Port types
+ * @IONIC_PORT_TYPE_NONE:           Port type not configured
+ * @IONIC_PORT_TYPE_ETH:            Port carries ethernet traffic (inband)
+ * @IONIC_PORT_TYPE_MGMT:           Port carries mgmt traffic (out-of-band)
  */
 enum ionic_port_type {
-	IONIC_PORT_TYPE_NONE = 0,  /* port type not configured */
-	IONIC_PORT_TYPE_ETH  = 1,  /* port carries ethernet traffic (inband) */
-	IONIC_PORT_TYPE_MGMT = 2,  /* port carries mgmt traffic (out-of-band) */
+	IONIC_PORT_TYPE_NONE = 0,
+	IONIC_PORT_TYPE_ETH  = 1,
+	IONIC_PORT_TYPE_MGMT = 2,
 };
 
 /**
- * Port config state
+ * enum ionic_port_admin_state - Port config state
+ * @IONIC_PORT_ADMIN_STATE_NONE:    Port admin state not configured
+ * @IONIC_PORT_ADMIN_STATE_DOWN:    Port admin disabled
+ * @IONIC_PORT_ADMIN_STATE_UP:      Port admin enabled
  */
 enum ionic_port_admin_state {
-	IONIC_PORT_ADMIN_STATE_NONE = 0,   /* port admin state not configured */
-	IONIC_PORT_ADMIN_STATE_DOWN = 1,   /* port is admin disabled */
-	IONIC_PORT_ADMIN_STATE_UP   = 2,   /* port is admin enabled */
+	IONIC_PORT_ADMIN_STATE_NONE = 0,
+	IONIC_PORT_ADMIN_STATE_DOWN = 1,
+	IONIC_PORT_ADMIN_STATE_UP   = 2,
 };
 
 /**
- * Port operational status
+ * enum ionic_port_oper_status - Port operational status
+ * @IONIC_PORT_OPER_STATUS_NONE:    Port disabled
+ * @IONIC_PORT_OPER_STATUS_UP:      Port link status up
+ * @IONIC_PORT_OPER_STATUS_DOWN:    Port link status down
  */
 enum ionic_port_oper_status {
-	IONIC_PORT_OPER_STATUS_NONE  = 0,	/* port is disabled */
-	IONIC_PORT_OPER_STATUS_UP    = 1,	/* port is linked up */
-	IONIC_PORT_OPER_STATUS_DOWN  = 2,	/* port link status is down */
+	IONIC_PORT_OPER_STATUS_NONE  = 0,
+	IONIC_PORT_OPER_STATUS_UP    = 1,
+	IONIC_PORT_OPER_STATUS_DOWN  = 2,
 };
 
 /**
- * Ethernet Forward error correction (fec) modes
+ * enum ionic_port_fec_type - Ethernet Forward error correction (FEC) modes
+ * @IONIC_PORT_FEC_TYPE_NONE:       FEC Disabled
+ * @IONIC_PORT_FEC_TYPE_FC:         FireCode FEC
+ * @IONIC_PORT_FEC_TYPE_RS:         ReedSolomon FEC
  */
 enum ionic_port_fec_type {
-	IONIC_PORT_FEC_TYPE_NONE = 0,		/* Disabled */
-	IONIC_PORT_FEC_TYPE_FC   = 1,		/* FireCode */
-	IONIC_PORT_FEC_TYPE_RS   = 2,		/* ReedSolomon */
+	IONIC_PORT_FEC_TYPE_NONE = 0,
+	IONIC_PORT_FEC_TYPE_FC   = 1,
+	IONIC_PORT_FEC_TYPE_RS   = 2,
 };
 
 /**
- * Ethernet pause (flow control) modes
+ * enum ionic_port_pause_type - Ethernet pause (flow control) modes
+ * @IONIC_PORT_PAUSE_TYPE_NONE:     Disable Pause
+ * @IONIC_PORT_PAUSE_TYPE_LINK:     Link level pause
+ * @IONIC_PORT_PAUSE_TYPE_PFC:      Priority-Flow Control
  */
 enum ionic_port_pause_type {
-	IONIC_PORT_PAUSE_TYPE_NONE = 0,	/* Disable Pause */
-	IONIC_PORT_PAUSE_TYPE_LINK = 1,	/* Link level pause */
-	IONIC_PORT_PAUSE_TYPE_PFC  = 2,	/* Priority-Flow control */
+	IONIC_PORT_PAUSE_TYPE_NONE = 0,
+	IONIC_PORT_PAUSE_TYPE_LINK = 1,
+	IONIC_PORT_PAUSE_TYPE_PFC  = 2,
 };
 
 /**
- * Loopback modes
+ * enum ionic_port_loopback_mode - Loopback modes
+ * @IONIC_PORT_LOOPBACK_MODE_NONE:  Disable loopback
+ * @IONIC_PORT_LOOPBACK_MODE_MAC:   MAC loopback
+ * @IONIC_PORT_LOOPBACK_MODE_PHY:   PHY/SerDes loopback
  */
 enum ionic_port_loopback_mode {
-	IONIC_PORT_LOOPBACK_MODE_NONE = 0,	/* Disable loopback */
-	IONIC_PORT_LOOPBACK_MODE_MAC  = 1,	/* MAC loopback */
-	IONIC_PORT_LOOPBACK_MODE_PHY  = 2,	/* PHY/Serdes loopback */
+	IONIC_PORT_LOOPBACK_MODE_NONE = 0,
+	IONIC_PORT_LOOPBACK_MODE_MAC  = 1,
+	IONIC_PORT_LOOPBACK_MODE_PHY  = 2,
 };
 
 /**
- * Transceiver Status information
+ * struct ionic_xcvr_status - Transceiver Status information
  * @state:    Transceiver status (enum ionic_xcvr_state)
  * @phy:      Physical connection type (enum ionic_phy_type)
  * @pid:      Transceiver link mode (enum pid)
@@ -1128,7 +1183,7 @@ struct ionic_xcvr_status {
 };
 
 /**
- * Port configuration
+ * union ionic_port_config - Port configuration
  * @speed:              port speed (in Mbps)
  * @mtu:                mtu
  * @state:              port admin state (enum port_admin_state)
@@ -1161,17 +1216,21 @@ union ionic_port_config {
 };
 
 /**
- * Port Status information
+ * struct ionic_port_status - Port Status information
  * @status:             link status (enum ionic_port_oper_status)
  * @id:                 port id
  * @speed:              link speed (in Mbps)
+ * @link_down_count:    number of times link went from from up to down
+ * @fec_type:           fec type (enum ionic_port_fec_type)
  * @xcvr:               tranceiver status
  */
 struct ionic_port_status {
 	__le32 id;
 	__le32 speed;
 	u8     status;
-	u8     rsvd[51];
+	__le16 link_down_count;
+	u8     fec_type;
+	u8     rsvd[48];
 	struct ionic_xcvr_status  xcvr;
 } __packed;
 
@@ -1190,7 +1249,7 @@ struct ionic_port_identify_cmd {
 
 /**
  * struct ionic_port_identify_comp - Port identify command completion
- * @status: The status of the command (enum status_code)
+ * @status: Status of the command (enum ionic_status_code)
  * @ver:    Version of identify returned by device
  */
 struct ionic_port_identify_comp {
@@ -1215,7 +1274,7 @@ struct ionic_port_init_cmd {
 
 /**
  * struct ionic_port_init_comp - Port initialization command completion
- * @status: The status of the command (enum status_code)
+ * @status: Status of the command (enum ionic_status_code)
  */
 struct ionic_port_init_comp {
 	u8 status;
@@ -1235,7 +1294,7 @@ struct ionic_port_reset_cmd {
 
 /**
  * struct ionic_port_reset_comp - Port reset command completion
- * @status: The status of the command (enum status_code)
+ * @status: Status of the command (enum ionic_status_code)
  */
 struct ionic_port_reset_comp {
 	u8 status;
@@ -1243,15 +1302,23 @@ struct ionic_port_reset_comp {
 };
 
 /**
- * enum stats_ctl_cmd - List of commands for stats control
+ * enum ionic_stats_ctl_cmd - List of commands for stats control
+ * @IONIC_STATS_CTL_RESET:      Reset statistics
  */
 enum ionic_stats_ctl_cmd {
 	IONIC_STATS_CTL_RESET		= 0,
 };
 
-
 /**
  * enum ionic_port_attr - List of device attributes
+ * @IONIC_PORT_ATTR_STATE:      Port state attribute
+ * @IONIC_PORT_ATTR_SPEED:      Port speed attribute
+ * @IONIC_PORT_ATTR_MTU:        Port MTU attribute
+ * @IONIC_PORT_ATTR_AUTONEG:    Port autonegotation attribute
+ * @IONIC_PORT_ATTR_FEC:        Port FEC attribute
+ * @IONIC_PORT_ATTR_PAUSE:      Port pause attribute
+ * @IONIC_PORT_ATTR_LOOPBACK:   Port loopback attribute
+ * @IONIC_PORT_ATTR_STATS_CTRL: Port statistics control attribute
  */
 enum ionic_port_attr {
 	IONIC_PORT_ATTR_STATE		= 0,
@@ -1266,9 +1333,17 @@ enum ionic_port_attr {
 
 /**
  * struct ionic_port_setattr_cmd - Set port attributes on the NIC
- * @opcode:     Opcode
- * @index:      port index
- * @attr:       Attribute type (enum ionic_port_attr)
+ * @opcode:         Opcode
+ * @index:          Port index
+ * @attr:           Attribute type (enum ionic_port_attr)
+ * @state:          Port state
+ * @speed:          Port speed
+ * @mtu:            Port MTU
+ * @an_enable:      Port autonegotiation setting
+ * @fec_type:       Port FEC type setting
+ * @pause_type:     Port pause type setting
+ * @loopback_mode:  Port loopback mode
+ * @stats_ctl:      Port stats setting
  */
 struct ionic_port_setattr_cmd {
 	u8     opcode;
@@ -1283,14 +1358,14 @@ struct ionic_port_setattr_cmd {
 		u8      fec_type;
 		u8      pause_type;
 		u8      loopback_mode;
-		u8	stats_ctl;
+		u8      stats_ctl;
 		u8      rsvd2[60];
 	};
 };
 
 /**
  * struct ionic_port_setattr_comp - Port set attr command completion
- * @status:     The status of the command (enum status_code)
+ * @status:     Status of the command (enum ionic_status_code)
  * @color:      Color bit
  */
 struct ionic_port_setattr_comp {
@@ -1314,8 +1389,15 @@ struct ionic_port_getattr_cmd {
 
 /**
  * struct ionic_port_getattr_comp - Port get attr command completion
- * @status:     The status of the command (enum status_code)
- * @color:      Color bit
+ * @status:         Status of the command (enum ionic_status_code)
+ * @state:          Port state
+ * @speed:          Port speed
+ * @mtu:            Port MTU
+ * @an_enable:      Port autonegotiation setting
+ * @fec_type:       Port FEC type setting
+ * @pause_type:     Port pause type setting
+ * @loopback_mode:  Port loopback mode
+ * @color:          Color bit
  */
 struct ionic_port_getattr_comp {
 	u8     status;
@@ -1334,12 +1416,12 @@ struct ionic_port_getattr_comp {
 };
 
 /**
- * struct ionic_lif_status - Lif status register
+ * struct ionic_lif_status - LIF status register
  * @eid:             most recent NotifyQ event id
- * @port_num:        port the lif is connected to
+ * @port_num:        port the LIF is connected to
  * @link_status:     port status (enum ionic_port_oper_status)
  * @link_speed:      speed of link in Mbps
- * @link_down_count: number of times link status changes
+ * @link_down_count: number of times link went from up to down
  */
 struct ionic_lif_status {
 	__le64 eid;
@@ -1373,6 +1455,9 @@ enum ionic_dev_state {
 
 /**
  * enum ionic_dev_attr - List of device attributes
+ * @IONIC_DEV_ATTR_STATE:     Device state attribute
+ * @IONIC_DEV_ATTR_NAME:      Device name attribute
+ * @IONIC_DEV_ATTR_FEATURES:  Device feature attributes
  */
 enum ionic_dev_attr {
 	IONIC_DEV_ATTR_STATE    = 0,
@@ -1402,7 +1487,7 @@ struct ionic_dev_setattr_cmd {
 
 /**
  * struct ionic_dev_setattr_comp - Device set attr command completion
- * @status:     The status of the command (enum status_code)
+ * @status:     Status of the command (enum ionic_status_code)
  * @features:   Device features
  * @color:      Color bit
  */
@@ -1429,7 +1514,7 @@ struct ionic_dev_getattr_cmd {
 
 /**
  * struct ionic_dev_setattr_comp - Device set attr command completion
- * @status:     The status of the command (enum status_code)
+ * @status:     Status of the command (enum ionic_status_code)
  * @features:   Device features
  * @color:      Color bit
  */
@@ -1459,6 +1544,13 @@ enum ionic_rss_hash_types {
 
 /**
  * enum ionic_lif_attr - List of LIF attributes
+ * @IONIC_LIF_ATTR_STATE:       LIF state attribute
+ * @IONIC_LIF_ATTR_NAME:        LIF name attribute
+ * @IONIC_LIF_ATTR_MTU:         LIF MTU attribute
+ * @IONIC_LIF_ATTR_MAC:         LIF MAC attribute
+ * @IONIC_LIF_ATTR_FEATURES:    LIF features attribute
+ * @IONIC_LIF_ATTR_RSS:         LIF RSS attribute
+ * @IONIC_LIF_ATTR_STATS_CTRL:  LIF statistics control attribute
  */
 enum ionic_lif_attr {
 	IONIC_LIF_ATTR_STATE        = 0,
@@ -1473,18 +1565,18 @@ enum ionic_lif_attr {
 /**
  * struct ionic_lif_setattr_cmd - Set LIF attributes on the NIC
  * @opcode:     Opcode
- * @type:       Attribute type (enum ionic_lif_attr)
+ * @attr:       Attribute type (enum ionic_lif_attr)
  * @index:      LIF index
- * @state:      lif state (enum lif_state)
+ * @state:      LIF state (enum ionic_lif_state)
  * @name:       The netdev name string, 0 terminated
  * @mtu:        Mtu
  * @mac:        Station mac
  * @features:   Features (enum ionic_eth_hw_features)
  * @rss:        RSS properties
- *              @types:     The hash types to enable (see rss_hash_types).
- *              @key:       The hash secret key.
- *              @addr:      Address for the indirection table shared memory.
- * @stats_ctl:  stats control commands (enum stats_ctl_cmd)
+ *              @types:     The hash types to enable (see rss_hash_types)
+ *              @key:       The hash secret key
+ *              @addr:      Address for the indirection table shared memory
+ * @stats_ctl:  stats control commands (enum ionic_stats_ctl_cmd)
  */
 struct ionic_lif_setattr_cmd {
 	u8     opcode;
@@ -1502,16 +1594,15 @@ struct ionic_lif_setattr_cmd {
 			u8     rsvd[6];
 			__le64 addr;
 		} rss;
-		u8	stats_ctl;
+		u8      stats_ctl;
 		u8      rsvd[60];
 	} __packed;
 };
 
 /**
  * struct ionic_lif_setattr_comp - LIF set attr command completion
- * @status:     The status of the command (enum status_code)
- * @comp_index: The index in the descriptor ring for which this
- *              is the completion.
+ * @status:     Status of the command (enum ionic_status_code)
+ * @comp_index: Index in the descriptor ring for which this is the completion
  * @features:   features (enum ionic_eth_hw_features)
  * @color:      Color bit
  */
@@ -1541,10 +1632,9 @@ struct ionic_lif_getattr_cmd {
 
 /**
  * struct ionic_lif_getattr_comp - LIF get attr command completion
- * @status:     The status of the command (enum status_code)
- * @comp_index: The index in the descriptor ring for which this
- *              is the completion.
- * @state:      lif state (enum lif_state)
+ * @status:     Status of the command (enum ionic_status_code)
+ * @comp_index: Index in the descriptor ring for which this is the completion
+ * @state:      LIF state (enum ionic_lif_state)
  * @name:       The netdev name string, 0 terminated
  * @mtu:        Mtu
  * @mac:        Station mac
@@ -1566,11 +1656,12 @@ struct ionic_lif_getattr_comp {
 };
 
 enum ionic_rx_mode {
-	IONIC_RX_MODE_F_UNICAST    = BIT(0),
-	IONIC_RX_MODE_F_MULTICAST  = BIT(1),
-	IONIC_RX_MODE_F_BROADCAST  = BIT(2),
-	IONIC_RX_MODE_F_PROMISC    = BIT(3),
-	IONIC_RX_MODE_F_ALLMULTI   = BIT(4),
+	IONIC_RX_MODE_F_UNICAST		= BIT(0),
+	IONIC_RX_MODE_F_MULTICAST	= BIT(1),
+	IONIC_RX_MODE_F_BROADCAST	= BIT(2),
+	IONIC_RX_MODE_F_PROMISC		= BIT(3),
+	IONIC_RX_MODE_F_ALLMULTI	= BIT(4),
+	IONIC_RX_MODE_F_RDMA_SNIFFER	= BIT(5),
 };
 
 /**
@@ -1578,11 +1669,12 @@ enum ionic_rx_mode {
  * @opcode:     opcode
  * @lif_index:  LIF index
  * @rx_mode:    Rx mode flags:
- *                  IONIC_RX_MODE_F_UNICAST: Accept known unicast packets.
- *                  IONIC_RX_MODE_F_MULTICAST: Accept known multicast packets.
- *                  IONIC_RX_MODE_F_BROADCAST: Accept broadcast packets.
- *                  IONIC_RX_MODE_F_PROMISC: Accept any packets.
- *                  IONIC_RX_MODE_F_ALLMULTI: Accept any multicast packets.
+ *                  IONIC_RX_MODE_F_UNICAST: Accept known unicast packets
+ *                  IONIC_RX_MODE_F_MULTICAST: Accept known multicast packets
+ *                  IONIC_RX_MODE_F_BROADCAST: Accept broadcast packets
+ *                  IONIC_RX_MODE_F_PROMISC: Accept any packets
+ *                  IONIC_RX_MODE_F_ALLMULTI: Accept any multicast packets
+ *                  IONIC_RX_MODE_F_RDMA_SNIFFER: Sniff RDMA packets
  */
 struct ionic_rx_mode_set_cmd {
 	u8     opcode;
@@ -1606,9 +1698,14 @@ enum ionic_rx_filter_match_type {
  * @qtype:      Queue type
  * @lif_index:  LIF index
  * @qid:        Queue ID
- * @match:      Rx filter match type.  (See IONIC_RX_FILTER_MATCH_xxx)
- * @vlan:       VLAN ID
- * @addr:       MAC address (network-byte order)
+ * @match:      Rx filter match type (see IONIC_RX_FILTER_MATCH_xxx)
+ * @vlan:       VLAN filter
+ *              @vlan:  VLAN ID
+ * @mac:        MAC filter
+ *              @addr:  MAC address (network-byte order)
+ * @mac_vlan:   MACVLAN filter
+ *              @vlan:  VLAN ID
+ *              @addr:  MAC address (network-byte order)
  */
 struct ionic_rx_filter_add_cmd {
 	u8     opcode;
@@ -1633,11 +1730,10 @@ struct ionic_rx_filter_add_cmd {
 
 /**
  * struct ionic_rx_filter_add_comp - Add LIF Rx filter command completion
- * @status:     The status of the command (enum status_code)
- * @comp_index: The index in the descriptor ring for which this
- *              is the completion.
+ * @status:     Status of the command (enum ionic_status_code)
+ * @comp_index: Index in the descriptor ring for which this is the completion
  * @filter_id:  Filter ID
- * @color:      Color bit.
+ * @color:      Color bit
  */
 struct ionic_rx_filter_add_comp {
 	u8     status;
@@ -1664,63 +1760,6 @@ struct ionic_rx_filter_del_cmd {
 
 typedef struct ionic_admin_comp ionic_rx_filter_del_comp;
 
-/**
- * struct ionic_qos_identify_cmd - QoS identify command
- * @opcode:    opcode
- * @ver:     Highest version of identify supported by driver
- *
- */
-struct ionic_qos_identify_cmd {
-	u8 opcode;
-	u8 ver;
-	u8 rsvd[62];
-};
-
-/**
- * struct ionic_qos_identify_comp - QoS identify command completion
- * @status: The status of the command (enum status_code)
- * @ver:    Version of identify returned by device
- */
-struct ionic_qos_identify_comp {
-	u8 status;
-	u8 ver;
-	u8 rsvd[14];
-};
-
-#define IONIC_QOS_CLASS_MAX		7
-#define IONIC_QOS_CLASS_NAME_SZ		32
-#define IONIC_QOS_DSCP_MAX_VALUES	64
-
-/**
- * enum ionic_qos_class
- */
-enum ionic_qos_class {
-	IONIC_QOS_CLASS_DEFAULT		= 0,
-	IONIC_QOS_CLASS_USER_DEFINED_1	= 1,
-	IONIC_QOS_CLASS_USER_DEFINED_2	= 2,
-	IONIC_QOS_CLASS_USER_DEFINED_3	= 3,
-	IONIC_QOS_CLASS_USER_DEFINED_4	= 4,
-	IONIC_QOS_CLASS_USER_DEFINED_5	= 5,
-	IONIC_QOS_CLASS_USER_DEFINED_6	= 6,
-};
-
-/**
- * enum ionic_qos_class_type - Traffic classification criteria
- */
-enum ionic_qos_class_type {
-	IONIC_QOS_CLASS_TYPE_NONE	= 0,
-	IONIC_QOS_CLASS_TYPE_PCP	= 1,	/* Dot1Q pcp */
-	IONIC_QOS_CLASS_TYPE_DSCP	= 2,	/* IP dscp */
-};
-
-/**
- * enum ionic_qos_sched_type - Qos class scheduling type
- */
-enum ionic_qos_sched_type {
-	IONIC_QOS_SCHED_TYPE_STRICT	= 0,	/* Strict priority */
-	IONIC_QOS_SCHED_TYPE_DWRR	= 1,	/* Deficit weighted round-robin */
-};
-
 enum ionic_vf_attr {
 	IONIC_VF_ATTR_SPOOFCHK	= 1,
 	IONIC_VF_ATTR_TRUST	= 2,
@@ -1732,26 +1771,29 @@ enum ionic_vf_attr {
 };
 
 /**
- * VF link status
+ * enum ionic_vf_link_status - Virtual Function link status
+ * @IONIC_VF_LINK_STATUS_AUTO:   Use link state of the uplink
+ * @IONIC_VF_LINK_STATUS_UP:     Link always up
+ * @IONIC_VF_LINK_STATUS_DOWN:   Link always down
  */
 enum ionic_vf_link_status {
-	IONIC_VF_LINK_STATUS_AUTO = 0,	/* link state of the uplink */
-	IONIC_VF_LINK_STATUS_UP   = 1,	/* link is always up */
-	IONIC_VF_LINK_STATUS_DOWN = 2,	/* link is always down */
+	IONIC_VF_LINK_STATUS_AUTO = 0,
+	IONIC_VF_LINK_STATUS_UP   = 1,
+	IONIC_VF_LINK_STATUS_DOWN = 2,
 };
 
 /**
  * struct ionic_vf_setattr_cmd - Set VF attributes on the NIC
  * @opcode:     Opcode
- * @index:      VF index
  * @attr:       Attribute type (enum ionic_vf_attr)
- *	macaddr		mac address
- *	vlanid		vlan ID
- *	maxrate		max Tx rate in Mbps
- *	spoofchk	enable address spoof checking
- *	trust		enable VF trust
- *	linkstate	set link up or down
- *	stats_pa	set DMA address for VF stats
+ * @vf_index:   VF index
+ *	@macaddr:	mac address
+ *	@vlanid:	vlan ID
+ *	@maxrate:	max Tx rate in Mbps
+ *	@spoofchk:	enable address spoof checking
+ *	@trust:		enable VF trust
+ *	@linkstate:	set link up or down
+ *	@stats_pa:	set DMA address for VF stats
  */
 struct ionic_vf_setattr_cmd {
 	u8     opcode;
@@ -1781,8 +1823,8 @@ struct ionic_vf_setattr_comp {
 /**
  * struct ionic_vf_getattr_cmd - Get VF attributes from the NIC
  * @opcode:     Opcode
- * @index:      VF index
  * @attr:       Attribute type (enum ionic_vf_attr)
+ * @vf_index:   VF index
  */
 struct ionic_vf_getattr_cmd {
 	u8     opcode;
@@ -1809,19 +1851,85 @@ struct ionic_vf_getattr_comp {
 };
 
 /**
- * union ionic_qos_config - Qos configuration structure
+ * struct ionic_qos_identify_cmd - QoS identify command
+ * @opcode:  opcode
+ * @ver:     Highest version of identify supported by driver
+ *
+ */
+struct ionic_qos_identify_cmd {
+	u8 opcode;
+	u8 ver;
+	u8 rsvd[62];
+};
+
+/**
+ * struct ionic_qos_identify_comp - QoS identify command completion
+ * @status: Status of the command (enum ionic_status_code)
+ * @ver:    Version of identify returned by device
+ */
+struct ionic_qos_identify_comp {
+	u8 status;
+	u8 ver;
+	u8 rsvd[14];
+};
+
+#define IONIC_QOS_TC_MAX		8
+/* Capri max supported, should be renamed. */
+#define IONIC_QOS_CLASS_MAX		7
+#define IONIC_QOS_PCP_MAX		8
+#define IONIC_QOS_CLASS_NAME_SZ	32
+#define IONIC_QOS_DSCP_MAX		64
+#define IONIC_QOS_ALL_PCP		0xFF
+
+/**
+ * enum ionic_qos_class
+ */
+enum ionic_qos_class {
+	IONIC_QOS_CLASS_DEFAULT		= 0,
+	IONIC_QOS_CLASS_USER_DEFINED_1	= 1,
+	IONIC_QOS_CLASS_USER_DEFINED_2	= 2,
+	IONIC_QOS_CLASS_USER_DEFINED_3	= 3,
+	IONIC_QOS_CLASS_USER_DEFINED_4	= 4,
+	IONIC_QOS_CLASS_USER_DEFINED_5	= 5,
+	IONIC_QOS_CLASS_USER_DEFINED_6	= 6,
+};
+
+/**
+ * enum ionic_qos_class_type - Traffic classification criteria
+ * @IONIC_QOS_CLASS_TYPE_NONE:    No QoS
+ * @IONIC_QOS_CLASS_TYPE_PCP:     Dot1Q PCP
+ * @IONIC_QOS_CLASS_TYPE_DSCP:    IP DSCP
+ */
+enum ionic_qos_class_type {
+	IONIC_QOS_CLASS_TYPE_NONE	= 0,
+	IONIC_QOS_CLASS_TYPE_PCP	= 1,
+	IONIC_QOS_CLASS_TYPE_DSCP	= 2,
+};
+
+/**
+ * enum ionic_qos_sched_type - QoS class scheduling type
+ * @IONIC_QOS_SCHED_TYPE_STRICT:  Strict priority
+ * @IONIC_QOS_SCHED_TYPE_DWRR:    Deficit weighted round-robin
+ */
+enum ionic_qos_sched_type {
+	IONIC_QOS_SCHED_TYPE_STRICT	= 0,
+	IONIC_QOS_SCHED_TYPE_DWRR	= 1,
+};
+
+/**
+ * union ionic_qos_config - QoS configuration structure
  * @flags:		Configuration flags
  *	IONIC_QOS_CONFIG_F_ENABLE		enable
- *	IONIC_QOS_CONFIG_F_DROP			drop/nodrop
+ *	IONIC_QOS_CONFIG_F_NO_DROP		drop/nodrop
  *	IONIC_QOS_CONFIG_F_RW_DOT1Q_PCP		enable dot1q pcp rewrite
  *	IONIC_QOS_CONFIG_F_RW_IP_DSCP		enable ip dscp rewrite
- * @sched_type:		Qos class scheduling type (enum ionic_qos_sched_type)
- * @class_type:		Qos class type (enum ionic_qos_class_type)
- * @pause_type:		Qos pause type (enum ionic_qos_pause_type)
- * @name:		Qos class name
+ * @sched_type:		QoS class scheduling type (enum ionic_qos_sched_type)
+ * @class_type:		QoS class type (enum ionic_qos_class_type)
+ * @pause_type:		QoS pause type (enum ionic_qos_pause_type)
+ * @name:		QoS class name
  * @mtu:		MTU of the class
- * @pfc_dot1q_pcp:	Pcp value for pause frames (valid iff F_NODROP)
- * @dwrr_weight:	Qos class scheduling weight
+ * @pfc_cos:		Priority-Flow Control class of service
+ * @dwrr_weight:	QoS class scheduling weight
  * @strict_rlmt:	Rate limit for strict priority scheduling
  * @rw_dot1q_pcp:	Rewrite dot1q pcp to this value	(valid iff F_RW_DOT1Q_PCP)
  * @rw_ip_dscp:		Rewrite ip dscp to this value	(valid iff F_RW_IP_DSCP)
@@ -1832,7 +1940,8 @@ struct ionic_vf_getattr_comp {
 union ionic_qos_config {
 	struct {
 #define IONIC_QOS_CONFIG_F_ENABLE		BIT(0)
-#define IONIC_QOS_CONFIG_F_DROP			BIT(1)
+#define IONIC_QOS_CONFIG_F_NO_DROP		BIT(1)
+/* Used to rewrite PCP or DSCP value. */
 #define IONIC_QOS_CONFIG_F_RW_DOT1Q_PCP		BIT(2)
 #define IONIC_QOS_CONFIG_F_RW_IP_DSCP		BIT(3)
 		u8      flags;
@@ -1849,6 +1958,7 @@ union ionic_qos_config {
 			__le64  strict_rlmt;
 		};
 		/* marking */
+		/* Used to rewrite PCP or DSCP value. */
 		union {
 			u8      rw_dot1q_pcp;
 			u8      rw_ip_dscp;
@@ -1858,7 +1968,7 @@ union ionic_qos_config {
 			u8      dot1q_pcp;
 			struct {
 				u8      ndscp;
-				u8      ip_dscp[IONIC_QOS_DSCP_MAX_VALUES];
+				u8      ip_dscp[IONIC_QOS_DSCP_MAX];
 			};
 		};
 	};
@@ -1877,15 +1987,15 @@ union ionic_qos_identity {
 		u8     version;
 		u8     type;
 		u8     rsvd[62];
-		union  ionic_qos_config config[IONIC_QOS_CLASS_MAX];
+		union ionic_qos_config config[IONIC_QOS_CLASS_MAX];
 	};
-	__le32 words[512];
+	__le32 words[478];
 };
 
 /**
- * struct qos_init_cmd - QoS config init command
+ * struct ionic_qos_init_cmd - QoS config init command
  * @opcode:	Opcode
- * @group:	Qos class id
+ * @group:	QoS class id
  * @info_pa:	destination address for qos info
  */
 struct ionic_qos_init_cmd {
@@ -1899,8 +2009,9 @@ struct ionic_qos_init_cmd {
 typedef struct ionic_admin_comp ionic_qos_init_comp;
 
 /**
- * struct ionic_qos_reset_cmd - Qos config reset command
+ * struct ionic_qos_reset_cmd - QoS config reset command
  * @opcode:	Opcode
+ * @group:	QoS class id
  */
 struct ionic_qos_reset_cmd {
 	u8    opcode;
@@ -1927,10 +2038,16 @@ struct ionic_fw_download_cmd {
 
 typedef struct ionic_admin_comp ionic_fw_download_comp;
 
+/**
+ * enum ionic_fw_control_oper - FW control operations
+ * @IONIC_FW_RESET:     Reset firmware
+ * @IONIC_FW_INSTALL:   Install firmware
+ * @IONIC_FW_ACTIVATE:  Activate firmware
+ */
 enum ionic_fw_control_oper {
-	IONIC_FW_RESET		= 0,	/* Reset firmware */
-	IONIC_FW_INSTALL	= 1,	/* Install firmware */
-	IONIC_FW_ACTIVATE	= 2,	/* Activate firmware */
+	IONIC_FW_RESET		= 0,
+	IONIC_FW_INSTALL	= 1,
+	IONIC_FW_ACTIVATE	= 2,
 };
 
 /**
@@ -1949,8 +2066,10 @@ struct ionic_fw_control_cmd {
 
 /**
  * struct ionic_fw_control_comp - Firmware control copletion
- * @opcode:    opcode
- * @slot:      slot where the firmware was installed
+ * @status:     Status of the command (enum ionic_status_code)
+ * @comp_index: Index in the descriptor ring for which this is the completion
+ * @slot:       Slot where the firmware was installed
+ * @color:      Color bit
  */
 struct ionic_fw_control_comp {
 	u8     status;
@@ -1968,11 +2087,11 @@ struct ionic_fw_control_comp {
 /**
  * struct ionic_rdma_reset_cmd - Reset RDMA LIF cmd
  * @opcode:        opcode
- * @lif_index:     lif index
+ * @lif_index:     LIF index
  *
- * There is no rdma specific dev command completion struct.  Completion uses
+ * There is no RDMA specific dev command completion struct.  Completion uses
  * the common struct ionic_admin_comp.  Only the status is indicated.
- * Nonzero status means the LIF does not support rdma.
+ * Nonzero status means the LIF does not support RDMA.
  **/
 struct ionic_rdma_reset_cmd {
 	u8     opcode;
@@ -1984,30 +2103,29 @@ struct ionic_rdma_reset_cmd {
 /**
  * struct ionic_rdma_queue_cmd - Create RDMA Queue command
  * @opcode:        opcode, 52, 53
- * @lif_index      lif index
- * @qid_ver:       (qid | (rdma version << 24))
+ * @lif_index:     LIF index
+ * @qid_ver:       (qid | (RDMA version << 24))
  * @cid:           intr, eq_id, or cq_id
  * @dbid:          doorbell page id
  * @depth_log2:    log base two of queue depth
  * @stride_log2:   log base two of queue stride
  * @dma_addr:      address of the queue memory
- * @xxx_table_index: temporary, but should not need pgtbl for contig. queues.
  *
- * The same command struct is used to create an rdma event queue, completion
- * queue, or rdma admin queue.  The cid is an interrupt number for an event
+ * The same command struct is used to create an RDMA event queue, completion
+ * queue, or RDMA admin queue.  The cid is an interrupt number for an event
  * queue, an event queue id for a completion queue, or a completion queue id
- * for an rdma admin queue.
+ * for an RDMA admin queue.
  *
  * The queue created via a dev command must be contiguous in dma space.
  *
  * The dev commands are intended only to be used during driver initialization,
- * to create queues supporting the rdma admin queue.  Other queues, and other
- * types of rdma resources like memory regions, will be created and registered
- * via the rdma admin queue, and will support a more complete interface
+ * to create queues supporting the RDMA admin queue.  Other queues, and other
+ * types of RDMA resources like memory regions, will be created and registered
+ * via the RDMA admin queue, and will support a more complete interface
  * providing scatter gather lists for larger, scattered queue buffers and
  * memory registration.
  *
- * There is no rdma specific dev command completion struct.  Completion uses
+ * There is no RDMA specific dev command completion struct.  Completion uses
  * the common struct ionic_admin_comp.  Only the status is indicated.
  **/
 struct ionic_rdma_queue_cmd {
@@ -2020,8 +2138,7 @@ struct ionic_rdma_queue_cmd {
 	u8     depth_log2;
 	u8     stride_log2;
 	__le64 dma_addr;
-	u8     rsvd2[36];
-	__le32 xxx_table_index;
+	u8     rsvd2[40];
 };
 
 /******************************************************************
@@ -2029,7 +2146,7 @@ struct ionic_rdma_queue_cmd {
  ******************************************************************/
 
 /**
- * struct ionic_notifyq_event
+ * struct ionic_notifyq_event - Generic event reporting structure
  * @eid:   event number
  * @ecode: event code
  * @data:  unspecified data about the event
@@ -2044,9 +2161,9 @@ struct ionic_notifyq_event {
 };
 
 /**
- * struct ionic_link_change_event
+ * struct ionic_link_change_event - Link change event notification
  * @eid:		event number
- * @ecode:		event code = EVENT_OPCODE_LINK_CHANGE
+ * @ecode:		event code = IONIC_EVENT_LINK_CHANGE
  * @link_status:	link up or down, with error bits (enum port_status)
  * @link_speed:		speed of the network link
  *
@@ -2061,9 +2178,9 @@ struct ionic_link_change_event {
 };
 
 /**
- * struct ionic_reset_event
+ * struct ionic_reset_event - Reset event notification
  * @eid:		event number
- * @ecode:		event code = EVENT_OPCODE_RESET
+ * @ecode:		event code = IONIC_EVENT_RESET
  * @reset_code:		reset type
  * @state:		0=pending, 1=complete, 2=error
  *
@@ -2079,11 +2196,9 @@ struct ionic_reset_event {
 };
 
 /**
- * struct ionic_heartbeat_event
+ * struct ionic_heartbeat_event - Sent periodically by NIC to indicate health
  * @eid:	event number
- * @ecode:	event code = EVENT_OPCODE_HEARTBEAT
- *
- * Sent periodically by the NIC to indicate continued health
+ * @ecode:	event code = IONIC_EVENT_HEARTBEAT
  */
 struct ionic_heartbeat_event {
 	__le64 eid;
@@ -2092,12 +2207,10 @@ struct ionic_heartbeat_event {
 };
 
 /**
- * struct ionic_log_event
+ * struct ionic_log_event - Sent to notify the driver of an internal error
  * @eid:	event number
- * @ecode:	event code = EVENT_OPCODE_LOG
+ * @ecode:	event code = IONIC_EVENT_LOG
  * @data:	log data
- *
- * Sent to notify the driver of an internal error.
  */
 struct ionic_log_event {
 	__le64 eid;
@@ -2106,7 +2219,18 @@ struct ionic_log_event {
 };
 
 /**
- * struct ionic_port_stats
+ * struct ionic_xcvr_event - Transceiver change event
+ * @eid:	event number
+ * @ecode:	event code = IONIC_EVENT_XCVR
+ */
+struct ionic_xcvr_event {
+	__le64 eid;
+	__le16 ecode;
+	u8     rsvd[54];
+};
+
+/**
+ * struct ionic_port_stats - Port statistics structure
  */
 struct ionic_port_stats {
 	__le64 frames_rx_ok;
@@ -2211,28 +2335,61 @@ struct ionic_mgmt_port_stats {
 	__le64 frames_rx_multicast;
 	__le64 frames_rx_broadcast;
 	__le64 frames_rx_pause;
-	__le64 frames_rx_bad_length0;
-	__le64 frames_rx_undersized1;
-	__le64 frames_rx_oversized2;
-	__le64 frames_rx_fragments3;
-	__le64 frames_rx_jabber4;
-	__le64 frames_rx_64b5;
-	__le64 frames_rx_65b_127b6;
-	__le64 frames_rx_128b_255b7;
-	__le64 frames_rx_256b_511b8;
-	__le64 frames_rx_512b_1023b9;
-	__le64 frames_rx_1024b_1518b0;
-	__le64 frames_rx_gt_1518b1;
-	__le64 frames_rx_fifo_full2;
-	__le64 frames_tx_ok3;
-	__le64 frames_tx_all4;
-	__le64 frames_tx_bad5;
-	__le64 octets_tx_ok6;
-	__le64 octets_tx_total7;
-	__le64 frames_tx_unicast8;
-	__le64 frames_tx_multicast9;
-	__le64 frames_tx_broadcast0;
-	__le64 frames_tx_pause1;
+	__le64 frames_rx_bad_length;
+	__le64 frames_rx_undersized;
+	__le64 frames_rx_oversized;
+	__le64 frames_rx_fragments;
+	__le64 frames_rx_jabber;
+	__le64 frames_rx_64b;
+	__le64 frames_rx_65b_127b;
+	__le64 frames_rx_128b_255b;
+	__le64 frames_rx_256b_511b;
+	__le64 frames_rx_512b_1023b;
+	__le64 frames_rx_1024b_1518b;
+	__le64 frames_rx_gt_1518b;
+	__le64 frames_rx_fifo_full;
+	__le64 frames_tx_ok;
+	__le64 frames_tx_all;
+	__le64 frames_tx_bad;
+	__le64 octets_tx_ok;
+	__le64 octets_tx_total;
+	__le64 frames_tx_unicast;
+	__le64 frames_tx_multicast;
+	__le64 frames_tx_broadcast;
+	__le64 frames_tx_pause;
+};
+
+enum ionic_pb_buffer_drop_stats {
+	IONIC_BUFFER_INTRINSIC_DROP = 0,
+	IONIC_BUFFER_DISCARDED,
+	IONIC_BUFFER_ADMITTED,
+	IONIC_BUFFER_OUT_OF_CELLS_DROP,
+	IONIC_BUFFER_OUT_OF_CELLS_DROP_2,
+	IONIC_BUFFER_OUT_OF_CREDIT_DROP,
+	IONIC_BUFFER_TRUNCATION_DROP,
+	IONIC_BUFFER_PORT_DISABLED_DROP,
+	IONIC_BUFFER_COPY_TO_CPU_TAIL_DROP,
+	IONIC_BUFFER_SPAN_TAIL_DROP,
+	IONIC_BUFFER_MIN_SIZE_VIOLATION_DROP,
+	IONIC_BUFFER_ENQUEUE_ERROR_DROP,
+	IONIC_BUFFER_INVALID_PORT_DROP,
+	IONIC_BUFFER_INVALID_OUTPUT_QUEUE_DROP,
+	IONIC_BUFFER_DROP_MAX,
+};
+
+/**
+ * struct port_pb_stats - packet buffers system stats
+ * uses ionic_pb_buffer_drop_stats for drop_counts[]
+ */
+struct ionic_port_pb_stats {
+	__le64 sop_count_in;
+	__le64 eop_count_in;
+	__le64 sop_count_out;
+	__le64 eop_count_out;
+	__le64 drop_counts[IONIC_BUFFER_DROP_MAX];
+	__le64 input_queue_buffer_occupancy[IONIC_QOS_TC_MAX];
+	__le64 input_queue_port_monitor[IONIC_QOS_TC_MAX];
+	__le64 output_queue_port_monitor[IONIC_QOS_TC_MAX];
 };
 
 /**
@@ -2264,22 +2421,31 @@ union ionic_port_identity {
 		u8     rsvd2[44];
 		union ionic_port_config config;
 	};
-	__le32 words[512];
+	__le32 words[478];
 };
 
 /**
  * struct ionic_port_info - port info structure
- * @port_status:     port status
- * @port_stats:      port stats
+ * @config:          Port configuration data
+ * @status:          Port status data
+ * @stats:           Port statistics data
+ * @mgmt_stats:      Port management statistics data
+ * @port_pb_drop_stats:   uplink pb drop stats
  */
 struct ionic_port_info {
 	union ionic_port_config config;
 	struct ionic_port_status status;
-	struct ionic_port_stats stats;
+	union {
+		struct ionic_port_stats      stats;
+		struct ionic_mgmt_port_stats mgmt_stats;
+	};
+	/* room for pb_stats to start at 2k offset */
+	u8                          rsvd[760];
+	struct ionic_port_pb_stats  pb_stats;
 };
 
 /**
- * struct ionic_lif_stats
+ * struct ionic_lif_stats - LIF statistics structure
  */
 struct ionic_lif_stats {
 	/* RX */
@@ -2332,7 +2498,7 @@ struct ionic_lif_stats {
 	__le64 tx_queue_error;
 	__le64 tx_desc_fetch_error;
 	__le64 tx_desc_data_error;
-	__le64 rsvd9;
+	__le64 tx_queue_empty;
 	__le64 rsvd10;
 	__le64 rsvd11;
 	__le64 rsvd12;
@@ -2433,7 +2599,10 @@ struct ionic_lif_stats {
 };
 
 /**
- * struct ionic_lif_info - lif info structure
+ * struct ionic_lif_info - LIF info structure
+ * @config:	LIF configuration structure
+ * @status:	LIF status structure
+ * @stats:	LIF statistics structure
  */
 struct ionic_lif_info {
 	union ionic_lif_config config;
@@ -2471,6 +2640,7 @@ union ionic_dev_cmd {
 
 	struct ionic_q_identify_cmd q_identify;
 	struct ionic_q_init_cmd q_init;
+	struct ionic_q_control_cmd q_control;
 };
 
 union ionic_dev_cmd_comp {
@@ -2507,15 +2677,15 @@ union ionic_dev_cmd_comp {
 };
 
 /**
- * union dev_info - Device info register format (read-only)
- * @signature:       Signature value of 0x44455649 ('DEVI').
- * @version:         Current version of info.
- * @asic_type:       Asic type.
- * @asic_rev:        Asic revision.
- * @fw_status:       Firmware status.
- * @fw_heartbeat:    Firmware heartbeat counter.
- * @serial_num:      Serial number.
- * @fw_version:      Firmware version.
+ * union ionic_dev_info_regs - Device info register format (read-only)
+ * @signature:       Signature value of 0x44455649 ('DEVI')
+ * @version:         Current version of info
+ * @asic_type:       Asic type
+ * @asic_rev:        Asic revision
+ * @fw_status:       Firmware status
+ * @fw_heartbeat:    Firmware heartbeat counter
+ * @serial_num:      Serial number
+ * @fw_version:      Firmware version
  */
 union ionic_dev_info_regs {
 #define IONIC_DEVINFO_FWVERS_BUFLEN 32
@@ -2536,10 +2706,10 @@ union ionic_dev_info_regs {
 
 /**
  * union ionic_dev_cmd_regs - Device command register format (read-write)
- * @doorbell:        Device Cmd Doorbell, write-only.
+ * @doorbell:        Device Cmd Doorbell, write-only
  *                   Write a 1 to signal device to process cmd,
  *                   poll done for completion.
- * @done:            Done indicator, bit 0 == 1 when command is complete.
+ * @done:            Done indicator, bit 0 == 1 when command is complete
  * @cmd:             Opcode-specific command bytes
  * @comp:            Opcode-specific response bytes
  * @data:            Opcode-specific side-data
@@ -2557,7 +2727,7 @@ union ionic_dev_cmd_regs {
 };
 
 /**
- * union ionic_dev_regs - Device register format in for bar 0 page 0
+ * union ionic_dev_regs - Device register format for bar 0 page 0
  * @info:            Device info registers
  * @devcmd:          Device command registers
  */
@@ -2572,6 +2742,7 @@ union ionic_dev_regs {
 union ionic_adminq_cmd {
 	struct ionic_admin_cmd cmd;
 	struct ionic_nop_cmd nop;
+	struct ionic_q_identify_cmd q_identify;
 	struct ionic_q_init_cmd q_init;
 	struct ionic_q_control_cmd q_control;
 	struct ionic_lif_setattr_cmd lif_setattr;
@@ -2588,6 +2759,7 @@ union ionic_adminq_cmd {
 union ionic_adminq_comp {
 	struct ionic_admin_comp comp;
 	struct ionic_nop_comp nop;
+	struct ionic_q_identify_comp q_identify;
 	struct ionic_q_init_comp q_init;
 	struct ionic_lif_setattr_comp lif_setattr;
 	struct ionic_lif_getattr_comp lif_getattr;
@@ -2613,14 +2785,14 @@ union ionic_adminq_comp {
 /**
  * struct ionic_doorbell - Doorbell register layout
  * @p_index: Producer index
- * @ring:    Selects the specific ring of the queue to update.
+ * @ring:    Selects the specific ring of the queue to update
  *           Type-specific meaning:
- *              ring=0: Default producer/consumer queue.
+ *              ring=0: Default producer/consumer queue
  *              ring=1: (CQ, EQ) Re-Arm queue.  RDMA CQs
  *              send events to EQs when armed.  EQs send
  *              interrupts when armed.
- * @qid:     The queue id selects the queue destination for the
- *           producer index and flags.
+ * @qid_lo:  Queue destination for the producer index and flags (low bits)
+ * @qid_hi:  Queue destination for the producer index and flags (high bits)
  */
 struct ionic_doorbell {
 	__le16 p_index;
@@ -2653,6 +2825,7 @@ struct ionic_identity {
 	union ionic_lif_identity lif;
 	union ionic_port_identity port;
 	union ionic_qos_identity qos;
+	union ionic_q_identity txq;
 };
 
 #endif /* _IONIC_IF_H_ */
-- 
2.17.1

