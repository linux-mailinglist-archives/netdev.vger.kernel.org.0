Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA3838D33D
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 05:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbhEVDPT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 21 May 2021 23:15:19 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:51139 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbhEVDPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 23:15:18 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 14M3DfGT2011316, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36502.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 14M3DfGT2011316
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 22 May 2021 11:13:41 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXH36502.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Sat, 22 May 2021 11:13:40 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Sat, 22 May 2021 11:13:40 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::1d8:ba7d:61ca:bd74]) by
 RTEXMBS04.realtek.com.tw ([fe80::1d8:ba7d:61ca:bd74%5]) with mapi id
 15.01.2106.013; Sat, 22 May 2021 11:13:40 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "syzbot+95afd23673f5dd295c57@syzkaller.appspotmail.com" 
        <syzbot+95afd23673f5dd295c57@syzkaller.appspotmail.com>
Subject: RE: [PATCH net] r8152: check the informaton of the device
Thread-Topic: [PATCH net] r8152: check the informaton of the device
Thread-Index: AQHXTiDTUevScj9u/kW7OuVFBi+KHqrtKP8AgAGqvnA=
Date:   Sat, 22 May 2021 03:13:39 +0000
Message-ID: <73dec4e9ba05452c90af9e174cacf7f8@realtek.com>
References: <1394712342-15778-363-Taiwan-albertk@realtek.com>
 <YKeAonwHduV8I+NW@kroah.com>
In-Reply-To: <YKeAonwHduV8I+NW@kroah.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.203]
x-kse-serverinfo: RTEXDAG02.realtek.com.tw, 9
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2021/5/21_=3F=3F_10:46:00?=
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
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 05/22/2021 03:00:35
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 163845 [May 22 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: hayeswang@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 446 446 0309aa129ce7cd9d810f87a68320917ac2eba541
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: realtek.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 05/22/2021 03:02:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org>
> Sent: Friday, May 21, 2021 5:43 PM
[...]
> We have a USB core function that does all of the above for you, why not
> use that instead?
> 
> Look at usb_find_common_endpoints() and
> usb_find_common_endpoints_reverse() and at the very least
> usb_find_bulk_in_endpoint() and related functions.  Please don't
> open-code this type of logic, it's easy to get things wrong.

Fine. Thanks.

Best Regards,
Hayes

