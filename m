Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1896222750D
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 03:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgGUB6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 21:58:33 -0400
Received: from mx21.baidu.com ([220.181.3.85]:55254 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725774AbgGUB6d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 21:58:33 -0400
X-Greylist: delayed 943 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Jul 2020 21:58:31 EDT
Received: from BC-Mail-Ex30.internal.baidu.com (unknown [172.31.51.24])
        by Forcepoint Email with ESMTPS id CF3085222703471FC498;
        Tue, 21 Jul 2020 09:42:39 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 BC-Mail-Ex30.internal.baidu.com (172.31.51.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1979.3; Tue, 21 Jul 2020 09:42:39 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1979.003; Tue, 21 Jul 2020 09:42:39 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
CC:     Network Development <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Subject: =?utf-8?B?562U5aSNOiBbSW50ZWwtd2lyZWQtbGFuXSBbUEFUQ0ggMS8yXSB4ZHA6IGk0?=
 =?utf-8?B?MGU6IGl4Z2JlOiBpeGdiZXZmOiBub3QgZmxpcCByeCBidWZmZXIgZm9yIGNv?=
 =?utf-8?Q?py_mode_xdp?=
Thread-Topic: [Intel-wired-lan] [PATCH 1/2] xdp: i40e: ixgbe: ixgbevf: not
 flip rx buffer for copy mode xdp
Thread-Index: AQHWXmZtsIr9AHsudEOLFGU9se5TiKkRPZUQ
Date:   Tue, 21 Jul 2020 01:42:39 +0000
Message-ID: <7b87919a454c4c7ba3d431783069e686@baidu.com>
References: <1594967062-20674-1-git-send-email-lirongqing@baidu.com>
 <1594967062-20674-2-git-send-email-lirongqing@baidu.com>
 <CAJ8uoz2hdemss9S5vuF=Ttapkfb8U4YJy41oVjpMUVLiCOJTkw@mail.gmail.com>
In-Reply-To: <CAJ8uoz2hdemss9S5vuF=Ttapkfb8U4YJy41oVjpMUVLiCOJTkw@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.197.254]
x-baidu-bdmsfe-datecheck: 1_BC-Mail-Ex30_2020-07-21 09:42:39:679
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0KPiDlj5Hku7bkuro6IE1hZ251cyBLYXJsc3Nv
biBbbWFpbHRvOm1hZ251cy5rYXJsc3NvbkBnbWFpbC5jb21dDQo+IOWPkemAgeaXtumXtDogMjAy
MOW5tDfmnIgyMOaXpSAxNToyMQ0KPiDmlLbku7bkuro6IExpLFJvbmdxaW5nIDxsaXJvbmdxaW5n
QGJhaWR1LmNvbT4NCj4g5oqE6YCBOiBOZXR3b3JrIERldmVsb3BtZW50IDxuZXRkZXZAdmdlci5r
ZXJuZWwub3JnPjsgaW50ZWwtd2lyZWQtbGFuDQo+IDxpbnRlbC13aXJlZC1sYW5AbGlzdHMub3N1
b3NsLm9yZz47IEthcmxzc29uLCBNYWdudXMNCj4gPG1hZ251cy5rYXJsc3NvbkBpbnRlbC5jb20+
OyBCasO2cm4gVMO2cGVsIDxiam9ybi50b3BlbEBpbnRlbC5jb20+DQo+IOS4u+mimDogUmU6IFtJ
bnRlbC13aXJlZC1sYW5dIFtQQVRDSCAxLzJdIHhkcDogaTQwZTogaXhnYmU6IGl4Z2JldmY6IG5v
dCBmbGlwIHJ4DQo+IGJ1ZmZlciBmb3IgY29weSBtb2RlIHhkcA0KPiANCj4gT24gRnJpLCBKdWwg
MTcsIDIwMjAgYXQgODoyNCBBTSBMaSBSb25nUWluZyA8bGlyb25ncWluZ0BiYWlkdS5jb20+IHdy
b3RlOg0KPiA+DQo+ID4gaTQwZS9peGdiZS9peGdiZXZmX3J4X2J1ZmZlcl9mbGlwIGluIGNvcHkg
bW9kZSB4ZHAgY2FuIGxlYWQgdG8gZGF0YQ0KPiA+IGNvcnJ1cHRpb24sIGxpa2UgdGhlIGZvbGxv
d2luZyBmbG93Og0KPiA+DQo+ID4gICAgMS4gZmlyc3Qgc2tiIGlzIG5vdCBmb3IgeHNrLCBhbmQg
Zm9yd2FyZGVkIHRvIGFub3RoZXIgZGV2aWNlDQo+ID4gICAgICAgb3Igc29ja2V0IHF1ZXVlDQo+
ID4gICAgMi4gc2Vjb25kcyBza2IgaXMgZm9yIHhzaywgY29weSBkYXRhIHRvIHhzayBtZW1vcnks
IGFuZCBwYWdlDQo+ID4gICAgICAgb2Ygc2tiLT5kYXRhIGlzIHJlbGVhc2VkDQo+ID4gICAgMy4g
cnhfYnVmZiBpcyByZXVzYWJsZSBzaW5jZSBvbmx5IGZpcnN0IHNrYiBpcyBpbiBpdCwgYnV0DQo+
ID4gICAgICAgKl9yeF9idWZmZXJfZmxpcCB3aWxsIG1ha2UgdGhhdCBwYWdlX29mZnNldCBpcyBz
ZXQgdG8NCj4gPiAgICAgICBmaXJzdCBza2IgZGF0YQ0KPiA+ICAgIDQuIHRoZW4gcmV1c2Ugcngg
YnVmZmVyLCBmaXJzdCBza2Igd2hpY2ggc3RpbGwgaXMgbGl2aW5nDQo+ID4gICAgICAgd2lsbCBi
ZSBjb3JydXB0ZWQuDQplLCBidXQga25vd24gc2l6ZSB0eXBlICovDQo+ID4gICAgICAgICB1MzIg
aWQ7DQo+ID4gQEAgLTczLDYgKzc1LDcgQEAgc3RydWN0IHhkcF9idWZmIHsNCj4gPiAgICAgICAg
IHN0cnVjdCB4ZHBfcnhxX2luZm8gKnJ4cTsNCj4gPiAgICAgICAgIHN0cnVjdCB4ZHBfdHhxX2lu
Zm8gKnR4cTsNCj4gPiAgICAgICAgIHUzMiBmcmFtZV9zejsgLyogZnJhbWUgc2l6ZSB0byBkZWR1
Y2UgZGF0YV9oYXJkX2VuZC9yZXNlcnZlZA0KPiA+IHRhaWxyb29tKi8NCj4gPiArICAgICAgIHUz
MiBmbGFnczsNCj4gDQo+IFJvbmdRaW5nLA0KPiANCj4gU29ycnkgdGhhdCBJIHdhcyBub3QgY2xl
YXIgZW5vdWdoLiBDb3VsZCB5b3UgcGxlYXNlIHN1Ym1pdCB0aGUgc2ltcGxlIHBhdGNoDQo+IHlv
dSBoYWQsIHRoZSBvbmUgdGhhdCBvbmx5IHRlc3RzIGZvciB0aGUgbWVtb3J5IHR5cGUuDQo+IA0K
PiBpZiAoeGRwLT5yeHEtPm1lbS50eXBlICE9IE1FTV9UWVBFX1hTS19CVUZGX1BPT0wpDQo+ICAg
ICAgIGk0MGVfcnhfYnVmZmVyX2ZsaXAocnhfcmluZywgcnhfYnVmZmVyLCBzaXplKTsNCj4gDQo+
IEkgZG8gbm90IHRoaW5rIHRoYXQgYWRkaW5nIGEgZmxhZ3MgZmllbGQgaW4gdGhlIHhkcF9tZW1f
aW5mbyB0byBmaXggYW4gSW50ZWwgZHJpdmVyDQo+IHByb2JsZW0gd2lsbCBiZSBodWdlbHkgcG9w
dWxhci4gVGhlIHN0cnVjdCBpcyBhbHNvIG1lYW50IHRvIGNvbnRhaW4gbG9uZyBsaXZlZA0KPiBp
bmZvcm1hdGlvbiwgbm90IHRoaW5ncyB0aGF0IHdpbGwgZnJlcXVlbnRseSBjaGFuZ2UuDQo+IA0K
DQoNClRoYW5rIHlvdSBNYWdudXMNCg0KTXkgb3JpZ2luYWwgc3VnZ2VzdGlvbiBpcyB3cm9uZyAs
IGl0IHNob3VsZCBiZSBmb2xsb3dpbmcNCg0KaWYgKHhkcC0+cnhxLT5tZW0udHlwZSA9PSBNRU1f
VFlQRV9YU0tfQlVGRl9QT09MKQ0KICAgICAgIGk0MGVfcnhfYnVmZmVyX2ZsaXAocnhfcmluZywg
cnhfYnVmZmVyLCBzaXplKTsNCg0KDQpidXQgSSBmZWVsIGl0IGlzIG5vdCBlbm91Z2ggdG8gb25s
eSBjaGVjayBtZW0udHlwZSwgaXQgbXVzdCBlbnN1cmUgdGhhdCBtYXBfdHlwZSBpcyBCUEZfTUFQ
X1RZUEVfWFNLTUFQID8gYnV0IGl0IGlzIG5vdCBleHBvc2UuIA0KDQpvdGhlciBtYXB0eXBlLCBs
aWtlIEJQRl9NQVBfVFlQRV9ERVZNQVAsICBhbmQgaWYgbWVtLnR5cGUgaXMgTUVNX1RZUEVfUEFH
RV9TSEFSRUQsIG5vdCBmbGlwIHRoZSByeCBidWZmZXIsIHdpbGwgY2F1c2UgZGF0YSBjb3JydXB0
aW9uLg0KDQoNCi1MaSANCg0KDQoNCg==
