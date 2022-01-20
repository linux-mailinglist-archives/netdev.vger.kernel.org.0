Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A26F54944FB
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 01:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345347AbiATAoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 19:44:02 -0500
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:38695 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345298AbiATAn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 19:43:56 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id C9C6F20004;
        Thu, 20 Jan 2022 00:43:53 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [wpan-next 2/4] net: mac802154: Include the softMAC stack inside the IEEE 802.15.4 menu
Date:   Thu, 20 Jan 2022 01:43:48 +0100
Message-Id: <20220120004350.308866-3-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220120004350.308866-1-miquel.raynal@bootlin.com>
References: <20220120004350.308866-1-miquel.raynal@bootlin.com>
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

