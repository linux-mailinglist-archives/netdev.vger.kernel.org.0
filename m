Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0166D29DBCF
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390826AbgJ2ANo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:13:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50772 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390814AbgJ2ANl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 20:13:41 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kXaLb-003uS5-UF; Wed, 28 Oct 2020 02:33:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next] net: ipv6: calipso: Fix kerneldoc warnings
Date:   Wed, 28 Oct 2020 02:33:44 +0100
Message-Id: <20201028013344.931928-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net/ipv6/calipso.c:1236: warning: Excess function parameter 'reg' description in 'calipso_req_delattr'
net/ipv6/calipso.c:1236: warning: Function parameter or member 'req' not described in 'calipso_req_delattr'
net/ipv6/calipso.c:435: warning: Excess function parameter 'audit_secid' description in 'calipso_doi_remove'
net/ipv6/calipso.c:435: warning: Function parameter or member 'audit_info' not described in 'calipso_doi_remove'

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/ipv6/calipso.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/calipso.c b/net/ipv6/calipso.c
index 78f766019b7e..51184a70ac7e 100644
--- a/net/ipv6/calipso.c
+++ b/net/ipv6/calipso.c
@@ -423,7 +423,7 @@ static void calipso_doi_free_rcu(struct rcu_head *entry)
 /**
  * calipso_doi_remove - Remove an existing DOI from the CALIPSO protocol engine
  * @doi: the DOI value
- * @audit_secid: the LSM secid to use in the audit message
+ * @audit_info: NetLabel audit information
  *
  * Description:
  * Removes a DOI definition from the CALIPSO engine.  The NetLabel routines will
@@ -1226,7 +1226,7 @@ static int calipso_req_setattr(struct request_sock *req,
 
 /**
  * calipso_req_delattr - Delete the CALIPSO option from a request socket
- * @reg: the request socket
+ * @req: the request socket
  *
  * Description:
  * Removes the CALIPSO option from a request socket, if present.
-- 
2.28.0

