Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D34C5AC882
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 03:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235124AbiIEB0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Sep 2022 21:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiIEB0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 21:26:42 -0400
Received: from out162-62-57-137.mail.qq.com (out162-62-57-137.mail.qq.com [162.62.57.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63DB82BB0D
        for <netdev@vger.kernel.org>; Sun,  4 Sep 2022 18:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1662341197;
        bh=YIE8sJ2GxvwPy8tD7EYzlAYfVnYvTWwBsPmlX9YPYv0=;
        h=From:To:Cc:Subject:Date;
        b=EQK6EeCfz1V063X5OSzU4zO/IkhR7hPkyYrzgITk5QtFmNySMU3iVXcgJ8YnNK+G9
         +0DjK6LUQREKbMCrKgUXAqong7Ad0tpN6UYAPo4gACooTS6IoKNUyv/jVTRsWJfdBj
         pZNaPSQ1k/YSNc+fJ/+InJ3BZZRjLoHEJaL5otF8=
Received: from localhost.localdomain ([220.180.239.55])
        by newxmesmtplogicsvrsza30.qq.com (NewEsmtp) with SMTP
        id 64A95C5E; Mon, 05 Sep 2022 09:25:10 +0800
X-QQ-mid: xmsmtpt1662341110tndn78uzk
Message-ID: <tencent_E50CA8A206904897C2D20DDAE90731183C05@qq.com>
X-QQ-XMAILINFO: NQR8mRxMnur9ZWgqfJXkZM4H4vOysS4TklrQQhM+P+Ej9Syk9Sq/AudcFZzF2R
         fugW62F6ffsfWk9IKEDRHBG+02SAx4sD/Hw/TckfMiP1mrZdLBiS+sd/1B7k3DL3yS/w8BExiu+H
         gAgPy+NIfO/EvODK5QcUsXa4uudd3Ql236ddTYts2ihWr6Z9Kqg0ab6BsGKtolH1hOZxh29ALy5T
         RjOU2INrZqPWUjwCdaHr/quI395Ndm7Pk26oVqL4OY0Xn9dQA42xjKXiULh6+8ekaPamBqg0SyvO
         Rongy1d4mnC3LBT0pBMY2dbPDmo5pBzjwj8McgMWl6UNNPK3MDM+/DWalFBZVv9sKhEUI2+sg8AU
         G7ypTnLCgJSOG8LfZWGli+dl9jhwfEdyMXN9db8vBY1U26D7LVK3bxIQBc9tv7kXl+dS8fXysGSQ
         gTED/w9siCb0ibE/M3YOaQLn+5tZ9VmmDsCCEfSZ4BNgk5lNgCBouEOTKZ65K7Y4hsO7Ppax/jFB
         7ZsfGCoJh6/dcFZU4tzM8GrwaYtdUwPGwVKfuG6jpAHbPMGBZyiFgGO0LA8hdTlskh0dME/YxMiL
         e540ryjDXntcJ43S8gvuRAVIFShaoi11O5i1iHqIPAx7rP9x0bjAnnjcuuXIVwG7RtckadLSiWKv
         iBe0JjE/YOErLJ57dY00K+wL72H3MPjqNtzogcTZDdsOnW7jP3T8vm6FlPJoaxX0J83v/i2PkoJ3
         nsrykLUE1Ba/zrXGVTkLDJ4HvHYi2T9foRgNBoc77nsyNuXlIISv0475qlo6rGnNo7odu1ZqzTLV
         3bKXaH8p/AQUjCXqby+O350k+BxhoOt49EsBmetdsraLZXAPEUPAjyJwn/hQlk5EvgpqAekyIxtY
         +ZCsgEhXSPucF+KUuoGjGVIrVi87VcTTs8GC9wrrpoNEkTp9UBZykPMy6GG6cSLXAU2dwq1PUJLF
         IfwgnjwDLFttfq1l/R+9y6q0zWZIhP1btwYjQbuQS7aN+cBowC2KqUS+LeL5SVxaiM6TT2Ngo=
From:   "jerry.meng" <jerry-meng@foxmail.com>
To:     bjorn@mork.no, davem@davemloft.net
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "jerry.meng" <jerry-meng@foxmail.com>
Subject: [PATCH] net: usb: qmi_wwan: add Quectel RM520N
Date:   Mon,  5 Sep 2022 09:24:52 +0800
X-OQ-MSGID: <20220905012452.36343-1-jerry-meng@foxmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HELO_DYNAMIC_IPADDR,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,RDNS_DYNAMIC,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add support for Quectel RM520N which is based on Qualcomm SDX62 chip.

0x0801: DIAG + NMEA + AT + MODEM + RMNET

T:  Bus=03 Lev=01 Prnt=01 Port=01 Cnt=02 Dev#= 10 Spd=480  MxCh= 0
D:  Ver= 2.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=2c7c ProdID=0801 Rev= 5.04
S:  Manufacturer=Quectel
S:  Product=RM520N-GL
S:  SerialNumber=384af524
C:* #Ifs= 5 Cfg#= 1 Atr=a0 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=40 Driver=option
E:  Ad=83(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=85(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=87(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=86(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
E:  Ad=88(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
E:  Ad=8e(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=0f(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms

Signed-off-by: jerry.meng <jerry-meng@foxmail.com>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 709e3c59e340..0cb187def5bc 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1087,6 +1087,7 @@ static const struct usb_device_id products[] = {
 	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0512)},	/* Quectel EG12/EM12 */
 	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0620)},	/* Quectel EM160R-GL */
 	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0800)},	/* Quectel RM500Q-GL */
+	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0801)},	/* Quectel RM520N */
 
 	/* 3. Combined interface devices matching on interface number */
 	{QMI_FIXED_INTF(0x0408, 0xea42, 4)},	/* Yota / Megafon M100-1 */
-- 
2.25.1


