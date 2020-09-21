Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1B3F27190B
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 03:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbgIUB4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 21:56:10 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:53419 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbgIUB4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 21:56:10 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.69 with qID 08L1tOygD016708, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb06.realtek.com.tw[172.21.6.99])
        by rtits2.realtek.com.tw (8.15.2/2.66/5.86) with ESMTPS id 08L1tOygD016708
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 21 Sep 2020 09:55:24 +0800
Received: from RTEXMB03.realtek.com.tw (172.21.6.96) by
 RTEXMB06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Mon, 21 Sep 2020 09:55:24 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMB03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Mon, 21 Sep 2020 09:55:23 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::3477:84c0:6ac8:dfee]) by
 RTEXMB04.realtek.com.tw ([fe80::3477:84c0:6ac8:dfee%3]) with mapi id
 15.01.2044.006; Mon, 21 Sep 2020 09:55:23 +0800
From:   =?utf-8?B?5YqJ5YGJ5qyK?= <willy.liu@realtek.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Ryan Kao <ryankao@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: phy: realtek: Replace 2.5Gbps name from RTL8125 to RTL8226
Thread-Topic: [PATCH] net: phy: realtek: Replace 2.5Gbps name from RTL8125 to
 RTL8226
Thread-Index: AQHWjJNc0PLfuV8nRk6LzdCHjJFbVKlsUNmAgAHJbvD//87ZAIAEcbXg
Date:   Mon, 21 Sep 2020 01:55:23 +0000
Message-ID: <29bf7b8fe2c94e0e9f8eddaf533919b8@realtek.com>
References: <1600306748-3176-1-git-send-email-willy.liu@realtek.com>
 <20200917134007.GN3526428@lunn.ch>
 <da7e5ceda2724cb5a1aa69d6304bcf95@realtek.com>
 <20200918140124.GD3631014@lunn.ch>
In-Reply-To: <20200918140124.GD3631014@lunn.ch>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.179.211]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3LA0KVGhhbmtzLi4udW5kZXJzdG9vZC4uLg0KDQpCLlIuDQpXaWxseQ0KLS0tLU9y
aWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPiAN
ClNlbnQ6IEZyaWRheSwgU2VwdGVtYmVyIDE4LCAyMDIwIDEwOjAxIFBNDQpUbzog5YqJ5YGJ5qyK
IDx3aWxseS5saXVAcmVhbHRlay5jb20+DQpDYzogaGthbGx3ZWl0MUBnbWFpbC5jb207IGRhdmVt
QGRhdmVtbG9mdC5uZXQ7IGxpbnV4QGFybWxpbnV4Lm9yZy51azsga3ViYUBrZXJuZWwub3JnOyBS
eWFuIEthbyA8cnlhbmthb0ByZWFsdGVrLmNvbT47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxp
bnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNClN1YmplY3Q6IFJlOiBbUEFUQ0hdIG5ldDogcGh5
OiByZWFsdGVrOiBSZXBsYWNlIDIuNUdicHMgbmFtZSBmcm9tIFJUTDgxMjUgdG8gUlRMODIyNg0K
DQpPbiBGcmksIFNlcCAxOCwgMjAyMCBhdCAwOTowMjo0M0FNICswMDAwLCDlionlgYnmrIogd3Jv
dGU6DQo+IEhpIEFuZHJldywNCj4gVGhhbmtzIGZvciB5b3VyIGluZm9ybWF0aW9uLiBTaG91bGQg
SSBkbyBhbnkgbW9kaWZpY2F0aW9ucyB0byBtYWtlIHRoaXMgcGF0Y2ggYmUgYXBwbGllZD8NCg0K
UGxlYXNlIGRvIG5vdCB0byBwb3N0LiBBbmQgd3JhcCB5b3VyIHRleHQgdG8gYWJvdXQgNzUgY2hh
cmFjdGVycy4NCg0KU2luY2UgaSB0aGluayB5b3UgYXJlIG5ldyB0byBwb3N0aW5nIHRvIG5ldGRl
diwgd2UgdGVuZCB0byBiZSBnZW5lcm91cyB0byBzdGFydCB3aXRoLCBhbmQgYWxsb3cgbWlub3Ig
cHJvY2VzcyBlcnJvcnMuIEJ1dCB3ZSBkbyBleHBlY3QgeW91IHRvIGxlYXJuIGZyb20gd2hhdCB3
ZSBzYXksIGFuZCB3YXRjaCBvdGhlciBwYXRjaGVzIG9uIG5ldGRldiwgc28gdGhhdCBmdXR1cmUg
cGF0Y2hlcyBkbyBmb2xsb3cgdGhlIHByb2Nlc3Nlcy4gU28gcGxlYXNlIGdldCBbUEFUQ0ggPHRy
ZWU+IHY8dmVyc2lvbj5dIGNvcnJlY3QgaW4geW91ciBuZXh0IHBhdGNoZXMsIGluY2x1ZGUgYSBz
dW1tYXJ5IG9mIHdoYXQgaGFzIGNoYW5nZWQgYmV0d2VlbiB2ZXJzaW9ucywgZXRjLg0KDQpJIGd1
ZXNzIERhdmlkIHdpbGwgYWNjZXB0IHRoaXMgcGF0Y2guIElmIG5vdCwgaGUgd2lsbCB0ZWxsIHlv
dSB3aHkgYW5kIHdoYXQgeW91IG5lZWQgdG8gaW1wcm92ZS4NCg0KICBBbmRyZXcNCg0KLS0tLS0t
UGxlYXNlIGNvbnNpZGVyIHRoZSBlbnZpcm9ubWVudCBiZWZvcmUgcHJpbnRpbmcgdGhpcyBlLW1h
aWwuDQo=
