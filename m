Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD1206C5C96
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 03:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbjCWC22 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 22 Mar 2023 22:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjCWC20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 22:28:26 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A81EA6E90;
        Wed, 22 Mar 2023 19:28:25 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 32N2RriZ6005274, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 32N2RriZ6005274
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Thu, 23 Mar 2023 10:27:53 +0800
Received: from RTEXMBS06.realtek.com.tw (172.21.6.99) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Thu, 23 Mar 2023 10:28:08 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Thu, 23 Mar 2023 10:28:07 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Thu, 23 Mar 2023 10:28:07 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Morgan <macroalpha82@gmail.com>,
        "Nitin Gupta" <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: RE: [PATCH v3 4/9] wifi: rtw88: main: Add the {cpwm,rpwm}_addr for SDIO based chipsets
Thread-Topic: [PATCH v3 4/9] wifi: rtw88: main: Add the {cpwm,rpwm}_addr for
 SDIO based chipsets
Thread-Index: AQHZW3PmFH0pXiFra0+q+akkUuPTRK8Hpy0g
Date:   Thu, 23 Mar 2023 02:28:07 +0000
Message-ID: <e47f71de375b44a9a3ff3a585a3ee628@realtek.com>
References: <20230320213508.2358213-1-martin.blumenstingl@googlemail.com>
 <20230320213508.2358213-5-martin.blumenstingl@googlemail.com>
In-Reply-To: <20230320213508.2358213-5-martin.blumenstingl@googlemail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS06.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2023/3/22_=3F=3F_11:29:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Sent: Tuesday, March 21, 2023 5:35 AM
> To: linux-wireless@vger.kernel.org
> Cc: Yan-Hsuan Chuang <tony0620emma@gmail.com>; Kalle Valo <kvalo@kernel.org>; Ulf Hansson
> <ulf.hansson@linaro.org>; linux-kernel@vger.kernel.org; netdev@vger.kernel.org;
> linux-mmc@vger.kernel.org; Chris Morgan <macroalpha82@gmail.com>; Nitin Gupta <nitin.gupta981@gmail.com>;
> Neo Jou <neojou@gmail.com>; Ping-Ke Shih <pkshih@realtek.com>; Jernej Skrabec <jernej.skrabec@gmail.com>;
> Larry Finger <Larry.Finger@lwfinger.net>; Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Subject: [PATCH v3 4/9] wifi: rtw88: main: Add the {cpwm,rpwm}_addr for SDIO based chipsets
> 
> Initialize the rpwm_addr and cpwm_addr for power-saving support on SDIO
> based chipsets.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>

> ---
> Changes since v2:
> - none
> 
> Changes since v1:
> - none
> 
> 
>  drivers/net/wireless/realtek/rtw88/main.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
> index b2e78737bd5d..cdc4703ead5f 100644
> --- a/drivers/net/wireless/realtek/rtw88/main.c
> +++ b/drivers/net/wireless/realtek/rtw88/main.c
> @@ -18,6 +18,7 @@
>  #include "debug.h"
>  #include "bf.h"
>  #include "sar.h"
> +#include "sdio.h"
> 
>  bool rtw_disable_lps_deep_mode;
>  EXPORT_SYMBOL(rtw_disable_lps_deep_mode);
> @@ -1785,6 +1786,10 @@ static int rtw_chip_parameter_setup(struct rtw_dev *rtwdev)
>                 rtwdev->hci.rpwm_addr = 0x03d9;
>                 rtwdev->hci.cpwm_addr = 0x03da;
>                 break;
> +       case RTW_HCI_TYPE_SDIO:
> +               rtwdev->hci.rpwm_addr = REG_SDIO_HRPWM1;
> +               rtwdev->hci.cpwm_addr = REG_SDIO_HCPWM1_V2;
> +               break;
>         case RTW_HCI_TYPE_USB:
>                 rtwdev->hci.rpwm_addr = 0xfe58;
>                 rtwdev->hci.cpwm_addr = 0xfe57;
> --
> 2.40.0

