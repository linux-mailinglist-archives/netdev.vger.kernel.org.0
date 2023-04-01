Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE2036D3315
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 20:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjDASVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 14:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjDASVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 14:21:01 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999EF1A96A
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 11:20:59 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-109-PIpW_n9fObuDPrn_DKoLWg-1; Sat, 01 Apr 2023 19:20:57 +0100
X-MC-Unique: PIpW_n9fObuDPrn_DKoLWg-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Sat, 1 Apr
 2023 19:20:55 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Sat, 1 Apr 2023 19:20:55 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Dumazet' <edumazet@google.com>,
        Alexander Lobakin <aleksander.lobakin@intel.com>
CC:     Arnd Bergmann <arnd@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        "Jason Xing" <kerneljasonxing@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: netcp: MAX_SKB_FRAGS is now 'int'
Thread-Topic: [PATCH] net: netcp: MAX_SKB_FRAGS is now 'int'
Thread-Index: AQHZY/INR0Ls8ZWFPEGBAKU08KSVVa8WxH4g
Date:   Sat, 1 Apr 2023 18:20:54 +0000
Message-ID: <5c940a6c29674b2986e4e9be1c2e4b39@AcuMS.aculab.com>
References: <20230331074919.1299425-1-arnd@kernel.org>
 <8dd0ab75-d007-8aa7-e546-c5fe93f9e03b@intel.com>
 <CANn89iLcgesDzLvvoAhDSFgmKz_1VcMNOTA=F8rDXzLmOSuTvw@mail.gmail.com>
In-Reply-To: <CANn89iLcgesDzLvvoAhDSFgmKz_1VcMNOTA=F8rDXzLmOSuTvw@mail.gmail.com>
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
X-Spam-Status: No, score=0.0 required=5.0 tests=RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRXJpYyBEdW1hemV0DQo+IFNlbnQ6IDMxIE1hcmNoIDIwMjMgMTc6NTgNCi4uLi4NCj4g
PiBJJ2QgcGVyc29uYWxseSBkZWZpbmUgJU1BWF9TS0JfRlJBR1MgYXMgYCh1MzIpQ09ORklHX01B
WF9TS0JfRlJBR1NgLg0KPiA+IEl0IGNhbid0IGJlIGJlbG93IHplcm8gb3IgYWJvdmUgJVUzMl9N
QVggYW5kIHdlIGhhdmUgdG8gZGVmaW5lIGl0DQo+ID4gbWFudWFsbHkgYW55d2F5LCBzbyB3aHkg
bm90IGNhc3QgdG8gdGhlIHR5cGUgZXhwZWN0ZWQgZnJvbSBpdCA6RA0KPiA+DQo+IA0KPiBTb21l
IGZpbGVzIGhhdmUgdGhlIGFzc3VtcHRpb24gTUFYX1NLQl9GUkFHUyBjYW4gYmUgdW5kZXJzdG9v
ZCBieSB0aGUNCj4gQyBwcmVwcm9jZXNzb3IuDQo+IA0KPiAjaWYgTUFYX1NLQl9GUkFHUyA+IDMy
DQoNCi4uLg0KDQpZb3UgY291bGQgdXNlOg0KI2RlZmluZSBNQVhfU0tCX0ZSQUdTIChDT05GSUdf
TUFYX1NLQl9GUkFHUyArIDB1KQ0KdG8gZm9yY2UgdGhlIHR5cGUgdG8gYmUgJ3Vuc2lnbmVkIGlu
dCcgd2hpbGUgc3RpbGwgbGVhdmluZw0KYSB2YWx1ZSB0aGF0IGNwcCBncm9rcy4NCihPciBhZGQg
MHVsIHRvIGdldCB0aGUgdHlwZSBiYWNrPyB0byAndW5zaWduZWQgbG9uZycuKQ0KDQoJRGF2aWQN
Cg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZh
cm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYg
KFdhbGVzKQ0K

