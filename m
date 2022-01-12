Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E41A48C992
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355709AbiALRdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:33:54 -0500
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:55207 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355694AbiALRdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:33:37 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 6E9F52000E;
        Wed, 12 Jan 2022 17:33:32 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Michael Hennerich <michael.hennerich@analog.com>,
        Harry Morris <h.morris@cascoda.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-wireless@vger.kernel.org,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [wpan-next v2 09/27] net: ieee802154: Move IEEE 802.15.4 Kconfig main entry
Date:   Wed, 12 Jan 2022 18:32:54 +0100
Message-Id: <20220112173312.764660-10-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220112173312.764660-1-miquel.raynal@bootlin.com>
References: <20220112173312.764660-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Girault <david.girault@qorvo.com>

It makes certainly more sense to have all the low-range wireless
protocols such as Bluetooth, IEEE 802.11 (WiFi) and IEEE 802.15.4
together, so let's move the main IEEE 802.15.4 stack Kconfig entry at a
better location.

Signed-off-by: David Girault <david.girault@qorvo.com>
[miquel.raynal@bootlin.com: Isolate this change from a bigger commit and
rewrite the commit message.]
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/Kconfig b/net/Kconfig
index 8a1f9d0287de..0da89d09ffa6 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -228,7 +228,6 @@ source "net/x25/Kconfig"
 source "net/lapb/Kconfig"
 source "net/phonet/Kconfig"
 source "net/6lowpan/Kconfig"
-source "net/ieee802154/Kconfig"
 source "net/mac802154/Kconfig"
 source "net/sched/Kconfig"
 source "net/dcb/Kconfig"
@@ -380,6 +379,7 @@ source "net/mac80211/Kconfig"
 
 endif # WIRELESS
 
+source "net/ieee802154/Kconfig"
 source "net/rfkill/Kconfig"
 source "net/9p/Kconfig"
 source "net/caif/Kconfig"
-- 
2.27.0

