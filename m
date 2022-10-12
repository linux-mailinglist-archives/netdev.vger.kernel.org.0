Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C60A5FCD66
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 23:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiJLVla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 17:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiJLVl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 17:41:29 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64B0AF88E6
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 14:41:28 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-189-uiSGPw9KOd-nHmHIeEtFFw-1; Wed, 12 Oct 2022 22:41:26 +0100
X-MC-Unique: uiSGPw9KOd-nHmHIeEtFFw-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Wed, 12 Oct
 2022 22:41:25 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.040; Wed, 12 Oct 2022 22:41:25 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Sergei Antonov' <saproj@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: RE: [PATCH v2 net] net: ftmac100: do not reject packets bigger than
 1514
Thread-Topic: [PATCH v2 net] net: ftmac100: do not reject packets bigger than
 1514
Thread-Index: AQHY3lCWEiTFPZdxBkKncwnj941AIq4K6mqQ///7b4CAAGEPQA==
Date:   Wed, 12 Oct 2022 21:41:25 +0000
Message-ID: <f05f9dd9b39f42d18df0018c3596d866@AcuMS.aculab.com>
References: <20221012153737.128424-1-saproj@gmail.com>
 <1b919195757c49769bde19c59a846789@AcuMS.aculab.com>
 <CABikg9zdg-WW+C-46Cy=gcgsd8ZEborOJkXOPUfxy9TmNEz_wg@mail.gmail.com>
In-Reply-To: <CABikg9zdg-WW+C-46Cy=gcgsd8ZEborOJkXOPUfxy9TmNEz_wg@mail.gmail.com>
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

