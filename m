Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD668273B11
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 08:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729220AbgIVGnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 02:43:49 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:60494 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726982AbgIVGns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 02:43:48 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.69 with qID 08M6gutA7012303, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb05.realtek.com.tw[172.21.6.98])
        by rtits2.realtek.com.tw (8.15.2/2.66/5.86) with ESMTPS id 08M6gutA7012303
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 22 Sep 2020 14:42:56 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMB05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Tue, 22 Sep 2020 14:42:56 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::3477:84c0:6ac8:dfee]) by
 RTEXMB04.realtek.com.tw ([fe80::3477:84c0:6ac8:dfee%3]) with mapi id
 15.01.2044.006; Tue, 22 Sep 2020 14:42:56 +0800
From:   =?utf-8?B?5YqJ5YGJ5qyK?= <willy.liu@realtek.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Serge Semin <fancer.lancer@gmail.com>,
        Kyle Evans <kevans@FreeBSD.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ryan Kao <ryankao@realtek.com>,
        "Joe Hershberger" <joe.hershberger@ni.com>,
        Peter Robinson <pbrobinson@gmail.com>
Subject: RE: [PATCH] net: phy: realtek: fix rtl8211e rx/tx delay config
Thread-Topic: [PATCH] net: phy: realtek: fix rtl8211e rx/tx delay config
Thread-Index: AQHWjJSIgE9wGMLbJkqAPItOTw6viqlsFkuAgAHOTXCAAAJ4gIAAG6aAgARrxhCAAEWCAIABVN6Q
Date:   Tue, 22 Sep 2020 06:42:55 +0000
Message-ID: <0de78894c4104046a262531cbbc225f1@realtek.com>
References: <1600307253-3538-1-git-send-email-willy.liu@realtek.com>
 <20200917101035.uwajg4m524g4lz5o@mobilestation>
 <87c4ebf4b1fe48a7a10b27d0ba0b333c@realtek.com>
 <20200918135403.GC3631014@lunn.ch>
 <20200918153301.chwlvzh6a2bctbjw@mobilestation>
 <e14a0e96ddf8480591f98677cdca5e77@realtek.com>
 <20200921151234.GC3717417@lunn.ch>
In-Reply-To: <20200921151234.GC3717417@lunn.ch>
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

