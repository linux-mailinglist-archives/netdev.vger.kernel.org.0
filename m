Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D27D5B1086
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 01:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbiIGXhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 19:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbiIGXh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 19:37:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AAF7C1CF;
        Wed,  7 Sep 2022 16:37:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B669AB81F5F;
        Wed,  7 Sep 2022 23:37:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5739CC433D6;
        Wed,  7 Sep 2022 23:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662593836;
        bh=Sl1U6xhAr3RaMzRCpm+HSZeUIOpdCt2tvsVApQ2vDjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZwLwUIhv8eGAJTKVrQ9Py8tvwQ6K0ZZeZv9qy9SBd7AX6At2Z6JaFx+x4au58hGPy
         3nH+KqJ1Kh/1YzVsDPOdXGEfAx3FAV5VeKEzL0G/uNIKCcKLp3hSnLLi8bRH3h1672
         Uvd8OvRXlqB7S54ahTlhpiIAaQWbrlFfeF0UI0LMcHZFrlZVH+gOC+GUc++jdBJYpv
         Nm0PoWin+do72wogrxOIBcS9Xtl/yY9kDE2UzQnUUAKjDpWodkARRtYrr82mOF5/6J
         DKAd51g12BMBzE1U3YNFQU1guNWTeZzmr8bXzC9ce3SNnXkJJtEpXnbhtV1lE62gSY
         TJF02k2VAwh6w==
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
Subject: [PATCH mlx5-next 08/14] net/mlx5: Remove unused functions
Date:   Wed,  7 Sep 2022 16:36:30 -0700
Message-Id: <20220907233636.388475-9-saeed@kernel.org>
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

Remove functions which are no longer used in the driver:
  mlx5e_ipsec_is_tx_flow
  mlx5_health_flush
  get_cqe_enhanced_num_mini_cqes
  get_cqe_l3_hdr_type
  mlx5_health_flush
  mlx5_fs_is_ipsec_flow
  _mlx5_fs_is_outer_ipproto_flow
  mlx5_fs_is_outer_tcp_flow
  mlx5_fs_is_outer_udp_flow
  mlx5_fs_is_vxlan_flow
  mlx5_fs_is_outer_ipsec_flow

Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h  |  5 --
 .../net/ethernet/mellanox/mlx5/core/health.c  |  7 ---
 include/linux/mlx5/device.h                   | 11 -----
 include/linux/mlx5/driver.h                   |  1 -
 include/linux/mlx5/fs_helpers.h               | 48 -------------------
 5 files changed, 72 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
index 0ae4e12ce528..efc43d25ef08 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
@@ -77,11 +77,6 @@ static inline bool mlx5_ipsec_is_rx_flow(struct mlx5_cqe64 *cqe)
 	return MLX5_IPSEC_METADATA_MARKER(be32_to_cpu(cqe->ft_metadata));
 }
 
-static inline bool mlx5e_ipsec_is_tx_flow(struct mlx5e_accel_tx_ipsec_state *ipsec_st)
-{
-	return ipsec_st->x;
-}
-
 static inline bool mlx5e_ipsec_eseg_meta(struct mlx5_wqe_eth_seg *eseg)
 {
 	return eseg->flow_table_metadata & cpu_to_be32(MLX5_ETH_WQE_FT_META_IPSEC);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index 2cf2c9948446..b7ef891836f0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -875,13 +875,6 @@ void mlx5_drain_health_wq(struct mlx5_core_dev *dev)
 	cancel_work_sync(&health->fatal_report_work);
 }
 
-void mlx5_health_flush(struct mlx5_core_dev *dev)
-{
-	struct mlx5_core_health *health = &dev->priv.health;
-
-	flush_workqueue(health->wq);
-}
-
 void mlx5_health_cleanup(struct mlx5_core_dev *dev)
 {
 	struct mlx5_core_health *health = &dev->priv.health;
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index b5f58fd37a0f..3fbeb0468618 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -874,12 +874,6 @@ static inline u8 get_cqe_opcode(struct mlx5_cqe64 *cqe)
 	return cqe->op_own >> 4;
 }
 
