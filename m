Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7E379F79
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 05:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727732AbfG3DMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 23:12:10 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:55102 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbfG3DMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 23:12:09 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x6U3BePq012141, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS12.realtek.com.tw[172.21.6.16])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x6U3BePq012141
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 30 Jul 2019 11:11:41 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCAS12.realtek.com.tw ([::1]) with mapi id 14.03.0439.000; Tue, 30 Jul
 2019 11:11:40 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Jian-Hong Pan <jian-hong@endlessm.com>,
        David Laight <David.Laight@aculab.com>
CC:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@endlessm.com" <linux@endlessm.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] rtw88: pci: Use general byte arrays as the elements of RX ring
Thread-Topic: [PATCH] rtw88: pci: Use general byte arrays as the elements of
 RX ring
Thread-Index: AQHVQsDFA5h+OZuaBU+XsMB5k0fq7qbaiPcAgAFfSQCAADO7gIAABNsAgAZbryA=
Date:   Tue, 30 Jul 2019 03:11:39 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D1881C54@RTITMBSVM04.realtek.com.tw>
References: <20190725080925.6575-1-jian-hong@endlessm.com>
 <06d713fff7434dfb9ccab32c2e2112e2@AcuMS.aculab.com>
 <CAPpJ_ecAAw=1X=7+MOw-VVH0ZKBr6rcRub6JnEqgNbZ6Hxt=ag@mail.gmail.com>
 <c2cdffd30923459e8773379fc2927e1d@AcuMS.aculab.com>
 <CAPpJ_eey7+KCMFj2YVQD8ziWR_xf-==k9MYb49-32Z5E6vTdHA@mail.gmail.com>
In-Reply-To: <CAPpJ_eey7+KCMFj2YVQD8ziWR_xf-==k9MYb49-32Z5E6vTdHA@mail.gmail.com>
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

