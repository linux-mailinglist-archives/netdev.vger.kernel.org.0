Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6088D639BB1
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 17:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbiK0QRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 11:17:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiK0QQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 11:16:59 -0500
Received: from smtp.smtpout.orange.fr (smtp-20.smtpout.orange.fr [80.12.242.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9F8EE08
        for <netdev@vger.kernel.org>; Sun, 27 Nov 2022 08:16:58 -0800 (PST)
Received: from pop-os.home ([86.243.100.34])
        by smtp.orange.fr with ESMTPA
        id zKKsod9JE8GHKzKKtoB4sH; Sun, 27 Nov 2022 17:16:56 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 27 Nov 2022 17:16:56 +0100
X-ME-IP: 86.243.100.34
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH] net/mlx5e: Remove unneeded io-mapping.h #include
Date:   Sun, 27 Nov 2022 17:16:52 +0100
Message-Id: <7779439b2678fffe7d3e4e0d94bbb1b1eb850f5e.1669565797.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mlx5 net files don't use io_mapping functionalities. So there is no
point in including <linux/io-mapping.h>.
Remove it.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c  | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/uar.c  | 1 -
 3 files changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 74bd05e5dda2..597907fd63f5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -37,7 +37,6 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/random.h>
-#include <linux/io-mapping.h>
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/eq.h>
 #include <linux/debugfs.h>
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 70e8dc305bec..25e87e5d9270 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -37,7 +37,6 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
-#include <linux/io-mapping.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/mlx5/driver.h>
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/uar.c b/drivers/net/ethernet/mellanox/mlx5/core/uar.c
index 8455e79bc44a..1513112ecec8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/uar.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/uar.c
@@ -31,7 +31,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/io-mapping.h>
 #include <linux/mlx5/driver.h>
 #include "mlx5_core.h"
 
-- 
2.34.1

