Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 472413FF930
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 06:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhICEBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 00:01:06 -0400
Received: from mx21.baidu.com ([220.181.3.85]:40898 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229481AbhICEBG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Sep 2021 00:01:06 -0400
Received: from BJHW-Mail-Ex15.internal.baidu.com (unknown [10.127.64.38])
        by Forcepoint Email with ESMTPS id 16D55AFC0E4098A45303;
        Fri,  3 Sep 2021 12:00:05 +0800 (CST)
Received: from BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) by
 BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Fri, 3 Sep 2021 12:00:04 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) by
 BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) with mapi id
 15.01.2308.014; Fri, 3 Sep 2021 12:00:04 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: =?utf-8?B?562U5aSNOiDnrZTlpI06IFtQQVRDSF0gdmlydGlvX25ldDogcmVkdWNlIHJh?=
 =?utf-8?B?d19zbXBfcHJvY2Vzc29yX2lkKCkgY2FsbGluZyBpbiB2aXJ0bmV0X3hkcF9n?=
 =?utf-8?Q?et=5Fsq?=
Thread-Topic: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIHZpcnRpb19uZXQ6IHJlZHVjZSByYXdfc21wX3By?=
 =?utf-8?B?b2Nlc3Nvcl9pZCgpIGNhbGxpbmcgaW4gdmlydG5ldF94ZHBfZ2V0X3Nx?=
Thread-Index: AQHXneNzpWGI4yCMH0iM4E17NXpkuauM3hmAgABKeACABIvLUA==
Date:   Fri, 3 Sep 2021 04:00:04 +0000
Message-ID: <a8d31e69b6e648adb73c7ca3a61eea3e@baidu.com>
References: <1629966095-16341-1-git-send-email-lirongqing@baidu.com>
 <20210830170837-mutt-send-email-mst@kernel.org>
 <bbf978c3252b4f2ea13ab7ca07d53034@baidu.com>
 <20210831103024-mutt-send-email-mst@kernel.org>
