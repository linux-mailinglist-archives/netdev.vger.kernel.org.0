Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E159F4F5E15
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 14:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbiDFMeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 08:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233102AbiDFMbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 08:31:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075C7577B6A;
        Wed,  6 Apr 2022 01:26:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 836DAB82186;
        Wed,  6 Apr 2022 08:26:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB7CC385A1;
        Wed,  6 Apr 2022 08:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649233612;
        bh=jRhpswGEZMMLoPMbto7cwMcackH47XHQEkjraLI8sdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kMbnD+BaTqBtjWZYu4EYeqYMC9/LJvo1T0sQ6e2UNJx1043GxFfzR7FGW4p3x8OYd
         F02uCGou7i3VV4KY/QK6ewH0rgtdzPqEvrNVIJcrvx7cxLUd9qS34wBveoQ1pkbcPv
         GLN27pnDd1U78ayXS4C5hQDfHR9E+gLxTpkkyboGaTPpm8SN4BKc6qKQAQYA8GP7ee
         IupN7g21lQBTu8Q5qNsRjdn9bbIJXQBhxD5dYPU4y4poglt9Q3FdnfXyFCO3ErRVXO
         qvGbUgBnkhwSNC78wDdYOD+pC/+Rs6gwLekQuNUThMS6NF5GQ4VDLnqHTg1EdzzWfZ
         dL4lHWpSXPCBA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH mlx5-next 14/17] net/mlx5: Move IPsec file to relevant directory
Date:   Wed,  6 Apr 2022 11:25:49 +0300
Message-Id: <a0ca88f4d9c602c574106c0de0511803e7dcbdff.1649232994.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649232994.git.leonro@nvidia.com>
References: <cover.1649232994.git.leonro@nvidia.com>
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

IPsec is part of ethernet side of mlx5 driver and needs to be placed
in en_accel folder.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/Makefile                | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/params.c             | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h        | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c     | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h     | 2 +-
 .../mellanox/mlx5/core/{accel => en_accel}/ipsec_offload.c      | 2 +-
 .../mellanox/mlx5/core/{accel => en_accel}/ipsec_offload.h      | 0
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c   | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_stats.c  | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c               | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c                 | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c                  | 2 +-
 12 files changed, 11 insertions(+), 11 deletions(-)
 rename drivers/net/ethernet/mellanox/mlx5/core/{accel => en_accel}/ipsec_offload.c (99%)
 rename drivers/net/ethernet/mellanox/mlx5/core/{accel => en_accel}/ipsec_offload.h (100%)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 9e715a1056f8..f7aafbfcdb61 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -94,7 +94,7 @@ mlx5_core-$(CONFIG_MLX5_FPGA) += fpga/cmd.o fpga/core.o fpga/conn.o fpga/sdk.o
 
 mlx5_core-$(CONFIG_MLX5_EN_IPSEC) += en_accel/ipsec.o en_accel/ipsec_rxtx.o \
 				     en_accel/ipsec_stats.o en_accel/ipsec_fs.o \
-				     accel/ipsec_offload.o
+				     en_accel/ipsec_offload.o
 
 mlx5_core-$(CONFIG_MLX5_EN_TLS) += en_accel/ktls_stats.o \
 				   en_accel/fs_tcp.o en_accel/ktls.o en_accel/ktls_txrx.o \
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 9f4ae8bc09b9..1e8700957280 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -5,7 +5,7 @@
 #include "en/txrx.h"
 #include "en/port.h"
 #include "en_accel/en_accel.h"
-#include "accel/ipsec_offload.h"
+#include "en_accel/ipsec_offload.h"
 
 static bool mlx5e_rx_is_xdp(struct mlx5e_params *params,
 			    struct mlx5e_xsk_param *xsk)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index eccc13b1338f..a0e9dade09e9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -40,7 +40,7 @@
 #include <net/xfrm.h>
 #include <linux/idr.h>
 
-#include "accel/ipsec_offload.h"
+#include "ipsec_offload.h"
 
 #define MLX5E_IPSEC_SADB_RX_BITS 10
 #define MLX5E_IPSEC_ESN_SCOPE_MID 0x80000000L
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 32093497292f..66b529e36ea1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -2,7 +2,7 @@
 /* Copyright (c) 2020, Mellanox Technologies inc. All rights reserved. */
 
 #include <linux/netdevice.h>
-#include "accel/ipsec_offload.h"
+#include "ipsec_offload.h"
 #include "ipsec_fs.h"
 #include "fs_core.h"
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h
index 3389b3bb3ef8..b3e23aa5beeb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h
@@ -6,7 +6,7 @@
 
 #include "en.h"
 #include "ipsec.h"
-#include "accel/ipsec_offload.h"
+#include "ipsec_offload.h"
 #include "en/fs.h"
 
 #ifdef CONFIG_MLX5_EN_IPSEC
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
similarity index 99%
rename from drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.c
rename to drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 9dbebef19ff0..7ae2d308139e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -2,7 +2,7 @@
 /* Copyright (c) 2017, Mellanox Technologies inc. All rights reserved. */
 
 #include "mlx5_core.h"
-#include "accel/ipsec_offload.h"
+#include "ipsec_offload.h"
 #include "lib/mlx5.h"
 #include "en_accel/ipsec_fs.h"
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.h
similarity index 100%
rename from drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.h
rename to drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.h
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
index 08a6dd4b7662..9b65c765cbd9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
@@ -34,7 +34,7 @@
 #include <crypto/aead.h>
 #include <net/xfrm.h>
 #include <net/esp.h>
-#include "accel/ipsec_offload.h"
+#include "ipsec_offload.h"
 #include "en_accel/ipsec_rxtx.h"
 #include "en_accel/ipsec.h"
 #include "en.h"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_stats.c
index 87c42df3ee20..3aace1c2a763 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_stats.c
@@ -35,7 +35,7 @@
 #include <net/sock.h>
 
 #include "en.h"
-#include "accel/ipsec_offload.h"
+#include "ipsec_offload.h"
 #include "fpga/sdk.h"
 #include "en_accel/ipsec.h"
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 6a3a08fd8910..12b72a0bcb1a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -48,7 +48,7 @@
 #include "en_accel/ipsec.h"
 #include "en_accel/en_accel.h"
 #include "en_accel/ktls.h"
-#include "accel/ipsec_offload.h"
+#include "en_accel/ipsec_offload.h"
 #include "lib/vxlan.h"
 #include "lib/clock.h"
 #include "en/port.h"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index f85eefaad6ab..a5f6fd16b665 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -48,7 +48,7 @@
 #include "en_rep.h"
 #include "en/rep/tc.h"
 #include "ipoib/ipoib.h"
-#include "accel/ipsec_offload.h"
+#include "en_accel/ipsec_offload.h"
 #include "en_accel/ipsec_rxtx.h"
 #include "en_accel/ktls_txrx.h"
 #include "en/xdp.h"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 8fcbb1032b07..032de078723c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -62,7 +62,7 @@
 #include "lib/mlx5.h"
 #include "lib/tout.h"
 #include "fpga/core.h"
-#include "accel/ipsec_offload.h"
+#include "en_accel/ipsec_offload.h"
 #include "lib/clock.h"
 #include "lib/vxlan.h"
 #include "lib/geneve.h"
-- 
2.35.1

