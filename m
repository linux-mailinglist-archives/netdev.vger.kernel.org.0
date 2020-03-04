Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE62179507
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 17:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388295AbgCDQYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 11:24:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:42336 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388254AbgCDQYW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 11:24:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 51662ADB3;
        Wed,  4 Mar 2020 16:24:20 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 04235E037F; Wed,  4 Mar 2020 17:24:19 +0100 (CET)
Message-Id: <4c410fbb93c84d801c267be68799101036715ecb.1583337972.git.mkubecek@suse.cz>
In-Reply-To: <cover.1583337972.git.mkubecek@suse.cz>
References: <cover.1583337972.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next 5/5] tun: drop TUN_DEBUG and tun_debug()
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Date:   Wed,  4 Mar 2020 17:24:20 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TUN_DEBUG and tun_debug() are no longer used anywhere, drop them.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 drivers/net/tun.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 42110aba0014..4689e4c62e21 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -75,23 +75,6 @@
 static void tun_default_link_ksettings(struct net_device *dev,
 				       struct ethtool_link_ksettings *cmd);
 
-/* Uncomment to enable debugging */
-/* #define TUN_DEBUG 1 */
-
-#ifdef TUN_DEBUG
-#define tun_debug(level, tun, fmt, args...)			\
-do {								\
-	if (tun->msg_enable)					\
-		netdev_printk(level, tun->dev, fmt, ##args);	\
-} while (0)
-#else
-#define tun_debug(level, tun, fmt, args...)			\
-do {								\
-	if (0)							\
-		netdev_printk(level, tun->dev, fmt, ##args);	\
-} while (0)
-#endif
-
 #define TUN_RX_PAD (NET_IP_ALIGN + NET_SKB_PAD)
 
 /* TUN device flags */
-- 
2.25.1

