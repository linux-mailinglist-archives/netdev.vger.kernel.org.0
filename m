Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71EA7CB6CA
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 11:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387735AbfJDJAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 05:00:37 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:48635 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387635AbfJDJAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 05:00:37 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x9490F8H011441, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x9490F8H011441
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 4 Oct 2019 17:00:15 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCAS11.realtek.com.tw ([fe80::7c6d:ced5:c4ff:8297%15]) with mapi id
 14.03.0468.000; Fri, 4 Oct 2019 17:00:15 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "zhengbin13@huawei.com" <zhengbin13@huawei.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 0/8] net/rtlwifi: remove some unused variables
Thread-Topic: [PATCH 0/8] net/rtlwifi: remove some unused variables
Thread-Index: AQHVeo7lDKTf4SmafEKiXdEX2jA93qdJqQoA
Date:   Fri, 4 Oct 2019 09:00:14 +0000
Message-ID: <1570179614.7613.0.camel@realtek.com>
References: <1570178635-57582-1-git-send-email-zhengbin13@huawei.com>
In-Reply-To: <1570178635-57582-1-git-send-email-zhengbin13@huawei.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.95]
Content-Type: text/plain; charset="utf-8"
Content-ID: <8AD1F375A6D6F748821A731DCF73225C@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTEwLTA0IGF0IDE2OjQzICswODAwLCB6aGVuZ2JpbiB3cm90ZToNCj4gemhl
bmdiaW4gKDgpOg0KPiDCoCBydGx3aWZpOiBydGw4ODIxYWU6IFJlbW92ZSBzZXQgYnV0IG5vdCB1
c2VkIHZhcmlhYmxlcyAncnRzdGF0dXMnLCdiZCcNCj4gwqAgcnRsd2lmaTogcnRsODcyM2FlOiBS
ZW1vdmUgc2V0IGJ1dCBub3QgdXNlZCB2YXJpYWJsZXMNCj4gwqDCoMKgwqAncmVnX2VjYycsJ3Jl
Z19lYzQnLCdyZWdfZWFjJywnYl9wYXRoYl9vaycNCj4gwqAgcnRsd2lmaTogcnRsODE5MmM6IFJl
bW92ZSBzZXQgYnV0IG5vdCB1c2VkIHZhcmlhYmxlcw0KPiDCoMKgwqDCoCdyZWdfZWNjJywncmVn
X2VhYycNCj4gwqAgcnRsd2lmaTogcnRsODE4OGVlOiBSZW1vdmUgc2V0IGJ1dCBub3QgdXNlZCB2
YXJpYWJsZXMNCj4gwqDCoMKgwqAndjMnLCdydHN0YXR1cycsJ3JlZ19lY2MnLCdyZWdfZWM0Jywn
cmVnX2VhYycsJ2JfcGF0aGJfb2snDQo+IMKgIHJ0bHdpZmk6IHJ0bDgxODhlZTogUmVtb3ZlIHNl
dCBidXQgbm90IHVzZWQgdmFyaWFibGUgJ2gyY19wYXJhbWV0ZXInDQo+IMKgIHJ0bHdpZmk6IGJ0
Y29leDogUmVtb3ZlIHNldCBidXQgbm90IHVzZWQgdmFyaWFibGUgJ3Jlc3VsdCcNCj4gwqAgcnRs
d2lmaTogYnRjb2V4OiBSZW1vdmUgc2V0IGJ1dCBub3QgdXNlZCB2YXJpYWJsZXMNCj4gwqDCoMKg
wqAnd2lmaV9idXN5JywnYnRfaW5mb19leHQnDQo+IMKgIHJ0bHdpZmk6IHJ0bDg3MjM6IFJlbW92
ZSBzZXQgYnV0IG5vdCB1c2VkIHZhcmlhYmxlICdvd24nDQoNClRoaXMgcGF0Y2hzZXQgbG9va3Mg
Z29vZC4gVGhhbmtzLg0KDQpBY2tlZC1ieTogUGluZy1LZSBTaGloIDxwa3NoaWhAcmVhbHRlay5j
b20+DQoNCj4gDQo+IMKgLi4uL3JlYWx0ZWsvcnRsd2lmaS9idGNvZXhpc3QvaGFsYnRjODE5MmUy
YW50LmPCoMKgwqDCoMKgfMKgwqA5IC0tLS0tLS0tLQ0KPiDCoC4uLi9yZWFsdGVrL3J0bHdpZmkv
YnRjb2V4aXN0L2hhbGJ0Yzg3MjNiMWFudC5jwqDCoMKgwqDCoHzCoMKgOSArLS0tLS0tLS0NCj4g
wqBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODE4OGVlL2RtLmMgfMKg
wqA4ICstLS0tLS0tDQo+IMKgLi4uL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODE4
OGVlL3BoeS5jwqDCoMKgwqB8IDIxICsrKystLS0tLS0tLS0tLS0tLQ0KPiAtLS0NCj4gwqAuLi4v
d2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDgxOTJjL3BoeV9jb21tb24uY8KgwqB8wqDCoDgg
KystLS0tLS0NCj4gwqAuLi4vbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9ydGw4NzIzYWUv
cGh5LmPCoMKgwqDCoHwgMTQgKysrLS0tLS0tLS0tLS0NCj4gwqAuLi4vd2lyZWxlc3MvcmVhbHRl
ay9ydGx3aWZpL3J0bDg3MjNjb20vZndfY29tbW9uLmMgfMKgwqA0IC0tLS0NCj4gwqAuLi4vbmV0
L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9ydGw4ODIxYWUvcGh5LmPCoMKgwqDCoHzCoMKgNyAr
LS0tLS0tDQo+IMKgOCBmaWxlcyBjaGFuZ2VkLCAxMiBpbnNlcnRpb25zKCspLCA2OCBkZWxldGlv
bnMoLSkNCj4gDQo+IC0tDQo+IDIuNy40DQo+IA0KPiANCj4gLS0tLS0tUGxlYXNlIGNvbnNpZGVy
IHRoZSBlbnZpcm9ubWVudCBiZWZvcmUgcHJpbnRpbmcgdGhpcyBlLW1haWwuDQoNCg0KDQo=
