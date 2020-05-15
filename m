Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC8D1D420E
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 02:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbgEOA0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 20:26:36 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:57865 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728131AbgEOA0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 20:26:36 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.69 with qID 04F0QFPu8011756, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb06.realtek.com.tw[172.21.6.99])
        by rtits2.realtek.com.tw (8.15.2/2.66/5.86) with ESMTPS id 04F0QFPu8011756
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 15 May 2020 08:26:15 +0800
Received: from RTEXDAG01.realtek.com.tw (172.21.6.100) by
 RTEXMB06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Fri, 15 May 2020 08:26:15 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXDAG01.realtek.com.tw (172.21.6.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Fri, 15 May 2020 08:26:15 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::8001:f5f5:a41e:f8d4]) by
 RTEXMB04.realtek.com.tw ([fe80::8001:f5f5:a41e:f8d4%3]) with mapi id
 15.01.1779.005; Fri, 15 May 2020 08:26:15 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Tony Chuang <yhchuang@realtek.com>,
        "colin.king@canonical.com" <colin.king@canonical.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH][next] rtw88: 8723d: fix incorrect setting of ldo_pwr
Thread-Topic: [PATCH][next] rtw88: 8723d: fix incorrect setting of ldo_pwr
Thread-Index: AQHWKhti7lhzaSVBmUG5wyOyhYF1sqinxIaA
Date:   Fri, 15 May 2020 00:26:14 +0000
Message-ID: <1589502367.2500.2.camel@realtek.com>
References: <20200514181329.16292-1-colin.king@canonical.com>
In-Reply-To: <20200514181329.16292-1-colin.king@canonical.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.213]
Content-Type: text/plain; charset="utf-8"
Content-ID: <7BA5728ACA45E54F983A55A77EB2DFA0@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTA1LTE0IGF0IDE4OjEzICswMDAwLCBDb2xpbiBLaW5nIHdyb3RlOg0KPiBG
cm9tOiBDb2xpbiBJYW4gS2luZyA8Y29saW4ua2luZ0BjYW5vbmljYWwuY29tPg0KPiANCj4gQ3Vy
cmVudGx5IGxkb19wd3IgaGFzIHRoZSBMRE8yNSB2b2x0YWdlIGJpdHMgc2V0IHRvIHplcm8gYW5k
IHRoZW4NCj4gaXQgaXMgb3ZlcndyaXR0ZW4gd2l0aCB0aGUgbmV3IHZvbHRhZ2Ugc2V0dGluZy4g
VGhlIGFzc2lnbm1lbnQNCj4gbG9va3MgaW5jb3JyZWN0LCBpdCBzaG91bGQgYmUgYml0LXdpc2Ug
b3InaW5nIGluIHRoZSBuZXcgdm9sdGFnZQ0KPiBzZXR0aW5nIHJhdGhlciB0aGFuIGEgZGlyZWN0
IGFzc2lnbm1lbnQuDQo+IA0KPiBBZGRyZXNzZXMtQ292ZXJpdHk6ICgiVW51c2VkIHZhbHVlIikN
Cj4gRml4ZXM6IDFhZmI1ZWI3YTAwZCAoInJ0dzg4OiA4NzIzZDogQWRkIGNmZ19sZG8yNSB0byBj
b250cm9sIExETzI1IikNCj4gU2lnbmVkLW9mZi1ieTogQ29saW4gSWFuIEtpbmcgPGNvbGluLmtp
bmdAY2Fub25pY2FsLmNvbT4NCg0KVGhhbmsgeW91IGZvciB5b3VyIGZpeC4NCg0KQWNrZWQtYnk6
IFBpbmctS2UgU2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPg0KDQo+IC0tLQ0KPiDCoGRyaXZlcnMv
bmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvcnR3ODcyM2QuYyB8IDIgKy0NCj4gwqAxIGZpbGUg
Y2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3J0dzg3MjNkLmMNCj4gYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3J0dzg3MjNkLmMNCj4gaW5kZXggYjUxN2Fm
NDE3ZTBlLi4yYzZlNDE3YzViY2EgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L3JlYWx0ZWsvcnR3ODgvcnR3ODcyM2QuYw0KPiArKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9y
ZWFsdGVrL3J0dzg4L3J0dzg3MjNkLmMNCj4gQEAgLTU2MSw3ICs1NjEsNyBAQCBzdGF0aWMgdm9p
ZCBydHc4NzIzZF9jZmdfbGRvMjUoc3RydWN0IHJ0d19kZXYgKnJ0d2RldiwNCj4gYm9vbCBlbmFi
bGUpDQo+IMKgCWxkb19wd3IgPSBydHdfcmVhZDgocnR3ZGV2LCBSRUdfTERPX0VGVVNFX0NUUkwg
KyAzKTsNCj4gwqAJaWYgKGVuYWJsZSkgew0KPiDCoAkJbGRvX3B3ciAmPSB+QklUX01BU0tfTERP
MjVfVk9MVEFHRTsNCj4gLQkJbGRvX3B3ciA9IChCSVRfTERPMjVfVk9MVEFHRV9WMjUgPDwgNCkg
fCBCSVRfTERPMjVfRU47DQo+ICsJCWxkb19wd3IgfD0gKEJJVF9MRE8yNV9WT0xUQUdFX1YyNSA8
PCA0KSB8IEJJVF9MRE8yNV9FTjsNCj4gwqAJfSBlbHNlIHsNCj4gwqAJCWxkb19wd3IgJj0gfkJJ
VF9MRE8yNV9FTjsNCj4gwqAJfQ0KPiAtLcKgDQo+IDIuMjUuMQ0KPiANCj4gDQo+IC0tLS0tLVBs
ZWFzZSBjb25zaWRlciB0aGUgZW52aXJvbm1lbnQgYmVmb3JlIHByaW50aW5nIHRoaXMgZS1tYWls
Lg0KDQoNCg==
