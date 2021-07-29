Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B08D03DA9E2
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 19:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbhG2RSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 13:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231710AbhG2RR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 13:17:56 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E6D0C061765;
        Thu, 29 Jul 2021 10:17:51 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id ec13so8685965edb.0;
        Thu, 29 Jul 2021 10:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+vZfnRq3/EOVTPEF7vG+rr6BfnpzlSRrrC26+zaIlVk=;
        b=mgUOnqPNquhRWKkdHTkB/LA0PF2nH0FdEd8cRxskE6FR+PF8/KHtzv1KgmbwYotBoc
         KEoEtfiELicmIJPZkKiOYl/9qB8RSlNtX5WaNjOxCmgboS5SCd3Mxrbycq2IQDZ/fXvb
         aUe4RiVbADD0Qodzybe3MD6/wCrrYNmpwyYo2COFcprJFk7JNkQnGiDqYw92WPgP5cPJ
         yXUJjkbP0phkiYkOiu5N+Ia2K7/oX2u/pzgMZvWwzB/usJlOlaIDSaN55sFIwzDgMsVR
         BLqbx2NJn/7MaJh5mYH2SWUCrtk/iYevo2QT7AyRfsVcsTC3RirDAGhHADo7BURysmDL
         RrAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+vZfnRq3/EOVTPEF7vG+rr6BfnpzlSRrrC26+zaIlVk=;
        b=iYw/73Y738ufRke3K1t5hbcwSdFal/fIqbEZJzgVLAp/G3f99SQY9U1EozbwD2TSZX
         WqNHen5lnGR5G7HIlqRHA1S33Bg4FLduC8F/D20InrHSI8GdKIXbyahJviSM41GPN2m+
         n3zufQRy1M9BYCl6tn8lGWlGepmTd0Gu1bYhQGgRCkPHAj0vbY+13PcWVebI18k8kzIZ
         cDdL0ypLjcs0ryIJv9mE0siQgsd/x6mkufEBRRdD/tgdEOkWoDvUb999Cr3rNV0VujyG
         oLm+EXmVZrL/QPfMoJtVrn3pt2fuIOyUAiIiKBpDkF6dZ2WPA9WnR6NCOYOYTLvlJjv8
         kjvw==
X-Gm-Message-State: AOAM530LzSiY8NMQv1b+mm93jJ2u9BgMFzxvoeJC/r6966frQ3QjMaew
        2ri5Gf9iD3xTQj+vaS3lGTI=
X-Google-Smtp-Source: ABdhPJzvSJQE4PttKpE6/3MF25WwUCo6uwYSTyoW+493+yTUQMJidgNDUzcCpEOfJ29HABHSGVcngg==
X-Received: by 2002:aa7:d593:: with SMTP id r19mr7102172edq.372.1627579069845;
        Thu, 29 Jul 2021 10:17:49 -0700 (PDT)
Received: from yoga-910.localhost ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id df14sm1451612edb.90.2021.07.29.10.17.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 10:17:49 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     corbet@lwn.net, netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 2/9] dpaa2-switch: rename dpaa2_switch_acl_tbl into filter_block
Date:   Thu, 29 Jul 2021 20:18:54 +0300
Message-Id: <20210729171901.3211729-3-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729171901.3211729-1-ciorneiioana@gmail.com>
References: <20210729171901.3211729-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Until now, shared filter blocks were implemented only by ACL tables
shared between ports. Going forward, when the mirroring support will be
added, this will not be true anymore.

Rename the dpaa2_switch_acl_tbl into dpaa2_switch_filter_block so that
we make it clear that the structure is used not only for filters that
use the ACL table but will be used for all the filters that are added in
a block.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../freescale/dpaa2/dpaa2-switch-flower.c     |  98 ++++++-------
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 129 +++++++++---------
 .../ethernet/freescale/dpaa2/dpaa2-switch.h   |  28 ++--
 3 files changed, 130 insertions(+), 125 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
index 639efb3edeec..80fe09ac9d5f 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
@@ -111,11 +111,11 @@ static int dpaa2_switch_flower_parse_key(struct flow_cls_offload *cls,
 	return 0;
 }
 
