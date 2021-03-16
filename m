Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBC133CFB3
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 09:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234491AbhCPIVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 04:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234409AbhCPIVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 04:21:19 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D374C061763
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 01:21:17 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lM4x1-000353-SQ
        for netdev@vger.kernel.org; Tue, 16 Mar 2021 09:21:15 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 81CB35F6447
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 08:21:12 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id BD8315F6415;
        Tue, 16 Mar 2021 08:21:06 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 1de128dd;
        Tue, 16 Mar 2021 08:21:05 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 04/11] can: peak_usb: add forgotten supported devices
Date:   Tue, 16 Mar 2021 09:20:57 +0100
Message-Id: <20210316082104.4027260-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210316082104.4027260-1-mkl@pengutronix.de>
References: <20210316082104.4027260-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephane Grosjean <s.grosjean@peak-system.com>

Since the peak_usb driver also supports the CAN-USB interfaces
"PCAN-USB X6" and "PCAN-Chip USB" from PEAK-System GmbH, this patch adds
their names to the list of explicitly supported devices.

Fixes: ea8b65b596d7 ("can: usb: Add support of PCAN-Chip USB stamp module")
Fixes: f00b534ded60 ("can: peak: Add support for PCAN-USB X6 USB interface")
Link: https://lore.kernel.org/r/20210309082128.23125-3-s.grosjean@peak-system.com
Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
index f347ecc79aef..f1d018218c93 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
@@ -18,6 +18,8 @@
 
 MODULE_SUPPORTED_DEVICE("PEAK-System PCAN-USB FD adapter");
 MODULE_SUPPORTED_DEVICE("PEAK-System PCAN-USB Pro FD adapter");
+MODULE_SUPPORTED_DEVICE("PEAK-System PCAN-Chip USB");
+MODULE_SUPPORTED_DEVICE("PEAK-System PCAN-USB X6 adapter");
 
 #define PCAN_USBPROFD_CHANNEL_COUNT	2
 #define PCAN_USBFD_CHANNEL_COUNT	1
-- 
2.30.1


