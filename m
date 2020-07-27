Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75CE622E592
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 07:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726662AbgG0Fvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 01:51:36 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:39193 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbgG0Fvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 01:51:36 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.69 with qID 06R5pAOc9026315, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb06.realtek.com.tw[172.21.6.99])
        by rtits2.realtek.com.tw (8.15.2/2.66/5.86) with ESMTPS id 06R5pAOc9026315
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 27 Jul 2020 13:51:10 +0800
Received: from RTEXMB05.realtek.com.tw (172.21.6.98) by
 RTEXMB06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 27 Jul 2020 13:51:09 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMB05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 27 Jul 2020 13:51:09 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::941:6388:7d34:5c44]) by
 RTEXMB04.realtek.com.tw ([fe80::941:6388:7d34:5c44%3]) with mapi id
 15.01.1779.005; Mon, 27 Jul 2020 13:51:09 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vulab@iscas.ac.cn" <vulab@iscas.ac.cn>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi: core: use eth_broadcast_addr() to assign broadcast
Thread-Topic: [PATCH] rtlwifi: core: use eth_broadcast_addr() to assign
 broadcast
Thread-Index: AQHWY7vvaET9pDksHk++u+1QwCkoZKkaZkWA
Date:   Mon, 27 Jul 2020 05:51:09 +0000
Message-ID: <1595829069.12227.2.camel@realtek.com>
References: <20200727021606.8602-1-vulab@iscas.ac.cn>
In-Reply-To: <20200727021606.8602-1-vulab@iscas.ac.cn>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.213]
Content-Type: text/plain; charset="utf-8"
Content-ID: <DA62BF2D7DC0FA4E89B6A2036E051474@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTA3LTI3IGF0IDAyOjE2ICswMDAwLCBYdSBXYW5nIHdyb3RlOg0KPiBUaGlz
IHBhdGNoIGlzIHRvIHVzZSBldGhfYnJvYWRjYXN0X2FkZHIoKSB0byBhc3NpZ24gYnJvYWRjYXN0
IGFkZHJlc3MNCj4gaW5zZXRhZCBvZiBtZW1jcHkoKS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFh1
IFdhbmcgPHZ1bGFiQGlzY2FzLmFjLmNuPg0KPiAtLS0NCj4gwqBkcml2ZXJzL25ldC93aXJlbGVz
cy9yZWFsdGVrL3J0bHdpZmkvY29yZS5jIHwgMyArLS0NCj4gwqAxIGZpbGUgY2hhbmdlZCwgMSBp
bnNlcnRpb24oKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL2NvcmUuYw0KPiBiL2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL3JlYWx0ZWsvcnRsd2lmaS9jb3JlLmMNCj4gaW5kZXggNGRkODJjNjA1MmYwLi44YmI0OWI3
N2I1YzggMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lm
aS9jb3JlLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL2Nv
cmUuYw0KPiBAQCAtMTUxMiw3ICsxNTEyLDYgQEAgc3RhdGljIGludCBydGxfb3Bfc2V0X2tleShz
dHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgZW51bQ0KPiBzZXRfa2V5X2NtZCBjbWQsDQo+IMKgCWJv
b2wgd2VwX29ubHkgPSBmYWxzZTsNCj4gwqAJaW50IGVyciA9IDA7DQo+IMKgCXU4IG1hY19hZGRy
W0VUSF9BTEVOXTsNCj4gLQl1OCBiY2FzdF9hZGRyW0VUSF9BTEVOXSA9IHsgMHhmZiwgMHhmZiwg
MHhmZiwgMHhmZiwgMHhmZiwgMHhmZiB9Ow0KPiDCoA0KPiDCoAlydGxwcml2LT5idGNvZXhpc3Qu
YnRjX2luZm8uaW5fNHdheSA9IGZhbHNlOw0KPiDCoA0KDQoNCidiY2FzdF9hZGRyJyBpcyBhbHNv
IHVzZWQgYnkgZGVidWc6DQoNCsKgIMKgIMKgIMKgIFJUX1RSQUNFKHJ0bHByaXYsIENPTVBfU0VD
LCBEQkdfRE1FU0cswqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqANCsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAiJXMgaGFyZHdhcmUgYmFzZWQgZW5jcnlwdGlvbiBmb3Iga2V5aWR4OiAlZCwgbWFjOiAlcE1c
biIswqDCoMKgwqDCoA0KwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgY21kID09
IFNFVF9LRVkgPyAiVXNpbmciIDogIkRpc2FibGluZyIsIGtleS0+a2V5aWR4LMKgwqDCoMKgwqDC
oMKgwqDCoMKgDQrCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBzdGEgPyBzdGEt
PmFkZHIgOiBiY2FzdF9hZGRyKTvCoA0KDQpJZiB5b3UgdHVybiBvbsKgQ09ORklHX1JUTFdJRklf
REVCVUcsIGNvbXBpbGVyIG11c3Qgd2FybiBhbiBlcnJvci4NClNvLCBOQUNLLg0KDQo+IEBAIC0x
NjM0LDcgKzE2MzMsNyBAQCBzdGF0aWMgaW50IHJ0bF9vcF9zZXRfa2V5KHN0cnVjdCBpZWVlODAy
MTFfaHcgKmh3LCBlbnVtDQo+IHNldF9rZXlfY21kIGNtZCwNCj4gwqAJCQltZW1jcHkocnRscHJp
di0+c2VjLmtleV9idWZba2V5X2lkeF0sDQo+IMKgCQkJwqDCoMKgwqDCoMKgwqBrZXktPmtleSwg
a2V5LT5rZXlsZW4pOw0KPiDCoAkJCXJ0bHByaXYtPnNlYy5rZXlfbGVuW2tleV9pZHhdID0ga2V5
LT5rZXlsZW47DQo+IC0JCQltZW1jcHkobWFjX2FkZHIsIGJjYXN0X2FkZHIsIEVUSF9BTEVOKTsN
Cj4gKwkJCWV0aF9icm9hZGNhc3RfYWRkcihtYWNfYWRkcik7DQo+IMKgCQl9IGVsc2UgewkvKiBw
YWlyd2lzZSBrZXkgKi8NCj4gwqAJCQlSVF9UUkFDRShydGxwcml2LCBDT01QX1NFQywgREJHX0RN
RVNHLA0KPiDCoAkJCQnCoCJzZXQgcGFpcndpc2Uga2V5XG4iKTsNCg==
