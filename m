Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8C626F8DC
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 11:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgIRJDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 05:03:12 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:38695 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgIRJDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 05:03:12 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.69 with qID 08I92h6S2008233, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb06.realtek.com.tw[172.21.6.99])
        by rtits2.realtek.com.tw (8.15.2/2.66/5.86) with ESMTPS id 08I92h6S2008233
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 18 Sep 2020 17:02:43 +0800
Received: from RTEXMB02.realtek.com.tw (172.21.6.95) by
 RTEXMB06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Fri, 18 Sep 2020 17:02:43 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMB02.realtek.com.tw (172.21.6.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Fri, 18 Sep 2020 17:02:43 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::3477:84c0:6ac8:dfee]) by
 RTEXMB04.realtek.com.tw ([fe80::3477:84c0:6ac8:dfee%3]) with mapi id
 15.01.2044.006; Fri, 18 Sep 2020 17:02:43 +0800
From:   =?big5?B?vEKwtsV2?= <willy.liu@realtek.com>
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
Thread-Index: AQHWjJNc0PLfuV8nRk6LzdCHjJFbVKlsUNmAgAHJbvA=
Date:   Fri, 18 Sep 2020 09:02:43 +0000
Message-ID: <da7e5ceda2724cb5a1aa69d6304bcf95@realtek.com>
References: <1600306748-3176-1-git-send-email-willy.liu@realtek.com>
 <20200917134007.GN3526428@lunn.ch>
In-Reply-To: <20200917134007.GN3526428@lunn.ch>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.179.211]
Content-Type: text/plain; charset="big5"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3LA0KVGhhbmtzIGZvciB5b3VyIGluZm9ybWF0aW9uLiBTaG91bGQgSSBkbyBhbnkg
bW9kaWZpY2F0aW9ucyB0byBtYWtlIHRoaXMgcGF0Y2ggYmUgYXBwbGllZD8NCg0KQi5SLg0KV2ls
bHkNCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IEFuZHJldyBMdW5uIDxhbmRy
ZXdAbHVubi5jaD4gDQpTZW50OiBUaHVyc2RheSwgU2VwdGVtYmVyIDE3LCAyMDIwIDk6NDAgUE0N
ClRvOiC8QrC2xXYgPHdpbGx5LmxpdUByZWFsdGVrLmNvbT4NCkNjOiBoa2FsbHdlaXQxQGdtYWls
LmNvbTsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgbGludXhAYXJtbGludXgub3JnLnVrOyBrdWJhQGtl
cm5lbC5vcmc7IFJ5YW4gS2FvIDxyeWFua2FvQHJlYWx0ZWsuY29tPjsgbmV0ZGV2QHZnZXIua2Vy
bmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KU3ViamVjdDogUmU6IFtQQVRD
SF0gbmV0OiBwaHk6IHJlYWx0ZWs6IFJlcGxhY2UgMi41R2JwcyBuYW1lIGZyb20gUlRMODEyNSB0
byBSVEw4MjI2DQoNCk9uIFRodSwgU2VwIDE3LCAyMDIwIGF0IDA5OjM5OjA4QU0gKzA4MDAsIFdp
bGx5IExpdSB3cm90ZToNCj4gQWNjb3JkaW5nIHRvIFBIWSBJRCwgMHgwMDFjYzgwMCBzaG91bGQg
YmUgbmFtZWQgIlJUTDgyMjYgMi41R2JwcyBQSFkiDQo+IGFuZCAweDAwMWNjODQwIHNob3VsZCBi
ZSBuYW1lZCAiUlRMODIyNkJfUlRMODIyMUIgMi41R2JwcyBQSFkiLg0KPiBSVEw4MTI1IGlzIG5v
dCBhIHNpbmdsZSBQSFkgc29sdXRpb24sIGl0IGludGVncmF0ZXMgUEhZL01BQy9QQ0lFIGJ1cyAN
Cj4gY29udHJvbGxlciBhbmQgZW1iZWRkZWQgbWVtb3J5Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTog
V2lsbHkgTGl1IDx3aWxseS5saXVAcmVhbHRlay5jb20+DQoNCkhpIFdpbGx5DQoNCkJlZm9yZSBz
dWJtaXR0aW5nIGFueSBtb3JlIHBhdGNoZXMsIHBsZWFzZSB0YWtlIGEgbG9vayBhdDoNCg0KaHR0
cHM6Ly93d3cua2VybmVsLm9yZy9kb2MvaHRtbC9sYXRlc3QvbmV0d29ya2luZy9uZXRkZXYtRkFR
Lmh0bWwNCg0KUmV2aWV3ZWQtYnk6IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD4NCg0KICAg
IEFuZHJldw0KDQotLS0tLS1QbGVhc2UgY29uc2lkZXIgdGhlIGVudmlyb25tZW50IGJlZm9yZSBw
cmludGluZyB0aGlzIGUtbWFpbC4NCg==
