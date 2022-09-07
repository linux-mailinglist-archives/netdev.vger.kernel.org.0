Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9A225B108A
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 01:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbiIGXht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 19:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbiIGXh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 19:37:29 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C735EC58D6;
        Wed,  7 Sep 2022 16:37:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 95F1ECE1E1C;
        Wed,  7 Sep 2022 23:37:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8C76C43470;
        Wed,  7 Sep 2022 23:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662593838;
        bh=aAXnCkV+nxiGQI7iRg1i4AG4A/y7hBGobBjlmiiYmpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RMe+hH5nohRKXDBg8hmNlpyCVx8gWa1FOv/qHYdoAzWvFcDMFRvxAb857dZs8ydHG
         4dE9ZqSmq4lq+ztZNVKMQSfvKYAUOgJe5W/6bmvDmV6nM1fhfmYisOIOP88qATxoOo
         Pf4Fd1UJwAGxzkknQ/zMk6NgjgVW7EONebhX998mWVrNfAJOIpKJnTDJrm3YJJf+93
         GpgJG5EtUnxtlpPzocXYDrA4AkSJDGTupOlQNZM1KAcqLdPTMP8lMxrKGCiet3UrQB
         i19RgCXdri03O2gQcPDHM0uWw7Y4XCqrQz7YbpL3alzbqhGRpQEzWqhsjpIEweCd4P
         4roTpJpYJU5Jg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-rdma@vger.kernel.org,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH mlx5-next 10/14] net/mlx5: Remove from FPGA IFC file not-needed definitions
Date:   Wed,  7 Sep 2022 16:36:32 -0700
Message-Id: <20220907233636.388475-11-saeed@kernel.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

Move IP layout bits definitions to be close to the place that actually
uses it, together with removal extra defines that not in-use.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h      | 16 ++++++++++++++++
 include/linux/mlx5/mlx5_ifc_fpga.h | 24 ------------------------
 2 files changed, 16 insertions(+), 24 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 3c1756763e90..26619b8e57c2 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -477,6 +477,22 @@ struct mlx5_ifc_odp_per_transport_service_cap_bits {
 	u8         reserved_at_6[0x1a];
 };
 
+struct mlx5_ifc_ipv4_layout_bits {
+	u8         reserved_at_0[0x60];
+
+	u8         ipv4[0x20];
+};
+
+struct mlx5_ifc_ipv6_layout_bits {
+	u8         ipv6[16][0x8];
+};
+
+union mlx5_ifc_ipv6_layout_ipv4_layout_auto_bits {
+	struct mlx5_ifc_ipv6_layout_bits ipv6_layout;
+	struct mlx5_ifc_ipv4_layout_bits ipv4_layout;
+	u8         reserved_at_0[0x80];
+};
+
 struct mlx5_ifc_fte_match_set_lyr_2_4_bits {
 	u8         smac_47_16[0x20];
 
diff --git a/include/linux/mlx5/mlx5_ifc_fpga.h b/include/linux/mlx5/mlx5_ifc_fpga.h
index 45c7c0d67635..0596472923ad 100644
--- a/include/linux/mlx5/mlx5_ifc_fpga.h
+++ b/include/linux/mlx5/mlx5_ifc_fpga.h
@@ -32,30 +32,6 @@
 #ifndef MLX5_IFC_FPGA_H
 #define MLX5_IFC_FPGA_H
 
-struct mlx5_ifc_ipv4_layout_bits {
-	u8         reserved_at_0[0x60];
-
-	u8         ipv4[0x20];
-};
-
-struct mlx5_ifc_ipv6_layout_bits {
-	u8         ipv6[16][0x8];
-};
-
-union mlx5_ifc_ipv6_layout_ipv4_layout_auto_bits {
-	struct mlx5_ifc_ipv6_layout_bits ipv6_layout;
-	struct mlx5_ifc_ipv4_layout_bits ipv4_layout;
-	u8         reserved_at_0[0x80];
-};
-
-enum {
-	MLX5_FPGA_CAP_SANDBOX_VENDOR_ID_MLNX = 0x2c9,
-};
-
-enum {
-	MLX5_FPGA_CAP_SANDBOX_PRODUCT_ID_IPSEC    = 0x2,
-};
-
 struct mlx5_ifc_fpga_shell_caps_bits {
 	u8         max_num_qps[0x10];
 	u8         reserved_at_10[0x8];
-- 
2.37.2

