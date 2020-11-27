Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573D02C60E3
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 09:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbgK0IcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 03:32:09 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:44618 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727913AbgK0IcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 03:32:08 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 0AR8VqxyE004991, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb05.realtek.com.tw[172.21.6.98])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 0AR8VqxyE004991
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 27 Nov 2020 16:31:53 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMB05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Fri, 27 Nov 2020 16:31:52 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::89f7:e6c3:b043:15fa]) by
 RTEXMB04.realtek.com.tw ([fe80::89f7:e6c3:b043:15fa%3]) with mapi id
 15.01.2044.006; Fri, 27 Nov 2020 16:31:52 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "lee.jones@linaro.org" <lee.jones@linaro.org>
CC:     Tony Chuang <yhchuang@realtek.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCH 17/17] realtek: rtw88: pci: Add prototypes for .probe, .remove and .shutdown
Thread-Topic: [PATCH 17/17] realtek: rtw88: pci: Add prototypes for .probe,
 .remove and .shutdown
Thread-Index: AQHWw/kLX1PwJPIhYEea5OlYi0Fw16nazioAgABEUACAAA6jgA==
Date:   Fri, 27 Nov 2020 08:31:52 +0000
Message-ID: <1606465839.26661.2.camel@realtek.com>
References: <20201126133152.3211309-1-lee.jones@linaro.org>
         <20201126133152.3211309-18-lee.jones@linaro.org>
         <1606448026.14483.4.camel@realtek.com> <20201127073816.GF2455276@dell>
