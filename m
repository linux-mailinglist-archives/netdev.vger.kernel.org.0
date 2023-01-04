Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92CB165D798
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 16:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234743AbjADPx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 10:53:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239740AbjADPxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 10:53:24 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 869FE1B9FA
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 07:53:22 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-214-KAuNDI3RMASqYXJv9H9bbQ-1; Wed, 04 Jan 2023 15:53:19 +0000
X-MC-Unique: KAuNDI3RMASqYXJv9H9bbQ-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 4 Jan
 2023 15:53:17 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.044; Wed, 4 Jan 2023 15:53:17 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Martin Blumenstingl' <martin.blumenstingl@googlemail.com>,
        Ping-Ke Shih <pkshih@realtek.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "tehuang@realtek.com" <tehuang@realtek.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/4] rtw88: Add packed attribute to the eFuse structs
Thread-Topic: [PATCH 1/4] rtw88: Add packed attribute to the eFuse structs
Thread-Index: AQHZGsFtJHlbRNsmYUOpTa0F4ufSPq6EmMnggAOg+qCAALbHgIAAiEwggAT0j0eAAALd0A==
Date:   Wed, 4 Jan 2023 15:53:17 +0000
Message-ID: <ec6a0988f3f943128e0122d50959185a@AcuMS.aculab.com>
References: <20221228133547.633797-1-martin.blumenstingl@googlemail.com>
 <20221228133547.633797-2-martin.blumenstingl@googlemail.com>
 <92eb7dfa8b7d447e966a2751e174b642@realtek.com>
 <87da8c82dec749dc826b5a1b4c4238aa@AcuMS.aculab.com>
 <eee17e2f4e44a2f38021a839dc39fedc1c1a4141.camel@realtek.com>
 <a86893f11fe64930897473a38226a9a8@AcuMS.aculab.com>
 <5c0c77240e7ddfdffbd771ee7e50d36ef3af9c84.camel@realtek.com>
 <CAFBinCC+1jGJx1McnBY+kr3RTQ-UpxW6JYNpHzStUTredDuCug@mail.gmail.com>
In-Reply-To: <CAFBinCC+1jGJx1McnBY+kr3RTQ-UpxW6JYNpHzStUTredDuCug@mail.gmail.com>
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

RnJvbTogTWFydGluIEJsdW1lbnN0aW5nbA0KPiBTZW50OiAwNCBKYW51YXJ5IDIwMjMgMTU6MzAN
Cj4gDQo+IEhpIFBpbmctS2UsIEhpIERhdmlkLA0KPiANCj4gT24gU3VuLCBKYW4gMSwgMjAyMyBh
dCAyOjA5IFBNIFBpbmctS2UgU2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPiB3cm90ZToNCj4gWy4u
Ll0NCj4gPiBZZXMsIGl0IHNob3VsZCBub3QgdXNlIGJpdCBmaWxlZC4gSW5zdGVhZCwgdXNlIGEg
X19sZTE2IGZvciBhbGwgZmllbGRzLCBzdWNoIGFzDQo+IEkgdGhpbmsgdGhpcyBjYW4gYmUgZG9u
ZSBpbiBhIHNlcGFyYXRlIHBhdGNoLg0KPiBNeSB2MiBvZiB0aGlzIHBhdGNoIGhhcyByZWR1Y2Vk
IHRoZXNlIGNoYW5nZXMgdG8gYSBtaW5pbXVtLCBzZWUgWzBdDQo+IA0KPiBbLi4uXQ0KPiA+IHN0
cnVjdCBydHc4ODIxY2VfZWZ1c2Ugew0KPiA+ICAgIC4uLg0KPiA+ICAgIHU4IGRhdGExOyAgICAg
ICAvLyBvZmZzZXQgMHgxMDANCj4gPiAgICBfX2xlMTYgZGF0YTI7ICAgLy8gb2Zmc2V0IDB4MTAx
LTB4MTAyDQo+ID4gICAgLi4uDQo+ID4gfSBfX3BhY2tlZDsNCj4gPg0KPiA+IFdpdGhvdXQgX19w
YWNrZWQsIGNvbXBpbGVyIGNvdWxkIGhhcyBwYWQgYmV0d2VlbiBkYXRhMSBhbmQgZGF0YTIsDQo+
ID4gYW5kIHRoZW4gZ2V0IHdyb25nIHJlc3VsdC4NCj4gTXkgdW5kZXJzdGFuZGluZyBpcyB0aGF0
IHRoaXMgaXMgdGhlIHJlYXNvbiB3aHkgd2UgbmVlZCBfX3BhY2tlZC4NCg0KVHJ1ZSwgYnV0IGRv
ZXMgaXQgcmVhbGx5IGhhdmUgdG8gbG9vayBsaWtlIHRoYXQ/DQpJIGNhbid0IGZpbmQgdGhhdCB2
ZXJzaW9uIChJIGRvbid0IGhhdmUgYSBuZXRfbmV4dCB0cmVlKS4NClBvc3NpYmx5IGl0IHNob3Vs
ZCBiZSAndTggZGF0YTJbMl07Jw0KDQpNb3N0IGhhcmR3YXJlIGRlZmluaXRpb25zIGFsaWduIGV2
ZXJ5dGhpbmcuDQoNCldoYXQgeW91IG1heSB3YW50IHRvIGRvIGlzIGFkZCBjb21waWxlLXRpbWUg
YXNzZXJ0cyBmb3IgdGhlDQpzaXplcyBvZiB0aGUgc3RydWN0dXJlcy4NCg0KUmVtZW1iZXIgdGhh
dCBpZiB5b3UgaGF2ZSAxNi8zMiBiaXQgZmllbGRzIGluIHBhY2tlZCBzdHJ1Y3R1cmVzDQpvbiBz
b21lIGFyY2hpdGVjdHVyZXMgdGhlIGNvbXBpbGUgaGFzIHRvIGdlbmVyYXRlIGNvZGUgdGhhdCBk
b2VzDQpieXRlIGxvYWRzIGFuZCBzaGlmdHMuDQoNClRoZSAnbWlzYWxpZ25lZCcgcHJvcGVydHkg
aXMgbG9zdCB3aGVuIHlvdSB0YWtlIHRoZSBhZGRyZXNzIC0gc28NCnlvdSBjYW4gZWFzaWx5IGdl
bmVyYXRlIGEgZmF1bHQuDQoNCkFkZGluZyBfX3BhY2tlZCB0byBhIHN0cnVjdCBpcyBhIHNsZWRn
ZWhhbW1lciB5b3UgcmVhbGx5IHNob3VsZG4ndCBuZWVkLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0
ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBL
ZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