-int dpaa2_switch_acl_entry_add(struct dpaa2_switch_acl_tbl *acl_tbl,
+int dpaa2_switch_acl_entry_add(struct dpaa2_switch_filter_block *filter_block,
 			       struct dpaa2_switch_acl_entry *entry)
 {
 	struct dpsw_acl_entry_cfg *acl_entry_cfg = &entry->cfg;
-	struct ethsw_core *ethsw = acl_tbl->ethsw;
+	struct ethsw_core *ethsw = filter_block->ethsw;
 	struct dpsw_acl_key *acl_key = &entry->key;
 	struct device *dev = ethsw->dev;
 	u8 *cmd_buff;
@@ -136,7 +136,7 @@ int dpaa2_switch_acl_entry_add(struct dpaa2_switch_acl_tbl *acl_tbl,
 	}
 
 	err = dpsw_acl_add_entry(ethsw->mc_io, 0, ethsw->dpsw_handle,
-				 acl_tbl->id, acl_entry_cfg);
+				 filter_block->acl_id, acl_entry_cfg);
 
 	dma_unmap_single(dev, acl_entry_cfg->key_iova, sizeof(cmd_buff),
 			 DMA_TO_DEVICE);
@@ -150,12 +150,13 @@ int dpaa2_switch_acl_entry_add(struct dpaa2_switch_acl_tbl *acl_tbl,
 	return 0;
 }
 
-static int dpaa2_switch_acl_entry_remove(struct dpaa2_switch_acl_tbl *acl_tbl,
-					 struct dpaa2_switch_acl_entry *entry)
+static int
+dpaa2_switch_acl_entry_remove(struct dpaa2_switch_filter_block *block,
+			      struct dpaa2_switch_acl_entry *entry)
 {
 	struct dpsw_acl_entry_cfg *acl_entry_cfg = &entry->cfg;
 	struct dpsw_acl_key *acl_key = &entry->key;
-	struct ethsw_core *ethsw = acl_tbl->ethsw;
+	struct ethsw_core *ethsw = block->ethsw;
 	struct device *dev = ethsw->dev;
 	u8 *cmd_buff;
 	int err;
@@ -175,7 +176,7 @@ static int dpaa2_switch_acl_entry_remove(struct dpaa2_switch_acl_tbl *acl_tbl,
 	}
 
 	err = dpsw_acl_remove_entry(ethsw->mc_io, 0, ethsw->dpsw_handle,
-				    acl_tbl->id, acl_entry_cfg);
+				    block->acl_id, acl_entry_cfg);
 
 	dma_unmap_single(dev, acl_entry_cfg->key_iova, sizeof(cmd_buff),
 			 DMA_TO_DEVICE);
@@ -190,19 +191,19 @@ static int dpaa2_switch_acl_entry_remove(struct dpaa2_switch_acl_tbl *acl_tbl,
 }
 
 static int
-dpaa2_switch_acl_entry_add_to_list(struct dpaa2_switch_acl_tbl *acl_tbl,
+dpaa2_switch_acl_entry_add_to_list(struct dpaa2_switch_filter_block *block,
 				   struct dpaa2_switch_acl_entry *entry)
 {
 	struct dpaa2_switch_acl_entry *tmp;
 	struct list_head *pos, *n;
 	int index = 0;
 
-	if (list_empty(&acl_tbl->entries)) {
-		list_add(&entry->list, &acl_tbl->entries);
+	if (list_empty(&block->acl_entries)) {
+		list_add(&entry->list, &block->acl_entries);
 		return index;
 	}
 
-	list_for_each_safe(pos, n, &acl_tbl->entries) {
+	list_for_each_safe(pos, n, &block->acl_entries) {
 		tmp = list_entry(pos, struct dpaa2_switch_acl_entry, list);
 		if (entry->prio < tmp->prio)
 			break;
@@ -213,13 +214,13 @@ dpaa2_switch_acl_entry_add_to_list(struct dpaa2_switch_acl_tbl *acl_tbl,
 }
 
 static struct dpaa2_switch_acl_entry*
-dpaa2_switch_acl_entry_get_by_index(struct dpaa2_switch_acl_tbl *acl_tbl,
+dpaa2_switch_acl_entry_get_by_index(struct dpaa2_switch_filter_block *block,
 				    int index)
 {
 	struct dpaa2_switch_acl_entry *tmp;
 	int i = 0;
 
-	list_for_each_entry(tmp, &acl_tbl->entries, list) {
+	list_for_each_entry(tmp, &block->acl_entries, list) {
 		if (i == index)
 			return tmp;
 		++i;
@@ -229,37 +230,38 @@ dpaa2_switch_acl_entry_get_by_index(struct dpaa2_switch_acl_tbl *acl_tbl,
 }
 
 static int
-dpaa2_switch_acl_entry_set_precedence(struct dpaa2_switch_acl_tbl *acl_tbl,
+dpaa2_switch_acl_entry_set_precedence(struct dpaa2_switch_filter_block *block,
 				      struct dpaa2_switch_acl_entry *entry,
 				      int precedence)
 {
 	int err;
 
-	err = dpaa2_switch_acl_entry_remove(acl_tbl, entry);
+	err = dpaa2_switch_acl_entry_remove(block, entry);
 	if (err)
 		return err;
 
 	entry->cfg.precedence = precedence;
-	return dpaa2_switch_acl_entry_add(acl_tbl, entry);
+	return dpaa2_switch_acl_entry_add(block, entry);
 }
 
-static int dpaa2_switch_acl_tbl_add_entry(struct dpaa2_switch_acl_tbl *acl_tbl,
-					  struct dpaa2_switch_acl_entry *entry)
+static int
+dpaa2_switch_acl_tbl_add_entry(struct dpaa2_switch_filter_block *block,
+			       struct dpaa2_switch_acl_entry *entry)
 {
 	struct dpaa2_switch_acl_entry *tmp;
 	int index, i, precedence, err;
 
 	/* Add the new ACL entry to the linked list and get its index */
-	index = dpaa2_switch_acl_entry_add_to_list(acl_tbl, entry);
+	index = dpaa2_switch_acl_entry_add_to_list(block, entry);
 
 	/* Move up in priority the ACL entries to make space
 	 * for the new filter.
 	 */
-	precedence = DPAA2_ETHSW_PORT_MAX_ACL_ENTRIES - acl_tbl->num_rules - 1;
+	precedence = DPAA2_ETHSW_PORT_MAX_ACL_ENTRIES - block->num_acl_rules - 1;
 	for (i = 0; i < index; i++) {
-		tmp = dpaa2_switch_acl_entry_get_by_index(acl_tbl, i);
+		tmp = dpaa2_switch_acl_entry_get_by_index(block, i);
 
-		err = dpaa2_switch_acl_entry_set_precedence(acl_tbl, tmp,
+		err = dpaa2_switch_acl_entry_set_precedence(block, tmp,
 							    precedence);
 		if (err)
 			return err;
@@ -269,19 +271,19 @@ static int dpaa2_switch_acl_tbl_add_entry(struct dpaa2_switch_acl_tbl *acl_tbl,
 
 	/* Add the new entry to hardware */
 	entry->cfg.precedence = precedence;
-	err = dpaa2_switch_acl_entry_add(acl_tbl, entry);
-	acl_tbl->num_rules++;
+	err = dpaa2_switch_acl_entry_add(block, entry);
+	block->num_acl_rules++;
 
 	return err;
 }
 
 static struct dpaa2_switch_acl_entry *
-dpaa2_switch_acl_tbl_find_entry_by_cookie(struct dpaa2_switch_acl_tbl *acl_tbl,
+dpaa2_switch_acl_tbl_find_entry_by_cookie(struct dpaa2_switch_filter_block *block,
 					  unsigned long cookie)
 {
 	struct dpaa2_switch_acl_entry *tmp, *n;
 
-	list_for_each_entry_safe(tmp, n, &acl_tbl->entries, list) {
+	list_for_each_entry_safe(tmp, n, &block->acl_entries, list) {
 		if (tmp->cookie == cookie)
 			return tmp;
 	}
@@ -289,13 +291,13 @@ dpaa2_switch_acl_tbl_find_entry_by_cookie(struct dpaa2_switch_acl_tbl *acl_tbl,
 }
 
 static int
-dpaa2_switch_acl_entry_get_index(struct dpaa2_switch_acl_tbl *acl_tbl,
+dpaa2_switch_acl_entry_get_index(struct dpaa2_switch_filter_block *block,
 				 struct dpaa2_switch_acl_entry *entry)
 {
 	struct dpaa2_switch_acl_entry *tmp, *n;
 	int index = 0;
 
-	list_for_each_entry_safe(tmp, n, &acl_tbl->entries, list) {
+	list_for_each_entry_safe(tmp, n, &block->acl_entries, list) {
 		if (tmp->cookie == entry->cookie)
 			return index;
 		index++;
@@ -304,20 +306,20 @@ dpaa2_switch_acl_entry_get_index(struct dpaa2_switch_acl_tbl *acl_tbl,
 }
 
 static int
-dpaa2_switch_acl_tbl_remove_entry(struct dpaa2_switch_acl_tbl *acl_tbl,
+dpaa2_switch_acl_tbl_remove_entry(struct dpaa2_switch_filter_block *block,
 				  struct dpaa2_switch_acl_entry *entry)
 {
 	struct dpaa2_switch_acl_entry *tmp;
 	int index, i, precedence, err;
 
-	index = dpaa2_switch_acl_entry_get_index(acl_tbl, entry);
+	index = dpaa2_switch_acl_entry_get_index(block, entry);
 
 	/* Remove from hardware the ACL entry */
-	err = dpaa2_switch_acl_entry_remove(acl_tbl, entry);
+	err = dpaa2_switch_acl_entry_remove(block, entry);
 	if (err)
 		return err;
 
-	acl_tbl->num_rules--;
+	block->num_acl_rules--;
 
 	/* Remove it from the list also */
 	list_del(&entry->list);
@@ -325,8 +327,8 @@ dpaa2_switch_acl_tbl_remove_entry(struct dpaa2_switch_acl_tbl *acl_tbl,
 	/* Move down in priority the entries over the deleted one */
 	precedence = entry->cfg.precedence;
 	for (i = index - 1; i >= 0; i--) {
-		tmp = dpaa2_switch_acl_entry_get_by_index(acl_tbl, i);
-		err = dpaa2_switch_acl_entry_set_precedence(acl_tbl, tmp,
+		tmp = dpaa2_switch_acl_entry_get_by_index(block, i);
+		err = dpaa2_switch_acl_entry_set_precedence(block, tmp,
 							    precedence);
 		if (err)
 			return err;
@@ -374,13 +376,13 @@ static int dpaa2_switch_tc_parse_action_acl(struct ethsw_core *ethsw,
 	return err;
 }
 
-int dpaa2_switch_cls_flower_replace(struct dpaa2_switch_acl_tbl *acl_tbl,
+int dpaa2_switch_cls_flower_replace(struct dpaa2_switch_filter_block *block,
 				    struct flow_cls_offload *cls)
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
 	struct netlink_ext_ack *extack = cls->common.extack;
-	struct ethsw_core *ethsw = acl_tbl->ethsw;
 	struct dpaa2_switch_acl_entry *acl_entry;
+	struct ethsw_core *ethsw = block->ethsw;
 	struct flow_action_entry *act;
 	int err;
 
@@ -389,7 +391,7 @@ int dpaa2_switch_cls_flower_replace(struct dpaa2_switch_acl_tbl *acl_tbl,
 		return -EOPNOTSUPP;
 	}
 
-	if (dpaa2_switch_acl_tbl_is_full(acl_tbl)) {
+	if (dpaa2_switch_acl_tbl_is_full(block)) {
 		NL_SET_ERR_MSG(extack, "Maximum filter capacity reached");
 		return -ENOMEM;
 	}
@@ -411,7 +413,7 @@ int dpaa2_switch_cls_flower_replace(struct dpaa2_switch_acl_tbl *acl_tbl,
 	acl_entry->prio = cls->common.prio;
 	acl_entry->cookie = cls->cookie;
 
-	err = dpaa2_switch_acl_tbl_add_entry(acl_tbl, acl_entry);
+	err = dpaa2_switch_acl_tbl_add_entry(block, acl_entry);
 	if (err)
 		goto free_acl_entry;
 
@@ -423,23 +425,23 @@ int dpaa2_switch_cls_flower_replace(struct dpaa2_switch_acl_tbl *acl_tbl,
 	return err;
 }
 
-int dpaa2_switch_cls_flower_destroy(struct dpaa2_switch_acl_tbl *acl_tbl,
+int dpaa2_switch_cls_flower_destroy(struct dpaa2_switch_filter_block *block,
 				    struct flow_cls_offload *cls)
 {
 	struct dpaa2_switch_acl_entry *entry;
 
-	entry = dpaa2_switch_acl_tbl_find_entry_by_cookie(acl_tbl, cls->cookie);
+	entry = dpaa2_switch_acl_tbl_find_entry_by_cookie(block, cls->cookie);
 	if (!entry)
 		return 0;
 
-	return dpaa2_switch_acl_tbl_remove_entry(acl_tbl, entry);
+	return dpaa2_switch_acl_tbl_remove_entry(block, entry);
 }
 
-int dpaa2_switch_cls_matchall_replace(struct dpaa2_switch_acl_tbl *acl_tbl,
+int dpaa2_switch_cls_matchall_replace(struct dpaa2_switch_filter_block *block,
 				      struct tc_cls_matchall_offload *cls)
 {
 	struct netlink_ext_ack *extack = cls->common.extack;
-	struct ethsw_core *ethsw = acl_tbl->ethsw;
+	struct ethsw_core *ethsw = block->ethsw;
 	struct dpaa2_switch_acl_entry *acl_entry;
 	struct flow_action_entry *act;
 	int err;
@@ -449,7 +451,7 @@ int dpaa2_switch_cls_matchall_replace(struct dpaa2_switch_acl_tbl *acl_tbl,
 		return -EOPNOTSUPP;
 	}
 
-	if (dpaa2_switch_acl_tbl_is_full(acl_tbl)) {
+	if (dpaa2_switch_acl_tbl_is_full(block)) {
 		NL_SET_ERR_MSG(extack, "Maximum filter capacity reached");
 		return -ENOMEM;
 	}
@@ -467,7 +469,7 @@ int dpaa2_switch_cls_matchall_replace(struct dpaa2_switch_acl_tbl *acl_tbl,
 	acl_entry->prio = cls->common.prio;
 	acl_entry->cookie = cls->cookie;
 
-	err = dpaa2_switch_acl_tbl_add_entry(acl_tbl, acl_entry);
+	err = dpaa2_switch_acl_tbl_add_entry(block, acl_entry);
 	if (err)
 		goto free_acl_entry;
 
@@ -479,14 +481,14 @@ int dpaa2_switch_cls_matchall_replace(struct dpaa2_switch_acl_tbl *acl_tbl,
 	return err;
 }
 
-int dpaa2_switch_cls_matchall_destroy(struct dpaa2_switch_acl_tbl *acl_tbl,
+int dpaa2_switch_cls_matchall_destroy(struct dpaa2_switch_filter_block *block,
 				      struct tc_cls_matchall_offload *cls)
 {
 	struct dpaa2_switch_acl_entry *entry;
 
-	entry = dpaa2_switch_acl_tbl_find_entry_by_cookie(acl_tbl, cls->cookie);
+	entry = dpaa2_switch_acl_tbl_find_entry_by_cookie(block, cls->cookie);
 	if (!entry)
 		return 0;
 
-	return  dpaa2_switch_acl_tbl_remove_entry(acl_tbl, entry);
+	return  dpaa2_switch_acl_tbl_remove_entry(block, entry);
 }
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index c233e8786e19..1806012f41d2 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -41,14 +41,14 @@ static struct dpaa2_switch_fdb *dpaa2_switch_fdb_get_unused(struct ethsw_core *e
 	return NULL;
 }
 
-static struct dpaa2_switch_acl_tbl *
-dpaa2_switch_acl_tbl_get_unused(struct ethsw_core *ethsw)
+static struct dpaa2_switch_filter_block *
+dpaa2_switch_filter_block_get_unused(struct ethsw_core *ethsw)
 {
 	int i;
 
 	for (i = 0; i < ethsw->sw_attr.num_ifs; i++)
-		if (!ethsw->acls[i].in_use)
-			return &ethsw->acls[i];
+		if (!ethsw->filter_blocks[i].in_use)
+			return &ethsw->filter_blocks[i];
 	return NULL;
 }
 
@@ -1127,28 +1127,28 @@ static netdev_tx_t dpaa2_switch_port_tx(struct sk_buff *skb,
 }
 
 static int
-dpaa2_switch_setup_tc_cls_flower(struct dpaa2_switch_acl_tbl *acl_tbl,
+dpaa2_switch_setup_tc_cls_flower(struct dpaa2_switch_filter_block *filter_block,
 				 struct flow_cls_offload *f)
 {
 	switch (f->command) {
 	case FLOW_CLS_REPLACE:
-		return dpaa2_switch_cls_flower_replace(acl_tbl, f);
+		return dpaa2_switch_cls_flower_replace(filter_block, f);
 	case FLOW_CLS_DESTROY:
-		return dpaa2_switch_cls_flower_destroy(acl_tbl, f);
+		return dpaa2_switch_cls_flower_destroy(filter_block, f);
 	default:
 		return -EOPNOTSUPP;
 	}
 }
 
 static int
-dpaa2_switch_setup_tc_cls_matchall(struct dpaa2_switch_acl_tbl *acl_tbl,
+dpaa2_switch_setup_tc_cls_matchall(struct dpaa2_switch_filter_block *block,
 				   struct tc_cls_matchall_offload *f)
 {
 	switch (f->command) {
 	case TC_CLSMATCHALL_REPLACE:
-		return dpaa2_switch_cls_matchall_replace(acl_tbl, f);
+		return dpaa2_switch_cls_matchall_replace(block, f);
 	case TC_CLSMATCHALL_DESTROY:
-		return dpaa2_switch_cls_matchall_destroy(acl_tbl, f);
+		return dpaa2_switch_cls_matchall_destroy(block, f);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -1170,106 +1170,108 @@ static int dpaa2_switch_port_setup_tc_block_cb_ig(enum tc_setup_type type,
 
 static LIST_HEAD(dpaa2_switch_block_cb_list);
 
-static int dpaa2_switch_port_acl_tbl_bind(struct ethsw_port_priv *port_priv,
-					  struct dpaa2_switch_acl_tbl *acl_tbl)
+static int
+dpaa2_switch_port_acl_tbl_bind(struct ethsw_port_priv *port_priv,
+			       struct dpaa2_switch_filter_block *block)
 {
 	struct ethsw_core *ethsw = port_priv->ethsw_data;
 	struct net_device *netdev = port_priv->netdev;
 	struct dpsw_acl_if_cfg acl_if_cfg;
 	int err;
 
-	if (port_priv->acl_tbl)
+	if (port_priv->filter_block)
 		return -EINVAL;
 
 	acl_if_cfg.if_id[0] = port_priv->idx;
 	acl_if_cfg.num_ifs = 1;
 	err = dpsw_acl_add_if(ethsw->mc_io, 0, ethsw->dpsw_handle,
-			      acl_tbl->id, &acl_if_cfg);
+			      block->acl_id, &acl_if_cfg);
 	if (err) {
 		netdev_err(netdev, "dpsw_acl_add_if err %d\n", err);
 		return err;
 	}
 
-	acl_tbl->ports |= BIT(port_priv->idx);
-	port_priv->acl_tbl = acl_tbl;
+	block->ports |= BIT(port_priv->idx);
+	port_priv->filter_block = block;
 
 	return 0;
 }
 
 static int
 dpaa2_switch_port_acl_tbl_unbind(struct ethsw_port_priv *port_priv,
-				 struct dpaa2_switch_acl_tbl *acl_tbl)
+				 struct dpaa2_switch_filter_block *block)
 {
 	struct ethsw_core *ethsw = port_priv->ethsw_data;
 	struct net_device *netdev = port_priv->netdev;
 	struct dpsw_acl_if_cfg acl_if_cfg;
 	int err;
 
-	if (port_priv->acl_tbl != acl_tbl)
+	if (port_priv->filter_block != block)
 		return -EINVAL;
 
 	acl_if_cfg.if_id[0] = port_priv->idx;
 	acl_if_cfg.num_ifs = 1;
 	err = dpsw_acl_remove_if(ethsw->mc_io, 0, ethsw->dpsw_handle,
-				 acl_tbl->id, &acl_if_cfg);
+				 block->acl_id, &acl_if_cfg);
 	if (err) {
 		netdev_err(netdev, "dpsw_acl_add_if err %d\n", err);
 		return err;
 	}
 
-	acl_tbl->ports &= ~BIT(port_priv->idx);
-	port_priv->acl_tbl = NULL;
+	block->ports &= ~BIT(port_priv->idx);
+	port_priv->filter_block = NULL;
 	return 0;
 }
 
 static int dpaa2_switch_port_block_bind(struct ethsw_port_priv *port_priv,
-					struct dpaa2_switch_acl_tbl *acl_tbl)
+					struct dpaa2_switch_filter_block *block)
 {
-	struct dpaa2_switch_acl_tbl *old_acl_tbl = port_priv->acl_tbl;
+	struct dpaa2_switch_filter_block *old_block = port_priv->filter_block;
 	int err;
 
 	/* If the port is already bound to this ACL table then do nothing. This
 	 * can happen when this port is the first one to join a tc block
 	 */
-	if (port_priv->acl_tbl == acl_tbl)
+	if (port_priv->filter_block == block)
 		return 0;
 
-	err = dpaa2_switch_port_acl_tbl_unbind(port_priv, old_acl_tbl);
+	err = dpaa2_switch_port_acl_tbl_unbind(port_priv, old_block);
 	if (err)
 		return err;
 
 	/* Mark the previous ACL table as being unused if this was the last
 	 * port that was using it.
 	 */
-	if (old_acl_tbl->ports == 0)
-		old_acl_tbl->in_use = false;
+	if (old_block->ports == 0)
+		old_block->in_use = false;
 
-	return dpaa2_switch_port_acl_tbl_bind(port_priv, acl_tbl);
+	return dpaa2_switch_port_acl_tbl_bind(port_priv, block);
 }
 
-static int dpaa2_switch_port_block_unbind(struct ethsw_port_priv *port_priv,
-					  struct dpaa2_switch_acl_tbl *acl_tbl)
+static int
+dpaa2_switch_port_block_unbind(struct ethsw_port_priv *port_priv,
+			       struct dpaa2_switch_filter_block *block)
 {
 	struct ethsw_core *ethsw = port_priv->ethsw_data;
-	struct dpaa2_switch_acl_tbl *new_acl_tbl;
+	struct dpaa2_switch_filter_block *new_block;
 	int err;
 
 	/* We are the last port that leaves a block (an ACL table).
 	 * We'll continue to use this table.
 	 */
-	if (acl_tbl->ports == BIT(port_priv->idx))
+	if (block->ports == BIT(port_priv->idx))
 		return 0;
 
-	err = dpaa2_switch_port_acl_tbl_unbind(port_priv, acl_tbl);
+	err = dpaa2_switch_port_acl_tbl_unbind(port_priv, block);
 	if (err)
 		return err;
 
-	if (acl_tbl->ports == 0)
-		acl_tbl->in_use = false;
+	if (block->ports == 0)
+		block->in_use = false;
 
-	new_acl_tbl = dpaa2_switch_acl_tbl_get_unused(ethsw);
-	new_acl_tbl->in_use = true;
-	return dpaa2_switch_port_acl_tbl_bind(port_priv, new_acl_tbl);
+	new_block = dpaa2_switch_filter_block_get_unused(ethsw);
+	new_block->in_use = true;
+	return dpaa2_switch_port_acl_tbl_bind(port_priv, new_block);
 }
 
 static int dpaa2_switch_setup_tc_block_bind(struct net_device *netdev,
@@ -1277,7 +1279,7 @@ static int dpaa2_switch_setup_tc_block_bind(struct net_device *netdev,
 {
 	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
 	struct ethsw_core *ethsw = port_priv->ethsw_data;
-	struct dpaa2_switch_acl_tbl *acl_tbl;
+	struct dpaa2_switch_filter_block *filter_block;
 	struct flow_block_cb *block_cb;
 	bool register_block = false;
 	int err;
@@ -1287,24 +1289,24 @@ static int dpaa2_switch_setup_tc_block_bind(struct net_device *netdev,
 					ethsw);
 
 	if (!block_cb) {
-		/* If the ACL table is not already known, then this port must
-		 * be the first to join it. In this case, we can just continue
-		 * to use our private table
+		/* If the filter block is not already known, then this port
+		 * must be the first to join it. In this case, we can just
+		 * continue to use our private table
 		 */
-		acl_tbl = port_priv->acl_tbl;
+		filter_block = port_priv->filter_block;
 
 		block_cb = flow_block_cb_alloc(dpaa2_switch_port_setup_tc_block_cb_ig,
-					       ethsw, acl_tbl, NULL);
+					       ethsw, filter_block, NULL);
 		if (IS_ERR(block_cb))
 			return PTR_ERR(block_cb);
 
 		register_block = true;
 	} else {
-		acl_tbl = flow_block_cb_priv(block_cb);
+		filter_block = flow_block_cb_priv(block_cb);
 	}
 
 	flow_block_cb_incref(block_cb);
-	err = dpaa2_switch_port_block_bind(port_priv, acl_tbl);
+	err = dpaa2_switch_port_block_bind(port_priv, filter_block);
 	if (err)
 		goto err_block_bind;
 
@@ -1327,7 +1329,7 @@ static void dpaa2_switch_setup_tc_block_unbind(struct net_device *netdev,
 {
 	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
 	struct ethsw_core *ethsw = port_priv->ethsw_data;
-	struct dpaa2_switch_acl_tbl *acl_tbl;
+	struct dpaa2_switch_filter_block *filter_block;
 	struct flow_block_cb *block_cb;
 	int err;
 
@@ -1337,8 +1339,8 @@ static void dpaa2_switch_setup_tc_block_unbind(struct net_device *netdev,
 	if (!block_cb)
 		return;
 
-	acl_tbl = flow_block_cb_priv(block_cb);
-	err = dpaa2_switch_port_block_unbind(port_priv, acl_tbl);
+	filter_block = flow_block_cb_priv(block_cb);
+	err = dpaa2_switch_port_block_unbind(port_priv, filter_block);
 	if (!err && !flow_block_cb_decref(block_cb)) {
 		flow_block_cb_remove(block_cb, f);
 		list_del(&block_cb->driver_list);
@@ -2991,7 +2993,7 @@ static int dpaa2_switch_port_trap_mac_addr(struct ethsw_port_priv *port_priv,
 	acl_entry.cfg.precedence = 0;
 	acl_entry.cfg.result.action = DPSW_ACL_ACTION_REDIRECT_TO_CTRL_IF;
 
-	return dpaa2_switch_acl_entry_add(port_priv->acl_tbl, &acl_entry);
+	return dpaa2_switch_acl_entry_add(port_priv->filter_block, &acl_entry);
 }
 
 static int dpaa2_switch_port_init(struct ethsw_port_priv *port_priv, u16 port)
@@ -3004,7 +3006,7 @@ static int dpaa2_switch_port_init(struct ethsw_port_priv *port_priv, u16 port)
 	};
 	struct net_device *netdev = port_priv->netdev;
 	struct ethsw_core *ethsw = port_priv->ethsw_data;
-	struct dpaa2_switch_acl_tbl *acl_tbl;
+	struct dpaa2_switch_filter_block *filter_block;
 	struct dpsw_fdb_cfg fdb_cfg = {0};
 	struct dpsw_if_attr dpsw_if_attr;
 	struct dpaa2_switch_fdb *fdb;
@@ -3059,14 +3061,14 @@ static int dpaa2_switch_port_init(struct ethsw_port_priv *port_priv, u16 port)
 		return err;
 	}
 
-	acl_tbl = dpaa2_switch_acl_tbl_get_unused(ethsw);
-	acl_tbl->ethsw = ethsw;
-	acl_tbl->id = acl_tbl_id;
-	acl_tbl->in_use = true;
-	acl_tbl->num_rules = 0;
-	INIT_LIST_HEAD(&acl_tbl->entries);
+	filter_block = dpaa2_switch_filter_block_get_unused(ethsw);
+	filter_block->ethsw = ethsw;
+	filter_block->acl_id = acl_tbl_id;
+	filter_block->in_use = true;
+	filter_block->num_acl_rules = 0;
+	INIT_LIST_HEAD(&filter_block->acl_entries);
 
-	err = dpaa2_switch_port_acl_tbl_bind(port_priv, acl_tbl);
+	err = dpaa2_switch_port_acl_tbl_bind(port_priv, filter_block);
 	if (err)
 		return err;
 
@@ -3120,7 +3122,7 @@ static int dpaa2_switch_remove(struct fsl_mc_device *sw_dev)
 	}
 
 	kfree(ethsw->fdbs);
-	kfree(ethsw->acls);
+	kfree(ethsw->filter_blocks);
 	kfree(ethsw->ports);
 
 	dpaa2_switch_takedown(sw_dev);
@@ -3248,9 +3250,10 @@ static int dpaa2_switch_probe(struct fsl_mc_device *sw_dev)
 		goto err_free_ports;
 	}
 
-	ethsw->acls = kcalloc(ethsw->sw_attr.num_ifs, sizeof(*ethsw->acls),
-			      GFP_KERNEL);
-	if (!ethsw->acls) {
+	ethsw->filter_blocks = kcalloc(ethsw->sw_attr.num_ifs,
+				       sizeof(*ethsw->filter_blocks),
+				       GFP_KERNEL);
+	if (!ethsw->filter_blocks) {
 		err = -ENOMEM;
 		goto err_free_fdbs;
 	}
@@ -3303,7 +3306,7 @@ static int dpaa2_switch_probe(struct fsl_mc_device *sw_dev)
 err_free_netdev:
 	for (i--; i >= 0; i--)
 		free_netdev(ethsw->ports[i]->netdev);
-	kfree(ethsw->acls);
+	kfree(ethsw->filter_blocks);
 err_free_fdbs:
 	kfree(ethsw->fdbs);
 err_free_ports:
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
index bdef71f234cb..296a09eb7a9a 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
@@ -113,20 +113,20 @@ struct dpaa2_switch_acl_entry {
 	struct dpsw_acl_key	key;
 };
 
-struct dpaa2_switch_acl_tbl {
-	struct list_head	entries;
+struct dpaa2_switch_filter_block {
 	struct ethsw_core	*ethsw;
 	u64			ports;
-
-	u16			id;
-	u8			num_rules;
 	bool			in_use;
+
+	struct list_head	acl_entries;
+	u16			acl_id;
+	u8			num_acl_rules;
 };
 
 static inline bool
-dpaa2_switch_acl_tbl_is_full(struct dpaa2_switch_acl_tbl *acl_tbl)
+dpaa2_switch_acl_tbl_is_full(struct dpaa2_switch_filter_block *filter_block)
 {
-	if ((acl_tbl->num_rules + DPAA2_ETHSW_PORT_DEFAULT_TRAPS) >=
+	if ((filter_block->num_acl_rules + DPAA2_ETHSW_PORT_DEFAULT_TRAPS) >=
 	    DPAA2_ETHSW_PORT_MAX_ACL_ENTRIES)
 		return true;
 	return false;
@@ -149,7 +149,7 @@ struct ethsw_port_priv {
 	bool			ucast_flood;
 	bool			learn_ena;
 
-	struct dpaa2_switch_acl_tbl *acl_tbl;
+	struct dpaa2_switch_filter_block *filter_block;
 };
 
 /* Switch data */
@@ -175,7 +175,7 @@ struct ethsw_core {
 	int				napi_users;
 
 	struct dpaa2_switch_fdb		*fdbs;
-	struct dpaa2_switch_acl_tbl	*acls;
+	struct dpaa2_switch_filter_block *filter_blocks;
 };
 
 static inline int dpaa2_switch_get_index(struct ethsw_core *ethsw,
@@ -229,18 +229,18 @@ typedef int dpaa2_switch_fdb_cb_t(struct ethsw_port_priv *port_priv,
 
 /* TC offload */
 
-int dpaa2_switch_cls_flower_replace(struct dpaa2_switch_acl_tbl *acl_tbl,
+int dpaa2_switch_cls_flower_replace(struct dpaa2_switch_filter_block *block,
 				    struct flow_cls_offload *cls);
 
-int dpaa2_switch_cls_flower_destroy(struct dpaa2_switch_acl_tbl *acl_tbl,
+int dpaa2_switch_cls_flower_destroy(struct dpaa2_switch_filter_block *block,
 				    struct flow_cls_offload *cls);
 
-int dpaa2_switch_cls_matchall_replace(struct dpaa2_switch_acl_tbl *acl_tbl,
+int dpaa2_switch_cls_matchall_replace(struct dpaa2_switch_filter_block *block,
 				      struct tc_cls_matchall_offload *cls);
 
-int dpaa2_switch_cls_matchall_destroy(struct dpaa2_switch_acl_tbl *acl_tbl,
+int dpaa2_switch_cls_matchall_destroy(struct dpaa2_switch_filter_block *block,
 				      struct tc_cls_matchall_offload *cls);
 
-int dpaa2_switch_acl_entry_add(struct dpaa2_switch_acl_tbl *acl_tbl,
+int dpaa2_switch_acl_entry_add(struct dpaa2_switch_filter_block *block,
 			       struct dpaa2_switch_acl_entry *entry);
 #endif	/* __ETHSW_H */
-- 
2.31.1

