Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73355174DC9
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 15:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgCAOpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 09:45:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:52564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725874AbgCAOpk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Mar 2020 09:45:40 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8888222C4;
        Sun,  1 Mar 2020 14:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583073940;
        bh=GQNKmsPlsxMjsAxf21hCJ88FEP21DLfSn8NM+bSkMk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=grFeduOOsy4VJ9KQZnmU6gG3t9KxPlvuwe3lpEZEPYYc/aEEKSmmM9Y/6NARWRBb6
         YMiKciGtd+tPZf0ndhThY5Zt9j6ek9LXqSp3z0aWiCW0WWXMFiHjSguTiRPJBx+9dl
         t8p+rp9yXimoFFL7+XnWH8zfAloM4SpUwo1hb4iI=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 13/23] net/davicom: Delete ethtool version assignment
Date:   Sun,  1 Mar 2020 16:44:46 +0200
Message-Id: <20200301144457.119795-14-leon@kernel.org>
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

Rely on global linux kernel version instead of static value.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/davicom/dm9000.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
index e94ae9b94dbf..7f7705138262 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -42,7 +42,6 @@
 #define DM9000_PHY		0x40	/* PHY address 0x01 */
 
 #define CARDNAME	"dm9000"
-#define DRV_VERSION	"1.31"
 
 /*
  * Transmit timeout, default 5 seconds.
@@ -543,7 +542,6 @@ static void dm9000_get_drvinfo(struct net_device *dev,
 	struct board_info *dm = to_dm9000_board(dev);
 
 	strlcpy(info->driver, CARDNAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 	strlcpy(info->bus_info, to_platform_device(dm->dev)->name,
 		sizeof(info->bus_info));
 }
-- 
2.24.1

