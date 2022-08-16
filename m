Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B43B75959F0
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 13:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232986AbiHPLYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 07:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233256AbiHPLYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 07:24:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A454CA19B
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 03:38:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14C3460FAD
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 10:38:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8749C433C1;
        Tue, 16 Aug 2022 10:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660646308;
        bh=OwaLhpZTr9QUnMAP0q9r5lnpkQkLATPCUQZsrqYe+t4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=crZ/Rgf5ULG8Zlv3TeBxUy6jwvhQu2jdqiH93v3wv7Krx0ut7VEao2ZSLpoCSrENk
         qjxL5UjZuSA2b16yWDPYENPMY6XUr39hqiUS+5etJyAi8AkxT47Yjs9hcc/L/yPgSo
         dGodogjTzF4ixQRFHBI6Vippy6LsbIsDJV8jivfLr9+shiDZzHCdHw2GUAdahB3BSD
         qgIg+4ZcvKomi/bEgXB9IAK5tzuj5YLx3K9t2XobVqaaaUSo4obusgVJcX9fVzj260
         8TnM97O/pEU5yk62NIiyJq3e6A9iOwvdJ2NmjXdPkMULyRNm+b6EOUiDG/ALF8bhgZ
         BdHEh56PV2Ahw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: [PATCH xfrm-next 03/26] net/mlx5: Remove from FPGA IFC file not-needed definitions
Date:   Tue, 16 Aug 2022 13:37:51 +0300
Message-Id: <b511fc84523a18178be1bcdfcb214d074d4ce5be.1660641154.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1660641154.git.leonro@nvidia.com>
References: <cover.1660641154.git.leonro@nvidia.com>
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
---
 include/linux/mlx5/mlx5_ifc.h      | 16 ++++++++++++++++
 include/linux/mlx5/mlx5_ifc_fpga.h | 24 ------------------------
 2 files changed, 16 insertions(+), 24 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 57b4ae2dce07..c30036f7b517 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -479,6 +479,22 @@ struct mlx5_ifc_odp_per_transport_service_cap_bits {
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