SGkgQW5kcmV3LA0KSSBzdW1tYXJ5IHRhYmxlIDEyLDEzIGZyb20gUlRMODIxMUUtVkIgZGF0YXNo
ZWV0IGFzIGJlbG93Lg0KW1RhYmxlIDEyXQ0KUlRMODIxMUUtVkIgUGluICAgICAgIFBpbiBOYW1l
DQpMRUQwICAgICAgICAgICAgICAgICBQSFlBRFswXQ0KTEVEMSAgICAgICAgICAgICAgICAgUEhZ
QURbMV0NClJYQ1RMICAgICAgICAgICAgICAgIFBIWUFEWzJdDQpSWEQyICAgICAgICAgICAgICAg
ICBBTlswXQ0KUlhEMyAgICAgICAgICAgICAgICAgQU5bMV0NCiAtICAgICAgICAgICAgICAgICAg
ICBNb2RlDQpMRUQyICAgICAgICAgICAgICAgICBSWCBEZWxheQ0KUlhEMSAgICAgICAgICAgICAg
ICAgVFggRGVsYXkNClJYRDAgICAgICAgICAgICAgICAgIFNFTFJHVg0KVG8gc2V0IHRoZSBDT05G
SUcgcGlucywgYW4gZXh0ZXJuYWwgcHVsbC1oaWdoIG9yIHB1bGwtbG93IHJlc2lzdG9yIGlzIHJl
cXVpcmVkLg0KW1RhYmxlIDEzXQ0KUEhZQURbMjowXTogUEhZIEFkZHJlc3MNCkFOWzE6MF06IEF1
dG8tbmVnb3RpYXRpb24gQ29uZmlndXJhdGlvbg0KTW9kZTogSW50ZXJmYWNlIE1vZGUgc2VsZWN0
DQpSWCBEZWxheTogUkdNSUkgVHJhbnNtaXQgY2xvY2sgdGltaW5nIGNvbnRyb2wNCiAgICAxOiBB
ZGQgMm5zIGRlbGF5IHRvIFJYQyBmb3IgUlhEIGxhdGNoaW5nKHZpYSA0LjdrLW9obSB0byAzLjNW
KQ0KICAgIDA6IE5vIGRlbGF5KHZpYSA0LjdrLW9obSB0byBHTkQpDQpUWCBEZWxheTogUkdNSUkg
VHJhbnNtaXQgY2xvY2sgdGltaW5nIGNvbnRyb2wNCiAgICAxOiBBZGQgMm5zIGRlbGF5IHRvIFRY
QyBmb3IgVFhEIGxhdGNoaW5nKHZpYSA0LjdrLW9obSB0byAzLjNWKQ0KICAgIDA6IE5vIGRlbGF5
KHZpYSA0LjdrLW9obSB0byBHTkQpDQpTRUxSR1Y6IDMuM1Ygb3IgMi41ViBSR01JSS9HTUlJIFNl
bGVjdGlvbg0KDQpUaGVzZSB0d28gdGFibGVzIGRlc2NyaXB0IGhvdyB0byBjb25maWcgaXQgdmlh
IGV4dGVybmFsIHB1bGwtaGlnaCBvciBwdWxsLWxvdyByZXNpc3RvciBvbiBQQ0IgY2lyY3VpdC4N
Cg0KQmVsb3cgcGF0Y2ggZ2l2ZXMgdGFibGUgMTMgYW5vdGhlciBtZWFuaW5nIGFuZCBtYXBzIHRv
IHJlZ2lzdGVyIHNldHRpbmcuDQpodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgv
a2VybmVsL2dpdC9uZXRkZXYvbmV0LmdpdC9jb21taXQvP2lkPWY4MWRhZGJjZjdmZDA2DQo4OjYg
PSBQSFkgQWRkcmVzcw0KNTo0ID0gQXV0by1OZWdvdGlhdGlvbg0KMyA9IEludGVyZmFjZSBNb2Rl
IFNlbGVjdA0KMiA9IFJYIERlbGF5DQoxID0gVFggRGVsYXkNCjAgPSBTRUxSR1YNClN5bmMgZnJv
bSBodHRwczovL3Jldmlld3MuZnJlZWJzZC5vcmcvRDEzNTkxDQoNClNob3VsZCBJIGFkZCBob3cg
dG8gY29uZmlnIFJYL1RYIERlbGF5IHZpYSBwdWxsIGhpZ2gvZG93biByZXNpc3RvciBpbiBwYXRj
aCBkZXNjcmlwdGlvbj8NCg0KV2lsbHkNCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZy
b206IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD4gDQpTZW50OiBNb25kYXksIFNlcHRlbWJl
ciAyMSwgMjAyMCAxMToxMyBQTQ0KVG86IOWKieWBieasiiA8d2lsbHkubGl1QHJlYWx0ZWsuY29t
Pg0KQ2M6IFNlcmdlIFNlbWluIDxmYW5jZXIubGFuY2VyQGdtYWlsLmNvbT47IEt5bGUgRXZhbnMg
PGtldmFuc0BGcmVlQlNELm9yZz47IGhrYWxsd2VpdDFAZ21haWwuY29tOyBsaW51eEBhcm1saW51
eC5vcmcudWs7IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9yZzsgbmV0ZGV2QHZn
ZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgUnlhbiBLYW8gPHJ5
YW5rYW9AcmVhbHRlay5jb20+OyBKb2UgSGVyc2hiZXJnZXIgPGpvZS5oZXJzaGJlcmdlckBuaS5j
b20+OyBQZXRlciBSb2JpbnNvbiA8cGJyb2JpbnNvbkBnbWFpbC5jb20+DQpTdWJqZWN0OiBSZTog
W1BBVENIXSBuZXQ6IHBoeTogcmVhbHRlazogZml4IHJ0bDgyMTFlIHJ4L3R4IGRlbGF5IGNvbmZp
Zw0KDQpPbiBNb24sIFNlcCAyMSwgMjAyMCBhdCAwNzowMDowMEFNICswMDAwLCDlionlgYnmrIog
d3JvdGU6DQo+IEhpIEFuZHJldywNCg0KPiBJIHJlbW92ZWQgYmVsb3cgcmVnaXN0ZXIgbGF5b3V0
IGRlc2NyaXB0aW9ucyBiZWNhdXNlIHRoZXNlIA0KPiBkZXNjcmlwdGlvbnMgZGlkIG5vdCBtYXRj
aCByZWdpc3RlciBkZWZpbml0aW9ucyBmb3IgcnRsODIxMWUgZXh0ZW5zaW9uIA0KPiBwYWdlIDE2
NCByZWcgMHgxYyBhdCBhbGwuDQo+IDg6NiA9IFBIWSBBZGRyZXNzDQo+IDU6NCA9IEF1dG8tTmVn
b3RpYXRpb24NCj4gMyA9IE1vZGUNCj4gMiA9IFJYRA0KPiAxID0gVFhEDQo+IDAgPSBTRUxSR1Yx
DQoNCj4gSSB0aGluayBpdCBpcyBhIG1pc3VuZGVyc3RhbmRpbmcuIFRoZXNlIGRlZmluaXRpb25z
IGFyZSBtYXBwZWQgZnJvbSANCj4gZGF0YXNoZWV0IHJ0bDgyMTFlIHRhYmxlMTMiIENvbmZpZ3Vy
YXRpb24gUmVnaXN0ZXIgRGVmaW5pdGlvbiIuIA0KPiBIb3dldmVyIHRoaXMgdGFibGUgc2hvdWxk
IGJlIEhXIHBpbiBjb25maWd1cmF0aW9ucyBub3QgcmVnaXN0ZXIgDQo+IGRlc2NyaXB0aW9ucy4N
Cg0KU28gdGhlc2UgYXJlIGp1c3QgaG93IHRoZSBkZXZpY2UgaXMgc3RyYXBwZWQuIFNvIGxldHMg
YWRkIHRoYXQgdG8gdGhlIGRlc2NyaXB0aW9uLCByYXRoZXIgdGhhbiByZW1vdmUgaXQuDQoNCj4g
VXNlcnMgY2FuIGNvbmZpZyBSWEQvVFhEIHZpYSByZWdpc3RlciBzZXR0aW5nKGV4dGVuc2lvbiBw
YWdlIDE2NCByZWcgDQo+IDB4MWMpLiBCdXQgYml0IG1hcCBmb3IgdGhlc2UgdHdvIHNldHRpbmdz
IHNob3VsZCBiZSBiZWxvdzoNCj4gMTMgPSBGb3JjZSBUeCBSWCBEZWxheSBjb250cm9sbGVkIGJ5
IGJpdDEyIGJpdDExLA0KPiAxMiA9IFJYIERlbGF5LCAxMSA9IFRYIERlbGF5DQoNCj4gSGkgU2Vy
Z2V5LA0KDQo+IEkgc2F3IHRoZSBzdW1tYXJ5IGZyb20gaHR0cHM6Ly9yZXZpZXdzLmZyZWVic2Qu
b3JnL0QxMzU5MS4gVGhpcyBwYXRjaCANCj4gaXMgdG8gcmVjb25maWd1cmUgdGhlIFJUTDgyMTFF
IHVzZWQgdG8gZm9yY2Ugb2ZmIFRYRC9SWEQgKFJYRCBpcyANCj4gZGVmYXVsdGluZyB0byBvbiwg
aW4gbXkgY2hlY2tzKSBhbmQgdHVybiBvbiBzb21lIGJpdHMgaW4gdGhlIA0KPiBjb25maWd1cmF0
aW9uIHJlZ2lzdGVyIGZvciB0aGlzIFBIWSB0aGF0IGFyZSB1bmRvY3VtZW50ZWQuDQoNCj4gVGhl
IGRlZmF1bHQgdmFsdWUgZm9yICJleHRlbnNpb24gcGcgMHhhNCByZWcgMHgxYyIgaXMgMHg4MTQ4
LCBhbmQNCj4gYml0MS0yIHNob3VsZCBiZSAwLiBJbiBteSBvcGluaW9uLCB0aGlzIHBhdGNoIHNo
b3VsZCBiZSB3b3JrZWQgYmFzZWQgDQo+IG9uIHRoZSBtYWdpYyBudW1iZXIgKDB4YjQwMCkuDQoN
Ck1hZ2ljIG51bWJlcnMgYXJlIGFsd2F5cyBiYWQuIFBsZWFzZSBkb2N1bWVudCB3aGF0IHRoZXNl
IGJpdHMgbWVhbi4NCg0KICAgICAgQW5kcmV3DQoNCi0tLS0tLVBsZWFzZSBjb25zaWRlciB0aGUg
ZW52aXJvbm1lbnQgYmVmb3JlIHByaW50aW5nIHRoaXMgZS1tYWlsLg0K
