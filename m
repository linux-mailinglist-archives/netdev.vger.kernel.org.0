Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B866B61C0B
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 11:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729653AbfGHJA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 05:00:28 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:43973 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727352AbfGHJA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 05:00:28 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x6890GB1027880, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x6890GB1027880
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Mon, 8 Jul 2019 17:00:16 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCASV01.realtek.com.tw ([::1]) with mapi id 14.03.0439.000; Mon, 8 Jul
 2019 17:00:15 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Jian-Hong Pan <jian-hong@endlessm.com>
CC:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@endlessm.com" <linux@endlessm.com>,
        Daniel Drake <drake@endlessm.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] rtw88/pci: Rearrange the memory usage for skb in RX ISR
Thread-Topic: [PATCH] rtw88/pci: Rearrange the memory usage for skb in RX ISR
Thread-Index: AQHVNVeEOhZgR6M53kuE5XrXitIVDqbAR+xA//+PoICAAIn6kA==
Date:   Mon, 8 Jul 2019 09:00:15 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D1861B71@RTITMBSVM04.realtek.com.tw>
References: <20190708063252.4756-1-jian-hong@endlessm.com>
 <F7CD281DE3E379468C6D07993EA72F84D1861A6D@RTITMBSVM04.realtek.com.tw>
 <CAPpJ_eebQtL0y_j98J2T7m9g77A61SVtvD8qnNN42bV0dm4MLA@mail.gmail.com>
In-Reply-To: <CAPpJ_eebQtL0y_j98J2T7m9g77A61SVtvD8qnNN42bV0dm4MLA@mail.gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.68.183]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiA+ID4gQEAgLTgwMywyNSArODEyLDE0IEBAIHN0YXRpYyB2b2lkIHJ0d19wY2lfcnhfaXNyKHN0
cnVjdCBydHdfZGV2DQo+ICpydHdkZXYsDQo+ID4gPiBzdHJ1Y3QgcnR3X3BjaSAqcnR3cGNpLA0K
PiA+ID4gICAgICAgICAgICAgICAgICAgICAgIHNrYl9wdXQoc2tiLCBwa3Rfc3RhdC5wa3RfbGVu
KTsNCj4gPiA+ICAgICAgICAgICAgICAgICAgICAgICBza2JfcmVzZXJ2ZShza2IsIHBrdF9vZmZz
ZXQpOw0KPiA+ID4NCj4gPiA+IC0gICAgICAgICAgICAgICAgICAgICAvKiBhbGxvYyBhIHNtYWxs
ZXIgc2tiIHRvIG1hYzgwMjExICovDQo+ID4gPiAtICAgICAgICAgICAgICAgICAgICAgbmV3ID0g
ZGV2X2FsbG9jX3NrYihwa3Rfc3RhdC5wa3RfbGVuKTsNCj4gPiA+IC0gICAgICAgICAgICAgICAg
ICAgICBpZiAoIW5ldykgew0KPiA+ID4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbmV3
ID0gc2tiOw0KPiA+ID4gLSAgICAgICAgICAgICAgICAgICAgIH0gZWxzZSB7DQo+ID4gPiAtICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBza2JfcHV0X2RhdGEobmV3LCBza2ItPmRhdGEsDQo+
IHNrYi0+bGVuKTsNCj4gPiA+IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAgIGRldl9rZnJl
ZV9za2JfYW55KHNrYik7DQo+ID4gPiAtICAgICAgICAgICAgICAgICAgICAgfQ0KPiA+DQo+ID4g
SSBhbSBub3Qgc3VyZSBpZiBpdCdzIGZpbmUgdG8gZGVsaXZlciBldmVyeSBodWdlIFNLQiB0byBt
YWM4MDIxMS4NCj4gPiBCZWNhdXNlIGl0IHdpbGwgdGhlbiBiZSBkZWxpdmVyZWQgdG8gVENQL0lQ
IHN0YWNrLg0KPiA+IEhlbmNlIEkgdGhpbmsgZWl0aGVyIGl0IHNob3VsZCBiZSB0ZXN0ZWQgdG8g
a25vdyBpZiB0aGUgcGVyZm9ybWFuY2UNCj4gPiB3b3VsZCBiZSBpbXBhY3RlZCBvciBmaW5kIG91
dCBhIG1vcmUgZWZmaWNpZW50IHdheSB0byBzZW5kDQo+ID4gc21hbGxlciBTS0IgdG8gbWFjODAy
MTEgc3RhY2suDQo+IA0KPiBJIHJlbWVtYmVyIG5ldHdvcmsgc3RhY2sgb25seSBwcm9jZXNzZXMg
dGhlIHNrYiB3aXRoKGluKSBwb2ludGVycw0KPiAoc2tiLT5kYXRhKSBhbmQgdGhlIHNrYi0+bGVu
IGZvciBkYXRhIHBhcnQuICBJdCBhbHNvIGNoZWNrcyByZWFsDQo+IGJ1ZmZlciBib3VuZGFyeSAo
aGVhZCBhbmQgZW5kKSBvZiB0aGUgc2tiIHRvIHByZXZlbnQgbWVtb3J5IG92ZXJmbG93Lg0KPiBU
aGVyZWZvcmUsIEkgdGhpbmsgdXNpbmcgdGhlIG9yaWdpbmFsIHNrYiBpcyB0aGUgbW9zdCBlZmZp
Y2llbnQgd2F5Lg0KPiANCj4gSWYgSSBtaXN1bmRlcnN0YW5kIHNvbWV0aGluZywgcGxlYXNlIHBv
aW50IG91dC4NCj4gDQoNCkl0IG1lYW5zIGlmIHdlIHN0aWxsIHVzZSBhIGh1Z2UgU0tCICh+OEsp
IGZvciBldmVyeSBSWCBwYWNrZXQgKH4xLjVLKS4NClRoZXJlIGlzIGFib3V0IDYuNUsgbm90IHVz
ZWQuIEFuZCBldmVuIG1vcmUgaWYgd2UgcGluZyB3aXRoIGxhcmdlIHBhY2tldA0Kc2l6ZSAiZWcu
ICQgcGluZyAtcyA2NTUzNiIsIEkgYW0gbm90IHN1cmUgaWYgdGhvc2UgaHVnZSBTS0JzIHdpbGwg
ZWF0IGFsbCBvZg0KdGhlIFNLQiBtZW0gcG9vbCwgYW5kIHRoZW4gcGluZyBmYWlscy4NCg0KQlRX
LCB0aGUgb3JpZ2luYWwgZGVzaWduIG9mIFJUS19QQ0lfUlhfQlVGX1NJWkUgdG8gYmUgKDgxOTIg
KyAyNCkgaXMgdG8NCnJlY2VpdmUgQU1TRFUgcGFja2V0IGluIG9uZSBTS0IuDQooQ291bGQgcHJv
YmFibHkgZW5sYXJnZSBpdCB0byBSWCBWSFQgQU1TRFUgfjExSykNCg0KWWFuLUhzdWFuDQo=
