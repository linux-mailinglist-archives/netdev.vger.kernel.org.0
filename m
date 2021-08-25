Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B66D73F701E
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 09:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239030AbhHYHIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 03:08:18 -0400
Received: from cmccmta3.chinamobile.com ([221.176.66.81]:9597 "EHLO
        cmccmta3.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238318AbhHYHIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 03:08:16 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.19]) by rmmx-syy-dmz-app12-12012 (RichMail) with SMTP id 2eec6125ec23ade-1e8a3; Wed, 25 Aug 2021 15:07:15 +0800 (CST)
X-RM-TRANSID: 2eec6125ec23ade-1e8a3
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[223.112.105.130])
        by rmsmtp-syy-appsvr10-12010 (RichMail) with SMTP id 2eea6125ec1ede0-4e93f;
        Wed, 25 Aug 2021 15:07:15 +0800 (CST)
X-RM-TRANSID: 2eea6125ec1ede0-4e93f
From:   Tang Bin <tangbin@cmss.chinamobile.com>
To:     mkl@pengutronix.de, wg@grandegger.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>
Subject: [PATCH v2] can: mscan: mpc5xxx_can: Remove useless BUG_ON()
Date:   Wed, 25 Aug 2021 15:07:52 +0800
Message-Id: <20210825070752.18724-1-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.20.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the function mpc5xxx_can_probe(), the variable 'data'
has already been determined in the above code, so the
BUG_ON() in this place is useless, remove it.

Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
---
Changes to v1
 - Fix the commit message for typo
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



