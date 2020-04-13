Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6979C1A6815
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 16:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730725AbgDMOYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 10:24:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:51394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730714AbgDMOYB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 10:24:01 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A86432075E;
        Mon, 13 Apr 2020 14:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586787840;
        bh=xm9eVyHG//dJZJ+9KzGmV/4o3KKdc7mpE/Q1MMT6Mvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uNS26jsoeZ2H2m0FlxUf+FTnS1+rSw1Gmf5BJmDquRVUbVKTUqP0DYm5IqTqF2oTL
         jNUSFifwoeQUVaDD7ZNwpA2pYW1R/a5wA8Zpar/pcEN/0BvFoxCP/nxapg2AZjAkml
         byc/QjH15JJtmtea88fWQwe8xiAX17pj48P28oGM=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 11/13] net/mlx5: Delete not-used cmd header
Date:   Mon, 13 Apr 2020 17:23:06 +0300
Message-Id: <20200413142308.936946-12-leon@kernel.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200413142308.936946-1-leon@kernel.org>
References: <20200413142308.936946-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

The structures defined in the cmd header are not used and can be safely
removed from the driver. This patch removes that file and deletes all
relevant includes.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/mad.c                       | 1 -
 drivers/infiniband/hw/mlx5/srq_cmd.c                   | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/cq.c           | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/eq.c           | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/fpga/cmd.c     | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/fw.c           | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/health.c       | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/mcg.c          | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/mr.c           | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c    | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/pd.c           | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/qp.c           | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/rl.c           | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/uar.c          | 1 -
 15 files changed, 15 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mad.c b/drivers/infiniband/hw/mlx5/mad.c
index 14e0c17de6a9..f0ab6d7d8497 100644
--- a/drivers/infiniband/hw/mlx5/mad.c
+++ b/drivers/infiniband/hw/mlx5/mad.c
@@ -30,7 +30,6 @@
  * SOFTWARE.
  */
 
-#include <linux/mlx5/cmd.h>
 #include <linux/mlx5/vport.h>
 #include <rdma/ib_mad.h>
 #include <rdma/ib_smi.h>
diff --git a/drivers/infiniband/hw/mlx5/srq_cmd.c b/drivers/infiniband/hw/mlx5/srq_cmd.c
index 8fc3630a9d4c..88c0388f9fc6 100644
--- a/drivers/infiniband/hw/mlx5/srq_cmd.c
+++ b/drivers/infiniband/hw/mlx5/srq_cmd.c
@@ -5,7 +5,6 @@
 
 #include <linux/kernel.h>
 #include <linux/mlx5/driver.h>
-#include <linux/mlx5/cmd.h>
 #include "mlx5_ib.h"
 #include "srq.h"
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cq.c b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
index 818edc63e428..4477a590b308 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
@@ -34,7 +34,6 @@
 #include <linux/module.h>
 #include <linux/hardirq.h>
 #include <linux/mlx5/driver.h>
-#include <linux/mlx5/cmd.h>
 #include <rdma/ib_verbs.h>
 #include <linux/mlx5/cq.h>
 #include "mlx5_core.h"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index cccea3a8eddd..bee419d01af2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -36,7 +36,6 @@
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/vport.h>
 #include <linux/mlx5/eq.h>
-#include <linux/mlx5/cmd.h>
 #ifdef CONFIG_RFS_ACCEL
 #include <linux/cpu_rmap.h>
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/cmd.c
index c0fd2212e890..09769401c313 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/cmd.c
@@ -31,7 +31,6 @@
  */
 
 #include <linux/etherdevice.h>
-#include <linux/mlx5/cmd.h>
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/device.h>
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
index 90e3d0233101..3040e0466681 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -31,7 +31,6 @@
  */
 
 #include <linux/mlx5/driver.h>
-#include <linux/mlx5/cmd.h>
 #include <linux/mlx5/eswitch.h>
 #include <linux/module.h>
 #include "mlx5_core.h"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index fa1665caac46..3ae355453464 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -36,7 +36,6 @@
 #include <linux/vmalloc.h>
 #include <linux/hardirq.h>
 #include <linux/mlx5/driver.h>
-#include <linux/mlx5/cmd.h>
 #include "mlx5_core.h"
 #include "lib/eq.h"
 #include "lib/mlx5.h"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c
index 48b5c847b642..8809a65ecefb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c
@@ -4,7 +4,6 @@
 #include <linux/module.h>
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/port.h>
-#include <linux/mlx5/cmd.h>
 #include "mlx5_core.h"
 #include "lib/port_tun.h"
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mcg.c b/drivers/net/ethernet/mellanox/mlx5/core/mcg.c
index ba2b09cc192f..6789fe658037 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mcg.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mcg.c
@@ -33,7 +33,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mlx5/driver.h>
-#include <linux/mlx5/cmd.h>
 #include <rdma/ib_verbs.h>
 #include "mlx5_core.h"
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mr.c b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
index 366f2cbfc6db..1feedf335dea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
@@ -33,7 +33,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mlx5/driver.h>
-#include <linux/mlx5/cmd.h>
 #include "mlx5_core.h"
 
 int mlx5_core_create_mkey(struct mlx5_core_dev *dev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index 91bd258ecf1b..a3959754b927 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -35,7 +35,6 @@
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/mlx5/driver.h>
-#include <linux/mlx5/cmd.h>
 #include "mlx5_core.h"
 #include "lib/eq.h"
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pd.c b/drivers/net/ethernet/mellanox/mlx5/core/pd.c
index bd830d8d6c5f..b92d6f621c83 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pd.c
@@ -33,7 +33,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mlx5/driver.h>
-#include <linux/mlx5/cmd.h>
 #include "mlx5_core.h"
 
 int mlx5_core_alloc_pd(struct mlx5_core_dev *dev, u32 *pdn)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/qp.c b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
index e36790ad5256..d9df3a5dd532 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
@@ -32,7 +32,6 @@
 
 #include <linux/gfp.h>
 #include <linux/export.h>
-#include <linux/mlx5/cmd.h>
 #include <linux/mlx5/qp.h>
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/transobj.h>
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/rl.c b/drivers/net/ethernet/mellanox/mlx5/core/rl.c
index f3b29d9ade1f..c9599f7c5696 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/rl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/rl.c
@@ -33,7 +33,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mlx5/driver.h>
-#include <linux/mlx5/cmd.h>
 #include "mlx5_core.h"
 
 /* Scheduling element fw management */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/uar.c b/drivers/net/ethernet/mellanox/mlx5/core/uar.c
index 0d006224d7b0..816f9c434359 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/uar.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/uar.c
@@ -34,7 +34,6 @@
 #include <linux/module.h>
 #include <linux/io-mapping.h>
 #include <linux/mlx5/driver.h>
-#include <linux/mlx5/cmd.h>
 #include "mlx5_core.h"
 
 int mlx5_cmd_alloc_uar(struct mlx5_core_dev *dev, u32 *uarn)
-- 
2.25.2

