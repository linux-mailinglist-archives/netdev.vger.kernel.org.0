Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C11BA6EFEA2
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 02:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242803AbjD0Arb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 26 Apr 2023 20:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241692AbjD0Ara (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 20:47:30 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7C4359E;
        Wed, 26 Apr 2023 17:47:29 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 33R0l5h05000574, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 33R0l5h05000574
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Thu, 27 Apr 2023 08:47:06 +0800
Received: from RTEXMBS06.realtek.com.tw (172.21.6.99) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Thu, 27 Apr 2023 08:47:08 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Thu, 27 Apr 2023 08:47:07 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::e138:e7f1:4709:ff4d]) by
 RTEXMBS04.realtek.com.tw ([fe80::e138:e7f1:4709:ff4d%5]) with mapi id
 15.01.2375.007; Thu, 27 Apr 2023 08:47:07 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Zhang Shurong <zhang_shurong@foxmail.com>
CC:     "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 0/2] wifi: rtw88: error codes fix patches
Thread-Topic: [PATCH v3 0/2] wifi: rtw88: error codes fix patches
Thread-Index: AQHZeGJ27jYL+1Dzf0WhQst+fewc+a8+UeVA
Date:   Thu, 27 Apr 2023 00:47:07 +0000
Message-ID: <5629deb196114fefb12f5f2273b4786d@realtek.com>
References: <tencent_1BB7243C6EDA6B2BB6E2C1563C1614D45009@qq.com>
In-Reply-To: <tencent_1BB7243C6EDA6B2BB6E2C1563C1614D45009@qq.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS06.realtek.com.tw, 9
x-kse-antispam-interceptor-info: fallback
x-kse-antivirus-interceptor-info: fallback
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Zhang Shurong <zhang_shurong@foxmail.com>
> Sent: Thursday, April 27, 2023 1:02 AM
> To: Ping-Ke Shih <pkshih@realtek.com>
> Cc: tony0620emma@gmail.com; kvalo@kernel.org; davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> Zhang Shurong <zhang_shurong@foxmail.com>
> Subject: [PATCH v3 0/2] wifi: rtw88: error codes fix patches
> 
> rtw88 does not handle the failure during copy_from_user or invalid
> user-provided data. We fix such problems by first modifying the return
> value of customized function rtw_debugfs_copy_from_user. Then for all
> the callers rtw_debugfs_set_*, we receive the returned error code.
> Moreover, negative code is returned if the user-provided data is invalid
> instead of a positive value count.
> 
> The changes in this version:
> - check by if (ret) instead of check by if (ret < 0)

It would be better if you preserve the change of v2 as changelog.
v3 is okay to me, so don't need v4 if no other reviewer has comment
for this patchset.

> 
> Zhang Shurong (2):
>   wifi: rtw88: fix incorrect error codes in rtw_debugfs_copy_from_user
>   wifi: rtw88: fix incorrect error codes in rtw_debugfs_set_*
> 
>  drivers/net/wireless/realtek/rtw88/debug.c | 59 ++++++++++++++++------
>  1 file changed, 43 insertions(+), 16 deletions(-)
> 
> --
> 2.40.0
> 

