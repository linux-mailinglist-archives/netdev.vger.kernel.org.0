Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 422B35B8CA
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 12:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbfGAKOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 06:14:06 -0400
Received: from mx22.baidu.com ([220.181.50.185]:41442 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727707AbfGAKOG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 06:14:06 -0400
X-Greylist: delayed 2801 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Jul 2019 06:14:04 EDT
Received: from BC-Mail-Ex09.internal.baidu.com (unknown [172.31.40.19])
        by Forcepoint Email with ESMTPS id 87DDB8F0A2B90;
        Mon,  1 Jul 2019 17:27:19 +0800 (CST)
Received: from BC-Bak-Ex15.internal.baidu.com (172.31.51.48) by
 BC-Mail-Ex09.internal.baidu.com (172.31.40.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1531.3; Mon, 1 Jul 2019 17:27:20 +0800
Received: from BC-Bak-Ex13.internal.baidu.com (172.31.51.46) by
 BC-Bak-Ex15.internal.baidu.com (172.31.51.48) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Mon, 1 Jul 2019 17:27:20 +0800
Received: from BC-Bak-Ex13.internal.baidu.com ([172.31.51.46]) by
 BC-Bak-Ex13.internal.baidu.com ([172.31.51.46]) with mapi id 15.01.1591.016;
 Mon, 1 Jul 2019 17:27:20 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Florian Westphal <fw@strlen.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXSB4ZnJtOiB1c2UgbGlzdF9mb3JfZWFjaF9lbnRyeV9z?=
 =?gb2312?B?YWZlIGluIHhmcm1fcG9saWN5X2ZsdXNo?=
Thread-Topic: [PATCH] xfrm: use list_for_each_entry_safe in xfrm_policy_flush
Thread-Index: AQHVL+vpIpFTefhRnEG/M1pEJJk8AKa1fZVQ
Date:   Mon, 1 Jul 2019 09:27:20 +0000
Message-ID: <b0b31ecbc1c54f3580df8a519c85eeab@baidu.com>
References: <1561969747-8629-1-git-send-email-lirongqing@baidu.com>
 <20190701090345.fkd7lrecicrewpnt@breakpoint.cc>
In-Reply-To: <20190701090345.fkd7lrecicrewpnt@breakpoint.cc>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.202.10]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Baidu-BdMsfe-DateCheck: 1_BC-Mail-Ex09_2019-07-01 17:27:21:014
X-Baidu-BdMsfe-VirusCheck: BC-Mail-Ex09_GRAY_Inside_WithoutAtta_2019-07-01
 17:27:21:045
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS3Tyrz+1K28/i0tLS0tDQo+ILeivP7IyzogRmxvcmlhbiBXZXN0cGhhbCBbbWFp
bHRvOmZ3QHN0cmxlbi5kZV0NCj4gt6LLzcqxvOQ6IDIwMTnE6jfUwjHI1SAxNzowNA0KPiDK1bz+
yMs6IExpLFJvbmdxaW5nIDxsaXJvbmdxaW5nQGJhaWR1LmNvbT4NCj4gs63LzTogbmV0ZGV2QHZn
ZXIua2VybmVsLm9yZw0KPiDW98ziOiBSZTogW1BBVENIXSB4ZnJtOiB1c2UgbGlzdF9mb3JfZWFj
aF9lbnRyeV9zYWZlIGluIHhmcm1fcG9saWN5X2ZsdXNoDQo+IA0KPiBMaSBSb25nUWluZyA8bGly
b25ncWluZ0BiYWlkdS5jb20+IHdyb3RlOg0KPiA+IFRoZSBpdGVyYXRlZCBwb2wgbWF5YmUgYmUg
ZnJlZWQgc2luY2UgaXQgaXMgbm90IHByb3RlY3RlZCBieSBSQ1Ugb3INCj4gPiBzcGlubG9jayB3
aGVuIHB1dCBpdCwgbGVhZCB0byBVQUYsIHNvIHVzZSBfc2FmZSBmdW5jdGlvbiB0byBpdGVyYXRl
DQo+ID4gb3ZlciBpdCBhZ2FpbnN0IHJlbW92YWwNCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IExp
IFJvbmdRaW5nIDxsaXJvbmdxaW5nQGJhaWR1LmNvbT4NCj4gPiAtLS0NCj4gPiAgbmV0L3hmcm0v
eGZybV9wb2xpY3kuYyB8IDQgKystLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25z
KCspLCAyIGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL25ldC94ZnJtL3hmcm1f
cG9saWN5LmMgYi9uZXQveGZybS94ZnJtX3BvbGljeS5jIGluZGV4DQo+ID4gMzIzNTU2MmY2NTg4
Li44N2Q3NzBkYWIxZjUgMTAwNjQ0DQo+ID4gLS0tIGEvbmV0L3hmcm0veGZybV9wb2xpY3kuYw0K
PiA+ICsrKyBiL25ldC94ZnJtL3hmcm1fcG9saWN5LmMNCj4gPiBAQCAtMTc3Miw3ICsxNzcyLDcg
QEAgeGZybV9wb2xpY3lfZmx1c2hfc2VjY3R4X2NoZWNrKHN0cnVjdCBuZXQgKm5ldCwNCj4gPiB1
OCB0eXBlLCBib29sIHRhc2tfdmFsaWQpICBpbnQgeGZybV9wb2xpY3lfZmx1c2goc3RydWN0IG5l
dCAqbmV0LCB1OA0KPiA+IHR5cGUsIGJvb2wgdGFza192YWxpZCkgIHsNCj4gPiAgCWludCBkaXIs
IGVyciA9IDAsIGNudCA9IDA7DQo+ID4gLQlzdHJ1Y3QgeGZybV9wb2xpY3kgKnBvbDsNCj4gPiAr
CXN0cnVjdCB4ZnJtX3BvbGljeSAqcG9sLCAqdG1wOw0KPiA+DQo+ID4gIAlzcGluX2xvY2tfYmgo
Jm5ldC0+eGZybS54ZnJtX3BvbGljeV9sb2NrKTsNCj4gPg0KPiA+IEBAIC0xNzgxLDcgKzE3ODEs
NyBAQCBpbnQgeGZybV9wb2xpY3lfZmx1c2goc3RydWN0IG5ldCAqbmV0LCB1OCB0eXBlLCBib29s
DQo+IHRhc2tfdmFsaWQpDQo+ID4gIAkJZ290byBvdXQ7DQo+ID4NCj4gPiAgYWdhaW46DQo+ID4g
LQlsaXN0X2Zvcl9lYWNoX2VudHJ5KHBvbCwgJm5ldC0+eGZybS5wb2xpY3lfYWxsLCB3YWxrLmFs
bCkgew0KPiA+ICsJbGlzdF9mb3JfZWFjaF9lbnRyeV9zYWZlKHBvbCwgdG1wLCAmbmV0LT54ZnJt
LnBvbGljeV9hbGwsIHdhbGsuYWxsKQ0KPiA+ICt7DQo+ID4gIAkJZGlyID0geGZybV9wb2xpY3lf
aWQyZGlyKHBvbC0+aW5kZXgpOw0KPiA+ICAJCWlmIChwb2wtPndhbGsuZGVhZCB8fA0KPiA+ICAJ
CSAgICBkaXIgPj0gWEZSTV9QT0xJQ1lfTUFYIHx8DQo+IA0KPiBUaGlzIGZ1bmN0aW9uIGRyb3Bz
IHRoZSBsb2NrLCBidXQgYWZ0ZXIgcmUtYWNxdWlyZSBqdW1wcyB0byB0aGUgJ2FnYWluJw0KPiBs
YWJlbCwgc28gSSBkbyBub3Qgc2VlIHRoZSBVQUYgYXMgdGhlIGVudGlyZSBsb29wIGdldHMgcmVz
dGFydGVkLg0KDQpZb3UgYXJlIHJpZ2h0LCBzb3JyeSBmb3IgdGhlIG5vaXNlDQoNCi1MaQ0K