PiA+ID4gPiBXaGlsZSBhbGxvY2F0aW5nIGFsbCA1MTIgYnVmZmVycyBpbiBvbmUgYmxvY2sgKGp1
c3Qgb3ZlciA0TUIpDQo+ID4gPiA+IGlzIHByb2JhYmx5IG5vdCBhIGdvb2QgaWRlYSwgeW91IG1h
eSBuZWVkIHRvIGFsbG9jYXRlZCAoYW5kIGRtYSBtYXApDQo+ID4gPiA+IHRoZW4gaW4gZ3JvdXBz
Lg0KPiA+ID4NCj4gPiA+IFRoYW5rcyBmb3IgcmV2aWV3aW5nLiAgQnV0IGdvdCBxdWVzdGlvbnMg
aGVyZSB0byBkb3VibGUgY29uZmlybSB0aGUNCj4gaWRlYS4NCj4gPiA+IEFjY29yZGluZyB0byBv
cmlnaW5hbCBjb2RlLCBpdCBhbGxvY2F0ZXMgNTEyIHNrYnMgZm9yIFJYIHJpbmcgYW5kIGRtYQ0K
PiA+ID4gbWFwcGluZyBvbmUgYnkgb25lLiAgU28sIHRoZSBuZXcgY29kZSBhbGxvY2F0ZXMgbWVt
b3J5IGJ1ZmZlciA1MTINCj4gPiA+IHRpbWVzIHRvIGdldCA1MTIgYnVmZmVyIGFycmF5cy4gIFdp
bGwgdGhlIDUxMiBidWZmZXJzIGFycmF5cyBiZSBpbiBvbmUNCj4gPiA+IGJsb2NrPyAgRG8geW91
IG1lYW4gYWdncmVnYXRlIHRoZSBidWZmZXJzIGFzIGEgc2NhdHRlcmxpc3QgYW5kIHVzZQ0KPiA+
ID4gZG1hX21hcF9zZz8NCj4gPg0KPiA+IElmIHlvdSBtYWxsb2MgYSBidWZmZXIgb2Ygc2l6ZSAo
ODE5MiszMikgdGhlIGFsbG9jYXRvciB3aWxsIGVpdGhlcg0KPiA+IHJvdW5kIGl0IHVwIHRvIGEg
d2hvbGUgbnVtYmVyIG9mIChvZnRlbiA0aykgcGFnZXMgb3IgdG8gYSBwb3dlciBvZg0KPiA+IDIg
b2YgcGFnZXMgLSBzbyBlaXRoZXIgMTJrIG9mIDE2ay4NCj4gPiBJIHRoaW5rIHRoZSBMaW51eCBh
bGxvY2F0b3IgZG9lcyB0aGUgbGF0dGVyLg0KPiA+IFNvbWUgb2YgdGhlIGFsbG9jYXRvcnMgYWxz
byAnc3RlYWwnIGEgYml0IGZyb20gdGhlIGZyb250IG9mIHRoZSBidWZmZXINCj4gPiBmb3IgJ3Jl
ZCB0YXBlJy4NCj4gPg0KPiA+IE9UT0ggbWFsbG9jIHRoZSBzcGFjZSAxNSBidWZmZXJzIGFuZCB0
aGUgYWxsb2NhdG9yIHdpbGwgcm91bmQgdGhlDQo+ID4gMTUqKDgxOTIgKyAzMikgdXAgdG8gMzIq
NGsgLSBhbmQgeW91IHdhc3RlIHVuZGVyIDhrIGFjcm9zcyBhbGwgdGhlDQo+ID4gYnVmZmVycy4N
Cj4gPg0KPiA+IFlvdSB0aGVuIGRtYV9tYXAgdGhlIGxhcmdlIGJ1ZmZlciBhbmQgc3BsaXQgaW50
byB0aGUgYWN0dWFsIHJ4IGJ1ZmZlcnMuDQo+ID4gUmVwZWF0IHVudGlsIHlvdSd2ZSBmaWxsZWQg
dGhlIGVudGlyZSByaW5nLg0KPiA+IFRoZSBvbmx5IGNvbXBsaWNhdGlvbiBpcyByZW1lbWJlcmlu
ZyB0aGUgYmFzZSBhZGRyZXNzIChhbmQgc2l6ZSkgZm9yDQo+ID4gdGhlIGRtYV91bm1hcCBhbmQg
ZnJlZS4NCj4gPiBBbHRob3VnaCB0aGVyZSBpcyBwbGVudHkgb2YgcGFkZGluZyB0byBleHRlbmQg
dGhlIGJ1ZmZlciBzdHJ1Y3R1cmUNCj4gPiBzaWduaWZpY2FudGx5IHdpdGhvdXQgdXNpbmcgbW9y
ZSBtZW1vcnkuDQo+ID4gQWxsb2NhdGUgaW4gMTUncyBhbmQgeW91IChwcm9iYWJseSkgaGF2ZSA1
MTIgYnl0ZXMgcGVyIGJ1ZmZlci4NCj4gPiBBbGxvY2F0ZSBpbiAzMSdzIGFuZCB5b3UgaGF2ZSAy
NTYgYnl0ZXMuDQo+ID4NCj4gPiBUaGUgcHJvYmxlbSBpcyB0aGF0IGxhcmdlciBhbGxvY2F0ZXMg
YXJlIG1vcmUgbGlrZWx5IHRvIGZhaWwNCj4gPiAoZXNwZWNpYWxseSBpZiB0aGUgc3lzdGVtIGhh
cyBiZWVuIHJ1bm5pbmcgZm9yIHNvbWUgdGltZSkuDQo+ID4gU28geW91IGFsbW9zdCBjZXJ0YWlu
bHkgd2FudCB0byBiZSBhYmxlIHRvIGZhbGwgYmFjayB0byBzbWFsbGVyDQo+ID4gYWxsb2NhdGVz
IGV2ZW4gdGhvdWdoIHRoZXkgdXNlIG1vcmUgbWVtb3J5Lg0KPiA+DQo+ID4gSSBhbHNvIHdvbmRl
ciBpZiB5b3UgYWN0dWFsbHkgbmVlZCA1MTIgOGsgcnggYnVmZmVycyB0byBjb3Zlcg0KPiA+IGlu
dGVycnVwdCBsYXRlbmN5Pw0KPiA+IEkndmUgbm90IGRvbmUgYW55IG1lYXN1cmVtZW50cyBmb3Ig
MjAgeWVhcnMhDQo+IA0KPiBUaGFua3MgZm9yIHRoZSBleHBsYW5hdGlvbi4NCj4gSSBhbSBub3Qg
c3VyZSB0aGUgY29tYmluYXRpb24gb2YgNTEyIDhrIFJYIGJ1ZmZlcnMuICBNYXliZSBSZWFsdGVr
DQo+IGZvbGtzIGNhbiBnaXZlIHVzIHNvbWUgaWRlYS4NCj4gVG9ueSBDaHVhbmcgYW55IGNvbW1l
bnQ/DQo+IA0KPiBKaWFuLUhvbmcgUGFuDQo+IA0KDQo1MTIgUlggYnVmZmVycyBpcyBub3QgbmVj
ZXNzYXJ5IEkgdGhpbmsuIEJ1dCBJIGhhdmVuJ3QgaGFkIGEgY2hhbmNlIHRvDQp0ZXN0IGlmIHJl
ZHVjZSB0aGUgbnVtYmVyIG9mIFJYIFNLQnMgY291bGQgYWZmZWN0IHRoZSBsYXRlbmN5Lg0KSSBj
YW4gcnVuIHNvbWUgdGhyb3VnaHB1dCB0ZXN0cyBhbmQgdGhlbiBkZWNpZGUgYSBtaW5pbXVtIG51
bWJlcnMNCnRoYXQgUlggcmluZyByZXF1aXJlcy4gT3IgaWYgeW91IGNhbiB0cnkgaXQuDQoNClRo
YW5rcy4NCllhbi1Ic3Vhbg0K
