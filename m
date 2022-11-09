Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E89FA6220D7
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 01:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiKIAdb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 8 Nov 2022 19:33:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiKIAd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 19:33:29 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E04259596;
        Tue,  8 Nov 2022 16:33:26 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2A90VhDuA005100, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2A90VhDuA005100
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Wed, 9 Nov 2022 08:31:43 +0800
Received: from RTEXMBS03.realtek.com.tw (172.21.6.96) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Wed, 9 Nov 2022 08:32:21 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Wed, 9 Nov 2022 08:32:21 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Wed, 9 Nov 2022 08:32:21 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Wei Li <liwei391@huawei.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "huawei.libin@huawei.com" <huawei.libin@huawei.com>
Subject: RE: [PATCH v1 0/3] rtlwifi: Correct inconsistent header guard
Thread-Topic: [PATCH v1 0/3] rtlwifi: Correct inconsistent header guard
Thread-Index: AQHY81WJj9gzrs6m1EyPW5R5vhZg7641vQ5w
Date:   Wed, 9 Nov 2022 00:32:21 +0000
Message-ID: <cc8f8393ab5e45f895fda98e6b42d1d3@realtek.com>
References: <20221108093447.3588889-1-liwei391@huawei.com>
In-Reply-To: <20221108093447.3588889-1-liwei391@huawei.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS03.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/11/8_=3F=3F_10:28:00?=
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
> From: Wei Li <liwei391@huawei.com>
> Sent: Tuesday, November 8, 2022 5:35 PM
> To: Ping-Ke Shih <pkshih@realtek.com>; Kalle Valo <kvalo@kernel.org>; David S. Miller <davem@davemloft.net>;
> Eric Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>
> Cc: linux-wireless@vger.kernel.org; netdev@vger.kernel.org; huawei.libin@huawei.com
> Subject: [PATCH v1 0/3] rtlwifi: Correct inconsistent header guard

Subject prefix should be "wifi: rtlwifi: ..."

> 
> This patch set fixes some inconsistent header guards in module
> rtl8188ee/rtl8723ae/rtl8192de, that may be copied but missing update.
> 
> Wei Li (3):
>   rtlwifi: rtl8188ee: Correct the header guard of rtl8188ee/*.h
>   rtlwifi: rtl8723ae: Correct the header guard of
>     rtl8723ae/{fw,led,phy}.h
>   rtlwifi: rtl8192de: Correct the header guard of rtl8192de/{dm,led}.h
> 
>  drivers/net/wireless/realtek/rtlwifi/rtl8188ee/def.h    | 4 ++--
>  drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.h     | 4 ++--
>  drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.h     | 4 ++--
>  drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.h     | 4 ++--
>  drivers/net/wireless/realtek/rtlwifi/rtl8188ee/led.h    | 4 ++--
>  drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.h    | 4 ++--
>  drivers/net/wireless/realtek/rtlwifi/rtl8188ee/pwrseq.h | 4 ++--
>  drivers/net/wireless/realtek/rtlwifi/rtl8188ee/reg.h    | 4 ++--
>  drivers/net/wireless/realtek/rtlwifi/rtl8188ee/rf.h     | 4 ++--
>  drivers/net/wireless/realtek/rtlwifi/rtl8188ee/table.h  | 4 ++--
>  drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.h    | 4 ++--
>  drivers/net/wireless/realtek/rtlwifi/rtl8192de/dm.h     | 4 ++--
>  drivers/net/wireless/realtek/rtlwifi/rtl8192de/led.h    | 4 ++--
>  drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.h     | 4 ++--
>  drivers/net/wireless/realtek/rtlwifi/rtl8723ae/led.h    | 4 ++--
>  drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.h    | 4 ++--
>  16 files changed, 32 insertions(+), 32 deletions(-)

The changes aren't too much and commit contents/messages are very similar,
so I would like to squash 3 patches into single one.

Ping-Ke

