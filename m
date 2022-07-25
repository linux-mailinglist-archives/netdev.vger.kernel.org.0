Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA00257F869
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 04:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbiGYC5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 22:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231866AbiGYC5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 22:57:09 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3896211808;
        Sun, 24 Jul 2022 19:57:08 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id bb16so12028007oib.11;
        Sun, 24 Jul 2022 19:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:content-transfer-encoding
         :user-agent:mime-version;
        bh=MNcUH7SY8b/6l09S9HdS39vSTI4No9r1haIIUkkxmfs=;
        b=OSav6bUQJVoHalrYmPxNfP9hFOzHySMwvIgM0NMvOXQLV9EKmF+Z604RcPWJNv7RE1
         ssBRi+jaEoa00Qu910x60rS3bafbdlKIKUCKjpXPpS3jN62vG5Zb1FOO3Ve2uGBOzPPc
         hgMg1bbOvWOl8aFCBIPrYGUALkPFDzmnFTVy2ERmQhgR7r+uJLRJk3p5u2vxoZG9Yt+B
         hAfiVTctPxuv11higO+H3o+do5Fjg56EYdGxN/pz11WaQFNspZg9p4ypeB+S9pk9IptV
         ChvizVB5Iv7eWTzD7Oy9C2nlwc53mt8xJ5hgyzb5+JA+61Fy2MkZy9nREB6rn+tqXNun
         KHkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date
         :content-transfer-encoding:user-agent:mime-version;
        bh=MNcUH7SY8b/6l09S9HdS39vSTI4No9r1haIIUkkxmfs=;
        b=jpTvuMWalSsNOfzrLZC80vhbn4BncHQRP4RYAPSbEfcDi2HyPo5u7N2mwtOZPRV3sv
         UwPhh4YknF/3+ltlS12fu74wjZfprapF5qd7exLhzR+jNLpyLUsyMNRGiFtSaYxKNkP7
         Hs5drYYsi7y7THIIMA9kVh6OH7vNu1NW5HHI5MWiz+FIoxFIZAWJTwvapf4ZGckzFVzs
         ct1KBfA3qKuG3ATyf/0PR+ppcIDrAJUUwRIcCeNjKcws4dY2Rc/j47evP0/b3nIxfnkX
         rJJDKfYfT4/dEcSRN71JPOqGhcBoV/fwmeyb2H66/sDCHAAG5svmMWTVtqjBievNxRSl
         9Etw==
X-Gm-Message-State: AJIora88pUT4Z8PR1cUdUntMKzPa3BHIMmF75HWVzbamnn1sS/GXAt9x
        GWqS5vq2k6tVmQRqoJjr7THCXndptuSFdQ==
X-Google-Smtp-Source: AGRyM1sccDKSu3F6EQgjYnUvIVF5IGT1P/U1ZvJ9XNoh/0hVYNmKDRNZH54LSJUMzTA7j2gDWwlfhA==
X-Received: by 2002:a05:6808:1a16:b0:33a:9edb:4e16 with SMTP id bk22-20020a0568081a1600b0033a9edb4e16mr4743894oib.118.1658717827582;
        Sun, 24 Jul 2022 19:57:07 -0700 (PDT)
Received: from ?IPv6:2804:14c:71:96e6:64c:ef9b:3df0:9e8d? ([2804:14c:71:96e6:64c:ef9b:3df0:9e8d])
        by smtp.gmail.com with ESMTPSA id h1-20020a4a4201000000b004357c1d1efasm4391123ooj.21.2022.07.24.19.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jul 2022 19:57:07 -0700 (PDT)
Message-ID: <4c11b3866f5dfc787fa477a6307096db9319c454.camel@gmail.com>
Subject: Patch for 4.9 stable tree "net: usb: ax88179_178a needs
 FLAG_SEND_ZLP"
From:   Jose Alonso <joalonsof@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Date:   Sun, 24 Jul 2022 23:57:04 -0300
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For 4.9 stable tree:
--------------------
From 36a15e1cb134c0395261ba1940762703f778438c Mon Sep 17 00:00:00 2001
From: Jose Alonso <joalonsof@gmail.com>
Date: Mon, 13 Jun 2022 15:32:44 -0300
Subject: net: usb: ax88179_178a needs FLAG_SEND_ZLP

From: Jose Alonso <joalonsof@gmail.com>

commit 36a15e1cb134c0395261ba1940762703f778438c upstream.

The extra byte inserted by usbnet.c when
 (length % dev->maxpacket =3D=3D 0) is causing problems to device.

This patch sets FLAG_SEND_ZLP to avoid this.

Tested with: 0b95:1790 ASIX Electronics Corp. AX88179 Gigabit Ethernet

Problems observed:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
1) Using ssh/sshfs. The remote sshd daemon can abort with the message:
   "message authentication code incorrect"
   This happens because the tcp message sent is corrupted during the
   USB "Bulk out". The device calculate the tcp checksum and send a
   valid tcp message to the remote sshd. Then the encryption detects
   the error and aborts.
2) NETDEV WATCHDOG: ... (ax88179_178a): transmit queue 0 timed out
3) Stop normal work without any log message.
   The "Bulk in" continue receiving packets normally.
   The host sends "Bulk out" and the device responds with -ECONNRESET.
   (The netusb.c code tx_complete ignore -ECONNRESET)
Under normal conditions these errors take days to happen and in
intense usage take hours.

A test with ping gives packet loss, showing that something is wrong:
ping -4 -s 462 {destination}	# 462 =3D 512 - 42 - 8
Not all packets fail.
My guess is that the device tries to find another packet starting
at the extra byte and will fail or not depending on the next
bytes (old buffer content).
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Signed-off-by: Jose Alonso <joalonsof@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/ax88179_178a.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1703,7 +1703,7 @@ static const struct driver_info ax88179_info =3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset =3D ax88179_reset,
 	.stop =3D ax88179_stop,
-	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1716,7 +1716,7 @@ static const struct driver_info ax88178a_info =3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset =3D ax88179_reset,
 	.stop =3D ax88179_stop,
-	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1729,7 +1729,7 @@ static const struct driver_info cypress_GX3_info =3D =
{
 	.link_reset =3D ax88179_link_reset,
 	.reset =3D ax88179_reset,
 	.stop =3D ax88179_stop,
-	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1742,7 +1742,7 @@ static const struct driver_info dlink_dub1312_info =
=3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset =3D ax88179_reset,
 	.stop =3D ax88179_stop,
-	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1755,7 +1755,7 @@ static const struct driver_info sitecom_info =3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset =3D ax88179_reset,
 	.stop =3D ax88179_stop,
-	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1768,7 +1768,7 @@ static const struct driver_info samsung_info =3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset =3D ax88179_reset,
 	.stop =3D ax88179_stop,
-	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1781,7 +1781,7 @@ static const struct driver_info lenovo_info =3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset =3D ax88179_reset,
 	.stop =3D ax88179_stop,
-	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };

