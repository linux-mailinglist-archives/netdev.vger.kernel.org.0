Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 545AF2A5EA0
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 08:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728922AbgKDHPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 02:15:03 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:38512 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbgKDHPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 02:15:02 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 0A47EubY6006108, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb01.realtek.com.tw[172.21.6.94])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 0A47EubY6006108
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 4 Nov 2020 15:14:56 +0800
Received: from RTEXMBS01.realtek.com.tw (172.21.6.36) by
 RTEXMB01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Wed, 4 Nov 2020 15:14:56 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMBS01.realtek.com.tw (172.21.6.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 4 Nov 2020 15:14:55 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::89f7:e6c3:b043:15fa]) by
 RTEXMB04.realtek.com.tw ([fe80::89f7:e6c3:b043:15fa%3]) with mapi id
 15.01.2044.006; Wed, 4 Nov 2020 15:14:55 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     =?utf-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
Subject: RE: [PATCH net-next 1/5] r8152: use generic USB macros to define product table
Thread-Topic: [PATCH net-next 1/5] r8152: use generic USB macros to define
 product table
Thread-Index: AQHWshavui7U4I+gmkudpd9bR0wfLqm3NRPA///A5ICAAJWLQA==
Date:   Wed, 4 Nov 2020 07:14:55 +0000
Message-ID: <2c5c23b4cbae499e82a307b95685fed1@realtek.com>
References: <20201103192226.2455-1-kabel@kernel.org>
        <20201103192226.2455-2-kabel@kernel.org>
        <b83ddcca96cb40cf8785e6b44f9838e0@realtek.com>
 <20201104070251.52fe638e@kernel.org>
In-Reply-To: <20201104070251.52fe638e@kernel.org>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.146]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TWFyZWsgQmVow7puIDxrYWJlbEBrZXJuZWwub3JnPg0KPiBTZW50OiBXZWRuZXNkYXksIE5vdmVt
YmVyIDQsIDIwMjAgMjowMyBQTQ0KWy4uLl0gDQo+IEJUVyBIYXllcywgaXMgaXQgcG9zc2libGUg
Zm9yIG1lIGdhaW5pbmcgYWNjZXNzIHRvIFJlYWx0ZWsNCj4gZG9jdW1lbnRhdGlvbiBmb3IgdGhl
c2UgY2hpcHMgdW5kZXIgTkRBPyBGb3IgZXhhbXBsZSB2aWEgbXkgZW1wbG95ZXIsDQo+IENaLk5J
Qz8gSSBjYW4ndCBmaW5kIGFueSBzdWNoIGluZm9ybWF0aW9uIG9uIFJlYWx0ZWsgd2Vic2l0ZS4N
Cg0KSSBoYXZlIHRvIGFzayBteSBib3NzLg0KTWF5YmUgSSByZXBseSB5b3UgaW4gcHJpdmF0ZSB3
aGVuIEkgZ2V0IHRoZSBhbnN3ZXIuDQoNCj4gQWxzbyBJIGNvdWxkIG5vdCBkb3dubG9hZCB0aGUg
ZHJpdmVyIGZyb20gUmVhbHRlaydzIHdlYnNpdGUsIEkgaGFkIHRvDQo+IGZpbmQgaXQgb24gZ2l0
aHViLiBXaGVuIGNsaWNraW5nIHRoZSBkb3dubG9hZCBidXR0b24gb24gWzFdLCBpdCBzYXlzOg0K
PiAgIFdhcm5pbmcNCj4gICBUaGUgZm9ybSAjMTAgZG9lcyBub3QgZXhpc3Qgb3IgaXQgaXMgbm90
IHB1Ymxpc2hlZC4NCg0KSSB0cnkgdG8gZG93bmxvYWQgdGhlIGRyaXZlciBmcm9tIG91ciB3ZWJz
aXRlLg0KQW5kIGl0IHNlZW0gdG8gd29yayBmaW5lLg0KSSB3aWxsIHNlbmQgaXQgdG8geW91IGxh
dGVyLg0KDQo+IEJUVzIgSSBhbSBpbnRlcmVzdGVkIHdoZXRoZXIgd2UgY2FuIG1ha2UgdGhlIGlu
dGVybmFsIFBIWSB2aXNpYmxlIHRvDQo+IHRoZSBMaW51eCBQSFkgc3Vic3lzdGVtLg0KDQpJIHRo
aW5rIGl0IGlzIHBvc3NpYmxlLg0KSSBhbSBub3QgZmFtaWxpYXIgd2l0aCB0aGUgTGludXggUEhZ
IHN1YnN5c3RlbSwgc28gSSBoYXZlIG5vIGlkZWEgYWJvdXQNCmhvdyB0byBzdGFydC4NCg0KQmVz
dCBSZWdhcmRzLA0KSGF5ZXMNCg0KDQoNCg==
