Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDEB33D641
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 15:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237655AbhCPO4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 10:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237624AbhCPOzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 10:55:36 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2FD3C06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 07:55:35 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id h10so21840856edt.13
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 07:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NQC9xTJlDB3OBIMKW1RuChvCDlrV0iAAytW1b7tX35w=;
        b=Uy/vU5cfz0EvSq1z5dqph5efAWf5B3SKI4/S6Ri32tIDnD292x7XawVTU6WKANdHkI
         jTe9Vo6z/rL6OvfkAQ/yY4znRH7z1fp8Au/qsz+isQrkF7jl4NPlqmUgocu7cI4jjpmQ
         mc3VmJ/bKPrZ44BzYavqDQAgBemlBVIzyoEPcv1DNT66JGvXg7RLbgsgbauQGdUQbtMz
         zG8FLr/3vHL9k5EhVjh66g2P7bkYbq9wjMOT2pvygWvhS2D2fWBo+yu9mejDAnNQ56vL
         K7/4Q+lbAysFKEpeGcqW1XIG7bOxbgu/VHahDMluw6962D0BPn1DKS3zeU16roii0lZ+
         pkiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NQC9xTJlDB3OBIMKW1RuChvCDlrV0iAAytW1b7tX35w=;
        b=eP02A2wr08y59H/ZIcLo6DS4Zk13To+QgS7b8EudGSk+2N2S4TenkaGAGB2Q1x6eqL
         9uqkRshvH8N1HPyIkh4by2y9NgEF2ATsa6I5c20OIiMn1RcbbrXjVJA6a2NU7v6CCXIo
         LIBrIzbiaEiug+PvmBOrF/0qYVOLXBHvEp9cAJ7lBI6mE/hukngh6GJv7kbCClH54qDl
         rHA8zYX66lIzpYM0fEf/7GJ8KOAremBx0Ok1jmBhh3BuJK6xgsbx1+c7nC3qlQJ0kxeA
         JMSVrF/tefRXTmG/HwZFOmFJMw0PY4yaSQ8OY7c9nO6IHl+twTLXqOhVlf/7w3//XGbv
         h2Vg==
X-Gm-Message-State: AOAM5324q4Vhc+86JkBzuyFvknHb7AXC4v1JGXgQow0b/uXZ4I1cpkUL
        XkwB5azEQcLIbPyLkAZswDY=
X-Google-Smtp-Source: ABdhPJzaqsjY2edFdn/usqQwk4ZVZ1RvwCdsVbX0vr0S8RAh0W7MUDbfQN4moP99B2QF+5ZZPVAQfg==
X-Received: by 2002:a05:6402:104c:: with SMTP id e12mr35556153edu.108.1615906534337;
        Tue, 16 Mar 2021 07:55:34 -0700 (PDT)
Received: from yoga-910.localhost (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id w18sm9681402ejn.23.2021.03.16.07.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 07:55:34 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ruxandra.radulescu@nxp.com, yangbo.lu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 4/5] dpaa2-switch: fit the function declaration on the same line
Date:   Tue, 16 Mar 2021 16:55:11 +0200
Message-Id: <20210316145512.2152374-5-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210316145512.2152374-1-ciorneiioana@gmail.com>
References: <20210316145512.2152374-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Multiple ABI function declarations are split unnecessarry on multiple
lines. Fix this so that we have a consistent coding style.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpsw.c | 191 +++++-------------
 drivers/net/ethernet/freescale/dpaa2/dpsw.h | 202 ++++++--------------
 2 files changed, 107 insertions(+), 286 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpsw.c b/drivers/net/ethernet/freescale/dpaa2/dpsw.c
index ef0f90ae683f..56f3c23fce07 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpsw.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpsw.c
@@ -9,9 +9,7 @@
 #include "dpsw.h"
 #include "dpsw-cmd.h"
 
