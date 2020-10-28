Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6B3829DBC2
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390799AbgJ2ANd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:13:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50754 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390803AbgJ2ANb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 20:13:31 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kXZj4-003u1f-CI; Wed, 28 Oct 2020 01:54:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Paul Moore <paul@paul-moore.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next] net: netlabel: Fix kerneldoc warnings
Date:   Wed, 28 Oct 2020 01:53:50 +0100
Message-Id: <20201028005350.930299-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net/netlabel/netlabel_calipso.c:376: warning: Function parameter or member 'ops' not described in 'netlbl_calipso_ops_register'

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/netlabel/netlabel_calipso.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netlabel/netlabel_calipso.c b/net/netlabel/netlabel_calipso.c
index 4e62f2ad3575..a4efa99fb1f8 100644
--- a/net/netlabel/netlabel_calipso.c
+++ b/net/netlabel/netlabel_calipso.c
@@ -366,6 +366,7 @@ static const struct netlbl_calipso_ops *calipso_ops;
 
 /**
  * netlbl_calipso_ops_register - Register the CALIPSO operations
+ * @ops: Ops to register
  *
  * Description:
  * Register the CALIPSO packet engine operations.
-- 
2.28.0

