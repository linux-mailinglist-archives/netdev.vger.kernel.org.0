Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6DD516DA7
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 11:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384320AbiEBJuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 05:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378782AbiEBJuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 05:50:16 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 631E811A00
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 02:46:43 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nlSdd-0000wV-T7
        for netdev@vger.kernel.org; Mon, 02 May 2022 11:46:41 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 332377304A
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 09:46:40 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id E49AC73039;
        Mon,  2 May 2022 09:46:39 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 8ace85c8;
        Mon, 2 May 2022 09:46:39 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
        Carlos Llamas <cmllamas@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 2/2] selftests/net: so_txtime: usage(): fix documentation of default clock
Date:   Mon,  2 May 2022 11:46:38 +0200
Message-Id: <20220502094638.1921702-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220502094638.1921702-1-mkl@pengutronix.de>
References: <20220502094638.1921702-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The program uses CLOCK_TAI as default clock since it was added to the
Linux repo. In commit:
| 040806343bb4 ("selftests/net: so_txtime multi-host support")
a help text stating the wrong default clock was added.

This patch fixes the help text.

Fixes: 040806343bb4 ("selftests/net: so_txtime multi-host support")
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 tools/testing/selftests/net/so_txtime.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/so_txtime.c b/tools/testing/selftests/net/so_txtime.c
index 103f6bf28e35..2672ac0b6d1f 100644
--- a/tools/testing/selftests/net/so_txtime.c
+++ b/tools/testing/selftests/net/so_txtime.c
@@ -421,7 +421,7 @@ static void usage(const char *progname)
 			"Options:\n"
 			"  -4            only IPv4\n"
 			"  -6            only IPv6\n"
-			"  -c <clock>    monotonic (default) or tai\n"
+			"  -c <clock>    monotonic or tai (default)\n"
 			"  -D <addr>     destination IP address (server)\n"
 			"  -S <addr>     source IP address (client)\n"
 			"  -r            run rx mode\n"
-- 
2.35.1


