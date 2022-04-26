Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAED050EE1F
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 03:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240966AbiDZBlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 21:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240343AbiDZBlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 21:41:21 -0400
Received: from mg.sunplus.com (mswedge2.sunplus.com [60.248.182.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D514713FA0;
        Mon, 25 Apr 2022 18:38:12 -0700 (PDT)
X-MailGates: (flag:3,DYNAMIC,RELAY,NOHOST:PASS)(compute_score:DELIVER,40
        ,3)
Received: from 172.17.9.202
        by mg02.sunplus.com with MailGates ESMTP Server V5.0(12336:0:AUTH_RELAY)
        (envelope-from <wells.lu@sunplus.com>); Tue, 26 Apr 2022 09:37:47 +0800 (CST)
Received: from sphcmbx02.sunplus.com.tw (172.17.9.112) by
 sphcmbx01.sunplus.com.tw (172.17.9.202) with Microsoft SMTP Server (TLS) id
 15.0.1497.26; Tue, 26 Apr 2022 09:37:42 +0800
Received: from sphcmbx02.sunplus.com.tw ([fe80::fd3d:ad1a:de2a:18bd]) by
 sphcmbx02.sunplus.com.tw ([fe80::fd3d:ad1a:de2a:18bd%14]) with mapi id
 15.00.1497.026; Tue, 26 Apr 2022 09:37:42 +0800
From:   =?big5?B?V2VsbHMgTHUgp2aq2sTL?= <wells.lu@sunplus.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Wells Lu <wellslutw@gmail.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
        "roopa@nvidia.com" <roopa@nvidia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "edumazet@google.com" <edumazet@google.com>
Subject: RE: [PATCH net-next v9 2/2] net: ethernet: Add driver for Sunplus
 SP7021
Thread-Topic: [PATCH net-next v9 2/2] net: ethernet: Add driver for Sunplus
 SP7021
Thread-Index: AQHYWI+jS4JtiaXpFUyrVgs1l1MK560ASrgAgAEfemA=
Date:   Tue, 26 Apr 2022 01:37:42 +0000
Message-ID: <3b9a6b2ce9e84b82963ad9a46b871b35@sphcmbx02.sunplus.com.tw>
References: <1650882640-7106-1-git-send-email-wellslutw@gmail.com>
        <1650882640-7106-3-git-send-email-wellslutw@gmail.com>
 <20220425092446.477bd8f5@hermes.local>
In-Reply-To: <20220425092446.477bd8f5@hermes.local>
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
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU3RlcGhlbiwNCg0KDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N1
bnBsdXMvc3BsMnN3X2RyaXZlci5oDQo+ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zdW5wbHVz
L3NwbDJzd19kcml2ZXIuaA0KPiA+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+ID4gaW5kZXggMDAw
MDAwMDAwLi41ZjE3N2IzYWYNCj4gPiAtLS0gL2Rldi9udWxsDQo+ID4gKysrIGIvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvc3VucGx1cy9zcGwyc3dfZHJpdmVyLmgNCj4gPiBAQCAtMCwwICsxLDEyIEBA
DQo+ID4gKy8qIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wICovDQo+ID4gKy8qIENv
cHlyaWdodCBTdW5wbHVzIFRlY2hub2xvZ3kgQ28uLCBMdGQuDQo+ID4gKyAqICAgICAgIEFsbCBy
aWdodHMgcmVzZXJ2ZWQuDQo+ID4gKyAqLw0KPiA+ICsNCj4gPiArI2lmbmRlZiBfX1NQTDJTV19E
UklWRVJfSF9fDQo+ID4gKyNkZWZpbmUgX19TUEwyU1dfRFJJVkVSX0hfXw0KPiA+ICsNCj4gPiAr
I2RlZmluZSBTUEwyU1dfUlhfTkFQSV9XRUlHSFQJMTYNCj4gPiArI2RlZmluZSBTUEwyU1dfVFhf
TkFQSV9XRUlHSFQJMTYNCj4gDQo+IFdoeSBkZWZpbmUgeW91ciBvd24/IHRoZXJlIGlzIE5BUElf
UE9MTF9XRUlHSFQgYWxyZWFkeSBkZWZpbmVkIGluIG5ldGRldmljZS5oDQoNCkkgZGlkbid0IGtu
b3cgdGhlcmUgaXMgTkFQSV9QT0xMX1dFSUdIVCBkZWZpbmVkIGluIG5ldGRldmljZS5oLg0KSSds
bCByZW1vdmUgbXkgb3duIGRlZmluZSBhbmQgdXNlIGl0IG5leHQgcGF0Y2guDQoNClRoYW5rIHlv
dSBmb3IgeW91ciByZXZpZXcuDQoNCg0KQmVzdCByZWdhcmRzLA0KV2VsbHMNCg==
