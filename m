Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE8E47D491
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 16:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344000AbhLVP6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 10:58:16 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:60803 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343873AbhLVP6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 10:58:02 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id B201D60002;
        Wed, 22 Dec 2021 15:57:59 +0000 (UTC)
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
Subject: [net-next 10/18] net: ieee802154: Define frame types
Date:   Wed, 22 Dec 2021 16:57:35 +0100
Message-Id: <20211222155743.256280-11-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211222155743.256280-1-miquel.raynal@bootlin.com>
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A 802.15.4 frame can be of different types, here is a definition
matching the specification. This enumeration will be soon be used when
adding scanning support.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/ieee802154_netdev.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/net/ieee802154_netdev.h b/include/net/ieee802154_netdev.h
index a92999817dc0..04738ae3b25e 100644
--- a/include/net/ieee802154_netdev.h
+++ b/include/net/ieee802154_netdev.h
@@ -105,6 +105,17 @@ struct ieee802154_hdr_fc {
 #endif
 };
 
+enum ieee802154_frame_type {
+	IEEE802154_BEACON_FRAME,
+	IEEE802154_DATA_FRAME,
+	IEEE802154_ACKNOWLEDGEMENT_FRAME,
+	IEEE802154_MAC_COMMAND_FRAME,
+	IEEE802154_RESERVED_FRAME,
+	IEEE802154_MULTIPURPOSE_FRAME,
+	IEEE802154_FRAGMENT_FRAME,
+	IEEE802154_EXTENDED_FRAME,
+};
+
 struct ieee802154_hdr {
 	struct ieee802154_hdr_fc fc;
 	u8 seq;
-- 
2.27.0

