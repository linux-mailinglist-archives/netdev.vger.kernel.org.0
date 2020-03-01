Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B850174DCA
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 15:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgCAOpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 09:45:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:52620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725874AbgCAOpn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Mar 2020 09:45:43 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E30CE24677;
        Sun,  1 Mar 2020 14:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583073943;
        bh=0WbUEmMc0iVKUuiB5gPVNyuRJ9+wqLwaGQmFXYUCFl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jZllbRFRmjMPujZpDcM0JZXU1nLkxO+nikx1EtZr8P2tCVEdcnHUj1tJTjcmEklgd
         zz8v9GtyOACdFGOwelv11OzhGXMCWUd+IhSSfyPFfLdSWFLo7nVGMknUNuqAQHYf1/
         LBiqC5DWusT6jXOgHss3B4nCDZIn+enSiTvH07dA=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        netdev@vger.kernel.org
Subject: [PATCH net-next 10/23] net/cirrus: Delete driver version
Date:   Sun,  1 Mar 2020 16:44:43 +0200
Message-Id: <20200301144457.119795-11-leon@kernel.org>
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

There is no need in static driver version, use global
linux kernel version instead.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/cirrus/ep93xx_eth.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/cirrus/ep93xx_eth.c b/drivers/net/ethernet/cirrus/ep93xx_eth.c
index f37c9a08c4cf..9f5e5ec69991 100644
--- a/drivers/net/ethernet/cirrus/ep93xx_eth.c
+++ b/drivers/net/ethernet/cirrus/ep93xx_eth.c
@@ -24,7 +24,6 @@
 #include <linux/platform_data/eth-ep93xx.h>
 
 #define DRV_MODULE_NAME		"ep93xx-eth"
-#define DRV_MODULE_VERSION	"0.1"
 
 #define RX_QUEUE_ENTRIES	64
 #define TX_QUEUE_ENTRIES	8
@@ -691,7 +690,6 @@ static int ep93xx_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 static void ep93xx_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
 	strlcpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_MODULE_VERSION, sizeof(info->version));
 }
 
 static int ep93xx_get_link_ksettings(struct net_device *dev,
-- 
2.24.1

