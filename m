Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B57B129C79
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 02:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbfLXB5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 20:57:39 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:44323 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726997AbfLXB5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 20:57:39 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID xBO1vEDr005591, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS12.realtek.com.tw[172.21.6.16])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id xBO1vEDr005591
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Dec 2019 09:57:14 +0800
Received: from RTEXMB01.realtek.com.tw (172.21.6.94) by
 RTITCAS12.realtek.com.tw (172.21.6.16) with Microsoft SMTP Server (TLS) id
 14.3.468.0; Tue, 24 Dec 2019 09:57:14 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMB01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Tue, 24 Dec 2019 09:57:13 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::d9c5:a079:495e:b999]) by
 RTEXMB04.realtek.com.tw ([fe80::d9c5:a079:495e:b999%6]) with mapi id
 15.01.1779.005; Tue, 24 Dec 2019 09:57:13 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "amade@asmblr.net" <amade@asmblr.net>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 0/9] rtlwifi: Cleanups
Thread-Topic: [PATCH 0/9] rtlwifi: Cleanups
Thread-Index: AQHVuY20w+4l9icG/0ewZ8k4l2sdbKfIAbOA
Date:   Tue, 24 Dec 2019 01:57:13 +0000
Message-ID: <1577152633.3237.0.camel@realtek.com>
References: <20191223123715.7177-1-amade@asmblr.net>
In-Reply-To: <20191223123715.7177-1-amade@asmblr.net>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.95]
Content-Type: text/plain; charset="utf-8"
Content-ID: <ECB1C69587152244A915A668A1FAEA16@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTEyLTIzIGF0IDEzOjM3ICswMTAwLCBBbWFkZXVzeiBTxYJhd2nFhHNraSB3
cm90ZToNCj4gU3RhcnQgZnJvbSBmaXhpbmcgYSB0eXBvIGVycm9yLCB0aGVuIG1vdmUgb250byBt
YWtpbmcgc2VyaWVzIG9mDQo+IGZ1bmN0aW9ucyBzdGF0aWMgYW5kIHJlbW92aW5nIHVubmVjZXNz
YXJ5IGhlYWRlci4NCj4gDQo+IEFtYWRldXN6IFPFgmF3acWEc2tpICg5KToNCj4gwqAgcnRsd2lm
aTogcnRsODE5MmN1OiBGaXggdHlwbw0KPiDCoCBydGx3aWZpOiBydGw4MTg4ZWU6IE1ha2UgZnVu
Y3Rpb25zIHN0YXRpYyAmIHJtIHN3LmgNCj4gwqAgcnRsd2lmaTogcnRsODE5MmNlOiBNYWtlIGZ1
bmN0aW9ucyBzdGF0aWMgJiBybSBzdy5oDQo+IMKgIHJ0bHdpZmk6IHJ0bDgxOTJjdTogUmVtb3Zl
IHN3LmggaGVhZGVyDQo+IMKgIHJ0bHdpZmk6IHJ0bDgxOTJlZTogTWFrZSBmdW5jdGlvbnMgc3Rh
dGljICYgcm0gc3cuaA0KPiDCoCBydGx3aWZpOiBydGw4MTkyc2U6IFJlbW92ZSBzdy5oIGhlYWRl
cg0KPiDCoCBydGx3aWZpOiBydGw4NzIzYWU6IE1ha2UgZnVuY3Rpb25zIHN0YXRpYyAmIHJtIHN3
LmgNCj4gwqAgcnRsd2lmaTogcnRsODcyM2JlOiBNYWtlIGZ1bmN0aW9ucyBzdGF0aWMgJiBybSBz
dy5oDQo+IMKgIHJ0bHdpZmk6IHJ0bDg4MjFhZTogTWFrZSBmdW5jdGlvbnMgc3RhdGljICYgcm0g
c3cuaA0KPiANCj4gwqAuLi4vd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDgxODhlZS9zdy5j
wqDCoMKgfMKgwqA3ICsrLS0NCj4gwqAuLi4vd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDgx
ODhlZS9zdy5owqDCoMKgfCAxMiAtLS0tLS0tDQo+IMKgLi4uL3dpcmVsZXNzL3JlYWx0ZWsvcnRs
d2lmaS9ydGw4MTkyY2Uvc3cuY8KgwqDCoHzCoMKgNSArKy0NCj4gwqAuLi4vd2lyZWxlc3MvcmVh
bHRlay9ydGx3aWZpL3J0bDgxOTJjZS9zdy5owqDCoMKgfCAxNSAtLS0tLS0tLQ0KPiDCoC4uLi93
aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODE5MmN1L3N3LmPCoMKgwqB8IDM1ICsrKysrKysr
Ky0tLS0tLS0tLS0NCj4gwqAuLi4vd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDgxOTJjdS9z
dy5owqDCoMKgfCAyNyAtLS0tLS0tLS0tLS0tLQ0KPiDCoC4uLi93aXJlbGVzcy9yZWFsdGVrL3J0
bHdpZmkvcnRsODE5MmVlL3N3LmPCoMKgwqB8wqDCoDcgKystLQ0KPiDCoC4uLi93aXJlbGVzcy9y
ZWFsdGVrL3J0bHdpZmkvcnRsODE5MmVlL3N3LmjCoMKgwqB8IDExIC0tLS0tLQ0KPiDCoC4uLi93
aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODE5MnNlL3N3LmPCoMKgwqB8wqDCoDEgLQ0KPiDC
oC4uLi93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODE5MnNlL3N3LmjCoMKgwqB8IDEzIC0t
LS0tLS0NCj4gwqAuLi4vd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDg3MjNhZS9zdy5jwqDC
oMKgfMKgwqA3ICsrLS0NCj4gwqAuLi4vd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDg3MjNh
ZS9zdy5owqDCoMKgfCAxMyAtLS0tLS0tDQo+IMKgLi4uL3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lm
aS9ydGw4NzIzYmUvc3cuY8KgwqDCoHzCoMKgNyArKy0tDQo+IMKgLi4uL3dpcmVsZXNzL3JlYWx0
ZWsvcnRsd2lmaS9ydGw4NzIzYmUvc3cuaMKgwqDCoHwgMTMgLS0tLS0tLQ0KPiDCoC4uLi93aXJl
bGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODgyMWFlL3N3LmPCoMKgwqB8wqDCoDcgKystLQ0KPiDC
oC4uLi93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODgyMWFlL3N3LmjCoMKgwqB8IDEyIC0t
LS0tLS0NCj4gwqAxNiBmaWxlcyBjaGFuZ2VkLCAzNCBpbnNlcnRpb25zKCspLCAxNTggZGVsZXRp
b25zKC0pDQo+IMKgZGVsZXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0
ZWsvcnRsd2lmaS9ydGw4MTg4ZWUvc3cuaA0KPiDCoGRlbGV0ZSBtb2RlIDEwMDY0NCBkcml2ZXJz
L25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODE5MmNlL3N3LmgNCj4gwqBkZWxldGUg
bW9kZSAxMDA2NDQgZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDgxOTJj
dS9zdy5oDQo+IMKgZGVsZXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0
ZWsvcnRsd2lmaS9ydGw4MTkyZWUvc3cuaA0KPiDCoGRlbGV0ZSBtb2RlIDEwMDY0NCBkcml2ZXJz
L25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODE5MnNlL3N3LmgNCj4gwqBkZWxldGUg
bW9kZSAxMDA2NDQgZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDg3MjNh
ZS9zdy5oDQo+IMKgZGVsZXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0
ZWsvcnRsd2lmaS9ydGw4NzIzYmUvc3cuaA0KPiDCoGRlbGV0ZSBtb2RlIDEwMDY0NCBkcml2ZXJz
L25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODgyMWFlL3N3LmgNCj4gDQoNCkZvciBh
bGwgcGF0Y2hlczrCoA0KQWNrZWQtYnk6IFBpbmctS2UgU2hpaCA8cGtzaGloQHJlYWx0ZWsuY29t
Pg0KDQpUaGFua3MuDQoNCg0K
