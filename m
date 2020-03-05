Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBE9117A55B
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 13:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgCEMgq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 5 Mar 2020 07:36:46 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:56872 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbgCEMgp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 07:36:45 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID 025CaUfw015156, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTEXMB06.realtek.com.tw[172.21.6.99])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id 025CaUfw015156
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 5 Mar 2020 20:36:30 +0800
Received: from RTEXMB03.realtek.com.tw (172.21.6.96) by
 RTEXMB06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 5 Mar 2020 20:36:30 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMB03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 5 Mar 2020 20:36:29 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::d9c5:a079:495e:b999]) by
 RTEXMB04.realtek.com.tw ([fe80::d9c5:a079:495e:b999%6]) with mapi id
 15.01.1779.005; Thu, 5 Mar 2020 20:36:29 +0800
From:   Hau <hau@realtek.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        "Kernel development list" <linux-kernel@vger.kernel.org>,
        Anthony Wong <anthony.wong@canonical.com>,
        Jason Yen <jason.yen@canonical.com>
Subject: RE: SFP+ support for 8168fp/8117
Thread-Topic: SFP+ support for 8168fp/8117
Thread-Index: AQHVwTo87C9FPgb4q0K7N9j/9Mzg+6fW+ByAgAAXwwCAAE15gIAAfZ0AgECGEQCAAkeigIAECCeAgAQrRCCADDcng4AJ2WCQ//9+CYCAAbubwA==
Date:   Thu, 5 Mar 2020 12:36:29 +0000
Message-ID: <112c2e67a6704a76befd99d32b4b40f6@realtek.com>
References: <DC28A43E-4F1A-40B6-84B0-3E79215527C9@canonical.com>
 <c148fefc-fd56-26a8-9f9b-fbefbaf25050@gmail.com>
 <02F7CBDE-B877-481C-A5AF-2F4CBF830A2C@canonical.com>
 <80E9C881-91C8-4F29-B9CE-652F9EE0B018@canonical.com>
 <995bddbc4f9d48cbb3a289a7e9799f15@realtek.com>
 <12EA7285-06D7-44D3-B033-4F52A06123CC@canonical.com>
 <cae39cfbb5174c8884328887cdfb5a89@realtek.com>
 <9AAC75D4-B04F-49CD-BBB9-11AE3382E4D8@canonical.com>
 <5A21808E-C9DA-44BF-952B-4A5077B52E9B@canonical.com>
 <e10eef58d8fc4b67ac2a73784bf86381@realtek.com>
 <20200304152849.GE3553@lunn.ch>
In-Reply-To: <20200304152849.GE3553@lunn.ch>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.157]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Hi Kai-Heng,
> >
> > For adding SFP+ support for rtl8168fp, 1.Some power saving features
> > must be disabled, like APDLS/EEE/EEEPLUS...
> > 2.PHY capability must be set to auto-negation.
> >
> > I am kind of busy this week. I will try to add support for this chip into
> upstream next week.
> 
> Is it possible to access the I2C bus? The GPIO lines from the SFP socket like
> LOS, TX Disable?
> 

I am asking our hardware team.  I will get back to you once I get the answer.

Thanks,
Hau
------Please consider the environment before printing this e-mail.
