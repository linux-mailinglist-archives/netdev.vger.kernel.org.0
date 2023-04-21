Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98FE46EA121
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 03:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233140AbjDUBkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 21:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233206AbjDUBj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 21:39:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4DE56A7B
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 18:39:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67B2C646C1
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 01:39:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3F7C433D2;
        Fri, 21 Apr 2023 01:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682041189;
        bh=dWF/2XIke8HfR+5sgA1O9mVjlV1FnK7siWZ60W9hI/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NFKpi3kkoSFXSCYIuyPnPo38jHmvmQNa3hA91h2tllmFvWhabKUYPjOLyvzBnsqoS
         Rl75Vh3R/xY4Doeor0SIgXbhpU0t7Y8aVsvVfL5Zz7ECks2SUAkqq0xEqpXI02OsNy
         aOnfTpYwVyFJpA/l59fl1odnWrlSV9DQ9Sugq0YgwzGRDoSQtUs+mnWBcA0VwJCCKj
         He6D/e9HSPodoBbyz/uY5GL4iix5wBgKPRPFjWnE844JT5vucpMef6n3HEtNeADVjh
         kzEvrJB0lm32HsjP6fCDtUzXuHicWtvKJWCLv7thKAUfLaAihbnaDR/l87QGkwMM2H
         Sbk84m8br6bbg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        kernel test robot <lkp@intel.com>
Subject: [net-next 12/15] net/mlx5: Include linux/pci.h for pci_msix_can_alloc_dyn()
Date:   Thu, 20 Apr 2023 18:38:47 -0700
Message-Id: <20230421013850.349646-13-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230421013850.349646-1-saeed@kernel.org>
References: <20230421013850.349646-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,TVD_SPACE_RATIO,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

Add include directive to assure pci_msix_can_alloc_dyn() prototype.

Fixes: 3354822cde5a ("net/mlx5: Use dynamic msix vectors allocation")
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/oe-kbuild-all/202303291328.sNmTyyWF-lkp@intel.com/
Signed-off-by: Eli Cohen <elic@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index e12e528c09f5..2245d3b2f393 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 /* Copyright (c) 2019 Mellanox Technologies. */
 
+#include <linux/pci.h>
 #include <linux/interrupt.h>
 #include <linux/notifier.h>
 #include <linux/mlx5/driver.h>
-- 
2.39.2

