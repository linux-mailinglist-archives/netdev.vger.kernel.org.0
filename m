Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E14D37497
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 14:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbfFFM4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 08:56:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:55628 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727836AbfFFM4J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 08:56:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0CC3BAE87;
        Thu,  6 Jun 2019 12:56:08 +0000 (UTC)
From:   Oliver Neukum <oneukum@suse.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 4/6] usb: hso: declare endianness
Date:   Thu,  6 Jun 2019 14:55:46 +0200
Message-Id: <20190606125548.18315-4-oneukum@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190606125548.18315-1-oneukum@suse.com>
References: <20190606125548.18315-1-oneukum@suse.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver declares data structures with defined endianness as
u16. Be more precise.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
---
 drivers/net/usb/hso.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index ab18dbe169f3..7379df01cd98 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -188,10 +188,10 @@ enum rx_ctrl_state{
 struct hso_serial_state_notification {
 	u8 bmRequestType;
 	u8 bNotification;
-	u16 wValue;
-	u16 wIndex;
-	u16 wLength;
-	u16 UART_state_bitmap;
+	__le16 wValue;
+	__le16 wIndex;
+	__le16 wLength;
+	__le16 UART_state_bitmap;
 } __packed;
 
 struct hso_tiocmget {
@@ -201,7 +201,7 @@ struct hso_tiocmget {
 	struct usb_endpoint_descriptor *endp;
 	struct urb *urb;
 	struct hso_serial_state_notification serial_state_notification;
-	u16    prev_UART_state_bitmap;
+	__le16    prev_UART_state_bitmap;
 	struct uart_icount icount;
 };
 
-- 
2.16.4

