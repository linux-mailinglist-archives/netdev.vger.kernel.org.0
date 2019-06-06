Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63C8F37494
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 14:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbfFFM4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 08:56:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:55630 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727783AbfFFM4J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 08:56:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 09A97AE4D;
        Thu,  6 Jun 2019 12:56:08 +0000 (UTC)
From:   Oliver Neukum <oneukum@suse.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 3/6] usb: hso: switch definitions to the BIT macro
Date:   Thu,  6 Jun 2019 14:55:45 +0200
Message-Id: <20190606125548.18315-3-oneukum@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190606125548.18315-1-oneukum@suse.com>
References: <20190606125548.18315-1-oneukum@suse.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is just a minor improvement in readability.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
---
 drivers/net/usb/hso.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index fe1d7bdc8afe..ab18dbe169f3 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -177,13 +177,13 @@ enum rx_ctrl_state{
 #define W_VALUE         (0x0)
 #define W_LENGTH        (0x2)
 
-#define B_OVERRUN       (0x1<<6)
-#define B_PARITY        (0x1<<5)
-#define B_FRAMING       (0x1<<4)
-#define B_RING_SIGNAL   (0x1<<3)
-#define B_BREAK         (0x1<<2)
-#define B_TX_CARRIER    (0x1<<1)
-#define B_RX_CARRIER    (0x1<<0)
+#define B_OVERRUN       BIT(6)
+#define B_PARITY        BIT(5)
+#define B_FRAMING       BIT(4)
+#define B_RING_SIGNAL   BIT(3)
+#define B_BREAK         BIT(2)
+#define B_TX_CARRIER    BIT(1)
+#define B_RX_CARRIER    BIT(0)
 
 struct hso_serial_state_notification {
 	u8 bmRequestType;
-- 
2.16.4

