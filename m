Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7F23F4C16
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 16:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhHWOKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 10:10:53 -0400
Received: from cmccmta1.chinamobile.com ([221.176.66.79]:53750 "EHLO
        cmccmta1.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbhHWOKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 10:10:53 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.3]) by rmmx-syy-dmz-app04-12004 (RichMail) with SMTP id 2ee46123ac3323e-05df7; Mon, 23 Aug 2021 22:09:57 +0800 (CST)
X-RM-TRANSID: 2ee46123ac3323e-05df7
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[223.112.105.130])
        by rmsmtp-syy-appsvr02-12002 (RichMail) with SMTP id 2ee26123ac2fde0-cdfa1;
        Mon, 23 Aug 2021 22:09:56 +0800 (CST)
X-RM-TRANSID: 2ee26123ac2fde0-cdfa1
From:   Tang Bin <tangbin@cmss.chinamobile.com>
To:     davem@davemloft.net, mkl@pengutronix.de, wg@grandegger.com,
        kuba@kernel.org
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>
Subject: [PATCH] can: mscan: mpc5xxx_can: Remove useless BUG_ON()
Date:   Mon, 23 Aug 2021 22:10:33 +0800
Message-Id: <20210823141033.17876-1-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.20.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the function mpc5xxx_can_probe(), the variale 'data'
has already been determined in the above code, so the
BUG_ON() in this place is useless, remove it.

Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
---
 drivers/net/can/mscan/mpc5xxx_can.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/can/mscan/mpc5xxx_can.c b/drivers/net/can/mscan/mpc5xxx_can.c
index 3b7465acd..35892c1ef 100644
--- a/drivers/net/can/mscan/mpc5xxx_can.c
+++ b/drivers/net/can/mscan/mpc5xxx_can.c
@@ -317,7 +317,6 @@ static int mpc5xxx_can_probe(struct platform_device *ofdev)
 
 	clock_name = of_get_property(np, "fsl,mscan-clock-source", NULL);
 
-	BUG_ON(!data);
 	priv->type = data->type;
 	priv->can.clock.freq = data->get_clock(ofdev, clock_name,
 					       &mscan_clksrc);
-- 
2.20.1.windows.1



