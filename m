Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1E94382270
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 03:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbhEQBDI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 16 May 2021 21:03:08 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:57664 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbhEQBDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 May 2021 21:03:06 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 14H11UQr8024911, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36502.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 14H11UQr8024911
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 17 May 2021 09:01:30 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXH36502.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 17 May 2021 09:01:29 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 17 May 2021 09:01:28 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::1d8:ba7d:61ca:bd74]) by
 RTEXMBS04.realtek.com.tw ([fe80::1d8:ba7d:61ca:bd74%5]) with mapi id
 15.01.2106.013; Mon, 17 May 2021 09:01:28 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Alan Stern <stern@rowland.harvard.edu>
CC:     syzbot <syzbot+95afd23673f5dd295c57@syzkaller.appspotmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        nic_swsd <nic_swsd@realtek.com>
Subject: RE: [syzbot] WARNING in rtl8152_probe
Thread-Topic: [syzbot] WARNING in rtl8152_probe
Thread-Index: AQHXRxMNo04dZcfiN0eNJrSRsQsh6qrguwNggAA4ewCAAVQHMP//vp6AgACQRgCAAAIjgIAESHmw
Date:   Mon, 17 May 2021 01:01:28 +0000
Message-ID: <547984d34f58406aa2e37861d7e8a44d@realtek.com>
References: <0000000000009df1b605c21ecca8@google.com>
 <7de0296584334229917504da50a0ac38@realtek.com>
 <20210513142552.GA967812@rowland.harvard.edu>
 <bde8fc1229ec41e99ec77f112cc5ee01@realtek.com> <YJ4dU3yCwd2wMq5f@kroah.com>
 <bddf302301f5420db0fa049c895c9b14@realtek.com>
 <20210514153253.GA1007561@rowland.harvard.edu>
In-Reply-To: <20210514153253.GA1007561@rowland.harvard.edu>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.203]
x-kse-serverinfo: RTEXDAG02.realtek.com.tw, 9
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2021/5/16_=3F=3F_11:41:00?=
x-kse-attachment-filter-triggered-rules: Clean
x-kse-attachment-filter-triggered-filters: Clean
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36502.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 05/17/2021 00:47:47
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 163679 [May 17 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: hayeswang@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 445 445 d5f7ae5578b0f01c45f955a2a751ac25953290c9
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: realtek.com:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 05/17/2021 00:49:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu>
> Sent: Friday, May 14, 2021 11:33 PM
[...]
> The real motivation here, which nobody has mentioned explicitly yet, is
> that the driver needs to be careful enough that it won't crash no matter
> what bizarre, malfunctioning, or malicious device is attached.
> 
> Even if a device isn't malicious, if it is buggy, broken, or
> malfunctioning in some way then it can present input that a normal
> device would never generate.  If the driver isn't prepared to handle
> this unusual input, it may crash.  That is specifically what we want to
> avoid.
> 
> So if a peculiar emulated device created by syzbot is capable of
> crashing the driver, then somewhere there is a bug which needs to be
> fixed.  It's true that fixing all these bugs might not protect against a
> malicious device which deliberately behaves in an apparently reasonable
> manner.  But it does reduce the attack surface.

Thanks for your response.
I will add some checks.

Best Regards,
Hayes