RnJvbTogU2VyZ2VpIEFudG9ub3YNCj4gU2VudDogMTIgT2N0b2JlciAyMDIyIDE3OjQzDQo+IA0K
PiBPbiBXZWQsIDEyIE9jdCAyMDIyIGF0IDE5OjEzLCBEYXZpZCBMYWlnaHQgPERhdmlkLkxhaWdo
dEBhY3VsYWIuY29tPiB3cm90ZToNCj4gPg0KPiA+IEZyb206IFNlcmdlaSBBbnRvbm92DQo+ID4g
PiBTZW50OiAxMiBPY3RvYmVyIDIwMjIgMTY6MzgNCj4gPiA+DQo+ID4gPiBEZXNwaXRlIHRoZSBk
YXRhc2hlZXQgWzFdIHNheWluZyB0aGUgY29udHJvbGxlciBzaG91bGQgYWxsb3cgaW5jb21pbmcN
Cj4gPiA+IHBhY2tldHMgb2YgbGVuZ3RoID49MTUxOCwgaXQgb25seSBhbGxvd3MgcGFja2V0cyBv
ZiBsZW5ndGggPD0xNTE0Lg0KPiA+DQo+ID4gU2hvdWxkbid0IHRoYXQgYmUgPD0xNTE4IGFuZCA8
MTUxOCA/Pw0KPiANCj4gT2gsIHRoYW5rcyBmb3Igbm90aWNpbmcuIEJ1dCBzdGlsbCBpdCBzaG91
bGQgYmUgc2xpZ2h0bHkgZGlmZmVyZW50Og0KPiA8PSAxNTE4IGFuZCA8PTE1MTQNCj4gSGVyZSBp
cyBteSB0ZXN0IHJlc3VsdHMgb2YgZGlmZmVyZW50IHBhY2tldCBzaXplczoNCj4gcGFja2V0cyBv
ZiAxNTE4IC8gMTUxNyAvIDE1MTYgLyAxNTE1IGJ5dGVzIGRpZCBub3QgY29tZSB0byB0aGUgZHJp
dmVyDQo+IChiZWZvcmUgbXkgcGF0Y2gpDQo+IHBhY2tldHMgb2YgMTUxNCBhbmQgbGVzcyBieXRl
cyBkaWQgY29tZQ0KDQpJIGhhZCB0byBkb3VibGUgY2hlY2sgdGhlIGZyYW1lcyBzaXplcywgbm90
IHdyaXR0ZW4gYW4gZXRoZXJuZXQgZHJpdmVyDQpmb3IgbmVhcmx5IDMwIHllYXJzISBUaGVyZSBp
cyBhIG5pY2UgZGVzY3JpcHRpb24gdGhhdCBpcyA5MCUgYWNjdXJhdGUNCmF0IGh0dHBzOi8vZW4u
d2lraXBlZGlhLm9yZy93aWtpL0V0aGVybmV0X2ZyYW1lDQoNCldpdGhvdXQgYW4gODAyLjFRIHRh
ZyAocHJvYmFibHkgYSBWTEFOIHRhZz8pIHRoZSBtYXggZnJhbWUgaGFzDQoxNTE0IGRhdGEgYnl0
ZXMgKGluYyBtYWMgYWRkcmVzc2VzLCBidXQgZXhjbCBjcmMpLg0KVW5sZXNzIHlvdSBhcmUgdXNp
bmcgVkxBTnMgdGhhdCBzaG91bGQgYmUgdGhlIGZyYW1lIGxpbWl0Lg0KVGhlIElQK1RDUCBpcyBs
aW1pdGVkIHRvIHRoZSAxNTAwIGJ5dGUgcGF5bG9hZC4NCg0KU28gaWYgdGhlIHNlbmRlciBpcyBn
ZW5lcmF0aW5nIGxvbmdlciBwYWNrZXRzIGl0IGlzIGJ1Z2d5IQ0KDQouLi4NCj4gPiA+IFNpbmNl
IDE1MTggaXMgYSBzdGFuZGFyZCBFdGhlcm5ldCBtYXhpbXVtIGZyYW1lIHNpemUsIGFuZCBpdCBj
YW4NCj4gPiA+IGVhc2lseSBiZSBlbmNvdW50ZXJlZCAoaW4gU1NIIGZvciBleGFtcGxlKSwgZml4
IHRoaXMgYmVoYXZpb3I6DQo+ID4gPg0KPiA+ID4gKiBTZXQgRlRNQUMxMDBfTUFDQ1JfUlhfRlRM
IGluIHRoZSBNQUMgQ29udHJvbCBSZWdpc3Rlci4NCj4gPg0KPiA+IFdoYXQgZG9lcyB0aGF0IGRv
Pw0KPiANCj4gSWYgRlRNQUMxMDBfTUFDQ1JfUlhfRlRMIGlzIG5vdCBzZXQ6DQo+ICAgdGhlIGRy
aXZlciBkb2VzIG5vdCByZWNlaXZlIHRoZSAibG9uZyIgcGFja2V0IGF0IGFsbC4gTG9va3MgbGlr
ZSB0aGUNCj4gY29udHJvbGxlciBkaXNjYXJkcyB0aGUgcGFja2V0IHdpdGhvdXQgYm90aGVyaW5n
IHRoZSBkcml2ZXIuDQoNClJpZ2h0IHNvIHRoZSBleGlzdGluZyBjaGVjayBmb3IgdGhlIGZsYWcg
YmVpbmcgc2V0IGNvdWxkIG5ldmVyIGhhcHBlbi4NCg0KPiBJZiBGVE1BQzEwMF9NQUNDUl9SWF9G
VEwgaXMgc2V0Og0KPiAgIHRoZSBkcml2ZXIgcmVjZWl2ZXMgdGhlICJsb25nIiBwYWNrZXQgbWFy
a2VkIGJ5IHRoZQ0KPiBGVE1BQzEwMF9SWERFUzBfRlRMIGZsYWcuIEFuZCB0aGVzZSBwYWNrZXRz
IHdlcmUgZGlzY2FyZGVkIGJ5IHRoZQ0KPiBkcml2ZXIgKGJlZm9yZSBteSBwYXRjaCkuDQo+IA0K
PiA+IExvb2tzIGxpa2UgaXQgbWlnaHQgY2F1c2UgJ0ZyYW1lIFRvbyBMb25nJyBwYWNrZXRzIGJl
IHJldHVybmVkLg0KPiA+IEluIHdoaWNoIGNhc2Ugc2hvdWxkIHRoZSBjb2RlIGp1c3QgaGF2ZSBp
Z25vcmVkIGl0IHNpbmNlDQo+ID4gbG9uZ2VyIGZyYW1lcyB3b3VsZCBiZSBkaXNjYXJkZWQgY29t
cGxldGVseT8/DQo+IA0KPiBJcyB0aGVyZSBzdWNoIGEgdGhpbmcgYXMgYSByZXNwb25zZSBwYWNr
ZXQgd2hpY2ggaXMgc2VudCBpbiByZXR1cm4gdG8NCj4gRlRMIHBhY2tldD8gRGlkIG5vdCBrbm93
IHRoYXQuIE15IHRlc3RjYXNlcyB3ZXJlIFNTSCBhbmQgU0NQIHByb2dyYW1zDQo+IG9uIFVidW50
dSAyMiBhbmQgdGhleSBzaW1wbHkgaGFuZyB0cnlpbmcgdG8gY29ubmVjdCB0byB0aGUgZnRtYWMx
MDANCj4gZGV2aWNlIC0gbm8gcmV0cmFuc21pc3Npb25zIG9yIHJldHJpZXMgd2l0aCBzbWFsbGVy
IGZyYW1lcyBoYXBwZW5lZC4NCg0KT3ZlcmxvbmcgZnJhbWVzIHNob3VsZCBiZSBkaXNjYXJkZWQu
DQpUaGUgc2VuZGVyIG1pZ2h0IGNob29zZSB0byBkbyBQTVRVIChwYXRoIE1UVSkgZGV0ZWN0aW9u
LA0KYnV0IHByb2JhYmx5IGRvZXNuJ3QgdW5sZXNzIGEgcm91dGVyIGlzIGludm9sdmVkLg0KDQou
Li4NCj4gPiBEbyB5b3UgbmVlZCB0byByZWFkIHRoaXMgdmFsdWUgdGhpcyBlYXJseSBpbiB0aGUg
ZnVuY3Rpb24/DQo+ID4gTG9va3MgbGlrZSBpdCBpcyBvbmx5IHVzZWQgd2hlbiBvdmVybG9uZyBw
YWNrZXRzIGFyZSByZXBvcnRlZC4NCj4gDQo+IEkgZGVjaWRlZCB0byBtYWtlIGEgdmFyaWFibGUg
aW4gb3JkZXIgdG8gdXNlIGl0IHR3aWNlOg0KPiBpbiB0aGUgY29uZGl0aW9uOiAibGVuZ3RoID4g
MTUxOCINCj4gaW4gbG9nZ2luZzogIm5ldGRldl9pbmZvKG5ldGRldiwgInJ4IGZyYW1lIHRvbyBs
b25nICgldSlcbiIsIGxlbmd0aCk7Ig0KPiBZb3UgYXJlIHJpZ2h0IHNheWluZyBpdCBpcyBub3Qg
bmVlZGVkIGluIG1vc3QgY2FzZXMuIENhbiB3ZSBob3BlIGZvcg0KPiB0aGUgb3B0aW1pemVyIHRv
IHBvc3Rwb25lIHRoZSBpbml0aWFsaXphdGlvbiBvZiAnbGVuZ3RoJyB0aWxsIGl0IGlzDQo+IGFj
Y2Vzc2VkPw0KDQpVbmxpa2VseSB1bmxlc3MgdGhlcmUgYXJlIG5vIGZ1bmN0aW9uIGNhbGxzIGFu
ZCBubyB2b2xhdGlsZQ0KbWVtb3J5IGFjY2Vzc2VzLg0KSU1ITyBqdXN0IGJlY2F1c2UgeW91IGNh
biBhc3NpZ24gYSB2YWx1ZSBvbiB0aGUgZGVjbGFyYXRpb24NCihvZiBhIGxvY2FsKSBkb2Vzbid0
IG1lYW4gaXQgaXMgYSBnb29kIGlkZWEuDQpCZXR0ZXIgdG8gbW92ZSBpdCBuZWFyZXIgdGhlIHVz
ZSAodW5sZXNzIGl0IGlzIHVzZWQgdGhyb3VnaG91dA0KdGhlIGZ1bmN0aW9uKS4NCg0KCURhdmlk
DQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBG
YXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2
IChXYWxlcykNCg==

