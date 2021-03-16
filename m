Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE9E233D640
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 15:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237646AbhCPO4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 10:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237625AbhCPOzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 10:55:37 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8F4C061756
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 07:55:36 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id z1so21883284edb.8
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 07:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XpsaULRDZIuJ/b8yaUxAw4xsmV7cBtmwTUOB+YQLc4s=;
        b=pO+tJC5/SKdSseqLYrMUmQb06pzFA8GIwEAMKgBD4Rf3mRCUsrP+Jzap0DKWkRqjdy
         mv82X3eV3hc7WdxTplzJzxYEoAtAtgeXQTvFxSUHUiBsLqF7VNOGnGmq3+TQVrzSUiiq
         eH2bnLtTxq+EtY+JDO60pSJ77k/qtNXrt0UZdGA0HzoeXlynZD29l+1HxZ+sCFR7Dp9s
         dlwF8r+tcb9Hd3nFgTWxwLZT3jacTFlesAOufipClesx+cY8v8n9cxmmpnapLy5sHQf1
         6fvUk1gZ9MQWpbk3dibw12Q/n2lMVMyP8cwP7NlIYn8fYO84ckx/rBIC6aRsYWn1sj0a
         DNKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XpsaULRDZIuJ/b8yaUxAw4xsmV7cBtmwTUOB+YQLc4s=;
        b=U6rrNo01vq+a+EizkaS7pqNe27gJD0B7F35MR3D6qZ3QZpFNKFS8qKr3MapOmejqoH
         jP8wWDCZ9Sr2B2SK7DhCYQvZ4UTDOh3b64k2lPytIw8fXJ/kTjEbJPkxS+99OBa1NlUm
         iJO5sDARL9fUc2H0UG73apJJ99vvuaASrZABrpO7/QF3bFABaUpYZmdhDJcgQJ1CNN+Q
         XQV9aQ+XqhXXypeIAy0sNp2qSqORa4lbZGEozypvONPr2+w/Xb9P+Yzfh8FH9at3xnAE
         swbPws1DqAbtUu6iNX/sT3+NcLR5TshmDazrWgtz8l9r5yddMNoGFNPzcZVaYuajv6bS
         TOOQ==
X-Gm-Message-State: AOAM53030NfjugVwcc/tirvaxeR1Kc2bHXz3KYG/oNuda5nKkNMM2y3A
        rxicwSHiByFroSnr87L5UpE=
X-Google-Smtp-Source: ABdhPJyiiUeIciZoavHNPrBxTpgYhg+RgbRJQszmQzD9fpbnu7FMOiH0cGtEvA6JYURQe4LI2zce+A==
X-Received: by 2002:a05:6402:270e:: with SMTP id y14mr36577165edd.283.1615906535468;
        Tue, 16 Mar 2021 07:55:35 -0700 (PDT)
Received: from yoga-910.localhost (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id w18sm9681402ejn.23.2021.03.16.07.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 07:55:34 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ruxandra.radulescu@nxp.com, yangbo.lu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 5/5] dpaa2-eth: fixup kdoc warnings
Date:   Tue, 16 Mar 2021 16:55:12 +0200
Message-Id: <20210316145512.2152374-6-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210316145512.2152374-1-ciorneiioana@gmail.com>
References: <20210316145512.2152374-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Running kernel-doc over the dpaa2-eth driver generates a bunch of
warnings. Fix them up by removing code comments for macros which are
self-explanatory, respecting the kdoc format for macro documentation and
other small changes like describing the expected return values of
functions.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpkg.h  |   5 +-
 drivers/net/ethernet/freescale/dpaa2/dpmac.h |  24 +--
 drivers/net/ethernet/freescale/dpaa2/dpni.c  |   6 +
 drivers/net/ethernet/freescale/dpaa2/dpni.h  | 162 ++++++++-----------
 drivers/net/ethernet/freescale/dpaa2/dprtc.h |   3 -
 5 files changed, 82 insertions(+), 118 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpkg.h b/drivers/net/ethernet/freescale/dpaa2/dpkg.h
