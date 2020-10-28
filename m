Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E85429DBD4
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390499AbgJ2ANE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:13:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50720 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390147AbgJ2ANC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 20:13:02 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kXaJL-003uQ3-5q; Wed, 28 Oct 2020 02:31:35 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next] net: ipv6: rpl*: Fix strange kerneldoc warnings due to bad header
Date:   Wed, 28 Oct 2020 02:31:23 +0100
Message-Id: <20201028013123.931816-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net/ipv6/rpl_iptunnel.c:15: warning: cannot understand function prototype: 'struct rpl_iptunnel_encap '

The header on the file containing the author copyright message uses
kerneldoc /** opener. This confuses the parser when it gets to

struct rpl_iptunnel_encap {
	struct ipv6_rpl_sr_hdr srh[0];
};

Similarly:

net//ipv6/rpl.c:10: warning: Function parameter or member 'x' not described in 'IPV6_PFXTAIL_LEN'

where IPV6_PFXTAIL_LEN is a macro definition, not a function.

Convert the header comments to a plain /* comment.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/ipv6/rpl.c          | 2 +-
 net/ipv6/rpl_iptunnel.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/rpl.c b/net/ipv6/rpl.c
index 307f336b5353..488aec9e1a74 100644
--- a/net/ipv6/rpl.c
+++ b/net/ipv6/rpl.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/**
+/*
  * Authors:
  * (C) 2020 Alexander Aring <alex.aring@gmail.com>
  */
diff --git a/net/ipv6/rpl_iptunnel.c b/net/ipv6/rpl_iptunnel.c
index 5fdf3ebb953f..233da43dd8d7 100644
--- a/net/ipv6/rpl_iptunnel.c
+++ b/net/ipv6/rpl_iptunnel.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/**
+/*
  * Authors:
  * (C) 2020 Alexander Aring <alex.aring@gmail.com>
  */
-- 
2.28.0

