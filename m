Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBE61543D3
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 13:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbgBFMNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 07:13:30 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:37421 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727609AbgBFMNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 07:13:30 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-168-qF-LqQnVODiKYIlObeBAig-1; Thu, 06 Feb 2020 12:13:26 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 6 Feb 2020 12:13:26 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 6 Feb 2020 12:13:26 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Yadu Kishore' <kyk.segfault@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: TCP checksum not offloaded during GSO
Thread-Topic: TCP checksum not offloaded during GSO
Thread-Index: AQHV2x+0o66qvMybmk6DT7EFwdIZFKgOFqmw
Date:   Thu, 6 Feb 2020 12:13:26 +0000
Message-ID: <fb00395be1f34554a3dcdee5b0bbcf8e@AcuMS.aculab.com>
References: <CABGOaVTY6BrzJTYEtVXwawzP7-D8sb1KASDWFk15v0QFaJVbUg@mail.gmail.com>
In-Reply-To: <CABGOaVTY6BrzJTYEtVXwawzP7-D8sb1KASDWFk15v0QFaJVbUg@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: qF-LqQnVODiKYIlObeBAig-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogWWFkdSBLaXNob3JlDQo+IFNlbnQ6IDA0IEZlYnJ1YXJ5IDIwMjAgMDU6NTUNCj4gSSdt
IHdvcmtpbmcgb24gZW5oYW5jaW5nIGEgZHJpdmVyIGZvciBhIE5ldHdvcmsgQ29udHJvbGxlciB0
aGF0DQo+IHN1cHBvcnRzICJDaGVja3N1bSBPZmZsb2FkcyIuDQouLi4NCj4gVGhlIE5ldHdvcmsg
Q29udHJvbGxlciBkb2VzIG5vdCBzdXBwb3J0IHNjYXR0ZXItZ2F0aGVyIChTRykgRE1BLg0KDQpJ
cyBpdCBvbmUgb2YgdGhlIHJlYWxseSBicm9rZW4gb25lcyB0aGF0IGFsc28gcmVxdWlyZXMgdGhl
DQp0eCBhbmQgcnggYnVmZmVycyBiZSA0IGJ5dGUgYWxpZ25lZD8NCg0KR2V0IGEgZGlmZmVyZW50
IE5ldHdvcmsgQ29udHJvbGxlciwgdGhlIG9uZSB5b3UgaGF2ZSBpc24ndA0KJ2ZpdCBmb3IgcHVy
cG9zZScgOi0pDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJy
YW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lz
dHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

