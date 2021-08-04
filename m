Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE063DFF52
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 12:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237520AbhHDKSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 06:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237451AbhHDKSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 06:18:15 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48141C061798
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 03:18:03 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mBDyL-0004B8-Mn
        for netdev@vger.kernel.org; Wed, 04 Aug 2021 12:18:01 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 701706607B7
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 10:18:00 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id B55F26607A6;
        Wed,  4 Aug 2021 10:17:58 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 908f173c;
        Wed, 4 Aug 2021 10:17:55 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        kernel test robot <lkp@intel.com>,
        Angelo Dureghello <angelo@kernel-space.org>
Subject: [PATCH net-next 4/5] can: flexcan: flexcan_clks_enable(): add missing variable initialization
Date:   Wed,  4 Aug 2021 12:17:52 +0200
Message-Id: <20210804101753.23826-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210804101753.23826-1-mkl@pengutronix.de>
References: <20210804101753.23826-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the missing initialization of the "err" variable in
the flexcan_clks_enable() function.

Fixes: d9cead75b1c6 ("can: flexcan: add mcf5441x support")
Link: https://lore.kernel.org/r/20210728075428.1493568-1-mkl@pengutronix.de
Reported-by: kernel test robot <lkp@intel.com>
Cc: Angelo Dureghello <angelo@kernel-space.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/flexcan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 54ffb796a320..7734229aa078 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -649,7 +649,7 @@ static inline void flexcan_error_irq_disable(const struct flexcan_priv *priv)
 
 static int flexcan_clks_enable(const struct flexcan_priv *priv)
 {
-	int err;
+	int err = 0;
 
 	if (priv->clk_ipg) {
 		err = clk_prepare_enable(priv->clk_ipg);
-- 
2.30.2


