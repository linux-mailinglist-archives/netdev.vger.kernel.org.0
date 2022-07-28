Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9266B583A7A
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 10:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235211AbiG1Ik2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 28 Jul 2022 04:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235153AbiG1Ik1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 04:40:27 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4F88646DB4;
        Thu, 28 Jul 2022 01:40:25 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 26S8eAIR1020624, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 26S8eAIR1020624
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Thu, 28 Jul 2022 16:40:10 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 28 Jul 2022 16:40:17 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 28 Jul 2022 16:40:16 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::415c:a915:a507:e600]) by
 RTEXMBS04.realtek.com.tw ([fe80::415c:a915:a507:e600%5]) with mapi id
 15.01.2308.027; Thu, 28 Jul 2022 16:40:16 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Oliver Neukum <oneukum@suse.com>
CC:     USB list <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: handling MAC set by user space in reset_resume() of r8152
Thread-Topic: handling MAC set by user space in reset_resume() of r8152
Thread-Index: AQHYoa2Y9Pz4/O8XDEKFeUHGHHdeq62SBZCAgAFrpBA=
Date:   Thu, 28 Jul 2022 08:40:16 +0000
Message-ID: <353a10d11f2345c8acff717be4ade74a@realtek.com>
References: <2397d98d-e373-1740-eb5f-8fe795a0352a@suse.com>
 <YuGFOU7oKlAGZjTa@lunn.ch>
In-Reply-To: <YuGFOU7oKlAGZjTa@lunn.ch>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.203]
x-kse-serverinfo: RTEXMBS04.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/7/28_=3F=3F_06:00:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Oliver Neukum <oneukum@suse.com>
> > Date: Wed, 27 Jul 2022 13:29:42 +0200
> > Subject: [PATCH] r8152: restore external MAC in reset_resume
> >
> > If user space has set the MAC of the interface,
> > reset_resume() must restore that setting rather
> > than redetermine the MAC like if te interface
> > is probed regularly.

I think this patch conflicts with commit 25766271e42f ("r8152: Refresh
MAC address during USBDEVFS_RESET"). The results would be changed.

Besides, I don't understand why you set tp->external_mac = false
in rtl8152_down().

Best Regards,
Hayes


