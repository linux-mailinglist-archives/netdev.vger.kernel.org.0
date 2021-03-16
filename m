Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9B233D63B
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 15:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237630AbhCPO4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 10:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbhCPOzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 10:55:33 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D728EC061756
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 07:55:32 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id bf3so21843819edb.6
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 07:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5cY1vttggKJxfAN1gIvxnaprcsfV9QcSRjH3K9V2X4U=;
        b=q8f+L0OoaYxQp/tInGT2IySMb9wsEN5dBE9JYwmTMsM0jov756vFi9PyoNuxqzSQDJ
         0eoLt4vc+85sYtnh1fUFsInGCDaMuPRCHL1CKg/5/tUSYmYek4Sv3XWPO0TPw4kLanYt
         UEHkdC+4jxuFoLCaOTUDq6ZlefCqe3WZoWhU6ZCwiGuT192WGGCet95NVvSLIYsOow7A
         rbOIGlYCzybwNw7Jnxe3bzFR4FOhYryuJaZ7VEjHyAdL1SMtzH9qq0szDO4Y2HUmzRQr
         Gw4pSlQdzY/FypsNX8XtR0HxinaaN5eDYUZPe7oAX3UmAGnXAVobr3j9k5mGRbVEEKsU
         XzFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5cY1vttggKJxfAN1gIvxnaprcsfV9QcSRjH3K9V2X4U=;
        b=Gn+YKAfKurSko2oms5kEeCT2Xouh9amSzYvyDVD2+KZvdhncJ7xK+Po22oFVtOstVl
         aSOO6frw5Hm1rt4mmJol0h4HxBZujsoJVPqYmKR3Wl92itR0zo3x38wNFDVzBOALVeAA
         T0ckvHs3QnbcJ4TCiRtzNrbRTXca/92chx+lOfb1brLTr20BlHHBkiIfQUCH44DROczF
         QU2hwCIy3NuYt8I+4W10BPHtsJ1Khj0SKf9rT5miVeOYX/iOlKB1WXHGZS2z2lkvt18e
         DInegUV67PkZKQmbAhkeuk7yztp53nx5O7//p4lL4e6qyPhQScuMcpfZGyse03yo3F+0
         8SFA==
X-Gm-Message-State: AOAM530W89Mgh7Ll0u00XcOHQxm2wwpxPOvUa+iZAaeFtqd48lXU08L3
        1jWi0Koo8l9nwWELxFROejGwYWlVhiI=
X-Google-Smtp-Source: ABdhPJyoJn27BeFC/cHs4v9BJuDh6QIJlfXUhohByU1dOkYwG+NGFglJqxxdvC/5qySnEAMuTQp8jA==
X-Received: by 2002:aa7:c403:: with SMTP id j3mr36565981edq.137.1615906531538;
        Tue, 16 Mar 2021 07:55:31 -0700 (PDT)
Received: from yoga-910.localhost (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id w18sm9681402ejn.23.2021.03.16.07.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 07:55:31 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ruxandra.radulescu@nxp.com, yangbo.lu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 1/5] dpaa2-switch: remove unused ABI functions
Date:   Tue, 16 Mar 2021 16:55:08 +0200
Message-Id: <20210316145512.2152374-2-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210316145512.2152374-1-ciorneiioana@gmail.com>
References: <20210316145512.2152374-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Cleanup the dpaa2-switch driver a bit by removing any unused MC firmware
ABI definitions.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../net/ethernet/freescale/dpaa2/dpsw-cmd.h   |  7 --
 drivers/net/ethernet/freescale/dpaa2/dpsw.c   | 70 +------------------
 drivers/net/ethernet/freescale/dpaa2/dpsw.h   |  6 --
 3 files changed, 1 insertion(+), 82 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpsw-cmd.h b/drivers/net/ethernet/freescale/dpaa2/dpsw-cmd.h
index eb620e832412..2371fd5c40e3 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpsw-cmd.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpsw-cmd.h
@@ -75,8 +75,6 @@
 #define DPSW_CMDID_FDB_DUMP                 DPSW_CMD_ID(0x08A)
 
 #define DPSW_CMDID_IF_GET_PORT_MAC_ADDR     DPSW_CMD_ID(0x0A7)
-#define DPSW_CMDID_IF_GET_PRIMARY_MAC_ADDR  DPSW_CMD_ID(0x0A8)
-#define DPSW_CMDID_IF_SET_PRIMARY_MAC_ADDR  DPSW_CMD_ID(0x0A9)
 
 #define DPSW_CMDID_CTRL_IF_GET_ATTR         DPSW_CMD_ID(0x0A0)
 #define DPSW_CMDID_CTRL_IF_SET_POOLS        DPSW_CMD_ID(0x0A1)
@@ -443,11 +441,6 @@ struct dpsw_rsp_if_get_mac_addr {
 	u8 mac_addr[6];
 };
 
