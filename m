Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292AB2A5982
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 23:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731152AbgKCWHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 17:07:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731092AbgKCWGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 17:06:46 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA99AC061A49
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 14:06:45 -0800 (PST)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ka4Rv-0006Ui-U3; Tue, 03 Nov 2020 23:06:44 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Yegor Yefremov <yegorslists@googlemail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 10/27] can: j1939: swap addr and pgn in the send example
Date:   Tue,  3 Nov 2020 23:06:19 +0100
Message-Id: <20201103220636.972106-11-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201103220636.972106-1-mkl@pengutronix.de>
References: <20201103220636.972106-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yegor Yefremov <yegorslists@googlemail.com>

The address was wrongly assigned to the PGN field and vice versa.

Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
Link: https://lore.kernel.org/r/20201022083708.8755-1-yegorslists@googlemail.com
Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 Documentation/networking/j1939.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/j1939.rst b/Documentation/networking/j1939.rst
index be59fcece3bf..faf2eb5c5052 100644
--- a/Documentation/networking/j1939.rst
+++ b/Documentation/networking/j1939.rst
@@ -414,8 +414,8 @@ Send:
 		.can_family = AF_CAN,
 		.can_addr.j1939 = {
 			.name = J1939_NO_NAME;
-			.pgn = 0x30,
-			.addr = 0x12300,
+			.addr = 0x30,
+			.pgn = 0x12300,
 		},
 	};
 
-- 
2.28.0