index 6de613b13e4d..6f596a5fbeeb 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpkg.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpkg.h
@@ -13,11 +13,12 @@
 /** Key Generator properties */
 
 /**
- * Number of masks per key extraction
+ * DPKG_NUM_OF_MASKS - Number of masks per key extraction
  */
 #define DPKG_NUM_OF_MASKS		4
+
 /**
- * Number of extractions per key profile
+ * DPKG_MAX_NUM_OF_EXTRACTS - Number of extractions per key profile
  */
 #define DPKG_MAX_NUM_OF_EXTRACTS	10
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpmac.h b/drivers/net/ethernet/freescale/dpaa2/dpmac.h
index 135f143097a5..8f7ceb731282 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpmac.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpmac.h
@@ -83,39 +83,21 @@ int dpmac_get_attributes(struct fsl_mc_io *mc_io,
 			 u16 token,
 			 struct dpmac_attr *attr);
 
-/**
- * DPMAC link configuration/state options
- */
+/* DPMAC link configuration/state options */
 
-/**
- * Enable auto-negotiation
- */
 #define DPMAC_LINK_OPT_AUTONEG			BIT_ULL(0)
-/**
- * Enable half-duplex mode
- */
 #define DPMAC_LINK_OPT_HALF_DUPLEX		BIT_ULL(1)
-/**
- * Enable pause frames
- */
 #define DPMAC_LINK_OPT_PAUSE			BIT_ULL(2)
-/**
- * Enable a-symmetric pause frames
- */
 #define DPMAC_LINK_OPT_ASYM_PAUSE		BIT_ULL(3)
 
-/**
- * Advertised link speeds
- */
+/* Advertised link speeds */
 #define DPMAC_ADVERTISED_10BASET_FULL		BIT_ULL(0)
 #define DPMAC_ADVERTISED_100BASET_FULL		BIT_ULL(1)
 #define DPMAC_ADVERTISED_1000BASET_FULL		BIT_ULL(2)
 #define DPMAC_ADVERTISED_10000BASET_FULL	BIT_ULL(4)
 #define DPMAC_ADVERTISED_2500BASEX_FULL		BIT_ULL(5)
 