In-Reply-To: <20210831103024-mutt-send-email-mst@kernel.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.194.62]
x-baidu-bdmsfe-datecheck: 1_BJHW-Mail-Ex15_2021-09-03 12:00:05:006
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0KPiDlj5Hku7bkuro6IE1pY2hhZWwgUy4gVHNp
cmtpbiA8bXN0QHJlZGhhdC5jb20+DQo+IOWPkemAgeaXtumXtDogMjAyMeW5tDjmnIgzMeaXpSAy
MjozNA0KPiDmlLbku7bkuro6IExpLFJvbmdxaW5nIDxsaXJvbmdxaW5nQGJhaWR1LmNvbT4NCj4g
5oqE6YCBOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBicGZAdmdlci5rZXJuZWwub3JnOw0KPiB2
aXJ0dWFsaXphdGlvbkBsaXN0cy5saW51eC1mb3VuZGF0aW9uLm9yZw0KPiDkuLvpopg6IFJlOiDn
rZTlpI06IFtQQVRDSF0gdmlydGlvX25ldDogcmVkdWNlIHJhd19zbXBfcHJvY2Vzc29yX2lkKCkg
Y2FsbGluZyBpbg0KPiB2aXJ0bmV0X3hkcF9nZXRfc3ENCj4gDQo+IE9uIFR1ZSwgQXVnIDMxLCAy
MDIxIGF0IDAyOjA5OjM2QU0gKzAwMDAsIExpLFJvbmdxaW5nIHdyb3RlOg0KPiA+ID4gLS0tLS3p
gq7ku7bljp/ku7YtLS0tLQ0KPiA+ID4g5Y+R5Lu25Lq6OiBNaWNoYWVsIFMuIFRzaXJraW4gPG1z
dEByZWRoYXQuY29tPg0KPiA+ID4g5Y+R6YCB5pe26Ze0OiAyMDIx5bm0OOaciDMx5pelIDU6MTAN
Cj4gPiA+IOaUtuS7tuS6ujogTGksUm9uZ3FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUuY29tPg0KPiA+
ID4g5oqE6YCBOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBicGZAdmdlci5rZXJuZWwub3JnOw0K
PiA+ID4gdmlydHVhbGl6YXRpb25AbGlzdHMubGludXgtZm91bmRhdGlvbi5vcmcNCj4gPiA+IOS4
u+mimDogUmU6IFtQQVRDSF0gdmlydGlvX25ldDogcmVkdWNlIHJhd19zbXBfcHJvY2Vzc29yX2lk
KCkgY2FsbGluZyBpbg0KPiA+ID4gdmlydG5ldF94ZHBfZ2V0X3NxDQo+ID4gPg0KPiA+ID4gT24g
VGh1LCBBdWcgMjYsIDIwMjEgYXQgMDQ6MjE6MzVQTSArMDgwMCwgTGkgUm9uZ1Fpbmcgd3JvdGU6
DQo+ID4gPiA+IHNtcF9wcm9jZXNzb3JfaWQoKS9yYXcqIHdpbGwgYmUgY2FsbGVkIG9uY2UgZWFj
aCB3aGVuIG5vdCBtb3JlDQo+ID4gPiA+IHF1ZXVlcyBpbiB2aXJ0bmV0X3hkcF9nZXRfc3EoKSB3
aGljaCBpcyBjYWxsZWQgaW4gbm9uLXByZWVtcHRpYmxlDQo+ID4gPiA+IGNvbnRleHQsIHNvIGl0
J3Mgc2FmZSB0byBjYWxsIHRoZSBmdW5jdGlvbg0KPiA+ID4gPiBzbXBfcHJvY2Vzc29yX2lkKCkg
b25jZS4NCj4gPiA+ID4NCj4gPiA+ID4gU2lnbmVkLW9mZi1ieTogTGkgUm9uZ1FpbmcgPGxpcm9u
Z3FpbmdAYmFpZHUuY29tPg0KPiA+ID4NCj4gPiA+IGNvbW1pdCBsb2cgc2hvdWxkIHByb2JhYmx5
IGV4cGxhaW4gd2h5IGl0J3MgYSBnb29kIGlkZWEgdG8gcmVwbGFjZQ0KPiA+ID4gcmF3X3NtcF9w
cm9jZXNzb3JfaWQgd2l0aCBzbXBfcHJvY2Vzc29yX2lkIGluIHRoZSBjYXNlIG9mDQo+ID4gPiBj
dXJyX3F1ZXVlX3BhaXJzIDw9IG5yX2NwdV9pZHMuDQo+ID4gPg0KPiA+DQo+ID4NCj4gPiBJIGNo
YW5nZSBpdCBhcyBiZWxvdywgaXMgaXQgb2s/DQo+ID4NCj4gPiAgICAgdmlydGlvX25ldDogcmVk
dWNlIHJhd19zbXBfcHJvY2Vzc29yX2lkKCkgY2FsbGluZyBpbg0KPiA+IHZpcnRuZXRfeGRwX2dl
dF9zcQ0KPiANCj4gc2hvcnRlcjoNCj4gDQo+IHZpcnRpb19uZXQ6IHMvcmF3X3NtcF9wcm9jZXNz
b3JfaWQvc21wX3Byb2Nlc3Nvcl9pZC8gaW4gdmlydG5ldF94ZHBfZ2V0X3NxDQo+IA0KPiANCj4g
Pg0KPiA+ICAgICBzbXBfcHJvY2Vzc29yX2lkKCkgYW5kIHJhd19zbXBfcHJvY2Vzc29yX2lkKCkg
YXJlIGNhbGxlZCBvbmNlDQo+ID4gICAgIGVhY2ggaW4gdmlydG5ldF94ZHBfZ2V0X3NxKCksIHdo
ZW4gY3Vycl9xdWV1ZV9wYWlycyA8PSBucl9jcHVfaWRzLA0KPiA+ICAgICBzaG91bGQgYmUgbWVy
Z2VkDQo+IA0KPiBJJ2QganVzdCBkcm9wIHRoaXMgcGFydC4NCj4gDQo+ID4NCj4gPiAgICAgdmly
dG5ldF94ZHBfZ2V0X3NxKCkgaXMgY2FsbGVkIGluIG5vbi1wcmVlbXB0aWJsZSBjb250ZXh0LCBz
bw0KPiA+ICAgICBpdCdzIHNhZmUgdG8gY2FsbCB0aGUgZnVuY3Rpb24gc21wX3Byb2Nlc3Nvcl9p
ZCgpLCBhbmQga2VlcA0KPiA+ICAgICBzbXBfcHJvY2Vzc29yX2lkKCksIGFuZCByZW1vdmUgdGhl
IGNhbGxpbmcgb2YgcmF3X3NtcF9wcm9jZXNzb3JfaWQoKSwNCj4gPiAgICAgYXZvaWQgdGhlIHdy
b25nIHVzZSB2aXJ0bmV0X3hkcF9nZXRfc3EgdG8gcHJlZW1wdGlibGUgY29udGV4dA0KPiA+ICAg
ICBpbiB0aGUgZnV0dXJlDQo+IA0KPiBzL2F2b2lkLiovdGhpcyB3YXkgd2UnbGwgZ2V0IGEgd2Fy
bmluZyBpZiB0aGlzIGlzIGV2ZXIgY2FsbGVkIGluIGEgcHJlZW1wdGlibGUNCj4gY29udGV4dC8N
Cj4gDQoNCg0KVGhhbmtzLCBzaG91bGQgSSByZXNlbmQgaXQNCg0KLUxpDQoNCg0KPiANCj4gPg0K
PiA+IC1MaQ0KDQo=
