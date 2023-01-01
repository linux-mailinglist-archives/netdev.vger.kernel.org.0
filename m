Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A395B65A9E1
	for <lists+netdev@lfdr.de>; Sun,  1 Jan 2023 12:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbjAALyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Jan 2023 06:54:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjAALye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Jan 2023 06:54:34 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18EE126D6
        for <netdev@vger.kernel.org>; Sun,  1 Jan 2023 03:54:32 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-47-bO43SgbmME2Zzinn1KAlyg-1; Sun, 01 Jan 2023 11:54:30 +0000
X-MC-Unique: bO43SgbmME2Zzinn1KAlyg-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Sun, 1 Jan
 2023 11:54:28 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.044; Sun, 1 Jan 2023 11:54:28 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Ping-Ke Shih' <pkshih@realtek.com>,
        "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "tehuang@realtek.com" <tehuang@realtek.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/4] rtw88: Add packed attribute to the eFuse structs
Thread-Topic: [PATCH 1/4] rtw88: Add packed attribute to the eFuse structs
Thread-Index: AQHZGsFtJHlbRNsmYUOpTa0F4ufSPq6EmMnggAOg+qCAALbHgIAAiEwg
Date:   Sun, 1 Jan 2023 11:54:28 +0000
Message-ID: <a86893f11fe64930897473a38226a9a8@AcuMS.aculab.com>
References: <20221228133547.633797-1-martin.blumenstingl@googlemail.com>
         <20221228133547.633797-2-martin.blumenstingl@googlemail.com>
         <92eb7dfa8b7d447e966a2751e174b642@realtek.com>
         <87da8c82dec749dc826b5a1b4c4238aa@AcuMS.aculab.com>
 <eee17e2f4e44a2f38021a839dc39fedc1c1a4141.camel@realtek.com>
