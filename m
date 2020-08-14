Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D221C244A8A
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 15:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbgHNNgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 09:36:40 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:38578 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728611AbgHNNgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 09:36:38 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-28-rZh65QU-OKmx5mJW_6SZ7w-1; Fri, 14 Aug 2020 14:36:34 +0100
X-MC-Unique: rZh65QU-OKmx5mJW_6SZ7w-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 14 Aug 2020 14:36:34 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 14 Aug 2020 14:36:34 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: sctp: num_ostreams and max_instreams negotiation
Thread-Topic: sctp: num_ostreams and max_instreams negotiation
Thread-Index: AdZyPjABix+HSvLeTmG2b9Vg1HRq1A==
Date:   Fri, 14 Aug 2020 13:36:34 +0000
Message-ID: <9a1bfa6085854387bf98b6171c879b37@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 1.001
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiA+IEF0IHNvbWUgcG9pbnQgdGhlIG5lZ290aWF0aW9uIG9mIHRoZSBudW1iZXIgb2YgU0NUUCBz
dHJlYW1zDQo+ID4gc2VlbXMgdG8gaGF2ZSBnb3QgYnJva2VuLg0KPiA+IEkndmUgZGVmaW5pdGVs
eSB0ZXN0ZWQgaXQgaW4gdGhlIHBhc3QgKHByb2JhYmx5IDEwIHllYXJzIGFnbyEpDQo+ID4gYnV0
IG9uIGEgNS44LjAga2VybmVsIGdldHNvY2tvcHQoU0NUUF9JTkZPKSBzZWVtcyB0byBiZQ0KPiA+
IHJldHVybmluZyB0aGUgJ251bV9vc3RyZWFtcycgc2V0IGJ5IHNldHNvY2tvcHQoU0NUUF9JTklU
KQ0KPiA+IHJhdGhlciB0aGFuIHRoZSBzbWFsbGVyIG9mIHRoYXQgdmFsdWUgYW5kIHRoYXQgY29u
ZmlndXJlZA0KPiA+IGF0IHRoZSBvdGhlciBlbmQgb2YgdGhlIGNvbm5lY3Rpb24uDQo+ID4NCj4g
PiBJJ2xsIGRvIGEgYml0IG9mIGRpZ2dpbmcuDQo+IA0KPiBJIGNhbid0IGZpbmQgdGhlIGNvZGUg
dGhhdCBwcm9jZXNzZXMgdGhlIGluaXRfYWNrLg0KPiBCdXQgd2hlbiBzY3RwX3Byb2Nzc19pbnQo
KSBzYXZlcyB0aGUgc21hbGxlciB2YWx1ZQ0KPiBpbiBhc29jLT5jLnNpbmludF9tYXhfb3N0cmVh
bXMuDQo+IA0KPiBCdXQgYWZlODk5OTYyZWUwNzkgKGlmIEkndmUgdHlwZWQgaXQgcmlnaHQpIGNo
YW5nZWQNCj4gdGhlIHZhbHVlcyBTQ1RQX0lORk8gcmVwb3J0ZWQuDQo+IEFwcGFyYW50bHkgYWRk
aW5nICdzY3RwIHJlY29uZmlnJyBoYWQgY2hhbmdlZCB0aGluZ3MuDQo+IA0KPiBTbyBJIHN1c3Bl
Y3QgdGhpcyBoYXMgYWxsIGJlZW4gYnJva2VuIGZvciBvdmVyIDMgeWVhcnMuDQoNCkl0IGxvb2tz
IGxpa2UgdGhlIGNoYW5nZXMgdGhhdCBicm9rZSBpdCB3ZW50IGludG8gNC4xMS4NCkkndmUganVz
dCBjaGVja2VkIGEgMy44IGtlcm5lbCBhbmQgdGhhdCBuZWdvdGlhdGVzIHRoZQ0KdmFsdWVzIGRv
d24gaW4gYm90aCBkaXJlY3Rpb25zLg0KDQpJIGRvbid0IGhhdmUgYW55IGtlcm5lbHMgbHVya2lu
ZyBiZXR3ZWVuIDMuOCBhbmQgNC4xNS4NCihZZXMsIEkgY291bGQgYnVpbGQgb25lLCBidXQgaXQg
ZG9lc24ndCByZWFsbHkgaGVscC4pDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3Mg
TGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQ
VCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

