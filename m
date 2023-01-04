Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89AC165D9DD
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 17:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239758AbjADQcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 11:32:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239676AbjADQbu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 11:31:50 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA0F411833
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 08:31:49 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-115-OKgX2QelNL2C9KzZNLhdvQ-1; Wed, 04 Jan 2023 16:31:47 +0000
X-MC-Unique: OKgX2QelNL2C9KzZNLhdvQ-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 4 Jan
 2023 16:31:45 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.044; Wed, 4 Jan 2023 16:31:45 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Martin Blumenstingl' <martin.blumenstingl@googlemail.com>
CC:     Ping-Ke Shih <pkshih@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "tehuang@realtek.com" <tehuang@realtek.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/4] rtw88: Add packed attribute to the eFuse structs
Thread-Topic: [PATCH 1/4] rtw88: Add packed attribute to the eFuse structs
Thread-Index: AQHZGsFtJHlbRNsmYUOpTa0F4ufSPq6EmMnggAOg+qCAALbHgIAAiEwggAT0j0eAAALd0IAAB5IAgAADjxA=
Date:   Wed, 4 Jan 2023 16:31:45 +0000
Message-ID: <662e2f820e7a478096dd6e09725c093a@AcuMS.aculab.com>
References: <20221228133547.633797-1-martin.blumenstingl@googlemail.com>
 <20221228133547.633797-2-martin.blumenstingl@googlemail.com>
 <92eb7dfa8b7d447e966a2751e174b642@realtek.com>
 <87da8c82dec749dc826b5a1b4c4238aa@AcuMS.aculab.com>
 <eee17e2f4e44a2f38021a839dc39fedc1c1a4141.camel@realtek.com>
 <a86893f11fe64930897473a38226a9a8@AcuMS.aculab.com>
 <5c0c77240e7ddfdffbd771ee7e50d36ef3af9c84.camel@realtek.com>
 <CAFBinCC+1jGJx1McnBY+kr3RTQ-UpxW6JYNpHzStUTredDuCug@mail.gmail.com>
 <ec6a0988f3f943128e0122d50959185a@AcuMS.aculab.com>
 <CAFBinCC9sNvQJcu-SOSrFmo4sCx29K6KwXnc-O6MX9TJEHtXYg@mail.gmail.com>
