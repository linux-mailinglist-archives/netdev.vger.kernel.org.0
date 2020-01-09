Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82FCF1356CD
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 11:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730102AbgAIKYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 05:24:20 -0500
Received: from mx24.baidu.com ([111.206.215.185]:48422 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728770AbgAIKYU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 05:24:20 -0500
Received: from BC-Mail-Ex14.internal.baidu.com (unknown [172.31.51.54])
        by Forcepoint Email with ESMTPS id 8747FB60B5079E3797D2;
        Thu,  9 Jan 2020 18:24:16 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 BC-Mail-Ex14.internal.baidu.com (172.31.51.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1531.3; Thu, 9 Jan 2020 18:24:16 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1713.004; Thu, 9 Jan 2020 18:24:15 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdW2JwZi1uZXh0XSBicGY6IHJldHVybiBFT1BOT1RT?=
 =?utf-8?B?VVBQIHdoZW4gaW52YWxpZCBtYXAgdHlwZSBpbiBfX2JwZl90eF94ZHBfbWFw?=
Thread-Topic: [PATCH][bpf-next] bpf: return EOPNOTSUPP when invalid map type
 in __bpf_tx_xdp_map
Thread-Index: AQHVxkeQgEkOVjljp0O7vuYzoFX93afiITqQ
Date:   Thu, 9 Jan 2020 10:24:15 +0000
Message-ID: <7010fba902ac4720bedb641516880c65@baidu.com>
References: <1578032749-18197-1-git-send-email-lirongqing@baidu.com>
 <5185e163-2c63-34bf-f521-5d643c95c0e6@iogearbox.net>
In-Reply-To: <5185e163-2c63-34bf-f521-5d643c95c0e6@iogearbox.net>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.197.249]
x-baidu-bdmsfe-datecheck: 1_BC-Mail-Ex14_2020-01-09 18:24:16:469
x-baidu-bdmsfe-viruscheck: BC-Mail-Ex14_GRAY_Inside_WithoutAtta_2020-01-09
 18:24:16:454
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0KPiDlj5Hku7bkuro6IERhbmllbCBCb3JrbWFu
biBbbWFpbHRvOmRhbmllbEBpb2dlYXJib3gubmV0XQ0KPiDlj5HpgIHml7bpl7Q6IDIwMjDlubQx
5pyIOeaXpSAxOjE4DQo+IOaUtuS7tuS6ujogTGksUm9uZ3FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUu
Y29tPg0KPiDmioTpgIE6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGJwZkB2Z2VyLmtlcm5lbC5v
cmc7IGJyb3VlckByZWRoYXQuY29tDQo+IOS4u+mimDogUmU6IFtQQVRDSF1bYnBmLW5leHRdIGJw
ZjogcmV0dXJuIEVPUE5PVFNVUFAgd2hlbiBpbnZhbGlkIG1hcCB0eXBlIGluDQo+IF9fYnBmX3R4
X3hkcF9tYXANCj4gDQo+IE9uIDEvMy8yMCA3OjI1IEFNLCBMaSBSb25nUWluZyB3cm90ZToNCj4g
PiBhIG5lZ2F0aXZlIHZhbHVlIC1FT1BOT1RTVVBQIHNob3VsZCBiZSByZXR1cm5lZCBpZiBtYXAt
Pm1hcF90eXBlIGlzDQo+ID4gaW52YWxpZCBhbHRob3VnaCB0aGF0IHNlZW1zIHVubGlrZWx5IG5v
dywgdGhlbiB0aGUgY2FsbGVyIHdpbGwNCj4gPiBjb250aW51ZSB0byBoYW5kbGUgYnVmZmVyLCBv
ciBlbHNlIHRoZSBidWZmZXIgd2lsbCBiZSBsZWFrZWQNCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6
IExpIFJvbmdRaW5nIDxsaXJvbmdxaW5nQGJhaWR1LmNvbT4NCj4gPiAtLS0NCj4gPiAgIG5ldC9j
b3JlL2ZpbHRlci5jIHwgMiArLQ0KPiA+ICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCsp
LCAxIGRlbGV0aW9uKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvbmV0L2NvcmUvZmlsdGVyLmMg
Yi9uZXQvY29yZS9maWx0ZXIuYyBpbmRleA0KPiA+IDFjYmFjMzRhNGUxMS4uNDBmYTU5MDUzMjFj
IDEwMDY0NA0KPiA+IC0tLSBhL25ldC9jb3JlL2ZpbHRlci5jDQo+ID4gKysrIGIvbmV0L2NvcmUv
ZmlsdGVyLmMNCj4gPiBAQCAtMzUxMiw3ICszNTEyLDcgQEAgc3RhdGljIGludCBfX2JwZl90eF94
ZHBfbWFwKHN0cnVjdCBuZXRfZGV2aWNlDQo+ICpkZXZfcngsIHZvaWQgKmZ3ZCwNCj4gPiAgIAlj
YXNlIEJQRl9NQVBfVFlQRV9YU0tNQVA6DQo+ID4gICAJCXJldHVybiBfX3hza19tYXBfcmVkaXJl
Y3QoZndkLCB4ZHApOw0KPiA+ICAgCWRlZmF1bHQ6DQo+ID4gLQkJYnJlYWs7DQo+ID4gKwkJcmV0
dXJuIC1FT1BOT1RTVVBQOw0KPiANCj4gU28gaW4gY2FzZSBvZiBnZW5lcmljIFhEUCB3ZSByZXR1
cm4gd2l0aCAtRUJBRFJRQyBpbg0KPiB4ZHBfZG9fZ2VuZXJpY19yZWRpcmVjdF9tYXAoKS4NCj4g
SSB3b3VsZCBzdWdnZXN0IHdlIGFkYXB0IHRoZSBzYW1lIGVycm9yIGNvZGUgaGVyZSBhcyB3ZWxs
LCBzbyBpdCdzIGNvbnNpc3RlbnQNCj4gZm9yIHRoZSB0cmFjZXBvaW50IG91dHB1dCBhbmQgbm90
IHRvIGJlIGNvbmZ1c2VkIHdpdGggLUVPUE5PVFNVUFAgZnJvbSBvdGhlcg0KPiBsb2NhdGlvbnMg
bGlrZSBkZXZfbWFwX2VucXVldWUoKSB3aGVuIG5kb194ZHBfeG1pdCBpcyBtaXNzaW5nIG9yIHN1
Y2guDQoNCk9rLCBJIHdpbGwgc2VuZCB2Mg0KDQpUaGFua3MNCg0KLUxpDQoNCg0KPiANCj4gPiAg
IAl9DQo+ID4gICAJcmV0dXJuIDA7DQo+ID4gICB9DQo+ID4NCg0K
