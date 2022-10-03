Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6A565F3046
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 14:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiJCM3S convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 3 Oct 2022 08:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiJCM3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 08:29:16 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2955632D87
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 05:29:11 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 293CSPLB0002290, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 293CSPLB0002290
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Mon, 3 Oct 2022 20:28:25 +0800
Received: from RTEXMBS06.realtek.com.tw (172.21.6.99) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Mon, 3 Oct 2022 20:28:51 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 3 Oct 2022 20:28:50 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::402d:f52e:eaf0:28a2]) by
 RTEXMBS04.realtek.com.tw ([fe80::402d:f52e:eaf0:28a2%5]) with mapi id
 15.01.2375.007; Mon, 3 Oct 2022 20:28:50 +0800
From:   Hau <hau@realtek.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
Subject: RE: [PATCH net-next v4] r8169: add support for rtl8168h(revid 0x2a) + rtl8211fs fiber application
Thread-Topic: [PATCH net-next v4] r8169: add support for rtl8168h(revid 0x2a)
 + rtl8211fs fiber application
Thread-Index: AQHYyRIu3kgXJ+ZikEudB0+XInLdc63oYFQAgAG7goCAEphMMA==
Date:   Mon, 3 Oct 2022 12:28:50 +0000
Message-ID: <36b777afdb2a40fbb56ce6694e01e48b@realtek.com>
References: <20220915144807.3602-1-hau@realtek.com>
        <20220920145944.302f2b24@kernel.org> <20220921172707.2b1399cb@kernel.org>
In-Reply-To: <20220921172707.2b1399cb@kernel.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.129]
x-kse-serverinfo: RTEXMBS06.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/10/3_=3F=3F_09:07:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_PASS,
        T_SPF_HELO_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jakub Kicinski [mailto:kuba@kernel.org]
> Sent: Thursday, September 22, 2022 8:27 AM
> To: hkallweit1@gmail.com; Andrew Lunn <andrew@lunn.ch>
> Cc: Hau <hau@realtek.com>; netdev@vger.kernel.org; nic_swsd
> <nic_swsd@realtek.com>
> Subject: Re: [PATCH net-next v4] r8169: add support for rtl8168h(revid 0x2a)
> + rtl8211fs fiber application
> 
> On Tue, 20 Sep 2022 14:59:44 -0700 Jakub Kicinski wrote:
> > On Thu, 15 Sep 2022 22:48:07 +0800 Chunhao Lin wrote:
> > > rtl8168h(revid 0x2a) + rtl8211fs is for fiber related application.
> > > rtl8168h is connected to rtl8211fs mdio bus via its eeprom or gpio pins.
> > >
> > > In this patch, use bitbanged MDIO framework to access rtl8211fs via
> > > rtl8168h's eeprom or gpio pins.
> > >
> > > And set mdiobb_ops owner to NULL to avoid increase module's refcount
> > > to prevent rmmod cannot be done.
> > > https://patchwork.kernel.org/project/linux-renesas-soc/patch/2020073
> > > 0100151.7490-1-ashiduka@fujitsu.com/
> >
> > Heiner, Andrew, good?
> 
> Well, we need Hainer or Andrew to ack, I'm marking this patch as Deferred
> until such endorsement is obtained.
> 
Hi Heiner, could you help to check this patch? 

Thanks.

 ------Please consider the environment before printing this e-mail.
