Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAF1523250
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 14:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241059AbiEKMAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 08:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241097AbiEKMAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 08:00:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 937ED245629
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 05:00:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C8FD6198A
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 12:00:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD8F2C340F2;
        Wed, 11 May 2022 12:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652270406;
        bh=vDKjtHmc9mVsFsZKAIhgIQo0evsHk54HNDat25yc1ws=;
        h=From:To:Cc:Subject:Date:From;
        b=AuXfs4/vqUdY+Cg1AHJjPKR0vveT21GLv+MbcU11RuS7rIoMZ1vl0xarhBJJv6McI
         rwHrFnhuvPBmnImaMrkGpTc8P/X9JaOZiIRnZD4EG8qtWsS26zCm6DvdcMUWAeCvi2
         ibi/xavcbHGhE0sPSoAk8eYyQ8w/T7LmDbhjmyKXRSPX8bs7UUkD7ft/+6yuWDNyC2
         fs4qCwgx7QyA+AuRg0Yda2BK0wiE6x7nWjRj3xqVcZ2jbQ6z16UFMtGyfYZKn8TUu4
         bxjtURL339IPjTOZVAjEmjfN2oI7WG1KTDLtwdzqb/dq1r2DWR0WqRkLwWqK7zjuHn
         9qKr7iEX3fQkA==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org
Subject: [PATCH net-next] net/mlx5: Delete ipsec_fs header file as not used
Date:   Wed, 11 May 2022 15:00:01 +0300
Message-Id: <a55631466505b2468baa436a536d6e900062f11f.1652270284.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

ipsec_fs.h is not used and can be safely deleted.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_fs.h    | 21 -------------------
 1 file changed, 21 deletions(-)
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h
deleted file mode 100644
index e4eeb2ba21c7..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h
+++ /dev/null
@@ -1,21 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
-/* Copyright (c) 2020, Mellanox Technologies inc. All rights reserved. */
-
-#ifndef __MLX5_IPSEC_STEERING_H__
-#define __MLX5_IPSEC_STEERING_H__
-
-#include "en.h"
-#include "ipsec.h"
-#include "ipsec_offload.h"
-#include "en/fs.h"
-
-void mlx5e_accel_ipsec_fs_cleanup(struct mlx5e_ipsec *ipsec);
-int mlx5e_accel_ipsec_fs_init(struct mlx5e_ipsec *ipsec);
-int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_priv *priv,
-				  struct mlx5_accel_esp_xfrm_attrs *attrs,
-				  u32 ipsec_obj_id,
-				  struct mlx5e_ipsec_rule *ipsec_rule);
-void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_priv *priv,
-				   struct mlx5_accel_esp_xfrm_attrs *attrs,
-				   struct mlx5e_ipsec_rule *ipsec_rule);
-#endif /* __MLX5_IPSEC_STEERING_H__ */
-- 
2.35.1

