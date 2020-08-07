Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3646F23E9F3
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 11:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgHGJSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 05:18:15 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:60575 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726932AbgHGJSI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 05:18:08 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-126-koqkZgaFNyeZIHOyATR4EA-1; Fri, 07 Aug 2020 10:18:04 +0100
X-MC-Unique: koqkZgaFNyeZIHOyATR4EA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 7 Aug 2020 10:18:03 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 7 Aug 2020 10:18:03 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Dumazet' <eric.dumazet@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "linux-hams@vger.kernel.org" <linux-hams@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "dccp@vger.kernel.org" <dccp@vger.kernel.org>,
        "linux-decnet-user@lists.sourceforge.net" 
        <linux-decnet-user@lists.sourceforge.net>,
        "linux-wpan@vger.kernel.org" <linux-wpan@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "mptcp@lists.01.org" <mptcp@lists.01.org>,
        "lvs-devel@vger.kernel.org" <lvs-devel@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "linux-x25@vger.kernel.org" <linux-x25@vger.kernel.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Subject: RE: [PATCH 25/26] net: pass a sockptr_t into ->setsockopt
Thread-Topic: [PATCH 25/26] net: pass a sockptr_t into ->setsockopt
Thread-Index: AQHWbD/ze4VO5Mh7NUG6O93LfP2Gq6ksXaow
Date:   Fri, 7 Aug 2020 09:18:03 +0000
Message-ID: <f21589f1262640b09ca27ed20f8e6790@AcuMS.aculab.com>
References: <20200723060908.50081-1-hch@lst.de>
 <20200723060908.50081-26-hch@lst.de>
 <6357942b-0b6e-1901-7dce-e308c9fac347@gmail.com>
In-Reply-To: <6357942b-0b6e-1901-7dce-e308c9fac347@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRXJpYyBEdW1hemV0DQo+IFNlbnQ6IDA2IEF1Z3VzdCAyMDIwIDIzOjIxDQo+IA0KPiBP
biA3LzIyLzIwIDExOjA5IFBNLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToNCj4gPiBSZXdvcmsg
dGhlIHJlbWFpbmluZyBzZXRzb2Nrb3B0IGNvZGUgdG8gcGFzcyBhIHNvY2twdHJfdCBpbnN0ZWFk
IG9mIGENCj4gPiBwbGFpbiB1c2VyIHBvaW50ZXIuICBUaGlzIHJlbW92ZXMgdGhlIGxhc3QgcmVt
YWluaW5nIHNldF9mcyhLRVJORUxfRFMpDQo+ID4gb3V0c2lkZSBvZiBhcmNoaXRlY3R1cmUgc3Bl
Y2lmaWMgY29kZS4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxo
Y2hAbHN0LmRlPg0KPiA+IEFja2VkLWJ5OiBTdGVmYW4gU2NobWlkdCA8c3RlZmFuQGRhdGVuZnJl
aWhhZmVuLm9yZz4gW2llZWU4MDIxNTRdDQo+ID4gLS0tDQo+IA0KPiANCj4gLi4uDQo+IA0KPiA+
IGRpZmYgLS1naXQgYS9uZXQvaXB2Ni9yYXcuYyBiL25ldC9pcHY2L3Jhdy5jDQo+ID4gaW5kZXgg
NTk0ZTAxYWQ2NzBhYTYuLjg3NGYwMWNkN2FlYzQyIDEwMDY0NA0KPiA+IC0tLSBhL25ldC9pcHY2
L3Jhdy5jDQo+ID4gKysrIGIvbmV0L2lwdjYvcmF3LmMNCj4gPiBAQCAtOTcyLDEzICs5NzIsMTMg
QEAgc3RhdGljIGludCByYXd2Nl9zZW5kbXNnKHN0cnVjdCBzb2NrICpzaywgc3RydWN0IG1zZ2hk
ciAqbXNnLCBzaXplX3QgbGVuKQ0KPiA+ICB9DQo+ID4NCj4gDQo+IC4uLg0KPiANCj4gPiAgc3Rh
dGljIGludCBkb19yYXd2Nl9zZXRzb2Nrb3B0KHN0cnVjdCBzb2NrICpzaywgaW50IGxldmVsLCBp
bnQgb3B0bmFtZSwNCj4gPiAtCQkJICAgIGNoYXIgX191c2VyICpvcHR2YWwsIHVuc2lnbmVkIGlu
dCBvcHRsZW4pDQo+ID4gKwkJCSAgICAgICBzb2NrcHRyX3Qgb3B0dmFsLCB1bnNpZ25lZCBpbnQg
b3B0bGVuKQ0KPiA+ICB7DQo+ID4gIAlzdHJ1Y3QgcmF3Nl9zb2NrICpycCA9IHJhdzZfc2soc2sp
Ow0KPiA+ICAJaW50IHZhbDsNCj4gPg0KPiA+IC0JaWYgKGdldF91c2VyKHZhbCwgKGludCBfX3Vz
ZXIgKilvcHR2YWwpKQ0KPiA+ICsJaWYgKGNvcHlfZnJvbV9zb2NrcHRyKCZ2YWwsIG9wdHZhbCwg
c2l6ZW9mKHZhbCkpKQ0KPiA+ICAJCXJldHVybiAtRUZBVUxUOw0KPiA+DQo+IA0KPiBjb252ZXJ0
aW5nIGdldF91c2VyKC4uLikgICB0byAgY29weV9mcm9tX3NvY2twdHIoLi4uKSByZWFsbHkgYXNz
dW1lZCB0aGUgb3B0bGVuDQo+IGhhcyBiZWVuIHZhbGlkYXRlZCB0byBiZSA+PSBzaXplb2YoaW50
KSBlYXJsaWVyLg0KPiANCj4gV2hpY2ggaXMgbm90IGFsd2F5cyB0aGUgY2FzZSwgZm9yIGV4YW1w
bGUgaGVyZS4NCj4gDQo+IFVzZXIgYXBwbGljYXRpb24gY2FuIGZvb2wgdXMgcGFzc2luZyBvcHRs
ZW49MCwgYW5kIGEgdXNlciBwb2ludGVyIG9mIGV4YWN0bHkgVEFTS19TSVpFLTENCg0KV29uJ3Qg
dGhlIHVzZXIgcG9pbnRlciBmb3JjZSBjb3B5X2Zyb21fc29ja3B0cigpIHRvIGNhbGwNCmNvcHlf
ZnJvbV91c2VyKCkgd2hpY2ggd2lsbCB0aGVuIGRvIGFjY2Vzc19vaygpIG9uIHRoZSBlbnRpcmUN
CnJhbmdlIGFuZCBzbyByZXR1cm4gLUVGQVVMVC4NCg0KVGhlIG9ubHkgcHJvYmxlbXMgYXJpc2Ug
aWYgdGhlIGtlcm5lbCBjb2RlIGFkZHMgYW4gb2Zmc2V0IHRvIHRoZQ0KdXNlciBhZGRyZXNzLg0K
QW5kIHRoZSBsYXRlciBwYXRjaCBhZGRlZCBhbiBvZmZzZXQgdG8gdGhlIGNvcHkgZnVuY3Rpb25z
Lg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJv
YWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24g
Tm86IDEzOTczODYgKFdhbGVzKQ0K

