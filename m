Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E695521CC13
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 01:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgGLXQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 19:16:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59608 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728513AbgGLXPb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jul 2020 19:15:31 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1julBt-004mPY-VT; Mon, 13 Jul 2020 01:15:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH net-next 11/20] net: netlabel: kerneldoc fixes
Date:   Mon, 13 Jul 2020 01:15:07 +0200
Message-Id: <20200712231516.1139335-12-andrew@lunn.ch>
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

Cc: Paul Moore <paul@paul-moore.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/netlabel/netlabel_domainhash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netlabel/netlabel_domainhash.c b/net/netlabel/netlabel_domainhash.c
index a1f2320ecc16..d07de2c0fbc7 100644
--- a/net/netlabel/netlabel_domainhash.c
+++ b/net/netlabel/netlabel_domainhash.c
@@ -92,7 +92,7 @@ static void netlbl_domhsh_free_entry(struct rcu_head *entry)
 
 /**
  * netlbl_domhsh_hash - Hashing function for the domain hash table
- * @domain: the domain name to hash
+ * @key: the domain name to hash
  *
  * Description:
  * This is the hashing function for the domain hash table, it returns the
-- 
2.27.0.rc2

