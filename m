Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4C513B734
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 02:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728905AbgAOBrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 20:47:06 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:35876 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728834AbgAOBrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 20:47:05 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID 00F1kVaC029300, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id 00F1kVaC029300
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jan 2020 09:46:31 +0800
Received: from RTEXMB01.realtek.com.tw (172.21.6.94) by
 RTITCAS11.realtek.com.tw (172.21.6.12) with Microsoft SMTP Server (TLS) id
 14.3.468.0; Wed, 15 Jan 2020 09:46:31 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMB01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 15 Jan 2020 09:46:30 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::d9c5:a079:495e:b999]) by
 RTEXMB04.realtek.com.tw ([fe80::d9c5:a079:495e:b999%6]) with mapi id
 15.01.1779.005; Wed, 15 Jan 2020 09:46:30 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "colin.king@canonical.com" <colin.king@canonical.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi: rtl8188ee: remove redundant assignment to variable cond
Thread-Topic: [PATCH] rtlwifi: rtl8188ee: remove redundant assignment to
 variable cond
Thread-Index: AQHVyvuETGjMBYS3AkaSVjAm0Ae8WKfqbyKA
Date:   Wed, 15 Jan 2020 01:46:30 +0000
Message-ID: <1579052789.2871.0.camel@realtek.com>
References: <20200114165601.374597-1-colin.king@canonical.com>
In-Reply-To: <20200114165601.374597-1-colin.king@canonical.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.111]
Content-Type: text/plain; charset="utf-8"
Content-ID: <9FBABB5D96EED04FB83EA5521F5E7308@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTAxLTE0IGF0IDE2OjU2ICswMDAwLCBDb2xpbiBLaW5nIHdyb3RlOg0KPiBG
cm9tOiBDb2xpbiBJYW4gS2luZyA8Y29saW4ua2luZ0BjYW5vbmljYWwuY29tPg0KPiANCj4gVmFy
aWFibGUgY29uZCBpcyBiZWluZyBhc3NpZ25lZCB3aXRoIGEgdmFsdWUgdGhhdCBpcyBuZXZlcg0K
PiByZWFkLCBpdCBpcyBhc3NpZ25lZCBhIG5ldyB2YWx1ZSBsYXRlciBvbi4gVGhlIGFzc2lnbm1l
bnQgaXMNCj4gcmVkdW5kYW50IGFuZCBjYW4gYmUgcmVtb3ZlZC4NCj4gDQo+IEFkZHJlc3Nlcy1D
b3Zlcml0eTogKCJVbnVzZWQgdmFsdWUiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBDb2xpbiBJYW4gS2lu
ZyA8Y29saW4ua2luZ0BjYW5vbmljYWwuY29tPg0KDQpBY2tlZC1ieTogUGluZy1LZSBTaGloIDxw
a3NoaWhAcmVhbHRlay5jb20+DQoNClRoYW5rIHlvdSEhDQoNCj4gLS0tDQo+IMKgZHJpdmVycy9u
ZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDgxODhlZS9waHkuYyB8IDIgKy0NCj4gwqAx
IGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODE4OGVlL3Bo
eS5jDQo+IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDgxODhlZS9w
aHkuYw0KPiBpbmRleCA1Y2E5MDBmOTdkNjYuLmQxMzk4M2VjMDlhZCAxMDA2NDQNCj4gLS0tIGEv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDgxODhlZS9waHkuYw0KPiAr
KysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODE4OGVlL3BoeS5j
DQo+IEBAIC0yNjQsNyArMjY0LDcgQEAgc3RhdGljIGJvb2wgX3J0bDg4ZV9jaGVja19jb25kaXRp
b24oc3RydWN0IGllZWU4MDIxMV9odw0KPiAqaHcsDQo+IMKgCXUzMiBfYm9hcmQgPSBydGxlZnVz
ZS0+Ym9hcmRfdHlwZTsgLypuZWVkIGVmdXNlIGRlZmluZSovDQo+IMKgCXUzMiBfaW50ZXJmYWNl
ID0gcnRsaGFsLT5pbnRlcmZhY2U7DQo+IMKgCXUzMiBfcGxhdGZvcm0gPSAweDA4Oy8qU3VwcG9y
dFBsYXRmb3JtICovDQo+IC0JdTMyIGNvbmQgPSBjb25kaXRpb247DQo+ICsJdTMyIGNvbmQ7DQo+
IMKgDQo+IMKgCWlmIChjb25kaXRpb24gPT0gMHhDRENEQ0RDRCkNCj4gwqAJCXJldHVybiB0cnVl
Ow0K
