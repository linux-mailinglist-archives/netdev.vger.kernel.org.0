Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38E321171DA
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 17:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbfLIQdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 11:33:04 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:37249 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbfLIQdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 11:33:03 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ieLy1-0001up-El; Mon, 09 Dec 2019 17:33:01 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [PATCH 04/13] can: j1939: fix address claim code example
Date:   Mon,  9 Dec 2019 17:32:47 +0100
Message-Id: <20191209163256.12000-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191209163256.12000-1-mkl@pengutronix.de>
References: <20191209163256.12000-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During development the define J1939_PGN_ADDRESS_REQUEST was renamed to
J1939_PGN_REQUEST. It was forgotten to adjust the documentation
accordingly.

This patch fixes the name of the symbol.

Reported-by: https://github.com/linux-can/can-utils/issues/159#issuecomment-556538798
Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 Documentation/networking/j1939.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/j1939.rst b/Documentation/networking/j1939.rst
index dc60b13fcd09..f5be243d250a 100644
--- a/Documentation/networking/j1939.rst
+++ b/Documentation/networking/j1939.rst
@@ -339,7 +339,7 @@ To claim an address following code example can be used:
 			.pgn = J1939_PGN_ADDRESS_CLAIMED,
 			.pgn_mask = J1939_PGN_PDU1_MAX,
 		}, {
-			.pgn = J1939_PGN_ADDRESS_REQUEST,
+			.pgn = J1939_PGN_REQUEST,
 			.pgn_mask = J1939_PGN_PDU1_MAX,
 		}, {
 			.pgn = J1939_PGN_ADDRESS_COMMANDED,
-- 
2.24.0

