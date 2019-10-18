Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2909DDC516
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 14:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633871AbfJRMgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 08:36:03 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:55119 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403808AbfJRMgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 08:36:02 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x9ICZi57020888, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x9ICZi57020888
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Oct 2019 20:35:44 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCAS11.realtek.com.tw ([fe80::7c6d:ced5:c4ff:8297%15]) with mapi id
 14.03.0468.000; Fri, 18 Oct 2019 20:35:43 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "labbott@redhat.com" <labbott@redhat.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nico@semmle.com" <nico@semmle.com>
Subject: Re: [PATCH v2] rtlwifi: Fix potential overflow on P2P code
Thread-Topic: [PATCH v2] rtlwifi: Fix potential overflow on P2P code
Thread-Index: AQHVhalClczxzfC5skeU3Go3kf32jKdfz60A
Date:   Fri, 18 Oct 2019 12:35:43 +0000
Message-ID: <1571402142.1994.6.camel@realtek.com>
References: <20191018114321.13131-1-labbott@redhat.com>
In-Reply-To: <20191018114321.13131-1-labbott@redhat.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.6.62]
Content-Type: text/plain; charset="utf-8"
Content-ID: <9E6FC9AFA9152045A93C210744C36458@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTEwLTE4IGF0IDA3OjQzIC0wNDAwLCBMYXVyYSBBYmJvdHQgd3JvdGU6DQo+
IE5pY29sYXMgV2Fpc21hbiBub3RpY2VkIHRoYXQgZXZlbiB0aG91Z2ggbm9hX2xlbiBpcyBjaGVj
a2VkIGZvcg0KPiBhIGNvbXBhdGlibGUgbGVuZ3RoIGl0J3Mgc3RpbGwgcG9zc2libGUgdG8gb3Zl
cnJ1biB0aGUgYnVmZmVycw0KPiBvZiBwMnBpbmZvIHNpbmNlIHRoZXJlJ3Mgbm8gY2hlY2sgb24g
dGhlIHVwcGVyIGJvdW5kIG9mIG5vYV9udW0uDQo+IEJvdW5kIG5vYV9udW0gYWdhaW5zdCBQMlBf
TUFYX05PQV9OVU0uDQo+IA0KPiBSZXBvcnRlZC1ieTogTmljb2xhcyBXYWlzbWFuIDxuaWNvQHNl
bW1sZS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IExhdXJhIEFiYm90dCA8bGFiYm90dEByZWRoYXQu
Y29tPg0KDQpBY2tlZC1ieTogUGluZy1LZSBTaGloIDxwa3NoaWhAcmVhbHRlay5jb20+DQphbmQg
UGxlYXNlIENDIHRvIHN0YWJsZQ0KQ2M6IFN0YWJsZSA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4g
IyA0LjQrDQoNCi0tLQ0KDQpIaSBLYWxsZSwNCg0KVGhpcyBidWcgd2FzIGV4aXN0aW5nIHNpbmNl
IHYzLjEwLCBhbmQgZGlyZWN0b3J5IG9mIHdpcmVsZXNzIGRyaXZlcnMgd2VyZQ0KbW92ZWQgYXQg
djQuNC4gRG8gSSBuZWVkIHNlbmQgYW5vdGhlciBwYXRjaCB0byBmaXggdGhpcyBpc3N1ZSBmb3Ig
bG9uZ3Rlcm0NCmtlcm5lbCB2My4xNi43NT8NCg0KVGhhbmtzDQpQSw0KDQoNCj4gLS0tDQo+IHYy
OiBVc2UgUDJQX01BWF9OT0FfTlVNIGluc3RlYWQgb2YgZXJyb3Jpbmcgb3V0Lg0KPiAtLS0NCj4g
wqBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcHMuYyB8IDYgKysrKysrDQo+
IMKgMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9wcy5jDQo+IGIvZHJpdmVycy9uZXQv
d2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3BzLmMNCj4gaW5kZXggNzBmMDRjMmY1YjE3Li5mZmY4
ZGRhMTQwMjMgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRs
d2lmaS9wcy5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9w
cy5jDQo+IEBAIC03NTQsNiArNzU0LDkgQEAgc3RhdGljIHZvaWQgcnRsX3AycF9ub2FfaWUoc3Ry
dWN0IGllZWU4MDIxMV9odyAqaHcsIHZvaWQNCj4gKmRhdGEsDQo+IMKgCQkJCXJldHVybjsNCj4g
wqAJCQl9IGVsc2Ugew0KPiDCoAkJCQlub2FfbnVtID0gKG5vYV9sZW4gLSAyKSAvIDEzOw0KPiAr
CQkJCWlmIChub2FfbnVtID4gUDJQX01BWF9OT0FfTlVNKQ0KPiArCQkJCQlub2FfbnVtID0gUDJQ
X01BWF9OT0FfTlVNOw0KPiArDQo+IMKgCQkJfQ0KPiDCoAkJCW5vYV9pbmRleCA9IGllWzNdOw0K
PiDCoAkJCWlmIChydGxwcml2LT5wc2MucDJwX3BzX2luZm8ucDJwX3BzX21vZGUgPT0NCj4gQEAg
LTg0OCw2ICs4NTEsOSBAQCBzdGF0aWMgdm9pZCBydGxfcDJwX2FjdGlvbl9pZShzdHJ1Y3QgaWVl
ZTgwMjExX2h3ICpodywNCj4gdm9pZCAqZGF0YSwNCj4gwqAJCQkJcmV0dXJuOw0KPiDCoAkJCX0g
ZWxzZSB7DQo+IMKgCQkJCW5vYV9udW0gPSAobm9hX2xlbiAtIDIpIC8gMTM7DQo+ICsJCQkJaWYg
KG5vYV9udW0gPiBQMlBfTUFYX05PQV9OVU0pDQo+ICsJCQkJCW5vYV9udW0gPSBQMlBfTUFYX05P
QV9OVU07DQo+ICsNCj4gwqAJCQl9DQo+IMKgCQkJbm9hX2luZGV4ID0gaWVbM107DQo+IMKgCQkJ
aWYgKHJ0bHByaXYtPnBzYy5wMnBfcHNfaW5mby5wMnBfcHNfbW9kZSA9PQ0KDQoNCg==
