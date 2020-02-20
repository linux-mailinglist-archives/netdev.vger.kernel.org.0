Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0849166033
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 15:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbgBTO7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 09:59:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:57266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728105AbgBTO7I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 09:59:08 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E46EA208E4;
        Thu, 20 Feb 2020 14:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582210747;
        bh=ziPjEgeQOxvbQJpZfuqOC1TEya5HzJoGQrdlLqkczqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GGwfGfQKqTThAE2N7Xg+ExK6M/y9c3p615CmVGgg8qa0v498Ttps5w/WbQc/iyhPk
         CwpukAoBLcyws7cKMfAEJnPDBLcwTiW5G0aI5Hovul4bKHuDIiIhRFlvWtXgKHm1GP
         nX1hXjRw0Xj59KbUIYPz3a8TxALqIia0zc/SibDI=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH net-next 02/16] net/dummy: Ditch driver and module versions
Date:   Thu, 20 Feb 2020 16:58:41 +0200
Message-Id: <20200220145855.255704-3-leon@kernel.org>
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

Delete constant driver and module versions in favor standard
global version which is unique to whole kernel.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/dummy.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/dummy.c b/drivers/net/dummy.c
index 3031a5fc5427..bab3a9bb5e6f 100644
--- a/drivers/net/dummy.c
+++ b/drivers/net/dummy.c
@@ -42,7 +42,6 @@
 #include <linux/u64_stats_sync.h>

 #define DRV_NAME	"dummy"
-#define DRV_VERSION	"1.0"

 static int numdummies = 1;

@@ -104,7 +103,6 @@ static void dummy_get_drvinfo(struct net_device *dev,
 			      struct ethtool_drvinfo *info)
 {
 	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 }

 static const struct ethtool_ops dummy_ethtool_ops = {
@@ -212,4 +210,3 @@ module_init(dummy_init_module);
 module_exit(dummy_cleanup_module);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_RTNL_LINK(DRV_NAME);
-MODULE_VERSION(DRV_VERSION);
--
2.24.1

