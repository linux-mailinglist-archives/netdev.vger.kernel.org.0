Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBF56AFED6
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 07:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjCHGV4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 8 Mar 2023 01:21:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjCHGVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 01:21:54 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9937A6144;
        Tue,  7 Mar 2023 22:21:52 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 3286LBG40015930, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 3286LBG40015930
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Wed, 8 Mar 2023 14:21:11 +0800
Received: from RTEXMBS06.realtek.com.tw (172.21.6.99) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Wed, 8 Mar 2023 14:21:21 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Wed, 8 Mar 2023 14:21:20 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Wed, 8 Mar 2023 14:21:20 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Martin Kaiser <martin@kaiser.cx>,
        Jes Sorensen <Jes.Sorensen@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] wifi: rtl8xxxu: use module_usb_driver
Thread-Topic: [PATCH] wifi: rtl8xxxu: use module_usb_driver
Thread-Index: AQHZUS+P3Ysqvr7iGU21QASDQjl8qq7wafOA
Date:   Wed, 8 Mar 2023 06:21:20 +0000
Message-ID: <2126bfe772234696956fe6a94c43eebb@realtek.com>
References: <20230307195718.168021-1-martin@kaiser.cx>
In-Reply-To: <20230307195718.168021-1-martin@kaiser.cx>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS06.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2023/3/8_=3F=3F_02:31:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Martin Kaiser <martin@kaiser.cx>
> Sent: Wednesday, March 8, 2023 3:57 AM
> To: Jes Sorensen <Jes.Sorensen@gmail.com>; Kalle Valo <kvalo@kernel.org>; David S. Miller
> <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>
> Cc: Martin Kaiser <martin@kaiser.cx>; linux-wireless@vger.kernel.org; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: [PATCH] wifi: rtl8xxxu: use module_usb_driver
> 
> We can use the module_usb_driver macro instead of open-coding the driver's
> init and exit functions. This is simpler and saves some lines of code.
> Other realtek wireless drivers use module_usb_driver as well.
> 
> Signed-off-by: Martin Kaiser <martin@kaiser.cx>

Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>


> ---
>  .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 20 +------------------
>  1 file changed, 1 insertion(+), 19 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> index e619ed21fbfe..58dbad9a14c2 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> @@ -7455,24 +7455,6 @@ static struct usb_driver rtl8xxxu_driver = {
>         .disable_hub_initiated_lpm = 1,
>  };
> 
> -static int __init rtl8xxxu_module_init(void)
> -{
> -       int res;
> -
> -       res = usb_register(&rtl8xxxu_driver);
> -       if (res < 0)
> -               pr_err(DRIVER_NAME ": usb_register() failed (%i)\n", res);
> -
> -       return res;
> -}
> -
> -static void __exit rtl8xxxu_module_exit(void)
> -{
> -       usb_deregister(&rtl8xxxu_driver);
> -}
> -
> -
>  MODULE_DEVICE_TABLE(usb, dev_table);
> 
> -module_init(rtl8xxxu_module_init);
> -module_exit(rtl8xxxu_module_exit);
> +module_usb_driver(rtl8xxxu_driver);
> --
> 2.30.2

