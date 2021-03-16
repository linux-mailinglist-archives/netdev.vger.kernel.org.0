Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C831533D63D
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 15:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237639AbhCPO4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 10:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbhCPOze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 10:55:34 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0F1C061762
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 07:55:33 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id dm8so21889842edb.2
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 07:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GOcsnumBGmuLOKygYRRBDZmidHGd/6joY3FP+GTAY7I=;
        b=G+FgMMaR39LMpPD6BBXvYgNrwdUWvpnL6fCy4W5c74w+CPehqS2IfJ0Qg6tUtQWqpl
         NRr+TUnJqSGjeUWT5/TPkDM+IOFkDd6rK0Hxp4HIc/WVVwgx6bmmXUjNW7a/HTF1Ms+e
         8Ew5G0Zu/xAOtz3bPOKVI/vW9JvbM/0ElmpJ4jEt0fhzsNH31XkTbVPpwviQUtrvFRN7
         EYrgyEsQ+nYRm8E7Y2NxODgeibhHnuM24xclJCHC+/7mZnFwAJcGvxlirKhLbvI1oIn5
         UiseQhAI2o9jaYhuGFAJTGYfPfv4TX6mTBLOgpHW88BiCX2sm3uYeMJx35xtx9+TD5pV
         VRcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GOcsnumBGmuLOKygYRRBDZmidHGd/6joY3FP+GTAY7I=;
        b=Z2vNCjQfhxfHAOs66W3K0aT7mfg98PlIs0Lm8IXfyWp1DrAQsrdanr0RmOkiadyu7N
         8gTDtfN53e6tVOYfqCaILDAt0ZytW2fSBcN4u0TcxGRBuOHBsXtbnl/X3qFnbRZII+Mf
         q0uq5h1RCS0gn1PdyZDRZegOdRscBkD2qbql0UGtT9Kd246seJlhxNcLJiqM0+Uw8Ka8
         ++yirhJoDg8kUpRJL2J668OUmcKEImopSTZSza1ZeoO9XLbLER8c8k1tj11tOneE4NNB
         HjqIVmxWnxavgTQTJY+fLIe1mbtzFpD9Mj7OgLGLI+lsEtHwxdFCFZuNQY6kYN0GQj8L
         3iCQ==
X-Gm-Message-State: AOAM531Mom2ZkLiLHZrwvw8qmry/lQvbCAz2GUcWXBBIXAGjA6HsnA2l
        Wloy7GXYIgoeQINLg6WKKKk=
X-Google-Smtp-Source: ABdhPJxEtst1VRXWGmdgWWYXg6Zcnwr1v6JczxBlmzhdbl8P3YlQU1kIg0Ukz2yrxVtQI8zcSFXW+g==
X-Received: by 2002:a50:e882:: with SMTP id f2mr36669136edn.184.1615906532427;
        Tue, 16 Mar 2021 07:55:32 -0700 (PDT)
Received: from yoga-910.localhost (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id w18sm9681402ejn.23.2021.03.16.07.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 07:55:32 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ruxandra.radulescu@nxp.com, yangbo.lu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 2/5] dpaa2-switch: fix kdoc warnings
Date:   Tue, 16 Mar 2021 16:55:09 +0200
Message-Id: <20210316145512.2152374-3-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210316145512.2152374-1-ciorneiioana@gmail.com>
References: <20210316145512.2152374-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Running kernel-doc over the dpaa2-switch driver generates a bunch of
warnings. Fix them up by removing code comments for macros which are
self-explanatory and adding a bit more context for the
dpsw_if_get_port_mac_addr() function and the fields of the
dpsw_vlan_if_cfg structure.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpsw.c |  2 +-
 drivers/net/ethernet/freescale/dpaa2/dpsw.h | 57 +++++----------------
 2 files changed, 15 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpsw.c b/drivers/net/ethernet/freescale/dpaa2/dpsw.c
index f94874381b69..ad7a4c03b130 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpsw.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpsw.c
@@ -1319,7 +1319,7 @@ int dpsw_get_api_version(struct fsl_mc_io *mc_io,
 }
 
 /**
- * dpsw_if_get_port_mac_addr()
+ * dpsw_if_get_port_mac_addr() - Retrieve MAC address associated to the physical port
  * @mc_io:	Pointer to MC portal's I/O object
  * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
  * @token:	Token of DPSW object
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpsw.h b/drivers/net/ethernet/freescale/dpaa2/dpsw.h
index e5e9c35604a7..6807b15f5807 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpsw.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpsw.h
@@ -14,17 +14,10 @@
 
 struct fsl_mc_io;
 
-/**
- * DPSW general definitions
- */
+/* DPSW general definitions */
 
