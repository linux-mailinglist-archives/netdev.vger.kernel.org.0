Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7894029DBBC
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390781AbgJ2ANV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:13:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50734 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726118AbgJ2ANR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 20:13:17 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kXZUR-003toc-6a; Wed, 28 Oct 2020 01:38:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 2/2] net: tipc: Add __printf() markup to fix -Wsuggest-attribute=format
Date:   Wed, 28 Oct 2020 01:38:49 +0100
Message-Id: <20201028003849.929490-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201028003849.929490-1-andrew@lunn.ch>
References: <20201028003849.929490-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net/tipc/netlink_compat.c: In function ‘tipc_tlv_sprintf’:
net/tipc/netlink_compat.c:137:2: warning: function ‘tipc_tlv_sprintf’ might be a candidate for ‘gnu_printf’ format attribute [-Wsuggest-attribute=format]
  137 |  n = vscnprintf(buf, rem, fmt, args);

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/tipc/netlink_compat.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
index 1c7aa51cc2a3..17a90a2fe753 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -118,7 +118,8 @@ static void tipc_tlv_init(struct sk_buff *skb, u16 type)
 	skb_put(skb, sizeof(struct tlv_desc));
 }
 
-static int tipc_tlv_sprintf(struct sk_buff *skb, const char *fmt, ...)
+static __printf(2, 3) int tipc_tlv_sprintf(struct sk_buff *skb,
+					   const char *fmt, ...)
 {
 	int n;
 	u16 len;
-- 
2.28.0

