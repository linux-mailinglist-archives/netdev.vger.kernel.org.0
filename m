Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE822955C
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 12:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390242AbfEXKFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 06:05:36 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:43387 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389745AbfEXKFg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 06:05:36 -0400
X-Originating-IP: 90.88.147.134
Received: from mc-bl-xps13.lan (aaubervilliers-681-1-27-134.w90-88.abo.wanadoo.fr [90.88.147.134])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id D7CABE0009;
        Fri, 24 May 2019 10:05:29 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next] net: ethtool: Document get_rxfh_context and set_rxfh_context ethtool ops
Date:   Fri, 24 May 2019 12:05:30 +0200
Message-Id: <20190524100530.8445-1-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ethtool ops get_rxfh_context and set_rxfh_context are used to create,
remove and access parameters associated to RSS contexts, in a similar
fashion to get_rxfh and set_rxfh.

Add a small descritopn of these callbacks in the struct ethtool_ops doc.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 include/linux/ethtool.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index e6ebc9761822..95991e4300bf 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -260,6 +260,15 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
  *	will remain unchanged.
  *	Returns a negative error code or zero. An error code must be returned
  *	if at least one unsupported change was requested.
+ * @get_rxfh_context: Get the contents of the RX flow hash indirection table,
+ *	hash key, and/or hash function assiciated to the given rss context.
+ *	Returns a negative error code or zero.
+ * @set_rxfh_context: Create, remove and configure RSS contexts. Allows setting
+ *	the contents of the RX flow hash indirection table, hash key, and/or
+ *	hash function associated to the given context. Arguments which are set
+ *	to %NULL or zero will remain unchanged.
+ *	Returns a negative error code or zero. An error code must be returned
+ *	if at least one unsupported change was requested.
  * @get_channels: Get number of channels.
  * @set_channels: Set number of channels.  Returns a negative error code or
  *	zero.
-- 
2.20.1

