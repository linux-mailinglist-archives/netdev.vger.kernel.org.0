Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F06C056424D
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 21:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbiGBTEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 15:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232369AbiGBTEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 15:04:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDAA7B49D
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 12:04:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A18B61007
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 19:04:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46FEC341C8;
        Sat,  2 Jul 2022 19:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656788661;
        bh=/WvcUZuc8DnF4KU5hTlcikg/2yfB6tFkV8JOmw8QLG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MKlGIDgx9xWnyzXY96MXBhk9O7AGUmEZx7LLnZcj+KXY5uyoLpCMgOld0YZ8OC3GK
         29JtSEBQjwqdz2zLCZlcMk1P1AmbFRPHZMOWeTXDS2toPnGjiglm0xW360PkYwTE+0
         15i5Lvge7EnIM8MwK7I64EZEYUgrr4I/mostOA5HaxbSx4ZdDXuID+J56Dx7yoFKsb
         7X4e0uHZ5bkSqsdU3f6EZL9kp7+vEZFlMjdLVv1mOHA1bdtvIg/tVh1xdorgJQn5pW
         8FA4Qtgbezmc96PTv9+ftxaS1R1GPWWDaN30LnzZSIfGZXa0vsFmVXc8uffPaHRdQO
         CV8MLP75RIScQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [net-next v2 01/15] net/mlx5: Delete ipsec_fs header file as not used
Date:   Sat,  2 Jul 2022 12:01:59 -0700
Message-Id: <20220702190213.80858-2-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220702190213.80858-1-saeed@kernel.org>
References: <20220702190213.80858-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
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
2.36.1

