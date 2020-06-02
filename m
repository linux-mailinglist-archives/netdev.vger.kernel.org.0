Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F25C1EBB9F
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 14:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbgFBM0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 08:26:30 -0400
Received: from mx20.baidu.com ([111.202.115.85]:46736 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726636AbgFBM0a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 08:26:30 -0400
X-Greylist: delayed 967 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Jun 2020 08:26:27 EDT
Received: from BC-Mail-Ex30.internal.baidu.com (unknown [172.31.51.24])
        by Forcepoint Email with ESMTPS id 6E037A58FCA89FDDD2C4;
        Tue,  2 Jun 2020 20:10:18 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 BC-Mail-Ex30.internal.baidu.com (172.31.51.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1979.3; Tue, 2 Jun 2020 20:10:18 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1713.004; Tue, 2 Jun 2020 20:10:18 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Netdev <netdev@vger.kernel.org>
CC:     bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIGk0MGU6IGZpeCB3cm9uZyBpbmRleCBpbiBpNDBl?=
 =?utf-8?B?X3hza191bWVtX2RtYV9tYXA=?=
Thread-Topic: [PATCH] i40e: fix wrong index in i40e_xsk_umem_dma_map
Thread-Index: AQHWONDBAVHG9ypJN0SpezjEH297HKjFO9eQ
Date:   Tue, 2 Jun 2020 12:10:18 +0000
Message-ID: <562a0ea8fe694d5c82dba6f446d1b518@baidu.com>
References: <1591089148-959-1-git-send-email-lirongqing@baidu.com>
 <CAJ+HfNjXh882Dc2N9qpYDGhEuTed9Vp36RuHSXnBMmWXfV9iHg@mail.gmail.com>
In-Reply-To: <CAJ+HfNjXh882Dc2N9qpYDGhEuTed9Vp36RuHSXnBMmWXfV9iHg@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.198.7]
x-baidu-bdmsfe-datecheck: 1_BC-Mail-Ex30_2020-06-02 20:10:18:298
x-baidu-bdmsfe-viruscheck: BC-Mail-Ex30_GRAY_Inside_WithoutAtta_2020-06-02
 20:10:18:298
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0KPiDlj5Hku7bkuro6IEJqw7ZybiBUw7ZwZWwg
W21haWx0bzpiam9ybi50b3BlbEBnbWFpbC5jb21dDQo+IOWPkemAgeaXtumXtDogMjAyMOW5tDbm
nIgy5pelIDE5OjI3DQo+IOaUtuS7tuS6ujogTGksUm9uZ3FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUu
Y29tPjsgaW50ZWwtd2lyZWQtbGFuDQo+IDxpbnRlbC13aXJlZC1sYW5AbGlzdHMub3N1b3NsLm9y
Zz47IE5ldGRldiA8bmV0ZGV2QHZnZXIua2VybmVsLm9yZz4NCj4g5oqE6YCBOiBicGYgPGJwZkB2
Z2VyLmtlcm5lbC5vcmc+OyBLYXJsc3NvbiwgTWFnbnVzDQo+IDxtYWdudXMua2FybHNzb25AaW50
ZWwuY29tPg0KPiDkuLvpopg6IFJlOiBbUEFUQ0hdIGk0MGU6IGZpeCB3cm9uZyBpbmRleCBpbiBp
NDBlX3hza191bWVtX2RtYV9tYXANCj4gDQo+IE9uIFR1ZSwgMiBKdW4gMjAyMCBhdCAxMToyMCwg
TGkgUm9uZ1FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUuY29tPiB3cm90ZToNCj4gPg0KPiANCj4gTGks
IHRoYW5rcyBmb3IgdGhlIHBhdGNoISBHb29kIGNhdGNoIQ0KPiANCj4gUGxlYXNlIGFkZCBhIHBy
b3BlciBkZXNjcmlwdGlvbiBmb3IgdGhlIHBhdGNoLiBUaGUgZml4IHNob3VsZCBiZSBhZGRlZCB0
byB0aGUNCj4gc3RhYmxlIGJyYW5jaGVzICg1LjcgYW5kIGVhcmxpZXIpLiBOb3RlIHRoYXQgdGhp
cyBjb2RlIHdhcyByZWNlbnRseSByZW1vdmVkIGluDQo+IGZhdm9yIG9mIHRoZSBuZXcgQUZfWERQ
IGJ1ZmZlciBhbGxvY2F0aW9uIHNjaGVtZS4NCj4gDQo+IA0KDQpPaw0KDQotTGlSb25nUWluZyAN
Cg0KPiBCasO2cm4NCj4gDQo+ID4gRml4ZXM6IDBhNzE0MTg2ZDNjMCAiKGk0MGU6IGFkZCBBRl9Y
RFAgemVyby1jb3B5IFJ4IHN1cHBvcnQpIg0KPiA+IFNpZ25lZC1vZmYtYnk6IExpIFJvbmdRaW5n
IDxsaXJvbmdxaW5nQGJhaWR1LmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJu
ZXQvaW50ZWwvaTQwZS9pNDBlX3hzay5jIHwgNCArKy0tDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAy
IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaTQwZS9pNDBlX3hzay5jDQo+ID4gYi9kcml2ZXJzL25l
dC9ldGhlcm5ldC9pbnRlbC9pNDBlL2k0MGVfeHNrLmMNCj4gPiBpbmRleCAwYjdkMjkxOTJiMmMu
LmM5MjY0MzgxMThlYSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRl
bC9pNDBlL2k0MGVfeHNrLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9p
NDBlL2k0MGVfeHNrLmMNCj4gPiBAQCAtMzcsOSArMzcsOSBAQCBzdGF0aWMgaW50IGk0MGVfeHNr
X3VtZW1fZG1hX21hcChzdHJ1Y3QgaTQwZV92c2kNCj4gPiAqdnNpLCBzdHJ1Y3QgeGRwX3VtZW0g
KnVtZW0pDQo+ID4NCj4gPiAgb3V0X3VubWFwOg0KPiA+ICAgICAgICAgZm9yIChqID0gMDsgaiA8
IGk7IGorKykgew0KPiA+IC0gICAgICAgICAgICAgICBkbWFfdW5tYXBfcGFnZV9hdHRycyhkZXYs
IHVtZW0tPnBhZ2VzW2ldLmRtYSwNCj4gUEFHRV9TSVpFLA0KPiA+ICsgICAgICAgICAgICAgICBk
bWFfdW5tYXBfcGFnZV9hdHRycyhkZXYsIHVtZW0tPnBhZ2VzW2pdLmRtYSwNCj4gPiArIFBBR0Vf
U0laRSwNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgRE1BX0JJRElS
RUNUSU9OQUwsDQo+IEk0MEVfUlhfRE1BX0FUVFIpOw0KPiA+IC0gICAgICAgICAgICAgICB1bWVt
LT5wYWdlc1tpXS5kbWEgPSAwOw0KPiA+ICsgICAgICAgICAgICAgICB1bWVtLT5wYWdlc1tqXS5k
bWEgPSAwOw0KPiA+ICAgICAgICAgfQ0KPiA+DQo+ID4gICAgICAgICByZXR1cm4gLTE7DQo+ID4g
LS0NCj4gPiAyLjE2LjINCj4gPg0K
