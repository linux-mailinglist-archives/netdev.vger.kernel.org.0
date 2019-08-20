Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4E55955D5
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 06:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728777AbfHTENe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 00:13:34 -0400
Received: from mx21.baidu.com ([220.181.3.85]:43315 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726049AbfHTENe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 00:13:34 -0400
X-Greylist: delayed 919 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Aug 2019 00:13:31 EDT
Received: from BJHW-Mail-Ex09.internal.baidu.com (unknown [10.127.64.32])
        by Forcepoint Email with ESMTPS id 9085379895129;
        Tue, 20 Aug 2019 11:57:58 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 BJHW-Mail-Ex09.internal.baidu.com (10.127.64.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Tue, 20 Aug 2019 11:57:59 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1713.004; Tue, 20 Aug 2019 11:57:59 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Zhang,Yu(ACG Cloud)" <zhangyu31@baidu.com>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIG5ldDogRml4IF9faXBfbWNfaW5jX2dyb3VwIGFy?=
 =?utf-8?Q?gument_3_input?=
Thread-Topic: [PATCH] net: Fix __ip_mc_inc_group argument 3 input
Thread-Index: AQHVVwkZYOdVgjsZ+Ee2WbCTE+Ysv6cDaDdw
Date:   Tue, 20 Aug 2019 03:57:59 +0000
Message-ID: <a1a50c3e63e24c538594696b684183a2@baidu.com>
References: <1566267933-30434-1-git-send-email-lirongqing@baidu.com>
 <39691d93-4150-2d0f-2978-4c5c68c893eb@gmail.com>
In-Reply-To: <39691d93-4150-2d0f-2978-4c5c68c893eb@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.198.23]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiANCj4gDQo+IE9uIDgvMTkvMjAxOSA3OjI1IFBNLCBMaSBSb25nUWluZyB3cm90ZToNCj4gPiBJ
dCBleHBlY3RzIGdmcF90LCBidXQgZ290IHVuc2lnbmVkIGludCBtb2RlDQo+ID4NCj4gPiBGaXhl
czogNmUyMDU5YjUzZjk4ICgiaXB2NC9pZ21wOiBpbml0IGdyb3VwIG1vZGUgYXMgSU5DTFVERSB3
aGVuIGpvaW4NCj4gPiBzb3VyY2UgZ3JvdXAiKQ0KPiA+IFNpZ25lZC1vZmYtYnk6IExpIFJvbmdR
aW5nIDxsaXJvbmdxaW5nQGJhaWR1LmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBaaGFuZyBZdSA8
emhhbmd5dTMxQGJhaWR1LmNvbT4NCj4gDQo+IFlvdSBoYXZlIGlkZW50aWZpZWQgYSBwcm9ibGVt
LCBidXQgSSBkb24ndCB0aGluayBpdCBjYW1lIGZyb20gdGhpcyBjb21taXQsDQo+IHJhdGhlciBm
cm9tOg0KPiANCj4gOWZiMjA4MDFkYWI0ICgibmV0OiBGaXggaXBfbWNfe2RlYyxpbmN9X2dyb3Vw
IGFsbG9jYXRpb24gY29udGV4dCIpDQo+IA0KPiBzZWUgYmVsb3cgZm9yIGRldGFpbHMuDQo+IA0K
PiA+IC0tLQ0KPiA+ICBuZXQvaXB2NC9pZ21wLmMgfCA0ICsrLS0NCj4gPiAgMSBmaWxlIGNoYW5n
ZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQg
YS9uZXQvaXB2NC9pZ21wLmMgYi9uZXQvaXB2NC9pZ21wLmMgaW5kZXgNCj4gPiAxODBmNjg5NmI5
OGIuLmI4MzUyZDcxNjI1MyAxMDA2NDQNCj4gPiAtLS0gYS9uZXQvaXB2NC9pZ21wLmMNCj4gPiAr
KysgYi9uZXQvaXB2NC9pZ21wLmMNCj4gPiBAQCAtMTQ3NSw3ICsxNDc1LDcgQEAgRVhQT1JUX1NZ
TUJPTChfX2lwX21jX2luY19ncm91cCk7DQo+ID4NCj4gPiAgdm9pZCBpcF9tY19pbmNfZ3JvdXAo
c3RydWN0IGluX2RldmljZSAqaW5fZGV2LCBfX2JlMzIgYWRkcikgIHsNCj4gPiAtCV9faXBfbWNf
aW5jX2dyb3VwKGluX2RldiwgYWRkciwgTUNBU1RfRVhDTFVERSk7DQo+ID4gKwlfX2lwX21jX2lu
Y19ncm91cChpbl9kZXYsIGFkZHIsIEdGUF9LRVJORUwpOw0KPiANCj4gVGhhdCBwYXJ0IGxvb2tz
IGZpbmUuDQo+IA0KPiA+ICB9DQo+ID4gIEVYUE9SVF9TWU1CT0woaXBfbWNfaW5jX2dyb3VwKTsN
Cj4gPg0KPiA+IEBAIC0yMTk3LDcgKzIxOTcsNyBAQCBzdGF0aWMgaW50IF9faXBfbWNfam9pbl9n
cm91cChzdHJ1Y3Qgc29jayAqc2ssDQo+IHN0cnVjdCBpcF9tcmVxbiAqaW1yLA0KPiA+ICAJaW1s
LT5zZmxpc3QgPSBOVUxMOw0KPiA+ICAJaW1sLT5zZm1vZGUgPSBtb2RlOw0KPiA+ICAJcmN1X2Fz
c2lnbl9wb2ludGVyKGluZXQtPm1jX2xpc3QsIGltbCk7DQo+ID4gLQlfX2lwX21jX2luY19ncm91
cChpbl9kZXYsIGFkZHIsIG1vZGUpOw0KPiA+ICsJX19pcF9tY19pbmNfZ3JvdXAoaW5fZGV2LCBh
ZGRyLCBHRlBfS0VSTkVMKTsNCj4gDQo+IEJ1dCBoZXJlLCB3ZSBwcm9iYWJseSB3YW50IHRvIHBh
c3MgYm90aCBtb2RlIGFuZCBnZnBfdCBhbmQgdXNlDQo+IF9fX19pcF9tY19pbmNfZ3JvdXAoaW5f
ZGV2LCBhZGRyLCBtb2RlLCBHRlBfS0VSTkVMKToNCj4gDQo+IGRpZmYgLS1naXQgYS9uZXQvaXB2
NC9pZ21wLmMgYi9uZXQvaXB2NC9pZ21wLmMgaW5kZXgNCj4gMTgwZjY4OTZiOThiLi4yNDU5YjVl
M2ZkOTggMTAwNjQ0DQo+IC0tLSBhL25ldC9pcHY0L2lnbXAuYw0KPiArKysgYi9uZXQvaXB2NC9p
Z21wLmMNCj4gQEAgLTIxOTcsNyArMjE5Nyw3IEBAIHN0YXRpYyBpbnQgX19pcF9tY19qb2luX2dy
b3VwKHN0cnVjdCBzb2NrICpzaywNCj4gc3RydWN0IGlwX21yZXFuICppbXIsDQo+ICAgICAgICAg
aW1sLT5zZmxpc3QgPSBOVUxMOw0KPiAgICAgICAgIGltbC0+c2Ztb2RlID0gbW9kZTsNCj4gICAg
ICAgICByY3VfYXNzaWduX3BvaW50ZXIoaW5ldC0+bWNfbGlzdCwgaW1sKTsNCj4gLSAgICAgICBf
X2lwX21jX2luY19ncm91cChpbl9kZXYsIGFkZHIsIG1vZGUpOw0KPiArICAgICAgIF9fX19pcF9t
Y19pbmNfZ3JvdXAoaW5fZGV2LCBhZGRyLCBtb2RlLCBHRlBfS0VSTkVMKTsNCj4gICAgICAgICBl
cnIgPSAwOw0KPiAgZG9uZToNCj4gICAgICAgICByZXR1cm4gZXJyOw0KPiANCj4gV2hhdCBkbyB5
b3UgdGhpbms/DQoNCg0KWW91IGFyZSByaWdodCwgSSB3aWxsIHNlbmQgVjINCg0KVGhhbmtzDQoN
Ci1Sb25nUWluZw0KDQoNCg==
