Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD87B64B2
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 15:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728837AbfIRNfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 09:35:45 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2421 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726562AbfIRNfp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 09:35:45 -0400
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id 543DB72AE6EC9CD72CCF;
        Wed, 18 Sep 2019 21:35:41 +0800 (CST)
Received: from dggeme704-chm.china.huawei.com (10.1.199.100) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 18 Sep 2019 21:35:41 +0800
Received: from dggeme753-chm.china.huawei.com (10.3.19.99) by
 dggeme704-chm.china.huawei.com (10.1.199.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Wed, 18 Sep 2019 21:35:40 +0800
Received: from dggeme753-chm.china.huawei.com ([10.7.64.70]) by
 dggeme753-chm.china.huawei.com ([10.7.64.70]) with mapi id 15.01.1713.004;
 Wed, 18 Sep 2019 21:35:40 +0800
From:   "zhangsha (A)" <zhangsha.zhang@huawei.com>
To:     "jay.vosburgh@canonical.com" <jay.vosburgh@canonical.com>,
        "vfalico@gmail.com" <vfalico@gmail.com>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        yuehaibing <yuehaibing@huawei.com>,
        hunongda <hunongda@huawei.com>,
        "Chenzhendong (alex)" <alex.chen@huawei.com>
Subject: RE: [PATCH v3] bonding: force enable lacp port after link state
 recovery for 802.3ad
Thread-Topic: [PATCH v3] bonding: force enable lacp port after link state
 recovery for 802.3ad
Thread-Index: AQHVbiHhj1lgrT2osES7x4pU2JseVqcxaH3A
Date:   Wed, 18 Sep 2019 13:35:40 +0000
Message-ID: <e333c8d2f3624a898a378eb1073f5f29@huawei.com>
References: <20190918130620.8556-1-zhangsha.zhang@huawei.com>
In-Reply-To: <20190918130620.8556-1-zhangsha.zhang@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.177.220.209]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogemhhbmdzaGEgKEEpDQo+
IFNlbnQ6IDIwMTnE6jnUwjE4yNUgMjE6MDYNCj4gVG86IGpheS52b3NidXJnaEBjYW5vbmljYWwu
Y29tOyB2ZmFsaWNvQGdtYWlsLmNvbTsgYW5keUBncmV5aG91c2UubmV0Ow0KPiBkYXZlbUBkYXZl
bWxvZnQubmV0OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJu
ZWwub3JnOw0KPiB5dWVoYWliaW5nIDx5dWVoYWliaW5nQGh1YXdlaS5jb20+OyBodW5vbmdkYSA8
aHVub25nZGFAaHVhd2VpLmNvbT47DQo+IENoZW56aGVuZG9uZyAoYWxleCkgPGFsZXguY2hlbkBo
dWF3ZWkuY29tPjsgemhhbmdzaGEgKEEpDQo+IDx6aGFuZ3NoYS56aGFuZ0BodWF3ZWkuY29tPg0K
PiBTdWJqZWN0OiBbUEFUQ0ggdjNdIGJvbmRpbmc6IGZvcmNlIGVuYWJsZSBsYWNwIHBvcnQgYWZ0
ZXIgbGluayBzdGF0ZSByZWNvdmVyeSBmb3INCj4gODAyLjNhZA0KPiANCj4gRnJvbTogU2hhIFpo
YW5nIDx6aGFuZ3NoYS56aGFuZ0BodWF3ZWkuY29tPg0KPiANCj4gQWZ0ZXIgdGhlIGNvbW1pdCAz
MzQwMzEyMTlhODQgKCJib25kaW5nLzgwMi4zYWQ6IGZpeCBzbGF2ZSBsaW5rIGluaXRpYWxpemF0
aW9uDQo+IHRyYW5zaXRpb24gc3RhdGVzIikgbWVyZ2VkLCB0aGUgc2xhdmUncyBsaW5rIHN0YXR1
cyB3aWxsIGJlIGNoYW5nZWQgdG8NCj4gQk9ORF9MSU5LX0ZBSUwgZnJvbSBCT05EX0xJTktfRE9X
TiBpbiB0aGUgZm9sbG93aW5nIHNjZW5hcmlvOg0KPiAtIERyaXZlciByZXBvcnRzIGxvc3Mgb2Yg
Y2FycmllciBhbmQNCj4gICBib25kaW5nIGRyaXZlciByZWNlaXZlcyBORVRERVZfRE9XTiBub3Rp
Zmllcg0KPiAtIHNsYXZlJ3MgZHVwbGV4IGFuZCBzcGVlZCBpcyB6ZXJvZCBhbmQNCj4gICBpdHMg
cG9ydC0+aXNfZW5hYmxlZCBpcyBjbGVhcmQgdG8gJ2ZhbHNlJzsNCj4gLSBEcml2ZXIgcmVwb3J0
cyBsaW5rIHJlY292ZXJ5IGFuZA0KPiAgIGJvbmRpbmcgZHJpdmVyIHJlY2VpdmVzIE5FVERFVl9V
UCBub3RpZmllcjsNCj4gLSBJZiBzcGVlZC9kdXBsZXggZ2V0dGluZyBmYWlsZWQgaGVyZSwgdGhl
IGxpbmsgc3RhdHVzDQo+ICAgd2lsbCBiZSBjaGFuZ2VkIHRvIEJPTkRfTElOS19GQUlMOw0KPiAt
IFRoZSBNSUkgbW9ub3RvciBsYXRlciByZWNvdmVyIHRoZSBzbGF2ZSdzIHNwZWVkL2R1cGxleA0K
PiAgIGFuZCBzZXQgbGluayBzdGF0dXMgdG8gQk9ORF9MSU5LX1VQLCBidXQgcmVtYWlucw0KPiAg
IHRoZSAncG9ydC0+aXNfZW5hYmxlZCcgdG8gJ2ZhbHNlJy4NCj4gDQo+IEluIHRoaXMgc2NlbmFy
aW8sIHRoZSBsYWNwIHBvcnQgd2lsbCBub3QgYmUgZW5hYmxlZCBldmVuIGl0cyBzcGVlZCBhbmQg
ZHVwbGV4IGFyZQ0KPiB2YWxpZC4gVGhlIGJvbmQgd2lsbCBub3Qgc2VuZCBMQUNQRFUncywgYW5k
IGl0cyBzdGF0ZSBpcyAnQURfU1RBVEVfREVGQVVMVEVEJw0KPiBmb3JldmVyLiBUaGUgc2ltcGxl
c3QgZml4IEkgdGhpbmsgaXMgdG8gY2FsbCBib25kXzNhZF9oYW5kbGVfbGlua19jaGFuZ2UoKSBp
bg0KPiBib25kX21paW1vbl9jb21taXQsIHRoaXMgZnVuY3Rpb24gY2FuIGVuYWJsZSBsYWNwIGFm
dGVyIHBvcnQgc2xhdmUgc3BlZWQNCj4gY2hlY2suDQo+IEFzIGVuYWJsZWQsIHRoZSBsYWNwIHBv
cnQgY2FuIHJ1biBpdHMgc3RhdGUgbWFjaGluZSBub3JtYWxseSBhZnRlciBsaW5rIHJlY292ZXJ5
Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogU2hhIFpoYW5nIDx6aGFuZ3NoYS56aGFuZ0BodWF3ZWku
Y29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L2JvbmRpbmcvYm9uZF9tYWluLmMgfCAzICsrLQ0K
PiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2JvbmRpbmcvYm9uZF9tYWluLmMNCj4gYi9kcml2ZXJz
L25ldC9ib25kaW5nL2JvbmRfbWFpbi5jIGluZGV4IDkzMWQ5ZDkuLjc2MzI0YTUgMTAwNjQ0DQo+
IC0tLSBhL2RyaXZlcnMvbmV0L2JvbmRpbmcvYm9uZF9tYWluLmMNCj4gKysrIGIvZHJpdmVycy9u
ZXQvYm9uZGluZy9ib25kX21haW4uYw0KPiBAQCAtMjIwNiw3ICsyMjA2LDggQEAgc3RhdGljIHZv
aWQgYm9uZF9taWltb25fY29tbWl0KHN0cnVjdCBib25kaW5nDQo+ICpib25kKQ0KPiAgCQkJICov
DQo+ICAJCQlpZiAoQk9ORF9NT0RFKGJvbmQpID09IEJPTkRfTU9ERV84MDIzQUQgJiYNCj4gIAkJ
CSAgICBzbGF2ZS0+bGluayA9PSBCT05EX0xJTktfVVApDQo+IC0NCj4gCWJvbmRfM2FkX2FkYXB0
ZXJfc3BlZWRfZHVwbGV4X2NoYW5nZWQoc2xhdmUpOw0KPiArCQkJCWJvbmRfM2FkX2hhbmRsZV9s
aW5rX2NoYW5nZShzbGF2ZSwNCj4gKwkJCQkJCQkgICAgQk9ORF9MSU5LX1VQKTsNCj4gIAkJCWNv
bnRpbnVlOw0KPiANCj4gIAkJY2FzZSBCT05EX0xJTktfVVA6DQoNCkhpLCBEYXZpZCwNCkkgaGF2
ZSByZXBsaWVkIHlvdXIgZW1haWwgZm9yIGEgd2hpbGUsICBJIGd1ZXNzIHlvdSBtYXkgbWlzcyBt
eSBlbWFpbCwgc28gSSByZXNlbmQgaXQuDQpUaGUgZm9sbG93aW5nIGxpbmsgYWRkcmVzcyBpcyB0
aGUgbGFzdCBlbWFpbCwgcGxlYXNlIHJldmlldyB0aGUgbmV3IG9uZSBhZ2FpbiwgdGhhbmsgeW91
Lg0KaHR0cHM6Ly9wYXRjaHdvcmsub3psYWJzLm9yZy9wYXRjaC8xMTUxOTE1Lw0KDQpMYXN0IHRp
bWUsIHlvdSBkb3VidGVkIHRoaXMgaXMgYSBkcml2ZXIgc3BlY2lmaWMgcHJvYmxlbSwNCkkgcHJl
ZmVyIHRvIGJlbGlldmUgaXQncyBub3QgYmVjYXVzZSBJIGZpbmQgdGhlIGNvbW1pdCA0ZDJjMGNk
YSwNCml0cyBsb2cgc2F5cyAiIFNvbWUgTklDIGRyaXZlcnMgZG9uJ3QgaGF2ZSBjb3JyZWN0IHNw
ZWVkL2R1cGxleCANCnNldHRpbmdzIGF0IHRoZSB0aW1lIHRoZXkgc2VuZCBORVRERVZfVVAgbm90
aWZpY2F0aW9uIC4uLiIuDQoNCkFueXdheSwgSSB0aGluayB0aGUgbGFjcCBzdGF0dXMgc2hvdWxk
IGJlIGZpeGVkIGNvcnJlY3RseSwNCnNpbmNlIGxpbmstbW9uaXRvcmluZyAobWlpbW9uKSBzZXQg
U1BFRUQvRFVQTEVYIHJpZ2h0IGhlcmUuDQoNCj4gLS0NCj4gMS44LjMuMQ0KDQoNCg==
