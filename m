Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A85E68BDFB
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 14:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbjBFNTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 08:19:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbjBFNSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 08:18:34 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564B72364B
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 05:17:41 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pP1NK-0008Ix-Gz
        for netdev@vger.kernel.org; Mon, 06 Feb 2023 14:17:38 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id BF65D171476
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 13:16:27 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id A30501712D5;
        Mon,  6 Feb 2023 13:16:23 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 039f587b;
        Mon, 6 Feb 2023 13:16:22 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Gerhard Uttenthaler <uttenthaler@ems-wuensche.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 22/47] can: ems_pci: Add myself as module author
Date:   Mon,  6 Feb 2023 14:15:55 +0100
Message-Id: <20230206131620.2758724-23-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230206131620.2758724-1-mkl@pengutronix.de>
References: <20230206131620.2758724-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gerhard Uttenthaler <uttenthaler@ems-wuensche.com>

Added myself as module author

Signed-off-by: Gerhard Uttenthaler <uttenthaler@ems-wuensche.com>
Link: https://lore.kernel.org/all/20230120112616.6071-9-uttenthaler@ems-wuensche.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/sja1000/ems_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/sja1000/ems_pci.c b/drivers/net/can/sja1000/ems_pci.c
index 212d051c53c0..c56e27223e5f 100644
--- a/drivers/net/can/sja1000/ems_pci.c
+++ b/drivers/net/can/sja1000/ems_pci.c
@@ -21,6 +21,7 @@
 #define DRV_NAME  "ems_pci"
 
 MODULE_AUTHOR("Sebastian Haas <support@ems-wuensche.com>");
+MODULE_AUTHOR("Gerhard Uttenthaler <uttenthaler@ems-wuensche.com>");
 MODULE_DESCRIPTION("Socket-CAN driver for EMS CPC-PCI/PCIe/104P CAN cards");
 MODULE_LICENSE("GPL v2");
 
-- 
2.39.1


