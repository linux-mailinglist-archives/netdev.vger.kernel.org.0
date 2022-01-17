Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93D62490799
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 12:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239307AbiAQLzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 06:55:15 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:60553 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239337AbiAQLzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 06:55:09 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id D7840200009;
        Mon, 17 Jan 2022 11:55:04 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH v3 12/41] net: mac802154: Include the softMAC stack inside the IEEE 802.15.4 menu
Date:   Mon, 17 Jan 2022 12:54:11 +0100
Message-Id: <20220117115440.60296-13-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220117115440.60296-1-miquel.raynal@bootlin.com>
References: <20220117115440.60296-1-miquel.raynal@bootlin.com>
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

