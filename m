Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76C39249285
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 03:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbgHSBsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 21:48:21 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3068 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726703AbgHSBsU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 21:48:20 -0400
Received: from dggeme704-chm.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id A1CB0E09B342EE1E188F;
        Wed, 19 Aug 2020 09:48:17 +0800 (CST)
Received: from dggeme753-chm.china.huawei.com (10.3.19.99) by
 dggeme704-chm.china.huawei.com (10.1.199.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Wed, 19 Aug 2020 09:48:16 +0800
Received: from dggeme753-chm.china.huawei.com ([10.7.64.70]) by
 dggeme753-chm.china.huawei.com ([10.7.64.70]) with mapi id 15.01.1913.007;
 Wed, 19 Aug 2020 09:48:15 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "martin.varghese@nokia.com" <martin.varghese@nokia.com>,
        Florian Westphal <fw@strlen.de>,
        Pravin B Shelar <pshelar@ovn.org>,
        Davide Caratti <dcaratti@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "shmulik@metanetworks.com" <shmulik@metanetworks.com>,
        "kyk.segfault@gmail.com" <kyk.segfault@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: Relax the npages test against MAX_SKB_FRAGS
Thread-Topic: [PATCH] net: Relax the npages test against MAX_SKB_FRAGS
Thread-Index: AdZ1yocb4TumB20X+kO1y6lKjHGROQ==
Date:   Wed, 19 Aug 2020 01:48:15 +0000
Message-ID: <c6f895470c8c4c36ad1ed2c5ebfbe82c@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.176.142]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RXJpYyBEdW1hemV0IDxlZHVtYXpldEBnb29nbGUuY29tPiB3cm90ZToNCj5PbiBUdWUsIEF1ZyAx
OCwgMjAyMCBhdCA0OjU4IEFNIE1pYW9oZSBMaW4gPGxpbm1pYW9oZUBodWF3ZWkuY29tPiB3cm90
ZToNCj4+DQo+PiBUaGUgbnBhZ2VzIHRlc3QgYWdhaW5zdCBNQVhfU0tCX0ZSQUdTIGNhbiBiZSBy
ZWxheGVkIGlmIHdlIHN1Y2NlZWQgdG8gDQo+PiBhbGxvY2F0ZSBoaWdoIG9yZGVyIHBhZ2VzIGFz
IHRoZSBub3RlIGluIGNvbW1lbnQgc2FpZC4NCj4+DQo+DQo+DQo+V2UgZG8gbm90IHdhbnQgdGhp
cyBjaGFuZ2UuDQo+DQo+VGhpcyBpbnRlcmZhY2UgaXMgdXNlZCBieSBkYXRhZ3JhbSBwcm92aWRl
cnMsIHdlIGRvIG5vdCB3YW50IHRvIGNsYWltIHRoZXkgY2FuIHNhZmVseSB1c2Ugc2tiIGFsbG9j
YXRpb25zIG92ZXIgNjRLQi4NCj4NCj5SZXR1cm5pbmcgLUVNU0dTSVpFIHNob3VsZCBub3QgZGVw
ZW5kIG9uIGF2YWlsYWJpbGl0eSBvZiBoaWdoLW9yZGVyIHBhZ2VzLg0KPg0KPlRoZSBjb21tZW50
IHdhcyBhIGhpbnQsIGJ1dCB3ZSBuZWVkIGZpcnN0IGEgdmFsaWQgdXNlciBiZWZvcmUgY29uc2lk
ZXJpbmcgZXhwYW5kaW5nIHRoZSBpbnRlcmZhY2UuDQoNCkkgc2VlLiBNYW55IHRoYW5rcyBmb3Ig
cmVwbHkgYW5kIGV4cGxhaW5hdGlvbi4gOikNCg0K
