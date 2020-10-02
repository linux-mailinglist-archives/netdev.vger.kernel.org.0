Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0948D281C46
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 21:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725767AbgJBTrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 15:47:48 -0400
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:30957 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725681AbgJBTrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 15:47:48 -0400
Received: from localhost.localdomain ([92.140.225.106])
        by mwinf5d73 with ME
        id b7nk230062JMhn8037nklC; Fri, 02 Oct 2020 21:47:46 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 02 Oct 2020 21:47:46 +0200
X-ME-IP: 92.140.225.106
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     dave@thedillows.org, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: typhoon: Fix a typo Typoon --> Typhoon
Date:   Fri,  2 Oct 2020 21:47:43 +0200
Message-Id: <20201002194743.640440-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/Typoon/Typhoon/

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/3com/typhoon.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/3com/typhoon.h b/drivers/net/ethernet/3com/typhoon.h
index 2f634c64d5d1..38e6dcab4e94 100644
--- a/drivers/net/ethernet/3com/typhoon.h
+++ b/drivers/net/ethernet/3com/typhoon.h
@@ -33,7 +33,7 @@ struct basic_ring {
 	u32 lastWrite;
 };
 
-/* The Typoon transmit ring -- same as a basic ring, plus:
+/* The Typhoon transmit ring -- same as a basic ring, plus:
  * lastRead:      where we're at in regard to cleaning up the ring
  * writeRegister: register to use for writing (different for Hi & Lo rings)
  */
-- 
2.25.1

