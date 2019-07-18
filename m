Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F162A6C507
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 04:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732313AbfGRCrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 22:47:39 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:45094 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727804AbfGRCri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 22:47:38 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x6I2jKju025492, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV02.realtek.com.tw[172.21.6.19])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x6I2jKju025492
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Thu, 18 Jul 2019 10:45:20 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCASV02.realtek.com.tw ([::1]) with mapi id 14.03.0439.000; Thu, 18 Jul
 2019 10:45:19 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yuehaibing@huawei.com" <yuehaibing@huawei.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "natechancellor@gmail.com" <natechancellor@gmail.com>,
        "hariprasad.kelam@gmail.com" <hariprasad.kelam@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi: btcoex: fix issue possible condition with no effect (if == else)
Thread-Topic: [PATCH] rtlwifi: btcoex: fix issue possible condition with no
 effect (if == else)
Thread-Index: AQHVOOY1W6hVhmptY0OYy+EIYozmE6bPLcOA
Date:   Thu, 18 Jul 2019 02:45:19 +0000
Message-ID: <1563417919.4276.0.camel@realtek.com>
References: <20190712191535.GA4215@hari-Inspiron-1545>
In-Reply-To: <20190712191535.GA4215@hari-Inspiron-1545>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.114]
Content-Type: text/plain; charset="utf-8"
Content-ID: <8A9B338587918D4EA57C625C3531B5C5@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTA3LTEyIGF0IDE5OjE1ICswMDAwLCBIYXJpcHJhc2FkIEtlbGFtIHdyb3Rl
Og0KPiBmaXggYmVsb3cgaXNzdWUgcmVwb3J0ZWQgYnkgY29jY2ljaGVjaw0KPiBkcml2ZXJzL25l
dC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvYnRjb2V4aXN0L2hhbGJ0Y291dHNyYy5jOjUxNDox
LTM6DQo+IFdBUk5JTkc6IHBvc3NpYmxlIGNvbmRpdGlvbiB3aXRoIG5vIGVmZmVjdCAoaWYgPT0g
ZWxzZSkNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEhhcmlwcmFzYWQgS2VsYW0gPGhhcmlwcmFzYWQu
a2VsYW1AZ21haWwuY29tPg0KPiAtLS0NCj4gwqBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVr
L3J0bHdpZmkvYnRjb2V4aXN0L2hhbGJ0Y291dHNyYy5jIHwgOCArLS0tLS0tLQ0KPiDCoDEgZmls
ZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgNyBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvYnRjb2V4aXN0L2hhbGJ0
Y291dHNyYy5jDQo+IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL2J0Y29l
eGlzdC9oYWxidGNvdXRzcmMuYw0KPiBpbmRleCAxNTIyNDJhLi4xOTFkYWZkMCAxMDA2NDQNCj4g
LS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL2J0Y29leGlzdC9oYWxi
dGNvdXRzcmMuYw0KPiArKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkv
YnRjb2V4aXN0L2hhbGJ0Y291dHNyYy5jDQo+IEBAIC01MDksMTMgKzUwOSw3IEBAIHN0YXRpYyB1
MzIgaGFsYnRjX2dldF93aWZpX2xpbmtfc3RhdHVzKHN0cnVjdCBidGNfY29leGlzdA0KPiAqYnRj
b2V4aXN0KQ0KPiDCoA0KPiDCoHN0YXRpYyBzMzIgaGFsYnRjX2dldF93aWZpX3Jzc2koc3RydWN0
IHJ0bF9wcml2ICpydGxwcml2KQ0KPiDCoHsNCj4gLQlpbnQgdW5kZWNfc21fcHdkYiA9IDA7DQo+
IC0NCj4gLQlpZiAocnRscHJpdi0+bWFjODAyMTEubGlua19zdGF0ZSA+PSBNQUM4MDIxMV9MSU5L
RUQpDQo+IC0JCXVuZGVjX3NtX3B3ZGIgPSBydGxwcml2LT5kbS51bmRlY19zbV9wd2RiOw0KPiAt
CWVsc2UgLyogYXNzb2NpYXRlZCBlbnRyeSBwd2RiICovDQo+IC0JCXVuZGVjX3NtX3B3ZGIgPSBy
dGxwcml2LT5kbS51bmRlY19zbV9wd2RiOw0KPiAtCXJldHVybiB1bmRlY19zbV9wd2RiOw0KPiAr
CXJldHVybiBydGxwcml2LT5kbS51bmRlY19zbV9wd2RiOw0KPiDCoH0NCj4gwqANCj4gwqBzdGF0
aWMgYm9vbCBoYWxidGNfZ2V0KHZvaWQgKnZvaWRfYnRjb2V4aXN0LCB1OCBnZXRfdHlwZSwgdm9p
ZCAqb3V0X2J1ZikNCg0KSXQgbG9va3MgZ29vZCB0byBtZS4gVGhhbmsgeW91Lg0KDQpBY2tlZC1i
eTogUGluZy1LZSBTaGloIDxwa3NoaWhAcmVhbHRlay5jb20+DQoNCg0K
