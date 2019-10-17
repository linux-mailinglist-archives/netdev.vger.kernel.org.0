Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32214DA7F7
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 11:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408446AbfJQJEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 05:04:06 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:22397 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728987AbfJQJEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 05:04:06 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-173-31XI3omJN66Rk8t6f-feOg-1; Thu, 17 Oct 2019 10:04:02 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 17 Oct 2019 10:04:01 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 17 Oct 2019 10:04:01 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Xin Long' <lucien.xin@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "marcelo.leitner@gmail.com" <marcelo.leitner@gmail.com>,
        "nhorman@tuxdriver.com" <nhorman@tuxdriver.com>
Subject: RE: [PATCHv3 net-next 0/5] sctp: update from rfc7829
Thread-Topic: [PATCHv3 net-next 0/5] sctp: update from rfc7829
Thread-Index: AQHVg7yU44xuaHxb70is56q5NyLqeqddFHmwgAEh3wCAAFWQsA==
Date:   Thu, 17 Oct 2019 09:04:01 +0000
Message-ID: <a62ea0845f224f15ad42cf9818040919@AcuMS.aculab.com>
References: <cover.1571033544.git.lucien.xin@gmail.com>
 <20191015.175639.347136446069377956.davem@davemloft.net>
 <1f6cf86fce074a9cbf7f8c2496cc7c84@AcuMS.aculab.com>
 <CADvbK_cBaydDVnmcKvUWwsbf+u_GgAumoq7wW7FQtFg_TZNiiw@mail.gmail.com>
In-Reply-To: <CADvbK_cBaydDVnmcKvUWwsbf+u_GgAumoq7wW7FQtFg_TZNiiw@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: 31XI3omJN66Rk8t6f-feOg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogWGluIExvbmcNCj4gU2VudDogMTcgT2N0b2JlciAyMDE5IDA1OjU3DQouLi4NCj4gPiBJ
J20gb25seSBhbiBTQ1RQIHVzZXIsIGJ1dCBJIHRoaW5rIHNvbWUgb2YgdGhlIEFQSSBjaGFuZ2Vz
IGFyZW4ndCByaWdodC4NCj4gSGksIERhdmlkIEwuDQo+IA0KPiBJIHRoaW5rIHlvdSBtdXN0IGtu
b3cgcXVpdGUgYSBmZXcgdXNlciBjYXNlcy4NCj4gDQo+IEJlZm9yZSBJIHJlcG9zdCwgY2FuIHlv
dSBwbHMgZ2l2ZSB0aGUgZXhhY3QgcGxhY2VzIHdoZXJlIHRoZSBBUEkNCj4gY2hhbmdlcyBtYXkg
bm90IGJlIHJpZ2h0IGFzIHlvdSd2ZSBhbHJlYWR5IGRvbmUgaW4gdjEgYW5kIHYyLCBzbw0KPiB0
aGF0IEkgY2FuIGNvcnJlY3QgdGhlbS4NCg0KSSdsbCB0cnkgdG8gZmluZCB0aW1lIHRvIGxvb2sg
bGF0ZXIgdG9kYXkuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUs
IEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJl
Z2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

