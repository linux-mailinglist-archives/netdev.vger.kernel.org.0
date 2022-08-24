Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5871D5A01F2
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 21:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239116AbiHXTPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 15:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239657AbiHXTPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 15:15:38 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D861BE0E2;
        Wed, 24 Aug 2022 12:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1661368520;
        bh=uIvt0oF2zqE3yCPJ59JRPqlEWFJymwqLIf9WiRpbsSA=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=HtIIxLEo6ZzHNLhGsiXIuYquj7+lW1eBf0xCE81uVQsWKUkYnVvyj7ZbMSS9UOVVS
         29LMF/NffhpoJzDmy/6lt+TTrndJKpaf0npEt4sCynBnvASjqXbYaj5hZiVopUZfB3
         Vsy9/CwfuVY7Qyi4XixxAOvzMs7Q6iw7l0rVG4Aw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from silverpad ([89.204.135.131]) by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MgNcz-1p5TOh1ZL5-00hv5r; Wed, 24
 Aug 2022 21:15:20 +0200
From:   Jean-Francois Le Fillatre <jflf_kernel@gmx.com>
To:     oliver@neukum.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jean-Francois Le Fillatre <jflf_kernel@gmx.com>
Subject: [PATCH v3] r8152: add PID for the Lenovo OneLink+ Dock
Date:   Wed, 24 Aug 2022 21:14:36 +0200
Message-Id: <20220824191435.17910-1-jflf_kernel@gmx.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:i4CYBF3hj89H3McJjNdj1uVYhJzwCVJmjfsyEwCC0v5u5+oDlBW
 hY0vKP2sjbQKu8MySLFit3Tv/yVqxkaBScOozHoFTH/sI1aQnML5nXnQ6TxrOXrx5TNVa55
 phl+gk2pfJhqRrljxYvJN3LZcNhqFJEO5cjf6h0mBejz9dQPKMp28XvbLAhofWYG/EYMFSx
 +NP/hKDikTqTVGPs3Bl3g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:eF0Hp2Ge24I=:T8/AcajRVXkyPojZqW0JHF
 cdN6uGGpllioMgAZLEh9yIidcM+xCY8qD7uTFi7Wh7uRzFs5MYWcFtIUwB5d6Mbeq1KtSlY1Q
 qCq6kWbAO8P57wvpstAb+Hmbwi1KkNuWO3oLrvy4/P/pigfzS50H1V9e2+Kc6RcFVKrhSowgQ
 s22LGs4jXGBIQmERrGVpR/ClWXc48+JlWEKXiFUiluUW+SSdkFngLA12j9aLKTj+Fq6eHx+1w
 ufT2EpPXdtEysbDvFUFHfb9X9jHKj/uDvG9j+qU/GXyevNtTNyDOCmxid2id+nx/jp7t/hLZ9
 ia+MPpW5b3xZTl/9drva4b1CcWiaHO4/teZmYW9FIofuEZSiDUo7J9vH30WW+l2IaGV8zpC8B
 Orqp9JaYVQIbNSMHtQl7wS9rdxuomRwoTNvXVABG1AWRsKjxyCGhORfLtHVvSJEtxPF7XzmSh
 ulB5kwdSAv7QddWW4ZhIpLZhGo/ifEedgVGsGPrZ+ZpnPAyaJ5sXEp0tJb3Fe0CYdAO5cO59I
 7wGJ7mXG7fDN8rCn2qU1jjxnnu3ZrioCDnbHYjUbaT/ho87KMpBhFy67D93Hx+kUJvx5kFv/0
 EOLRmX3DsLo3TFjdlJ+Qj3fbBTXqyyaRPAdTl1xDNrbRBeIs8Re9KX9GxoRpYntZx06Q6iumE
 NrdxP+EsmItQ8TWiAQD/tQPmDsuJePTDLAfItkIZvm5reH11ZVP3OUKHqyF5knJCexdqz/n4Z
 0VnYED3qmYBpTIcBent+6VvgvkvuG/pfG+2DtKR7BgimOVym2v3MdSrZcJqIbZzKjlZF+3045
 Aq/+xLasyaHfK0to+X7/1J/EjbMFQcF/fKcTUtUo8mULKgNHx0KPalytNgZIzP/6eT/ksQKEV
 BQkrAi52wEyh2n8EMVe+o5jv/AydpWTOsv9+j+9uN/2z/CZKmJXLir4h1otjvhdZ9nFdgc4RY
 /aLohgwEDCpvc16WeTSzW992H4/Zje0qDJjY1iYshWRjPzdR1WQn5ouSz/yp/QQHAAxPBgN+W
 pTZPVTWgGVijA3UXXBVM723wJ3pUS1fgiHFEThjVdwkc3xLjiVP5By1ixWsVbCugJ+QlVc8Un
 pUKNrP1C3vKwf+H61meUQyeVQBE+fS43n0C+Yq+eMOkEQnV68XRA5NJAA==
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

Signed-off-by: Jean-Francois Le Fillatre <jflf_kernel@gmx.com>
=2D--
v2 -> v3: fix commit email address, add revision details
v1 -> v2: use full author name


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

