Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80AF2B566B
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 02:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbgKQBuL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 16 Nov 2020 20:50:11 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:55329 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgKQBuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 20:50:11 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 0AH1o4WJ1014800, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb03.realtek.com.tw[172.21.6.96])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 0AH1o4WJ1014800
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 17 Nov 2020 09:50:04 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.33) by
 RTEXMB03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Tue, 17 Nov 2020 09:50:03 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMBS04.realtek.com.tw (172.21.6.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 17 Nov 2020 09:50:03 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::89f7:e6c3:b043:15fa]) by
 RTEXMB04.realtek.com.tw ([fe80::89f7:e6c3:b043:15fa%3]) with mapi id
 15.01.2044.006; Tue, 17 Nov 2020 09:50:03 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH net-next] r8153_ecm: avoid to be prior to r8152 driver
Thread-Topic: [PATCH net-next] r8153_ecm: avoid to be prior to r8152 driver
Thread-Index: AQHWu+Uk6MVFESXbN0aOZKSDeZR30KnJ9OqAgACBuYCAARgAcA==
Date:   Tue, 17 Nov 2020 01:50:03 +0000
Message-ID: <02f38e505a3a45389e2f3c06b2f6c850@realtek.com>
References: <7fd014f2-c9a5-e7ec-f1c6-b3e4bb0f6eb6@samsung.com>
        <CGME20201116065317eucas1p2a2d141857bbdd6b4998dd11937d52f56@eucas1p2.samsung.com>
        <1394712342-15778-393-Taiwan-albertk@realtek.com>
        <5f3db229-940c-c8ed-257b-0b4b3dd2afbb@samsung.com>
 <20201116090231.423afc8f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201116090231.423afc8f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.146]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, November 17, 2020 1:03 AM
[...]
> > Yes, this fixes this issue, although I would prefer a separate Kconfig
> > entry for r8153_ecm with proper dependencies instead of this ifdefs in
> > Makefile.
> 
> Agreed, this is what dependency resolution is for.
> 
> Let's just make this a separate Kconfig entry.

Excuse me. I am not familiar with Kconfig.

I wish r8153_ecm could be used, even
CONFIG_USB_RTL8152 is not defined.

How should set it in Kconfig? 

Best Regards,
Hayes

