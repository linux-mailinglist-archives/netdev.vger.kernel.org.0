Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C546506868
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 12:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350522AbiDSKOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 06:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350513AbiDSKOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 06:14:45 -0400
Received: from mg.sunplus.com (mswedge1.sunplus.com [60.248.182.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C84A11BE85;
        Tue, 19 Apr 2022 03:12:01 -0700 (PDT)
X-MailGates: (compute_score:DELIVER,40,3)
Received: from 172.17.9.202
        by mg01.sunplus.com with MailGates ESMTP Server V5.0(27730:0:AUTH_RELAY)
        (envelope-from <wells.lu@sunplus.com>); Tue, 19 Apr 2022 18:07:55 +0800 (CST)
Received: from sphcmbx02.sunplus.com.tw (172.17.9.112) by
 sphcmbx01.sunplus.com.tw (172.17.9.202) with Microsoft SMTP Server (TLS) id
 15.0.1497.26; Tue, 19 Apr 2022 18:07:55 +0800
Received: from sphcmbx02.sunplus.com.tw ([fe80::fd3d:ad1a:de2a:18bd]) by
 sphcmbx02.sunplus.com.tw ([fe80::fd3d:ad1a:de2a:18bd%14]) with mapi id
 15.00.1497.026; Tue, 19 Apr 2022 18:07:55 +0800
From:   =?big5?B?V2VsbHMgTHUgp2aq2sTL?= <wells.lu@sunplus.com>
To:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
CC:     Wells Lu <wellslutw@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
        "roopa@nvidia.com" <roopa@nvidia.com>,
        "edumazet@google.com" <edumazet@google.com>
Subject: RE: [PATCH net-next v8 2/2] net: ethernet: Add driver for Sunplus
 SP7021
Thread-Topic: [PATCH net-next v8 2/2] net: ethernet: Add driver for Sunplus
 SP7021
Thread-Index: AQHYTt60q5RPpkXZvk6NoPqcLCmB1Kzuz6GAgAAV3oCACBN/MA==
Date:   Tue, 19 Apr 2022 10:07:55 +0000
Message-ID: <e784ab5356aa4b6e93765b54bdefea0a@sphcmbx02.sunplus.com.tw>
References: <1649817118-14667-1-git-send-email-wellslutw@gmail.com>
 <1649817118-14667-3-git-send-email-wellslutw@gmail.com>
 <20220414141825.50eb8b6a@kernel.org> <Ylgjab6qLsrzKZKc@lunn.ch>
In-Reply-To: <Ylgjab6qLsrzKZKc@lunn.ch>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [172.25.108.39]
Content-Type: text/plain; charset="big5"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiA+ID4gKwkJLyogR2V0IG1hYy1hZGRyZXNzIGZyb20gbnZtZW0uICovDQo+ID4gPiArCQlyZXQg
PSBzcGwyc3dfbnZtZW1fZ2V0X21hY19hZGRyZXNzKCZwZGV2LT5kZXYsIHBvcnRfbnAsIG1hY19h
ZGRyKTsNCj4gPiA+ICsJCWlmIChyZXQpIHsNCj4gPiA+ICsJCQlkZXZfaW5mbygmcGRldi0+ZGV2
LCAiR2VuZXJhdGUgYSByYW5kb20gbWFjIGFkZHJlc3MhXG4iKTsNCj4gPiA+ICsNCj4gPiA+ICsJ
CQkvKiBHZW5lcmF0ZSBhIG1hYyBhZGRyZXNzIHVzaW5nIE9VSSBvZiBTdW5wbHVzIFRlY2hub2xv
Z3kNCj4gPiA+ICsJCQkgKiBhbmQgcmFuZG9tIGNvbnRyb2xsZXIgbnVtYmVyLg0KPiA+ID4gKwkJ
CSAqLw0KPiA+ID4gKwkJCW1hY19hZGRyWzBdID0gMHhmYzsgLyogT1VJIG9mIFN1bnBsdXM6IGZj
OjRiOmJjICovDQo+ID4gPiArCQkJbWFjX2FkZHJbMV0gPSAweDRiOw0KPiA+ID4gKwkJCW1hY19h
ZGRyWzJdID0gMHhiYzsNCj4gPiA+ICsJCQltYWNfYWRkclszXSA9IGdldF9yYW5kb21faW50KCkg
JSAyNTY7DQo+ID4gPiArCQkJbWFjX2FkZHJbNF0gPSBnZXRfcmFuZG9tX2ludCgpICUgMjU2Ow0K
PiA+ID4gKwkJCW1hY19hZGRyWzVdID0gZ2V0X3JhbmRvbV9pbnQoKSAlIDI1NjsNCj4gPg0KPiA+
IEkgZG9uJ3QgdGhpbmsgeW91IGNhbiBkbyB0aGF0LiBFaXRoZXIgeW91IHVzZSB5b3VyIE9VSSBh
bmQgYXNzaWduIHRoZQ0KPiA+IGFkZHJlc3MgYXQgbWFudWZhY3R1cmUgb3IgeW91IG11c3QgdXNl
IGEgbG9jYWxseSBhZG1pbmlzdGVyZWQgYWRkcmVzcy4NCj4gPiBBbmQgaWYgbG9jYWxseSBhZG1p
bmlzdGVyZWQgYWRkcmVzcyBpcyB1c2VkIGl0IGJldHRlciBiZSBjb21wbGV0ZWx5DQo+ID4gcmFu
ZG9tIHRvIGxvd2VyIHRoZSBwcm9iYWJpbGl0eSBvZiBjb2xsaXNpb24gdG8gYWJzb2x1dGUgbWlu
aW11bS4NCj4gDQo+IEkgY29tbWVudGVkIGFib3V0IHRoYXQgaW4gYW4gZWFybGllciB2ZXJzaW9u
IG9mIHRoZXNlIHBhdGNoZXMuIFdlIHByb2JhYmx5IG5lZWQgYSBxdW90ZQ0KPiBmcm9tIHRoZSA4
MDIuMSBvciA4MDIuMyB3aGljaCBzYXlzIHRoaXMgaXMgTy5LLg0KPiANCj4gCSBBbmRyZXcNCg0K
SGkgQW5kcmV3LA0KDQpJIHBsYW4gdG8gcmVwbGFjZSBhYm92ZSBzdGF0ZW1lbnRzIHdpdGg6DQoN
CglldGhfcmFuZG9tX2FkZHIobWFjX2FkZHIpOw0KDQpldGhfcmFuZG9tX2FkZHIoKSBnZW5lcmF0
ZXMgbG9jYWxseSBhZG1pbmlzdGVyZWQgKHJhbmRvbSkgYWRkcmVzcy4NCg0KRG8geW91IG1lYW4g
SSBjYW4ga2VlcCB1c2UgdGhlIG1hYyBhZGRyZXNzOiAiT1VJICsgcmFuZG9tIG51bWJlciI/DQpP
bmx5IG5lZWQgdG8gYWRkIGNvbW1lbnQgZm9yIGl0LiANCldoYXQgY29tbWVudCBzaG91bGQgSSBh
ZGQ/IFdoaWNoIG9uZSBkbyB5b3UgcmVjb21tZW5kPw0KDQpUaGFuayB5b3UgdmVyeSBtdWNoIGZv
ciB5b3VyIHJldmlldy4NCg0KDQpCZXN0IHJlZ2FyZHMsDQpXZWxscw0KDQo=
