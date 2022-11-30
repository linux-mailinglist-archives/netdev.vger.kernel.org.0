Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A310763CE91
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 06:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233084AbiK3FME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 00:12:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbiK3FMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 00:12:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0585E63CDF
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 21:12:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 971FB619FF
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 05:11:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D41D9C433D6;
        Wed, 30 Nov 2022 05:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669785119;
        bh=cBgJBzoNdaFkoru1R3oh/4yixBxz7No1+7z3a1geK5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L3j2FrL91n5VG0RMipk/cXl0/wMLUSVGfYpzgFvMWfy9oFNOkaUhUkwofqqJmpuoI
         uerjyvigSSYVi8RyBbPrhp3X6sXCtUOdArRflav0HYcRoMjckIOKeZTvTKnFyr+6K2
         0eQMXCfp/AkNc0AqXj9jFAI2ZlzXWW82hcZLXsQIimqAP0xB77i4x0nCFGkoHtMpta
         A+FMd+lJRzJo91eRP6ZVIprdkpwk4M+m4TNwWZtYwduPQBnP4ZvnOFzMEC04ZnpBQy
         dIVCb8tDIgeyKe3sF5WZKcXEib6nlPDY7mS6XXt/ofpM5upXInH80xy61DR8IDsIQw
         Isk77sqfH1gcQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>
Subject: [net-next 01/15] net/mlx5e: Remove unneeded io-mapping.h #include
Date:   Tue, 29 Nov 2022 21:11:38 -0800
Message-Id: <20221130051152.479480-2-saeed@kernel.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

The mlx5 net files don't use io_mapping functionalities. So there is no
point in including <linux/io-mapping.h>.
Remove it.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c  | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/uar.c  | 1 -
 3 files changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index e7a894ba5c3e..d3ca745d107d 100644
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
2.38.1