In-Reply-To: <CAFBinCC9sNvQJcu-SOSrFmo4sCx29K6KwXnc-O6MX9TJEHtXYg@mail.gmail.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogTWFydGluIEJsdW1lbnN0aW5nbA0KPiBTZW50OiAwNCBKYW51YXJ5IDIwMjMgMTY6MDgN
Cj4gDQo+IE9uIFdlZCwgSmFuIDQsIDIwMjMgYXQgNDo1MyBQTSBEYXZpZCBMYWlnaHQgPERhdmlk
LkxhaWdodEBhY3VsYWIuY29tPiB3cm90ZToNCj4gPg0KPiA+IEZyb206IE1hcnRpbiBCbHVtZW5z
dGluZ2wNCj4gPiA+IFNlbnQ6IDA0IEphbnVhcnkgMjAyMyAxNTozMA0KPiA+ID4NCj4gPiA+IEhp
IFBpbmctS2UsIEhpIERhdmlkLA0KPiA+ID4NCj4gPiA+IE9uIFN1biwgSmFuIDEsIDIwMjMgYXQg
MjowOSBQTSBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVrLmNvbT4gd3JvdGU6DQo+ID4gPiBb
Li4uXQ0KPiA+ID4gPiBZZXMsIGl0IHNob3VsZCBub3QgdXNlIGJpdCBmaWxlZC4gSW5zdGVhZCwg
dXNlIGEgX19sZTE2IGZvciBhbGwgZmllbGRzLCBzdWNoIGFzDQo+ID4gPiBJIHRoaW5rIHRoaXMg
Y2FuIGJlIGRvbmUgaW4gYSBzZXBhcmF0ZSBwYXRjaC4NCj4gPiA+IE15IHYyIG9mIHRoaXMgcGF0
Y2ggaGFzIHJlZHVjZWQgdGhlc2UgY2hhbmdlcyB0byBhIG1pbmltdW0sIHNlZSBbMF0NCj4gPiA+
DQo+ID4gPiBbLi4uXQ0KPiA+ID4gPiBzdHJ1Y3QgcnR3ODgyMWNlX2VmdXNlIHsNCj4gPiA+ID4g
ICAgLi4uDQo+ID4gPiA+ICAgIHU4IGRhdGExOyAgICAgICAvLyBvZmZzZXQgMHgxMDANCj4gPiA+
ID4gICAgX19sZTE2IGRhdGEyOyAgIC8vIG9mZnNldCAweDEwMS0weDEwMg0KPiA+ID4gPiAgICAu
Li4NCj4gPiA+ID4gfSBfX3BhY2tlZDsNCj4gPiA+ID4NCj4gPiA+ID4gV2l0aG91dCBfX3BhY2tl
ZCwgY29tcGlsZXIgY291bGQgaGFzIHBhZCBiZXR3ZWVuIGRhdGExIGFuZCBkYXRhMiwNCj4gPiA+
ID4gYW5kIHRoZW4gZ2V0IHdyb25nIHJlc3VsdC4NCj4gPiA+IE15IHVuZGVyc3RhbmRpbmcgaXMg
dGhhdCB0aGlzIGlzIHRoZSByZWFzb24gd2h5IHdlIG5lZWQgX19wYWNrZWQuDQo+ID4NCj4gPiBU
cnVlLCBidXQgZG9lcyBpdCByZWFsbHkgaGF2ZSB0byBsb29rIGxpa2UgdGhhdD8NCj4gPiBJIGNh
bid0IGZpbmQgdGhhdCB2ZXJzaW9uIChJIGRvbid0IGhhdmUgYSBuZXRfbmV4dCB0cmVlKS4NCj4g
TXkgdW5kZXJzdGFuZGluZyBpcyB0aGF0IHRoZXJlJ3Mgb25lIGFjdHVhbCBhbmQgb25lIHBvdGVu
dGlhbCB1c2UtY2FzZS4NCj4gTGV0J3Mgc3RhcnQgd2l0aCB0aGUgYWN0dWFsIG9uZSBpbg0KPiBk
cml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3J0dzg4MjFjLmg6DQo+ICAgc3RydWN0
IHJ0dzg4MjFjX2VmdXNlIHsNCj4gICAgICAgX19sZTE2IHJ0bF9pZDsNCj4gICAgICAgdTggcmVz
MFsweDBlXTsNCj4gICAgICAgLi4uDQo+IA0KPiBUaGUgc2Vjb25kIG9uZSBpcyBhIHBvdGVudGlh
bCBvbmUsIGFsc28gaW4NCj4gZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9ydHc4
ODIxYy5oIGlmIHdlIHJlcGxhY2UgdGhlDQo+IGJpdGZpZWxkcyBieSBhbiBfX2xlMTYgKHdoaWNo
IGlzIG15IHVuZGVyc3RhbmRpbmcgaG93IHRoZSBkYXRhIGlzDQo+IG1vZGVsZWQgaW4gdGhlIGVG
dXNlKToNCj4gICBzdHJ1Y3QgcnR3ODgyMWNlX2VmdXNlIHsNCj4gICAgICAgLi4uDQo+ICAgICAg
IHU4IHNlcmlhbF9udW1iZXJbOF07DQo+ICAgICAgIF9fbGUxNiBjYXBfZGF0YTsgLyogMHhmNCAq
Lw0KPiAgICAgICAuLi4NCj4gKEknbSBub3Qgc3VyZSBhYm91dCB0aGUgImNhcF9kYXRhIiBuYW1l
LCBidXQgSSB0aGluayB5b3UgZ2V0IHRoZSBwb2ludCkNCg0KQm90aCB0aG9zZSBzZWVtIHRvIGJl
IGFsaWduZWQgLSBwcm92aWRlZCB0aGUgc3RydWN0dXJlIGlzIGFsaWduZWQuDQoNCj4gPiBQb3Nz
aWJseSBpdCBzaG91bGQgYmUgJ3U4IGRhdGEyWzJdOycNCj4gU28geW91J3JlIHNheWluZyB3ZSBz
aG91bGQgcmVwbGFjZSB0aGUgX19sZTE2IHdpdGggdTggc29tZV9uYW1lWzJdOw0KPiBpbnN0ZWFk
LCB0aGVuIHdlIGRvbid0IG5lZWQgdGhlIF9fcGFja2VkIGF0dHJpYnV0ZS4NCg0KQnV0IG1heWJl
IHlvdSBzaG91bGQgbG9vayBhdCBkZWZpbmluZyB0aGUgYml0ZmllbGRzIGRpZmZlcmVudGx5Lg0K
Q2hhbmdlIHRvIF9fbGUxNiBpcyBwcm9iYWJseSBtYWtpbmcgaXQgaGFyZCBmb3IgeW91cnNlbGYu
DQpQZXJoYXBzIHlvdSBjb3VsZCAjZGVmaW5lIGEgY29uc3RhbnQgZm9yIGVhY2ggYml0ZmllbGQN
CnNvIHlvdSBjYW4gd3JpdGUgYW4gYWNjZXNzIGZ1bmN0aW9uIGxpa2U6DQoJI2RlZmluZSBiaXR2
YWwoZmllbGQsIG4pIChmaWVsZFtuID4+IDE2XSA+PiAoKG4gPj4gOCkgJiA3KSkgJiAobiAmIDB4
ZmYpKQ0KSWYgJ24nIGlzIGFsd2F5cyBhIGNvbXBpbGUgdGltZSBjb25zdGFudCB0aGUgY29kZSB3
aWxsIGJlIGZpbmUuDQpUaGVuIGFkZCBhbm90aGVyIGRlZmluZSB0byBjcmVhdGUgdGhlICduJyBi
YXNlZCBvbiB2YWx1ZXMgZnJvbSB0aGUgc3BlYy4NCihXaGljaCBjb3VsZCBiZSBvZmZzZXRzIG9u
dG8gMTZiaXQgaXRlbXMgb24gb2RkIGJvdW5kYXJpZXMuKQ0KUHJvdmlkZWQgbm90aGluZyBjcm9z
c2VzIGJ5dGUgYm91bmRhcmllcyBpdCBzaG91bGQgYmUgZmluZSBhbmQgdGhlDQpzb3VyY2UgY29k
ZSB3aWxsIGJlIHJlYXNvbmFibHkgcmVhZGFibGUuDQoNCj4gPiBXaGF0IHlvdSBtYXkgd2FudCB0
byBkbyBpcyBhZGQgY29tcGlsZS10aW1lIGFzc2VydHMgZm9yIHRoZQ0KPiA+IHNpemVzIG9mIHRo
ZSBzdHJ1Y3R1cmVzLg0KPiBEbyBJIGdldCB5b3UgcmlnaHQgdGhhdCBzb21ldGhpbmcgbGlrZToN
Cj4gICBCVUlMRF9CVUdfT04oc2l6ZW9mKHJ0dzg4MjFjX2VmdXNlKSAhPSAyNTYpOw0KPiBpcyB3
aGF0IHlvdSBoYXZlIGluIG1pbmQ/DQoNClRoYXQgbG9va3MgbGlrZSB0aGUgb25lLi4uDQoNCglE
YXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91
bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5
NzM4NiAoV2FsZXMpDQo=

