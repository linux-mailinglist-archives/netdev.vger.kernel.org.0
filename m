Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFDCD66D51A
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 04:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232920AbjAQDk5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 16 Jan 2023 22:40:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235198AbjAQDky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 22:40:54 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6F23223673;
        Mon, 16 Jan 2023 19:40:53 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 30H3diFD3008527, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 30H3diFD3008527
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Tue, 17 Jan 2023 11:39:44 +0800
Received: from RTEXDAG01.realtek.com.tw (172.21.6.100) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Tue, 17 Jan 2023 11:39:45 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG01.realtek.com.tw (172.21.6.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Tue, 17 Jan 2023 11:39:44 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Tue, 17 Jan 2023 11:39:44 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Doug Brown <doug@schmorgal.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC:     Dan Williams <dcbw@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        "libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v3 1/4] wifi: libertas: fix capitalization in mrvl_ie_data struct
Thread-Topic: [PATCH v3 1/4] wifi: libertas: fix capitalization in
 mrvl_ie_data struct
Thread-Index: AQHZKeiY0WpPdGjdOESWllQNyCtwnq6h9mnw
Date:   Tue, 17 Jan 2023 03:39:44 +0000
Message-ID: <651627a8399f4cb49feb336e6f5bd9dc@realtek.com>
References: <20230116202126.50400-1-doug@schmorgal.com>
 <20230116202126.50400-2-doug@schmorgal.com>
In-Reply-To: <20230116202126.50400-2-doug@schmorgal.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXDAG01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2023/1/16_=3F=3F_11:39:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Doug Brown <doug@schmorgal.com>
> Sent: Tuesday, January 17, 2023 4:21 AM
> To: Kalle Valo <kvalo@kernel.org>; David S. Miller <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>
> Cc: Dan Williams <dcbw@redhat.com>; Simon Horman <simon.horman@corigine.com>;
> libertas-dev@lists.infradead.org; linux-wireless@vger.kernel.org; netdev@vger.kernel.org; Doug Brown
> <doug@schmorgal.com>
> Subject: [PATCH v3 1/4] wifi: libertas: fix capitalization in mrvl_ie_data struct
> 
> This struct is currently unused, but it will be used in future patches.
> Fix the code style to not use camel case.
> 
> Signed-off-by: Doug Brown <doug@schmorgal.com>
> ---
>  drivers/net/wireless/marvell/libertas/types.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/marvell/libertas/types.h
> b/drivers/net/wireless/marvell/libertas/types.h
> index cd4ceb6f885d..398e3272e85f 100644
> --- a/drivers/net/wireless/marvell/libertas/types.h
> +++ b/drivers/net/wireless/marvell/libertas/types.h
> @@ -105,7 +105,7 @@ struct mrvl_ie_header {
> 
>  struct mrvl_ie_data {
>  	struct mrvl_ie_header header;
> -	u8 Data[1];
> +	u8 data[1];

data[]. see [1]

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays

>  } __packed;
> 
>  struct mrvl_ie_rates_param_set {
> --
> 2.34.1

