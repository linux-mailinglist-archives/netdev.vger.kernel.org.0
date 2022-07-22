Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F2057E3AC
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 17:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235751AbiGVPXX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 22 Jul 2022 11:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235750AbiGVPXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 11:23:07 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 07DED9D513;
        Fri, 22 Jul 2022 08:23:05 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 26MFMjz36013603, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 26MFMjz36013603
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Fri, 22 Jul 2022 23:22:45 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Fri, 22 Jul 2022 23:22:50 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Fri, 22 Jul 2022 23:22:49 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::415c:a915:a507:e600]) by
 RTEXMBS04.realtek.com.tw ([fe80::415c:a915:a507:e600%5]) with mapi id
 15.01.2308.027; Fri, 22 Jul 2022 23:22:49 +0800
From:   Hau <hau@realtek.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] r8169: add support for rtl8168h(revid 0x2a) + rtl8211fs fiber application
Thread-Topic: [PATCH net-next] r8169: add support for rtl8168h(revid 0x2a) +
 rtl8211fs fiber application
Thread-Index: AQHYnRCVRrASn8LKuEagRDBDIpqm962JGHOAgAFq8GA=
Date:   Fri, 22 Jul 2022 15:22:49 +0000
Message-ID: <e7f31872f7e54970b99b5a3df94cb1f1@realtek.com>
References: <20220721144550.4405-1-hau@realtek.com>
 <20220721184243.31ace75f@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20220721184243.31ace75f@kicinski-fedora-PC1C0HJN>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.129]
x-kse-serverinfo: RTEXDAG02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/7/22_=3F=3F_12:44:00?=
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

> On Thu, 21 Jul 2022 22:45:50 +0800 Chunhao Lin wrote:
> > rtl8168h(revid 0x2a) + rtl8211fs is for fiber related application.
> > rtl8168h will control rtl8211fs via its eeprom or gpo pins.
> > Fiber module will be connected to rtl8211fs. The link speed between
> > rtl8168h and rtl8211fs is decied by fiber module.
> 
> Compiler says:
> 
> drivers/net/ethernet/realtek/r8169_main.c:614:24: warning: symbol
> 'rtl_sfp_if_eeprom_mask' was not declared. Should it be static?
> drivers/net/ethernet/realtek/r8169_main.c:617:24: warning: symbol
> 'rtl_sfp_if_gpo_mask' was not declared. Should it be static?
> 

I will change code to use static my next patch.

 ------Please consider the environment before printing this e-mail.
