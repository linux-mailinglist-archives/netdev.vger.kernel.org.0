Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 689696A6502
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 02:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjCABwV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 28 Feb 2023 20:52:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbjCABwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 20:52:18 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1403B2A98C;
        Tue, 28 Feb 2023 17:52:04 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 3211plCI3014228, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 3211plCI3014228
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Wed, 1 Mar 2023 09:51:47 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Wed, 1 Mar 2023 09:51:53 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Wed, 1 Mar 2023 09:51:53 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Wed, 1 Mar 2023 09:51:53 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        Neo Jou <neojou@gmail.com>
Subject: RE: [PATCH v1 wireless-next 1/2] wifi: rtw88: mac: Return the original error from rtw_pwr_seq_parser()
Thread-Topic: [PATCH v1 wireless-next 1/2] wifi: rtw88: mac: Return the
 original error from rtw_pwr_seq_parser()
Thread-Index: AQHZSi85JwqjhjhK7EK65NOfrSrDW67lLFnQ
Date:   Wed, 1 Mar 2023 01:51:53 +0000
Message-ID: <271b67a3134a4ba0847b4be74305022f@realtek.com>
References: <20230226221004.138331-1-martin.blumenstingl@googlemail.com>
 <20230226221004.138331-2-martin.blumenstingl@googlemail.com>
In-Reply-To: <20230226221004.138331-2-martin.blumenstingl@googlemail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXDAG02.realtek.com.tw, 9
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
> Subject: [PATCH v1 wireless-next 1/2] wifi: rtw88: mac: Return the original error from rtw_pwr_seq_parser()
> 
> rtw_pwr_seq_parser() calls rtw_sub_pwr_seq_parser() which can either
> return -EBUSY, -EINVAL or 0. Propagate the original error code instead
> of unconditionally returning -EBUSY in case of an error.
> 
> Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>

> ---
>  drivers/net/wireless/realtek/rtw88/mac.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/mac.c b/drivers/net/wireless/realtek/rtw88/mac.c
> index 1c9530a0eb69..4749d75fefee 100644
> --- a/drivers/net/wireless/realtek/rtw88/mac.c
> +++ b/drivers/net/wireless/realtek/rtw88/mac.c
> @@ -236,7 +236,7 @@ static int rtw_pwr_seq_parser(struct rtw_dev *rtwdev,
> 
>                 ret = rtw_sub_pwr_seq_parser(rtwdev, intf_mask, cut_mask, cmd);
>                 if (ret)
> -                       return -EBUSY;
> +                       return ret;
> 
>                 idx++;
>         } while (1);
> --
> 2.39.2

