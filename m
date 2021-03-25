Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A73CB348646
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 02:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239568AbhCYBMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 21:12:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:52304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239546AbhCYBMH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 21:12:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BC3F61A18;
        Thu, 25 Mar 2021 01:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616634727;
        bh=5Qgbif0kiDvbA9CA4CjJ/BGxTnwNb4TNSg6d5fPIxsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r/BEgMxeVtXsi+dSevkFOTZRSwrmZvi1RoO3+pxSjaChFGclxQf+B9HBIY9sr2WqU
         mFvfMQf67zB/Fpg0a2WlvRXKk05S/VkEDqGqX4+vhc2FY9Z53xX4/XHLjzVtQQiBwS
         G9wHDgYK6IDqKKxvOfl7Wk3aJzCz+tB6xnlsXvQJ1uRwkTH+hCpGRPyRaulM/AIbCE
         wsss5RYOeIa/svN4oAW0+bVZ2ekoDoeKwoKEJvjxirp2/qdNquBEUr7g/2TDdRajXf
         uor5bNr08R/EyQveCAbYna03TQ4ZT48CtkURC1zOwpcG0FyMdjuYrckiFHkcBqOnKt
         HUbrUBpuHsKGw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com,
        michael.chan@broadcom.com, damian.dybek@intel.com,
        paul.greenwalt@intel.com, rajur@chelsio.com,
        jaroslawx.gawin@intel.com, vkochan@marvell.com, alobakin@pm.me,
        snelson@pensando.io, shayagr@amazon.com, ayal@nvidia.com,
        shenjian15@huawei.com, saeedm@nvidia.com, mkubecek@suse.cz,
        andrew@lunn.ch, roopa@nvidia.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/6] ethtool: fec: fix typo in kdoc
Date:   Wed, 24 Mar 2021 18:11:55 -0700
Message-Id: <20210325011200.145818-2-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325011200.145818-1-kuba@kernel.org>
References: <20210325011200.145818-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/porte/the port/

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/uapi/linux/ethtool.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index cde753bb2093..1433d6278018 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1374,15 +1374,15 @@ struct ethtool_per_queue_op {
 	__u32	queue_mask[__KERNEL_DIV_ROUND_UP(MAX_NUM_QUEUE, 32)];
 	char	data[];
 };
 
 /**
  * struct ethtool_fecparam - Ethernet forward error correction(fec) parameters
  * @cmd: Command number = %ETHTOOL_GFECPARAM or %ETHTOOL_SFECPARAM
- * @active_fec: FEC mode which is active on porte
+ * @active_fec: FEC mode which is active on the port
  * @fec: Bitmask of supported/configured FEC modes
  * @rsvd: Reserved for future extensions. i.e FEC bypass feature.
  *
  * Drivers should reject a non-zero setting of @autoneg when
  * autoneogotiation is disabled (or not supported) for the link.
  *
  */
-- 
2.30.2

