Return-Path: <netdev+bounces-2786-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CF3A8703F21
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 23:00:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D19DA1C20CDD
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 21:00:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3FAF19E7A;
	Mon, 15 May 2023 20:58:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99C019E52
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 20:58:38 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2066D84B
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 13:58:17 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mkl@pengutronix.de>)
	id 1pyfGj-0006k3-Lj
	for netdev@vger.kernel.org; Mon, 15 May 2023 22:58:09 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
	by bjornoya.blackshift.org (Postfix) with SMTP id 9EDAD1C5D1F
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 20:58:05 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bjornoya.blackshift.org (Postfix) with ESMTPS id 0C9381C5CC2;
	Mon, 15 May 2023 20:58:03 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
	by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 7381a132;
	Mon, 15 May 2023 20:58:02 +0000 (UTC)
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	kuba@kernel.org,
	linux-can@vger.kernel.org,
	kernel@pengutronix.de,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>,
	Simon Horman <simon.horman@corigine.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 06/22] can: bxcan: Remove unnecessary print function dev_err()
Date: Mon, 15 May 2023 22:57:43 +0200
Message-Id: <20230515205759.1003118-7-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230515205759.1003118-1-mkl@pengutronix.de>
References: <20230515205759.1003118-1-mkl@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

The print function dev_err() is redundant because
platform_get_irq_byname() already prints an error.

./drivers/net/can/bxcan.c:970:2-9: line 970 is redundant because platform_get_irq() already prints an error.
./drivers/net/can/bxcan.c:964:2-9: line 964 is redundant because platform_get_irq() already prints an error.
./drivers/net/can/bxcan.c:958:2-9: line 958 is redundant because platform_get_irq() already prints an error.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4878
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/all/20230506080725.68401-1-jiapeng.chong@linux.alibaba.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/bxcan.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/can/bxcan.c b/drivers/net/can/bxcan.c
index e26ccd41e3cb..7b285eeb08a1 100644
--- a/drivers/net/can/bxcan.c
+++ b/drivers/net/can/bxcan.c
@@ -954,22 +954,16 @@ static int bxcan_probe(struct platform_device *pdev)
 	}
 
 	rx_irq = platform_get_irq_byname(pdev, "rx0");
-	if (rx_irq < 0) {
-		dev_err(dev, "failed to get rx0 irq\n");
+	if (rx_irq < 0)
 		return rx_irq;
-	}
 
 	tx_irq = platform_get_irq_byname(pdev, "tx");
-	if (tx_irq < 0) {
-		dev_err(dev, "failed to get tx irq\n");
+	if (tx_irq < 0)
 		return tx_irq;
-	}
 
 	sce_irq = platform_get_irq_byname(pdev, "sce");
-	if (sce_irq < 0) {
-		dev_err(dev, "failed to get sce irq\n");
+	if (sce_irq < 0)
 		return sce_irq;
-	}
 
 	ndev = alloc_candev(sizeof(struct bxcan_priv), BXCAN_TX_MB_NUM);
 	if (!ndev) {
-- 
2.39.2



