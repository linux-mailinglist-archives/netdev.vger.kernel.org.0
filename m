Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45E42E11BD
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 07:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730611AbfJWFi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 01:38:56 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:41331 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbfJWFiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 01:38:55 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x9N5cVkK004030, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x9N5cVkK004030
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Wed, 23 Oct 2019 13:38:31 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCASV01.realtek.com.tw ([::1]) with mapi id 14.03.0468.000; Wed, 23 Oct
 2019 13:38:30 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "natechancellor@gmail.com" <natechancellor@gmail.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH] rtlwifi: Remove unnecessary NULL check in rtl_regd_init
Thread-Topic: [PATCH] rtlwifi: Remove unnecessary NULL check in rtl_regd_init
Thread-Index: AQHViTtpsZzjxTpDzEGH+xR50FXlCadnL6AA
Date:   Wed, 23 Oct 2019 05:38:30 +0000
Message-ID: <1571809110.12757.0.camel@realtek.com>
References: <20191023004703.39710-1-natechancellor@gmail.com>
In-Reply-To: <20191023004703.39710-1-natechancellor@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.95]
Content-Type: text/plain; charset="utf-8"
Content-ID: <EA6B22816DFAC3419D67AF0D26586ED0@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTEwLTIyIGF0IDE3OjQ3IC0wNzAwLCBOYXRoYW4gQ2hhbmNlbGxvciB3cm90
ZToNCj4gV2hlbiBidWlsZGluZyB3aXRoIENsYW5nICsgLVd0YXV0b2xvZ2ljYWwtcG9pbnRlci1j
b21wYXJlOg0KPiANCj4gZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3JlZ2Qu
YzozODk6MzM6IHdhcm5pbmc6IGNvbXBhcmlzb24NCj4gb2YgYWRkcmVzcyBvZiAncnRscHJpdi0+
cmVnZCcgZXF1YWwgdG8gYSBudWxsIHBvaW50ZXIgaXMgYWx3YXlzIGZhbHNlDQo+IFstV3RhdXRv
bG9naWNhbC1wb2ludGVyLWNvbXBhcmVdDQo+IMKgwqDCoMKgwqDCoMKgwqBpZiAod2lwaHkgPT0g
TlVMTCB8fCAmcnRscHJpdi0+cmVnZCA9PSBOVUxMKQ0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB+fn5+fn5+fn5efn5+wqDCoMKg
wqB+fn5+DQo+IDEgd2FybmluZyBnZW5lcmF0ZWQuDQo+IA0KPiBUaGUgYWRkcmVzcyBvZiBhbiBh
cnJheSBtZW1iZXIgaXMgbmV2ZXIgTlVMTCB1bmxlc3MgaXQgaXMgdGhlIGZpcnN0DQo+IHN0cnVj
dCBtZW1iZXIgc28gcmVtb3ZlIHRoZSB1bm5lY2Vzc2FyeSBjaGVjay4gVGhpcyB3YXMgYWRkcmVz
c2VkIGluDQo+IHRoZSBzdGFnaW5nIHZlcnNpb24gb2YgdGhlIGRyaXZlciBpbiBjb21taXQgZjk4
Njk3OGIzMmIzICgiU3RhZ2luZzoNCj4gcnRsd2lmaTogcmVtb3ZlIHVubmVjZXNzYXJ5IE5VTEwg
Y2hlY2siKS4NCj4gDQo+IFdoaWxlIHdlIGFyZSBoZXJlLCBmaXggdGhlIGZvbGxvd2luZyBjaGVj
a3BhdGNoIHdhcm5pbmc6DQo+IA0KPiBDSEVDSzogQ29tcGFyaXNvbiB0byBOVUxMIGNvdWxkIGJl
IHdyaXR0ZW4gIiF3aXBoeSINCj4gMzU6IEZJTEU6IGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0
ZWsvcnRsd2lmaS9yZWdkLmM6Mzg5Og0KPiArwqDCoMKgwqDCoMKgwqBpZiAod2lwaHkgPT0gTlVM
TCkNCj4gDQo+IEZpeGVzOiAwYzgxNzMzODVlNTQgKCJydGw4MTkyY2U6IEFkZCBuZXcgZHJpdmVy
IikNCj4gTGluazpodHRwczovL2dpdGh1Yi5jb20vQ2xhbmdCdWlsdExpbnV4L2xpbnV4L2lzc3Vl
cy83NTANCj4gU2lnbmVkLW9mZi1ieTogTmF0aGFuIENoYW5jZWxsb3IgPG5hdGVjaGFuY2VsbG9y
QGdtYWlsLmNvbT4NCg0KTG9va3MgZ29vZC4NClRoYW5rcyBmb3IgeW91ciBmaXguDQoNCkFja2Vk
LWJ5OiBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVrLmNvbT4NCg0KPiAtLS0NCj4gwqBkcml2
ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcmVnZC5jIHwgMiArLQ0KPiDCoDEgZmls
ZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9yZWdkLmMNCj4gYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcmVnZC5jDQo+IGluZGV4IGMxMDQzMmNk
NzAzZS4uOGJlMzFlMGFkODc4IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9y
ZWFsdGVrL3J0bHdpZmkvcmVnZC5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0
ZWsvcnRsd2lmaS9yZWdkLmMNCj4gQEAgLTM4Niw3ICszODYsNyBAQCBpbnQgcnRsX3JlZ2RfaW5p
dChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywNCj4gwqAJc3RydWN0IHdpcGh5ICp3aXBoeSA9IGh3
LT53aXBoeTsNCj4gwqAJc3RydWN0IGNvdW50cnlfY29kZV90b19lbnVtX3JkICpjb3VudHJ5ID0g
TlVMTDsNCj4gwqANCj4gLQlpZiAod2lwaHkgPT0gTlVMTCB8fCAmcnRscHJpdi0+cmVnZCA9PSBO
VUxMKQ0KPiArCWlmICghd2lwaHkpDQo+IMKgCQlyZXR1cm4gLUVJTlZBTDsNCj4gwqANCj4gwqAJ
LyogaW5pdCBjb3VudHJ5X2NvZGUgZnJvbSBlZnVzZSBjaGFubmVsIHBsYW4gKi8NCg0KDQo=
