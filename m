Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E654629DBBD
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390783AbgJ2ANX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:13:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50736 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbgJ2ANU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 20:13:20 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kXZc4-003twh-DO; Wed, 28 Oct 2020 01:46:52 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next] net: llc: Fix kerneldoc warnings
Date:   Wed, 28 Oct 2020 01:46:44 +0100
Message-Id: <20201028004644.929997-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net/llc/llc_conn.c:917: warning: Function parameter or member 'kern' not described in 'llc_sk_alloc'
net/llc/llc_conn.c:917: warning: Function parameter or member 'prot' not described in 'llc_sk_alloc'

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/llc/llc_conn.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/llc/llc_conn.c b/net/llc/llc_conn.c
index 1144cda2a0fc..912aa9bd5e29 100644
--- a/net/llc/llc_conn.c
+++ b/net/llc/llc_conn.c
@@ -909,6 +909,8 @@ static void llc_sk_init(struct sock *sk)
  *	@net: network namespace
  *	@family: upper layer protocol family
  *	@priority: for allocation (%GFP_KERNEL, %GFP_ATOMIC, etc)
+ *	@prot: struct proto associated with this new sock instance
+ *	@kern: is this to be a kernel socket?
  *
  *	Allocates a LLC sock and initializes it. Returns the new LLC sock
  *	or %NULL if there's no memory available for one
-- 
2.28.0

