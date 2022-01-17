Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED0049079B
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 12:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236510AbiAQLzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 06:55:17 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:41723 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239365AbiAQLzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 06:55:13 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id E5BA2200010;
        Mon, 17 Jan 2022 11:55:09 +0000 (UTC)
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
Subject: [PATCH v3 14/41] net: ieee802154: Add a kernel doc header to the ieee802154_addr structure
Date:   Mon, 17 Jan 2022 12:54:13 +0100
Message-Id: <20220117115440.60296-15-miquel.raynal@bootlin.com>
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

While not being absolutely needed, it at least explain the mode vs. enum
fields.

Signed-off-by: David Girault <david.girault@qorvo.com>
[miquel.raynal@bootlin.com: Isolate this change from a bigger commit and
                            reword the comment]
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/cfg802154.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index 4193c242d96e..0b8b1812cea1 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -29,6 +29,16 @@ struct ieee802154_llsec_key_id;
 struct ieee802154_llsec_key;
 #endif /* CONFIG_IEEE802154_NL802154_EXPERIMENTAL */
 
+/**
+ * struct ieee802154_addr - IEEE802.15.4 device address
+ * @mode: Address mode from frame header. Can be one of:
+ *        - @IEEE802154_ADDR_NONE
+ *        - @IEEE802154_ADDR_SHORT
+ *        - @IEEE802154_ADDR_LONG
+ * @pan_id: The PAN ID this address belongs to
+ * @short_addr: address if @mode is @IEEE802154_ADDR_SHORT
+ * @extended_addr: address if @mode is @IEEE802154_ADDR_LONG
+ */
 struct ieee802154_addr {
 	u8 mode;
 	__le16 pan_id;
-- 
2.27.0

