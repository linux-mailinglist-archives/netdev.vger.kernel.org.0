Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADED6F2A3
	for <lists+netdev@lfdr.de>; Sun, 21 Jul 2019 12:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfGUKih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jul 2019 06:38:37 -0400
Received: from smtp10.smtpout.orange.fr ([80.12.242.132]:51705 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfGUKih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jul 2019 06:38:37 -0400
Received: from localhost.localdomain ([92.140.204.221])
        by mwinf5d33 with ME
        id fNeW2000F4n7eLC03NeWau; Sun, 21 Jul 2019 12:38:35 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 21 Jul 2019 12:38:35 +0200
X-ME-IP: 92.140.204.221
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     jon.maloy@ericsson.com, ying.xue@windriver.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] tipc: Fix a typo
Date:   Sun, 21 Jul 2019 12:38:11 +0200
Message-Id: <20190721103811.29724-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/tipc_toprsv_listener_data_ready/tipc_topsrv_listener_data_ready/
(r and s switched in topsrv)

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
The function name could also be removed from the comment. It does not
bring any useful information IMHO.
---
 net/tipc/topsrv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/topsrv.c b/net/tipc/topsrv.c
index f345662890a6..ca8ac96d22a9 100644
--- a/net/tipc/topsrv.c
+++ b/net/tipc/topsrv.c
@@ -476,7 +476,7 @@ static void tipc_topsrv_accept(struct work_struct *work)
 	}
 }
 
-/* tipc_toprsv_listener_data_ready - interrupt callback with connection request
+/* tipc_topsrv_listener_data_ready - interrupt callback with connection request
  * The queued job is launched into tipc_topsrv_accept()
  */
 static void tipc_topsrv_listener_data_ready(struct sock *sk)
-- 
2.20.1

