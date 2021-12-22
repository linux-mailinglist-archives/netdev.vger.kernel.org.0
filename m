Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5269247D4BF
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 16:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343970AbhLVP7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 10:59:05 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:59117 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343835AbhLVP54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 10:57:56 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 3377C60016;
        Wed, 22 Dec 2021 15:57:53 +0000 (UTC)
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
Subject: [net-next 06/18] net: ieee802154: Add a kernel doc header to the ieee802154_addr structure
Date:   Wed, 22 Dec 2021 16:57:31 +0100
Message-Id: <20211222155743.256280-7-miquel.raynal@bootlin.com>
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
index 9f57bafeb3bb..4f36003bca98 100644
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