-/**
- * Maximum number of traffic class priorities
- */
 #define DPSW_MAX_PRIORITIES	8
-/**
- * Maximum number of interfaces
- */
+
 #define DPSW_MAX_IF		64
 
 int dpsw_open(struct fsl_mc_io *mc_io,
@@ -36,30 +29,20 @@ int dpsw_close(struct fsl_mc_io *mc_io,
 	       u32 cmd_flags,
 	       u16 token);
 
-/**
- * DPSW options
- */
+/* DPSW options */
 
 /**
- * Disable flooding
+ * DPSW_OPT_FLOODING_DIS - Flooding was disabled at device create
  */
 #define DPSW_OPT_FLOODING_DIS		0x0000000000000001ULL
 /**
- * Disable Multicast
+ * DPSW_OPT_MULTICAST_DIS - Multicast was disabled at device create
  */
 #define DPSW_OPT_MULTICAST_DIS		0x0000000000000004ULL
 /**
- * Support control interface
+ * DPSW_OPT_CTRL_IF_DIS - Control interface support is disabled
  */
 #define DPSW_OPT_CTRL_IF_DIS		0x0000000000000010ULL
-/**
- * Disable flooding metering
- */
-#define DPSW_OPT_FLOODING_METERING_DIS  0x0000000000000020ULL
-/**
- * Enable metering
- */
-#define DPSW_OPT_METERING_EN            0x0000000000000040ULL
 
 /**
  * enum dpsw_component_type - component type of a bridge
@@ -116,15 +99,13 @@ int dpsw_reset(struct fsl_mc_io *mc_io,
 	       u32 cmd_flags,
 	       u16 token);
 
-/**
- * DPSW IRQ Index and Events
- */
+/* DPSW IRQ Index and Events */
 
 #define DPSW_IRQ_INDEX_IF		0x0000
 #define DPSW_IRQ_INDEX_L2SW		0x0001
 
 /**
- * IRQ event - Indicates that the link state changed
+ * DPSW_IRQ_EVENT_LINK_CHANGED - Indicates that the link state changed
  */
 #define DPSW_IRQ_EVENT_LINK_CHANGED	0x0001
 
@@ -229,9 +210,6 @@ enum dpsw_queue_type {
 	DPSW_QUEUE_RX_ERR,
 };
 
-/**
- * Maximum number of DPBP
- */
 #define DPSW_MAX_DPBP     8
 
 /**
@@ -293,21 +271,9 @@ enum dpsw_action {
 	DPSW_ACTION_REDIRECT = 1
 };
 
-/**
- * Enable auto-negotiation
- */
 #define DPSW_LINK_OPT_AUTONEG		0x0000000000000001ULL
-/**
- * Enable half-duplex mode
- */
 #define DPSW_LINK_OPT_HALF_DUPLEX	0x0000000000000002ULL
-/**
- * Enable pause frames
- */
 #define DPSW_LINK_OPT_PAUSE		0x0000000000000004ULL
-/**
- * Enable a-symmetric pause frames
- */
 #define DPSW_LINK_OPT_ASYM_PAUSE	0x0000000000000008ULL
 
 /**
@@ -376,10 +342,11 @@ int dpsw_if_get_tci(struct fsl_mc_io *mc_io,
 
 /**
  * enum dpsw_stp_state - Spanning Tree Protocol (STP) states
- * @DPSW_STP_STATE_BLOCKING: Blocking state
+ * @DPSW_STP_STATE_DISABLED: Disabled state
  * @DPSW_STP_STATE_LISTENING: Listening state
  * @DPSW_STP_STATE_LEARNING: Learning state
  * @DPSW_STP_STATE_FORWARDING: Forwarding state
+ * @DPSW_STP_STATE_BLOCKING: Blocking state
  *
  */
 enum dpsw_stp_state {
@@ -524,6 +491,10 @@ int dpsw_vlan_add(struct fsl_mc_io *mc_io,
  *		list for this VLAN
  * @if_id: The set of interfaces that are
  *		assigned to the egress list for this VLAN
+ * @options: Options map for this command (DPSW_VLAN_ADD_IF_OPT_FDB_ID)
+ * @fdb_id: FDB id to be used by this VLAN on these specific interfaces
+ *		(taken into account only if the DPSW_VLAN_ADD_IF_OPT_FDB_ID is
+ *		specified in the options field)
  */
 struct dpsw_vlan_if_cfg {
 	u16 num_ifs;
-- 
2.30.0

