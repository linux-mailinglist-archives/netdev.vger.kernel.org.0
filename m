Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1967C4A3CA2
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 03:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357444AbiAaCyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 21:54:12 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:43845 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357428AbiAaCyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jan 2022 21:54:07 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 20V2rf6V3003389, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 20V2rf6V3003389
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 31 Jan 2022 10:53:41 +0800
Received: from RTEXMBS02.realtek.com.tw (172.21.6.95) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 31 Jan 2022 10:53:41 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS02.realtek.com.tw (172.21.6.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 31 Jan 2022 10:53:41 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::35e4:d9d1:102d:605e]) by
 RTEXMBS04.realtek.com.tw ([fe80::35e4:d9d1:102d:605e%5]) with mapi id
 15.01.2308.020; Mon, 31 Jan 2022 10:53:41 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "colin.i.king@gmail.com" <colin.i.king@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi: remove redundant initialization of variable ul_encalgo
Thread-Topic: [PATCH] rtlwifi: remove redundant initialization of variable
 ul_encalgo
Thread-Index: AQHYFinyAYEbu+NX9kauX8snRBxGHqx76QqA
Date:   Mon, 31 Jan 2022 02:53:40 +0000
Message-ID: <55f8c7f2c75b18cd628d02a25ed96fae676eace2.camel@realtek.com>
References: <20220130223714.6999-1-colin.i.king@gmail.com>
In-Reply-To: <20220130223714.6999-1-colin.i.king@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.1-2 
x-originating-ip: [111.252.224.243]
x-kse-serverinfo: RTEXMBS02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzEvMzAg5LiL5Y2IIDEwOjIxOjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-ID: <AF69B66F0AB8C44397B963849C6B24DA@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCAyMDIyLTAxLTMwIGF0IDIyOjM3ICswMDAwLCBDb2xpbiBJYW4gS2luZyB3cm90ZToN
Cj4gVmFyaWFibGUgdWxfZW5jYWxnbyBpcyBpbml0aWFsaXplZCB3aXRoIGEgdmFsdWUgdGhhdCBp
cyBuZXZlciByZWFkLA0KPiBpdCBpcyBiZWluZyByZS1hc3NpZ25lZCBhIG5ldyB2YWx1ZSBpbiBl
dmVyeSBjYXNlIGluIHRoZSBmb2xsb3dpbmcNCj4gc3dpdGNoIHN0YXRlbWVudC4gVGhlIGluaXRp
YWxpemF0aW9uIGlzIHJlZHVuZGFudCBhbmQgY2FuIGJlIHJlbW92ZWQuDQo+IA0KPiBTaWduZWQt
b2ZmLWJ5OiBDb2xpbiBJYW4gS2luZyA8Y29saW4uaS5raW5nQGdtYWlsLmNvbT4NCg0KQWNrZWQt
Ynk6IFBpbmctS2UgU2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPg0KDQo+IC0tLQ0KPiAgZHJpdmVy
cy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL2NhbS5jIHwgMiArLQ0KPiAgMSBmaWxlIGNo
YW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL2NhbS5jDQo+IGIvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL2NhbS5jDQo+IGluZGV4IDdhMDM1NWRjNmJhYi4u
MzI5NzBlYTRiNGU3IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVr
L3J0bHdpZmkvY2FtLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3
aWZpL2NhbS5jDQo+IEBAIC0yMDgsNyArMjA4LDcgQEAgdm9pZCBydGxfY2FtX2VtcHR5X2VudHJ5
KHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCB1OCB1Y19pbmRleCkNCj4gIA0KPiAgCXUzMiB1bF9j
b21tYW5kOw0KPiAgCXUzMiB1bF9jb250ZW50Ow0KPiAtCXUzMiB1bF9lbmNhbGdvID0gcnRscHJp
di0+Y2ZnLT5tYXBzW1NFQ19DQU1fQUVTXTsNCj4gKwl1MzIgdWxfZW5jYWxnbzsNCj4gIAl1OCBl
bnRyeV9pOw0KPiAgDQo+ICAJc3dpdGNoIChydGxwcml2LT5zZWMucGFpcndpc2VfZW5jX2FsZ29y
aXRobSkgew0KPiAtLSANCg0KV2hlbiBJIGNoZWNrIHRoaXMgcGF0Y2gsIEkgZmluZCB0aGVyZSBp
cyBubyAnYnJlYWsnIGZvciBkZWZhdWx0IGNhc2UuDQpEbyB3ZSBuZWVkIG9uZT8gbGlrZQ0KDQpA
QCAtMjI2LDYgKzIyNiw3IEBAIHZvaWQgcnRsX2NhbV9lbXB0eV9lbnRyeShzdHJ1Y3QgaWVlZTgw
MjExX2h3ICpodywgdTggdWNfaW5kZXgpDQogICAgICAgICAgICAgICAgYnJlYWs7DQogICAgICAg
IGRlZmF1bHQ6DQogICAgICAgICAgICAgICAgdWxfZW5jYWxnbyA9IHJ0bHByaXYtPmNmZy0+bWFw
c1tTRUNfQ0FNX0FFU107DQorICAgICAgICAgICAgICAgYnJlYWs7DQogICAgICAgIH0NCiANCiAg
ICAgICAgZm9yIChlbnRyeV9pID0gMDsgZW50cnlfaSA8IENBTV9DT05URU5UX0NPVU5UOyBlbnRy
eV9pKyspIHsNCg0KLS0NClBpbmctS2UNCg0KDQo=