In-Reply-To: <eee17e2f4e44a2f38021a839dc39fedc1c1a4141.camel@realtek.com>
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogUGluZy1LZSBTaGloDQo+IFNlbnQ6IDAxIEphbnVhcnkgMjAyMyAxMTo0Mg0KPiANCj4g
T24gU2F0LCAyMDIyLTEyLTMxIGF0IDE2OjU3ICswMDAwLCBEYXZpZCBMYWlnaHQgd3JvdGU6DQo+
ID4gRnJvbTogUGluZy1LZSBTaGloDQo+ID4gPiBTZW50OiAyOSBEZWNlbWJlciAyMDIyIDA5OjI1
DQo+ID4gPg0KPiA+ID4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+ID4gPiBGcm9t
OiBNYXJ0aW4gQmx1bWVuc3RpbmdsIDxtYXJ0aW4uYmx1bWVuc3RpbmdsQGdvb2dsZW1haWwuY29t
Pg0KPiA+ID4gPiBTZW50OiBXZWRuZXNkYXksIERlY2VtYmVyIDI4LCAyMDIyIDk6MzYgUE0NCj4g
PiA+ID4gVG86IGxpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVsLm9yZw0KPiA+ID4gPiBDYzogdG9u
eTA2MjBlbW1hQGdtYWlsLmNvbTsga3ZhbG9Aa2VybmVsLm9yZzsgUGluZy1LZSBTaGloIDxwa3No
aWhAcmVhbHRlay5jb20+Ow0KPiA+ID4gdGVodWFuZ0ByZWFsdGVrLmNvbTsNCj4gPiA+ID4gcy5o
YXVlckBwZW5ndXRyb25peC5kZTsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVs
QHZnZXIua2VybmVsLm9yZzsgTWFydGluDQo+ID4gPiA+IEJsdW1lbnN0aW5nbA0KPiA+ID4gPiA8
bWFydGluLmJsdW1lbnN0aW5nbEBnb29nbGVtYWlsLmNvbT4NCj4gPiA+ID4gU3ViamVjdDogW1BB
VENIIDEvNF0gcnR3ODg6IEFkZCBwYWNrZWQgYXR0cmlidXRlIHRvIHRoZSBlRnVzZSBzdHJ1Y3Rz
DQo+ID4gPiA+DQo+ID4gPiA+IFRoZSBlRnVzZSBkZWZpbml0aW9ucyBpbiB0aGUgcnR3ODggYXJl
IHVzaW5nIHN0cnVjdHMgdG8gZGVzY3JpYmUgdGhlDQo+ID4gPiA+IGVGdXNlIGNvbnRlbnRzLiBB
ZGQgdGhlIHBhY2tlZCBhdHRyaWJ1dGUgdG8gYWxsIHN0cnVjdHMgdXNlZCBmb3IgdGhlDQo+ID4g
PiA+IGVGdXNlIGRlc2NyaXB0aW9uIHNvIHRoZSBjb21waWxlciBkb2Vzbid0IGFkZCBnYXBzIG9y
IHJlLW9yZGVyDQo+ID4gPiA+IGF0dHJpYnV0ZXMuDQo+ID4gPiA+DQo+ID4gPiA+IEFsc28gY2hh
bmdlIHRoZSB0eXBlIG9mIHRoZSByZXMyLi5yZXMzIGVGdXNlIGZpZWxkcyB0byB1MTYgdG8gYXZv
aWQgdGhlDQo+ID4gPiA+IGZvbGxvd2luZyB3YXJuaW5nLCBub3cgdGhhdCB0aGVpciBzdXJyb3Vu
ZGluZyBzdHJ1Y3QgaGFzIHRoZSBwYWNrZWQNCj4gPiA+ID4gYXR0cmlidXRlOg0KPiA+ID4gPiAg
IG5vdGU6IG9mZnNldCBvZiBwYWNrZWQgYml0LWZpZWxkICdyZXMyJyBoYXMgY2hhbmdlZCBpbiBH
Q0MgNC40DQo+ID4gPiA+DQo+ID4gPiA+IEZpeGVzOiBlMzAzNzQ4NWM2OGUgKCJydHc4ODogbmV3
IFJlYWx0ZWsgODAyLjExYWMgZHJpdmVyIikNCj4gPiA+ID4gRml4ZXM6IGFiMGEwMzFlY2YyOSAo
InJ0dzg4OiA4NzIzZDogQWRkIHJlYWRfZWZ1c2UgdG8gcmVjb2duaXplIGVmdXNlIGluZm8gZnJv
bSBtYXAiKQ0KPiA+ID4gPiBGaXhlczogNzY5YTI5Y2UyYWY0ICgicnR3ODg6IDg4MjFjOiBhZGQg
YmFzaWMgZnVuY3Rpb25zIikNCj4gPiA+ID4gRml4ZXM6IDg3Y2FlZWYwMzJmYyAoIndpZmk6IHJ0
dzg4OiBBZGQgcnR3ODcyM2R1IGNoaXBzZXQgc3VwcG9ydCIpDQo+ID4gPiA+IEZpeGVzOiBhZmY1
ZmZkNzE4ZGUgKCJ3aWZpOiBydHc4ODogQWRkIHJ0dzg4MjFjdSBjaGlwc2V0IHN1cHBvcnQiKQ0K
PiA+ID4gPiBTaWduZWQtb2ZmLWJ5OiBNYXJ0aW4gQmx1bWVuc3RpbmdsIDxtYXJ0aW4uYmx1bWVu
c3RpbmdsQGdvb2dsZW1haWwuY29tPg0KPiA+ID4gPiAtLS0NCj4gPiA+ID4gIGRyaXZlcnMvbmV0
L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvbWFpbi5oICAgICB8ICA2ICsrKy0tLQ0KPiA+ID4gPiAg
ZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9ydHc4NzIzZC5oIHwgIDYgKysrLS0t
DQo+ID4gPiA+ICBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3J0dzg4MjFjLmgg
fCAyMCArKysrKysrKystLS0tLS0tLS0tDQo+ID4gPiA+ICBkcml2ZXJzL25ldC93aXJlbGVzcy9y
ZWFsdGVrL3J0dzg4L3J0dzg4MjJiLmggfCAyMCArKysrKysrKystLS0tLS0tLS0tDQo+ID4gPiA+
ICBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3J0dzg4MjJjLmggfCAyMCArKysr
KysrKystLS0tLS0tLS0tDQo+ID4gPiA+ICA1IGZpbGVzIGNoYW5nZWQsIDM2IGluc2VydGlvbnMo
KyksIDM2IGRlbGV0aW9ucygtKQ0KPiA+ID4gPg0KPiA+ID4NCj4gPiA+IFsuLi5dDQo+ID4gPg0K
PiA+ID4gPiBAQCAtNDMsMTMgKzQzLDEzIEBAIHN0cnVjdCBydHc4ODIxY2VfZWZ1c2Ugew0KPiA+
ID4gPiAgCXU4IGxpbmtfY2FwWzRdOw0KPiA+ID4gPiAgCXU4IGxpbmtfY29udHJvbFsyXTsNCj4g
PiA+ID4gIAl1OCBzZXJpYWxfbnVtYmVyWzhdOw0KPiA+ID4gPiAtCXU4IHJlczA6MjsJCQkvKiAw
eGY0ICovDQo+ID4gPiA+IC0JdTggbHRyX2VuOjE7DQo+ID4gPiA+IC0JdTggcmVzMToyOw0KPiA+
ID4gPiAtCXU4IG9iZmY6MjsNCj4gPiA+ID4gLQl1OCByZXMyOjM7DQo+ID4gPiA+IC0JdTggb2Jm
Zl9jYXA6MjsNCj4gPiA+ID4gLQl1OCByZXMzOjQ7DQo+ID4gPiA+ICsJdTE2IHJlczA6MjsJCQkv
KiAweGY0ICovDQo+ID4gPiA+ICsJdTE2IGx0cl9lbjoxOw0KPiA+ID4gPiArCXUxNiByZXMxOjI7
DQo+ID4gPiA+ICsJdTE2IG9iZmY6MjsNCj4gPiA+ID4gKwl1MTYgcmVzMjozOw0KPiA+ID4gPiAr
CXUxNiBvYmZmX2NhcDoyOw0KPiA+ID4gPiArCXUxNiByZXMzOjQ7DQo+ID4gPg0KPiA+ID4gVGhl
c2Ugc2hvdWxkIGJlIF9fbGUxNi4gVGhvdWdoIGJpdCBmaWVsZHMgYXJlIHN1aXRhYmxlIHRvIGVm
dXNlIGxheW91dCwNCj4gPiA+IHdlIGRvbid0IGFjY2VzcyB0aGVzZSBmaWVsZHMgZm9yIG5vdy4g
SXQgd291bGQgYmUgd2VsbC4NCj4gDQo+IFVoLiBJIHR5cG8gdGhlIHNlbnRlbmNlLiBPcmlnaW5h
bGx5LCBJIHdvdWxkIGxpa2UgdG8gdHlwZQ0KPiAiLi4uYml0IGZpZWxkcyBhcmUgTk9UIHN1aXRh
YmxlLi4uIi4NCj4gDQo+IEluIHRoaXMgZHJpdmVyLCBlZnVzZSBpcyByZWFkIGludG8gYSB1OCBh
cnJheSwgYW5kIGNhc3QgdG8gdGhpcyBzdHJ1Y3QNCj4gcG9pbnRlciB0byBhY2Nlc3MgdGhlIGZp
ZWxkLg0KDQpUaGVuIGRlZmluZSBpdCBhcyBzdWNoLg0KVGhlIDE2Yml0IGVuZGlhbm5lc3MgYW5k
IGJpdC1vcmRlciBkZXBlbmRhbnQgYml0ZmllbGRzIHNlcnZlDQpubyBwdXJwb3NlLiANCg0KPiA+
IElJUkMgdGhlIGFzc2lnbm1lbnQgb2YgYWN0dWFsIGJpdHMgdG8gYml0LWZpZWxkcyBpcyAoYXQg
YmVzdCkNCj4gPiBhcmNoaXRlY3R1cmFsbHkgZGVmaW5lZCAtIHNvIGlzbid0IHJlYWxseSBzdWl0
YWJsZSBmb3IgYW55dGhpbmcNCj4gPiB3aGVyZSB0aGUgYml0cyBoYXZlIHRvIG1hdGNoIGEgcG9y
dGFibGUgbWVtb3J5IGJ1ZmZlci4NCj4gPiBUaGUgYml0IGFsbG9jYXRpb24gaXNuJ3QgdGllZCB0
byB0aGUgYnl0ZSBlbmRpYW5uZXNzLg0KPiANCj4gWWVzLCB0aGlzIGtpbmQgb2Ygc3RydWN0IGhh
cyBlbmRpYW4gcHJvYmxlbS4gRm9ydHVuYXRlbHksIHdlIGRvbid0DQo+IGFjdHVhbGx5IGFjY2Vz
cyB2YWx1ZXMgdmlhIGJpdCBmaWVsZHMuDQo+IA0KPiA+DQo+ID4gVG8gZ2V0IGFuIGV4cGxpY2l0
IGxheW91dCB5b3UgaGF2ZSB0byBkbyBleHBsaWNpdCBtYXNraW5nLg0KPiANCj4gSWYgd2UgYWN0
dWFsbHkgd2FudCB0byBhY2Nlc3MgdGhlc2UgdmFsdWVzLCB3ZSB3aWxsIGRlZmluZSBtYXNrcw0K
PiBhbmQgdXNlIHt1OCxfbGUxNixsZTMyfV9nZXRfYml0cygpIG9yIGJhcmUgJyYnIGJpdCBvcGVy
YXRpb24gdG8gYWNjZXNzDQo+IHRoZW0uDQoNCkJ1dCB5b3UgY2FuJ3QgdGFrZSB0aGUgYWRkcmVz
cyBvZiBiaXRmaWVsZCBtZW1iZXJzLg0KRGVmaW5lIHRoZSBkYXRhIHByb3Blcmx5Lg0KDQo+ID4N
Cj4gPiBZb3UgYWxzbyBkb24ndCBuZWVkIF9fcGFja2VkIHVubGVzcyB0aGUgJ25hdHVyYWwnIGFs
aWdubWVudA0KPiA+IG9mIGZpZWxkcyB3b3VsZCBuZWVkIGdhcHMgb3IgdGhlIGFjdHVhbCBzdHJ1
Y3R1cmUgaXRzZWxmIG1pZ2h0DQo+ID4gYmUgbWlzYWxpZ25lZCBpbiBtZW1vcnkuDQo+ID4gV2hp
bGUgQyBjb21waWxlcnMgYXJlIGFsbG93ZWQgdG8gYWRkIGFyYml0cmFyeSBwYWRkaW5nIHRoZSBM
aW51eCBrZXJuZWwNCj4gPiByZXF1aXJlcyB0aGF0IHRoZXkgZG9uJ3QuDQo+ID4gSSdtIGFsc28g
cHJldHR5IHN1cmUgdGhhdCBjb21waWxlcnMgYXJlIG5vdCBhbGxvd2VkIHRvIHJlb3JkZXIgZmll
bGRzLg0KPiA+DQo+ID4gU3BlY2lmeWluZyBfX3BhY2tlZCBjYW4gYWRkIGNvbnNpZGVyYWJsZSBy
dW4tdGltZSAoYW5kIGNvZGUgc2l6ZSkNCj4gPiBvdmVyaGVhZCBvbiBzb21lIGFyY2hpdGVjdHVy
ZXMgLSBpdCBzaG91bGQgb25seSBiZSB1c2VkIGlmIGFjdHVhbGx5DQo+ID4gbmVlZGVkLg0KPiA+
DQo+IA0KPiBVbmRlcnN0b29kLiBXZSBvbmx5IGFkZCBfX3BhY2tlZCB0byB0aGUgc3RydWN0IHdo
aWNoIGlzIHVzZWQgdG8NCj4gYWNjZXNzIHByZWRlZmluZWQgZm9ybWF0LCBsaWtlIGVmdXNlIGNv
bnRlbnQgZGVmaW5lZCBieSB2ZW5kb3IuDQoNCk5vIC0gdGhhdCBkb2Vzbid0IG1lYW4geW91IG5l
ZWQgdG8gdXNlIF9fcGFja2VkLg0KSXQgZG9lcyBtZWFuIHRoYXQgeW91IHNob3VsZG4ndCB1c2Ug
Yml0ZmllbGRzLg0KTG9vayBhdCBhbGwgdGhlIGhhcmR3YXJlIGRyaXZlcnMsIHRoZXkgdXNlIHN0
cnVjdHMgdG8gbWFwIGRldmljZQ0KcmVnaXN0ZXJzIGFuZCBhYnNvbHV0ZWx5IHJlcXVpcmUgdGhl
IGNvbXBpbGUgbm90IGFkZCBwYWRkaW5nLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRy
ZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1L
MSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

