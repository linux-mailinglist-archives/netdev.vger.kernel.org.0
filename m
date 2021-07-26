Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8CDB3D5B18
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 16:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234584AbhGZNbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 09:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234251AbhGZNbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 09:31:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6327BC061796
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 07:11:56 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m81Kk-0000kJ-QB
        for netdev@vger.kernel.org; Mon, 26 Jul 2021 16:11:54 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 70E5365818C
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 14:11:50 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 990D465815B;
        Mon, 26 Jul 2021 14:11:46 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id d931c21b;
        Mon, 26 Jul 2021 14:11:45 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [PATCH net-next 03/46] can: j1939: replace fall through comment by fallthrough pseudo-keyword
Date:   Mon, 26 Jul 2021 16:11:01 +0200
Message-Id: <20210726141144.862529-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726141144.862529-1-mkl@pengutronix.de>
References: <20210726141144.862529-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the existing /* fall through */ comments the new
pseudo-keyword macro fallthrough.

Cc: Robin van der Gracht <robin@protonic.nl>
Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/r/20210616102811.2449426-3-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/j1939/transport.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index d47caffb687d..a24bcf5f422b 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1264,12 +1264,14 @@ static bool j1939_xtp_rx_cmd_bad_pgn(struct j1939_session *session,
 		break;
 
 	case J1939_ETP_CMD_RTS:
-	case J1939_TP_CMD_RTS: /* fall through */
+		fallthrough;
+	case J1939_TP_CMD_RTS:
 		abort = J1939_XTP_ABORT_BUSY;
 		break;
 
 	case J1939_ETP_CMD_CTS:
-	case J1939_TP_CMD_CTS: /* fall through */
+		fallthrough;
+	case J1939_TP_CMD_CTS:
 		abort = J1939_XTP_ABORT_ECTS_UNXPECTED_PGN;
 		break;
 
@@ -1278,7 +1280,8 @@ static bool j1939_xtp_rx_cmd_bad_pgn(struct j1939_session *session,
 		break;
 
 	case J1939_ETP_CMD_EOMA:
-	case J1939_TP_CMD_EOMA: /* fall through */
+		fallthrough;
+	case J1939_TP_CMD_EOMA:
 		abort = J1939_XTP_ABORT_OTHER;
 		break;
 
@@ -1793,7 +1796,8 @@ static void j1939_xtp_rx_dat_one(struct j1939_session *session,
 			break;
 		fallthrough;
 	case J1939_TP_CMD_BAM:
-	case J1939_TP_CMD_CTS: /* fall through */
+		fallthrough;
+	case J1939_TP_CMD_CTS:
 		if (skcb->addr.type != J1939_ETP)
 			break;
 		fallthrough;
@@ -1996,7 +2000,8 @@ static void j1939_tp_cmd_recv(struct j1939_priv *priv, struct sk_buff *skb)
 		extd = J1939_ETP;
 		fallthrough;
 	case J1939_TP_CMD_BAM:
-	case J1939_TP_CMD_RTS: /* fall through */
+		fallthrough;
+	case J1939_TP_CMD_RTS:
 		if (skcb->addr.type != extd)
 			return;
 
-- 
2.30.2


