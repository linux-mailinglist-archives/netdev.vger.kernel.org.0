Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1EC29DBBA
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390777AbgJ2ANS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:13:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50732 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbgJ2ANO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 20:13:14 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kXZUR-003toZ-5U; Wed, 28 Oct 2020 01:38:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 1/2] net: dccp: Add __printf() markup to fix -Wsuggest-attribute=format
Date:   Wed, 28 Oct 2020 01:38:48 +0100
Message-Id: <20201028003849.929490-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201028003849.929490-1-andrew@lunn.ch>
References: <20201028003849.929490-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net/dccp/ccid.c: In function ‘ccid_kmem_cache_create’:
net/dccp/ccid.c:85:2: warning: function ‘ccid_kmem_cache_create’ might be a candidate for ‘gnu_printf’ format attribute [-Wsuggest-attribute=format]
   85 |  vsnprintf(slab_name_fmt, CCID_SLAB_NAME_LENGTH, fmt, args);

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/dccp/ccid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dccp/ccid.c b/net/dccp/ccid.c
index 1e9bb121ba72..6beac5d348e2 100644
--- a/net/dccp/ccid.c
+++ b/net/dccp/ccid.c
@@ -76,7 +76,7 @@ int ccid_getsockopt_builtin_ccids(struct sock *sk, int len,
 	return err;
 }
 
-static struct kmem_cache *ccid_kmem_cache_create(int obj_size, char *slab_name_fmt, const char *fmt,...)
+static __printf(3, 4) struct kmem_cache *ccid_kmem_cache_create(int obj_size, char *slab_name_fmt, const char *fmt,...)
 {
 	struct kmem_cache *slab;
 	va_list args;
-- 
2.28.0

