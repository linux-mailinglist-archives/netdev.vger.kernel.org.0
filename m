Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1834211C2AB
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 02:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727615AbfLLBrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 20:47:36 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:46061 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727473AbfLLBrg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 20:47:36 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID xBC1lLY7028248, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id xBC1lLY7028248
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Dec 2019 09:47:21 +0800
Received: from RTEXDAG01.realtek.com.tw (172.21.6.100) by
 RTITCAS11.realtek.com.tw (172.21.6.12) with Microsoft SMTP Server (TLS) id
 14.3.468.0; Thu, 12 Dec 2019 09:47:21 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXDAG01.realtek.com.tw (172.21.6.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 12 Dec 2019 09:47:21 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::7d15:f8ee:cfc7:88ce]) by
 RTEXMB04.realtek.com.tw ([fe80::7d15:f8ee:cfc7:88ce%6]) with mapi id
 15.01.1779.005; Thu, 12 Dec 2019 09:47:21 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "straube.linux@gmail.com" <straube.linux@gmail.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] rtlwifi: convert rtl8192{ce,cu,de} to use generic functions
Thread-Topic: [PATCH 0/6] rtlwifi: convert rtl8192{ce,cu,de} to use generic
 functions
Thread-Index: AQHVsDpzfsqbYxD/WEOoQ833A6RTfKe1NZ6A
Date:   Thu, 12 Dec 2019 01:47:21 +0000
Message-ID: <1576115241.2733.1.camel@realtek.com>
References: <20191211154755.15012-1-straube.linux@gmail.com>
In-Reply-To: <20191211154755.15012-1-straube.linux@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.95]
Content-Type: text/plain; charset="utf-8"
Content-ID: <EB2C6ECAB6231E48B97459A61CA72D91@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTEyLTExIGF0IDE2OjQ3ICswMTAwLCBNaWNoYWVsIFN0cmF1YmUgd3JvdGU6
DQo+IFRoaXMgc2VyaWVzIGNvbnZlcnRzIHRoZSBkcml2ZXJzIHJ0bDgxOTJ7Y2UsY3UsZGV9IHRv
IHVzZSB0aGUgZ2VuZXJpYw0KPiBmdW5jdGlvbnMgcnRsX3F1ZXJ5X3J4cHdycGVyY2VudGFnZSBh
bmQgcnRsX3NpZ25hbF9zY2FsZV9tYXBwaW5nLg0KPiANCj4gTWljaGFlbCBTdHJhdWJlICg2KToN
Cj4gwqAgcnRsd2lmaTogcnRsODE5MmNlOiB1c2UgZ2VuZXJpYyBydGxfcXVlcnlfcnhwd3JwZXJj
ZW50YWdlDQo+IMKgIHJ0bHdpZmk6IHJ0bDgxOTJjdTogdXNlIGdlbmVyaWMgcnRsX3F1ZXJ5X3J4
cHdycGVyY2VudGFnZQ0KPiDCoCBydGx3aWZpOiBydGw4MTkyZGU6IHVzZSBnZW5lcmljIHJ0bF9x
dWVyeV9yeHB3cnBlcmNlbnRhZ2UNCj4gwqAgcnRsd2lmaTogcnRsODE5MmNlOiB1c2UgZ2VuZXJp
YyBydGxfc2lnbmFsX3NjYWxlX21hcHBpbmcNCj4gwqAgcnRsd2lmaTogcnRsODE5MmN1OiB1c2Ug
Z2VuZXJpYyBydGxfc2lnbmFsX3NjYWxlX21hcHBpbmcNCj4gwqAgcnRsd2lmaTogcnRsODE5MmRl
OiB1c2UgZ2VuZXJpYyBydGxfc2lnbmFsX3NjYWxlX21hcHBpbmcNCj4gDQo+IMKgLi4uL3dpcmVs
ZXNzL3JlYWx0ZWsvcnRsd2lmaS9ydGw4MTkyY2UvdHJ4LmPCoMKgfCA0OCArKy0tLS0tLS0tLS0t
LS0tLS0NCj4gwqAuLi4vd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDgxOTJjdS9tYWMuY8Kg
wqB8IDQ5ICsrLS0tLS0tLS0tLS0tLS0tLS0NCj4gwqAuLi4vd2lyZWxlc3MvcmVhbHRlay9ydGx3
aWZpL3J0bDgxOTJkZS90cnguY8KgwqB8IDQ3ICsrLS0tLS0tLS0tLS0tLS0tLQ0KPiDCoDMgZmls
ZXMgY2hhbmdlZCwgMTQgaW5zZXJ0aW9ucygrKSwgMTMwIGRlbGV0aW9ucygtKQ0KPiANCg0KRm9y
IGFsbCBwYXRjaGVzOg0KQWNrZWQtYnk6IFBpbmctS2UgU2hpaCA8cGtzaGloQHJlYWx0ZWsuY29t
Pg0KDQpDdXJpb3VzbHkuIEhvdyBjYW4geW91IGZpbmQgdGhlc2UgZnVuY3Rpb24gYXJlIGlkZW50
aWNhbD8NCg0KDQo=
