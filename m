Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C541B7607
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 11:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388599AbfISJQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 05:16:57 -0400
Received: from smtp3.goneo.de ([85.220.129.37]:59102 "EHLO smtp3.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387637AbfISJQ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 05:16:57 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp3.goneo.de (Postfix) with ESMTP id 6DFEE23FA28;
        Thu, 19 Sep 2019 11:16:54 +0200 (CEST)
X-Virus-Scanned: by goneo
X-Spam-Flag: NO
X-Spam-Score: -3.026
X-Spam-Level: 
X-Spam-Status: No, score=-3.026 tagged_above=-999 tests=[ALL_TRUSTED=-1,
        AWL=-0.126, BAYES_00=-1.9] autolearn=ham
Received: from smtp3.goneo.de ([127.0.0.1])
        by localhost (smtp3.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id avsuAnECQglS; Thu, 19 Sep 2019 11:16:53 +0200 (CEST)
Received: from lem-wkst-02.lemonage.de. (hq.lemonage.de [87.138.178.34])
        by smtp3.goneo.de (Postfix) with ESMTPA id 8485223F2CC;
        Thu, 19 Sep 2019 11:16:52 +0200 (CEST)
From:   Lars Poeschel <poeschel@lemonage.de>
To:     Steve Winslow <swinslow@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Allison Randal <allison@lohutok.net>,
        Jilayne Lovejoy <opensource@jilayne.com>,
        Lars Poeschel <poeschel@lemonage.de>,
        netdev@vger.kernel.org (open list:NFC SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Cc:     Johan Hovold <johan@kernel.org>, Simon Horman <horms@verge.net.au>
Subject: [PATCH v8 1/7] nfc: pn533: i2c: "pn532" as dt compatible string
Date:   Thu, 19 Sep 2019 11:16:38 +0200
Message-Id: <20190919091645.16439-1-poeschel@lemonage.de>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is favourable to have one unified compatible string for devices that
have multiple interfaces. So this adds simply "pn532" as the devicetree
binding compatible string and makes a note that the old ones are
deprecated.

Cc: Johan Hovold <johan@kernel.org>
Cc: Simon Horman <horms@verge.net.au>
Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
---
Changes in v6:
- Rebased the patch series on v5.3-rc5

Changes in v3:
- This patch is new in v3

 drivers/nfc/pn533/i2c.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/nfc/pn533/i2c.c b/drivers/nfc/pn533/i2c.c
index 1832cd921ea7..1abd40398a5a 100644
--- a/drivers/nfc/pn533/i2c.c
+++ b/drivers/nfc/pn533/i2c.c
@@ -245,6 +245,11 @@ static int pn533_i2c_remove(struct i2c_client *client)
 }
 
 static const struct of_device_id of_pn533_i2c_match[] = {
+	{ .compatible = "nxp,pn532", },
+	/*
+	 * NOTE: The use of the compatibles with the trailing "...-i2c" is
+	 * deprecated and will be removed.
+	 */
 	{ .compatible = "nxp,pn533-i2c", },
 	{ .compatible = "nxp,pn532-i2c", },
 	{},
-- 
2.23.0

