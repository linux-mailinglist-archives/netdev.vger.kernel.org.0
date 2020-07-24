Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1489B22BD5F
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 07:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgGXFOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 01:14:50 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:49484 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgGXFOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 01:14:50 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.69 with qID 06O5EQbmC027222, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb06.realtek.com.tw[172.21.6.99])
        by rtits2.realtek.com.tw (8.15.2/2.66/5.86) with ESMTPS id 06O5EQbmC027222
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 24 Jul 2020 13:14:26 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMB06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Fri, 24 Jul 2020 13:14:26 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::941:6388:7d34:5c44]) by
 RTEXMB04.realtek.com.tw ([fe80::941:6388:7d34:5c44%3]) with mapi id
 15.01.1779.005; Fri, 24 Jul 2020 13:14:26 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "colin.king@canonical.com" <colin.king@canonical.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi: btcoex: remove redundant initialization of variables ant_num and single_ant_path
Thread-Topic: [PATCH] rtlwifi: btcoex: remove redundant initialization of
 variables ant_num and single_ant_path
Thread-Index: AQHWYQ7XNkhtPOEyEEq9t9OsahfrH6kVql6A
Date:   Fri, 24 Jul 2020 05:14:25 +0000
Message-ID: <1595567665.24550.0.camel@realtek.com>
References: <20200723163214.995226-1-colin.king@canonical.com>
In-Reply-To: <20200723163214.995226-1-colin.king@canonical.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.213]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D57AD17CF0210647B0ADF5717B31ABB2@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTA3LTIzIGF0IDE3OjMyICswMTAwLCBDb2xpbiBLaW5nIHdyb3RlOg0KPiBG
cm9tOiBDb2xpbiBJYW4gS2luZyA8Y29saW4ua2luZ0BjYW5vbmljYWwuY29tPg0KPiANCj4gVGhl
IHZhcmlhYmxlcyBhbnRfbnVtIGFuZCBzaW5nbGVfYW50X3BhdGggYXJlIGJlaW5nIGluaXRpYWxp
emVkIHdpdGggYQ0KPiB2YWx1ZSB0aGF0IGlzIG5ldmVyIHJlYWQgYW5kIGFyZSBiZWluZyB1cGRh
dGVkIGxhdGVyIHdpdGggYSBuZXcgdmFsdWUuDQo+IFRoZSBpbml0aWFsaXphdGlvbnMgYXJlIHJl
ZHVuZGFudCBhbmQgY2FuIGJlIHJlbW92ZWQuDQo+IA0KPiBBZGRyZXNzZXMtQ292ZXJpdHk6ICgi
VW51c2VkIHZhbHVlIikNCj4gU2lnbmVkLW9mZi1ieTogQ29saW4gSWFuIEtpbmcgPGNvbGluLmtp
bmdAY2Fub25pY2FsLmNvbT4NCg0KQWNrZWQtYnk6IFBpbmctS2UgU2hpaCA8cGtzaGloQHJlYWx0
ZWsuY29tPg0KDQpUaGFuayB5b3UNCg0KPiAtLS0NCj4gwqBkcml2ZXJzL25ldC93aXJlbGVzcy9y
ZWFsdGVrL3J0bHdpZmkvYnRjb2V4aXN0L2hhbGJ0Y291dHNyYy5jIHwgMiArLQ0KPiDCoDEgZmls
ZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9idGNvZXhpc3QvaGFsYnRj
b3V0c3JjLmMNCj4gYi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvYnRjb2V4
aXN0L2hhbGJ0Y291dHNyYy5jDQo+IGluZGV4IGE0OTQwYTM4NDJkZS4uNDk0OWY5OTg0NGI1IDEw
MDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvYnRjb2V4
aXN0L2hhbGJ0Y291dHNyYy5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsv
cnRsd2lmaS9idGNvZXhpc3QvaGFsYnRjb3V0c3JjLmMNCj4gQEAgLTEzMTgsNyArMTMxOCw3IEBA
IGJvb2wgZXhoYWxidGNfYmluZF9idF9jb2V4X3dpdGhhZGFwdGVyKHZvaWQgKmFkYXB0ZXIpDQo+
IMKgew0KPiDCoAlzdHJ1Y3QgcnRsX3ByaXYgKnJ0bHByaXYgPSBhZGFwdGVyOw0KPiDCoAlzdHJ1
Y3QgYnRjX2NvZXhpc3QgKmJ0Y29leGlzdCA9IHJ0bF9idGNfY29leGlzdChydGxwcml2KTsNCj4g
LQl1OCBhbnRfbnVtID0gMiwgY2hpcF90eXBlLCBzaW5nbGVfYW50X3BhdGggPSAwOw0KPiArCXU4
IGFudF9udW0sIGNoaXBfdHlwZSwgc2luZ2xlX2FudF9wYXRoOw0KPiDCoA0KPiDCoAlpZiAoIWJ0
Y29leGlzdCkNCj4gwqAJCXJldHVybiBmYWxzZTsNCg0KDQo=
