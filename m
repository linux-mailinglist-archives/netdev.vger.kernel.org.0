Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4F571A44F2
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 12:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbgDJKE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 06:04:56 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:26694 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725861AbgDJKE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 06:04:56 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-48-x_uEFZHKOVCh5ORMr0Lc0A-1; Fri, 10 Apr 2020 11:04:53 +0100
X-MC-Unique: x_uEFZHKOVCh5ORMr0Lc0A-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 10 Apr 2020 11:04:53 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 10 Apr 2020 11:04:53 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Konstantin Kharlamov' <hi-angel@yandex.ru>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: On 5.6.2, SCTP is 10 000 times slower than TCP
Thread-Topic: On 5.6.2, SCTP is 10 000 times slower than TCP
Thread-Index: AQHWDnmIUf34av0T4karIpy1I9PllqhyHxew
Date:   Fri, 10 Apr 2020 10:04:53 +0000
Message-ID: <f45c281f37724eec868ae72180ab3cdd@AcuMS.aculab.com>
References: <09cc102b-31d1-b0e8-3ea1-3b07b9a6df74@yandex.ru>
In-Reply-To: <09cc102b-31d1-b0e8-3ea1-3b07b9a6df74@yandex.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogS29uc3RhbnRpbiBLaGFybGFtb3YNCj4gU2VudDogMDkgQXByaWwgMjAyMCAxNTowOQ0K
PiANCj4gSSB3YXMgY29uc2lkZXJpbmcsIHdoZXRoZXIgU0NUUCBjb3VsZCBiZSBmYXN0ZXIgdGhh
biBUQ1AsIGFuZCBtYWRlIHNvbWUNCj4gbWVhc3VyZW1lbnRzLg0KDQpTQ1RQIHdpbGwgYWx3YXlz
IGJlIHNsb3dlciB0aGFuIFRDUCAtIGl0IGlzIG11Y2ggbW9yZSBjb21wbGljYXRlZC4NCkFkZGl0
aW9uYWxseSBpdCBpcyBtdWNoIGhhcmRlciB0byBmaWxsIGV0aGVybmV0IGZyYW1lcyAtIHdoaWNo
IG1ha2VzDQppdCBldmVuIHNsb3dlci4NCk5vdCB0byBtZW50aW9uIHRoZSBzbG93ZXIgY2hlY2tz
dW0gYWxnb3JpdGhtLg0KLSBJIGNhbiBhZGQgbW9yZS4uLg0KSU1ITyBldmVuIHByb3RvY29scyBs
aWtlIE0zVUEgd291bGQgcnVuIGJldHRlciBvdmVyIFRDUC4NCg0KPiBSZXN1bHRzIGFyZSBhc3Rv
bmlzaGluZzogNC43NCBHQi9zZWMgZm9yIFRDUCB2cyA1OTAsIEtCL3NlYyBmb3INCj4gU0NUUC4g
TGV0IG1lIHJlcGhyYXNlOiB0aGF0IGlzIDQuNzQgR0Ivc2VjIHZzIDAuMDAwNTkgR0Ivc2VjISBX
b3cuIFRoaXMgbG9va3MNCj4gc29vbyB3cm9uZywgdGhhdCB0aGlzIGlzIHByb2JhYmx5IGEgYnVn
LCBzbyBJJ20gcmVwb3J0aW5nIGl0IGhlcmUuDQoNCkl0IHNob3VsZG4ndCBiZSB0aGF0IG11Y2gg
c2xvd2VyIHRob3VnaC4NCg0KPiBUZXN0cyBhcmUgZG9uZSBvbiBrZXJuZWwgNS42LjIgd2l0aCBx
cGVyZiAwLjQuMTEgYXMgZm9sbG93czoNCj4gDQo+IDEuIFJ1biBgcXBlcmZgIGluIG9uZSB0ZXJt
aW5hbA0KPiAyLiBSdW4gYHFwZXJmIC12IGxvY2FsaG9zdCB0Y3BfYncgdGNwX2xhdCBzY3RwX2J3
IHNjdHBfbGF0YCBpbiB0aGUgb3RoZXIgdGVybWluYWwNCj4gDQo+IEJlbG93IGFyZSA0IHJlc3Vs
dHMgZm9yIG15IERlbGwgSW5zcGlyb24gNTc2NyBsYXB0b3AuDQo+IA0KPiBUZXN0IG51bWJlciB8
IFRDUCBiYW5kd2lkdGggfCBUQ1AgbGF0ZW5jeSwgzrxzIHwgU0NUUCBiYW5kd2lkdGggfCBTQ1RQ
IGxhdGVuY3ksIM68cw0KPiAxICAgICAgICAgICB8IDQuNzQgR0Ivc2VjICAgfCA2LjgxICAgICAg
ICAgICAgfCA1OTAsIEtCL3NlYyAgICB8IDExLjgNCj4gMiAgICAgICAgICAgfCA1IEdCL3NlYyAg
ICAgIHwgNi43OSAgICAgICAgICAgIHwgNzIxLCBLQi9zZWMgICAgfCAxMC41DQo+IDMgICAgICAg
ICAgIHwgNC43MyBHQi9zZWMgICB8IDYuNzYgICAgICAgICAgICB8IDguMzksIE1CL3NlYyAgIHwg
MTAuOQ0KPiA0ICAgICAgICAgICB8IDUuNyBHQi9zZWMgICAgfCA2LjEgICAgICAgICAgICAgfCA1
My40LCBNQi9zZWMgICB8IDkuMzMNCg0KVGhlcmUgaXMgc29tZXRoaW5nIHN0cmFuZ2UgZ29pbmcg
b24sIHRoZSBsYXRlbmN5IGlzIHJlYXNvbmFibGUuDQoNCj4gRldJVywgSSBhbHNvIG1hZGUgc29t
ZSBtZWFzdXJlbWVudHMgb24gYSBzZXJ2ZXIgaHcgd2l0aCBvbGRlciBrZXJuZWwgNC4xOS4gVGhl
DQo+IGRpZmZlcmVuY2UgdGhlcmUgaXMgbm90IHRoYXQgYmlnLCB5ZXQgZXZlbiB0aGVyZSBTQ1RQ
IGlzIHR3aWNlIGFzIHNsb3dlciBjb21wYXJlZA0KPiB0byBUQ1AuDQoNClRoYXQgd291bGRuJ3Qg
c3VycHJpc2UgbWUuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUs
IEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJl
Z2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

