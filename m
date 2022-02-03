Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBFF4A8BBB
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 19:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353522AbiBCShX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 13:37:23 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:37101 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234230AbiBCShW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 13:37:22 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-274-M1TI04j4Ms25d2Ls78umWg-1; Thu, 03 Feb 2022 18:37:20 +0000
X-MC-Unique: M1TI04j4Ms25d2Ls78umWg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Thu, 3 Feb 2022 18:37:19 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Thu, 3 Feb 2022 18:37:18 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Dan Williams' <dcbw@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>
Subject: RE: Getting the IPv6 'prefix_len' for DHCP6 assigned addresses.
Thread-Topic: Getting the IPv6 'prefix_len' for DHCP6 assigned addresses.
Thread-Index: AdgYVDaKcmxvhRE6TKuESvE9KYEi9QAEiiiAAAc+UwAAIoxEAAAHhZbg
Date:   Thu, 3 Feb 2022 18:37:18 +0000
Message-ID: <b3d1e478fb02420ab6414e889fd10259@AcuMS.aculab.com>
References: <58dfe4b57faa4ead8a90c3fe924850c2@AcuMS.aculab.com>
         <7c6ddb66d278cbf7c946994605cbd3c57f3a2508.camel@redhat.com>
         <dc141b3c07fa4d51ad48ac87718f7c98@AcuMS.aculab.com>
 <f3c5248cd47dd38fbd215d13e430ff184df2b8d9.camel@redhat.com>
In-Reply-To: <f3c5248cd47dd38fbd215d13e430ff184df2b8d9.camel@redhat.com>
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

RnJvbTogRGFuIFdpbGxpYW1zDQo+IFNlbnQ6IDAzIEZlYnJ1YXJ5IDIwMjIgMTQ6NTINCj4gPiA+
IE9uIFdlZCwgMjAyMi0wMi0wMiBhdCAxNjo1OCArMDAwMCwgRGF2aWQgTGFpZ2h0IHdyb3RlOg0K
PiA+ID4gPiBJJ20gdHJ5aW5nIHRvIHdvcmsgb3V0IGhvdyBESENQNiBpcyBzdXBwb3NlZCB0byB3
b3JrLg0KPiA+ID4gPg0KPiA+ID4gPiBJJ3ZlIGEgdGVzdCBuZXR3b3JrIHdpdGggdGhlIElTQyBk
aGNwNiBzZXJ2ZXIgYW5kIHJhZHZkIHJ1bm5pbmcuDQo+ID4gPiA+IElmIEkgZW5hYmxlICdhdXRv
Y29uZicgSSBnZXQgYSBuaWNlIGFkZHJlc3Mgd2l0aCB0aGUgcHJlZml4IGZyb20NCj4gPiA+ID4g
cmFkdmQgYW5kIHRoZSBsYXN0IDggYnl0ZXMgZnJvbSBteSBtYWMgYWRkcmVzcywgcHJlZml4X2xl
biA2NC4NCj4gPiA+ID4gSSBnZXQgYSBuaWNlIGFkZHJlc3MgZnJvbSBkaGNwNiAoYnVzeWJveCB1
ZGhjcGM2KSB3aXRoIHRoZSBzYW1lDQo+ID4gPiA+IHByZWZpeC4NCg0KVG9kYXkgaXQgd2FzIHdv
cmtpbmcuDQpOb3Qgc3VyZSB3aGF0IHdhcyBnb2luZyBvbiBsYXN0IHRpbWUgSSB0cmllZC4NCg0K
QnV0IEkgZG8gaGF2ZSB0byBsb29rIHZlcnkgaGFyZCB0byBmaW5kIHRoZSBJUHY2IHJvdXRlcy4N
ClJ1bm5pbmc6DQogICBpcCByb3V0ZSBzaG93IHRhYmxlIGFsbA0KZG9lcyBnaXZlIHRoZW0sIGJ1
dCBub3RoaW5nIGVsc2Ugc2VlbXMgdG8uDQoNClRoZSBidXN5Ym94IG5ldHN0YXQgZG9lc24ndCBn
cm9rIC02Lg0KQnV0IEkndmUgdGhlIGZ1bGwgdmVyc2lvbiBvZiAnaXAnIHRvIGdldCBuYW1lc3Bh
Y2Ugc3VwcG9ydC4NCg0KVGFsa2luZyBvZiBuYW1lc3BhY2VzLCBpcyBpdCBwb3NzaWJsZSB0byBt
b3VudCB0aGUgbmFtZXNwYWNlDQp2ZXJzaW9uIG9mIC9wcm9jL3N5cy9uZXQgc29tZXdoZXJlIGlu
IHRoZSBmaWxlc3lzdGVtPw0KSSd2ZSBnb3QgcHJvZ3JhbXMgdGhhdCByZWFsbHkgd2FudCB0byBv
cGVuIG5vZGVzIGluIHRoZQ0KJ2luaXQnIG5hbWVzcGFjZSBhbmQgYSBuYW1lZCBvbmUuDQoNCkkg
Y2FuIHVzZToNCglpcCBuZXRucyBleGVjIG5hbWVzcGFjZSBwcm9ncmFtIDM8L3Byb2Mvc3lzL25l
dCBhbmQNCnRoZW4gdXNlIG9wZW5hdCgzLCAicGF0aCIpIHRvIGdldCBpdGVtcyBpbiB0aGUgJ2lu
aXQnIG5hbWVzcGFjZS4NCkJ1dCBpdCBpcyBhIGJpdCBob3JyaWQuDQoNCglEYXZpZA0KDQotDQpS
ZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWls
dG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMp
DQo=