In-Reply-To: <20201127073816.GF2455276@dell>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.213]
Content-Type: text/plain; charset="utf-8"
Content-ID: <61C2FFAC809A0A47A19EF5EE39BE2A0A@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTExLTI3IGF0IDA3OjM4ICswMDAwLCBMZWUgSm9uZXMgd3JvdGU6DQo+IE9u
IEZyaSwgMjcgTm92IDIwMjAsIFBrc2hpaCB3cm90ZToNCj4gDQo+ID7CoA0KPiA+IFRoZSBzdWJq
ZWN0IHByZWZpeCBkb2Vzbid0IG5lZWQgJ3JlYWx0ZWs6JzsgdXNlICdydHc4ODonLg0KPiA+wqAN
Cj4gPiBPbiBUaHUsIDIwMjAtMTEtMjYgYXQgMTM6MzEgKzAwMDAsIExlZSBKb25lcyB3cm90ZToN
Cj4gPiA+IEFsc28gc3RyaXAgb3V0IG90aGVyIGR1cGxpY2F0ZXMgZnJvbSBkcml2ZXIgc3BlY2lm
aWMgaGVhZGVycy4NCj4gPiA+wqANCj4gPiA+IEVuc3VyZSAnbWFpbi5oJyBpcyBleHBsaWNpdGx5
IGluY2x1ZGVkIGluICdwY2kuaCcgc2luY2UgdGhlIGxhdHRlcg0KPiA+ID4gdXNlcyBzb21lIGRl
ZmluZXMgZnJvbSB0aGUgZm9ybWVyLsKgwqBJdCBhdm9pZHMgaXNzdWVzIGxpa2U6DQo+ID4gPsKg
DQo+ID4gPiDCoGZyb20gZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9ydHc4ODIy
YmUuYzo1Og0KPiA+ID4gwqBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3BjaS5o
OjIwOToyODogZXJyb3I6DQo+ID4gPiDigJhSVEtfTUFYX1RYX1FVRVVFX05VTeKAmSB1bmRlY2xh
cmVkIGhlcmUgKG5vdCBpbiBhIGZ1bmN0aW9uKTsgZGlkIHlvdSBtZWFuDQo+ID4gPiDigJhSVEtf
TUFYX1JYX0RFU0NfTlVN4oCZPw0KPiA+ID4gwqAyMDkgfCBERUNMQVJFX0JJVE1BUCh0eF9xdWV1
ZWQsIFJUS19NQVhfVFhfUVVFVUVfTlVNKTsNCj4gPiA+IMKgfCBefn5+fn5+fn5+fn5+fn5+fn5+
fg0KPiA+ID7CoA0KPiA+ID4gRml4ZXMgdGhlIGZvbGxvd2luZyBXPTEga2VybmVsIGJ1aWxkIHdh
cm5pbmcocyk6DQo+ID4gPsKgDQo+ID4gPiDCoGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsv
cnR3ODgvcGNpLmM6MTQ4ODo1OiB3YXJuaW5nOiBubyBwcmV2aW91cw0KPiA+ID4gcHJvdG90eXBl
IGZvciDigJhydHdfcGNpX3Byb2Jl4oCZIFstV21pc3NpbmctcHJvdG90eXBlc10NCj4gPiA+IMKg
MTQ4OCB8IGludCBydHdfcGNpX3Byb2JlKHN0cnVjdCBwY2lfZGV2ICpwZGV2LA0KPiA+ID4gwqB8
IF5+fn5+fn5+fn5+fn4NCj4gPiA+IMKgZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4
OC9wY2kuYzoxNTY4OjY6IHdhcm5pbmc6IG5vIHByZXZpb3VzDQo+ID4gPiBwcm90b3R5cGUgZm9y
IOKAmHJ0d19wY2lfcmVtb3Zl4oCZIFstV21pc3NpbmctcHJvdG90eXBlc10NCj4gPiA+IMKgMTU2
OCB8IHZvaWQgcnR3X3BjaV9yZW1vdmUoc3RydWN0IHBjaV9kZXYgKnBkZXYpDQo+ID4gPiDCoHwg
Xn5+fn5+fn5+fn5+fn4NCj4gPiA+IMKgZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4
OC9wY2kuYzoxNTkwOjY6IHdhcm5pbmc6IG5vIHByZXZpb3VzDQo+ID4gPiBwcm90b3R5cGUgZm9y
IOKAmHJ0d19wY2lfc2h1dGRvd27igJkgWy1XbWlzc2luZy1wcm90b3R5cGVzXQ0KPiA+ID4gwqAx
NTkwIHwgdm9pZCBydHdfcGNpX3NodXRkb3duKHN0cnVjdCBwY2lfZGV2ICpwZGV2KQ0KPiA+ID4g
wqB8IF5+fn5+fn5+fn5+fn5+fn4NCj4gPiA+wqANCj4gPiA+IENjOiBZYW4tSHN1YW4gQ2h1YW5n
IDx5aGNodWFuZ0ByZWFsdGVrLmNvbT4NCj4gPiA+IENjOiBLYWxsZSBWYWxvIDxrdmFsb0Bjb2Rl
YXVyb3JhLm9yZz4NCj4gPiA+IENjOiAiRGF2aWQgUy4gTWlsbGVyIiA8ZGF2ZW1AZGF2ZW1sb2Z0
Lm5ldD4NCj4gPiA+IENjOiBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPg0KPiA+ID4g
Q2M6IGxpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVsLm9yZw0KPiA+ID4gQ2M6IG5ldGRldkB2Z2Vy
Lmtlcm5lbC5vcmcNCj4gPiA+IFNpZ25lZC1vZmYtYnk6IExlZSBKb25lcyA8bGVlLmpvbmVzQGxp
bmFyby5vcmc+DQo+ID4gPiAtLS0NCj4gPiA+IMKgZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRl
ay9ydHc4OC9wY2kuaMKgwqDCoMKgwqDCoMKgfCA4ICsrKysrKysrDQo+ID4gPiDCoGRyaXZlcnMv
bmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvcnR3ODcyM2RlLmMgfCAxICsNCj4gPiA+IMKgZHJp
dmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9ydHc4NzIzZGUuaCB8IDQgLS0tLQ0KPiA+
ID4gwqBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3J0dzg4MjFjZS5jIHwgMSAr
DQo+ID4gPiDCoGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvcnR3ODgyMWNlLmgg
fCA0IC0tLS0NCj4gPiA+IMKgZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9ydHc4
ODIyYmUuYyB8IDEgKw0KPiA+ID4gwqBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4
L3J0dzg4MjJiZS5oIHwgNCAtLS0tDQo+ID4gPiDCoGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0
ZWsvcnR3ODgvcnR3ODgyMmNlLmMgfCAxICsNCj4gPiA+IMKgZHJpdmVycy9uZXQvd2lyZWxlc3Mv
cmVhbHRlay9ydHc4OC9ydHc4ODIyY2UuaCB8IDQgLS0tLQ0KPiA+ID4gwqA5IGZpbGVzIGNoYW5n
ZWQsIDEyIGluc2VydGlvbnMoKyksIDE2IGRlbGV0aW9ucygtKQ0KPiA+ID7CoA0KPiA+ID4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvcGNpLmgNCj4gPiA+
IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9wY2kuaA0KPiA+ID4gaW5kZXgg
Y2ExN2FhOWNmN2RjNy4uY2RhNTY5MTlhNWYwZiAxMDA2NDQNCj4gPiA+IC0tLSBhL2RyaXZlcnMv
bmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvcGNpLmgNCj4gPiA+ICsrKyBiL2RyaXZlcnMvbmV0
L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvcGNpLmgNCj4gPiA+IEBAIC01LDYgKzUsOCBAQA0KPiA+
ID4gwqAjaWZuZGVmIF9fUlRLX1BDSV9IXw0KPiA+ID4gwqAjZGVmaW5lIF9fUlRLX1BDSV9IXw0K
PiA+ID4gwqANCj4gPiA+ICsjaW5jbHVkZSAibWFpbi5oIg0KPiA+ID4gKw0KPiA+wqANCj4gPiBQ
bGVhc2UgI2luY2x1ZGUgIm1haW4uaCIgYWhlYWQgb2YgInBjaS5oIiBpbiBlYWNoIG9mwqBydHc4
eHh4eGUuYy4NCj4gDQo+IFlvdSBtZWFuIGluc3RlYWQgb2YgaW4gcGNpLmg/DQo+IA0KPiBTdXJl
bHkgdGhhdCdzIGEgaGFjay4NCj4gDQoNCkkgbWVhbiBkb24ndCBpbmNsdWRlIG1haW4uaCBpbiBw
Y2kuaCwgYnV0IGluY2x1ZGUgYm90aCBvZiB0aGVtwqBpbiBlYWNoDQpvZsKgcnR3OHh4eHhlLmMu
DQoNCisjaW5jbHVkZSAibWFpbi5oIg0KKyNpbmNsdWRlICJwY2kuaCINCg0KLS0tDQpQaW5nLUtl
DQoNCg==