-struct dpsw_cmd_if_set_mac_addr {
-	__le16 if_id;
-	u8 mac_addr[6];
-};
-
 struct dpsw_cmd_set_egress_flood {
 	__le16 fdb_id;
 	u8 flood_type;
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpsw.c b/drivers/net/ethernet/freescale/dpaa2/dpsw.c
index 5189f156100e..f94874381b69 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpsw.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpsw.c
@@ -397,7 +397,7 @@ int dpsw_if_set_link_cfg(struct fsl_mc_io *mc_io,
  * @if_id:	Interface id
  * @state:	Link state	1 - linkup, 0 - link down or disconnected
  *
- * @Return	'0' on Success; Error code otherwise.
+ * Return:	'0' on Success; Error code otherwise.
  */
 int dpsw_if_get_link_state(struct fsl_mc_io *mc_io,
 			   u32 cmd_flags,
@@ -1356,74 +1356,6 @@ int dpsw_if_get_port_mac_addr(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
 	return 0;
 }
 
-/**
- * dpsw_if_get_primary_mac_addr()
- * @mc_io:	Pointer to MC portal's I/O object
- * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
- * @token:	Token of DPSW object
- * @if_id:	Interface Identifier
- * @mac_addr:	MAC address of the physical port, if any, otherwise 0
- *
- * Return:	Completion status. '0' on Success; Error code otherwise.
- */
-int dpsw_if_get_primary_mac_addr(struct fsl_mc_io *mc_io, u32 cmd_flags,
-				 u16 token, u16 if_id, u8 mac_addr[6])
-{
-	struct dpsw_rsp_if_get_mac_addr *rsp_params;
-	struct fsl_mc_command cmd = { 0 };
-	struct dpsw_cmd_if *cmd_params;
-	int err, i;
-
-	/* prepare command */
-	cmd.header = mc_encode_cmd_header(DPSW_CMDID_IF_SET_PRIMARY_MAC_ADDR,
-					  cmd_flags,
-					  token);
-	cmd_params = (struct dpsw_cmd_if *)cmd.params;
-	cmd_params->if_id = cpu_to_le16(if_id);
-
-	/* send command to mc*/
-	err = mc_send_command(mc_io, &cmd);
-	if (err)
-		return err;
-
-	/* retrieve response parameters */
-	rsp_params = (struct dpsw_rsp_if_get_mac_addr *)cmd.params;
-	for (i = 0; i < 6; i++)
-		mac_addr[5 - i] = rsp_params->mac_addr[i];
-
-	return 0;
-}
-
-/**
- * dpsw_if_set_primary_mac_addr()
- * @mc_io:	Pointer to MC portal's I/O object
- * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
- * @token:	Token of DPSW object
- * @if_id:	Interface Identifier
- * @mac_addr:	MAC address of the physical port, if any, otherwise 0
- *
- * Return:	Completion status. '0' on Success; Error code otherwise.
- */
-int dpsw_if_set_primary_mac_addr(struct fsl_mc_io *mc_io, u32 cmd_flags,
-				 u16 token, u16 if_id, u8 mac_addr[6])
-{
-	struct dpsw_cmd_if_set_mac_addr *cmd_params;
-	struct fsl_mc_command cmd = { 0 };
-	int i;
-
-	/* prepare command */
-	cmd.header = mc_encode_cmd_header(DPSW_CMDID_IF_SET_PRIMARY_MAC_ADDR,
-					  cmd_flags,
-					  token);
-	cmd_params = (struct dpsw_cmd_if_set_mac_addr *)cmd.params;
-	cmd_params->if_id = cpu_to_le16(if_id);
-	for (i = 0; i < 6; i++)
-		cmd_params->mac_addr[i] = mac_addr[5 - i];
-
-	/* send command to mc*/
-	return mc_send_command(mc_io, &cmd);
-}
-
 /**
  * dpsw_ctrl_if_enable() - Enable control interface
  * @mc_io:	Pointer to MC portal's I/O object
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpsw.h b/drivers/net/ethernet/freescale/dpaa2/dpsw.h
index 9e04350f3277..e5e9c35604a7 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpsw.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpsw.h
@@ -707,12 +707,6 @@ int dpsw_get_api_version(struct fsl_mc_io *mc_io,
 int dpsw_if_get_port_mac_addr(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
 			      u16 if_id, u8 mac_addr[6]);
 
-int dpsw_if_get_primary_mac_addr(struct fsl_mc_io *mc_io, u32 cmd_flags,
-				 u16 token, u16 if_id, u8 mac_addr[6]);
-
-int dpsw_if_set_primary_mac_addr(struct fsl_mc_io *mc_io, u32 cmd_flags,
-				 u16 token, u16 if_id, u8 mac_addr[6]);
-
 /**
  * struct dpsw_fdb_cfg  - FDB Configuration
  * @num_fdb_entries: Number of FDB entries
-- 
2.30.0