-static inline u8 get_cqe_enhanced_num_mini_cqes(struct mlx5_cqe64 *cqe)
-{
-	/* num_of_mini_cqes is zero based */
-	return get_cqe_opcode(cqe) + 1;
-}
-
 static inline u8 get_cqe_lro_tcppsh(struct mlx5_cqe64 *cqe)
 {
 	return (cqe->lro.tcppsh_abort_dupack >> 6) & 1;
@@ -890,11 +884,6 @@ static inline u8 get_cqe_l4_hdr_type(struct mlx5_cqe64 *cqe)
 	return (cqe->l4_l3_hdr_type >> 4) & 0x7;
 }
 
-static inline u8 get_cqe_l3_hdr_type(struct mlx5_cqe64 *cqe)
-{
-	return (cqe->l4_l3_hdr_type >> 2) & 0x3;
-}
-
 static inline bool cqe_is_tunneled(struct mlx5_cqe64 *cqe)
 {
 	return cqe->tls_outer_l3_tunneled & 0x1;
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 829a2ceafdec..48f2d79a7732 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1017,7 +1017,6 @@ int mlx5_cmd_exec_polling(struct mlx5_core_dev *dev, void *in, int in_size,
 bool mlx5_cmd_is_down(struct mlx5_core_dev *dev);
 
 int mlx5_core_get_caps(struct mlx5_core_dev *dev, enum mlx5_cap_type cap_type);
-void mlx5_health_flush(struct mlx5_core_dev *dev);
 void mlx5_health_cleanup(struct mlx5_core_dev *dev);
 int mlx5_health_init(struct mlx5_core_dev *dev);
 void mlx5_start_health_poll(struct mlx5_core_dev *dev);
diff --git a/include/linux/mlx5/fs_helpers.h b/include/linux/mlx5/fs_helpers.h
index 9db21cd0e92c..bc5125bc0561 100644
--- a/include/linux/mlx5/fs_helpers.h
+++ b/include/linux/mlx5/fs_helpers.h
@@ -38,46 +38,6 @@
 #define MLX5_FS_IPV4_VERSION 4
 #define MLX5_FS_IPV6_VERSION 6
 
-static inline bool mlx5_fs_is_ipsec_flow(const u32 *match_c)
-{
-	void *misc_params_c = MLX5_ADDR_OF(fte_match_param, match_c,
-					   misc_parameters);
-
-	return MLX5_GET(fte_match_set_misc, misc_params_c, outer_esp_spi);
-}
-
-static inline bool _mlx5_fs_is_outer_ipproto_flow(const u32 *match_c,
-						  const u32 *match_v, u8 match)
-{
-	const void *headers_c = MLX5_ADDR_OF(fte_match_param, match_c,
-					     outer_headers);
-	const void *headers_v = MLX5_ADDR_OF(fte_match_param, match_v,
-					     outer_headers);
-
-	return MLX5_GET(fte_match_set_lyr_2_4, headers_c, ip_protocol) == 0xff &&
-		MLX5_GET(fte_match_set_lyr_2_4, headers_v, ip_protocol) == match;
-}
-
-static inline bool mlx5_fs_is_outer_tcp_flow(const u32 *match_c,
-					     const u32 *match_v)
-{
-	return _mlx5_fs_is_outer_ipproto_flow(match_c, match_v, IPPROTO_TCP);
-}
-
-static inline bool mlx5_fs_is_outer_udp_flow(const u32 *match_c,
-					     const u32 *match_v)
-{
-	return _mlx5_fs_is_outer_ipproto_flow(match_c, match_v, IPPROTO_UDP);
-}
-
-static inline bool mlx5_fs_is_vxlan_flow(const u32 *match_c)
-{
-	void *misc_params_c = MLX5_ADDR_OF(fte_match_param, match_c,
-					   misc_parameters);
-
-	return MLX5_GET(fte_match_set_misc, misc_params_c, vxlan_vni);
-}
-
 static inline bool _mlx5_fs_is_outer_ipv_flow(struct mlx5_core_dev *mdev,
 					      const u32 *match_c,
 					      const u32 *match_v, int version)
@@ -131,12 +91,4 @@ mlx5_fs_is_outer_ipv6_flow(struct mlx5_core_dev *mdev, const u32 *match_c,
 					  MLX5_FS_IPV6_VERSION);
 }
 
-static inline bool mlx5_fs_is_outer_ipsec_flow(const u32 *match_c)
-{
-	void *misc_params_c =
-			MLX5_ADDR_OF(fte_match_param, match_c, misc_parameters);
-
-	return MLX5_GET(fte_match_set_misc, misc_params_c, outer_esp_spi);
-}
-
 #endif
-- 
2.37.2

