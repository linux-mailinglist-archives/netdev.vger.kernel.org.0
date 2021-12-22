Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 891A147D484
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 16:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343850AbhLVP56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 10:57:58 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:47309 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343813AbhLVP5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 10:57:52 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 2E1C960007;
        Wed, 22 Dec 2021 15:57:50 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        <linux-kernel@vger.kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [net-next 04/18] net: mac802154: Include the softMAC stack inside the IEEE 802.15.4 menu
Date:   Wed, 22 Dec 2021 16:57:29 +0100
Message-Id: <20211222155743.256280-5-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211222155743.256280-1-miquel.raynal@bootlin.com>
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Girault <david.girault@qorvo.com>

The softMAC stack has no meaning outside of the IEEE 802.15.4 stack and
cannot be used without it.

Signed-off-by: David Girault <david.girault@qorvo.com>
[miquel.raynal@bootlin.com: Isolate this change from a bigger commit]
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/Kconfig            | 1 -
 net/ieee802154/Kconfig | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/Kconfig b/net/Kconfig
index 0da89d09ffa6..a5e31078fd14 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -228,7 +228,6 @@ source "net/x25/Kconfig"
 source "net/lapb/Kconfig"
 source "net/phonet/Kconfig"
 source "net/6lowpan/Kconfig"
-source "net/mac802154/Kconfig"
 source "net/sched/Kconfig"
 source "net/dcb/Kconfig"
 source "net/dns_resolver/Kconfig"
diff --git a/net/ieee802154/Kconfig b/net/ieee802154/Kconfig
index 31aed75fe62d..7e4b1d49d445 100644
--- a/net/ieee802154/Kconfig
+++ b/net/ieee802154/Kconfig
@@ -36,6 +36,7 @@ config IEEE802154_SOCKET
 	  for 802.15.4 dataframes. Also RAW socket interface to build MAC
 	  header from userspace.
 
+source "net/mac802154/Kconfig"
 source "net/ieee802154/6lowpan/Kconfig"
 
 endif
-- 
2.27.0

