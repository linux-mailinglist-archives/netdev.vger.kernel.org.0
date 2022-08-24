Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C688E59FF80
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 18:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238155AbiHXQ2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 12:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231838AbiHXQ2O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 12:28:14 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0961382F8D;
        Wed, 24 Aug 2022 09:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1661358478;
        bh=/JoCUmYyXJpMrmMGoBDe1GVrcRBpSz2UCYx2nBYqnrI=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=hdicWkl6A5DLxc1Wu7iQlkEoyQnbt3Qg3bGL9Dg4FYVmtXmwwnJq4giwn+PvB6aPh
         lqRO1oD+uXumt27iGHdGmAKNZMuqg5gxD+9yO2ubAzpsWQZWOtc8YsLDEvgwtOaVCf
         BGBYS7yiK9EJYlapt4zNRxuKYTKgX+SGVHFVRaUM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from silverpad ([82.113.106.57]) by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MvK4f-1pI1qm3Xgf-00rFKd; Wed, 24
 Aug 2022 18:27:58 +0200
From:   Jean-Francois Le Fillatre <jflf_kernel@gmx.com>
To:     oliver@neukum.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     JFLF <jflf_kernel@gmx.com>
Subject: [PATCH v2] r8152: add PID for the Lenovo OneLink+ Dock
Date:   Wed, 24 Aug 2022 18:27:51 +0200
Message-Id: <20220824162751.11881-1-jflf_kernel@gmx.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:6FZAJtIqXhXav3lOfcXwUhEu6JC99LFsPjFBMODnDY8h00Jt5Pz
 p9Y9DpKtQ8r98M0scFU/LofzRfqAajzg8NRUuQJBkNSQMhlXa+XZyWNJgw0QBw6NVRnzZOQ
 4aEz8kRyE5EjVx59rb1rV6NVhedqQzQJjtNLaYbcdhOphkWDqeGoTv3c7i+VezkmNIhb/rV
 7yBT6LBrZvPvmyY1aeqyA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:xfpsgQm5lWw=:kCHZi2jY/E9O50va/kemj7
 xAlzXxfjYzHGx2ShDXx7MJ6Y0E6m+I8wpdJBT6gmjjGj4dGA4rD7xIcrEHiXM5b3CdluYnHDP
 XVDvjN394IBnMN904NkGn9Zde4cizcCZwLFHin5E+qTHZZy1QUWX95SVN0bZD9lOT/zCC+jF5
 JrqFfJ9XdONR3cjja36XHjWUkxWlj0baMmqBqE+O5BHFy3f08JHffQjaWzadA9OPyIuj/5bH1
 9MXpCi02TjGeHJ85ak7oB4yn1egSApF/if43Bl1cl/zQ3PigVj9Vo5nqNw7AqeGC935WUw5kl
 doRsYzJFJqSs3r8t+f0PRrz4UJJxvFu6lHnJHtyMzeuiyXdwcYHwGSrDTTElEBL3oaBQtvu3Z
 ejun+rYJtYyJ4EL4ZUu31dr9uAlMUEUJHkMnw9QiZiN3oj6ucjefrRQ7grjaIe0Cj/4yBZe8a
 1JU6p9bfuBYlYVx2hiLfMZfJc7HTCqDOeJVQDwNcjhn2XcpxlHUs51kR/K2+lLEyGBUXm2gIH
 SmbuSWhdxrEZ/vt3mnT60Ef1ZZcImhs/4uIpvcaG9ovIrGl0EtPEUwJg4uKpQFRoloDY9Zxzu
 dEOcP0HHYnew7RzYbdIQCzpldulZGa3qlOY7vbPqwixQHdE8s49JrPfNH3Vtj1syhpaH6brRm
 WzAGxbfOfqtMGc/o2LKSDeDPW6aBCzOhAs4xCuxl5EzPad/PHQ/zaObNcq8DQBkzMeiimOQYR
 Akwo4c47A1bNRvbdGkiVZ30KVdCrCswCX6efhwMPjl/2kOajTmP2fGkxqUrCyGQeOUQRby8UN
 NoPAm2jQNAeYHs6YkYG/yEX7YDnQ734osg4g0S2WOWNLOI/bQRaW0B66jKzQs1Jodse30kh0u
 xSihvXUp+YF1urtov3G3K0CL/rxpOLonF5O3YknH8Mb7de2Vx/+YchMwCeOvKonvbXaez39sf
 nxdFKACd5sFINSBczlkPvHtSrANeAPTwg3u3CWFweftMaBYjH/NWqYKyJlo+9P2lLxuK01ISc
 jUcSZ4NBSPi0iu5EM8e9Crc8ezclENw6H//bbGh9zJwZTIlYGgsO2kz8EbUKtiKwRvXdXKyr1
 vXvLVINWkBuG8rMj95Fs8M39CnkVTA9jjTcUQocypWhyl7Dr+T9jD+RsmzwiUspzTtji2qOD0
 8UvtNORaG9BZ1txy2Yg7aSsv7rt/NnZHtu1mX1NIs3E2za6tIG7fu0DgmDSbuirBjjAGXwFy4
 cHIYwtwl2g5FY4wefYlLLI1csTWY7JOLmAkrxYiFYSDzkv6U/AnWoCKjuHHkRvzsOW3qHvbmE
 Pve3al4FXgmLZkfXmLzAvNlRuyZlAg==
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: JFLF <jflf_kernel@gmx.com>

The Lenovo OneLink+ Dock contains an RTL8153 controller that behaves as
a broken CDC device by default. Add the custom Lenovo PID to the r8152
driver to support it properly.

Also, systems compatible with this dock provide a BIOS option to enable
MAC address passthrough (as per Lenovo document "ThinkPad Docking
Solutions 2017"). Add the custom PID to the MAC passthrough list too.

Tested on a ThinkPad 13 1st gen with the expected results:

passthrough disabled: Invalid header when reading pass-thru MAC addr
passthrough enabled:  Using pass-thru MAC addr XX:XX:XX:XX:XX:XX

Signed-off-by: Jean-Francois Le Fillatre <jflf_kernel@gmx.com>
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

