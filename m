Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9782152CD
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 08:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbgGFGyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 02:54:20 -0400
Received: from mx24.baidu.com ([111.206.215.185]:39984 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727896AbgGFGyU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 02:54:20 -0400
Received: from BC-Mail-Ex30.internal.baidu.com (unknown [172.31.51.24])
        by Forcepoint Email with ESMTPS id 2DA8DE84217917A62844;
        Mon,  6 Jul 2020 14:38:32 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 BC-Mail-Ex30.internal.baidu.com (172.31.51.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1979.3; Mon, 6 Jul 2020 14:38:31 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1979.003; Mon, 6 Jul 2020 14:38:25 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
CC:     intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Netdev <netdev@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbSW50ZWwtd2lyZWQtbGFuXSBbYnVnID9dIGk0MGVfcnhfYnVm?=
 =?utf-8?B?ZmVyX2ZsaXAgc2hvdWxkIG5vdCBiZSBjYWxsZWQgZm9yIHJlZGlyZWN0ZWQg?=
 =?utf-8?Q?xsk_copy_mode?=
Thread-Topic: [Intel-wired-lan] [bug ?] i40e_rx_buffer_flip should not be
 called for redirected xsk copy mode
Thread-Index: AdZQR0EbXNQd8xyJRvWOWMhzMsvatQC0jCIAABEVlZA=
Date:   Mon, 6 Jul 2020 06:38:25 +0000
Message-ID: <3a12136e75a04b98b736c14da4044506@baidu.com>
References: <2863b548da1d4c369bbd9d6ceb337a24@baidu.com>
 <CAJ8uoz08pyWR43K_zhp6PsDLi0KE=y_4QTs-a7kBA-jkRQksaw@mail.gmail.com>
In-Reply-To: <CAJ8uoz08pyWR43K_zhp6PsDLi0KE=y_4QTs-a7kBA-jkRQksaw@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.197.248]
x-baidu-bdmsfe-datecheck: 1_BC-Mail-Ex30_2020-07-06 14:38:32:013
x-baidu-bdmsfe-viruscheck: BC-Mail-Ex30_GRAY_Inside_WithoutAtta_2020-07-06
 14:38:32:013
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0KPiDlj5Hku7bkuro6IE1hZ251cyBLYXJsc3Nv
biBbbWFpbHRvOm1hZ251cy5rYXJsc3NvbkBnbWFpbC5jb21dDQo+IOWPkemAgeaXtumXtDogMjAy
MOW5tDfmnIg25pelIDE0OjEzDQo+IOaUtuS7tuS6ujogTGksUm9uZ3FpbmcgPGxpcm9uZ3FpbmdA
YmFpZHUuY29tPg0KPiDmioTpgIE6IGludGVsLXdpcmVkLWxhbiA8aW50ZWwtd2lyZWQtbGFuQGxp
c3RzLm9zdW9zbC5vcmc+OyBCasO2cm4gVMO2cGVsDQo+IDxiam9ybi50b3BlbEBpbnRlbC5jb20+
OyBLYXJsc3NvbiwgTWFnbnVzIDxtYWdudXMua2FybHNzb25AaW50ZWwuY29tPjsNCj4gTmV0ZGV2
IDxuZXRkZXZAdmdlci5rZXJuZWwub3JnPg0KPiDkuLvpopg6IFJlOiBbSW50ZWwtd2lyZWQtbGFu
XSBbYnVnID9dIGk0MGVfcnhfYnVmZmVyX2ZsaXAgc2hvdWxkIG5vdCBiZSBjYWxsZWQgZm9yDQo+
IHJlZGlyZWN0ZWQgeHNrIGNvcHkgbW9kZQ0KPiANCj4gVGhhbmsgeW91IFJvbmdRaW5nIGZvciBy
ZXBvcnRpbmcgdGhpcy4gSSB3aWxsIHRha2UgYSBsb29rIGF0IGl0IGFuZCBwcm9kdWNlIGENCj4g
cGF0Y2guDQo+IA0KPiAvTWFnbnVzDQoNClRoYW5rcywgYW5kIGl4Z2JldmYvaXhnYmUgaGF2ZSBz
YW1lIGlzc3VlLg0KDQpkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9peGdiZXZmL2l4Z2JldmZf
bWFpbi5jDQpkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pNDBlL2k0MGVfdHhyeC5jDQpkcml2
ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9peGdiZS9peGdiZV9tYWluLmMNCg0KSSBoYXZlIGEgUkZD
LCBpdCBtYXliZSBub3QgYmV0dGVyIGR1ZSB0byBhZGRpbmcgYSBuZXcgdmFyaWFibGUgDQpodHRw
Oi8vcGF0Y2h3b3JrLm96bGFicy5vcmcvcHJvamVjdC9uZXRkZXYvcGF0Y2gvMTU5Mzc2MzkyNi0y
NDI5Mi0xLWdpdC1zZW5kLWVtYWlsLWxpcm9uZ3FpbmdAYmFpZHUuY29tLw0KDQpvciBjaGVjayBt
ZW1vcnkgdHlwZQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaTQw
ZS9pNDBlX3R4cnguYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2k0MGUvaTQwZV90eHJ4
LmMNCmluZGV4IGIzODM2MDkyYzMyNy4uZjQxNjY0ZTBjODRlIDEwMDY0NA0KLS0tIGEvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvaW50ZWwvaTQwZS9pNDBlX3R4cnguYw0KKysrIGIvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvaW50ZWwvaTQwZS9pNDBlX3R4cnguYw0KQEAgLTIzOTQsNyArMjM5NCw5IEBAIHN0
YXRpYyBpbnQgaTQwZV9jbGVhbl9yeF9pcnEoc3RydWN0IGk0MGVfcmluZyAqcnhfcmluZywgaW50
IGJ1ZGdldCkNCiANCiAgICAgICAgICAgICAgICAgICAgICAgIGlmICh4ZHBfcmVzICYgKEk0MEVf
WERQX1RYIHwgSTQwRV9YRFBfUkVESVIpKSB7DQogICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIHhkcF94bWl0IHw9IHhkcF9yZXM7DQotICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IGk0MGVfcnhfYnVmZmVyX2ZsaXAocnhfcmluZywgcnhfYnVmZmVyLCBzaXplKTsNCisNCisgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgaWYgKHhkcC0+cnhxLT5tZW0udHlwZSAhPSBNRU1f
VFlQRV9YU0tfQlVGRl9QT09MKQ0KKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIGk0MGVfcnhfYnVmZmVyX2ZsaXAocnhfcmluZywgcnhfYnVmZmVyLCBzaXplKTsNCiAgICAg
ICAgICAgICAgICAgICAgICAgIH0gZWxzZSB7DQogICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIHJ4X2J1ZmZlci0+cGFnZWNudF9iaWFzKys7DQogICAgICAgICAgICAgICAgICAgICAgICB9
DQpXaGV0aGVyLCAgbGlrZSB0byBzZWUgeW91ciBwYXRjaA0KDQotTGkgUm9uZ1FpbmcNCg==
