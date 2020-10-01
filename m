Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43ACA27FB78
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 10:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731365AbgJAI3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 04:29:17 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:38323 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730695AbgJAI3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 04:29:16 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-225-ILwDGfD-PReVCn78K21u1g-1; Thu, 01 Oct 2020 09:29:11 +0100
X-MC-Unique: ILwDGfD-PReVCn78K21u1g-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 1 Oct 2020 09:29:11 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 1 Oct 2020 09:29:11 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Petko Manolov' <petkan@nucleusys.com>,
        David Bilsby <d.bilsby@virgin.net>
CC:     Thor Thayer <thor.thayer@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: Altera TSE driver not working in 100mbps mode
Thread-Topic: Altera TSE driver not working in 100mbps mode
Thread-Index: AQHWl722UOgH1w9MMUi35dKxafwVgqmCaXnQ
Date:   Thu, 1 Oct 2020 08:29:11 +0000
Message-ID: <c1e0be78292e4044951227a66c1822c7@AcuMS.aculab.com>
References: <20191127135419.7r53qw6vtp747x62@p310>
 <20191203092918.52x3dfuvnryr5kpx@carbon>
 <c8e4fc3a-0f40-45b6-d9c8-f292c3fdec9d@virgin.net>
 <20200917064239.GA40050@p310>
 <9f312748-1069-4a30-ba3f-d1de6d84e920@virgin.net>
 <20200918171440.GA1538@p310>
 <bbd5cc3a-51a9-d46c-ef24-f0bb4d6498fe@virgin.net>
 <20201001063959.GA8609@carbon>
In-Reply-To: <20201001063959.GA8609@carbon>
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

PiBUaGVzZSBhcmUgaW1wbGVtZW50YXRpb24gc3BlY2lmaWMuICBEb24ndCBmb3JnZXQgeW91J3Jl
IG9uIEZQR0EgZGV2aWNlLCB3aGljaA0KPiBhbGxvd3MgZm9yIGEgbG90IG9mIGZsZXhpYmlsaXR5
IC0gbWVtb3J5IHJlZ2lvbiBhZGRyZXNzIGFuZCBzaXplIHNoaWZ0cywgMzIgdnMNCj4gMTYgYml0
IHdpZGUgbWVtb3J5LCBldGMuICBZb3UgaGF2ZSB0byB0YWtlIGludG8gYWNjb3VudCBib3RoLCBU
U0UncyBtYW51YWwgYXMNCj4gd2VsbCBhcyB0aGUgYWN0dWFsIGltcGxlbWVudGF0aW9uIGRvY3Mu
DQoNCkFyZSB5b3UgYnVpbGRpbmcgeW91ciBvd24gZnBnYSBpbWFnZT8NCg0KSWYgc28gSSdkIGNv
bnNpZGVyIHVzaW5nIHNpZ25hbHRhcCB0byBsb29rICdpbnNpZGUnIHRoZSBUU0UNCmxvZ2ljIHRv
IHNlZSBpZiBpdCBhY3R1YWxseSB0cnlpbmcgdG8gc2VuZCBhbnl0aGluZyBhdCBhbGwuDQoNCglE
YXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91
bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5
NzM4NiAoV2FsZXMpDQo=

