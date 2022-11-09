Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A768B62297A
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 12:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiKILDZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 9 Nov 2022 06:03:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiKILDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 06:03:24 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 48CB713D23;
        Wed,  9 Nov 2022 03:03:19 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2A9B2FAz8022767, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2A9B2FAz8022767
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Wed, 9 Nov 2022 19:02:15 +0800
Received: from RTEXMBS05.realtek.com.tw (172.21.6.98) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Wed, 9 Nov 2022 19:02:53 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Wed, 9 Nov 2022 19:02:53 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Wed, 9 Nov 2022 19:02:53 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Albert Zhou <albert.zhou.50@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next RFC 0/5] Update r8152 to version two
Thread-Topic: [PATCH net-next RFC 0/5] Update r8152 to version two
Thread-Index: AQHY84eCZedYEX+95EOjyKXiF2YVV642Rxog
Date:   Wed, 9 Nov 2022 11:02:52 +0000
Message-ID: <77e816857bbd46ec8357134f767be785@realtek.com>
References: <20221108153342.18979-1-albert.zhou.50@gmail.com>
In-Reply-To: <20221108153342.18979-1-albert.zhou.50@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.203]
x-kse-serverinfo: RTEXMBS05.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/11/9_=3F=3F_09:47:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_PASS,
        T_SPF_HELO_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Albert Zhou <albert.zhou.50@gmail.com>
> Sent: Tuesday, November 8, 2022 11:34 PM
> Subject: [PATCH net-next RFC 0/5] Update r8152 to version two
> 
> This patch integrates the version-two r8152 drivers from Realtek into
> the kernel. I am new to kernel development, so apologies if I make
> newbie mistakes.

The Realtek's in-house driver doesn't satisfy the rules or requests of
Linux kernel, so I don't think you could use it to replace the Linux
kernel r8152 driver.

The version is used to distinguish between the Realtek's in-house driver
and Linux kernel r8152 driver. It doesn't mean you have to use version 2,
even the version 2 may contain more experiment features.

Best Regards,
Hayes

> I have tested the updated module in v6.1 on my machine, without any
> issues.
> 
> A final note, when I removed all the code for earlier kernel versions,
> the header r8152_compatibility.h reduced dramatically in size. This
> leads me to suspect that some of the headers like <linux/init.h> are no
> longer  needed. However, I left them in there just in case.

