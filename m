Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 670744CE356
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 08:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbiCEHDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 02:03:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiCEHDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 02:03:20 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D631BD31F2
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 23:02:30 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-227-IBxUC2iNMviUCLLp-QFpZQ-1; Sat, 05 Mar 2022 07:02:27 +0000
X-MC-Unique: IBxUC2iNMviUCLLp-QFpZQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Sat, 5 Mar 2022 07:02:26 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Sat, 5 Mar 2022 07:02:26 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'Dimitrios P. Bouras'" <dimitrios.bouras@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 1/1] eth: Transparently receive IP over LLC/SNAP
Thread-Topic: [PATCH 1/1] eth: Transparently receive IP over LLC/SNAP
Thread-Index: AQHYMCimD+c3nDfKNk2FTT507UZnFqywW3rQ
Date:   Sat, 5 Mar 2022 07:02:26 +0000
Message-ID: <4baebbcb95d84823a7f4ecbe18cbbc3c@AcuMS.aculab.com>
References: <462fa134-bc85-a629-b9c5-8c6ea08b751d@gmail.com>
In-Reply-To: <462fa134-bc85-a629-b9c5-8c6ea08b751d@gmail.com>
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
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URI_DOTEDU autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGltaXRyaW9zIFAuIEJvdXJhcw0KPiBTZW50OiAwNSBNYXJjaCAyMDIyIDAwOjMzDQo+
IA0KPiBQcmFjdGljYWwgdXNlIGNhc2VzIGV4aXN0IHdoZXJlIGJlaW5nIGFibGUgdG8gcmVjZWl2
ZSBFdGhlcm5ldCBwYWNrZXRzDQo+IGVuY2Fwc3VsYXRlZCBpbiBMTEMgU05BUCBpcyB1c2VmdWws
IHdoaWxlIGF0IHRoZSBzYW1lIHRpbWUgZW5jYXBzdWxhdGluZw0KPiByZXBsaWVzICh0cmFuc21p
dHRpbmcgYmFjaykgaW4gTExDIFNOQVAgaXMgbm90IHJlcXVpcmVkLg0KDQpJIHRoaW5rIHlvdSBu
ZWVkIHRvIGJlIG1vcmUgZXhwbGljaXQuDQpJZiByZWNlaXZlZCBmcmFtZXMgaGF2ZSB0aGUgU05B
UCBoZWFkZXIgSSdkIGV4cGVjdCB0cmFuc21pdHRlZCBvbmVzDQp0byBuZWVkIGl0IGFzIHdlbGwu
DQoNCj4gQWNjb3JkaW5nbHksIHRoaXMNCj4gaXMgbm90IGFuIGF0dGVtcHQgdG8gYWRkIGZ1bGwt
Ymxvd24gc3VwcG9ydCBmb3IgSVAgb3ZlciBMTEMgU05BUCwgb25seSBhDQo+ICJoYWNrIiB0aGF0
ICJqdXN0IHdvcmtzIiAtLSBzZWUgQWxhbidzIGNvbW1lbnQgb24gdGhlIHRoZSBMaW51eC1rZXJu
ZWwNCj4gbGlzdCBvbiB0aGlzIHN1YmplY3QgKCJMaW51eCBzdXBwb3J0cyBMTEMvU05BUCBhbmQg
dmFyaW91cyB0aGluZ3Mgb3ZlciBpdA0KPiAoSVBYL0FwcGxldGFsayBERFAgZXRjKSBidXQgbm90
IElQIG92ZXIgaXQsIGFzIGl0J3Mgb25lIG9mIHRob3NlIHN0YW5kYXJkcw0KPiBib2RpZXMgZHJp
dmVuIGJvZ29zaXRpZXMgd2hpY2ggbm9ib2R5IGV2ZXIgYWN0dWFsbHkgZGVwbG95ZWQiIC0tDQo+
IGh0dHA6Ly9sa21sLml1LmVkdS9oeXBlcm1haWwvbGludXgva2VybmVsLzExMDcuMy8wMTI0OS5o
dG1sKS4NCg0KSVAgb3ZlciBTTkFQIGlzIG5lZWRlZCBmb3IgVG9rZW4gcmluZyBuZXR3b3JrcyAo
ZXNwLiAxNk0gb25lcykgd2hlcmUgdGhlDQptdHUgaXMgbXVjaCBsYXJnZXIgdGhhbiAxNTAwIGJ5
dGVzLg0KDQpJdCBpcyBhbGwgdG9vIGxvbmcgYWdvIHRob3VnaCwgSSBjYW4ndCByZW1lbWJlciB3
aGV0aGVyIHRva2VuIHJpbmcNCnRlbmRzIHRvIGJpdC1yZXZlcnNlIHRoZSBNQUMgYWRkcmVzcyAo
bGlrZSBGRERJIGRvZXMpIHdoaWNoIG1lYW5zIHlvdQ0KY2FuJ3QganVzdCBicmlkZ2UgQVJQIHBh
Y2tldHMuDQpTbyB5b3UgbmVlZCBhIGJldHRlciBicmlkZ2UgLSBhbmQgdGhhdCBjYW4gYWRkL3Jl
bW92ZSBzb21lIFNOQVAgaGVhZGVycy4NCg0KLi4uDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVk
IEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5l
cywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

