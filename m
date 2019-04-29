Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1EA8E397
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 15:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728243AbfD2NTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 09:19:43 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:42550 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725838AbfD2NTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 09:19:42 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-160-XeyJq5N0PkKkDtqUV6LkPA-1; Mon, 29 Apr 2019 14:19:35 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 29 Apr 2019 14:19:34 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 29 Apr 2019 14:19:34 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Willem de Bruijn' <willemdebruijn.kernel@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        Willem de Bruijn <willemb@google.com>
Subject: RE: [PATCH net] packet: in recvmsg msg_name return at least
 sockaddr_ll
Thread-Topic: [PATCH net] packet: in recvmsg msg_name return at least
 sockaddr_ll
Thread-Index: AQHU/GZvSQrCFfAZB0iZHUe9Gb/AfaZS22WggAAz1YCAABNqkA==
Date:   Mon, 29 Apr 2019 13:19:34 +0000
Message-ID: <e559e87385254ad1a0fdc5f36bdde44a@AcuMS.aculab.com>
References: <20190426192954.146301-1-willemdebruijn.kernel@gmail.com>
 <d57c87e402354163a7ed311d6d27aa4f@AcuMS.aculab.com>
 <CAF=yD-+omQXQO7ue=BkwjVahAFP6YuU5AMTKbC9fBG6qPu6rSw@mail.gmail.com>
In-Reply-To: <CAF=yD-+omQXQO7ue=BkwjVahAFP6YuU5AMTKbC9fBG6qPu6rSw@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: XeyJq5N0PkKkDtqUV6LkPA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBDYW4gdGhlbiBhbHNvIGNoYW5nZSBtZW1zZXQgdG8gemVybyBvbmx5IHR3byBieXRlcyBpbiB0
aGUgRXRoZXJuZXQgY2FzZS4NCj4gDQo+ICsgICAgICAgICAgICAgICAgICAgICAgIGlmIChtc2ct
Pm1zZ19uYW1lbGVuIDwgc2l6ZW9mKHN0cnVjdCBzb2NrYWRkcl9sbCkpIHsNCj4gKyAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBtc2ctPm1zZ19uYW1lbGVuID0gc2l6ZW9mKHN0cnVjdCBz
b2NrYWRkcl9sbCk7DQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbWVtc2V0KG1z
Zy0+bXNnX25hbWUgKyBjb3B5X2xlbiwgMCwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgbXNnLT5uYW1lbGVuIC0gY29weV9sZW4pOw0KDQpjb3B5X2xlbiBub3QgZGVm
aW5lZCAuLi4uDQoNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgfQ0KDQpFeGNlcHQgdGhhdCBo
YXMgdG8gYmUgYSByZWFsIG1lbXNldCgpIG5vdCBhbiBpbmxpbmVkIGRpcmVjdA0Kd3JpdGUgb2Yg
YW4gOGJ5dGUgcmVnaXN0ZXIgKG9yIDIgd3JpdGVzIG9uIGEgMzJiaXQgc3lzdGVtcykuDQoNCglE
YXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91
bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5
NzM4NiAoV2FsZXMpDQo=

