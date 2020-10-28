Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCF8E29DBCD
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbgJ2ANw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:13:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50788 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390846AbgJ2ANu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 20:13:50 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kXZgA-003tzq-3m; Wed, 28 Oct 2020 01:51:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next] net: l3mdev: Fix kerneldoc warning
Date:   Wed, 28 Oct 2020 01:50:59 +0100
Message-Id: <20201028005059.930192-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net/l3mdev/l3mdev.c:249: warning: Function parameter or member 'arg' not described in 'l3mdev_fib_rule_match'

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/l3mdev/l3mdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/l3mdev/l3mdev.c b/net/l3mdev/l3mdev.c
index 864326f150e2..e07292a4779e 100644
--- a/net/l3mdev/l3mdev.c
+++ b/net/l3mdev/l3mdev.c
@@ -241,6 +241,7 @@ EXPORT_SYMBOL_GPL(l3mdev_link_scope_lookup);
  *				L3 master device
  *	@net: network namespace for device index lookup
  *	@fl:  flow struct
+ *	@arg: store the table the rule matched with here.
  */
 
 int l3mdev_fib_rule_match(struct net *net, struct flowi *fl,
-- 
2.28.0

