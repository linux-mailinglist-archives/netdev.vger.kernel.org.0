Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D40B5F9EE7
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 14:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbiJJMyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 08:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbiJJMyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 08:54:18 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA671558EA
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 05:54:16 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-308-DFMKOn1AMvu0Lixm1Isi4A-1; Mon, 10 Oct 2022 13:54:14 +0100
X-MC-Unique: DFMKOn1AMvu0Lixm1Isi4A-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Mon, 10 Oct
 2022 13:54:12 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.040; Mon, 10 Oct 2022 13:54:12 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Alexei Starovoitov' <alexei.starovoitov@gmail.com>,
        Paul Moore <paul@paul-moore.com>
CC:     Martin KaFai Lau <martin.lau@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>
Subject: RE: SO_PEERSEC protections in sk_getsockopt()?
Thread-Topic: SO_PEERSEC protections in sk_getsockopt()?
Thread-Index: AQHY2peNL0l8xeG/wU6MBAmpwQpDnq4HlZFQ
Date:   Mon, 10 Oct 2022 12:54:12 +0000
Message-ID: <df4df4eb70594d65b40865ca00ecad09@AcuMS.aculab.com>
References: <CAHC9VhTGE1cf_WtDn4aDUY=E-m--4iZXWiNTwPZrP9AVoq17cw@mail.gmail.com>
 <CAHC9VhT2LK_P+_LuBYDEHnkNkAX6fhNArN_N5bF1qwGed+Kyww@mail.gmail.com>
 <CAADnVQ+kRCfKn6MCvfYGhpHF0fUWBU-qJqvM=1YPfj02jM9zKw@mail.gmail.com>
 <CAHC9VhRcr03ZCURFi=EJyPvB3sgi44_aC5ixazC43Zs2bNJiDw@mail.gmail.com>
 <CAADnVQJ5VgTNiEhEhOtESRrK0q3-pUSbZfAWL=tXv-s2GXqq8Q@mail.gmail.com>
In-Reply-To: <CAADnVQJ5VgTNiEhEhOtESRrK0q3-pUSbZfAWL=tXv-s2GXqq8Q@mail.gmail.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQWxleGVpIFN0YXJvdm9pdG92DQo+IFNlbnQ6IDA3IE9jdG9iZXIgMjAyMiAyMjo1NQ0K
Li4uLg0KPiBOb3QgZWFzeSBhdCBhbGwuDQo+IFRoZXJlIGlzIG9ubHkgd2F5IHBsYWNlIGluIHRo
ZSB3aG9sZSBrZXJuZWwgdGhhdCBkb2VzOg0KPiAgICAgICAgICAgICAgICAgcmV0dXJuIHNrX2dl
dHNvY2tvcHQoc2ssIFNPTF9TT0NLRVQsIG9wdG5hbWUsDQo+ICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBLRVJORUxfU09DS1BUUihvcHR2YWwpLA0KPiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgS0VSTkVMX1NPQ0tQVFIob3B0bGVuKSk7DQoNClVudGls
IEkgYWRkIGNoYW5nZSBteSBvdXQgb2YgdHJlZSBkcml2ZXIgdG8gd29yayB3aXRoDQp0aGUgbmV3
IGNvZGUuDQooQWx0aG91Z2ggaXQgYWN0dWFsbHkgbmVlZHMgdG8gZG8gYSBnZXRzb2Nrb3B0IGlu
dG8gU0NUUC4pDQoNCkkgZGlkbid0IHNwb3QgdGhlIGNoYW5nZSB0byBza19nZXRzb2Nrb3B0KCkg
Z29pbmcgdGhvdWdoLg0KQnV0IEtFUk5FTF9TT0NLUFRSKCkgaXMgcmVhbGx5IHRoZSB3cm9uZyBm
dW5jdGlvbi90eXBlDQpmb3IgdGhlIGxlbmd0aC4NCkl0IHdvdWxkIGJlIG11Y2ggc2FmZXIgdG8g
aGF2ZSBhIHN0cnVjdCB3aXRoIHR3byBtZW1iZXJzLA0Kb25lIGFuIF9fdXNlciBwb2ludGVyIGFu
ZCBvbmUgYSBrZXJuZWwgcG9pbnRlciBib3RoIHRvDQpzb2NrbGVuX3QuDQoNCkl0IGlzbid0IHJl
YWxseSBpZGVhbCBmb3IgdGhlIGJ1ZmZlciBwb2ludGVyIGVpdGhlci4NClRoYXQgc3RhcnRlZCBh
cyBhIHNpbmdsZSBmaWVsZCAoYXNzdW1pbmcgdGhlIGNhbGxlcg0KaGFzIHZlcmlmaWVkIHRoZSB1
c2VyL2tlcm5lbCBzdGF0dXMpLCB0aGVuIHRoZSBpc19rZXJuZWwNCmZpZWxkIHdhcyBhZGRlZCBm
b3IgYXJjaGl0ZWN0dXJlcyB3aGVyZSB1c2VyL2tlcm5lbA0KYWRkcmVzc2VzIHVzZSB0aGUgc2Ft
ZSB2YWx1ZXMuDQpUaGVuIGEgaG9ycmlkIGJ1ZyAoZm9yZ290dGVuIHdoZXJlKSBmb3JjZWQgdGhl
IGlzX2tlcm5lbA0KZmllbGQgYmUgdXNlZCBldmVyeXdoZXJlLg0KQWdhaW4gYSBzdHJ1Y3R1cmUg
d2l0aCB0d28gcG9pbnRlcnMgd291bGQgYmUgbXVjaCBzYWZlci4NCg0KSW5kZWVkIHRoZSBsZW5n
dGggY291bGQgbGlrZWx5IGJlIGluY2x1ZGVkIGFzIHdlbGwuDQpUaGF0IHdvdWxkIGV2ZW4gZ2l2
ZSBzY29wZSBmb3IgYSBzaG9ydCB1c2VyIGJ1ZmZlciBiZWluZw0KY29waWVkIGludG8ga2VybmVs
IG1lbW9yeSB3aGlsZSBsZXR0aW5nIGNvZGUgdGhhdCBuZWVkcw0KYSBsb25nIGJ1ZmZlciAob3Ig
aWdub3JlcyB0aGUgbGVuZ3RoKSBzdGlsbCBkaXJlY3RseQ0KYWNjZXNzIHVzZXJzcGFjZS4NCg0K
SSBjYW4ndCByZW1lbWJlciwgYnV0IHNvbWV0aGluZyBtYWtlcyBtZSB0aGluayB0aGF0IGEgbG90
DQpvZiB0aGUgJ25vdCBjaGVja2luZyB0aGUgbGVuZ3RoJyBzZXRzb2Nrb3B0IGNhbGxzIHdlcmUg
aW4NCmRlY25ldCAtIHdoaWNoIGhhcyBub3cgYmVlbiBkZWxldGVkLg0KDQoJRGF2aWQNCg0KLQ0K
UmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1p
bHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVz
KQ0K

