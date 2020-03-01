Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89450174DD4
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 15:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgCAOqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 09:46:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:52988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726602AbgCAOqJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Mar 2020 09:46:09 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90FDC222C4;
        Sun,  1 Mar 2020 14:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583073969;
        bh=eW9goID7xop2rWV+k9gS1/7fT5RXysT+YLxP6eO8qM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hImu+rYiVNjzPyBsajCyg5LBYgKlvCWiTkHrMXtAOQzejzc1QuitzKIcjRE+1Oc6+
         dKXk1Ns9rHew7w9Ne+ljlcrZrh5XSbDg/2Vycxobt9NSKGSApRQONvnB2EF//qI3Wt
         3bDhiN9WnpbcMOQVijqpdZ5DKm4ggwUpkEof/gjA=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        linuxppc-dev@lists.ozlabs.org, Li Yang <leoyang.li@nxp.com>,
        netdev@vger.kernel.org
Subject: [PATCH net-next 22/23] net/freescale: Don't set zero if FW not-available in ucc_geth
Date:   Sun,  1 Mar 2020 16:44:55 +0200
Message-Id: <20200301144457.119795-23-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200301144457.119795-1-leon@kernel.org>
References: <20200301144457.119795-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Rely on ethtool to properly present the fact that FW is not
available for the ucc_geth driver.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/freescale/ucc_geth_ethtool.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth_ethtool.c b/drivers/net/ethernet/freescale/ucc_geth_ethtool.c
index bc7ba70d176c..14c08a868190 100644
--- a/drivers/net/ethernet/freescale/ucc_geth_ethtool.c
+++ b/drivers/net/ethernet/freescale/ucc_geth_ethtool.c
@@ -334,7 +334,6 @@ uec_get_drvinfo(struct net_device *netdev,
                        struct ethtool_drvinfo *drvinfo)
 {
 	strlcpy(drvinfo->driver, DRV_NAME, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->fw_version, "N/A", sizeof(drvinfo->fw_version));
 	strlcpy(drvinfo->bus_info, "QUICC ENGINE", sizeof(drvinfo->bus_info));
 }
 
-- 
2.24.1

