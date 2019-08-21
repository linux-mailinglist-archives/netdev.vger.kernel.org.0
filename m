Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03CAA993F9
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 14:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387878AbfHVMi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 08:38:59 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:32841 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387808AbfHVMi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 08:38:59 -0400
Received: by mail-wr1-f67.google.com with SMTP id u16so5299699wrr.0;
        Thu, 22 Aug 2019 05:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=2yyL+3tM9mSt5kE1ALeX6Ty5QXmmZMrb4tbRBsxGTeE=;
        b=S+lrkLL6LmaTWZ3kaj59RfGGeeE1zezGYh6F892O434uwJEZQOg2XD3RGHbVhf3zAm
         tTHKhvmxSvON1rh+c/eaAfY0lsR3UPkhGRgu6ytfUuxYHI1vh5irHmJOs5B1PALYQPeo
         Z4jfw5qnG6cpWG1vElUD26JIo3MWJVwjETCK+RVO9dhTlauq6m5QF6AXo5nxXWTY8gOG
         OGGll9V/mGcIGTiGRQcsqyqeyaTeaGfGkA+QYxXuDsWf+dCEl1bVMssikurAlmwV1lqb
         IoFkGMUYO6cfP48T6lye4sMwLFqaN9fI9ojPQtH3L4iZJwkVj5+i2r1jAXrJppzU02Xa
         wGdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2yyL+3tM9mSt5kE1ALeX6Ty5QXmmZMrb4tbRBsxGTeE=;
        b=eBRBKnDR3KvPI2j1ugSha7A8o2Wnd6P0RCLymGiAXXtTbPjRrOgOL8U+u3HX/ZQwCq
         t+zn64Tt/3nONvr58/hbIQofS980CRmeyn1h6iDH9pi5oT8cHHUQmbqP5U6V/YXUmiSP
         Uu1KdMj7UEcyD5GyfBW5BqYeHrask0Y3bXFkUyW1PsCg00TndRw4OHHYC0nd7Up1jmWw
         Epknrx2Bnep6mdnKHewAPUTwi+MJ81DW8HWLg0xUDlNRMUSjIs+/W4JbYtRu0lacBpy5
         GXaL5hqViPiYzbEer69eysN4bu+63ypqCJsWC8f/aavx4T0H84PlX/DAbqwSO27qzezb
         Au1Q==
X-Gm-Message-State: APjAAAW0vwXZTSbSXCrQRnkJCB6KBXWLiN9z5NcHmDAf57cQH3lZJ1ru
        uwSORqQjDpsAAqcSkLE0orMVfsRFjDQ=
X-Google-Smtp-Source: APXvYqyUryLr5qmc3F8K9mBFiNnf8qDauD9NslXpIU3ZO2/cMJ0v1ikma5jdOyRHvow2F8goEmk68w==
X-Received: by 2002:a5d:4f81:: with SMTP id d1mr47254318wru.177.1566477536353;
        Thu, 22 Aug 2019 05:38:56 -0700 (PDT)
Received: from localhost.localdomain.localdomain (67.200.broadband2.iol.cz. [83.208.200.67])
        by smtp.googlemail.com with ESMTPSA id r17sm60719483wrg.93.2019.08.22.05.38.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Aug 2019 05:38:55 -0700 (PDT)
From:   Martin Tomes <tomesm@gmail.com>
To:     isdn@linux-pingi.de
Cc:     gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, netdev@vger.kernel.org,
        Martin Tomes <tomesm@gmail.com>
Subject: [PATCH] Staging: isdn/gigaset : Fix bare unsigned warnings and trailing lines errors
Date:   Wed, 21 Aug 2019 15:27:39 +0000
Message-Id: <1566401259-16921-1-git-send-email-tomesm@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are many bare use of unsigned warnings and trailing statements should be on next line errors from checkpatch.pl script.
Change the code by adding 'unsigned int'. Move 'break' statement of 'switch' command to next line.

Signed-off-by: Martin Tomes <tomesm@gmail.com>
---
 drivers/staging/isdn/gigaset/usb-gigaset.c | 52 ++++++++++++++++++------------
 1 file changed, 31 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/isdn/gigaset/usb-gigaset.c b/drivers/staging/isdn/gigaset/usb-gigaset.c
index 1b9b436..d565242 100644
--- a/drivers/staging/isdn/gigaset/usb-gigaset.c
+++ b/drivers/staging/isdn/gigaset/usb-gigaset.c
@@ -143,16 +143,16 @@ struct usb_cardstate {
 	char			bchars[6];		/* for request 0x19 */
 };
 
-static inline unsigned tiocm_to_gigaset(unsigned state)
+static inline unsigned int tiocm_to_gigaset(unsigned int state)
 {
 	return ((state & TIOCM_DTR) ? 1 : 0) | ((state & TIOCM_RTS) ? 2 : 0);
 }
 