-/**
- * Advertise auto-negotiation enable
- */
+/* Advertise auto-negotiation enable */
 #define DPMAC_ADVERTISED_AUTONEG		BIT_ULL(3)
 
 /**
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni.c b/drivers/net/ethernet/freescale/dpaa2/dpni.c
index aa429c17c343..d6afada99fb6 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni.c
@@ -17,6 +17,8 @@
  * This function has to be called before the following functions:
  *	- dpni_set_rx_tc_dist()
  *	- dpni_set_qos_table()
+ *
+ * Return:	'0' on Success; Error code otherwise.
  */
 int dpni_prepare_key_cfg(const struct dpkg_profile_cfg *cfg, u8 *key_cfg_buf)
 {
@@ -1793,6 +1795,8 @@ int dpni_get_api_version(struct fsl_mc_io *mc_io,
  * If cfg.enable is set to 0 the command will clear flow steering table.
  * The packets will be classified according to settings made in
  * dpni_set_rx_hash_dist()
+ *
+ * Return:	'0' on Success; Error code otherwise.
  */
 int dpni_set_rx_fs_dist(struct fsl_mc_io *mc_io,
 			u32 cmd_flags,
@@ -1826,6 +1830,8 @@ int dpni_set_rx_fs_dist(struct fsl_mc_io *mc_io,
  * If cfg.enable is set to 1 the packets will be classified using a hash
  * function based on the key received in cfg.key_cfg_iova parameter.
  * If cfg.enable is set to 0 the packets will be sent to the default queue
+ *
+ * Return:	'0' on Success; Error code otherwise.
  */
 int dpni_set_rx_hash_dist(struct fsl_mc_io *mc_io,
 			  u32 cmd_flags,
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni.h b/drivers/net/ethernet/freescale/dpaa2/dpni.h
index 4e96d9362dd2..7de0562bbf59 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni.h
@@ -10,73 +10,76 @@
 
 struct fsl_mc_io;
 
-/**
- * Data Path Network Interface API
+/* Data Path Network Interface API
  * Contains initialization APIs and runtime control APIs for DPNI
  */
 
 /** General DPNI macros */
 
 /**
- * Maximum number of traffic classes
+ * DPNI_MAX_TC - Maximum number of traffic classes
  */
 #define DPNI_MAX_TC				8
 /**
- * Maximum number of buffer pools per DPNI
+ * DPNI_MAX_DPBP - Maximum number of buffer pools per DPNI
  */
 #define DPNI_MAX_DPBP				8
 
 /**
- * All traffic classes considered; see dpni_set_queue()
+ * DPNI_ALL_TCS - All traffic classes considered; see dpni_set_queue()
  */
 #define DPNI_ALL_TCS				(u8)(-1)
 /**
- * All flows within traffic class considered; see dpni_set_queue()
+ * DPNI_ALL_TC_FLOWS - All flows within traffic class considered; see
+ * dpni_set_queue()
  */
 #define DPNI_ALL_TC_FLOWS			(u16)(-1)
 /**
- * Generate new flow ID; see dpni_set_queue()
+ * DPNI_NEW_FLOW_ID - Generate new flow ID; see dpni_set_queue()
  */
 #define DPNI_NEW_FLOW_ID			(u16)(-1)
 
 /**
- * Tx traffic is always released to a buffer pool on transmit, there are no
- * resources allocated to have the frames confirmed back to the source after
- * transmission.
+ * DPNI_OPT_TX_FRM_RELEASE - Tx traffic is always released to a buffer pool on
+ * transmit, there are no resources allocated to have the frames confirmed back
+ * to the source after transmission.
  */
 #define DPNI_OPT_TX_FRM_RELEASE			0x000001
 /**
- * Disables support for MAC address filtering for addresses other than primary
- * MAC address. This affects both unicast and multicast. Promiscuous mode can
- * still be enabled/disabled for both unicast and multicast. If promiscuous mode
- * is disabled, only traffic matching the primary MAC address will be accepted.
+ * DPNI_OPT_NO_MAC_FILTER - Disables support for MAC address filtering for
+ * addresses other than primary MAC address. This affects both unicast and
+ * multicast. Promiscuous mode can still be enabled/disabled for both unicast
+ * and multicast. If promiscuous mode is disabled, only traffic matching the
+ * primary MAC address will be accepted.
  */
 #define DPNI_OPT_NO_MAC_FILTER			0x000002
 /**
- * Allocate policers for this DPNI. They can be used to rate-limit traffic per
- * traffic class (TC) basis.
+ * DPNI_OPT_HAS_POLICING - Allocate policers for this DPNI. They can be used to
+ * rate-limit traffic per traffic class (TC) basis.
  */
 #define DPNI_OPT_HAS_POLICING			0x000004
 /**
- * Congestion can be managed in several ways, allowing the buffer pool to
- * deplete on ingress, taildrop on each queue or use congestion groups for sets
- * of queues. If set, it configures a single congestion groups across all TCs.
- * If reset, a congestion group is allocated for each TC. Only relevant if the
- * DPNI has multiple traffic classes.
+ * DPNI_OPT_SHARED_CONGESTION - Congestion can be managed in several ways,
+ * allowing the buffer pool to deplete on ingress, taildrop on each queue or
+ * use congestion groups for sets of queues. If set, it configures a single
+ * congestion groups across all TCs.  If reset, a congestion group is allocated
+ * for each TC. Only relevant if the DPNI has multiple traffic classes.
  */
 #define DPNI_OPT_SHARED_CONGESTION		0x000008
 /**
- * Enables TCAM for Flow Steering and QoS look-ups. If not specified, all
- * look-ups are exact match. Note that TCAM is not available on LS1088 and its
- * variants. Setting this bit on these SoCs will trigger an error.
+ * DPNI_OPT_HAS_KEY_MASKING - Enables TCAM for Flow Steering and QoS look-ups.
+ * If not specified, all look-ups are exact match. Note that TCAM is not
+ * available on LS1088 and its variants. Setting this bit on these SoCs will
+ * trigger an error.
  */
 #define DPNI_OPT_HAS_KEY_MASKING		0x000010
 /**
- * Disables the flow steering table.
+ * DPNI_OPT_NO_FS - Disables the flow steering table.
  */
 #define DPNI_OPT_NO_FS				0x000020
 /**
- * Flow steering table is shared between all traffic classes
+ * DPNI_OPT_SHARED_FS - Flow steering table is shared between all traffic
+ * classes
  */
 #define DPNI_OPT_SHARED_FS			0x001000
 
@@ -129,20 +132,14 @@ int dpni_reset(struct fsl_mc_io	*mc_io,
 	       u32		cmd_flags,
 	       u16		token);
 
-/**
- * DPNI IRQ Index and Events
- */
+/* DPNI IRQ Index and Events */
 
-/**
- * IRQ index
- */
 #define DPNI_IRQ_INDEX				0
-/**
- * IRQ events:
- *       indicates a change in link state
- *       indicates a change in endpoint
- */
+
+/* DPNI_IRQ_EVENT_LINK_CHANGED - indicates a change in link state */
 #define DPNI_IRQ_EVENT_LINK_CHANGED		0x00000001
+
+/* DPNI_IRQ_EVENT_ENDPOINT_CHANGED - indicates a change in endpoint */
 #define DPNI_IRQ_EVENT_ENDPOINT_CHANGED		0x00000002
 
 int dpni_set_irq_enable(struct fsl_mc_io	*mc_io,
@@ -222,32 +219,30 @@ int dpni_get_attributes(struct fsl_mc_io	*mc_io,
 			u16			token,
 			struct dpni_attr	*attr);
 
-/**
- * DPNI errors
- */
+/* DPNI errors */
 
 /**
- * Extract out of frame header error
+ * DPNI_ERROR_EOFHE - Extract out of frame header error
  */
 #define DPNI_ERROR_EOFHE	0x00020000
 /**
- * Frame length error
+ * DPNI_ERROR_FLE - Frame length error
  */
 #define DPNI_ERROR_FLE		0x00002000
 /**
- * Frame physical error
+ * DPNI_ERROR_FPE - Frame physical error
  */
 #define DPNI_ERROR_FPE		0x00001000
 /**
- * Parsing header error
+ * DPNI_ERROR_PHE - Parsing header error
  */
 #define DPNI_ERROR_PHE		0x00000020
 /**
- * Parser L3 checksum error
+ * DPNI_ERROR_L3CE - Parser L3 checksum error
  */
 #define DPNI_ERROR_L3CE		0x00000004
 /**
- * Parser L3 checksum error
+ * DPNI_ERROR_L4CE - Parser L3 checksum error
  */
 #define DPNI_ERROR_L4CE		0x00000001
 
@@ -281,36 +276,35 @@ int dpni_set_errors_behavior(struct fsl_mc_io		*mc_io,
 			     u16			token,
 			     struct dpni_error_cfg	*cfg);
 
-/**
- * DPNI buffer layout modification options
- */
+/* DPNI buffer layout modification options */
 
 /**
- * Select to modify the time-stamp setting
+ * DPNI_BUF_LAYOUT_OPT_TIMESTAMP - Select to modify the time-stamp setting
  */
 #define DPNI_BUF_LAYOUT_OPT_TIMESTAMP		0x00000001
 /**
- * Select to modify the parser-result setting; not applicable for Tx
+ * DPNI_BUF_LAYOUT_OPT_PARSER_RESULT - Select to modify the parser-result
+ * setting; not applicable for Tx
  */
 #define DPNI_BUF_LAYOUT_OPT_PARSER_RESULT	0x00000002
 /**
- * Select to modify the frame-status setting
+ * DPNI_BUF_LAYOUT_OPT_FRAME_STATUS - Select to modify the frame-status setting
  */
 #define DPNI_BUF_LAYOUT_OPT_FRAME_STATUS	0x00000004
 /**
- * Select to modify the private-data-size setting
+ * DPNI_BUF_LAYOUT_OPT_PRIVATE_DATA_SIZE - Select to modify the private-data-size setting
  */
 #define DPNI_BUF_LAYOUT_OPT_PRIVATE_DATA_SIZE	0x00000008
 /**
- * Select to modify the data-alignment setting
+ * DPNI_BUF_LAYOUT_OPT_DATA_ALIGN - Select to modify the data-alignment setting
  */
 #define DPNI_BUF_LAYOUT_OPT_DATA_ALIGN		0x00000010
 /**
- * Select to modify the data-head-room setting
+ * DPNI_BUF_LAYOUT_OPT_DATA_HEAD_ROOM - Select to modify the data-head-room setting
  */
 #define DPNI_BUF_LAYOUT_OPT_DATA_HEAD_ROOM	0x00000020
 /**
- * Select to modify the data-tail-room setting
+ * DPNI_BUF_LAYOUT_OPT_DATA_TAIL_ROOM - Select to modify the data-tail-room setting
  */
 #define DPNI_BUF_LAYOUT_OPT_DATA_TAIL_ROOM	0x00000040
 
@@ -343,7 +337,8 @@ struct dpni_buffer_layout {
  * @DPNI_QUEUE_TX: Tx queue
  * @DPNI_QUEUE_TX_CONFIRM: Tx confirmation queue
  * @DPNI_QUEUE_RX_ERR: Rx error queue
- */enum dpni_queue_type {
+ */
+enum dpni_queue_type {
 	DPNI_QUEUE_RX,
 	DPNI_QUEUE_TX,
 	DPNI_QUEUE_TX_CONFIRM,
@@ -424,7 +419,7 @@ int dpni_get_tx_data_offset(struct fsl_mc_io	*mc_io,
  *	lack of buffers
  * @page_2.egress_discarded_frames: Egress discarded frame count
  * @page_2.egress_confirmed_frames: Egress confirmed frame count
- * @page3: Page_3 statistics structure
+ * @page_3: Page_3 statistics structure
  * @page_3.egress_dequeue_bytes: Cumulative count of the number of bytes
  *	dequeued from egress FQs
  * @page_3.egress_dequeue_frames: Cumulative count of the number of frames
@@ -501,30 +496,14 @@ int dpni_get_statistics(struct fsl_mc_io	*mc_io,
 			u8			page,
 			union dpni_statistics	*stat);
 
-/**
- * Enable auto-negotiation
- */
 #define DPNI_LINK_OPT_AUTONEG		0x0000000000000001ULL
-/**
- * Enable half-duplex mode
- */
 #define DPNI_LINK_OPT_HALF_DUPLEX	0x0000000000000002ULL
-/**
- * Enable pause frames
- */
 #define DPNI_LINK_OPT_PAUSE		0x0000000000000004ULL
-/**
- * Enable a-symmetric pause frames
- */
 #define DPNI_LINK_OPT_ASYM_PAUSE	0x0000000000000008ULL
-
-/**
- * Enable priority flow control pause frames
- */
 #define DPNI_LINK_OPT_PFC_PAUSE		0x0000000000000010ULL
 
 /**
- * struct - Structure representing DPNI link configuration
+ * struct dpni_link_cfg - Structure representing DPNI link configuration
  * @rate: Rate
  * @options: Mask of available options; use 'DPNI_LINK_OPT_<X>' values
  */
@@ -687,8 +666,8 @@ int dpni_set_rx_tc_dist(struct fsl_mc_io			*mc_io,
 			const struct dpni_rx_tc_dist_cfg	*cfg);
 
 /**
- * When used for fs_miss_flow_id in function dpni_set_rx_dist,
- * will signal to dpni to drop all unclassified frames
+ * DPNI_FS_MISS_DROP - When used for fs_miss_flow_id in function
+ * dpni_set_rx_dist, will signal to dpni to drop all unclassified frames
  */
 #define DPNI_FS_MISS_DROP		((uint16_t)-1)
 
@@ -766,7 +745,7 @@ enum dpni_dest {
 
 /**
  * struct dpni_queue - Queue structure
- * @destination - Destination structure
+ * @destination: - Destination structure
  * @destination.id: ID of the destination, only relevant if DEST_TYPE is > 0.
  *	Identifies either a DPIO or a DPCON object.
  *	Not relevant for Tx queues.
@@ -837,9 +816,7 @@ struct dpni_queue_id {
 	u16 qdbin;
 };
 
-/**
- * Set User Context
- */
+/* Set User Context */
 #define DPNI_QUEUE_OPT_USER_CTX		0x00000001
 #define DPNI_QUEUE_OPT_DEST		0x00000002
 #define DPNI_QUEUE_OPT_FLC		0x00000004
@@ -904,9 +881,9 @@ struct dpni_dest_cfg {
 /* DPNI congestion options */
 
 /**
- * This congestion will trigger flow control or priority flow control.
- * This will have effect only if flow control is enabled with
- * dpni_set_link_cfg().
+ * DPNI_CONG_OPT_FLOW_CONTROL - This congestion will trigger flow control or
+ * priority flow control.  This will have effect only if flow control is
+ * enabled with dpni_set_link_cfg().
  */
 #define DPNI_CONG_OPT_FLOW_CONTROL		0x00000040
 
@@ -990,23 +967,24 @@ struct dpni_rule_cfg {
 };
 
 /**
- * Discard matching traffic. If set, this takes precedence over any other
- * configuration and matching traffic is always discarded.
+ * DPNI_FS_OPT_DISCARD - Discard matching traffic. If set, this takes
+ * precedence over any other configuration and matching traffic is always
+ * discarded.
  */
  #define DPNI_FS_OPT_DISCARD            0x1
 
 /**
- * Set FLC value. If set, flc member of struct dpni_fs_action_cfg is used to
- * override the FLC value set per queue.
+ * DPNI_FS_OPT_SET_FLC - Set FLC value. If set, flc member of struct
+ * dpni_fs_action_cfg is used to override the FLC value set per queue.
  * For more details check the Frame Descriptor section in the hardware
  * documentation.
  */
 #define DPNI_FS_OPT_SET_FLC            0x2
 
 /**
- * Indicates whether the 6 lowest significant bits of FLC are used for stash
- * control. If set, the 6 least significant bits in value are interpreted as
- * follows:
+ * DPNI_FS_OPT_SET_STASH_CONTROL - Indicates whether the 6 lowest significant
+ * bits of FLC are used for stash control. If set, the 6 least significant bits
+ * in value are interpreted as follows:
  *     - bits 0-1: indicates the number of 64 byte units of context that are
  *     stashed. FLC value is interpreted as a memory address in this case,
  *     excluding the 6 LS bits.
@@ -1068,7 +1046,7 @@ int dpni_get_api_version(struct fsl_mc_io *mc_io,
 			 u16 *major_ver,
 			 u16 *minor_ver);
 /**
- * struct dpni_tx_shaping - Structure representing DPNI tx shaping configuration
+ * struct dpni_tx_shaping_cfg - Structure representing DPNI tx shaping configuration
  * @rate_limit:		Rate in Mbps
  * @max_burst_size:	Burst size in bytes (up to 64KB)
  */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dprtc.h b/drivers/net/ethernet/freescale/dpaa2/dprtc.h
index 05c413719e55..01d77c685a5b 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dprtc.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dprtc.h
@@ -13,9 +13,6 @@
 
 struct fsl_mc_io;
 
-/**
- * Number of irq's
- */
 #define DPRTC_MAX_IRQ_NUM	1
 #define DPRTC_IRQ_INDEX		0
 
-- 
2.30.0

