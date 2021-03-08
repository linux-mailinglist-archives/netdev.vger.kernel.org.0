Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE62F33101C
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 14:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbhCHN4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 08:56:15 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:46212 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230272AbhCHNzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 08:55:14 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-78-9v-ZWzc2NtaRpvNO-H1ysQ-1; Mon, 08 Mar 2021 13:53:06 +0000
X-MC-Unique: 9v-ZWzc2NtaRpvNO-H1ysQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 8 Mar 2021 13:53:05 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 8 Mar 2021 13:53:05 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Alex Elder' <elder@linaro.org>,
        "subashab@codeaurora.org" <subashab@codeaurora.org>,
        "stranche@codeaurora.org" <stranche@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "sharathv@codeaurora.org" <sharathv@codeaurora.org>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        "evgreen@chromium.org" <evgreen@chromium.org>,
        "cpratapa@codeaurora.org" <cpratapa@codeaurora.org>,
        "elder@kernel.org" <elder@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v2 5/6] net: qualcomm: rmnet: don't use C
 bit-fields in rmnet checksum trailer
Thread-Topic: [PATCH net-next v2 5/6] net: qualcomm: rmnet: don't use C
 bit-fields in rmnet checksum trailer
Thread-Index: AQHXEjcvEK7MzxmURkq987v/iEpZqap54riQgAA5xoCAAAJq8A==
Date:   Mon, 8 Mar 2021 13:53:05 +0000
Message-ID: <a2954816677f4ae1b27e4cb8e38da0a1@AcuMS.aculab.com>
References: <20210306031550.26530-1-elder@linaro.org>
 <20210306031550.26530-6-elder@linaro.org>
 <ebe1bf51902e49458cfdd685790c4350@AcuMS.aculab.com>
 <956ca2dd-d15e-ce40-e3b4-56b0f5bf2154@linaro.org>
In-Reply-To: <956ca2dd-d15e-ce40-e3b4-56b0f5bf2154@linaro.org>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Li4uDQo+ID4+IC0JaWYgKCFjc3VtX3RyYWlsZXItPnZhbGlkKSB7DQo+ID4+ICsJaWYgKCF1OF9n
ZXRfYml0cyhjc3VtX3RyYWlsZXItPmZsYWdzLCBNQVBfQ1NVTV9ETF9WQUxJRF9GTUFTSykpIHsN
Cj4gPg0KPiA+IElzIHRoYXQganVzdCBhbiBvdmVyY29tcGxpY2F0ZWQgd2F5IG9mIHNheWluZzoN
Cj4gPiAJaWYgKCEoY3N1bV90cmFpbGVyLT5mbGFncyAmIE1BUF9DU1VNX0RMX1ZBTElEX0ZNQVNL
KSkgew0KPiANCj4gWWVzIGl0IGlzLiAgSSBkZWZpbmVkIGFuZCB1c2VkIGFsbCB0aGUgZmllbGQg
bWFza3MgaW4gYQ0KPiBjb25zaXN0ZW50IHdheSwgYnV0IEkgZG8gdGhpbmsgaXQgd2lsbCByZWFk
IGJldHRlciB0aGUNCj4gd2F5IHlvdSBzdWdnZXN0LiAgQmpvcm4gYWxzbyBhc2tlZCBtZSBwcml2
YXRlbHkgd2hldGhlcg0KPiBHRU5NQVNLKDE1LCAxNSkgd2FzIGp1c3QgdGhlIHNhbWUgYXMgQklU
KDE1KSAoaXQgaXMpLg0KPiANCj4gSSB3aWxsIHBvc3QgdmVyc2lvbiAzIG9mIHRoZSBzZXJpZXMs
IGlkZW50aWZ5aW5nIHdoaWNoDQo+IGZpZWxkcyBhcmUgc2luZ2xlIGJpdC9Cb29sZWFuLiAgRm9y
IHRob3NlIEkgd2lsbCBkZWZpbmUNCj4gdGhlIHZhbHVlIHVzaW5nIEJJVCgpIGFuZCB3aWxsIHNl
dC9leHRyYWN0IHVzaW5nIHNpbXBsZQ0KPiBBTkQvT1Igb3BlcmF0b3JzLiAgSSB3b24ndCB1c2Ug
dGhlIF9GTUFTSyBzdWZmaXggb24gc3VjaA0KPiBmaWVsZHMuDQoNCkV2ZW4gZm9yIHRoZSBjaGVj
a3N1bSBvZmZzZXQgYSBzaW1wbGUgJ29mZnNldCA8PCBDT05TVEFOVCcNCmlzIGVub3VnaC4NCklm
IGl0IGlzIHRoZSBib3R0b20gYml0cyB0aGVuIGV2ZW4gdGhhdCBpc24ndCByZWFsbHkgbmVlZGVk
Lg0KWW91IG1pZ2h0IHdhbnQgdG8gbWFzayBvZmYgaGlnaCBiaXRzIC0gYnV0IHRoYXQgaXMgYW4g
ZXJyb3INCnBhdGggdGhhdCBuZWVkcyB0byBoYXZlIGJlZW4gY2hlY2tlZCBlYXJsaWVyLg0KDQoJ
RGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1v
dW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEz
OTczODYgKFdhbGVzKQ0K

