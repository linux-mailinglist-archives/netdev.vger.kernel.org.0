Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC604305789
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 10:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235687AbhA0J5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 04:57:07 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:33017 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235706AbhA0JzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 04:55:11 -0500
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1l4h23-00084j-9s
        for netdev@vger.kernel.org; Wed, 27 Jan 2021 10:22:35 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id E4C295CF0EA
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 09:22:32 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 9B01A5CF0CD;
        Wed, 27 Jan 2021 09:22:28 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id c32620fe;
        Wed, 27 Jan 2021 09:22:28 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 01/12] can: gw: fix typo
Date:   Wed, 27 Jan 2021 10:22:16 +0100
Message-Id: <20210127092227.2775573-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210127092227.2775573-1-mkl@pengutronix.de>
References: <20210127092227.2775573-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes a typo found by codespell.

Fixes: 94c23097f991 ("can: gw: support modification of Classical CAN DLCs")
Link: https://lore.kernel.org/r/20210127085529.2768537-3-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/gw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/can/gw.c b/net/can/gw.c
index 8598d9da0e5f..ba4124805602 100644
--- a/net/can/gw.c
+++ b/net/can/gw.c
@@ -225,7 +225,7 @@ static void mod_store_ccdlc(struct canfd_frame *cf)
 	if (ccf->len <= CAN_MAX_DLEN)
 		return;
 
-	/* potentially broken values are catched in can_can_gw_rcv() */
+	/* potentially broken values are caught in can_can_gw_rcv() */
 	if (ccf->len > CAN_MAX_RAW_DLC)
 		return;
 

base-commit: 6626a0266566c5aea16178c5e6cd7fc4db3f2f56
-- 
2.29.2


