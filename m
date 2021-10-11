Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939314288FC
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 10:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235205AbhJKIlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 04:41:40 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:23149 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235196AbhJKIlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 04:41:39 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-105-W-MLlp8VPJeIvzCSQwUGgw-1; Mon, 11 Oct 2021 09:39:38 +0100
X-MC-Unique: W-MLlp8VPJeIvzCSQwUGgw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Mon, 11 Oct 2021 09:39:35 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.023; Mon, 11 Oct 2021 09:39:35 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Mathieu Desnoyers' <mathieu.desnoyers@efficios.com>,
        rostedt <rostedt@goodmis.org>
CC:     linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul <paulmck@linux.vnet.ibm.com>,
        "Josh Triplett" <josh@joshtriplett.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        "Joel Fernandes, Google" <joel@joelfernandes.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        "Florian Westphal" <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        "Hideaki YOSHIFUJI" <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        "Jakub Kicinski" <kuba@kernel.org>, rcu <rcu@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        netdev <netdev@vger.kernel.org>
Subject: RE: [RFC][PATCH] rcu: Use typeof(p) instead of typeof(*p) *
Thread-Topic: [RFC][PATCH] rcu: Use typeof(p) instead of typeof(*p) *
Thread-Index: Ade+e4X0oj4GW2UzTF+XE9nyZN8f2w==
Date:   Mon, 11 Oct 2021 08:39:35 +0000
Message-ID: <4dbff8032f874a6f921ba0555c94eeaf@AcuMS.aculab.com>
References: <20211005094728.203ecef2@gandalf.local.home>
 <505004021.2637.1633446912223.JavaMail.zimbra@efficios.com>
In-Reply-To: <505004021.2637.1633446912223.JavaMail.zimbra@efficios.com>
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

RnJvbTogTWF0aGlldSBEZXNub3llcnMNCj4gU2VudDogMDUgT2N0b2JlciAyMDIxIDE2OjE1DQo+
IA0KPiAtLS0tLSBPbiBPY3QgNSwgMjAyMSwgYXQgOTo0NyBBTSwgcm9zdGVkdCByb3N0ZWR0QGdv
b2RtaXMub3JnIHdyb3RlOg0KPiBbLi4uXQ0KPiA+ICNkZWZpbmUgcmN1X2RlcmVmZXJlbmNlX3Jh
dyhwKSBcDQo+ID4gKHsgXA0KPiA+IAkvKiBEZXBlbmRlbmN5IG9yZGVyIHZzLiBwIGFib3ZlLiAq
LyBcDQo+ID4gCXR5cGVvZihwKSBfX19fX19fX3AxID0gUkVBRF9PTkNFKHApOyBcDQo+ID4gLQko
KHR5cGVvZigqcCkgX19mb3JjZSBfX2tlcm5lbCAqKShfX19fX19fX3AxKSk7IFwNCj4gPiArCSgo
dHlwZW9mKHApIF9fZm9yY2UgX19rZXJuZWwpKF9fX19fX19fcDEpKTsgXA0KPiA+IH0pDQo+IA0K
PiBBRkFJVSBkb2luZyBzbyByZW1vdmVzIHZhbGlkYXRpb24gdGhhdCBAcCBpcyBpbmRlZWQgYSBw
b2ludGVyLCBzbyBhIHVzZXIgbWlnaHQgbWlzdGFrZW5seQ0KPiB0cnkgdG8gdXNlIHJjdV9kZXJl
ZmVyZW5jZSgpIG9uIGFuIGludGVnZXIsIGFuZCBnZXQgYXdheSB3aXRoIGl0LiBJJ20gbm90IHN1
cmUgd2Ugd2FudCB0bw0KPiBsb29zZW4gdGhpcyBjaGVjay4gSSB3b25kZXIgaWYgdGhlcmUgbWln
aHQgYmUgYW5vdGhlciB3YXkgdG8gYWNoaWV2ZSB0aGUgc2FtZSBjaGVjayB3aXRob3V0DQo+IHJl
cXVpcmluZyB0aGUgc3RydWN0dXJlIHRvIGJlIGRlY2xhcmVkLCBlLmcuIHdpdGggX19idWlsdGlu
X3R5cGVzX2NvbXBhdGlibGVfcCA/DQoNCkNvdWxkIHlvdSBwYXNzIHRoZSBwb2ludGVyIHRvIHNv
bWV0aGluZyBsaWtlOg0Kc3RhdGljIF9fYWx3YXlzX2lubGluZSB2b2lkIGZvbyh2b2lkICphcmcp
IHt9Ow0KDQpUaGF0IHdvdWxkIGZhaWwgZm9yIGludGVnZXJzLg0KTm90IHN1cmUgd2hldGhlciBD
RkkgYmxlYXRzIGFib3V0IGZ1bmN0aW9uIHBvaW50ZXJzIHRob3VnaC4NCg0KCURhdmlkDQoNCi0N
ClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBN
aWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxl
cykNCg==

