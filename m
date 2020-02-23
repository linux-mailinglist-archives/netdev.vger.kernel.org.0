Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E04EE16969F
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 08:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbgBWHby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 02:31:54 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34648 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgBWHbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 02:31:52 -0500
Received: by mail-wm1-f67.google.com with SMTP id s144so8334099wme.1
        for <netdev@vger.kernel.org>; Sat, 22 Feb 2020 23:31:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0/eIAQnep/cBCkQsz+EkI/3vfMg6HFJN3+XbfVu9oGg=;
        b=SVRRcnNYiXmBhAgv0YuygyQF/dfbE1oBN1jBAJCSMRi/QGS/HO2SkZJjOysVkxFplt
         NmNjERg/H/lPe/1byn8hP0LWznZBhX7ZB9SAZLT7VEai7Cyd0utVWxnorw9UTC9sJOyN
         +mr9qLVrKcmZvy6OhhQAek9fSX3TnyIKxGCaicPHjfivFaOmAu+ZBaykCeCMcOSHHM3q
         zfFwoxitS2YHqy2ydX598Z8j9Q1MLuotc8Gm5fNYDj3CJ7l4pLsRNkbfshwrCt60GHHY
         K5XIgbwwAevYOKob1R7zJSKK0FoEhzx5M1bdx968SF3eGPqUBflSasL2YTcDmXOhGodX
         f8IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0/eIAQnep/cBCkQsz+EkI/3vfMg6HFJN3+XbfVu9oGg=;
        b=QfdLRMDhSAn2u2vPOP1wqdDFUAh241tpSAiKlnAmYkFK/nWoR+txwYJfdjGvQrSloL
         cgVYrUE3/dpmbW82CENDrfLRQrnlOqEat0Thj6phnDDL4JVHLOgZUcOFFeAcgXh4iJBC
         B5bKEl9VXVVx9Gm9gBofb/7xchJg8HYo44yDo6X7258lS/VSSmCCkB7qafIxHLURrQpA
         zHl8ALY4vBXbM/1rJaI3G9QnUtpkYxT5F2iu6vUkdmORBCVECNQONKxwkTT8y2Qj8JcP
         8X4OwcMaYSlShhkuv1+TNTB5v2wNCyZIryWcqv6kay+KcAazt+eXyrbOXVnVHzV+X1GZ
         BqyA==
X-Gm-Message-State: APjAAAUqT1HqJjnznnAKQI4kmb3qrR4S20sIWehLj+6eLL0Y0hu4UH1z
        nX4Ql4zpK4YsSkxV/Yc/aVaLJHaP7u4=
X-Google-Smtp-Source: APXvYqwTvx+Ldv/6iKTSMDOBkcJtobszKywCmgRJ2iMrwA7Y14E7pH+m+PmebttXe3OQ+SoQ/oh3nA==
X-Received: by 2002:a1c:6a15:: with SMTP id f21mr14268189wmc.126.1582443109332;
        Sat, 22 Feb 2020 23:31:49 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id h128sm11692927wmh.33.2020.02.22.23.31.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Feb 2020 23:31:48 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 03/12] mlxsw: core_acl_flex_actions: Rename Trap / Discard Action to Trap Action
Date:   Sun, 23 Feb 2020 08:31:35 +0100
Message-Id: <20200223073144.28529-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200223073144.28529-1-jiri@resnulli.us>
References: <20200223073144.28529-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

The Trap / Discard Action action got renamed in PRM, so rename it in the
code as well.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../mellanox/mlxsw/core_acl_flex_actions.c    | 103 +++++++++---------
 1 file changed, 49 insertions(+), 54 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
index c51b2adfc1e1..b9e2193848dd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
@@ -747,97 +747,94 @@ int mlxsw_afa_block_append_vlan_modify(struct mlxsw_afa_block *block,
 }
 EXPORT_SYMBOL(mlxsw_afa_block_append_vlan_modify);
 
-/* Trap / Discard Action
- * ---------------------
- * The Trap / Discard action enables trapping / mirroring packets to the CPU
+/* Trap Action
+ * -----------
+ * The Trap action enables trapping / mirroring packets to the CPU
  * as well as discarding packets.
  * The ACL Trap / Discard separates the forward/discard control from CPU
  * trap control. In addition, the Trap / Discard action enables activating
  * SPAN (port mirroring).
  */
 
-#define MLXSW_AFA_TRAPDISC_CODE 0x03
-#define MLXSW_AFA_TRAPDISC_SIZE 1
+#define MLXSW_AFA_TRAP_CODE 0x03
+#define MLXSW_AFA_TRAP_SIZE 1
 
