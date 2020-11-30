Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C968D2C7C20
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 01:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgK3AiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 19:38:14 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:42219 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbgK3AiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 19:38:14 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 0AU0bBviD006408, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb04.realtek.com.tw[172.21.6.97])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 0AU0bBviD006408
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 30 Nov 2020 08:37:11 +0800
Received: from RTEXMBS02.realtek.com.tw (172.21.6.35) by
 RTEXMB04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Mon, 30 Nov 2020 08:37:11 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMBS02.realtek.com.tw (172.21.6.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 30 Nov 2020 08:37:10 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::89f7:e6c3:b043:15fa]) by
 RTEXMB04.realtek.com.tw ([fe80::89f7:e6c3:b043:15fa%3]) with mapi id
 15.01.2044.006; Mon, 30 Nov 2020 08:37:10 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Lee Jones <lee.jones@linaro.org>
CC:     Tony Chuang <yhchuang@realtek.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: RE: [PATCH 17/17] realtek: rtw88: pci: Add prototypes for .probe, .remove and .shutdown
Thread-Topic: [PATCH 17/17] realtek: rtw88: pci: Add prototypes for .probe,
 .remove and .shutdown
Thread-Index: AQHWw/kLX1PwJPIhYEea5OlYi0Fw16nazioAgABEUACAAA6jgIAAB2OAgASvuFA=
Date:   Mon, 30 Nov 2020 00:37:10 +0000
Message-ID: <0f8e7ac5a30a4f63a0a6aa923fa6d100@realtek.com>
References: <20201126133152.3211309-1-lee.jones@linaro.org>
 <20201126133152.3211309-18-lee.jones@linaro.org>
 <1606448026.14483.4.camel@realtek.com> <20201127073816.GF2455276@dell>
 <1606465839.26661.2.camel@realtek.com> <20201127085705.GL2455276@dell>
