Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D77CD174DCE
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 15:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgCAOpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 09:45:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:52728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726954AbgCAOpx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Mar 2020 09:45:53 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CFC2222C4;
        Sun,  1 Mar 2020 14:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583073953;
        bh=wxrzzDx9iWEw0EqKpq2fz331x9XcQ9L7+ZHQlZrWSnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CbVn08jufux2a6W9ZqV6lY6fPcBEZIff8OWd1ewnZErp7cZSGB0iLqbQiCWAiFLW7
         HTwj7niRZ7a25tzpu3OOkIe8gR83OJlwwP4s8ZJbP+IreGDPKjXoY+pjfbUwJWOS6K
         J8q9lKsaoxVMs1DZOcWp6Gx6mwvaNeCwkJFQtZ2E=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 16/23] net/dnet: Delete static version from the driver
Date:   Sun,  1 Mar 2020 16:44:49 +0200
Message-Id: <20200301144457.119795-17-leon@kernel.org>
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

Remove static driver version from the ethtool output.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/dnet.c | 1 -
 drivers/net/ethernet/dnet.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/dnet.c b/drivers/net/ethernet/dnet.c
index 5f8fa1145db6..057a508dd6e2 100644
--- a/drivers/net/ethernet/dnet.c
+++ b/drivers/net/ethernet/dnet.c
@@ -729,7 +729,6 @@ static void dnet_get_drvinfo(struct net_device *dev,
 			     struct ethtool_drvinfo *info)
 {
 	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 	strlcpy(info->bus_info, "0", sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/dnet.h b/drivers/net/ethernet/dnet.h
index 8af6c0705ab3..030724484b49 100644
--- a/drivers/net/ethernet/dnet.h
+++ b/drivers/net/ethernet/dnet.h
@@ -8,7 +8,6 @@
 #define _DNET_H
 
 #define DRV_NAME		"dnet"
-#define DRV_VERSION		"0.9.1"
 #define PFX				DRV_NAME ": "
 
 /* Register access macros */
-- 
2.24.1

