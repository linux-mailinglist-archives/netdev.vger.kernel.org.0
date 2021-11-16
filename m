Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF6BC453878
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 18:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238721AbhKPR3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 12:29:20 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:58736 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235906AbhKPR3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 12:29:19 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 1AGHQEVW028157;
        Tue, 16 Nov 2021 11:26:14 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1637083574;
        bh=96YNMg5oGFv9Huoe6KaX52iFJcNPsRAYA6BmzYzF2Yw=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=ip3gfasZdBw3cC51gF1lGPSPEM+9rrBqJQTG4Z3Q4KQMWLYdhhGyS7AhQQi641EUT
         3iZjqSSWkNtzHDPHiq1re/NLi8WWeoUK45uyUZ11ClAEhlEa+wAaU8WWgWWb9GCKpe
         p0vn+IaAbBes9kKEHMRZiDEZTAWXdnvbLQPh9hJ0=
Received: from DFLE106.ent.ti.com (dfle106.ent.ti.com [10.64.6.27])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 1AGHQEVE106258
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 16 Nov 2021 11:26:14 -0600
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 16
 Nov 2021 11:26:13 -0600
Received: from DFLE103.ent.ti.com ([fe80::7431:ea48:7659:dc14]) by
 DFLE103.ent.ti.com ([fe80::7431:ea48:7659:dc14%17]) with mapi id
 15.01.2308.014; Tue, 16 Nov 2021 11:26:13 -0600
From:   "Modi, Geet" <geet.modi@ti.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "Nagalla, Hari" <hnagalla@ti.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sharma, Vikram" <vikram.sharma@ti.com>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>
Subject: Re: [EXTERNAL] Re: [EXTERNAL] Re: [PATCH net-next] net: phy: add
 support for TI DP83561-SP phy
Thread-Topic: [EXTERNAL] Re: [EXTERNAL] Re: [PATCH net-next] net: phy: add
 support for TI DP83561-SP phy
Thread-Index: AQHX2tOMsbw4hsZEBUufpuxwWJPtqKwGkZ6A//+cxQCAAIqzgP//jdKA
Date:   Tue, 16 Nov 2021 17:26:13 +0000
Message-ID: <BBC60868-73DB-47E5-B38C-A733DD8D5A35@ti.com>
References: <20211116102015.15495-1-hnagalla@ti.com>
 <YZO33aidzEwo3YFC@lunn.ch> <722B4304-CE9B-436C-A157-48007D289956@ti.com>
 <YZPY+WSLVcTtkDwm@lunn.ch>
In-Reply-To: <YZPY+WSLVcTtkDwm@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.54.21101001
x-originating-ip: [10.250.200.196]
x-exclaimer-md-config: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Content-Type: text/plain; charset="utf-8"
Content-ID: <F3880C8E3D3CCF46A500BFD044C95D5C@owa.mail.ti.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzIEFuZHJldy4gDQoNCkhhcmksIHBsZWFzZSB1cGRhdGUgdGhlIGNvbW1pdCBtZXNzYWdl
IGFuZCByZS1zdWJtaXQuDQoNCg0KUmVnYXJkcywNCkdlZXQNCg0K77u/T24gMTEvMTYvMjEsIDg6
MTUgQU0sICJBbmRyZXcgTHVubiIgPGFuZHJld0BsdW5uLmNoPiB3cm90ZToNCg0KICAgIE9uIFR1
ZSwgTm92IDE2LCAyMDIxIGF0IDAzOjU4OjI3UE0gKzAwMDAsIE1vZGksIEdlZXQgd3JvdGU6DQog
ICAgPiBIZWxsbyBBbmRyZXcsDQogICAgPiANCiAgICA+ICANCiAgICA+IA0KICAgID4gV2UgYmVp
bmcgVGV4YXMgSW5zdHJ1bWVudHMgYXJlIGNvbnNlcnZhdGl2ZSBhbmQgZG9uJ3QgcHJvbW90ZSBt
ZWFuaW5nbGVzcw0KICAgID4gbWFya2V0aW5nIGFzIHdlbGwuIFBsZWFzZSBub3RlIERQODM1NjEt
U1AgaXMgYSBSYWRpYXRpb24gSGFyZGVuZWQgU3BhY2UgR3JhZGUNCiAgICA+IEdpZ2FiaXQgUEhZ
LiBJdCBoYXMgYmVlbiB0ZXN0ZWQgZm9yIFNpbmdsZSBFdmVudCBMYXRjaCB1cCB1cHRvIDEyMSBN
ZVYsIHRoZQ0KICAgID4gY3JpdGljYWwgcmVsaWFiaWxpdHkgcGFyYW1ldGVyIFNwYWNlIERlc2ln
bnMgbG9vayBmb3IuDQoNCiAgICBUaGF0IHN0YXRlbWVudCBpIGhhdmUgbm8gcHJvYmxlbXMgd2l0
aCwgaXQgaXMgY2xlYXJseSBmYWN0dWFsLg0KDQogICAgPiBUaGUgZHA4MzU2MS1zcCBpcyBhIGhp
Z2ggcmVsaWFiaWxpdHkgZ2lnYWJpdCBldGhlcm5ldCBQSFkgZGVzaWduZWQNCg0KICAgIGlzIGNs
ZWFybHkgTWFya2V0aW5nLCB3aG8gd291bGQgZGVzaWduIGEgbG93IHJlbGlhYmlsaXR5IGdpZ2Fi
aXQNCiAgICBldGhlcm5ldCBQSFk/IEl0IGlzIG1lYW5pbmdsZXNzLg0KDQogICAgU28gcGxlYXNl
IHVzZSB5b3VyIHRleHQgZnJvbSBhYm92ZSBpbiB0aGUgY29tbWl0IG1lc3NhZ2UsIGl0IG5pY2Vs
eQ0KICAgIGRlc2NyaWJlcyB3aGF0IHRoaXMgUEhZIGlzIGluIGVuZ2luZWVyaW5nIHRlcm1zLg0K
DQogICAgICAgQW5kcmV3DQoNCg==
