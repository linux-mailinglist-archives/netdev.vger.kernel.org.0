Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD5B6348644
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 02:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239572AbhCYBMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 21:12:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:52334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239547AbhCYBMI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 21:12:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6894961A1D;
        Thu, 25 Mar 2021 01:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616634728;
        bh=lfQTIsxGgK/T6nkf25phdKN+2C5QT/CByloOAt4tPUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GVlhJmp6gPBhUHC4eBk7FF4zGQcs6fq8IPLvP8LWsBh5ZE9sWGNxQjteNcHZJPTiI
         C+VSXPgjOC3IMaCIequJHjxswQa1HUWK65R9tRtlg/XJWybvVbmJp6U1cdGZrWc0r5
         uXWatURUXvStjLE172rniTwm5BrrtDRxvgTG97O5O1yrHkaQkAHFVHVF/D/ZXMGbnL
         8mNj85cTDoKzWswCpN+i4SXiPSIX1YyJu8xZl3ZCd84Hb3+A9LHMj+4nxAtAtN8xdZ
         R1j4M+T0FX8Laq27jG9Sc/FRX0mRA31rZmt7047buH8UHxYNKx0aOwES0viuEzSsmv
         drj3YuQE+CAnA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com,
        michael.chan@broadcom.com, damian.dybek@intel.com,
        paul.greenwalt@intel.com, rajur@chelsio.com,
        jaroslawx.gawin@intel.com, vkochan@marvell.com, alobakin@pm.me,
        snelson@pensando.io, shayagr@amazon.com, ayal@nvidia.com,
        shenjian15@huawei.com, saeedm@nvidia.com, mkubecek@suse.cz,
        andrew@lunn.ch, roopa@nvidia.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/6] ethtool: fec: remove long structure description
Date:   Wed, 24 Mar 2021 18:11:56 -0700
Message-Id: <20210325011200.145818-3-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325011200.145818-1-kuba@kernel.org>
References: <20210325011200.145818-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Digging through the mailing list archive @autoneg was part
of the first version of the RFC, this left over comment was
pointed out twice in review but wasn't removed.

The sentence is an exact copy-paste from pauseparam.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/uapi/linux/ethtool.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 1433d6278018..36bf435d232c 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1377,18 +1377,14 @@ struct ethtool_per_queue_op {
 
 /**
  * struct ethtool_fecparam - Ethernet forward error correction(fec) parameters
  * @cmd: Command number = %ETHTOOL_GFECPARAM or %ETHTOOL_SFECPARAM
  * @active_fec: FEC mode which is active on the port
  * @fec: Bitmask of supported/configured FEC modes
  * @rsvd: Reserved for future extensions. i.e FEC bypass feature.
- *
- * Drivers should reject a non-zero setting of @autoneg when
- * autoneogotiation is disabled (or not supported) for the link.
- *
  */
 struct ethtool_fecparam {
 	__u32   cmd;
 	/* bitmask of FEC modes */
 	__u32   active_fec;
 	__u32   fec;
 	__u32   reserved;
-- 
2.30.2

