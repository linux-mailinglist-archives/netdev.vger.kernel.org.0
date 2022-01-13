Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7DFA48D1A0
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 05:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiAMEWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 23:22:44 -0500
Received: from mail-smail-vm96.daum.net ([211.231.106.171]:10003 "EHLO
        mail-smail-vm96.hanmail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229729AbiAMEWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 23:22:43 -0500
X-Greylist: delayed 310 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Jan 2022 23:22:43 EST
Received: from mail-hmail-smtp2 ([10.194.31.52])
        by mail-smail-vm96.hanmail.net (8.13.8/8.9.1) with SMTP id 20D4HAfT013314;
        Thu, 13 Jan 2022 13:17:11 +0900
X-Kakaomail-MID: CsIfNAAAMb4AAAF+UaddDAB5A0M=
X-Hermes-Message-Id: q0DDH9t6K1806451193
X-Originating-IP: 121.128.138.119
Received: from mail-qpsmtp-vm17 ([10.61.241.164]) by hermes of mail-hmail-smtp2 (10.194.31.52) with ESMTP id q0DDH9t6K1806451193; Thu, 13 Jan 2022 13:17:09 +0900 (KST)
Received: from [121.128.138.119] (HELO choryu-tfx5470h) (121.128.138.119)
 by  (8.12.9/8.9.1) with ESMTPA; Thu, 13 Jan 2022 13:17:09 +0900
Authentication-Results: mail-qpsmtp-vm17; auth=pass (plain) smtp.auth=yous87aa
Date:   Thu, 13 Jan 2022 13:17:08 +0900
From:   Kyoungkyu Park <choryu.park@choryu.space>
To:     bjorn@mork.no
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH] net: qmi_wwan: Add Hucom Wireless HM-211S/K
Message-ID: <Yd+nxAA6KorDpQFv@choryu-tfx5470h>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HM-UT: o17QzsKftw4CKB7VBuWCIgpx9lOC3yzUkBJyQP365Y0=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Hucom Wireless HM-211S/K is an LTE module based on Qualcomm MDM9207.
This module supports LTE Band 1, 3, 5, 7, 8 and WCDMA Band 1.

Manual testing showed that only interface
number two replies to QMI messages.

T:  Bus=01 Lev=02 Prnt=02 Port=01 Cnt=01 Dev#=  3 Spd=480  MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=22de ProdID=9051 Rev= 3.18
S:  Manufacturer=Android
S:  Product=Android
S:  SerialNumber=0123456789ABCDEF
C:* #Ifs= 4 Cfg#= 1 Atr=80 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E:  Ad=83(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
E:  Ad=85(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 3 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=(none)
E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=86(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms

Signed-off-by: Kyoungkyu Park <choryu.park@choryu.space>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index f510e8219470..9f6e996b1c93 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1401,6 +1401,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x413c, 0x81e0, 0)},	/* Dell Wireless 5821e with eSIM support*/
 	{QMI_FIXED_INTF(0x03f0, 0x4e1d, 8)},	/* HP lt4111 LTE/EV-DO/HSPA+ Gobi 4G Module */
 	{QMI_FIXED_INTF(0x03f0, 0x9d1d, 1)},	/* HP lt4120 Snapdragon X5 LTE */
+	{QMI_QUIRK_SET_DTR(0x22de, 0x9051, 2)}, /* Hucom Wireless HM-211S/K */
 	{QMI_FIXED_INTF(0x22de, 0x9061, 3)},	/* WeTelecom WPD-600N */
 	{QMI_QUIRK_SET_DTR(0x1e0e, 0x9001, 5)},	/* SIMCom 7100E, 7230E, 7600E ++ */
 	{QMI_QUIRK_SET_DTR(0x2c7c, 0x0121, 4)},	/* Quectel EC21 Mini PCIe */
-- 
2.34.1

