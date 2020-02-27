Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CABF1722AD
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 17:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729431AbgB0QAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 11:00:24 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:56716 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727592AbgB0QAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 11:00:24 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-233-BmOBkgAOPui3H26LTnpTgA-1; Thu, 27 Feb 2020 16:00:20 +0000
X-MC-Unique: BmOBkgAOPui3H26LTnpTgA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 27 Feb 2020 16:00:19 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 27 Feb 2020 16:00:19 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     David Laight <David.Laight@ACULAB.COM>,
        netdev <netdev@vger.kernel.org>
Subject: RE: sys_sendto() spinning for 1.6ms
Thread-Topic: sys_sendto() spinning for 1.6ms
Thread-Index: AdXtbb8kfVfk26r1Rfib7iXWKp20CAAF9gmA
Date:   Thu, 27 Feb 2020 16:00:19 +0000
Message-ID: <683b4f4779fc490197e4bf48eb6c5a60@AcuMS.aculab.com>
References: <303c8600e4964d1593b038239779ba4b@AcuMS.aculab.com>
In-Reply-To: <303c8600e4964d1593b038239779ba4b@AcuMS.aculab.com>
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

RnJvbTogRGF2aWQgTGFpZ2h0DQo+IFNlbnQ6IDI3IEZlYnJ1YXJ5IDIwMjAgMTM6MTkNCj4gDQo+
IEknbSBsb29raW5nIGludG8gdW5leHBlY3RlZCBkZWxheXMgaW4gc29tZSByZWFsIHRpbWUgKFJU
UCBhdWRpbykgcHJvY2Vzc2luZy4NCj4gTW9zdGx5IHRoZXkgYXJlIGEgZmV3IDEwMCB1c2VjcyBp
biB0aGUgc29mdGludCBjb2RlLg0KPiANCj4gSG93ZXZlciBJJ3ZlIGp1c3QgdHJpZ2dlcmVkIGlu
IHNlbmR0bygpIG9uIGEgcmF3IElQVjQgc29ja2V0IHRha2luZyAxLjZtcy4NCj4gTW9zdCBvZiB0
aGUgc2VuZHMgdGFrZSBsZXNzIHRoYW4gMzJ1cy4NCi4uLg0KPiBDcHUgMiB0cmFjZSBpczoNCj4g
ICAgIHBpZC0yODIxOSBbMDAyXSAuLi4uIDE5Nzk4OTEuMTU5OTEyOiBzeXNfc2VuZHRvKGZkOiAz
OTQsIGJ1ZmY6IDdmZmJjYjJlMjk0MCwgbGVuOiBjOCwgZmxhZ3M6IDAsDQo+IGFkZHI6IDdmZmJj
Y2RjOTQ5MCwgYWRkcl9sZW46IDEwKQ0KPiAgICAgcGlkLTI4MjE5IFswMDJdIC4uLi4gMTk3OTg5
MS4xNjE2NDc6IHN5c19zZW5kdG8gLT4gMHhjOA0KPiANCg0KT2ssIEkndmUgZm91bmQgdGhlIGJ1
Z2d5IHBpZWNlIG9mIGNyYXAgcmVzcG9uc2libGU6DQoNCjE5OTI4NTcuMjk0OTEwIHwgICAyKSAg
UHJvc29keS01ODEyICB8ICAgICAgICAgICAgICAgfCAgcmF3X3NlbmRtc2coKSB7DQoxOTkyODU3
LjI5NDkxMiB8ICAgMikgIFByb3NvZHktNTgxMiAgfCAgIDEuMDk5IHVzICAgIHwgICAgX19ldzMy
X3ByZXBhcmUgW2UxMDAwZV0oKTsNCjE5OTI4NTcuMjk0OTEzIHwgICAyKSAgUHJvc29keS01ODEy
ICB8ICAgMC44NTUgdXMgICAgfCAgICBfX2V3MzJfcHJlcGFyZSBbZTEwMDBlXSgpOw0KMTk5Mjg1
Ny4yOTQ5MTUgfCAgIDIpICBQcm9zb2R5LTU4MTIgIHwgICAwLjc3MyB1cyAgICB8ICAgIF9fZXcz
Ml9wcmVwYXJlIFtlMTAwMGVdKCk7DQoxOTkyODU3LjI5NDkxNiB8ICAgMikgIFByb3NvZHktNTgx
MiAgfCAhIDIwMi42ODkgdXMgIHwgICAgX19ldzMyX3ByZXBhcmUgW2UxMDAwZV0oKTsNCjE5OTI4
NTcuMjk1MTU1IHwgICAyKSAgUHJvc29keS01ODEyICB8ICEgMjUzLjE2MiB1cyAgfCAgICBfX2V3
MzJfcHJlcGFyZSBbZTEwMDBlXSgpOw0KMTk5Mjg1Ny4yOTU0MDkgfCAgIDIpICBQcm9zb2R5LTU4
MTIgIHwgICAwLjg1NSB1cyAgICB8ICAgIF9fZXczMl9wcmVwYXJlIFtlMTAwMGVdKCk7DQoxOTky
ODU3LjI5NTQxMSB8ICAgMikgIFByb3NvZHktNTgxMiAgfCAhIDUwMC44MjggdXMgIHwgIH0NCg0K
LyoqDQogKiBfX2V3MzJfcHJlcGFyZSAtIHByZXBhcmUgdG8gd3JpdGUgdG8gTUFDIENTUiByZWdp
c3RlciBvbiBjZXJ0YWluIHBhcnRzDQogKiBAaHc6IHBvaW50ZXIgdG8gdGhlIEhXIHN0cnVjdHVy
ZQ0KICoNCiAqIFdoZW4gdXBkYXRpbmcgdGhlIE1BQyBDU1IgcmVnaXN0ZXJzLCB0aGUgTWFuYWdl
YWJpbGl0eSBFbmdpbmUgKE1FKSBjb3VsZA0KICogYmUgYWNjZXNzaW5nIHRoZSByZWdpc3RlcnMg
YXQgdGhlIHNhbWUgdGltZS4gIE5vcm1hbGx5LCB0aGlzIGlzIGhhbmRsZWQgaW4NCiAqIGgvdyBi
eSBhbiBhcmJpdGVyIGJ1dCBvbiBzb21lIHBhcnRzIHRoZXJlIGlzIGEgYnVnIHRoYXQgYWNrbm93
bGVkZ2VzIEhvc3QNCiAqIGFjY2Vzc2VzIGxhdGVyIHRoYW4gaXQgc2hvdWxkIHdoaWNoIGNvdWxk
IHJlc3VsdCBpbiB0aGUgcmVnaXN0ZXIgdG8gaGF2ZQ0KICogYW4gaW5jb3JyZWN0IHZhbHVlLiAg
V29ya2Fyb3VuZCB0aGlzIGJ5IGNoZWNraW5nIHRoZSBGV1NNIHJlZ2lzdGVyIHdoaWNoDQogKiBo
YXMgYml0IDI0IHNldCB3aGlsZSBNRSBpcyBhY2Nlc3NpbmcgTUFDIENTUiByZWdpc3RlcnMsIHdh
aXQgaWYgaXQgaXMgc2V0DQogKiBhbmQgdHJ5IGFnYWluIGEgbnVtYmVyIG9mIHRpbWVzLg0KICoq
Lw0KczMyIF9fZXczMl9wcmVwYXJlKHN0cnVjdCBlMTAwMF9odyAqaHcpDQp7DQogICAgICAgIHMz
MiBpID0gRTEwMDBfSUNIX0ZXU01fUENJTTJQQ0lfQ09VTlQ7IC8vIDIwMDANCg0KICAgICAgICB3
aGlsZSAoKGVyMzIoRldTTSkgJiBFMTAwMF9JQ0hfRldTTV9QQ0lNMlBDSSkgJiYgLS1pKQ0KICAg
ICAgICAgICAgICAgIHVkZWxheSg1MCk7DQoNCiAgICAgICAgcmV0dXJuIGk7DQp9DQoNCldURiEh
ISEhISEhISEhISEhISEhISEhISEhISEhISEhIQ0KDQpUaGF0IGl0IGp1c3Qgc28gYnJva2VuLi4u
Lg0KDQpOb3R3aXRoc3RhbmRpbmcgYW55dGhpbmcgZWxzZSB0aGUgYml0IGNhbiBnZXQgc2V0IGp1
c3QgYWZ0ZXINCndlJ3ZlIGNoZWNrZWQgaXQgaXNuJ3Qgc2V0Lg0KU28gdGhlIGNvZGUgZG9lc24n
dCBzb2x2ZSBhbnl0aGluZyBhdCBhbGwuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJl
c3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsx
IDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

