Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7133123F7A7
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 14:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgHHMuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 08:50:25 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:51121 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726198AbgHHMuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Aug 2020 08:50:22 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-156-ZHfazWqmM5WHZGeQnmlm0A-1; Sat, 08 Aug 2020 13:50:16 +0100
X-MC-Unique: ZHfazWqmM5WHZGeQnmlm0A-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Sat, 8 Aug 2020 13:50:15 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Sat, 8 Aug 2020 13:50:15 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'luobin (L)'" <luobin9@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "luoxianjun@huawei.com" <luoxianjun@huawei.com>,
        "yin.yinshi@huawei.com" <yin.yinshi@huawei.com>,
        "cloud.wangxiaoyun@huawei.com" <cloud.wangxiaoyun@huawei.com>,
        "chiqijun@huawei.com" <chiqijun@huawei.com>
Subject: RE: [PATCH net-next v1] hinic: fix strncpy output truncated compile
 warnings
Thread-Topic: [PATCH net-next v1] hinic: fix strncpy output truncated compile
 warnings
Thread-Index: AQHWbF+/LM1G8mFmIkykQEWb0Xuu7aksYh5wgAEeogCAAKsWsA==
Date:   Sat, 8 Aug 2020 12:50:15 +0000
Message-ID: <89ee89b8c4a54a848aa57a31c5f5c81a@AcuMS.aculab.com>
References: <20200807020914.3123-1-luobin9@huawei.com>
 <e7a4fcf12a4e4d179e2fae8ffb44f992@AcuMS.aculab.com>
 <b886a6ff-8ed8-c857-f190-e99f8f735e02@huawei.com>
In-Reply-To: <b886a6ff-8ed8-c857-f190-e99f8f735e02@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogbHVvYmluIChMKQ0KPiBTZW50OiAwOCBBdWd1c3QgMjAyMCAwNDozNw0KPiANCj4gT24g
MjAyMC84LzcgMTc6MzIsIERhdmlkIExhaWdodCB3cm90ZToNCj4gPiBGcm9tOiBMdW8gYmluDQo+
ID4+IFNlbnQ6IDA3IEF1Z3VzdCAyMDIwIDAzOjA5DQo+ID4+DQo+ID4+IGZpeCB0aGUgY29tcGls
ZSB3YXJuaW5ncyBvZiAnc3RybmNweScgb3V0cHV0IHRydW5jYXRlZCBiZWZvcmUNCj4gPj4gdGVy
bWluYXRpbmcgbnVsIGNvcHlpbmcgTiBieXRlcyBmcm9tIGEgc3RyaW5nIG9mIHRoZSBzYW1lIGxl
bmd0aA0KPiA+Pg0KPiA+PiBTaWduZWQtb2ZmLWJ5OiBMdW8gYmluIDxsdW9iaW45QGh1YXdlaS5j
b20+DQo+ID4+IFJlcG9ydGVkLWJ5OiBrZXJuZWwgdGVzdCByb2JvdCA8bGtwQGludGVsLmNvbT4N
Cj4gPj4gLS0tDQo+ID4+IFYwflYxOg0KPiA+PiAtIHVzZSB0aGUgc3RybGVuKCkrMSBwYXR0ZXJu
IGNvbnNpc3RlbnRseQ0KPiA+Pg0KPiA+PiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaHVhd2VpL2hp
bmljL2hpbmljX2RldmxpbmsuYyB8IDggKysrKy0tLS0NCj4gPj4gIDEgZmlsZSBjaGFuZ2VkLCA0
IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQo+ID4+DQo+ID4+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9odWF3ZWkvaGluaWMvaGluaWNfZGV2bGluay5jDQo+ID4+IGIv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvaHVhd2VpL2hpbmljL2hpbmljX2RldmxpbmsuYw0KPiA+PiBp
bmRleCBjNmFkYzc3NmYzYzguLjFlYzg4ZWJmODFkNiAxMDA2NDQNCj4gPj4gLS0tIGEvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvaHVhd2VpL2hpbmljL2hpbmljX2RldmxpbmsuYw0KPiA+PiArKysgYi9k
cml2ZXJzL25ldC9ldGhlcm5ldC9odWF3ZWkvaGluaWMvaGluaWNfZGV2bGluay5jDQo+ID4+IEBA
IC0zNDIsOSArMzQyLDkgQEAgc3RhdGljIGludCBjaGlwX2ZhdWx0X3Nob3coc3RydWN0IGRldmxp
bmtfZm1zZyAqZm1zZywNCj4gPj4NCj4gPj4gIAlsZXZlbCA9IGV2ZW50LT5ldmVudC5jaGlwLmVy
cl9sZXZlbDsNCj4gPj4gIAlpZiAobGV2ZWwgPCBGQVVMVF9MRVZFTF9NQVgpDQo+ID4+IC0JCXN0
cm5jcHkobGV2ZWxfc3RyLCBmYXVsdF9sZXZlbFtsZXZlbF0sIHN0cmxlbihmYXVsdF9sZXZlbFts
ZXZlbF0pKTsNCj4gPj4gKwkJc3RybmNweShsZXZlbF9zdHIsIGZhdWx0X2xldmVsW2xldmVsXSwg
c3RybGVuKGZhdWx0X2xldmVsW2xldmVsXSkgKyAxKTsNCj4gPg0KPiA+IEhhdmUgeW91IGV2ZW4g
Y29uc2lkZXJlZCB3aGF0IHRoYXQgY29kZSBpcyBhY3R1YWxseSBkb2luZz8NCj4gPg0KPiA+IAlE
YXZpZA0KPg0KPiBJJ20gc29ycnkgdGhhdCBJIGhhdmVuJ3QgZ290IHdoYXQgeW91IG1lYW4gYW5k
IEkgaGF2ZW4ndCBmb3VuZCBhbnkgZGVmZWN0cyBpbiB0aGF0IGNvZGUuIENhbiB5b3UNCj4gZXhw
bGFpbiBtb3JlIHRvIG1lPw0KDQpJZiB5b3UgY2FuJ3Qgc2VlIGl0IHlvdSBwcm9iYWJseSBzaG91
bGRuJ3QgYmUgc3VibWl0dGluZyBwYXRjaGVzLi4uLg0KDQpDb25zaWRlciB3aGF0IGhhcHBlbnMg
d2hlbiB0aGUgc3RyaW5nIGlzIGxvbmcuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJl
c3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsx
IDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

