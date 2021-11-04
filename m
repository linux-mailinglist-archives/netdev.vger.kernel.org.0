Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A140A4450FD
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 10:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbhKDJTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 05:19:50 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:47826 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230497AbhKDJTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 05:19:50 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-173-N5bOYDKsPfSbmMVWox4mog-1; Thu, 04 Nov 2021 09:17:10 +0000
X-MC-Unique: N5bOYDKsPfSbmMVWox4mog-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.24; Thu, 4 Nov 2021 09:17:07 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.024; Thu, 4 Nov 2021 09:17:07 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Dumazet' <eric.dumazet@gmail.com>,
        Leonard Crestez <cdleonard@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>
CC:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        "Yuchung Cheng" <ycheng@google.com>,
        Enke Chen <enchen@paloaltonetworks.com>,
        Wei Wang <weiwan@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] tcp: Use BIT() for OPTION_* constants
Thread-Topic: [PATCH] tcp: Use BIT() for OPTION_* constants
Thread-Index: AQHX0QUloXdkr6nCi0mOO2Zi6AIfEavzFV8g
Date:   Thu, 4 Nov 2021 09:17:07 +0000
Message-ID: <0b48f1ae32ba49f38dcfe11f912c4ace@AcuMS.aculab.com>
References: <cde3385c115ddf64fe14725f57d88a2a089f23e1.1635977622.git.cdleonard@gmail.com>
 <e869d690-939a-a5a5-1a8c-fe4b550b69ab@gmail.com>
In-Reply-To: <e869d690-939a-a5a5-1a8c-fe4b550b69ab@gmail.com>
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

RnJvbTogRXJpYyBEdW1hemV0DQo+IFNlbnQ6IDAzIE5vdmVtYmVyIDIwMjEgMjI6NTANCj4gDQo+
IE9uIDExLzMvMjEgMzoxNyBQTSwgTGVvbmFyZCBDcmVzdGV6IHdyb3RlOg0KPiA+IEV4dGVuZGlu
ZyB0aGVzZSBmbGFncyB1c2luZyB0aGUgZXhpc3RpbmcgKDEgPDwgeCkgcGF0dGVybiB0cmlnZ2Vy
cw0KPiA+IGNvbXBsYWludHMgZnJvbSBjaGVja3BhdGNoLiBJbnN0ZWFkIG9mIGlnbm9yaW5nIGNo
ZWNrcGF0Y2ggbW9kaWZ5IHRoZQ0KPiA+IGV4aXN0aW5nIHZhbHVlcyB0byB1c2UgQklUKHgpIHN0
eWxlIGluIGEgc2VwYXJhdGUgY29tbWl0Lg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogTGVvbmFy
ZCBDcmVzdGV6IDxjZGxlb25hcmRAZ21haWwuY29tPg0KPiA+DQo+IA0KPiBZZXMsIEkgZ3Vlc3Mg
Y2hlY2twYXRjaCBkb2VzIG5vdCBrbm93IHRoYXQgd2UgY3VycmVudGx5IHVzZSBhdCBtb3N0IDE2
IGJpdHMgOikNCj4gDQo+IHUxNiBvcHRpb25zID0gb3B0cy0+b3B0aW9uczsNCj4gDQo+IEFueXdh
eSwgdGhpcyBzZWVtcyBmaW5lLg0KDQpEb2Vzbid0IEJJVCgpIGhhdmUgYSBuYXN0eSBoYWJpdCBv
ZiBnZW5lcmF0aW5nIDY0Yml0IGNvbnN0YW50cw0KdGhhdCBqdXN0IGNhdXNlIGEgZGlmZmVyZW50
IHNldCBvZiBpc3N1ZXMgd2hlbiBpbnZlcnRlZD8NCkl0IG1heSBiZSBzYWZlIGhlcmUgLSBidXQg
d2hvIGtub3dzLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBC
cmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdp
c3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

