Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0C8464533
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 03:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346342AbhLADAs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 30 Nov 2021 22:00:48 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:59336 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346343AbhLADAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 22:00:47 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 1B12v1QH1016468, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36503.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 1B12v1QH1016468
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 1 Dec 2021 10:57:01 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXH36503.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 1 Dec 2021 10:57:01 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 1 Dec 2021 10:57:01 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::e095:6756:b2cf:3baa]) by
 RTEXMBS04.realtek.com.tw ([fe80::e095:6756:b2cf:3baa%5]) with mapi id
 15.01.2308.015; Wed, 1 Dec 2021 10:57:01 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [RFC PATCH 0/4] r8169: support dash
Thread-Topic: [RFC PATCH 0/4] r8169: support dash
Thread-Index: AQHX5QnDLn6ABzzmpEe3dMh4ox9UtKwaRZuAgAKrunA=
Date:   Wed, 1 Dec 2021 02:57:00 +0000
Message-ID: <918d75ea873a453ab2ba588a35d66ab6@realtek.com>
References: <20211129101315.16372-381-nic_swsd@realtek.com>
 <20211129095947.547a765f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211129095947.547a765f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.203]
x-kse-serverinfo: RTEXDAG02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2021/11/30_=3F=3F_11:16:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36503.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, November 30, 2021 2:00 AM
> Subject: Re: [RFC PATCH 0/4] r8169: support dash
> 
> On Mon, 29 Nov 2021 18:13:11 +0800 Hayes Wang wrote:
> > These patches are used to support dash for RTL8111EP and
> > RTL8111FP(RTL81117).
> 
> If I understand correctly DASH is a DMTF standard for remote control.
> 
> Since it's a standard I think we should have a common way of
> configuring it across drivers.

Excuse me. I am not familiar with it.
What document or sample code could I start?

> Is enable/disable the only configuration
> that we will need?

I don't think I could answer it before I understand the above way
you mentioned.

> We don't use sysfs too much these days, can we move the knob to
> devlink, please? (If we only need an on/off switch generic devlink param
> should be fine).

Thanks. I would study devlink.

Best Regards,
Hayes

