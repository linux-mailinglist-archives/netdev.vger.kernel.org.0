Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E024C2A89F1
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 23:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732361AbgKEWf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 17:35:27 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:22992 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726729AbgKEWf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 17:35:27 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-238-Rmdo_dXeOyK3cySTP3tbsg-1; Thu, 05 Nov 2020 22:35:23 +0000
X-MC-Unique: Rmdo_dXeOyK3cySTP3tbsg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 5 Nov 2020 22:35:23 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 5 Nov 2020 22:35:23 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Xie He' <xie.he.0141@gmail.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: RE: [PATCH net-next] net: x25_asy: Delete the x25_asy driver
Thread-Topic: [PATCH net-next] net: x25_asy: Delete the x25_asy driver
Thread-Index: AQHWs0YkvDVQKZzs2ECZM+crj0xbk6m5Pz0wgACvvICAADEhsA==
Date:   Thu, 5 Nov 2020 22:35:23 +0000
Message-ID: <56513ba35a864fce8e27c550b55766a1@AcuMS.aculab.com>
References: <20201105073434.429307-1-xie.he.0141@gmail.com>
 <1d7f669ba4e444f1b35184264e5da601@AcuMS.aculab.com>
 <CAJht_EM6rXw2Y6NOw9npqUx-MSscwaZ54q7KM4V2ip_CCQsdeg@mail.gmail.com>
In-Reply-To: <CAJht_EM6rXw2Y6NOw9npqUx-MSscwaZ54q7KM4V2ip_CCQsdeg@mail.gmail.com>
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

RnJvbTogWGllIEhlDQo+IFNlbnQ6IDA1IE5vdmVtYmVyIDIwMjAgMTk6MzUNCj4gDQo+IE9uIFRo
dSwgTm92IDUsIDIwMjAgYXQgMToxMCBBTSBEYXZpZCBMYWlnaHQgPERhdmlkLkxhaWdodEBhY3Vs
YWIuY29tPiB3cm90ZToNCj4gPg0KPiA+ID4gVGhpcyBkcml2ZXIgdHJhbnNwb3J0cyBMQVBCIChY
LjI1IGxpbmsgbGF5ZXIpIGZyYW1lcyBvdmVyIFRUWSBsaW5rcy4NCj4gPg0KPiA+IEkgZG9uJ3Qg
cmVtZW1iZXIgYW55IHJlcXVlc3RzIHRvIHJ1biBMQVBCIG92ZXIgYW55dGhpbmcgb3RoZXINCj4g
PiB0aGFuIHN5bmNocm9ub3VzIGxpbmtzIHdoZW4gSSB3YXMgd3JpdGluZyBMQVBCIGltcGxlbWVu
dGF0aW9uKHMpDQo+ID4gYmFjayBpbiB0aGUgbWlkIDE5ODAncy4NCj4gPg0KPiA+IElmIHlvdSBu
ZWVkIHRvIHJ1biAnY29tbXMgb3ZlciBhc3luYyB1YXJ0IGxpbmtzJyB0aGVyZQ0KPiA+IGFyZSBi
ZXR0ZXIgb3B0aW9ucy4NCj4gPg0KPiA+IEkgd29uZGVyIHdoYXQgdGhlIGFjdHVhbCB1c2UgY2Fz
ZSB3YXM/DQo+IA0KPiBJIHRoaW5rIHRoaXMgZHJpdmVyIHdhcyBqdXN0IGZvciBleHBlcmltZW50
YWwgcHVycG9zZXMuIEFjY29yZGluZyB0bw0KPiB0aGUgYXV0aG9yJ3MgY29tbWVudCBhdCB0aGUg
YmVnaW5uaW5nIG9mIHgyNV9hc3kuYywgdGhpcyBkcml2ZXIgZGlkbid0DQo+IGltcGxlbWVudCBG
Q1MgKGZyYW1lIGNoZWNrIHNlcXVlbmNlKSwgd2hpY2ggd2FzIHJlcXVpcmVkIGJ5IENDSVRUJ3MN
Cj4gc3RhbmRhcmQuIFNvIEkgdGhpbmsgdGhpcyBkcml2ZXIgd2FzIG5vdCBzdWl0YWJsZSBmb3Ig
cmVhbC13b3JsZCB1c2UNCj4gYW55d2F5Lg0KDQpZZXMsIHlvdSBjb3VsZCBnZXQgdHJhbnNwYXJl
bmN5IGJ5IHNlbmRpbmcgMHg3ZiBieXRlcyB0d2ljZQ0KKGEgYml0IGxpa2UgYmlzeW5jKSBidXQg
eW91J2Qgd2FudCB0aGUgQ1JDIHRvIGNoZWNrIGZvciBsb3N0IGJ5dGVzLg0KDQpJIGJldCB0aGlz
IHdhcyBvbmx5IGV2ZXIgdXNlZCBieSB0aGUgYXV0aG9yIGFuZCBvbmx5IHRvIHRhbGsgdG8gaXRz
ZWxmLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5
IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRp
b24gTm86IDEzOTczODYgKFdhbGVzKQ0K

