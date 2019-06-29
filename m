Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B93265A84A
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 04:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfF2CNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 22:13:11 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2959 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726682AbfF2CNL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 22:13:11 -0400
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id 009771E16AABD9844CA4;
        Sat, 29 Jun 2019 10:13:07 +0800 (CST)
Received: from dggeme714-chm.china.huawei.com (10.1.199.110) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 29 Jun 2019 10:13:06 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme714-chm.china.huawei.com (10.1.199.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Sat, 29 Jun 2019 10:13:06 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1591.008;
 Sat, 29 Jun 2019 10:13:06 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     David Ahern <dsahern@gmail.com>
CC:     "pablo@netfilter.org" <pablo@netfilter.org>,
        "kadlec@blackhole.kfki.hu" <kadlec@blackhole.kfki.hu>,
        "fw@strlen.de" <fw@strlen.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mingfangsen <mingfangsen@huawei.com>
Subject: Re: [PATCH v4] net: netfilter: Fix rpfilter dropping vrf packets by
 mistake
Thread-Topic: [PATCH v4] net: netfilter: Fix rpfilter dropping vrf packets by
 mistake
Thread-Index: AdUuGy8DDB3uB4ksWUWckzFOhXp+DA==
Date:   Sat, 29 Jun 2019 02:13:06 +0000
Message-ID: <2213b3e722a14ee48768ecc7118efc46@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.189.20]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNi8yOS8xOSAxOjA1IEFNLCBEYXZpZCBBaGVybiB3cm90ZToNCj4gT24gNi8yOC8xOSAzOjA2
IEFNLCBNaWFvaGUgTGluIHdyb3RlOg0KPiA+IGRpZmYgLS1naXQgYS9uZXQvaXB2Ni9uZXRmaWx0
ZXIvaXA2dF9ycGZpbHRlci5jIA0KPiA+IGIvbmV0L2lwdjYvbmV0ZmlsdGVyL2lwNnRfcnBmaWx0
ZXIuYw0KPiA+IGluZGV4IDZiY2FmNzM1NzE4My4uM2M0YTE3NzJjMTVmIDEwMDY0NA0KPiA+IC0t
LSBhL25ldC9pcHY2L25ldGZpbHRlci9pcDZ0X3JwZmlsdGVyLmMNCj4gPiArKysgYi9uZXQvaXB2
Ni9uZXRmaWx0ZXIvaXA2dF9ycGZpbHRlci5jDQo+ID4gQEAgLTU1LDYgKzU1LDEwIEBAIHN0YXRp
YyBib29sIHJwZmlsdGVyX2xvb2t1cF9yZXZlcnNlNihzdHJ1Y3QgbmV0ICpuZXQsIGNvbnN0IHN0
cnVjdCBza19idWZmICpza2IsDQo+ID4gIAlpZiAocnBmaWx0ZXJfYWRkcl9saW5rbG9jYWwoJmlw
aC0+c2FkZHIpKSB7DQo+ID4gIAkJbG9va3VwX2ZsYWdzIHw9IFJUNl9MT09LVVBfRl9JRkFDRTsN
Cj4gPiAgCQlmbDYuZmxvd2k2X29pZiA9IGRldi0+aWZpbmRleDsNCj4gPiArCS8qIFNldCBmbG93
aTZfb2lmIGZvciB2cmYgZGV2aWNlcyB0byBsb29rdXAgcm91dGUgaW4gbDNtZGV2IGRvbWFpbi4g
Ki8NCj4gPiArCX0gZWxzZSBpZiAobmV0aWZfaXNfbDNfbWFzdGVyKGRldikgfHwgbmV0aWZfaXNf
bDNfc2xhdmUoZGV2KSkgew0KPiA+ICsJCWxvb2t1cF9mbGFncyB8PSBGTE9XSV9GTEFHX1NLSVBf
TkhfT0lGOw0KPg0KPiB5b3UgZG9uJ3QgbmVlZCB0byBzZXQgdGhhdCBmbGFnIGhlcmUuIEl0IGlz
IGRvbmUgYnkgdGhlIGZpYl9ydWxlcyBjb2RlIGFzIG5lZWRlZC4NCj4NCllvdSdyZSByaWdodC4g
RmliIHJ1bGVzIGNvZGUgd291bGQgc2V0IEZMT1dJX0ZMQUdfU0tJUF9OSF9PSUYgZmxhZy4gIEJ1
dCBJIHNldA0KaXQgaGVyZSBmb3IgZGlzdGluZ3Vpc2ggd2l0aCB0aGUgZmxhZ3MgJiBYVF9SUEZJ
TFRFUl9MT09TRSBicmFuY2guIFdpdGhvdXQNCnRoaXMsIHRoZXkgZG8gdGhlIHNhbWUgd29yayBh
bmQgbWF5YmUgc2hvdWxkIGJlICBjb21iaW5lZC4gSSBkb24ndCB3YW50IHRvDQpkbyB0aGF0IGFz
IHRoYXQgbWFrZXMgY29kZSBjb25mdXNpbmcuDQpJcyB0aGlzIGNvZGUgc25pcGV0IGJlbG93IG9r
ID8gSWYgc28sIEkgd291bGQgZGVsZXRlIHRoaXMgZmxhZyBzZXR0aW5nLg0KIA0KICAgICAgIH0g
ZWxzZSBpZiAobmV0aWZfaXNfbDNfbWFzdGVyKGRldikgfHwgbmV0aWZfaXNfbDNfc2xhdmUoZGV2
KSkgew0KICAgICAgICAgICAgICAgZmw2LmZsb3dpNl9vaWYgPSBkZXYtPmlmaW5kZXg7DQogICAg
ICAgIH0gZWxzZSBpZiAoKGZsYWdzICYgWFRfUlBGSUxURVJfTE9PU0UpID09IDApDQogICAgICAg
ICAgICAgICAgZmw2LmZsb3dpNl9vaWYgPSBkZXYtPmlmaW5kZXg7DQo=
