Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42024295AD2
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 10:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2508493AbgJVIrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 04:47:13 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:52363 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2505946AbgJVIrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 04:47:12 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-53-AdgJZ8YlPCmZbNHut1TQXA-1; Thu, 22 Oct 2020 09:47:05 +0100
X-MC-Unique: AdgJZ8YlPCmZbNHut1TQXA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 22 Oct 2020 09:47:05 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 22 Oct 2020 09:47:05 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Xin Long' <lucien.xin@gmail.com>,
        Michael Tuexen <tuexen@fh-muenster.de>
CC:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        davem <davem@davemloft.net>, Guillaume Nault <gnault@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: RE: [PATCHv4 net-next 16/16] sctp: enable udp tunneling socks
Thread-Topic: [PATCHv4 net-next 16/16] sctp: enable udp tunneling socks
Thread-Index: AQHWqCE9GSoHIJDNH0uB1ZnpfnejBqmjTwoA
Date:   Thu, 22 Oct 2020 08:47:05 +0000
Message-ID: <d36e186fd50c44a29adb07f16242f3fd@AcuMS.aculab.com>
References: <cover.1603110316.git.lucien.xin@gmail.com>
 <b65bdc11e5a17e328227676ea283cee617f973fb.1603110316.git.lucien.xin@gmail.com>
 <20201019221545.GD11030@localhost.localdomain>
 <CADvbK_ezWXMxpKkt3kxbXhcgu73PTJ1zpChb_sCgDu38xcROtA@mail.gmail.com>
 <20201020211108.GF11030@localhost.localdomain>
 <3BC2D946-9EA7-4847-9C6E-B3C9DA6A6618@fh-muenster.de>
 <20201020212338.GG11030@localhost.localdomain>
 <CADvbK_csZzHwQ04rMnCDw6=4meY-rrH--19VWm8ROafYSQWWeQ@mail.gmail.com>
 <5EE3969E-CE57-4D9E-99E9-9A9D39C60425@fh-muenster.de>
 <CADvbK_cZua_+2e=u--cV4jH5tR=24DvcEtwcHfAp1kyq9sYofA@mail.gmail.com>
In-Reply-To: <CADvbK_cZua_+2e=u--cV4jH5tR=24DvcEtwcHfAp1kyq9sYofA@mail.gmail.com>
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

RnJvbTogWGluIExvbmcNCj4gU2VudDogMjIgT2N0b2JlciAyMDIwIDA0OjEzDQouLi4NCj4gSSB3
YXMgdGhpbmtpbmcgdGhhdCBieSBsZWF2aW5nIGl0IHRvIDk4OTkgYnkgZGVmYXVsdCB1c2VycyBk
b24ndCBuZWVkIHRvDQo+IGtub3cgdGhlIHBvcnQgd2hlbiB3YW50IHRvIHVzZSBpdCwgYW5kIHll
dCBJIGRpZG4ndCB3YW50IHRvIGFkZCBhbm90aGVyDQo+IHN5c2N0bCBtZW1iZXIuIDpEDQoNCkNv
dWxkIHlvdSBtYWtlIDEgbWVhbiA5ODk5Pw0KU286DQogIDAgPT4gZGlzYWJsZWQNCiAgMSA9PiBk
ZWZhdWx0IHBvcnQNCiAgbiA9PiB1c2UgcG9ydCBuDQpJIGRvdWJ0IHRoYXQgZGlzYWxsb3dpbmcg
cG9ydCAxIGlzIGEgcHJvYmxlbSENCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBM
YWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBU
LCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