-static int gigaset_set_modem_ctrl(struct cardstate *cs, unsigned old_state,
-				  unsigned new_state)
+static int gigaset_set_modem_ctrl(struct cardstate *cs, unsigned int old_state,
+				  unsigned int new_state)
 {
 	struct usb_device *udev = cs->hw.usb->udev;
-	unsigned mask, val;
+	unsigned int mask, val;
 	int r;
 
 	mask = tiocm_to_gigaset(old_state ^ new_state);
@@ -178,7 +178,7 @@ static int set_value(struct cardstate *cs, u8 req, u16 val)
 	int r, r2;
 
 	gig_dbg(DEBUG_USBREQ, "request %02x (%04x)",
-		(unsigned)req, (unsigned)val);
+		(unsigned int)req, (unsigned int)val);
 	r = usb_control_msg(udev, usb_sndctrlpipe(udev, 0), 0x12, 0x41,
 			    0xf /*?*/, 0, NULL, 0, 2000 /*?*/);
 	/* no idea what this does */
@@ -191,7 +191,7 @@ static int set_value(struct cardstate *cs, u8 req, u16 val)
 			    val, 0, NULL, 0, 2000 /*?*/);
 	if (r < 0)
 		dev_err(&udev->dev, "error %d on request 0x%02x\n",
-			-r, (unsigned)req);
+			-r, (unsigned int)req);
 
 	r2 = usb_control_msg(udev, usb_sndctrlpipe(udev, 0), 0x19, 0x41,
 			     0, 0, cs->hw.usb->bchars, 6, 2000 /*?*/);
@@ -205,7 +205,7 @@ static int set_value(struct cardstate *cs, u8 req, u16 val)
  * set the baud rate on the internal serial adapter
  * using the undocumented parameter setting command
  */
-static int gigaset_baud_rate(struct cardstate *cs, unsigned cflag)
+static int gigaset_baud_rate(struct cardstate *cs, unsigned int cflag)
 {
 	u16 val;
 	u32 rate;
@@ -213,16 +213,26 @@ static int gigaset_baud_rate(struct cardstate *cs, unsigned cflag)
 	cflag &= CBAUD;
 
 	switch (cflag) {
-	case    B300: rate =     300; break;
-	case    B600: rate =     600; break;
-	case   B1200: rate =    1200; break;
-	case   B2400: rate =    2400; break;
-	case   B4800: rate =    4800; break;
-	case   B9600: rate =    9600; break;
-	case  B19200: rate =   19200; break;
-	case  B38400: rate =   38400; break;
-	case  B57600: rate =   57600; break;
-	case B115200: rate =  115200; break;
+	case    B300: rate =     300;
+		      break;
+	case    B600: rate =     600;
+		      break;
+	case   B1200: rate =    1200;
+		      break;
+	case   B2400: rate =    2400;
+		      break;
+	case   B4800: rate =    4800;
+		      break;
+	case   B9600: rate =    9600;
+		      break;
+	case  B19200: rate =   19200;
+		      break;
+	case  B38400: rate =   38400;
+		      break;
+	case  B57600: rate =   57600;
+		      break;
+	case B115200: rate =  115200;
+		      break;
 	default:
 		rate =  9600;
 		dev_err(cs->dev, "unsupported baudrate request 0x%x,"
@@ -345,7 +355,7 @@ static void gigaset_read_int_callback(struct urb *urb)
 	struct inbuf_t *inbuf = cs->inbuf;
 	int status = urb->status;
 	int r;
-	unsigned numbytes;
+	unsigned int numbytes;
 	unsigned char *src;
 	unsigned long flags;
 
@@ -357,7 +367,7 @@ static void gigaset_read_int_callback(struct urb *urb)
 			if (unlikely(*src))
 				dev_warn(cs->dev,
 					 "%s: There was no leading 0, but 0x%02x!\n",
-					 __func__, (unsigned) *src);
+					 __func__, (unsigned int) *src);
 			++src; /* skip leading 0x00 */
 			--numbytes;
 			if (gigaset_fill_inbuf(inbuf, src, numbytes)) {
@@ -517,7 +527,7 @@ static int gigaset_write_cmd(struct cardstate *cs, struct cmdbuf_t *cb)
 
 static int gigaset_write_room(struct cardstate *cs)
 {
-	unsigned bytes;
+	unsigned int bytes;
 
 	bytes = cs->cmdbytes;
 	return bytes < IF_WRITEBUF ? IF_WRITEBUF - bytes : 0;
@@ -611,7 +621,7 @@ static int write_modem(struct cardstate *cs)
 	}
 
 	/* Copy data to bulk out buffer and transmit data */
-	count = min(bcs->tx_skb->len, (unsigned) ucs->bulk_out_size);
+	count = min(bcs->tx_skb->len, (unsigned int) ucs->bulk_out_size);
 	skb_copy_from_linear_data(bcs->tx_skb, ucs->bulk_out_buffer, count);
 	skb_pull(bcs->tx_skb, count);
 	ucs->busy = 1;
-- 
1.8.3.1

