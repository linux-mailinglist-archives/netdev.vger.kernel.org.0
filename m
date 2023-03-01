Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 321606A6444
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 01:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbjCAAd3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 28 Feb 2023 19:33:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCAAd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 19:33:28 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DEFF13537;
        Tue, 28 Feb 2023 16:33:25 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 3210WVblC030574, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 3210WVblC030574
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Wed, 1 Mar 2023 08:32:32 +0800
Received: from RTEXMBS05.realtek.com.tw (172.21.6.98) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Wed, 1 Mar 2023 08:32:38 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Wed, 1 Mar 2023 08:32:38 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Wed, 1 Mar 2023 08:32:38 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Simon Horman <simon.horman@corigine.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
CC:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: RE: [PATCH] rtlwifi: rtl8192se: Remove the unused variable bcntime_cfg
Thread-Topic: [PATCH] rtlwifi: rtl8192se: Remove the unused variable
 bcntime_cfg
Thread-Index: AQHZSxoGZWivytKAKkyUIoUlgPpoua7jrTwAgAFmn/A=
Date:   Wed, 1 Mar 2023 00:32:38 +0000
Message-ID: <1d262829764d40a086e93f0c7d0541bc@realtek.com>
References: <20230228021132.88910-1-jiapeng.chong@linux.alibaba.com>
 <Y/3gUquaPNlaLaKt@corigine.com>
In-Reply-To: <Y/3gUquaPNlaLaKt@corigine.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS05.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2023/2/28_=3F=3F_10:36:00?=
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
> From: Simon Horman <simon.horman@corigine.com>
> Sent: Tuesday, February 28, 2023 7:07 PM
> To: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> Cc: Ping-Ke Shih <pkshih@realtek.com>; kvalo@kernel.org; davem@davemloft.net; edumazet@google.com;
> kuba@kernel.org; pabeni@redhat.com; linux-wireless@vger.kernel.org; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org; Abaci Robot <abaci@linux.alibaba.com>
> Subject: Re: [PATCH] rtlwifi: rtl8192se: Remove the unused variable bcntime_cfg
> 
> On Tue, Feb 28, 2023 at 10:11:32AM +0800, Jiapeng Chong wrote:
> > Variable bcntime_cfg is not effectively used, so delete it.
> >
> > drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c:1555:6: warning: variable 'bcntime_cfg' set but not
> used.
> >
> > Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> > Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4240
> > Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> 
> Hi Jiapeng Chong,
> 
> this looks good to me.
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> 
> While reviewing this gcc 12.2.0 told me:
> 
> drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c:1555:25: error: unused variable 'bcn_ifs'
> [-Werror=unused-variable]
>  1555 |         u16 bcn_cw = 6, bcn_ifs = 0xf;
>       |                         ^~~~~~~
> drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c:1555:13: error: unused variable 'bcn_cw'
> [-Werror=unused-variable]
>  1555 |         u16 bcn_cw = 6, bcn_ifs = 0xf;
>       |             ^~~~~~
> 
> So perhaps you could consider sending another patch to remove them too.
> 

These errors are introduced by this patch, so please fix them together by this
patch.

Ping-Ke


