Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A320AF407
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 03:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfIKBbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 21:31:39 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:46032 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbfIKBbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 21:31:39 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x8B1VQsF002738, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV02.realtek.com.tw[172.21.6.19])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x8B1VQsF002738
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Wed, 11 Sep 2019 09:31:26 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCASV02.realtek.com.tw ([::1]) with mapi id 14.03.0468.000; Wed, 11 Sep
 2019 09:31:26 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "straube.linux@gmail.com" <straube.linux@gmail.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] rtlwifi: use generic rtl_evm_db_to_percentage
Thread-Topic: [PATCH 0/3] rtlwifi: use generic rtl_evm_db_to_percentage
Thread-Index: AQHVaAqdltESvzrja0+EOTUTCYZIa6clKw6A
Date:   Wed, 11 Sep 2019 01:31:25 +0000
Message-ID: <1568165485.3098.2.camel@realtek.com>
References: <20190910190422.63378-1-straube.linux@gmail.com>
In-Reply-To: <20190910190422.63378-1-straube.linux@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.95]
Content-Type: text/plain; charset="utf-8"
Content-ID: <629A5078FF38464BB101AEF5EE9DD6A5@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA5LTEwIGF0IDIxOjA0ICswMjAwLCBNaWNoYWVsIFN0cmF1YmUgd3JvdGU6
DQo+IEZ1bmN0aW9ucyBfcnRsOTJ7YyxkfV9ldm1fZGJfdG9fcGVyY2VudGFnZSBhcmUgZnVuY3Rp
b25hbGx5IGlkZW50aWNhbA0KPiB0byB0aGUgZ2VuZXJpYyB2ZXJzaW9uIHJ0bF9ldm1fZGJfdG8g
cGVyY2VudGFnZS4gVGhpcyBzZXJpZXMgY29udmVydHMNCj4gcnRsODE5MmNlLCBydGw4MTkyY3Ug
YW5kIHJ0bDgxOTJkZSB0byB1c2UgdGhlIGdlbmVyaWMgdmVyc2lvbi4NCj4gDQo+IE1pY2hhZWwg
U3RyYXViZSAoMyk6DQo+IMKgIHJ0bHdpZmk6IHJ0bDgxOTJjZTogcmVwbGFjZSBfcnRsOTJjX2V2
bV9kYl90b19wZXJjZW50YWdlIHdpdGggZ2VuZXJpYw0KPiDCoMKgwqDCoHZlcnNpb24NCj4gwqAg
cnRsd2lmaTogcnRsODE5MmN1OiByZXBsYWNlIF9ydGw5MmNfZXZtX2RiX3RvX3BlcmNlbnRhZ2Ug
d2l0aCBnZW5lcmljDQo+IMKgwqDCoMKgdmVyc2lvbg0KPiDCoCBydGx3aWZpOiBydGw4MTkyZGU6
IHJlcGxhY2UgX3J0bDkyZF9ldm1fZGJfdG9fcGVyY2VudGFnZSB3aXRoIGdlbmVyaWMNCj4gwqDC
oMKgwqB2ZXJzaW9uDQo+IA0KPiDCoC4uLi93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODE5
MmNlL3RyeC5jwqDCoHwgMjMgKy0tLS0tLS0tLS0tLS0tLS0tLQ0KPiDCoC4uLi93aXJlbGVzcy9y
ZWFsdGVrL3J0bHdpZmkvcnRsODE5MmN1L21hYy5jwqDCoHwgMTggKy0tLS0tLS0tLS0tLS0tDQo+
IMKgLi4uL3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9ydGw4MTkyZGUvdHJ4LmPCoMKgfCAxOCAr
Ky0tLS0tLS0tLS0tLS0NCj4gwqAzIGZpbGVzIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgNTUg
ZGVsZXRpb25zKC0pDQo+IA0KDQpJIGNoZWNrZWQgdGhlIGdlbmVyaWMgdmVyc2lvbiBhbmQgcmVt
b3ZlZCBmdW5jdGlvbnMsIGFuZCB0aGV5IGFyZSBpbmRlZWQNCmlkZW50aWNhbC4gVGhhbmtzIGZv
ciB5b3VyIHBhdGNoZXMuDQoNCkFja2VkLWJ5OiBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVr
LmNvbT4NCg0KDQo=