-static void build_if_id_bitmap(__le64 *bmap,
-			       const u16 *id,
-			       const u16 num_ifs)
+static void build_if_id_bitmap(__le64 *bmap, const u16 *id, const u16 num_ifs)
 {
 	int i;
 
@@ -38,10 +36,7 @@ static void build_if_id_bitmap(__le64 *bmap,
  *
  * Return:	'0' on Success; Error code otherwise.
  */
-int dpsw_open(struct fsl_mc_io *mc_io,
-	      u32 cmd_flags,
-	      int dpsw_id,
-	      u16 *token)
+int dpsw_open(struct fsl_mc_io *mc_io, u32 cmd_flags, int dpsw_id, u16 *token)
 {
 	struct fsl_mc_command cmd = { 0 };
 	struct dpsw_cmd_open *cmd_params;
@@ -76,9 +71,7 @@ int dpsw_open(struct fsl_mc_io *mc_io,
  *
  * Return:	'0' on Success; Error code otherwise.
  */
-int dpsw_close(struct fsl_mc_io *mc_io,
-	       u32 cmd_flags,
-	       u16 token)
+int dpsw_close(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token)
 {
 	struct fsl_mc_command cmd = { 0 };
 
@@ -99,9 +92,7 @@ int dpsw_close(struct fsl_mc_io *mc_io,
  *
  * Return:	Completion status. '0' on Success; Error code otherwise.
  */
-int dpsw_enable(struct fsl_mc_io *mc_io,
-		u32 cmd_flags,
-		u16 token)
+int dpsw_enable(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token)
 {
 	struct fsl_mc_command cmd = { 0 };
 
@@ -122,9 +113,7 @@ int dpsw_enable(struct fsl_mc_io *mc_io,
  *
  * Return:	Completion status. '0' on Success; Error code otherwise.
  */
-int dpsw_disable(struct fsl_mc_io *mc_io,
-		 u32 cmd_flags,
-		 u16 token)
+int dpsw_disable(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token)
 {
 	struct fsl_mc_command cmd = { 0 };
 
@@ -145,9 +134,7 @@ int dpsw_disable(struct fsl_mc_io *mc_io,
  *
  * Return:	'0' on Success; Error code otherwise.
  */
-int dpsw_reset(struct fsl_mc_io *mc_io,
-	       u32 cmd_flags,
-	       u16 token)
+int dpsw_reset(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token)
 {
 	struct fsl_mc_command cmd = { 0 };
 
@@ -175,11 +162,8 @@ int dpsw_reset(struct fsl_mc_io *mc_io,
  *
  * Return:	'0' on Success; Error code otherwise.
  */
-int dpsw_set_irq_enable(struct fsl_mc_io *mc_io,
-			u32 cmd_flags,
-			u16 token,
-			u8 irq_index,
-			u8 en)
+int dpsw_set_irq_enable(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			u8 irq_index, u8 en)
 {
 	struct fsl_mc_command cmd = { 0 };
 	struct dpsw_cmd_set_irq_enable *cmd_params;
@@ -212,11 +196,8 @@ int dpsw_set_irq_enable(struct fsl_mc_io *mc_io,
  *
  * Return:	'0' on Success; Error code otherwise.
  */
-int dpsw_set_irq_mask(struct fsl_mc_io *mc_io,
-		      u32 cmd_flags,
-		      u16 token,
-		      u8 irq_index,
-		      u32 mask)
+int dpsw_set_irq_mask(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+		      u8 irq_index, u32 mask)
 {
 	struct fsl_mc_command cmd = { 0 };
 	struct dpsw_cmd_set_irq_mask *cmd_params;
@@ -245,11 +226,8 @@ int dpsw_set_irq_mask(struct fsl_mc_io *mc_io,
  *
  * Return:	'0' on Success; Error code otherwise.
  */
-int dpsw_get_irq_status(struct fsl_mc_io *mc_io,
-			u32 cmd_flags,
-			u16 token,
-			u8 irq_index,
-			u32 *status)
+int dpsw_get_irq_status(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			u8 irq_index, u32 *status)
 {
 	struct fsl_mc_command cmd = { 0 };
 	struct dpsw_cmd_get_irq_status *cmd_params;
@@ -288,11 +266,8 @@ int dpsw_get_irq_status(struct fsl_mc_io *mc_io,
  *
  * Return:	'0' on Success; Error code otherwise.
  */
-int dpsw_clear_irq_status(struct fsl_mc_io *mc_io,
-			  u32 cmd_flags,
-			  u16 token,
-			  u8 irq_index,
-			  u32 status)
+int dpsw_clear_irq_status(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			  u8 irq_index, u32 status)
 {
 	struct fsl_mc_command cmd = { 0 };
 	struct dpsw_cmd_clear_irq_status *cmd_params;
@@ -318,9 +293,7 @@ int dpsw_clear_irq_status(struct fsl_mc_io *mc_io,
  *
  * Return:	Completion status. '0' on Success; Error code otherwise.
  */
-int dpsw_get_attributes(struct fsl_mc_io *mc_io,
-			u32 cmd_flags,
-			u16 token,
+int dpsw_get_attributes(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
 			struct dpsw_attr *attr)
 {
 	struct fsl_mc_command cmd = { 0 };
@@ -367,10 +340,7 @@ int dpsw_get_attributes(struct fsl_mc_io *mc_io,
  *
  * Return:	'0' on Success; Error code otherwise.
  */
-int dpsw_if_set_link_cfg(struct fsl_mc_io *mc_io,
-			 u32 cmd_flags,
-			 u16 token,
-			 u16 if_id,
+int dpsw_if_set_link_cfg(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token, u16 if_id,
 			 struct dpsw_link_cfg *cfg)
 {
 	struct fsl_mc_command cmd = { 0 };
@@ -399,11 +369,8 @@ int dpsw_if_set_link_cfg(struct fsl_mc_io *mc_io,
  *
  * Return:	'0' on Success; Error code otherwise.
  */
-int dpsw_if_get_link_state(struct fsl_mc_io *mc_io,
-			   u32 cmd_flags,
-			   u16 token,
-			   u16 if_id,
-			   struct dpsw_link_state *state)
+int dpsw_if_get_link_state(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			   u16 if_id, struct dpsw_link_state *state)
 {
 	struct fsl_mc_command cmd = { 0 };
 	struct dpsw_cmd_if_get_link_state *cmd_params;
@@ -441,10 +408,7 @@ int dpsw_if_get_link_state(struct fsl_mc_io *mc_io,
  *
  * Return:	Completion status. '0' on Success; Error code otherwise.
  */
-int dpsw_if_set_tci(struct fsl_mc_io *mc_io,
-		    u32 cmd_flags,
-		    u16 token,
-		    u16 if_id,
+int dpsw_if_set_tci(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token, u16 if_id,
 		    const struct dpsw_tci_cfg *cfg)
 {
 	struct fsl_mc_command cmd = { 0 };
@@ -476,10 +440,7 @@ int dpsw_if_set_tci(struct fsl_mc_io *mc_io,
  *
  * Return:	Completion status. '0' on Success; Error code otherwise.
  */
-int dpsw_if_get_tci(struct fsl_mc_io *mc_io,
-		    u32 cmd_flags,
-		    u16 token,
-		    u16 if_id,
+int dpsw_if_get_tci(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token, u16 if_id,
 		    struct dpsw_tci_cfg *cfg)
 {
 	struct fsl_mc_command cmd = { 0 };
@@ -521,10 +482,7 @@ int dpsw_if_get_tci(struct fsl_mc_io *mc_io,
  *
  * Return:	Completion status. '0' on Success; Error code otherwise.
  */
-int dpsw_if_set_stp(struct fsl_mc_io *mc_io,
-		    u32 cmd_flags,
-		    u16 token,
-		    u16 if_id,
+int dpsw_if_set_stp(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token, u16 if_id,
 		    const struct dpsw_stp_cfg *cfg)
 {
 	struct fsl_mc_command cmd = { 0 };
@@ -554,12 +512,8 @@ int dpsw_if_set_stp(struct fsl_mc_io *mc_io,
  *
  * Return:	Completion status. '0' on Success; Error code otherwise.
  */
-int dpsw_if_get_counter(struct fsl_mc_io *mc_io,
-			u32 cmd_flags,
-			u16 token,
-			u16 if_id,
-			enum dpsw_counter type,
-			u64 *counter)
+int dpsw_if_get_counter(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			u16 if_id, enum dpsw_counter type, u64 *counter)
 {
 	struct fsl_mc_command cmd = { 0 };
 	struct dpsw_cmd_if_get_counter *cmd_params;
@@ -595,10 +549,7 @@ int dpsw_if_get_counter(struct fsl_mc_io *mc_io,
  *
  * Return:	Completion status. '0' on Success; Error code otherwise.
  */
-int dpsw_if_enable(struct fsl_mc_io *mc_io,
-		   u32 cmd_flags,
-		   u16 token,
-		   u16 if_id)
+int dpsw_if_enable(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token, u16 if_id)
 {
 	struct fsl_mc_command cmd = { 0 };
 	struct dpsw_cmd_if *cmd_params;
@@ -623,10 +574,7 @@ int dpsw_if_enable(struct fsl_mc_io *mc_io,
  *
  * Return:	Completion status. '0' on Success; Error code otherwise.
  */
-int dpsw_if_disable(struct fsl_mc_io *mc_io,
-		    u32 cmd_flags,
-		    u16 token,
-		    u16 if_id)
+int dpsw_if_disable(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token, u16 if_id)
 {
 	struct fsl_mc_command cmd = { 0 };
 	struct dpsw_cmd_if *cmd_params;
@@ -693,11 +641,8 @@ int dpsw_if_get_attributes(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
  *
  * Return:	Completion status. '0' on Success; Error code otherwise.
  */
-int dpsw_if_set_max_frame_length(struct fsl_mc_io *mc_io,
-				 u32 cmd_flags,
-				 u16 token,
-				 u16 if_id,
-				 u16 frame_length)
+int dpsw_if_set_max_frame_length(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+				 u16 if_id, u16 frame_length)
 {
 	struct fsl_mc_command cmd = { 0 };
 	struct dpsw_cmd_if_set_max_frame_length *cmd_params;
@@ -731,11 +676,8 @@ int dpsw_if_set_max_frame_length(struct fsl_mc_io *mc_io,
  *
  * Return:	Completion status. '0' on Success; Error code otherwise.
  */
-int dpsw_vlan_add(struct fsl_mc_io *mc_io,
-		  u32 cmd_flags,
-		  u16 token,
-		  u16 vlan_id,
-		  const struct dpsw_vlan_cfg *cfg)
+int dpsw_vlan_add(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+		  u16 vlan_id, const struct dpsw_vlan_cfg *cfg)
 {
 	struct fsl_mc_command cmd = { 0 };
 	struct dpsw_vlan_add *cmd_params;
@@ -767,11 +709,8 @@ int dpsw_vlan_add(struct fsl_mc_io *mc_io,
  *
  * Return:	Completion status. '0' on Success; Error code otherwise.
  */
-int dpsw_vlan_add_if(struct fsl_mc_io *mc_io,
-		     u32 cmd_flags,
-		     u16 token,
-		     u16 vlan_id,
-		     const struct dpsw_vlan_if_cfg *cfg)
+int dpsw_vlan_add_if(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+		     u16 vlan_id, const struct dpsw_vlan_if_cfg *cfg)
 {
 	struct dpsw_cmd_vlan_add_if *cmd_params;
 	struct fsl_mc_command cmd = { 0 };
@@ -807,11 +746,8 @@ int dpsw_vlan_add_if(struct fsl_mc_io *mc_io,
  *
  * Return:	Completion status. '0' on Success; Error code otherwise.
  */
-int dpsw_vlan_add_if_untagged(struct fsl_mc_io *mc_io,
-			      u32 cmd_flags,
-			      u16 token,
-			      u16 vlan_id,
-			      const struct dpsw_vlan_if_cfg *cfg)
+int dpsw_vlan_add_if_untagged(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			      u16 vlan_id, const struct dpsw_vlan_if_cfg *cfg)
 {
 	struct fsl_mc_command cmd = { 0 };
 	struct dpsw_cmd_vlan_manage_if *cmd_params;
@@ -841,11 +777,8 @@ int dpsw_vlan_add_if_untagged(struct fsl_mc_io *mc_io,
  *
  * Return:	Completion status. '0' on Success; Error code otherwise.
  */
-int dpsw_vlan_remove_if(struct fsl_mc_io *mc_io,
-			u32 cmd_flags,
-			u16 token,
-			u16 vlan_id,
-			const struct dpsw_vlan_if_cfg *cfg)
+int dpsw_vlan_remove_if(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			u16 vlan_id, const struct dpsw_vlan_if_cfg *cfg)
 {
 	struct fsl_mc_command cmd = { 0 };
 	struct dpsw_cmd_vlan_manage_if *cmd_params;
@@ -877,11 +810,8 @@ int dpsw_vlan_remove_if(struct fsl_mc_io *mc_io,
  *
  * Return:	Completion status. '0' on Success; Error code otherwise.
  */
-int dpsw_vlan_remove_if_untagged(struct fsl_mc_io *mc_io,
-				 u32 cmd_flags,
-				 u16 token,
-				 u16 vlan_id,
-				 const struct dpsw_vlan_if_cfg *cfg)
+int dpsw_vlan_remove_if_untagged(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+				 u16 vlan_id, const struct dpsw_vlan_if_cfg *cfg)
 {
 	struct fsl_mc_command cmd = { 0 };
 	struct dpsw_cmd_vlan_manage_if *cmd_params;
@@ -907,9 +837,7 @@ int dpsw_vlan_remove_if_untagged(struct fsl_mc_io *mc_io,
  *
  * Return:	Completion status. '0' on Success; Error code otherwise.
  */
-int dpsw_vlan_remove(struct fsl_mc_io *mc_io,
-		     u32 cmd_flags,
-		     u16 token,
+int dpsw_vlan_remove(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
 		     u16 vlan_id)
 {
 	struct fsl_mc_command cmd = { 0 };
@@ -996,11 +924,8 @@ int dpsw_fdb_remove(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token, u16 fdb_i
  *
  * Return:	Completion status. '0' on Success; Error code otherwise.
  */
-int dpsw_fdb_add_unicast(struct fsl_mc_io *mc_io,
-			 u32 cmd_flags,
-			 u16 token,
-			 u16 fdb_id,
-			 const struct dpsw_fdb_unicast_cfg *cfg)
+int dpsw_fdb_add_unicast(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			 u16 fdb_id, const struct dpsw_fdb_unicast_cfg *cfg)
 {
 	struct fsl_mc_command cmd = { 0 };
 	struct dpsw_cmd_fdb_unicast_op *cmd_params;
@@ -1039,13 +964,8 @@ int dpsw_fdb_add_unicast(struct fsl_mc_io *mc_io,
  * The struct fdb_dump_entry array must be parsed until the end of memory
  * area or until an entry with mac_addr set to zero is found.
  */
-int dpsw_fdb_dump(struct fsl_mc_io *mc_io,
-		  u32 cmd_flags,
-		  u16 token,
-		  u16 fdb_id,
-		  u64 iova_addr,
-		  u32 iova_size,
-		  u16 *num_entries)
+int dpsw_fdb_dump(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token, u16 fdb_id,
+		  u64 iova_addr, u32 iova_size, u16 *num_entries)
 {
 	struct dpsw_cmd_fdb_dump *cmd_params;
 	struct dpsw_rsp_fdb_dump *rsp_params;
@@ -1082,11 +1002,8 @@ int dpsw_fdb_dump(struct fsl_mc_io *mc_io,
  *
  * Return:	Completion status. '0' on Success; Error code otherwise.
  */
-int dpsw_fdb_remove_unicast(struct fsl_mc_io *mc_io,
-			    u32 cmd_flags,
-			    u16 token,
-			    u16 fdb_id,
-			    const struct dpsw_fdb_unicast_cfg *cfg)
+int dpsw_fdb_remove_unicast(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			    u16 fdb_id, const struct dpsw_fdb_unicast_cfg *cfg)
 {
 	struct fsl_mc_command cmd = { 0 };
 	struct dpsw_cmd_fdb_unicast_op *cmd_params;
@@ -1124,11 +1041,8 @@ int dpsw_fdb_remove_unicast(struct fsl_mc_io *mc_io,
  *
  * Return:	Completion status. '0' on Success; Error code otherwise.
  */
-int dpsw_fdb_add_multicast(struct fsl_mc_io *mc_io,
-			   u32 cmd_flags,
-			   u16 token,
-			   u16 fdb_id,
-			   const struct dpsw_fdb_multicast_cfg *cfg)
+int dpsw_fdb_add_multicast(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			   u16 fdb_id, const struct dpsw_fdb_multicast_cfg *cfg)
 {
 	struct fsl_mc_command cmd = { 0 };
 	struct dpsw_cmd_fdb_multicast_op *cmd_params;
@@ -1166,11 +1080,8 @@ int dpsw_fdb_add_multicast(struct fsl_mc_io *mc_io,
  *
  * Return:	Completion status. '0' on Success; Error code otherwise.
  */
-int dpsw_fdb_remove_multicast(struct fsl_mc_io *mc_io,
-			      u32 cmd_flags,
-			      u16 token,
-			      u16 fdb_id,
-			      const struct dpsw_fdb_multicast_cfg *cfg)
+int dpsw_fdb_remove_multicast(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			      u16 fdb_id, const struct dpsw_fdb_multicast_cfg *cfg)
 {
 	struct fsl_mc_command cmd = { 0 };
 	struct dpsw_cmd_fdb_multicast_op *cmd_params;
@@ -1296,10 +1207,8 @@ int dpsw_ctrl_if_set_queue(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
  *
  * Return:  '0' on Success; Error code otherwise.
  */
-int dpsw_get_api_version(struct fsl_mc_io *mc_io,
-			 u32 cmd_flags,
-			 u16 *major_ver,
-			 u16 *minor_ver)
+int dpsw_get_api_version(struct fsl_mc_io *mc_io, u32 cmd_flags,
+			 u16 *major_ver, u16 *minor_ver)
 {
 	struct fsl_mc_command cmd = { 0 };
 	struct dpsw_rsp_get_api_version *rsp_params;
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpsw.h b/drivers/net/ethernet/freescale/dpaa2/dpsw.h
index 6807b15f5807..f108cc61bb27 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpsw.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpsw.h
@@ -20,14 +20,9 @@ struct fsl_mc_io;
 
 #define DPSW_MAX_IF		64
 
-int dpsw_open(struct fsl_mc_io *mc_io,
-	      u32 cmd_flags,
-	      int dpsw_id,
-	      u16 *token);
+int dpsw_open(struct fsl_mc_io *mc_io, u32 cmd_flags, int dpsw_id, u16 *token);
 
-int dpsw_close(struct fsl_mc_io *mc_io,
-	       u32 cmd_flags,
-	       u16 token);
+int dpsw_close(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token);
 
 /* DPSW options */
 
@@ -87,17 +82,11 @@ enum dpsw_broadcast_cfg {
 	DPSW_BROADCAST_PER_FDB,
 };
 
-int dpsw_enable(struct fsl_mc_io *mc_io,
-		u32 cmd_flags,
-		u16 token);
+int dpsw_enable(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token);
 
-int dpsw_disable(struct fsl_mc_io *mc_io,
-		 u32 cmd_flags,
-		 u16 token);
+int dpsw_disable(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token);
 
-int dpsw_reset(struct fsl_mc_io *mc_io,
-	       u32 cmd_flags,
-	       u16 token);
+int dpsw_reset(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token);
 
 /* DPSW IRQ Index and Events */
 
@@ -121,29 +110,17 @@ struct dpsw_irq_cfg {
 	int irq_num;
 };
 
-int dpsw_set_irq_enable(struct fsl_mc_io *mc_io,
-			u32 cmd_flags,
-			u16 token,
-			u8 irq_index,
-			u8 en);
-
-int dpsw_set_irq_mask(struct fsl_mc_io *mc_io,
-		      u32 cmd_flags,
-		      u16 token,
-		      u8 irq_index,
-		      u32 mask);
-
-int dpsw_get_irq_status(struct fsl_mc_io *mc_io,
-			u32 cmd_flags,
-			u16 token,
-			u8 irq_index,
-			u32 *status);
-
-int dpsw_clear_irq_status(struct fsl_mc_io *mc_io,
-			  u32 cmd_flags,
-			  u16 token,
-			  u8 irq_index,
-			  u32 status);
+int dpsw_set_irq_enable(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			u8 irq_index, u8 en);
+
+int dpsw_set_irq_mask(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+		      u8 irq_index, u32 mask);
+
+int dpsw_get_irq_status(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			u8 irq_index, u32 *status);
+
+int dpsw_clear_irq_status(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			  u8 irq_index, u32 status);
 
 /**
  * struct dpsw_attr - Structure representing DPSW attributes
@@ -184,9 +161,7 @@ struct dpsw_attr {
 	enum dpsw_broadcast_cfg broadcast_cfg;
 };
 
-int dpsw_get_attributes(struct fsl_mc_io *mc_io,
-			u32 cmd_flags,
-			u16 token,
+int dpsw_get_attributes(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
 			struct dpsw_attr *attr);
 
 /**
@@ -286,11 +261,9 @@ struct dpsw_link_cfg {
 	u64 options;
 };
 
-int dpsw_if_set_link_cfg(struct fsl_mc_io *mc_io,
-			 u32 cmd_flags,
-			 u16 token,
-			 u16 if_id,
+int dpsw_if_set_link_cfg(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token, u16 if_id,
 			 struct dpsw_link_cfg *cfg);
+
 /**
  * struct dpsw_link_state - Structure representing DPSW link state
  * @rate: Rate
@@ -303,11 +276,8 @@ struct dpsw_link_state {
 	u8 up;
 };
 
-int dpsw_if_get_link_state(struct fsl_mc_io *mc_io,
-			   u32 cmd_flags,
-			   u16 token,
-			   u16 if_id,
-			   struct dpsw_link_state *state);
+int dpsw_if_get_link_state(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			   u16 if_id, struct dpsw_link_state *state);
 
 /**
  * struct dpsw_tci_cfg - Tag Control Information (TCI) configuration
@@ -328,16 +298,10 @@ struct dpsw_tci_cfg {
 	u16 vlan_id;
 };
 
-int dpsw_if_set_tci(struct fsl_mc_io *mc_io,
-		    u32 cmd_flags,
-		    u16 token,
-		    u16 if_id,
+int dpsw_if_set_tci(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token, u16 if_id,
 		    const struct dpsw_tci_cfg *cfg);
 
-int dpsw_if_get_tci(struct fsl_mc_io *mc_io,
-		    u32 cmd_flags,
-		    u16 token,
-		    u16 if_id,
+int dpsw_if_get_tci(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token, u16 if_id,
 		    struct dpsw_tci_cfg *cfg);
 
 /**
@@ -367,10 +331,7 @@ struct dpsw_stp_cfg {
 	enum dpsw_stp_state state;
 };
 
-int dpsw_if_set_stp(struct fsl_mc_io *mc_io,
-		    u32 cmd_flags,
-		    u16 token,
-		    u16 if_id,
+int dpsw_if_set_stp(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token, u16 if_id,
 		    const struct dpsw_stp_cfg *cfg);
 
 /**
@@ -418,22 +379,12 @@ enum dpsw_counter {
 	DPSW_CNT_ING_NO_BUFF_DISCARD = 0xc,
 };
 
-int dpsw_if_get_counter(struct fsl_mc_io *mc_io,
-			u32 cmd_flags,
-			u16 token,
-			u16 if_id,
-			enum dpsw_counter type,
-			u64 *counter);
+int dpsw_if_get_counter(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			u16 if_id, enum dpsw_counter type, u64 *counter);
 
-int dpsw_if_enable(struct fsl_mc_io *mc_io,
-		   u32 cmd_flags,
-		   u16 token,
-		   u16 if_id);
+int dpsw_if_enable(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token, u16 if_id);
 
-int dpsw_if_disable(struct fsl_mc_io *mc_io,
-		    u32 cmd_flags,
-		    u16 token,
-		    u16 if_id);
+int dpsw_if_disable(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token, u16 if_id);
 
 /**
  * struct dpsw_if_attr - Structure representing DPSW interface attributes
@@ -463,11 +414,8 @@ struct dpsw_if_attr {
 int dpsw_if_get_attributes(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
 			   u16 if_id, struct dpsw_if_attr *attr);
 
-int dpsw_if_set_max_frame_length(struct fsl_mc_io *mc_io,
-				 u32 cmd_flags,
-				 u16 token,
-				 u16 if_id,
-				 u16 frame_length);
+int dpsw_if_set_max_frame_length(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+				 u16 if_id, u16 frame_length);
 
 /**
  * struct dpsw_vlan_cfg - VLAN Configuration
@@ -477,11 +425,8 @@ struct dpsw_vlan_cfg {
 	u16 fdb_id;
 };
 
-int dpsw_vlan_add(struct fsl_mc_io *mc_io,
-		  u32 cmd_flags,
-		  u16 token,
-		  u16 vlan_id,
-		  const struct dpsw_vlan_cfg *cfg);
+int dpsw_vlan_add(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+		  u16 vlan_id, const struct dpsw_vlan_cfg *cfg);
 
 #define DPSW_VLAN_ADD_IF_OPT_FDB_ID            0x0001
 
@@ -503,33 +448,19 @@ struct dpsw_vlan_if_cfg {
 	u16 fdb_id;
 };
 
-int dpsw_vlan_add_if(struct fsl_mc_io *mc_io,
-		     u32 cmd_flags,
-		     u16 token,
-		     u16 vlan_id,
-		     const struct dpsw_vlan_if_cfg *cfg);
-
-int dpsw_vlan_add_if_untagged(struct fsl_mc_io *mc_io,
-			      u32 cmd_flags,
-			      u16 token,
-			      u16 vlan_id,
-			      const struct dpsw_vlan_if_cfg *cfg);
-
-int dpsw_vlan_remove_if(struct fsl_mc_io *mc_io,
-			u32 cmd_flags,
-			u16 token,
-			u16 vlan_id,
-			const struct dpsw_vlan_if_cfg *cfg);
-
-int dpsw_vlan_remove_if_untagged(struct fsl_mc_io *mc_io,
-				 u32 cmd_flags,
-				 u16 token,
-				 u16 vlan_id,
-				 const struct dpsw_vlan_if_cfg *cfg);
-
-int dpsw_vlan_remove(struct fsl_mc_io *mc_io,
-		     u32 cmd_flags,
-		     u16 token,
+int dpsw_vlan_add_if(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+		     u16 vlan_id, const struct dpsw_vlan_if_cfg *cfg);
+
+int dpsw_vlan_add_if_untagged(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			      u16 vlan_id, const struct dpsw_vlan_if_cfg *cfg);
+
+int dpsw_vlan_remove_if(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			u16 vlan_id, const struct dpsw_vlan_if_cfg *cfg);
+
+int dpsw_vlan_remove_if_untagged(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+				 u16 vlan_id, const struct dpsw_vlan_if_cfg *cfg);
+
+int dpsw_vlan_remove(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
 		     u16 vlan_id);
 
 /**
@@ -554,17 +485,11 @@ struct dpsw_fdb_unicast_cfg {
 	u16 if_egress;
 };
 
-int dpsw_fdb_add_unicast(struct fsl_mc_io *mc_io,
-			 u32 cmd_flags,
-			 u16 token,
-			 u16 fdb_id,
-			 const struct dpsw_fdb_unicast_cfg *cfg);
+int dpsw_fdb_add_unicast(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			 u16 fdb_id, const struct dpsw_fdb_unicast_cfg *cfg);
 
-int dpsw_fdb_remove_unicast(struct fsl_mc_io *mc_io,
-			    u32 cmd_flags,
-			    u16 token,
-			    u16 fdb_id,
-			    const struct dpsw_fdb_unicast_cfg *cfg);
+int dpsw_fdb_remove_unicast(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			    u16 fdb_id, const struct dpsw_fdb_unicast_cfg *cfg);
 
 #define DPSW_FDB_ENTRY_TYPE_DYNAMIC  BIT(0)
 #define DPSW_FDB_ENTRY_TYPE_UNICAST  BIT(1)
@@ -583,13 +508,8 @@ struct fdb_dump_entry {
 	u8 if_mask[8];
 };
 
-int dpsw_fdb_dump(struct fsl_mc_io *mc_io,
-		  u32 cmd_flags,
-		  u16 token,
-		  u16 fdb_id,
-		  u64 iova_addr,
-		  u32 iova_size,
-		  u16 *num_entries);
+int dpsw_fdb_dump(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token, u16 fdb_id,
+		  u64 iova_addr, u32 iova_size, u16 *num_entries);
 
 /**
  * struct dpsw_fdb_multicast_cfg - Multi-cast entry configuration
@@ -605,17 +525,11 @@ struct dpsw_fdb_multicast_cfg {
 	u16 if_id[DPSW_MAX_IF];
 };
 
-int dpsw_fdb_add_multicast(struct fsl_mc_io *mc_io,
-			   u32 cmd_flags,
-			   u16 token,
-			   u16 fdb_id,
-			   const struct dpsw_fdb_multicast_cfg *cfg);
+int dpsw_fdb_add_multicast(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			   u16 fdb_id, const struct dpsw_fdb_multicast_cfg *cfg);
 
-int dpsw_fdb_remove_multicast(struct fsl_mc_io *mc_io,
-			      u32 cmd_flags,
-			      u16 token,
-			      u16 fdb_id,
-			      const struct dpsw_fdb_multicast_cfg *cfg);
+int dpsw_fdb_remove_multicast(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			      u16 fdb_id, const struct dpsw_fdb_multicast_cfg *cfg);
 
 /**
  * enum dpsw_fdb_learning_mode - Auto-learning modes
@@ -670,10 +584,8 @@ struct dpsw_fdb_attr {
 	u16 max_fdb_mc_groups;
 };
 
-int dpsw_get_api_version(struct fsl_mc_io *mc_io,
-			 u32 cmd_flags,
-			 u16 *major_ver,
-			 u16 *minor_ver);
+int dpsw_get_api_version(struct fsl_mc_io *mc_io, u32 cmd_flags,
+			 u16 *major_ver, u16 *minor_ver);
 
 int dpsw_if_get_port_mac_addr(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
 			      u16 if_id, u8 mac_addr[6]);
-- 
2.30.0

