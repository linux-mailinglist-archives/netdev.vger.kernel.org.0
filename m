Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53CC22D0231
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 10:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725800AbgLFJNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 04:13:54 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:34330 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725772AbgLFJNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Dec 2020 04:13:54 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@nvidia.com)
        with SMTP; 6 Dec 2020 11:13:07 +0200
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.234.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0B69D6WZ011439;
        Sun, 6 Dec 2020 11:13:06 +0200
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next] net/mlx4: Remove unused #define MAX_MSIX_P_PORT
Date:   Sun,  6 Dec 2020 11:12:54 +0200
Message-Id: <20201206091254.12476-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

All usages of the definition MAX_MSIX_P_PORT were removed.
It's not in use anymore. Remove it.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
---
 include/linux/mlx4/device.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 06e066e04a4b..236a7d04f891 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -46,7 +46,6 @@
 
 #define DEFAULT_UAR_PAGE_SHIFT  12
 
-#define MAX_MSIX_P_PORT		17
 #define MAX_MSIX		128
 #define MIN_MSIX_P_PORT		5
 #define MLX4_IS_LEGACY_EQ_MODE(dev_cap) ((dev_cap).num_comp_vectors < \
-- 
2.21.0

