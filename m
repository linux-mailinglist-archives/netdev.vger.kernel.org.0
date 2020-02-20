Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19BA2166038
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 15:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbgBTO7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 09:59:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:57396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728054AbgBTO7Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 09:59:25 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1247F206F4;
        Thu, 20 Feb 2020 14:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582210764;
        bh=7CICMqnQF7xoeXIcHQwwcYQyrJAiXAKQVpcrdIOkVs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NQ1k5xa+D2GLq9gBsr/GwA1a0252bMgx8wp92GA3Y13ikhMKAJmcyRyVaBVjREknW
         LQoY2BY40Jw126E2BjoezewPRVPeeXtuGSDffRqCjHzIRVrbDJxUgM8dmnNWA5y+b2
         VI7eCprtfhRnAklpVWNweMiD0jIM9ZLmeYpKB20M=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH net-next 08/16] net/allwinner: Remove driver version
Date:   Thu, 20 Feb 2020 16:58:47 +0200
Message-Id: <20200220145855.255704-9-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200220145855.255704-1-leon@kernel.org>
References: <20200220145855.255704-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

There is no need in custom driver version for in-tree code.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/allwinner/sun4i-emac.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/ethernet/allwinner/sun4i-emac.c
index 22cadfbeedfb..18d3b4340bd4 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -33,7 +33,6 @@
 #include "sun4i-emac.h"

 #define DRV_NAME		"sun4i-emac"
-#define DRV_VERSION		"1.02"

 #define EMAC_MAX_FRAME_LEN	0x0600

@@ -212,7 +211,6 @@ static void emac_get_drvinfo(struct net_device *dev,
 			      struct ethtool_drvinfo *info)
 {
 	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 	strlcpy(info->bus_info, dev_name(&dev->dev), sizeof(info->bus_info));
 }

--
2.24.1

