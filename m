Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF9AF174DD6
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 15:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbgCAOqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 09:46:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:53034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726579AbgCAOqM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Mar 2020 09:46:12 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A42E024672;
        Sun,  1 Mar 2020 14:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583073972;
        bh=Gu+6rI4BoIVuAF3FmEaf/irnn44sm9OSGO1GPPoDXwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QlgiDNM8nr/byrCyLpxb5dBl5psImCighVtNPw56UYi/sUhfLrjqhiF+pXA+q9/++
         aLgHTSb/jjBDOMO26RA7pd4yZMzrgpv4bM2/e/iD0alllAoNbWQKZ8eL3Wywb9K+VV
         PbWeEAtiQuUVCtNaFto/DHjvdUrkScIXQSLhYbkg=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 23/23] net/freescale: Don't set zero if FW iand bus not-available in gianfar
Date:   Sun,  1 Mar 2020 16:44:56 +0200
Message-Id: <20200301144457.119795-24-leon@kernel.org>
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

Rely on ethtool to properly present the fact that FW and bus
are not available for the gianfar driver.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/freescale/gianfar_ethtool.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/drivers/net/ethernet/freescale/gianfar_ethtool.c
index 7b69e80d6b30..a7cc371ee94f 100644
--- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
+++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
@@ -164,8 +164,6 @@ static void gfar_gdrvinfo(struct net_device *dev,
 			  struct ethtool_drvinfo *drvinfo)
 {
 	strlcpy(drvinfo->driver, DRV_NAME, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->fw_version, "N/A", sizeof(drvinfo->fw_version));
-	strlcpy(drvinfo->bus_info, "N/A", sizeof(drvinfo->bus_info));
 }
 
 /* Return the length of the register structure */
-- 
2.24.1

