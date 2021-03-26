Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDFEE349F52
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 03:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbhCZCHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 22:07:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:50684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230045AbhCZCHe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 22:07:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE22C61A42;
        Fri, 26 Mar 2021 02:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616724454;
        bh=G4GzRaGULdPY6SQAzChSDbeQZP9ITOBq/B1QcSkovEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OnLmvoC5bwJHv7qZWVPdNbBINgFyLh+gMAvfGO7GiyEFvGiAW5VkZnLcOqGn/3EK7
         DT+1Z1Nh/2lZMpHVjrxSVLFrUGez+X+CkBiC+okRE9427m4PrPPnDbKhynfiHyH2sG
         buy4ODECSWlfA+ILjxh7QevlWurQlZwVR20NGACNk2vKrEBlmiNQUbmI9muHfiil2n
         uUWa+E4SPFDhQypucMeHi/OQoQu5KU1u4Zl/juhLNWC6fon6ThXqAVVGkFFiHmwkze
         yoMH2yVfz6HgwyrTRGz+XNsFGuiECVCwhBazdK/dXRmq6Fha5yf2pU2N9Y324Inv8h
         RPgkcN+S6AA0w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com,
        michael.chan@broadcom.com, paul.greenwalt@intel.com,
        rajur@chelsio.com, jaroslawx.gawin@intel.com, vkochan@marvell.com,
        alobakin@pm.me, snelson@pensando.io, shayagr@amazon.com,
        ayal@nvidia.com, shenjian15@huawei.com, saeedm@nvidia.com,
        mkubecek@suse.cz, andrew@lunn.ch, roopa@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 1/6] ethtool: fec: fix typo in kdoc
Date:   Thu, 25 Mar 2021 19:07:22 -0700
Message-Id: <20210326020727.246828-2-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210326020727.246828-1-kuba@kernel.org>
References: <20210326020727.246828-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/porte/the port/

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
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