In-Reply-To: <20201127085705.GL2455276@dell>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.213]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTGVlIEpvbmVzIFttYWls
dG86bGVlLmpvbmVzQGxpbmFyby5vcmddDQo+IFNlbnQ6IEZyaWRheSwgTm92ZW1iZXIgMjcsIDIw
MjAgNDo1NyBQTQ0KPiBUbzogUGtzaGloDQo+IENjOiBUb255IENodWFuZzsga3ZhbG9AY29kZWF1
cm9yYS5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LXdpcmVsZXNzQHZn
ZXIua2VybmVsLm9yZzsNCj4gZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgbmV0ZGV2QHZnZXIua2VybmVs
Lm9yZzsga3ViYUBrZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMTcvMTddIHJlYWx0
ZWs6IHJ0dzg4OiBwY2k6IEFkZCBwcm90b3R5cGVzIGZvciAucHJvYmUsIC5yZW1vdmUgYW5kIC5z
aHV0ZG93bg0KPiANCj4gT24gRnJpLCAyNyBOb3YgMjAyMCwgUGtzaGloIHdyb3RlOg0KPiANCj4g
PiBPbiBGcmksIDIwMjAtMTEtMjcgYXQgMDc6MzggKzAwMDAsIExlZSBKb25lcyB3cm90ZToNCj4g
PiA+IE9uIEZyaSwgMjcgTm92IDIwMjAsIFBrc2hpaCB3cm90ZToNCj4gPiA+DQo+ID4gPiA+DQo+
ID4gPiA+IFRoZSBzdWJqZWN0IHByZWZpeCBkb2Vzbid0IG5lZWQgJ3JlYWx0ZWs6JzsgdXNlICdy
dHc4ODonLg0KPiA+ID4gPg0KPiA+ID4gPiBPbiBUaHUsIDIwMjAtMTEtMjYgYXQgMTM6MzEgKzAw
MDAsIExlZSBKb25lcyB3cm90ZToNCj4gPiA+ID4gPiBBbHNvIHN0cmlwIG91dCBvdGhlciBkdXBs
aWNhdGVzIGZyb20gZHJpdmVyIHNwZWNpZmljIGhlYWRlcnMuDQo+ID4gPiA+ID4NCj4gPiA+ID4g
PiBFbnN1cmUgJ21haW4uaCcgaXMgZXhwbGljaXRseSBpbmNsdWRlZCBpbiAncGNpLmgnIHNpbmNl
IHRoZSBsYXR0ZXINCj4gPiA+ID4gPiB1c2VzIHNvbWUgZGVmaW5lcyBmcm9tIHRoZSBmb3JtZXIu
wqDCoEl0IGF2b2lkcyBpc3N1ZXMgbGlrZToNCj4gPiA+ID4gPg0KPiA+ID4gPiA+IMKgZnJvbSBk
cml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3J0dzg4MjJiZS5jOjU6DQo+ID4gPiA+
ID4gwqBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3BjaS5oOjIwOToyODogZXJy
b3I6DQo+ID4gPiA+ID4g4oCYUlRLX01BWF9UWF9RVUVVRV9OVU3igJkgdW5kZWNsYXJlZCBoZXJl
IChub3QgaW4gYSBmdW5jdGlvbik7IGRpZCB5b3UgbWVhbg0KPiA+ID4gPiA+IOKAmFJUS19NQVhf
UlhfREVTQ19OVU3igJk/DQo+ID4gPiA+ID4gwqAyMDkgfCBERUNMQVJFX0JJVE1BUCh0eF9xdWV1
ZWQsIFJUS19NQVhfVFhfUVVFVUVfTlVNKTsNCj4gPiA+ID4gPiDCoHwgXn5+fn5+fn5+fn5+fn5+
fn5+fn4NCj4gPiA+ID4gPg0KPiA+ID4gPiA+IEZpeGVzIHRoZSBmb2xsb3dpbmcgVz0xIGtlcm5l
bCBidWlsZCB3YXJuaW5nKHMpOg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gwqBkcml2ZXJzL25ldC93
aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3BjaS5jOjE0ODg6NTogd2FybmluZzogbm8gcHJldmlvdXMN
Cj4gPiA+ID4gPiBwcm90b3R5cGUgZm9yIOKAmHJ0d19wY2lfcHJvYmXigJkgWy1XbWlzc2luZy1w
cm90b3R5cGVzXQ0KPiA+ID4gPiA+IMKgMTQ4OCB8IGludCBydHdfcGNpX3Byb2JlKHN0cnVjdCBw
Y2lfZGV2ICpwZGV2LA0KPiA+ID4gPiA+IMKgfCBefn5+fn5+fn5+fn5+DQo+ID4gPiA+ID4gwqBk
cml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3BjaS5jOjE1Njg6Njogd2FybmluZzog
bm8gcHJldmlvdXMNCj4gPiA+ID4gPiBwcm90b3R5cGUgZm9yIOKAmHJ0d19wY2lfcmVtb3Zl4oCZ
IFstV21pc3NpbmctcHJvdG90eXBlc10NCj4gPiA+ID4gPiDCoDE1NjggfCB2b2lkIHJ0d19wY2lf
cmVtb3ZlKHN0cnVjdCBwY2lfZGV2ICpwZGV2KQ0KPiA+ID4gPiA+IMKgfCBefn5+fn5+fn5+fn5+
fg0KPiA+ID4gPiA+IMKgZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9wY2kuYzox
NTkwOjY6IHdhcm5pbmc6IG5vIHByZXZpb3VzDQo+ID4gPiA+ID4gcHJvdG90eXBlIGZvciDigJhy
dHdfcGNpX3NodXRkb3du4oCZIFstV21pc3NpbmctcHJvdG90eXBlc10NCj4gPiA+ID4gPiDCoDE1
OTAgfCB2b2lkIHJ0d19wY2lfc2h1dGRvd24oc3RydWN0IHBjaV9kZXYgKnBkZXYpDQo+ID4gPiA+
ID4gwqB8IF5+fn5+fn5+fn5+fn5+fn4NCj4gPiA+ID4gPg0KPiA+ID4gPiA+IENjOiBZYW4tSHN1
YW4gQ2h1YW5nIDx5aGNodWFuZ0ByZWFsdGVrLmNvbT4NCj4gPiA+ID4gPiBDYzogS2FsbGUgVmFs
byA8a3ZhbG9AY29kZWF1cm9yYS5vcmc+DQo+ID4gPiA+ID4gQ2M6ICJEYXZpZCBTLiBNaWxsZXIi
IDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KPiA+ID4gPiA+IENjOiBKYWt1YiBLaWNpbnNraSA8a3Vi
YUBrZXJuZWwub3JnPg0KPiA+ID4gPiA+IENjOiBsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5v
cmcNCj4gPiA+ID4gPiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiA+ID4gPiA+IFNpZ25l
ZC1vZmYtYnk6IExlZSBKb25lcyA8bGVlLmpvbmVzQGxpbmFyby5vcmc+DQo+ID4gPiA+ID4gLS0t
DQo+ID4gPiA+ID4gwqBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3BjaS5owqDC
oMKgwqDCoMKgwqB8IDggKysrKysrKysNCj4gPiA+ID4gPiDCoGRyaXZlcnMvbmV0L3dpcmVsZXNz
L3JlYWx0ZWsvcnR3ODgvcnR3ODcyM2RlLmMgfCAxICsNCj4gPiA+ID4gPiDCoGRyaXZlcnMvbmV0
L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvcnR3ODcyM2RlLmggfCA0IC0tLS0NCj4gPiA+ID4gPiDC
oGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvcnR3ODgyMWNlLmMgfCAxICsNCj4g
PiA+ID4gPiDCoGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvcnR3ODgyMWNlLmgg
fCA0IC0tLS0NCj4gPiA+ID4gPiDCoGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgv
cnR3ODgyMmJlLmMgfCAxICsNCj4gPiA+ID4gPiDCoGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0
ZWsvcnR3ODgvcnR3ODgyMmJlLmggfCA0IC0tLS0NCj4gPiA+ID4gPiDCoGRyaXZlcnMvbmV0L3dp
cmVsZXNzL3JlYWx0ZWsvcnR3ODgvcnR3ODgyMmNlLmMgfCAxICsNCj4gPiA+ID4gPiDCoGRyaXZl
cnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvcnR3ODgyMmNlLmggfCA0IC0tLS0NCj4gPiA+
ID4gPiDCoDkgZmlsZXMgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKSwgMTYgZGVsZXRpb25zKC0p
DQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
cmVhbHRlay9ydHc4OC9wY2kuaA0KPiA+ID4gPiA+IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVh
bHRlay9ydHc4OC9wY2kuaA0KPiA+ID4gPiA+IGluZGV4IGNhMTdhYTljZjdkYzcuLmNkYTU2OTE5
YTVmMGYgMTAwNjQ0DQo+ID4gPiA+ID4gLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRl
ay9ydHc4OC9wY2kuaA0KPiA+ID4gPiA+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0
ZWsvcnR3ODgvcGNpLmgNCj4gPiA+ID4gPiBAQCAtNSw2ICs1LDggQEANCj4gPiA+ID4gPiDCoCNp
Zm5kZWYgX19SVEtfUENJX0hfDQo+ID4gPiA+ID4gwqAjZGVmaW5lIF9fUlRLX1BDSV9IXw0KPiA+
ID4gPiA+DQo+ID4gPiA+ID4gKyNpbmNsdWRlICJtYWluLmgiDQo+ID4gPiA+ID4gKw0KPiA+ID4g
Pg0KPiA+ID4gPiBQbGVhc2UgI2luY2x1ZGUgIm1haW4uaCIgYWhlYWQgb2YgInBjaS5oIiBpbiBl
YWNoIG9mwqBydHc4eHh4eGUuYy4NCj4gPiA+DQo+ID4gPiBZb3UgbWVhbiBpbnN0ZWFkIG9mIGlu
IHBjaS5oPw0KPiA+ID4NCj4gPiA+IFN1cmVseSB0aGF0J3MgYSBoYWNrLg0KPiA+ID4NCj4gPg0K
PiA+IEkgbWVhbiBkb24ndCBpbmNsdWRlIG1haW4uaCBpbiBwY2kuaCwgYnV0IGluY2x1ZGUgYm90
aCBvZiB0aGVtwqBpbiBlYWNoDQo+ID4gb2bCoHJ0dzh4eHh4ZS5jLg0KPiA+DQo+ID4gKyNpbmNs
dWRlICJtYWluLmgiDQo+ID4gKyNpbmNsdWRlICJwY2kuaCINCj4gDQo+IFllcywgdGhhdCdzIHdo
YXQgSSB0aG91Z2h0IHlvdSBtZWFudC4gIEkgdGhpbmsgdGhhdCdzIGEgaGFjay4NCj4gDQo+IFNv
dXJjZSBmaWxlcyBzaG91bGRuJ3QgcmVseSBvbiB0aGUgb3JkZXJpbmcgb2YgaW5jbHVkZSBmaWxl
cyB0bw0KPiByZXNvbHZlIGRlcGVuZGVuY2llcy4gIEluIGZhY3QsIGEgbG90IG9mIHN1YnN5c3Rl
bXMgcmVxdWlyZSBpbmNsdWRlcyB0bw0KPiBiZSBpbiBhbHBoYWJldGljYWwgb3JkZXIuDQo+IA0K
PiBJZiBhIHNvdXJjZSBvciBoZWFkZXIgZmlsZSByZWZlcmVuY2VzIGEgcmVzb3VyY2UgZnJvbSBh
IHNwZWNpZmljDQo+IGhlYWRlciBmaWxlIChmb3IgaW5zdGFuY2UgaGVyZSBwY2kuaCB1c2VzIGRl
ZmluZXMgZnJvbSBtYWluLmgpIHRoZW4gaXQNCj4gc2hvdWxkIGV4cGxpY2l0bHkgaW5jbHVkZSBp
dC4NCj4gDQo+IENhbiB5b3UgdGVsbCBtZSB0aGUgdGVjaG5pY2FsIHJlYXNvbiBhcyB0byB3aHkg
dGhlc2UgZHJpdmVycyBhcmUNCj4gaGFuZGxlZCBkaWZmZXJlbnRseSBwbGVhc2U/DQo+IA0KDQpO
byB0ZWNobmljYWwgcmVhc29uLCBidXQgdGhhdCdzIG91ciBjb2RpbmcgY29udmVudGlvbiB0aGF0
IG5lZWRzIHNvbWUNCmNoYW5nZXMgbm93Lg0KQ291bGQgeW91IHBvaW50IG91dCB3aGVyZSBrZXJu
ZWwgb3Igc3Vic3lzdGVtIGRlc2NyaWJlcyB0aGUgcnVsZXM/DQpPciwgcG9pbnQgb3V0IHRoZSBz
dWJzeXN0ZW0geW91IG1lbnRpb25lZCBhYm92ZS4NClRoZW4sIEkgY2FuIHN0dWR5IGFuZCBmb2xs
b3cgdGhlIHJ1bGVzIGZvciBmdXJ0aGVyIGRldmVsb3BtZW50Lg0KDQpUaGFuayB5b3UNCi0tLQ0K
UGluZy1LZQ0KDQoNCg==
