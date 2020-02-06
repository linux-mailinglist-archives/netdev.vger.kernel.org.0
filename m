Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 683F3153CF0
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 03:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727604AbgBFCXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 21:23:34 -0500
Received: from mx24.baidu.com ([111.206.215.185]:50196 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727307AbgBFCXd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Feb 2020 21:23:33 -0500
Received: from BC-Mail-Ex14.internal.baidu.com (unknown [172.31.51.54])
        by Forcepoint Email with ESMTPS id 65E4E92E5797AFF46279;
        Thu,  6 Feb 2020 10:23:22 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 BC-Mail-Ex14.internal.baidu.com (172.31.51.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1531.3; Thu, 6 Feb 2020 10:23:22 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1713.004; Thu, 6 Feb 2020 10:23:22 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXSBwYWdlX3Bvb2w6IGZpbGwgcGFnZSBvbmx5IHdoZW4g?=
 =?gb2312?Q?refill_condition_is_true?=
Thread-Topic: [PATCH] page_pool: fill page only when refill condition is true
Thread-Index: AQHV3BqC/shoQdrij0SLd8dbH6GYDagNb1mA
Date:   Thu, 6 Feb 2020 02:23:22 +0000
Message-ID: <130d2489bca54b36bda0a8178b8535b4@baidu.com>
References: <1580890954-21322-1-git-send-email-lirongqing@baidu.com>
 <20200205125031.57c1f0d6@carbon>
In-Reply-To: <20200205125031.57c1f0d6@carbon>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.21.0.29]
x-baidu-bdmsfe-datecheck: 1_BC-Mail-Ex14_2020-02-06 10:23:22:391
x-baidu-bdmsfe-viruscheck: BC-Mail-Ex14_GRAY_Inside_WithoutAtta_2020-02-06
 10:23:22:375
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS3Tyrz+1K28/i0tLS0tDQo+ILeivP7IyzogSmVzcGVyIERhbmdhYXJkIEJyb3Vl
ciBbbWFpbHRvOmJyb3VlckByZWRoYXQuY29tXQ0KPiC3osvNyrG85DogMjAyMMTqMtTCNcjVIDE5
OjUxDQo+IMrVvP7IyzogTGksUm9uZ3FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUuY29tPg0KPiCzrcvN
OiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBicm91ZXJAcmVkaGF0LmNvbTsgSWxpYXMgQXBhbG9k
aW1hcw0KPiA8aWxpYXMuYXBhbG9kaW1hc0BsaW5hcm8ub3JnPg0KPiDW98ziOiBSZTogW1BBVENI
XSBwYWdlX3Bvb2w6IGZpbGwgcGFnZSBvbmx5IHdoZW4gcmVmaWxsIGNvbmRpdGlvbiBpcyB0cnVl
DQo+IA0KPiBPbiBXZWQsICA1IEZlYiAyMDIwIDE2OjIyOjM0ICswODAwDQo+IExpIFJvbmdRaW5n
IDxsaXJvbmdxaW5nQGJhaWR1LmNvbT4gd3JvdGU6DQo+IA0KPiA+ICJkbyB7fSB3aGlsZSIgaW4g
cGFnZV9wb29sX3JlZmlsbF9hbGxvY19jYWNoZSB3aWxsIGFsd2F5cyByZWZpbGwgcGFnZQ0KPiA+
IG9uY2Ugd2hldGhlciByZWZpbGwgaXMgdHJ1ZSBvciBmYWxzZSwgYW5kIHdoZXRoZXIgYWxsb2Mu
Y291bnQgb2YgcG9vbA0KPiA+IGlzIGxlc3MgdGhhbiBQUF9BTExPQ19DQUNIRV9SRUZJTEwuDQo+
ID4NCj4gPiBzbyBmaXggaXQgYnkgY2FsbGluZyBwYWdlX3Bvb2xfcmVmaWxsX2FsbG9jX2NhY2hl
KCkgb25seSB3aGVuIHJlZmlsbA0KPiA+IGlzIHRydWUNCj4gPg0KPiA+IEZpeGVzOiA0NDc2OGRl
Y2I3YzAgKCJwYWdlX3Bvb2w6IGhhbmRsZSBwYWdlIHJlY3ljbGUgZm9yIE5VTUFfTk9fTk9ERQ0K
PiA+IGNvbmRpdGlvbiIpDQo+ID4gU2lnbmVkLW9mZi1ieTogTGkgUm9uZ1FpbmcgPGxpcm9uZ3Fp
bmdAYmFpZHUuY29tPg0KPiA+IENjOiBKZXNwZXIgRGFuZ2FhcmQgQnJvdWVyIDxicm91ZXJAcmVk
aGF0LmNvbT4NCj4gDQo+IEhtbW0uLi4gSSdtIG5vdCAxMDAlIGNvbnZpbmNlZCB0aGlzIGlzIHRo
ZSByaWdodCBhcHByb2FjaC4NCj4gDQo+IEkgZG8gcmVhbGl6ZSB0aGF0IGluIGNvbW1pdCA0NDc2
OGRlY2I3YzAsIEkgYWxzbyBhZGRlZCB0b3VjaGluZw0KPiBwb29sLT5hbGxvYy5jYWNoZVtdIHdo
aWNoIHdhcyBwcm90ZWN0ZWQgYnkgImNhbGxlZCB1bmRlciIgaW5fc2VydmluZ19zb2Z0aXJxKCku
DQo+IChiZWZvcmUgSSB1c2VkIGEgbG9ja2VkIHB0cl9yaW5nX2NvbnN1bWUocikpLg0KPiANCj4g
QlVUIG1heWJlIGl0IHdpbGwgYmUgYmV0dGVyIHRvIHJlbW92ZSwgdGhlIHRlc3QgaW5fc2Vydmlu
Z19zb2Z0aXJxKCksIGJlY2F1c2UNCj4gdGhlIGNhbGxlciBzaG91bGQgcHJvdmlkZSBndWFyYW50
ZWUgdGhhdCBwb29sLT5hbGxvYy5jYWNoZVtdIGlzIHNhZmUgdG8gYWNjZXNzLg0KPiANCj4gSSBh
ZGRlZCB0aGlzIGluX3NlcnZpbmdfc29mdGlycSgpIGNoZWNrLCBiZWNhdXNlIEkgbm90aWNlZCBO
SUMgZHJpdmVycyB3aWxsIGNhbGwNCj4gdGhpcyBmcm9tIG5vcm1hbCBwcm9jZXNzIGNvbnRleHQs
IGR1cmluZyAoMSkgaW5pdGlhbCBmaWxsIG9mIHRoZWlyIFJYLXJpbmdzLCBhbmQgKDIpDQo+IGR1
cmluZyBkcml2ZXIgUlgtcmluZyBzaHV0ZG93bi4gIEJVVCBpbiBib3RoIGNhc2VzIHRoZSBOSUMg
ZHJpdmVycyB3aWxsIGZpcnN0DQo+IGhhdmUgbWFkZSBzdXJlIHRoYXQgdGhlaXIgUlgtcmluZyBo
YXZlIGJlZW4gZGlzY29ubmVjdGVkIGFuZCBubyBjb25jdXJyZW50DQo+IGFjY2Vzc2VzIHdpbGwg
aGFwcGVuLiAgVGh1cywgYWNjZXNzIHRvIHBvb2wtPmFsbG9jLmNhY2hlW10gaXMgc2FmZSwgc28N
Cj4gcGFnZV9wb29sIEFQSSBzaG91bGQgdHJ1c3QgdGhlIGNhbGxlciBrbm93cyB0aGlzLg0KPiAN
Cj4gDQoNCkkgdGhpbmsgaXQgaXMgYmV0dGVyIGFuZCBzZW1hbnRpYyBjbGFyaXR5IHRvIGtlZXAg
aW5fc2VydmluZ19zb2Z0aXJxLCBhbmQgd2UgY2FuIHNlZSBvcGluaW9ucyBvZiBvdGhlcnMNCg0K
VGhhbmtzDQoNCi1MaQ0KDQo=
