Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6445FD3C2
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 06:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbiJMEYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 00:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiJMEYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 00:24:46 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2270E113F
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 21:24:42 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-248-51rZ28CCMQGwV54jqoVNCw-1; Thu, 13 Oct 2022 05:24:39 +0100
X-MC-Unique: 51rZ28CCMQGwV54jqoVNCw-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Thu, 13 Oct
 2022 05:24:39 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.040; Thu, 13 Oct 2022 05:24:39 +0100
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
Thread-Index: AQHY3lCWEiTFPZdxBkKncwnj941AIq4K6mqQ///7b4CAAMyDUA==
Date:   Thu, 13 Oct 2022 04:24:39 +0000
Message-ID: <379c5499d1be4f73a6175385d3345a68@AcuMS.aculab.com>
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
ZiBsZW5ndGggPD0xNTE0Lg0KDQpBY3R1YWxseSBJIGJldCB0aGUgZGF0YXNoZWV0IGlzIGNvcnJl
Y3QuDQpUaGUgbGVuZ3RoIGNoZWNrIGlzIHByb2JhYmx5IGRvbmUgYmVmb3JlIHRoZSBDUkMgaXMg
ZGlzY2FyZGVkLg0KDQouLi4NCj4gPiBBbHRob3VnaCB0cmFkaXRpb25hbGx5IGl0IHdhcyAxNTE0
K2NyYy4NCj4gPiBBbiBleHRyYSA0IGJ5dGUgaGVhZGVyIGlzIG5vdyBhbGxvd2VkLg0KPiA+IFRo
ZXJlIGlzIGFsc28gdGhlIHVzZWZ1bG5lc3Mgb2Ygc3VwcG9ydGluZyBmdWxsIGxlbmd0aCBmcmFt
ZXMNCj4gPiB3aXRoIGEgUFBQb0UgaGVhZGVyLg0KPiA+DQo+ID4gV2hldGhlciBpdCBhY3R1YWxs
eSBtYWtlcyBzZW5zZSB0byByb3VuZCB1cCB0aGUgcmVjZWl2ZSBidWZmZXINCj4gPiBzaXplIGFu
ZCBhc3NvY2lhdGVkIG1heCBmcmFtZSBsZW5ndGggdG8gMTUzNiAoY2FjaGUgbGluZSBhbGlnbmVk
KQ0KPiA+IGlzIGFub3RoZXIgbWF0dGVyIChwcm9iYWJseSAxNTM0IGZvciA0bisyIGFsaWdubWVu
dCkuDQo+ID4NCj4gPiA+IFNpbmNlIDE1MTggaXMgYSBzdGFuZGFyZCBFdGhlcm5ldCBtYXhpbXVt
IGZyYW1lIHNpemUsIGFuZCBpdCBjYW4NCj4gPiA+IGVhc2lseSBiZSBlbmNvdW50ZXJlZCAoaW4g
U1NIIGZvciBleGFtcGxlKSwgZml4IHRoaXMgYmVoYXZpb3I6DQo+ID4gPg0KPiA+ID4gKiBTZXQg
RlRNQUMxMDBfTUFDQ1JfUlhfRlRMIGluIHRoZSBNQUMgQ29udHJvbCBSZWdpc3Rlci4NCj4gPg0K
PiA+IFdoYXQgZG9lcyB0aGF0IGRvPw0KPiANCj4gSWYgRlRNQUMxMDBfTUFDQ1JfUlhfRlRMIGlz
IG5vdCBzZXQ6DQo+ICAgdGhlIGRyaXZlciBkb2VzIG5vdCByZWNlaXZlIHRoZSAibG9uZyIgcGFj
a2V0IGF0IGFsbC4gTG9va3MgbGlrZSB0aGUNCj4gY29udHJvbGxlciBkaXNjYXJkcyB0aGUgcGFj
a2V0IHdpdGhvdXQgYm90aGVyaW5nIHRoZSBkcml2ZXIuDQo+IElmIEZUTUFDMTAwX01BQ0NSX1JY
X0ZUTCBpcyBzZXQ6DQo+ICAgdGhlIGRyaXZlciByZWNlaXZlcyB0aGUgImxvbmciIHBhY2tldCBt
YXJrZWQgYnkgdGhlDQo+IEZUTUFDMTAwX1JYREVTMF9GVEwgZmxhZy4gQW5kIHRoZXNlIHBhY2tl
dHMgd2VyZSBkaXNjYXJkZWQgYnkgdGhlDQo+IGRyaXZlciAoYmVmb3JlIG15IHBhdGNoKS4NCg0K
VGhlcmUgYXJlIG90aGVyIHByb2JsZW1zIGhlcmUuDQpXaGVyZSBkb2VzIHRoZSBleHRyYSBkYXRh
IGFjdHVhbGx5IGdldCB3cml0dGVuIHRvPw0KV2hhdCBoYXBwZW5zIHRvIHZlcnkgbG9uZyBwYWNr
ZXRzPw0KDQpJJ20gZ3Vlc3NpbmcgdGhlIGhhcmR3YXJlIGhhcyBhIHJlYXNvbmFibGUgaW50ZXJm
YWNlIHdoZXJlDQp0aGVyZSBpcyBhICdyaW5nJyBvZiByZWNlaXZlIGJ1ZmZlciBkZXNjcmlwdG9y
cy4NCklmIGEgZnJhbWUgaXMgbG9uZ2VyIHRoYW4gYSBidWZmZXIgdGhlIGhhcmR3YXJlIHdpbGwg
d3JpdGUNCnRoZSBmcmFtZSB0byBtdWx0aXBsZSBidWZmZXJzLg0KDQpIb3dldmVyIGlmIGVhY2gg
YnVmZmVyIGlzIGxvbmcgZW5vdWdoIGZvciBhIG5vcm1hbCBmcmFtZQ0KYW5kIHRoZSBoYXJkd2Fy
ZSBkaXNjYXJkcy90cnVuY2F0ZXMgb3ZlcmxvbmcgZnJhbWVzIHRoZW4NCnRoZSBkcml2ZXIgY2Fu
IGFzc3VtZSB0aGVyZSBhcmUgbm8gY29udGludWF0aW9ucy4NCihJIHVzZWQgdG8gdXNlIGFuIGFy
cmF5IG9mIDEyOCBidWZmZXJzIG9mIDUxMiBieXRlcyBhbmQNCmFsd2F5cyBjb3B5IHRoZSByZWNl
aXZlIGRhdGEgLSBhIHNpbmdsZSB3b3JkIGFsaWduZWQgY29weQ0KdW5sZXNzIGEgbG9uZyBmcmFt
ZSBjcm9zc2VkIHRoZSByaW5nIGVuZC4pDQoNCkl0IGxvb2tzIGxpa2UgdGhlIEZUTCBiaXQgYWN0
dWFsbHkgY29udHJvbHMgd2hldGhlcg0Kb3ZlcmxvbmcgZnJhbWVzIGFyZSBkaXNjYXJkZWQgb3Ig
dHJ1bmNhdGVkLg0KKFRoZXJlIG1heSBiZSBhbm90aGVyIG9wdGlvbiB0byBlaXRoZXIgc2V0IHRo
ZSBmcmFtZQ0KbGVuZ3RoIG9yIGRpc2FibGUgdGhlIGZlYXR1cmUgY29tcGxldGVseS4pDQoNCk5v
dyB5b3UgbWlnaHQgZ2V0IGF3YXkgd2l0aCBwYWNrZXRzIHRoYXQgYXJlIG9ubHkgNCBieXRlcw0K
b3ZlcmxvbmcgKG9uZSBWTEFOIGhlYWRlcikgYmVjYXVzZSB0aGUgaGFyZHdhcmUgYWx3YXlzDQp3
cml0ZXMgdGhlIGZ1bGwgcmVjZWl2ZWQgQ1JDIGludG8gdGhlIGJ1ZmZlci4NClNvIHdoZW4gaXQg
ZGlzY2FyZHMgYSAxNTE1LTE1MTggZnJhbWUgdGhlIGV4dHJhIGJ5dGVzDQphcmUgZnJvbSB0aGUg
ZnJhbWUuDQpJZiB0aGF0IGlzIHRydWUgaXQgZGVzZXJ2ZXMgYSBjb21tZW50Lg0KDQpPVE9IIGlm
IGl0IGNhcnJpZXMgb24gd3JpdGluZyBpbnRvIHRoZSByeCByaW5nIGJ1ZmZlcg0KdGhlbiBpdCBt
aWdodCBhbHNvICdvdmVyZmxvdycgaW50byB0aGUgbmV4dCByaW5nIGVudHJ5Lg0KSW5kZWVkIGEg
bG9uZyBlbm91Z2ggZnJhbWUgd2lsbCBmaWxsIHRoZSBlbnRpcmUgcmluZw0KKHlvdSdsbCBuZWVk
IGEgYnVnZ3kgZXRoZXJuZXQgaHViL3N3aXRjaCBvZiBhIDEwLzEwME0NCkhEWCBuZXR3b3JrKS4N
Cg0KWW91IHJlYWxseSBkbyBuZWVkIHRvIGNoZWNrIHdoZXRoZXIgaXQgZGV0ZWN0cyBDUkMgZXJy
b3JzDQpvbiBvdmVybG9uZyBmcmFtZXMuIElmIGl0IChtb3N0bHkpIHN0b3BzIHByb2Nlc3Npbmcg
YXQNCjE1MTggYnl0ZXMgKGluYyBjcmMpIHRoZW4gaXQgbWF5IG5vdC4NCkFsc28gaWYgdGhlIGZy
YW1lIGxlbmd0aCBmaWVsZCBpcyAoc2F5KSAxNiBiaXRzIHRoZW4NCmEgNjRrKyBmcmFtZSB3aWxs
IHdyYXAgdGhlIGNvdW50ZXIuDQpXaGljaCBtZWFucyB0aGF0IHRoZSBmcmFtZSBsZW5ndGggbWF5
IGJlIHVucmVsaWFibGUNCmZvciBvdmVybG9uZyBmcmFtZXMuDQooVGhlIGNvdW50IG1pZ2h0IHNh
dHVyYXRlLikNCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJh
bWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0
cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