-enum mlxsw_afa_trapdisc_trap_action {
-	MLXSW_AFA_TRAPDISC_TRAP_ACTION_NOP = 0,
-	MLXSW_AFA_TRAPDISC_TRAP_ACTION_TRAP = 2,
+enum mlxsw_afa_trap_trap_action {
+	MLXSW_AFA_TRAP_TRAP_ACTION_NOP = 0,
+	MLXSW_AFA_TRAP_TRAP_ACTION_TRAP = 2,
 };
 
-/* afa_trapdisc_trap_action
+/* afa_trap_trap_action
  * Trap Action.
  */
-MLXSW_ITEM32(afa, trapdisc, trap_action, 0x00, 24, 4);
+MLXSW_ITEM32(afa, trap, trap_action, 0x00, 24, 4);
 
-enum mlxsw_afa_trapdisc_forward_action {
-	MLXSW_AFA_TRAPDISC_FORWARD_ACTION_FORWARD = 1,
-	MLXSW_AFA_TRAPDISC_FORWARD_ACTION_DISCARD = 3,
+enum mlxsw_afa_trap_forward_action {
+	MLXSW_AFA_TRAP_FORWARD_ACTION_FORWARD = 1,
+	MLXSW_AFA_TRAP_FORWARD_ACTION_DISCARD = 3,
 };
 
-/* afa_trapdisc_forward_action
+/* afa_trap_forward_action
  * Forward Action.
  */
-MLXSW_ITEM32(afa, trapdisc, forward_action, 0x00, 0, 4);
+MLXSW_ITEM32(afa, trap, forward_action, 0x00, 0, 4);
 
-/* afa_trapdisc_trap_id
+/* afa_trap_trap_id
  * Trap ID to configure.
  */
-MLXSW_ITEM32(afa, trapdisc, trap_id, 0x04, 0, 9);
+MLXSW_ITEM32(afa, trap, trap_id, 0x04, 0, 9);
 
-/* afa_trapdisc_mirror_agent
+/* afa_trap_mirror_agent
  * Mirror agent.
  */
-MLXSW_ITEM32(afa, trapdisc, mirror_agent, 0x08, 29, 3);
+MLXSW_ITEM32(afa, trap, mirror_agent, 0x08, 29, 3);
 
-/* afa_trapdisc_mirror_enable
+/* afa_trap_mirror_enable
  * Mirror enable.
  */
-MLXSW_ITEM32(afa, trapdisc, mirror_enable, 0x08, 24, 1);
+MLXSW_ITEM32(afa, trap, mirror_enable, 0x08, 24, 1);
 
 static inline void
-mlxsw_afa_trapdisc_pack(char *payload,
-			enum mlxsw_afa_trapdisc_trap_action trap_action,
-			enum mlxsw_afa_trapdisc_forward_action forward_action,
-			u16 trap_id)
+mlxsw_afa_trap_pack(char *payload,
+		    enum mlxsw_afa_trap_trap_action trap_action,
+		    enum mlxsw_afa_trap_forward_action forward_action,
+		    u16 trap_id)
 {
-	mlxsw_afa_trapdisc_trap_action_set(payload, trap_action);
-	mlxsw_afa_trapdisc_forward_action_set(payload, forward_action);
-	mlxsw_afa_trapdisc_trap_id_set(payload, trap_id);
+	mlxsw_afa_trap_trap_action_set(payload, trap_action);
+	mlxsw_afa_trap_forward_action_set(payload, forward_action);
+	mlxsw_afa_trap_trap_id_set(payload, trap_id);
 }
 
 static inline void
-mlxsw_afa_trapdisc_mirror_pack(char *payload, bool mirror_enable,
-			       u8 mirror_agent)
+mlxsw_afa_trap_mirror_pack(char *payload, bool mirror_enable,
+			   u8 mirror_agent)
 {
-	mlxsw_afa_trapdisc_mirror_enable_set(payload, mirror_enable);
-	mlxsw_afa_trapdisc_mirror_agent_set(payload, mirror_agent);
+	mlxsw_afa_trap_mirror_enable_set(payload, mirror_enable);
+	mlxsw_afa_trap_mirror_agent_set(payload, mirror_agent);
 }
 
 int mlxsw_afa_block_append_drop(struct mlxsw_afa_block *block)
 {
-	char *act = mlxsw_afa_block_append_action(block,
-						  MLXSW_AFA_TRAPDISC_CODE,
-						  MLXSW_AFA_TRAPDISC_SIZE);
+	char *act = mlxsw_afa_block_append_action(block, MLXSW_AFA_TRAP_CODE,
+						  MLXSW_AFA_TRAP_SIZE);
 
 	if (IS_ERR(act))
 		return PTR_ERR(act);
-	mlxsw_afa_trapdisc_pack(act, MLXSW_AFA_TRAPDISC_TRAP_ACTION_NOP,
-				MLXSW_AFA_TRAPDISC_FORWARD_ACTION_DISCARD, 0);
+	mlxsw_afa_trap_pack(act, MLXSW_AFA_TRAP_TRAP_ACTION_NOP,
+			    MLXSW_AFA_TRAP_FORWARD_ACTION_DISCARD, 0);
 	return 0;
 }
 EXPORT_SYMBOL(mlxsw_afa_block_append_drop);
 
 int mlxsw_afa_block_append_trap(struct mlxsw_afa_block *block, u16 trap_id)
 {
-	char *act = mlxsw_afa_block_append_action(block,
-						  MLXSW_AFA_TRAPDISC_CODE,
-						  MLXSW_AFA_TRAPDISC_SIZE);
+	char *act = mlxsw_afa_block_append_action(block, MLXSW_AFA_TRAP_CODE,
+						  MLXSW_AFA_TRAP_SIZE);
 
 	if (IS_ERR(act))
 		return PTR_ERR(act);
-	mlxsw_afa_trapdisc_pack(act, MLXSW_AFA_TRAPDISC_TRAP_ACTION_TRAP,
-				MLXSW_AFA_TRAPDISC_FORWARD_ACTION_DISCARD,
-				trap_id);
+	mlxsw_afa_trap_pack(act, MLXSW_AFA_TRAP_TRAP_ACTION_TRAP,
+			    MLXSW_AFA_TRAP_FORWARD_ACTION_DISCARD, trap_id);
 	return 0;
 }
 EXPORT_SYMBOL(mlxsw_afa_block_append_trap);
@@ -845,15 +842,13 @@ EXPORT_SYMBOL(mlxsw_afa_block_append_trap);
 int mlxsw_afa_block_append_trap_and_forward(struct mlxsw_afa_block *block,
 					    u16 trap_id)
 {
-	char *act = mlxsw_afa_block_append_action(block,
-						  MLXSW_AFA_TRAPDISC_CODE,
-						  MLXSW_AFA_TRAPDISC_SIZE);
+	char *act = mlxsw_afa_block_append_action(block, MLXSW_AFA_TRAP_CODE,
+						  MLXSW_AFA_TRAP_SIZE);
 
 	if (IS_ERR(act))
 		return PTR_ERR(act);
-	mlxsw_afa_trapdisc_pack(act, MLXSW_AFA_TRAPDISC_TRAP_ACTION_TRAP,
-				MLXSW_AFA_TRAPDISC_FORWARD_ACTION_FORWARD,
-				trap_id);
+	mlxsw_afa_trap_pack(act, MLXSW_AFA_TRAP_TRAP_ACTION_TRAP,
+			    MLXSW_AFA_TRAP_FORWARD_ACTION_FORWARD, trap_id);
 	return 0;
 }
 EXPORT_SYMBOL(mlxsw_afa_block_append_trap_and_forward);
@@ -920,13 +915,13 @@ mlxsw_afa_block_append_allocated_mirror(struct mlxsw_afa_block *block,
 					u8 mirror_agent)
 {
 	char *act = mlxsw_afa_block_append_action(block,
-						  MLXSW_AFA_TRAPDISC_CODE,
-						  MLXSW_AFA_TRAPDISC_SIZE);
+						  MLXSW_AFA_TRAP_CODE,
+						  MLXSW_AFA_TRAP_SIZE);
 	if (IS_ERR(act))
 		return PTR_ERR(act);
-	mlxsw_afa_trapdisc_pack(act, MLXSW_AFA_TRAPDISC_TRAP_ACTION_NOP,
-				MLXSW_AFA_TRAPDISC_FORWARD_ACTION_FORWARD, 0);
-	mlxsw_afa_trapdisc_mirror_pack(act, true, mirror_agent);
+	mlxsw_afa_trap_pack(act, MLXSW_AFA_TRAP_TRAP_ACTION_NOP,
+			    MLXSW_AFA_TRAP_FORWARD_ACTION_FORWARD, 0);
+	mlxsw_afa_trap_mirror_pack(act, true, mirror_agent);
 	return 0;
 }
 
-- 
2.21.1

