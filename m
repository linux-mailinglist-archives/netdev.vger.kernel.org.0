Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C044C4D5C91
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 08:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343840AbiCKHlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 02:41:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242370AbiCKHlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 02:41:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA9B1B756A
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 23:40:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C14261E00
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 07:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D9FC340EC;
        Fri, 11 Mar 2022 07:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646984441;
        bh=vXLTyiNN58/pypcICM9w2PJKLtVFNhJ/t80YQyrrZO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NZWZA/Z0AlMtXbQfXIV/d3M0Fh85zHjK41AfcMtUxNNkl6/KXvztiGMMW+vuvP7dH
         i6j3kZKpbNqflrOGsXNoIIX8SOAYhn9tXTcAE/RyJpCThAJMOL3MQUyv+gOdHRM8vt
         ExggamnxtBi2evi9XJgi9vtbyCzrn5qxURLejfhRq61bu+eyr9AN96GytzU6awOOp9
         GeZjxyK1ln0/FSs3d79o/4DlAwAhuaBfoY3hSs3eg/3N2STk+BzrtLK6+8vqcNZHx4
         PW7/3edT97raIMhcmc3wH5VSwAGG9CEdTMlr9VfatNrnqgOSE2PA9df02b0/NogiLR
         nb0Z673q7kNRQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/15] net/mlx5: Delete useless module.h include
Date:   Thu, 10 Mar 2022 23:40:18 -0800
Message-Id: <20220311074031.645168-3-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220311074031.645168-1-saeed@kernel.org>
References: <20220311074031.645168-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

There is no need in include of module.h in the following files.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c             | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/cq.c              | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c         | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c  | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/eq.c              | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c       | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/fw.c              | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/health.c          | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c    | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c       | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/mcg.c             | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/mr.c              | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c       | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c         | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/pd.c              | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/rl.c              | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/uar.c             | 1 -
 18 files changed, 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 989e7cb48a95..c2462d37f1b3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -31,7 +31,6 @@
  */
 
 #include <linux/highmem.h>
-#include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cq.c b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
index 15a74966be7d..4caa1b6f40ba 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
@@ -31,7 +31,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/module.h>
 #include <linux/hardirq.h>
 #include <linux/mlx5/driver.h>
 #include <rdma/ib_verbs.h>
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
index d69bac93a83b..3d3e55a5cb11 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
@@ -30,7 +30,6 @@
  * SOFTWARE.
  */
 
-#include <linux/module.h>
 #include <linux/debugfs.h>
 #include <linux/mlx5/qp.h>
 #include <linux/mlx5/cq.h>
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 7cab08a2f715..299e3f0fcb5c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -35,7 +35,6 @@
 #include <crypto/aead.h>
 #include <linux/inetdevice.h>
 #include <linux/netdevice.h>
-#include <linux/module.h>
 
 #include "en.h"
 #include "en_accel/ipsec.h"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 48a45aa54a3c..cb4730cb456a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -5,7 +5,6 @@
 
 #include <linux/interrupt.h>
 #include <linux/notifier.h>
-#include <linux/module.h>
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/vport.h>
 #include <linux/mlx5/eq.h>
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c
index 2ce4241459ce..39c03dcbd196 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c
@@ -30,7 +30,6 @@
  * SOFTWARE.
  */
 
-#include <linux/module.h>
 #include <linux/etherdevice.h>
 #include <linux/mlx5/driver.h>
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
index 2d8406fab844..614687e0e3d9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -32,7 +32,6 @@
 
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/eswitch.h>
-#include <linux/module.h>
 #include "mlx5_core.h"
 #include "../../mlxfw/mlxfw.h"
 #include "lib/tout.h"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index 737df402c927..659021c31cbd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -31,7 +31,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/module.h>
 #include <linux/random.h>
 #include <linux/vmalloc.h>
 #include <linux/hardirq.h>
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c
index e042e0924079..4571c56ec3c9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c
@@ -1,7 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
 /* Copyright (c) 2019 Mellanox Technologies. */
 
-#include <linux/module.h>
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/port.h>
 #include "mlx5_core.h"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
index e3b0a131c3e1..d55e15c1f380 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
@@ -31,7 +31,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/module.h>
 #include <linux/refcount.h>
 #include <linux/mlx5/driver.h>
 #include <net/vxlan.h>
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mcg.c b/drivers/net/ethernet/mellanox/mlx5/core/mcg.c
index e019d68062d8..495cca58dccc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mcg.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mcg.c
@@ -31,7 +31,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/module.h>
 #include <linux/mlx5/driver.h>
 #include <rdma/ib_verbs.h>
 #include "mlx5_core.h"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mr.c b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
index f099a087400e..9d735c343a3b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
@@ -31,7 +31,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/module.h>
 #include <linux/mlx5/driver.h>
 #include "mlx5_core.h"
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index e0543b860144..ec76a8b1acc1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -32,7 +32,6 @@
 
 #include <linux/highmem.h>
 #include <linux/kernel.h>
-#include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/mlx5/driver.h>
 #include <linux/xarray.h>
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 41807ef55201..351ea0a41a03 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -3,7 +3,6 @@
 
 #include <linux/interrupt.h>
 #include <linux/notifier.h>
-#include <linux/module.h>
 #include <linux/mlx5/driver.h>
 #include "mlx5_core.h"
 #include "mlx5_irq.h"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pd.c b/drivers/net/ethernet/mellanox/mlx5/core/pd.c
index aabc53ad8bdd..ee5ffdeb9015 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pd.c
@@ -31,7 +31,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/module.h>
 #include <linux/mlx5/driver.h>
 #include "mlx5_core.h"
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/rl.c b/drivers/net/ethernet/mellanox/mlx5/core/rl.c
index 7161220afe30..9f8b4005f4bd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/rl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/rl.c
@@ -31,7 +31,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/module.h>
 #include <linux/mlx5/driver.h>
 #include "mlx5_core.h"
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c
index 2e8b109fb34e..d232f1ea34a2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c
@@ -3,7 +3,6 @@
 
 #include <linux/debugfs.h>
 #include <linux/kernel.h>
-#include <linux/module.h>
 #include <linux/seq_file.h>
 #include "dr_types.h"
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/uar.c b/drivers/net/ethernet/mellanox/mlx5/core/uar.c
index 01e9c412977c..9c81fb7c2c3c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/uar.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/uar.c
@@ -31,7 +31,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/module.h>
 #include <linux/io-mapping.h>
 #include <linux/mlx5/driver.h>
 #include "mlx5_core.h"
-- 
2.35.1

