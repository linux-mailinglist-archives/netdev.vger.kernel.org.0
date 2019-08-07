Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D81748427E
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 04:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729438AbfHGCdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 22:33:36 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:41763 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727653AbfHGCdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 22:33:36 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x772XQA2021696, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS12.realtek.com.tw[172.21.6.16])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x772XQA2021696
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Wed, 7 Aug 2019 10:33:26 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCAS12.realtek.com.tw ([::1]) with mapi id 14.03.0439.000; Wed, 7 Aug 2019
 10:33:26 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Brian Norris <briannorris@chromium.org>,
        =?utf-8?B?6rOg7KSA?= <gojun077@gmail.com>
CC:     linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: RE: Realtek r8822be wireless card fails to work with new rtw88 kernel module
Thread-Topic: Realtek r8822be wireless card fails to work with new rtw88
 kernel module
Thread-Index: AQHVTGO9JaOOz1AO2EeBgyY27UJlXKbuT6EAgACnGPA=
Date:   Wed, 7 Aug 2019 02:33:25 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D1889B04@RTITMBSVM04.realtek.com.tw>
References: <CAH040W7fdd-ND4-QG3DwGpFAPTMGB4zzuXYohMdfoSejV6XE_Q@mail.gmail.com>
 <CA+ASDXM6Jz7YY9XUj6QKv5VJCED-BnQ5K1UZHNApB9p6qTWtgg@mail.gmail.com>
In-Reply-To: <CA+ASDXM6Jz7YY9XUj6QKv5VJCED-BnQ5K1UZHNApB9p6qTWtgg@mail.gmail.com>
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

PiArIHloY2h1YW5nDQo+IA0KPiBPbiBUdWUsIEF1ZyA2LCAyMDE5IGF0IDc6MzIgQU0g6rOg7KSA
IDxnb2p1bjA3N0BnbWFpbC5jb20+IHdyb3RlOg0KPiA+DQo+ID4gSGVsbG8sDQo+ID4NCj4gPiBJ
IHJlY2VudGx5IHJlcG9ydGVkIGEgYnVnIHRvIFVidW50dSByZWdhcmRpbmcgYSByZWdyZXNzaW9u
IGluIHdpcmVsZXNzDQo+ID4gZHJpdmVyIHN1cHBvcnQgZm9yIHRoZSBSZWFsdGVrIHI4ODIyYmUg
d2lyZWxlc3MgY2hpcHNldC4gVGhlIGlzc3VlDQo+ID4gbGluayBvbiBsYXVuY2hwYWQgaXM6DQo+
ID4NCj4gPiBodHRwczovL2J1Z3MubGF1bmNocGFkLm5ldC9idWdzLzE4MzgxMzMNCj4gPg0KPiA+
IEFmdGVyIENhbm9uaWNhbCBkZXZlbG9wZXJzIHRyaWFnZWQgdGhlIGJ1ZyB0aGV5IGRldGVybWlu
ZWQgdGhhdCB0aGUNCj4gPiBwcm9ibGVtIGxpZXMgdXBzdHJlYW0sIGFuZCBpbnN0cnVjdGVkIG1l
IHRvIHNlbmQgbWFpbHMgdG8gdGhlIHJlbGV2YW50DQo+ID4ga2VybmVsIG1vZHVsZSBtYWludGFp
bmVycyBhdCBSZWFsdGVrIGFuZCB0byB0aGUgZ2VuZXJhbCBrZXJuZWwub3JnDQo+ID4gbWFpbGlu
ZyBsaXN0Lg0KPiA+DQo+ID4gSSBidWlsdCBrZXJuZWwgNS4zLjAtcmMxKyB3aXRoIHRoZSBsYXRl
c3QgcmVhbHRlayBkcml2ZXJzIGZyb20NCj4gPiB3aXJlbGVzcy1kcml2ZXJzLW5leHQgYnV0IG15
IFJlYWx0ZWsgcjg4MjJiZSBkb2Vzbid0IHdvcmsgd2l0aA0KPiA+IHJ0dzg4L3J0d3BjaSBrZXJu
ZWwgbW9kdWxlcy4NCj4gPg0KPiA+IFBsZWFzZSBsZXQgbWUga25vdyBpZiB0aGVyZSBpcyBhbnkg
YWRkaXRpb25hbCBpbmZvcm1hdGlvbiBJIGNhbg0KPiA+IHByb3ZpZGUgdGhhdCB3b3VsZCBoZWxw
IGluIGRlYnVnZ2luZyB0aGlzIGlzc3VlLg0KPiANCj4gQW55IGNoYW5jZSB0aGlzIHdvdWxkIGhl
bHAgeW91Pw0KPiANCj4gaHR0cHM6Ly9wYXRjaHdvcmsua2VybmVsLm9yZy9wYXRjaC8xMTA2NTYz
MS8NCj4gDQo+IFNvbWVib2R5IGVsc2Ugd2FzIGNvbXBsYWluaW5nIGFib3V0IDg4MjJiZSByZWdy
ZXNzaW9ucyB0aGF0IHdlcmUgZml4ZWQNCj4gd2l0aCB0aGF0Lg0KPiANCg0KSSBob3BlIGl0IGNv
dWxkIGZpeCBpdC4NCg0KQW5kIGFzICJyODgyMmJlIiB3YXMgZHJvcHBlZCwgaXQgaXMgcHJlZmVy
cmVkIHRvIHVzZSAicnR3ODgiIGluc3RlYWQuDQpJIGhhdmUgcmVjZWl2ZWQgdHdvIGtpbmRzIG9m
IGZhaWx1cmVzIHRoYXQgY2F1c2UgZHJpdmVyIHN0b3Agd29ya2luZy4NCk9uZSBpcyB0aGUgTVNJ
IGludGVycnVwdCBzaG91bGQgYmUgZW5hYmxlZCBvbiBjZXJ0YWluIHBsYXRmb3Jtcy4NCkFub3Ro
ZXIgaXMgdGhlIFJGRSB0eXBlIG9mIHRoZSBjYXJkLCBjb3VsZCB5b3Ugc2VuZCBtb3JlIGRtZXNn
IHRvIG1lPw0KDQpZYW4tSHN1YW4NCg0KDQo=
