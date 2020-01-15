Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 197EA13BA11
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 08:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbgAOHEX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 15 Jan 2020 02:04:23 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:36166 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbgAOHEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 02:04:23 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID 00F744CQ024629, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id 00F744CQ024629
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jan 2020 15:04:04 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTITCAS11.realtek.com.tw (172.21.6.12) with Microsoft SMTP Server (TLS) id
 14.3.468.0; Wed, 15 Jan 2020 15:04:04 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMB04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 15 Jan 2020 15:04:03 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::d9c5:a079:495e:b999]) by
 RTEXMB04.realtek.com.tw ([fe80::d9c5:a079:495e:b999%6]) with mapi id
 15.01.1779.005; Wed, 15 Jan 2020 15:04:03 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Kai Heng Feng <kai.heng.feng@canonical.com>,
        "Mario.Limonciello@dell.com" <Mario.Limonciello@dell.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "pmalani@chromium.org" <pmalani@chromium.org>,
        "grundler@chromium.org" <grundler@chromium.org>,
        "<David.Chen7@dell.com>" <David.Chen7@Dell.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] r8152: Add MAC passthrough support to new device
Thread-Topic: [PATCH] r8152: Add MAC passthrough support to new device
Thread-Index: AQHVypTrvWsj1nE3Z02rCzrvB8fQNKfqGHCAgACphYCAAIjAgA==
Date:   Wed, 15 Jan 2020 07:04:03 +0000
Message-ID: <2eddafe6b9694a288013c3af41321ce5@realtek.com>
References: <20200114044127.20085-1-kai.heng.feng@canonical.com>
 <d8af34dbf4994b7b8b0bf48e81084dd0@AUSX13MPC101.AMER.DELL.COM>
 <430A264A-27E0-489D-B7B1-8E78AAD528D7@canonical.com>
In-Reply-To: <430A264A-27E0-489D-B7B1-8E78AAD528D7@canonical.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.214]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kai Heng Feng [mailto:kai.heng.feng@canonical.com]
> Sent: Wednesday, January 15, 2020 2:40 PM
[...]
> >> Device 0xa387 also supports MAC passthrough, therefore add it to the
> >> whitelst.
> >
> > Have you confirmed whether this product ID is unique to the products that
> > support this feature or if it's also re-used in other products?
> 
> This is unique for Lenovo product.
> 
> >
> > For Dell's devices there are very specific tests that make sure that this
> > feature only applies on the products it is supposed to and nothing else
> > (For example RTL8153-AD checks variant as well as effuse value)
> > (Example two: RTL8153-BND is a Dell only part).
> 
> Hayes, do you know how macpassthru on Lenovo dock works?

I don't sure about it.

The Dell's devices use the VID/PID of Realtek, so they have another way
to check which devices support macpassthru.

The Lenovo use their VID/PID, so I guess they only check VID/PID.

Best Regards,
Hayes



