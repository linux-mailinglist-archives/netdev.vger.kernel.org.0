Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31CE65EDC78
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 14:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233335AbiI1MXa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 28 Sep 2022 08:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiI1MX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 08:23:28 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C06D6868BE
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 05:23:26 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 28SCMqRkA029858, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 28SCMqRkA029858
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Wed, 28 Sep 2022 20:22:52 +0800
Received: from RTEXMBS05.realtek.com.tw (172.21.6.98) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Wed, 28 Sep 2022 20:23:17 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 28 Sep 2022 20:23:16 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::402d:f52e:eaf0:28a2]) by
 RTEXMBS04.realtek.com.tw ([fe80::402d:f52e:eaf0:28a2%5]) with mapi id
 15.01.2375.007; Wed, 28 Sep 2022 20:23:16 +0800
From:   Hau <hau@realtek.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
Subject: RE: [PATCH net-next] r8169: add rtl_disable_rxdvgate()
Thread-Topic: [PATCH net-next] r8169: add rtl_disable_rxdvgate()
Thread-Index: AQHY0XxXdq+4NufuW0SXKPsMbVmGvK3zfBUAgAFK1nA=
Date:   Wed, 28 Sep 2022 12:23:16 +0000
Message-ID: <500db480aa314e4d96c0a7f6a9da1260@realtek.com>
References: <20220926074813.3619-1-hau@realtek.com>
 <20220927173810.6caad4f3@kernel.org>
In-Reply-To: <20220927173810.6caad4f3@kernel.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.129]
x-kse-serverinfo: RTEXMBS05.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/9/28_=3F=3F_09:39:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
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

> 
> On Mon, 26 Sep 2022 15:48:13 +0800 Chunhao Lin wrote:
> > rtl_disable_rxdvgate() is used for disable RXDV_GATE.
> > It is opposite function of rtl_enable_rxdvgate().
> 
> You should mention that you're dropping the udelay() and if you know why it
> was there in the first place - why it's no longer needed.
> 
I will update the commit message and resubmit the patch.

Thanks.

------Please consider the environment before printing this e-mail.
