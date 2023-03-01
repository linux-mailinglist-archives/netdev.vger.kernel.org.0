Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 538446A64FC
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 02:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjCABvt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 28 Feb 2023 20:51:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjCABvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 20:51:48 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F062914F;
        Tue, 28 Feb 2023 17:51:45 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 3211pPTJ1012296, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 3211pPTJ1012296
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Wed, 1 Mar 2023 09:51:25 +0800
Received: from RTEXMBS01.realtek.com.tw (172.21.6.94) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Wed, 1 Mar 2023 09:51:31 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Wed, 1 Mar 2023 09:51:31 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Wed, 1 Mar 2023 09:51:31 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        Neo Jou <neojou@gmail.com>
Subject: RE: [PATCH v1 wireless-next 2/2] wifi: rtw88: mac: Return the original error from rtw_mac_power_switch()
Thread-Topic: [PATCH v1 wireless-next 2/2] wifi: rtw88: mac: Return the
 original error from rtw_mac_power_switch()
Thread-Index: AQHZSi85yR313XHw3kWdywFCHY8SEq7lKekg
Date:   Wed, 1 Mar 2023 01:51:31 +0000
Message-ID: <79fd583078414f2f8c137c85bcdebef7@realtek.com>
References: <20230226221004.138331-1-martin.blumenstingl@googlemail.com>
 <20230226221004.138331-3-martin.blumenstingl@googlemail.com>
In-Reply-To: <20230226221004.138331-3-martin.blumenstingl@googlemail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS01.realtek.com.tw, 9
x-kse-antispam-interceptor-info: fallback
x-kse-antivirus-interceptor-info: fallback
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-AntiSpam-Interceptor-Info: fallback
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
> From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Sent: Monday, February 27, 2023 6:10 AM
> To: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; kvalo@kernel.org; tony0620emma@gmail.com;
> Ping-Ke Shih <pkshih@realtek.com>; Neo Jou <neojou@gmail.com>; Martin Blumenstingl
> <martin.blumenstingl@googlemail.com>
> Subject: [PATCH v1 wireless-next 2/2] wifi: rtw88: mac: Return the original error from
> rtw_mac_power_switch()
> 
> rtw_mac_power_switch() calls rtw_pwr_seq_parser() which can return
> -EINVAL, -EBUSY or 0. Propagate the original error code instead of
> unconditionally returning -EINVAL in case of an error.
> 
> Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>

> ---
>  drivers/net/wireless/realtek/rtw88/mac.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/mac.c b/drivers/net/wireless/realtek/rtw88/mac.c
> index 4749d75fefee..f3a566cf979b 100644
> --- a/drivers/net/wireless/realtek/rtw88/mac.c
> +++ b/drivers/net/wireless/realtek/rtw88/mac.c
> @@ -250,6 +250,7 @@ static int rtw_mac_power_switch(struct rtw_dev *rtwdev, bool pwr_on)
>         const struct rtw_pwr_seq_cmd **pwr_seq;
>         u8 rpwm;
>         bool cur_pwr;
> +       int ret;
> 
>         if (rtw_chip_wcpu_11ac(rtwdev)) {
>                 rpwm = rtw_read8(rtwdev, rtwdev->hci.rpwm_addr);
> @@ -273,8 +274,9 @@ static int rtw_mac_power_switch(struct rtw_dev *rtwdev, bool pwr_on)
>                 return -EALREADY;

I think a reason why we don't propagate return value is special deal of EALREADY
by caller. Since this driver becomes stable and no others use EALREADY as error code,
this patchset will be okay.

> 
>         pwr_seq = pwr_on ? chip->pwr_on_seq : chip->pwr_off_seq;
> -       if (rtw_pwr_seq_parser(rtwdev, pwr_seq))
> -               return -EINVAL;
> +       ret = rtw_pwr_seq_parser(rtwdev, pwr_seq);
> +       if (ret)
> +               return ret;
> 
>         if (pwr_on)
>                 set_bit(RTW_FLAG_POWERON, rtwdev->flags);
> --
> 2.39.2

