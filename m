Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96DCF65E6DE
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 09:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbjAEIeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 03:34:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbjAEIes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 03:34:48 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CEFA4C714
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 00:34:44 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-108-6ZLZ5sXtNqe3xnp3-GeDRg-1; Thu, 05 Jan 2023 08:34:41 +0000
X-MC-Unique: 6ZLZ5sXtNqe3xnp3-GeDRg-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Thu, 5 Jan
 2023 08:34:40 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.044; Thu, 5 Jan 2023 08:34:40 +0000
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
Thread-Index: AQHZGsFtJHlbRNsmYUOpTa0F4ufSPq6EmMnggAOg+qCAALbHgIAAiEwggAT0j0eAAALd0IAAB5IAgAADjxCAABjCgIAA9scQ
Date:   Thu, 5 Jan 2023 08:34:40 +0000
Message-ID: <4c4551c787ee4fc9ac40b34707d7365a@AcuMS.aculab.com>
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
 <662e2f820e7a478096dd6e09725c093a@AcuMS.aculab.com>
 <CAFBinCCTa47SRjNHbMB3t2zjiE5Vh1ZQrgT3G38g9g_-mzvh6w@mail.gmail.com>
In-Reply-To: <CAFBinCCTa47SRjNHbMB3t2zjiE5Vh1ZQrgT3G38g9g_-mzvh6w@mail.gmail.com>
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

RnJvbTogTWFydGluIEJsdW1lbnN0aW5nbA0KPiBTZW50OiAwNCBKYW51YXJ5IDIwMjMgMTc6NDkN
Cj4gDQo+IE9uIFdlZCwgSmFuIDQsIDIwMjMgYXQgNTozMSBQTSBEYXZpZCBMYWlnaHQgPERhdmlk
LkxhaWdodEBhY3VsYWIuY29tPiB3cm90ZToNCj4gWy4uLl0NCj4gPiA+ID4gV2hhdCB5b3UgbWF5
IHdhbnQgdG8gZG8gaXMgYWRkIGNvbXBpbGUtdGltZSBhc3NlcnRzIGZvciB0aGUNCj4gPiA+ID4g
c2l6ZXMgb2YgdGhlIHN0cnVjdHVyZXMuDQo+ID4gPiBEbyBJIGdldCB5b3UgcmlnaHQgdGhhdCBz
b21ldGhpbmcgbGlrZToNCj4gPiA+ICAgQlVJTERfQlVHX09OKHNpemVvZihydHc4ODIxY19lZnVz
ZSkgIT0gMjU2KTsNCj4gPiA+IGlzIHdoYXQgeW91IGhhdmUgaW4gbWluZD8NCj4gPg0KPiA+IFRo
YXQgbG9va3MgbGlrZSB0aGUgb25lLi4uDQo+IEkgdHJpZWQgdGhpcyAoc2VlIHRoZSBhdHRhY2hl
ZCBwYXRjaCAtIGl0J3MganVzdCBtZWFudCB0byBzaG93IHdoYXQgSQ0KPiBkaWQsIGl0J3Mgbm90
IG1lYW50IHRvIGJlIGFwcGxpZWQgdXBzdHJlYW0pLg0KPiBXaXRoIHRoZSBhdHRhY2hlZCBwYXRj
aCBidXQgbm8gb3RoZXIgcGF0Y2hlcyB0aGlzIG1ha2VzIHRoZSBydHc4OA0KPiBkcml2ZXIgY29t
cGlsZSBmaW5lIG9uIDYuMi1yYzIuDQo+IA0KPiBBZGRpbmcgX19wYWNrZWQgdG8gc3RydWN0IHJ0
dzg3MjNkX2VmdXNlIGNoYW5nZXMgdGhlIHNpemUgb2YgdGhhdA0KPiBzdHJ1Y3QgZm9yIG1lIChJ
J20gY29tcGlsaW5nIGZvciBBQXJjaDY0IC8gQVJNNjQpLg0KPiBXaXRoIHRoZSBwYWNrZWQgYXR0
cmlidXRlIGl0IGhhcyAyNjcgYnl0ZXMsIHdpdGhvdXQgMjY4IGJ5dGVzLg0KPiANCj4gRG8geW91
IGhhdmUgYW55IGlkZWFzIGFzIHRvIHdoeSB0aGF0IGlzPw0KDQpUYWlsIHBhZGRpbmcgLSB5b3Ug
d29uJ3QgZ2V0IGFuIG9kZCBsZW5ndGggZm9yIGEgc3RydWN0dXJlDQp0aGF0IGNvbnRhaW5zIGEg
MTZiaXQgaXRlbS4NCg0KT1RPSCBJIGRvdWJ0IHlvdSBjYXJlIGFib3V0IHRoZSBzaXplIG9mIHRo
YXQgc3RydWN0dXJlLCBqdXN0DQp0aGUgb2Zmc2V0IG9mIHRoZSB1bmlvbiBhbmQgdGhlIHNpemVz
IG9mIHRoZSB1bmlvbiBtZW1iZXJzLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNz
IExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAx
UFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

