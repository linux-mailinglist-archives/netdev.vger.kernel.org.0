Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF533567B7
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 11:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349969AbhDGJKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 05:10:00 -0400
Received: from smtpout4.mo541.mail-out.ovh.net ([51.210.94.141]:60403 "EHLO
        smtpout4.mo541.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229869AbhDGJJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 05:09:59 -0400
X-Greylist: delayed 378 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Apr 2021 05:09:59 EDT
Received: from ex2.mail.ovh.net (unknown [10.108.1.206])
        by mo541.mail-out.ovh.net (Postfix) with ESMTPS id 1A9A41342BDC;
        Wed,  7 Apr 2021 11:03:31 +0200 (CEST)
Received: from EX10.indiv2.local (172.16.2.10) by EX9.indiv2.local
 (172.16.2.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.2106.2; Wed, 7 Apr
 2021 11:03:31 +0200
Received: from EX10.indiv2.local ([fe80::62:7b97:e069:79e]) by
 EX10.indiv2.local ([fe80::62:7b97:e069:79e%13]) with mapi id 15.01.2106.013;
 Wed, 7 Apr 2021 11:03:31 +0200
From:   =?utf-8?B?Q2hyaXN0aWFuIFDDtnNzaW5nZXI=?= <christian@poessinger.com>
To:     "u9012063@gmail.com" <u9012063@gmail.com>
CC:     =?utf-8?B?Q2hyaXN0aWFuIFDDtnNzaW5nZXI=?= <christian@poessinger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>
Subject: Re: [PATCH iproute2] erspan: fix JSON output
Thread-Topic: Re: [PATCH iproute2] erspan: fix JSON output
Thread-Index: AdcrjJjAhafw08Z8Rr6Y+9skz9+bKA==
Date:   Wed, 7 Apr 2021 09:03:31 +0000
Message-ID: <1347824917bc426c92a4aaebd41adb83@poessinger.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [84.167.156.165]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Ovh-Tracer-Id: 8458604526396215761
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduledrudejjedguddvucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucenucfjughrpefhvffuthffkfhitgfgggesthgsjhdttddtjeenucfhrhhomhepvehhrhhishhtihgrnhcurfpnshhsihhnghgvrhcuoegthhhrihhsthhirghnsehpohgvshhsihhnghgvrhdrtghomheqnecuggftrfgrthhtvghrnhepudfhtddufffgueeijeehuefgheekvdfhheehvefggfejhfeuieeivdehvddtuddtnecukfhppedtrddtrddtrddtpdekgedrudeijedrudehiedrudeiheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopegvgidvrdhmrghilhdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomheptghhrhhishhtihgrnhesphhovghsshhinhhgvghrrdgtohhmpdhrtghpthhtohepshhtvghphhgvnhesnhgvthifohhrkhhplhhumhgsvghrrdhorhhg
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCBBcHIgNiwgMjAyMSBhdCA5OjI4IEFNIFN0ZXBoZW4gSGVtbWluZ2VyDQo8c3RlcGhl
bkBuZXR3b3JrcGx1bWJlci5vcmc+IHdyb3RlOg0KPg0KPiBUaGUgZm9ybWF0IGZvciBlcnNwYW4g
b3V0cHV0IGlzIG5vdCB2YWxpZCBKU09OLg0KPiBUaGUgZGlyZWN0aW9uIHNob3VsZCBiZSB2YWx1
ZSBhbmQgZXJzcGFuX2RpciBzaG91bGQgYmUgdGhlIGtleS4NCj4NCj4gRml4ZXM6IDI4OTc2MzYy
NjcyMSAoImVyc3BhbjogYWRkIGVyc3BhbiB2ZXJzaW9uIElJIHN1cHBvcnQiKQ0KPiBDYzogdTkw
MTIwNjNAZ21haWwuY29tDQo+IFJlcG9ydGVkLWJ5OiBDaHJpc3RpYW4gUMO2c3NpbmdlciA8Y2hy
aXN0aWFuQHBvZXNzaW5nZXIuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBTdGVwaGVuIEhlbW1pbmdl
ciA8c3RlcGhlbkBuZXR3b3JrcGx1bWJlci5vcmc+DQo+IC0tLQ0KDQpJIGhhdmUgcmVidWlsZCBp
cHJvdXRlMiB3aXRoIHRoZSBtZW50aW9uZWQgY2hhbmdlcyBhYm92ZSBidXQgSSBjYW4NCm5vdCBj
b25maXJtIHRoaXMgd29ya2luZy4gVGhlIGJlaGF2aW9yIGlzIHN0aWxsIGEgbWlzc2luZyB2YWx1
ZQ0KZm9yIHRoZSBKU09OICJlcnNwYW5fZGlyIiBrZXkuDQoNCi0tDQpDaHJpc3RpYW4NCg==
