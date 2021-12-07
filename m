Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2ED46B3DD
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 08:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbhLGHbw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 7 Dec 2021 02:31:52 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:36072 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbhLGHbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 02:31:51 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 1B77S31r8002938, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 1B77S31r8002938
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 7 Dec 2021 15:28:03 +0800
Received: from RTEXMBS01.realtek.com.tw (172.21.6.94) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 7 Dec 2021 15:28:02 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 7 Dec 2021 15:28:02 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::65a3:1e23:d911:4b01]) by
 RTEXMBS04.realtek.com.tw ([fe80::65a3:1e23:d911:4b01%5]) with mapi id
 15.01.2308.020; Tue, 7 Dec 2021 15:28:02 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [RFC PATCH 0/4] r8169: support dash
Thread-Topic: [RFC PATCH 0/4] r8169: support dash
Thread-Index: AQHX5QnDLn6ABzzmpEe3dMh4ox9UtKwaRZuAgAKrunD//4AsAIAD8ppQ///5wgCABkeCEA==
Date:   Tue, 7 Dec 2021 07:28:02 +0000
Message-ID: <e2fd429a489545e7a521283600cb7caa@realtek.com>
References: <20211129101315.16372-381-nic_swsd@realtek.com>
        <20211129095947.547a765f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <918d75ea873a453ab2ba588a35d66ab6@realtek.com>
        <20211130190926.7c1d735d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d3a1e1c469844aa697d6d315c9549eda@realtek.com>
 <20211203070410.1b4abc4d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211203070410.1b4abc4d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.203]
x-kse-serverinfo: RTEXMBS01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2021/12/7_=3F=3F_05:19:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, December 3, 2021 11:04 PM
[...]
> Ah, I've only spotted the enable/disable knob in the patch.
> If you're exchanging arbitrary binary data with the FW we
> can't help you. It's not going to fly upstream. 

How is it that we only provide certain basic settings,
such as IPv4 address, IPv6 address, and so on? Then,
they are not the arbitrary binary data.

Could devlink param be used for more than 4 bytes settings?
At least the IPv6 address is longer.

Besides, we need the information of SMBIOS which could
be 4K ~ 8K bytes data. Is there any way we could transmit
it to firmware?

Best Regards,
Hayes


