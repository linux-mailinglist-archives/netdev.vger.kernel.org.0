Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E865A1A5260
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 15:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgDKNju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 09:39:50 -0400
Received: from canardo.mork.no ([148.122.252.1]:45483 "EHLO canardo.mork.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726054AbgDKNjt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 09:39:49 -0400
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 03BDdmpZ022975
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Sat, 11 Apr 2020 15:39:48 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1586612388; bh=7m/AdLPPqzm9a8J+2GRplR0V6UvaC9m18ntQKA+cOLo=;
        h=From:To:Cc:Subject:Date:Message-Id:From;
        b=X2hOncnPr8ZLY5d1Gud03YG1i8I9NKj2Iv6L0O8BMaJJJ6I6Pk/+wDSSR7jnD4ixH
         vKtr+ZFHCLoXnUiHb2Khy/HBe9o160abOn1p/5Riw8IClaHSShPuKmMB+XoEbUXRBM
         YBTUBDWxa6v4d2aGWF1aLBs0bER5ZEv8S8RNVn0Y=
Received: from bjorn by miraculix.mork.no with local (Exim 4.92)
        (envelope-from <bjorn@miraculix.mork.no>)
        id 1jNGMN-000109-Ri; Sat, 11 Apr 2020 15:39:47 +0200
From:   =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To:     netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH net,stable] qmi_wwan: add Huawei E1820
Date:   Sat, 11 Apr 2020 15:39:41 +0200
Message-Id: <20200411133941.3806-1-bjorn@mork.no>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.102.1 at canardo
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Older Huawei modem, not using the "standard" Huawei class scheme.
Supporting QMI on the 02/06/ff function.

T:  Bus=01 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  3 Spd=480  MxCh= 0
D:  Ver= 2.00 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=12d1 ProdID=14ac Rev= 0.00
S:  Manufacturer=Huawei Technologies
S:  Product=HUAWEI Mobile
C:* #Ifs= 7 Cfg#= 1 Atr=c0 MxPwr=500mA
A:  FirstIf#= 1 IfCount= 2 Cls=02(comm.) Sub=00 Prot=00
I:* If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
E:  Ad=81(I) Atr=03(Int.) MxPS=  64 Ivl=2ms
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=4ms
I:* If#= 1 Alt= 0 #EPs= 1 Cls=02(comm.) Sub=06 Prot=ff Driver=qmi_wwan
E:  Ad=83(I) Atr=03(Int.) MxPS=  64 Ivl=2ms
I:* If#= 2 Alt= 0 #EPs= 2 Cls=0a(data ) Sub=00 Prot=00 Driver=qmi_wwan
E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=4ms
I:* If#= 3 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
E:  Ad=85(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=4ms
I:* If#= 4 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
E:  Ad=86(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=4ms
I:* If#= 5 Alt= 0 #EPs= 2 Cls=08(stor.) Sub=06 Prot=50 Driver=usb-storage
E:  Ad=87(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 6 Alt= 0 #EPs= 2 Cls=08(stor.) Sub=06 Prot=50 Driver=usb-storage
E:  Ad=06(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=88(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms

Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
 drivers/net/usb/qmi_wwan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 6c738a271257..08614f1e7407 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -965,6 +965,10 @@ static const struct usb_device_id products[] = {
 		USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, USB_CLASS_VENDOR_SPEC, 0x01, 0x69),
 		.driver_info        = (unsigned long)&qmi_wwan_info,
 	},
+	{	/* Huawei E1820 */
+		USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0x14ac, USB_CLASS_COMM, USB_CDC_SUBCLASS_ETHERNET, 0xff),
+		.driver_info        = (unsigned long)&qmi_wwan_info,
+	},
 	{	/* Motorola Mapphone devices with MDM6600 */
 		USB_VENDOR_AND_INTERFACE_INFO(0x22b8, USB_CLASS_VENDOR_SPEC, 0xfb, 0xff),
 		.driver_info        = (unsigned long)&qmi_wwan_info,
-- 
2.20.1

