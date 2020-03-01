Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E683D174DD1
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 15:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgCAOqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 09:46:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:52842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726954AbgCAOp7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Mar 2020 09:45:59 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A565C222C4;
        Sun,  1 Mar 2020 14:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583073959;
        bh=yenWz8BchI84GkC+Hn+D/76fjJSi2RJKhkKXec3PBZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I2rdv4uBTGJ8U2lcwkE/pS6D4STwjVyYX7yWZZ1HTweCJwysFdeiNSOKawTLxss//
         xgmSjmUmT0Iba2ClOcz7yCl61TK0PbxLLPvAqNnjLTO20ma8fCclDopgfj6u60iTaz
         hAnAEmgLFjRkq0V/EsdIDU9aFwgLbSGp9V3QBqqc=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 18/23] net/faraday: Delete driver version from the drivers
Date:   Sun,  1 Mar 2020 16:44:51 +0200
Message-Id: <20200301144457.119795-19-leon@kernel.org>
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

Use general linux kernel version instead of static driver version.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/faraday/ftgmac100.c | 2 --
 drivers/net/ethernet/faraday/ftmac100.c  | 3 ---
 2 files changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 4572797f00d7..71a7709f7cc8 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -30,7 +30,6 @@
 #include "ftgmac100.h"
 
 #define DRV_NAME	"ftgmac100"
-#define DRV_VERSION	"0.7"
 
 /* Arbitrary values, I am not sure the HW has limits */
 #define MAX_RX_QUEUE_ENTRIES	1024
@@ -1150,7 +1149,6 @@ static void ftgmac100_get_drvinfo(struct net_device *netdev,
 				  struct ethtool_drvinfo *info)
 {
 	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 	strlcpy(info->bus_info, dev_name(&netdev->dev), sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/faraday/ftmac100.c b/drivers/net/ethernet/faraday/ftmac100.c
index 6c247cbbd23e..32cf54f0e35b 100644
--- a/drivers/net/ethernet/faraday/ftmac100.c
+++ b/drivers/net/ethernet/faraday/ftmac100.c
@@ -23,7 +23,6 @@
 #include "ftmac100.h"
 
 #define DRV_NAME	"ftmac100"
-#define DRV_VERSION	"0.2"
 
 #define RX_QUEUE_ENTRIES	128	/* must be power of 2 */
 #define TX_QUEUE_ENTRIES	16	/* must be power of 2 */
@@ -809,7 +808,6 @@ static void ftmac100_get_drvinfo(struct net_device *netdev,
 				 struct ethtool_drvinfo *info)
 {
 	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 	strlcpy(info->bus_info, dev_name(&netdev->dev), sizeof(info->bus_info));
 }
 
@@ -1184,7 +1182,6 @@ static struct platform_driver ftmac100_driver = {
  *****************************************************************************/
 static int __init ftmac100_init(void)
 {
-	pr_info("Loading version " DRV_VERSION " ...\n");
 	return platform_driver_register(&ftmac100_driver);
 }
 
-- 
2.24.1

