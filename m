Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD3685B1088
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 01:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbiIGXho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 19:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbiIGXh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 19:37:29 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B014C480D;
        Wed,  7 Sep 2022 16:37:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E5461CE1E05;
        Wed,  7 Sep 2022 23:37:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 215B3C433C1;
        Wed,  7 Sep 2022 23:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662593837;
        bh=TY6erFYHZ8WMJWtlX48MYBWhCozS/CeISBZAdV2IRcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GxFhoMrx3XrxMUnIOCZMLw/Lz2GLZT0SuMXhT7idlXmypC3tN8a2MG/Mpxc0gJw63
         +d1EF4/NpC3NTEEAwM9WnCerSpkspOGNZFkTJ67tndogObpFd8ZybinvRPXlq64Znv
         28zKW5KlznNQhDcXBbfbqudih19eZzpZulRjWE/8CrWvwkRYF/PQ8gvnvJ4rvyROFw
         rEJlPxgpt9wOgwXnYPnWOQ5xs+3eTSuz/RG6nN908fV22ibhtyFenF/a7lBm1FB4V8
         4MYPbqCpo8s5Pk24ybn+4yp/APrddXQXRu4d2x8UrBiiDCxZS29IEimBvTkAJ7utUv
         +6qIEP2P3s/0A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-rdma@vger.kernel.org,
        Gal Pressman <gal@nvidia.com>
Subject: [PATCH mlx5-next 09/14] net/mlx5: Remove unused structs
Date:   Wed,  7 Sep 2022 16:36:31 -0700
Message-Id: <20220907233636.388475-10-saeed@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220907233636.388475-1-saeed@kernel.org>
References: <20220907233636.388475-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gal Pressman <gal@nvidia.com>

Remove structs which are no longer used in the driver:
  mlx5dr_cmd_qp_create_attr
  mlx5_fs_dr_ns
  mlx5_pas

Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_types.h         | 14 --------------
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.h   |  4 ----
 include/linux/mlx5/driver.h                        |  5 -----
 3 files changed, 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 062c7c74a1f3..1777a1e508e7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -1294,20 +1294,6 @@ struct mlx5dr_cmd_gid_attr {
 	u32 roce_ver;
 };
 
-struct mlx5dr_cmd_qp_create_attr {
-	u32 page_id;
-	u32 pdn;
-	u32 cqn;
-	u32 pm_state;
-	u32 service_type;
-	u32 buff_umem_id;
-	u32 db_umem_id;
-	u32 sq_wqe_cnt;
-	u32 rq_wqe_cnt;
-	u32 rq_wqe_shift;
-	u8 isolate_vl_tc:1;
-};
-
 int mlx5dr_cmd_query_gid(struct mlx5_core_dev *mdev, u8 vhca_port_num,
 			 u16 index, struct mlx5dr_cmd_gid_attr *attr);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.h
index 1fb185d6ac7f..d168622063d5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.h
@@ -14,10 +14,6 @@ struct mlx5_fs_dr_action {
 	struct mlx5dr_action *dr_action;
 };
 
-struct mlx5_fs_dr_ns {
-	struct mlx5_dr_ns *dr_ns;
-};
-
 struct mlx5_fs_dr_rule {
 	struct mlx5dr_rule    *dr_rule;
 	/* Only actions created by fs_dr */
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 48f2d79a7732..b55583425920 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -856,11 +856,6 @@ struct mlx5_cmd_work_ent {
 	refcount_t              refcnt;
 };
 
-struct mlx5_pas {
-	u64	pa;
-	u8	log_sz;
-};
-
 enum phy_port_state {
 	MLX5_AAA_111
 };
-- 
2.37.2

