Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD89029A256
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 02:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504094AbgJ0Bs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 21:48:58 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:56388 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504082AbgJ0Bs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 21:48:57 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 09R1me9kB004001, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb06.realtek.com.tw[172.21.6.99])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 09R1me9kB004001
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 27 Oct 2020 09:48:40 +0800
Received: from RTEXMBS01.realtek.com.tw (172.21.6.36) by
 RTEXMB06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Tue, 27 Oct 2020 09:48:40 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMBS01.realtek.com.tw (172.21.6.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 27 Oct 2020 09:48:39 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::89f7:e6c3:b043:15fa]) by
 RTEXMB04.realtek.com.tw ([fe80::89f7:e6c3:b043:15fa%3]) with mapi id
 15.01.2044.006; Tue, 27 Oct 2020 09:48:39 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "WeitaoWang-oc@zhaoxin.com" <WeitaoWang-oc@zhaoxin.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "CobeChen@zhaoxin.com" <CobeChen@zhaoxin.com>,
        "tonywwang@zhaoxin.com" <tonywwang@zhaoxin.com>,
        "weitaowang@zhaoxin.com" <weitaowang@zhaoxin.com>,
        "TimGuo@zhaoxin.com" <TimGuo@zhaoxin.com>,
        "wwt8723@163.com" <wwt8723@163.com>
Subject: Re: [PATCH] Net/Usb:Fix realtek wireless NIC non-canonical address access issues
Thread-Topic: [PATCH] Net/Usb:Fix realtek wireless NIC non-canonical address
 access issues
Thread-Index: AQHWptWjGYiU3K5ktkesoLGRVBev56mqMpcA
Date:   Tue, 27 Oct 2020 01:48:39 +0000
Message-ID: <1603763274.2765.5.camel@realtek.com>
References: <1603193939-3458-1-git-send-email-WeitaoWang-oc@zhaoxin.com>
In-Reply-To: <1603193939-3458-1-git-send-email-WeitaoWang-oc@zhaoxin.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.213]
Content-Type: text/plain; charset="utf-8"
Content-ID: <AE375D08D71DFB469DC42518BD0C10F5@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTEwLTIwIGF0IDE5OjM4ICswODAwLCBXZWl0YW9XYW5nb2Mgd3JvdGU6DQoN
CkZvciBydGx3aWZpIGRyaXZlciwgcGxlYXNlIHVzZSAncnRsd2lmaTogJyBhcyBwcmVmaXggb2Yg
bWFpbCBzdWJqZWN0LCBsaWtlDQoicnRsd2lmaTogRml4IG5vbi1jYW5vbmljYWwgYWRkcmVzcyBh
Y2Nlc3MgaXNzdWVzIg0KDQo+IER1cmluZyByZWFsdGVrIFVTQiB3aXJlbGVzcyBOSUMgaW5pdGlh
bGl6YXRpb24sIGl0J3MgdW5leHBlY3RlZA0KPiBkaXNjb25uZWN0aW9uIHdpbGwgY2F1c2UgdXJi
IHN1bWJtaXQgZmFpbC5PbiB0aGUgb25lIGhhbmQsDQoNCm5pdDogYWRkIHNwYWNlIHJpZ2h0IGFm
dGVyIHBlcmlvZCwgbGlrZSAiLi4uIGZhaWwuIE9uIHRoZSBvbmUgaGFuZCAuLi4iDQoNCj4gX3J0
bF91c2JfY2xlYW51cF9yeCB3aWxsIGJlIGNhbGxlZCB0byBjbGVhbiB1cCByeCBzdHVmZiwgZXNw
ZWNpYWxseQ0KPiBmb3IgcnRsX3dxLiBPbiB0aGUgb3RoZXIgaGFuZCwgZGlzY29ubmVjdGlvbiB3
aWxsIGNhdXNlIHJ0bF91c2JfZGlzY29ubmVjdA0KPiBhbmQgX3J0bF91c2JfY2xlYW51cF9yeCB0
byBiZSBjYWxsZWQuRmlubmFsbHkscnRsX3dxIHdpbGwgYmUgZmx1c2gvZGVzdHJveQ0KPiB0d2lj
ZSx3aGljaCB3aWxsIGNhdXNlIG5vbi1jYW5vbmljYWwgYWRkcmVzcyAweGRlYWQwMDAwMDAwMDAx
MjIgYWNjZXNzIGFuZA0KPiBnZW5lcmFsIHByb3RlY3Rpb24gZmF1bHQuDQo+IA0KPiBGaXhlZCB0
aGlzIGlzc3VlIGJ5IHJlbW92ZSBfcnRsX3VzYl9jbGVhbnVwX3J4IHdoZW4gdXJiIHN1bWJtaXQg
ZmFpbC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFdlaXRhb1dhbmdvYyA8V2VpdGFvV2FuZy1vY0B6
aGFveGluLmNvbT4NCj4gLS0tDQo+IMKgZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3
aWZpL3VzYi5jIHwgMSAtDQo+IMKgMSBmaWxlIGNoYW5nZWQsIDEgZGVsZXRpb24oLSkNCj4gDQo+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvdXNiLmMN
Cj4gYi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvdXNiLmMNCj4gaW5kZXgg
MDZlMDczZC4uZDYyYjg3ZiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVh
bHRlay9ydGx3aWZpL3VzYi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsv
cnRsd2lmaS91c2IuYw0KPiBAQCAtNzMxLDcgKzczMSw2IEBAIHN0YXRpYyBpbnQgX3J0bF91c2Jf
cmVjZWl2ZShzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodykNCj4gwqANCj4gwqBlcnJfb3V0Og0KPiDC
oAl1c2Jfa2lsbF9hbmNob3JlZF91cmJzKCZydGx1c2ItPnJ4X3N1Ym1pdHRlZCk7DQo+IC0JX3J0
bF91c2JfY2xlYW51cF9yeChodyk7DQo+IMKgCXJldHVybiBlcnI7DQo+IMKgfQ0KPiDCoA0K
