Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A593821CC1A
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 01:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728971AbgGLXQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 19:16:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59564 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727785AbgGLXP3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jul 2020 19:15:29 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1julBt-004mPK-Ln; Mon, 13 Jul 2020 01:15:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 05/20] net: decnet: kerneldoc fixes
Date:   Mon, 13 Jul 2020 01:15:01 +0200
Message-Id: <20200712231516.1139335-6-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200712231516.1139335-1-andrew@lunn.ch>
References: <20200712231516.1139335-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simple fixes which require no deep knowledge of the code.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/decnet/dn_route.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/decnet/dn_route.c b/net/decnet/dn_route.c
index 9eb7e4b62d9b..4cac31d22a50 100644
--- a/net/decnet/dn_route.c
+++ b/net/decnet/dn_route.c
@@ -494,6 +494,8 @@ static int dn_return_long(struct sk_buff *skb)
 
 /**
  * dn_route_rx_packet - Try and find a route for an incoming packet
+ * @net: The applicable net namespace
+ * @sk: Socket packet transmitted on
  * @skb: The packet to find a route for
  *
  * Returns: result of input function if route is found, error code otherwise
-- 
2.27.0.rc2

