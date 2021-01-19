Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B16842FAE4B
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 02:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387866AbhASBY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 20:24:28 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:40119 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726834AbhASBYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 20:24:24 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 10J1NGRa8028413, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmbs03.realtek.com.tw[172.21.6.96])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 10J1NGRa8028413
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 19 Jan 2021 09:23:16 +0800
Received: from RTEXMBS05.realtek.com.tw (172.21.6.98) by
 RTEXMBS03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 19 Jan 2021 09:23:16 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 19 Jan 2021 09:23:15 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::ecca:80ca:53:e833]) by
 RTEXMBS04.realtek.com.tw ([fe80::ecca:80ca:53:e833%12]) with mapi id
 15.01.2106.006; Tue, 19 Jan 2021 09:23:15 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Grant Grundler <grundler@chromium.org>,
        nic_swsd <nic_swsd@realtek.com>
CC:     Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/3] net: usb: cdc_ncm: don't spew notifications
Thread-Topic: [PATCH 3/3] net: usb: cdc_ncm: don't spew notifications
Thread-Index: AQHW7eWpb6BAWMEvJU+hKvNmeu5nuKouJtIQ
Date:   Tue, 19 Jan 2021 01:23:15 +0000
Message-ID: <b7cefef1db98473e8483c6d582a59589@realtek.com>
References: <20210116052623.3196274-1-grundler@chromium.org>
 <20210116052623.3196274-3-grundler@chromium.org>
 <CANEJEGuDnZ6ujsRnn7xmO-y+SxxqxyaQCJXmHeV3XgfLsA8cDg@mail.gmail.com>
In-Reply-To: <CANEJEGuDnZ6ujsRnn7xmO-y+SxxqxyaQCJXmHeV3XgfLsA8cDg@mail.gmail.com>
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

