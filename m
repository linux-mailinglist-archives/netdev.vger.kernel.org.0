Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13426510E2C
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 03:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356799AbiD0BlL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 26 Apr 2022 21:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356792AbiD0BlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 21:41:10 -0400
X-Greylist: delayed 482 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 26 Apr 2022 18:37:56 PDT
Received: from rtits2.realtek.com.tw (unknown [122.146.120.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4297BFDD3C;
        Tue, 26 Apr 2022 18:37:55 -0700 (PDT)
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 23R1T7Q80001571, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 23R1T7Q80001571
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 27 Apr 2022 09:29:07 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 27 Apr 2022 09:29:07 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 27 Apr 2022 09:29:06 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6]) by
 RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6%5]) with mapi id
 15.01.2308.021; Wed, 27 Apr 2022 09:29:06 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Yang Li <yang.lee@linux.alibaba.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: RE: [PATCH -next] rtw89: remove unneeded semicolon
Thread-Topic: [PATCH -next] rtw89: remove unneeded semicolon
Thread-Index: AQHYWc42Nr9Q9fn5+kKBPYJ4G5aYIa0C+LAQ
Date:   Wed, 27 Apr 2022 01:29:06 +0000
Message-ID: <ef7a754fa9a04bb09b355d9e063eb950@realtek.com>
References: <20220427003142.107916-1-yang.lee@linux.alibaba.com>
In-Reply-To: <20220427003142.107916-1-yang.lee@linux.alibaba.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS04.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/4/26_=3F=3F_11:20:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,MAY_BE_FORGED,
        SPF_FAIL,SPF_HELO_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Yang Li <yang.lee@linux.alibaba.com>
> Sent: Wednesday, April 27, 2022 8:32 AM
> To: davem@davemloft.net
> Cc: kuba@kernel.org; pabeni@redhat.com; kvalo@kernel.org; Pkshih <pkshih@realtek.com>;
> linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Yang Li
> <yang.lee@linux.alibaba.com>; Abaci Robot <abaci@linux.alibaba.com>
> Subject: [PATCH -next] rtw89: remove unneeded semicolon
> 
> Eliminate the following coccicheck warning:
> ./drivers/net/wireless/realtek/rtw89/rtw8852c.c:2556:2-3: Unneeded
> semicolon
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>

> ---
>  drivers/net/wireless/realtek/rtw89/rtw8852c.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852c.c
> b/drivers/net/wireless/realtek/rtw89/rtw8852c.c
> index 858611c64e6b..275568468212 100644
> --- a/drivers/net/wireless/realtek/rtw89/rtw8852c.c
> +++ b/drivers/net/wireless/realtek/rtw89/rtw8852c.c
> @@ -2553,7 +2553,7 @@ do {								\
>  	default:
>  		val = arg.gnt_bt.data;
>  		break;
> -	};
> +	}
> 
>  	__write_ctrl(R_AX_PWR_COEXT_CTRL, B_AX_TXAGC_BT_MASK, val,
>  		     B_AX_TXAGC_BT_EN, arg.ctrl_gnt_bt != 0xffff);
> --
> 2.20.1.7.g153144c

