Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6835463CE94
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 06:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbiK3FMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 00:12:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233168AbiK3FME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 00:12:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A5DD5FBA3
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 21:12:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA0D86154A
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 05:12:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28759C433B5;
        Wed, 30 Nov 2022 05:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669785123;
        bh=pZjcGCFhtNbdDKtbayuonxHkUFNUzZJ+1DjZkeYhqOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lXgEae0B3i2K1l9bOs9le3oofs5omWR8OuE4AHt8eMAe7Sn5lppVGXWg0xzUGhk2U
         ye+54S/Z/AeyGkb41mtes/DJK9rEMhCejRCn68ruGRZFlb0U7SQ67Z6K3KuApZe6/W
         LTmhOf5Z3OJix0ak0y/xT9Ulk9HCqsHTUAE9YTtPPvFLAxdcRU+HHG9oIBC8ehmJFF
         a7iU/qGs1j0tfYwL92LbL4Eh2CJaklYyZVUHlMD1eM+vyKxtUKTg5qlxvrYiT3mGIo
         WmnFFHRkc0KfDFChUqI7YjrwENABrhTFsuiE59MJUYXNKNDbfsyqMgfoUWAh/YdsjI
         Sc5ALI+VujTjg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [net-next 05/15] net/mlx5: Remove unused UMR MTT definitions
Date:   Tue, 29 Nov 2022 21:11:42 -0800
Message-Id: <20221130051152.479480-6-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130051152.479480-1-saeed@kernel.org>
References: <20221130051152.479480-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Defines MLX5_UMR_MTT_MASK and MLX5_UMR_MTT_MIN_CHUNK_SIZE are not in
use. Remove them.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/device.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 97275965f156..ecf840e2989b 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -292,8 +292,6 @@ enum {
 
 #define MLX5_UMR_KLM_ALIGNMENT 4
 #define MLX5_UMR_MTT_ALIGNMENT 0x40
-#define MLX5_UMR_MTT_MASK      (MLX5_UMR_MTT_ALIGNMENT - 1)
-#define MLX5_UMR_MTT_MIN_CHUNK_SIZE MLX5_UMR_MTT_ALIGNMENT
 #define MLX5_UMR_MTT_NUM_ENTRIES_ALIGNMENT (MLX5_UMR_MTT_ALIGNMENT / sizeof(struct mlx5_mtt))
 
 #define MLX5_USER_INDEX_LEN (MLX5_FLD_SZ_BYTES(qpc, user_index) * 8)
-- 
2.38.1

