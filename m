Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD0F857F863
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 04:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbiGYCz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 22:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbiGYCz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 22:55:58 -0400
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2437F1115F;
        Sun, 24 Jul 2022 19:55:58 -0700 (PDT)
Received: by mail-oo1-xc2d.google.com with SMTP id t11-20020a4ad0ab000000b004356ab59d3bso1946444oor.7;
        Sun, 24 Jul 2022 19:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:content-transfer-encoding
         :user-agent:mime-version;
        bh=h60lCE3oBROb+4ER/R2GZ32rbZ3q2pXMIhvMgRxpRmI=;
        b=dNJDvYxzBcS6ohJCwoCT2knsDkdmg3QaEfRHV6PaWhoT4EZ7aa2unK+g8w3MoOJVhx
         1lgKNpa4ZJWc8B2k3jtY/U/hzxM0wfVO4PfyPCaTATlhnANx9IKIojrJY9fRBRaUXF4h
         A/tAMjlK/+gSRKyichMHiJvdPZs6TSfa8tO5W4pVU1ESjYnyy0pJJMTbDW1BkFPwKhsI
         6mGgsHL+dfZMxE/O1qST0bugtn4dH1LKeg2emo58Yr1HM4wzbJ2vzf+iLpdwdgas9/bK
         5RNNWmNfnOEwBZzwuO3KpQvlUAOJ/PyHBfSkB4kvUqZjI89vZMeVEHRZEtxd7e5cGXC6
         mu/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date
         :content-transfer-encoding:user-agent:mime-version;
        bh=h60lCE3oBROb+4ER/R2GZ32rbZ3q2pXMIhvMgRxpRmI=;
        b=sA+9CBEUA5p9IxJZ5Op5A9y2X06Wq7BexECb6Wsdi00AYQwUwmffQf1mLfOeCajTXb
         4oO7/fa2a/QBFRYJgacrAIx4hUkMU7Q0pIyfrOMyuF1OQASqXQTuQVJ499k8tvsEIrrA
         pO+xpYEbfAKpOLDFTn3Xplra+onzCpF+2vBgV/eiY2vdoDqI7CnoPp6DcHL5VPDHPE5N
         l+CWzVExNkD0Fk5yIGrKzqnqfVwNvVcDBXyaRQSoQwJSmyr/PnpPP/9NkGqyOuP1MjW8
         9W54p3GeuYeo48UnGy9XAyTMEadyK3VX/PnBg4NolTvVWc4P19nnmQhUiogPNw+G0QZC
         EwMQ==
X-Gm-Message-State: AJIora/lPnorOXDAHloqLlx9NV1UcNO/vuaVoimJddfqk8MDt6P/tU7d
        pTMfH1SnAzD4OnsCAbBwHMM=
X-Google-Smtp-Source: AGRyM1sE1TegqbJnyxiSm34K+RLaoPk5aPRnZ/7oH+IS2bi8zQbvt7GQ0Wow5zUZDKvQCPyQRBLdVA==
X-Received: by 2002:a4a:b048:0:b0:435:b7b4:7505 with SMTP id g8-20020a4ab048000000b00435b7b47505mr3550365oon.57.1658717757437;
        Sun, 24 Jul 2022 19:55:57 -0700 (PDT)
Received: from ?IPv6:2804:14c:71:96e6:64c:ef9b:3df0:9e8d? ([2804:14c:71:96e6:64c:ef9b:3df0:9e8d])
        by smtp.gmail.com with ESMTPSA id d64-20020a4a5243000000b00431003ca076sm4378392oob.44.2022.07.24.19.55.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jul 2022 19:55:57 -0700 (PDT)
Message-ID: <a539c2eea77b33036f282c96b7684e8af8d588c4.camel@gmail.com>
Subject: Patch for 5.4 stable tree "net: usb: ax88179_178a needs
 FLAG_SEND_ZLP"
From:   Jose Alonso <joalonsof@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Date:   Sun, 24 Jul 2022 23:55:55 -0300
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

For 5.4 stable tree:
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
 drivers/net/usb/ax88179_178a.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1690,7 +1690,7 @@ static const struct driver_info ax88179_info =3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset =3D ax88179_reset,
 	.stop =3D ax88179_stop,
-	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1703,7 +1703,7 @@ static const struct driver_info ax88178a_info =3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset =3D ax88179_reset,
 	.stop =3D ax88179_stop,
-	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1716,7 +1716,7 @@ static const struct driver_info cypress_GX3_info =3D =
{
 	.link_reset =3D ax88179_link_reset,
 	.reset =3D ax88179_reset,
 	.stop =3D ax88179_stop,
-	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1729,7 +1729,7 @@ static const struct driver_info dlink_dub1312_info =
=3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset =3D ax88179_reset,
 	.stop =3D ax88179_stop,
-	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1742,7 +1742,7 @@ static const struct driver_info sitecom_info =3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset =3D ax88179_reset,
 	.stop =3D ax88179_stop,
-	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1755,7 +1755,7 @@ static const struct driver_info samsung_info =3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset =3D ax88179_reset,
 	.stop =3D ax88179_stop,
-	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1768,7 +1768,7 @@ static const struct driver_info lenovo_info =3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset =3D ax88179_reset,
 	.stop =3D ax88179_stop,
-	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1781,7 +1781,7 @@ static const struct driver_info belkin_info =3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset	=3D ax88179_reset,
 	.stop	=3D ax88179_stop,
-	.flags	=3D FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags	=3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };

