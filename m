Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAD44286A21
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 23:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728696AbgJGVcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 17:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgJGVcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 17:32:08 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F7F3C061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 14:32:08 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kQH2c-0005qi-8e; Wed, 07 Oct 2020 23:32:06 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 01/17] can: af_can: can_rcv_list_find(): fix kernel doc after variable renaming
Date:   Wed,  7 Oct 2020 23:31:43 +0200
Message-Id: <20201007213159.1959308-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201007213159.1959308-1-mkl@pengutronix.de>
References: <20201007213159.1959308-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes the kernel doc for can_rcv_list_find() which was broken in commit:

    3ee6d2bebef8 ("can: af_can: rename find_rcv_list() to can_rcv_list_find()")

while renaming a variable, but forgetting to rename the kernel doc, too.

Link: http://lore.kernel.org/r/20201006203748.1750156-2-mkl@pengutronix.de
Fixes: 3ee6d2bebef8 ("can: af_can: rename find_rcv_list() to can_rcv_list_find()")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/af_can.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/can/af_can.c b/net/can/af_can.c
index ea29a6d97ef5..b7d0f6500893 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -338,7 +338,7 @@ static unsigned int effhash(canid_t can_id)
  * can_rcv_list_find - determine optimal filterlist inside device filter struct
  * @can_id: pointer to CAN identifier of a given can_filter
  * @mask: pointer to CAN mask of a given can_filter
- * @d: pointer to the device filter struct
+ * @dev_rcv_lists: pointer to the device filter struct
  *
  * Description:
  *  Returns the optimal filterlist to reduce the filter handling in the
-- 
2.28.0

