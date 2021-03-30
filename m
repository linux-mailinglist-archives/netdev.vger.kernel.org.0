Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35DE734E68F
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 13:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbhC3Lqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 07:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231923AbhC3LqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 07:46:24 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CCBAC061765
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 04:46:23 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lRCpB-0005zh-Ml
        for netdev@vger.kernel.org; Tue, 30 Mar 2021 13:46:21 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 4E61D603E2F
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 11:46:12 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id CF5CB603DD6;
        Tue, 30 Mar 2021 11:46:02 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 2de966b8;
        Tue, 30 Mar 2021 11:46:00 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 08/39] can: netlink: move '=' operators back to previous line (checkpatch fix)
Date:   Tue, 30 Mar 2021 13:45:28 +0200
Message-Id: <20210330114559.1114855-9-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330114559.1114855-1-mkl@pengutronix.de>
References: <20210330114559.1114855-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

Fix the warning triggered by having an '=' at the beginning of the
line by moving it back to the previous line. Also replace all
indentations with a single space so that future entries can be more
easily added.

Extract of ./scripts/checkpatch.pl -f drivers/net/can/dev/netlink.c:

CHECK: Assignment operator '=' should be on the previous line
+       [IFLA_CAN_BITTIMING_CONST]
+                               = { .len = sizeof(struct can_bittiming_const) },

CHECK: Assignment operator '=' should be on the previous line
+       [IFLA_CAN_DATA_BITTIMING]
+                               = { .len = sizeof(struct can_bittiming) },

CHECK: Assignment operator '=' should be on the previous line
+       [IFLA_CAN_DATA_BITTIMING_CONST]
+                               = { .len = sizeof(struct can_bittiming_const) },

Link: https://lore.kernel.org/r/20210224002008.4158-4-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev/netlink.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/net/can/dev/netlink.c b/drivers/net/can/dev/netlink.c
index f5d79e6e5483..8443480a703d 100644
--- a/drivers/net/can/dev/netlink.c
+++ b/drivers/net/can/dev/netlink.c
@@ -8,20 +8,17 @@
 #include <net/rtnetlink.h>
 
 static const struct nla_policy can_policy[IFLA_CAN_MAX + 1] = {
-	[IFLA_CAN_STATE]	= { .type = NLA_U32 },
-	[IFLA_CAN_CTRLMODE]	= { .len = sizeof(struct can_ctrlmode) },
-	[IFLA_CAN_RESTART_MS]	= { .type = NLA_U32 },
-	[IFLA_CAN_RESTART]	= { .type = NLA_U32 },
-	[IFLA_CAN_BITTIMING]	= { .len = sizeof(struct can_bittiming) },
-	[IFLA_CAN_BITTIMING_CONST]
-				= { .len = sizeof(struct can_bittiming_const) },
-	[IFLA_CAN_CLOCK]	= { .len = sizeof(struct can_clock) },
-	[IFLA_CAN_BERR_COUNTER]	= { .len = sizeof(struct can_berr_counter) },
-	[IFLA_CAN_DATA_BITTIMING]
-				= { .len = sizeof(struct can_bittiming) },
-	[IFLA_CAN_DATA_BITTIMING_CONST]
-				= { .len = sizeof(struct can_bittiming_const) },
-	[IFLA_CAN_TERMINATION]	= { .type = NLA_U16 },
+	[IFLA_CAN_STATE] = { .type = NLA_U32 },
+	[IFLA_CAN_CTRLMODE] = { .len = sizeof(struct can_ctrlmode) },
+	[IFLA_CAN_RESTART_MS] = { .type = NLA_U32 },
+	[IFLA_CAN_RESTART] = { .type = NLA_U32 },
+	[IFLA_CAN_BITTIMING] = { .len = sizeof(struct can_bittiming) },
+	[IFLA_CAN_BITTIMING_CONST] = { .len = sizeof(struct can_bittiming_const) },
+	[IFLA_CAN_CLOCK] = { .len = sizeof(struct can_clock) },
+	[IFLA_CAN_BERR_COUNTER] = { .len = sizeof(struct can_berr_counter) },
+	[IFLA_CAN_DATA_BITTIMING] = { .len = sizeof(struct can_bittiming) },
+	[IFLA_CAN_DATA_BITTIMING_CONST]	= { .len = sizeof(struct can_bittiming_const) },
+	[IFLA_CAN_TERMINATION] = { .type = NLA_U16 },
 };
 
 static int can_validate(struct nlattr *tb[], struct nlattr *data[],
-- 
2.30.2


