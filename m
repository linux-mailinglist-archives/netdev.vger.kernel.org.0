Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3357D2A5C72
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 02:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730147AbgKDB5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 20:57:17 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:58271 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730116AbgKDB5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 20:57:17 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 0A41vBY51031929, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb06.realtek.com.tw[172.21.6.99])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 0A41vBY51031929
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 4 Nov 2020 09:57:11 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMB06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Wed, 4 Nov 2020 09:57:10 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::89f7:e6c3:b043:15fa]) by
 RTEXMB04.realtek.com.tw ([fe80::89f7:e6c3:b043:15fa%3]) with mapi id
 15.01.2044.006; Wed, 4 Nov 2020 09:57:10 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     =?utf-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH net-next 1/5] r8152: use generic USB macros to define product table
Thread-Topic: [PATCH net-next 1/5] r8152: use generic USB macros to define
 product table
Thread-Index: AQHWshavui7U4I+gmkudpd9bR0wfLqm3NRPA
Date:   Wed, 4 Nov 2020 01:57:10 +0000
Message-ID: <b83ddcca96cb40cf8785e6b44f9838e0@realtek.com>
References: <20201103192226.2455-1-kabel@kernel.org>
 <20201103192226.2455-2-kabel@kernel.org>
In-Reply-To: <20201103192226.2455-2-kabel@kernel.org>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.146]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TWFyZWsgQmVow7puIDxrYWJlbEBrZXJuZWwub3JnPg0KPiBTZW50OiBXZWRuZXNkYXksIE5vdmVt
YmVyIDQsIDIwMjAgMzoyMiBBTQ0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvdXNiL3I4MTUy
LmMgYi9kcml2ZXJzL25ldC91c2IvcjgxNTIuYw0KPiBpbmRleCBiMTc3MDQ4OWFjYTUuLjg1ZGRh
NTkxYzgzOCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvdXNiL3I4MTUyLmMNCj4gKysrIGIv
ZHJpdmVycy9uZXQvdXNiL3I4MTUyLmMNCj4gQEAgLTY4NjIsMjAgKzY4NjIsMTIgQEAgc3RhdGlj
IHZvaWQgcnRsODE1Ml9kaXNjb25uZWN0KHN0cnVjdA0KPiB1c2JfaW50ZXJmYWNlICppbnRmKQ0K
PiAgfQ0KPiANCj4gICNkZWZpbmUgUkVBTFRFS19VU0JfREVWSUNFKHZlbmQsIHByb2QpCVwNCj4g
LQkubWF0Y2hfZmxhZ3MgPSBVU0JfREVWSUNFX0lEX01BVENIX0RFVklDRSB8IFwNCj4gLQkJICAg
ICAgIFVTQl9ERVZJQ0VfSURfTUFUQ0hfSU5UX0NMQVNTLCBcDQo+IC0JLmlkVmVuZG9yID0gKHZl
bmQpLCBcDQo+IC0JLmlkUHJvZHVjdCA9IChwcm9kKSwgXA0KPiAtCS5iSW50ZXJmYWNlQ2xhc3Mg
PSBVU0JfQ0xBU1NfVkVORE9SX1NQRUMgXA0KPiArCVVTQl9ERVZJQ0VfSU5URVJGQUNFX0NMQVNT
KHZlbmQsIHByb2QsIFVTQl9DTEFTU19WRU5ET1JfU1BFQykNCj4gXA0KPiAgfSwgXA0KPiAgeyBc
DQo+IC0JLm1hdGNoX2ZsYWdzID0gVVNCX0RFVklDRV9JRF9NQVRDSF9JTlRfSU5GTyB8IFwNCj4g
LQkJICAgICAgIFVTQl9ERVZJQ0VfSURfTUFUQ0hfREVWSUNFLCBcDQo+IC0JLmlkVmVuZG9yID0g
KHZlbmQpLCBcDQo+IC0JLmlkUHJvZHVjdCA9IChwcm9kKSwgXA0KPiAtCS5iSW50ZXJmYWNlQ2xh
c3MgPSBVU0JfQ0xBU1NfQ09NTSwgXA0KPiAtCS5iSW50ZXJmYWNlU3ViQ2xhc3MgPSBVU0JfQ0RD
X1NVQkNMQVNTX0VUSEVSTkVULCBcDQo+IC0JLmJJbnRlcmZhY2VQcm90b2NvbCA9IFVTQl9DRENf
UFJPVE9fTk9ORQ0KPiArCVVTQl9ERVZJQ0VfQU5EX0lOVEVSRkFDRV9JTkZPKHZlbmQsIHByb2Qs
IFVTQl9DTEFTU19DT01NLCBcDQo+ICsJCQkJICAgICAgVVNCX0NEQ19TVUJDTEFTU19FVEhFUk5F
VCwgXA0KPiArCQkJCSAgICAgIFVTQl9DRENfUFJPVE9fTk9ORSkNCj4gDQo+ICAvKiB0YWJsZSBv
ZiBkZXZpY2VzIHRoYXQgd29yayB3aXRoIHRoaXMgZHJpdmVyICovDQo+ICBzdGF0aWMgY29uc3Qg
c3RydWN0IHVzYl9kZXZpY2VfaWQgcnRsODE1Ml90YWJsZVtdID0gew0KDQpJIGRvbid0IHVzZSB0
aGVzZSwgYmVjYXVzZSBjaGVja3BhdGNoLnBsIHdvdWxkIHNob3cgZXJyb3IuDQoNCgkkIHNjcmlw
dHMvY2hlY2twYXRjaC5wbCAtLWZpbGUgLS10ZXJzZSBkcml2ZXJzL25ldC91c2IvcjgxNTIuYw0K
CUVSUk9SOiBNYWNyb3Mgd2l0aCBjb21wbGV4IHZhbHVlcyBzaG91bGQgYmUgZW5jbG9zZWQgaW4g
cGFyZW50aGVzZXMNCg0KQmVzdCBSZWdhcmRzLA0KSGF5ZXMNCg0K
