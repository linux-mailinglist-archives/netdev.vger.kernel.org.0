Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98D1C59FF33
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 18:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237869AbiHXQNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 12:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236248AbiHXQNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 12:13:36 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF5C80036;
        Wed, 24 Aug 2022 09:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1661357601;
        bh=RITRmdFYonKaiGv2xsH9XHj0MS3G4Ogg8tbbihG4OHQ=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=SLP3aj+TT1lyJXmPfd9god9pociCeV5B+LnHuf7vD6k4lp4F3oQ9/wkvn4dfrAYR5
         kAMwE02nNjj5K9AcX4IbKoeo0TnQnFrdCDlqdrjQH9cv2rF9LnglfXrpDR0jn4wQN7
         PflJvIs91ZICqk3/HtnpeJZgZCpckSsCmPcD/mJY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from silverpad ([82.113.106.57]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MHGCu-1oe8Xo2ilk-00DEks; Wed, 24
 Aug 2022 18:13:20 +0200
From:   JFLF <jflf_kernel@gmx.com>
To:     oliver@neukum.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     JFLF <jflf_kernel@gmx.com>
Subject: [PATCH] r8152: add PID for the Lenovo OneLink+ Dock
Date:   Wed, 24 Aug 2022 18:13:07 +0200
Message-Id: <20220824161307.10243-1-jflf_kernel@gmx.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:sE9h4WF99wC14srgPhDtHwwJvX9tNGQs4iEFl2rQPP/B8W6wb5j
 z1sG7sz14TgEQXWOoBuyiDWIQnSZMXLlGERH/Xn+SNbVLYtHBrsVd13HIDallo9j701Ajq9
 OBwKS7ElV/LhHpsOlm8MQSesWtt/AprYA87sGJrbvyMwMQNxEGpx85dTEsl7SAs/Rhz0CHC
 Qpg5gy433Wn+g+E/E95GQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:WE9XvrjLW1A=:GmQrDdornC5qcKzMyiOxae
 bwHbvjMmpUtNpQhvfLcy/goCqILKLgc3Ys7QvUBzUrvZnymaWUPwbR7Cn0s4vhvMmGsTltPMq
 pi7+arOe1FTN4qQ5qJapqt58LLGm5NAwWWTxMfXxU4+t7RMr0XQnW3xqrX26ikgrePlvncnmh
 gcyu074f315ULsgigYhVP5f3Rkykiz8SueNk0ASRcPif0tFuF2gIF1ESCNR+zBFey954q+fC8
 yJbK30BMMSBzNsEuboZZjik9415zqa5wTGbvzKuohPXd5o7edo62CnuffMq86BrY8vVnJjlgB
 P+D0/MF/ctOSyhOAZTMjtnMH6Iu1yKcemYbZuQpU3otB81edqLv2YVebE/1MM9t34C3uduxLh
 bMVeAXDHglbjtmlDS+iEAChRlnTglL5XnPqekfB3p5htCG9wUv44hhNyiANHh7yZ05zr84QYi
 cIctPDzZnqs65xxY2FnZ1NBqtTpiPbpNJYtEadnjbdXhbpbOVsscqp8MgSVEiDLvsAlqKZH63
 xL+HQOqkFcghH/0RqDaHsZcJ8qCdcX4PEYKxf5meHWyubJDuaIYCq1OPUZ+9uluHOYJGLbmpX
 e3BpiyoO/Gx2O1xDZrKwVQfPiHC23o/7/1TGcCPobLUVRuEa82CidoF2Atv1mKZVWg1fkW8bE
 jpmY2xgQDJdLH7fF1fdzn9L/+wY6ZXU8+ybniQgO5OrHdUY3YDmJlp0SbaTpZKeJLPRzRNFP9
 gdCQ6WKzv38CwTQ5+ZNBsEeQpXvU/hy8DEIY6FmvKKZmdv8u41FJZ0dpxMH0n1rOQjPyoSV6z
 qxdehoB/EKz4L96NShRoBmLR0jCBlD6S6xcJbwLIMQmVIiJj90+JV7OwLzKQlvqLOVk5hRMRK
 hKraboWrR2YBjk3wsR2PLjYaAgPeMGgOK37+OyHxZdql1i+QbZswXwYRaHm4+4d5dmkTc24Bw
 zLl8GV801i6RuHu1jCE+Z5IWniyIPJn5kVhCDqGnZ33gQIXMNg3dBaY8FgmLmDhJ23MHOuFfu
 exYInm6KHbQp/RXnrS8DVjG6Jq5DOcFclV/5DlMS6ypST7c7tRVAlGXHfTfzvHZ5ioEgk9yja
 j9laURZxLqybi7ec6vTCyH1DrZGAoWLGwgRmgdSmbA36ZCNtl2g4GiqWA==
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Lenovo OneLink+ Dock contains an RTL8153 controller that behaves as
a broken CDC device by default. Add the custom Lenovo PID to the r8152
driver to support it properly.

Also, systems compatible with this dock provide a BIOS option to enable
MAC address passthrough (as per Lenovo document "ThinkPad Docking
Solutions 2017"). Add the custom PID to the MAC passthrough list too.

Tested on a ThinkPad 13 1st gen with the expected results:

passthrough disabled: Invalid header when reading pass-thru MAC addr
passthrough enabled:  Using pass-thru MAC addr XX:XX:XX:XX:XX:XX

Signed-off-by: JFLF <jflf_kernel@gmx.com>
=2D--
 drivers/net/usb/cdc_ether.c | 7 +++++++
 drivers/net/usb/r8152.c     | 3 +++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index 2de09ad5b..e11f70911 100644
=2D-- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -777,6 +777,13 @@ static const struct usb_device_id	products[] =3D {
 },
 #endif

+/* Lenovo ThinkPad OneLink+ Dock (based on Realtek RTL8153) */
+{
+	USB_DEVICE_AND_INTERFACE_INFO(LENOVO_VENDOR_ID, 0x3054, USB_CLASS_COMM,
+			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	.driver_info =3D 0,
+},
+
 /* ThinkPad USB-C Dock (based on Realtek RTL8153) */
 {
 	USB_DEVICE_AND_INTERFACE_INFO(LENOVO_VENDOR_ID, 0x3062, USB_CLASS_COMM,
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 0f6efaaba..e692a1576 100644
=2D-- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -770,6 +770,7 @@ enum rtl8152_flags {
 	RX_EPROTO,
 };

+#define DEVICE_ID_THINKPAD_ONELINK_PLUS_DOCK		0x3054
 #define DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2	0x3082
 #define DEVICE_ID_THINKPAD_USB_C_DONGLE			0x720c
 #define DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2		0xa387
@@ -9584,6 +9585,7 @@ static bool rtl8152_supports_lenovo_macpassthru(stru=
ct usb_device *udev)

 	if (vendor_id =3D=3D VENDOR_ID_LENOVO) {
 		switch (product_id) {
+		case DEVICE_ID_THINKPAD_ONELINK_PLUS_DOCK:
 		case DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2:
 		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2:
 		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN3:
@@ -9831,6 +9833,7 @@ static const struct usb_device_id rtl8152_table[] =
=3D {
 	REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x0927),
 	REALTEK_USB_DEVICE(VENDOR_ID_SAMSUNG, 0xa101),
 	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x304f),
+	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3054),
 	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3062),
 	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3069),
 	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3082),
=2D-
2.34.1