R3JhbnQgR3J1bmRsZXIgPGdydW5kbGVyQGNocm9taXVtLm9yZz4NCj4gU2VudDogVHVlc2RheSwg
SmFudWFyeSAxOSwgMjAyMSA2OjAzIEFNDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMy8zXSBuZXQ6
IHVzYjogY2RjX25jbTogZG9uJ3Qgc3BldyBub3RpZmljYXRpb25zDQpbLi4uXQ0KPiA+IFJUTDgx
NTYgc2VuZHMgbm90aWZpY2F0aW9ucyBhYm91dCBldmVyeSAzMm1zLg0KPiA+IE9ubHkgZGlzcGxh
eS9sb2cgbm90aWZpY2F0aW9ucyB3aGVuIHNvbWV0aGluZyBjaGFuZ2VzLg0KPiA+DQo+ID4gVGhp
cyBpc3N1ZSBoYXMgYmVlbiByZXBvcnRlZCBieSBvdGhlcnM6DQo+ID4gICAgICAgICBodHRwczov
L2J1Z3MubGF1bmNocGFkLm5ldC91YnVudHUvK3NvdXJjZS9saW51eC8rYnVnLzE4MzI0NzINCj4g
PiAgICAgICAgIGh0dHBzOi8vbGttbC5vcmcvbGttbC8yMDIwLzgvMjcvMTA4Mw0KPiA+DQo+ID4g
Li4uDQo+ID4gWzc4NTk2Mi43Nzk4NDBdIHVzYiAxLTE6IG5ldyBoaWdoLXNwZWVkIFVTQiBkZXZp
Y2UgbnVtYmVyIDUgdXNpbmcNCj4geGhjaV9oY2QNCj4gPiBbNzg1OTYyLjkyOTk0NF0gdXNiIDEt
MTogTmV3IFVTQiBkZXZpY2UgZm91bmQsIGlkVmVuZG9yPTBiZGEsDQo+IGlkUHJvZHVjdD04MTU2
LCBiY2REZXZpY2U9MzAuMDANCj4gPiBbNzg1OTYyLjkyOTk0OV0gdXNiIDEtMTogTmV3IFVTQiBk
ZXZpY2Ugc3RyaW5nczogTWZyPTEsIFByb2R1Y3Q9MiwNCj4gU2VyaWFsTnVtYmVyPTYNCj4gPiBb
Nzg1OTYyLjkyOTk1Ml0gdXNiIDEtMTogUHJvZHVjdDogVVNCIDEwLzEwMC8xRy8yLjVHIExBTg0K
PiA+IFs3ODU5NjIuOTI5OTU0XSB1c2IgMS0xOiBNYW51ZmFjdHVyZXI6IFJlYWx0ZWsNCj4gPiBb
Nzg1OTYyLjkyOTk1Nl0gdXNiIDEtMTogU2VyaWFsTnVtYmVyOiAwMDAwMDAwMDENCj4gPiBbNzg1
OTYyLjk5MTc1NV0gdXNiY29yZTogcmVnaXN0ZXJlZCBuZXcgaW50ZXJmYWNlIGRyaXZlciBjZGNf
ZXRoZXINCj4gPiBbNzg1OTYzLjAxNzA2OF0gY2RjX25jbSAxLTE6Mi4wOiBNQUMtQWRkcmVzczog
MDA6MjQ6Mjc6ODg6MDg6MTUNCj4gPiBbNzg1OTYzLjAxNzA3Ml0gY2RjX25jbSAxLTE6Mi4wOiBz
ZXR0aW5nIHJ4X21heCA9IDE2Mzg0DQo+ID4gWzc4NTk2My4wMTcxNjldIGNkY19uY20gMS0xOjIu
MDogc2V0dGluZyB0eF9tYXggPSAxNjM4NA0KPiA+IFs3ODU5NjMuMDE3NjgyXSBjZGNfbmNtIDEt
MToyLjAgdXNiMDogcmVnaXN0ZXIgJ2NkY19uY20nIGF0DQo+IHVzYi0wMDAwOjAwOjE0LjAtMSwg
Q0RDIE5DTSwgMDA6MjQ6Mjc6ODg6MDg6MTUNCj4gPiBbNzg1OTYzLjAxOTIxMV0gdXNiY29yZTog
cmVnaXN0ZXJlZCBuZXcgaW50ZXJmYWNlIGRyaXZlciBjZGNfbmNtDQo+ID4gWzc4NTk2My4wMjM4
NTZdIHVzYmNvcmU6IHJlZ2lzdGVyZWQgbmV3IGludGVyZmFjZSBkcml2ZXIgY2RjX3dkbQ0KPiA+
IFs3ODU5NjMuMDI1NDYxXSB1c2Jjb3JlOiByZWdpc3RlcmVkIG5ldyBpbnRlcmZhY2UgZHJpdmVy
IGNkY19tYmltDQo+ID4gWzc4NTk2My4wMzg4MjRdIGNkY19uY20gMS0xOjIuMCBlbngwMDI0Mjc4
ODA4MTU6IHJlbmFtZWQgZnJvbSB1c2IwDQo+ID4gWzc4NTk2My4wODk1ODZdIGNkY19uY20gMS0x
OjIuMCBlbngwMDI0Mjc4ODA4MTU6IG5ldHdvcmsgY29ubmVjdGlvbjoNCj4gZGlzY29ubmVjdGVk
DQo+ID4gWzc4NTk2My4xMjE2NzNdIGNkY19uY20gMS0xOjIuMCBlbngwMDI0Mjc4ODA4MTU6IG5l
dHdvcmsgY29ubmVjdGlvbjoNCj4gZGlzY29ubmVjdGVkDQo+ID4gWzc4NTk2My4xNTM2ODJdIGNk
Y19uY20gMS0xOjIuMCBlbngwMDI0Mjc4ODA4MTU6IG5ldHdvcmsgY29ubmVjdGlvbjoNCj4gZGlz
Y29ubmVjdGVkDQo+ID4gLi4uDQo+ID4NCj4gPiBUaGlzIGlzIGFib3V0IDJLQiBwZXIgc2Vjb25k
IGFuZCB3aWxsIG92ZXJ3cml0ZSBhbGwgY29udGVudHMgb2YgYSAxTUINCj4gPiBkbWVzZyBidWZm
ZXIgaW4gdW5kZXIgMTAgbWludXRlcyByZW5kZXJpbmcgdGhlbSB1c2VsZXNzIGZvciBkZWJ1Z2dp
bmcNCj4gPiBtYW55IGtlcm5lbCBwcm9ibGVtcy4NCj4gPg0KPiA+IFRoaXMgaXMgYWxzbyBhbiBl
eHRyYSAxODAgTUIvZGF5IGluIC92YXIvbG9ncyAob3IgMUdCIHBlciB3ZWVrKSByZW5kZXJpbmcN
Cj4gPiB0aGUgbWFqb3JpdHkgb2YgdGhvc2UgbG9ncyB1c2VsZXNzIHRvby4NCj4gPg0KPiA+IFdo
ZW4gdGhlIGxpbmsgaXMgdXAgKGV4cGVjdGVkIHN0YXRlKSwgc3BldyBhbW91bnQgaXMgPjJ4IGhp
Z2hlcjoNCj4gPiAuLi4NCj4gPiBbNzg2MTM5LjYwMDk5Ml0gY2RjX25jbSAyLTE6Mi4wIGVueDAw
MjQyNzg4MDgxNTogbmV0d29yayBjb25uZWN0aW9uOg0KPiBjb25uZWN0ZWQNCj4gPiBbNzg2MTM5
LjYzMjk5N10gY2RjX25jbSAyLTE6Mi4wIGVueDAwMjQyNzg4MDgxNTogMjUwMCBtYml0L3MgZG93
bmxpbmsNCj4gMjUwMCBtYml0L3MgdXBsaW5rDQo+ID4gWzc4NjEzOS42NjUwOTddIGNkY19uY20g
Mi0xOjIuMCBlbngwMDI0Mjc4ODA4MTU6IG5ldHdvcmsgY29ubmVjdGlvbjoNCj4gY29ubmVjdGVk
DQo+ID4gWzc4NjEzOS42OTcxMDBdIGNkY19uY20gMi0xOjIuMCBlbngwMDI0Mjc4ODA4MTU6IDI1
MDAgbWJpdC9zIGRvd25saW5rDQo+IDI1MDAgbWJpdC9zIHVwbGluaw0KPiA+IFs3ODYxMzkuNzI5
MDk0XSBjZGNfbmNtIDItMToyLjAgZW54MDAyNDI3ODgwODE1OiBuZXR3b3JrIGNvbm5lY3Rpb246
DQo+IGNvbm5lY3RlZA0KPiA+IFs3ODYxMzkuNzYxMTA4XSBjZGNfbmNtIDItMToyLjAgZW54MDAy
NDI3ODgwODE1OiAyNTAwIG1iaXQvcyBkb3dubGluaw0KPiAyNTAwIG1iaXQvcyB1cGxpbmsNCj4g
PiAuLi4NCj4gPg0KPiA+IENocm9tZSBPUyBjYW5ub3Qgc3VwcG9ydCBSVEw4MTU2IHVudGlsIHRo
aXMgaXMgZml4ZWQuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBHcmFudCBHcnVuZGxlciA8Z3J1
bmRsZXJAY2hyb21pdW0ub3JnPg0KDQpSZXZpZXdlZC1ieTogSGF5ZXMgV2FuZyA8aGF5ZXN3YW5n
QHJlYWx0ZWsuY29tPg0KDQpCZXN0IFJlZ2FyZHMsDQpIYXllcw0KDQo=
