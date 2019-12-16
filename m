Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F06A81210F1
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbfLPRHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:07:22 -0500
Received: from mail-dm6nam11on2044.outbound.protection.outlook.com ([40.107.223.44]:54496
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727982AbfLPRHF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:07:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dOx5qC7pxCuDMU8/uaquC2IQAsF6hIrmgT/aW0T11KOf+wb3uO3MZXS7KIGf+WbWuSp+ZlX5QPhbtEmUsf3qcLmjDY5D3qtyzTY7ML5nqijF24F5R3gQAsQS09b4hzGb2+m//fzDGEVxxwkUgHxoUZ0KwEoharwDFHicTERIXLD3QbaGbUI3MLS/pt2ou/xK2QZ0xMJUzasDln9lfvA5oO2EY7B5CLsQSzwonB2i0LH8EHebH4numfS2fjZjIcHSQAZnojCMvUj+Jf+j8r0yz+3cdf/58bjNJk8h9nEPAjpnnNFd9rMJbAXo6Dl5tgOQk6sTs02jyFQIHWqLHPf5fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3nSgIrJVjHtXm0OSE4HQ+oKKLDyCvgi1hyXl0I9fo4U=;
 b=Ju3CJa2SRuiUD949YE7904dvzPcMyFaf7ryiZ3e+Hntib89zrTmHg2++r1ZkP247lNL7ZWLCpOMCLXm1fcNnQGy7XzGH5eyqcXnTm7thvjWb0+U0Td1P+xZ7uRZQaiz133MaWHM8FNHvtVpb9vXvLtpFE8ejgrvD8nElQAFcIfQgD7IMP74EadhrsySrrihRggBPXP3Hi53VaFEM2d4Qkfq0w7TMrsi7cNrWe6LhDPGkZaHJ4l5SkJTauA7hykvuMncNAJMt88oc5nbUhglNpqWCfrt1I+G0gIp/1VtFWRKu1ZzuycLtW+NSGRMxsybNEZT6tobJ4xX+LCZxQErQpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3nSgIrJVjHtXm0OSE4HQ+oKKLDyCvgi1hyXl0I9fo4U=;
 b=YxWwfAYbi7YsFPwcpCfmjhbpbB5KAOCUZyNcHH/zX+EoWz8tqzNida/PweO2b6uogKKo9/7Z3wuvqA0Df2wRXZSoV/Sfw98VFkp41gbv7fF8Z56A/mRYFCU4CQWwy8ZFJotL7UJJlWiTHfWU9S9GZIil9q70TIH5KVoNzJlPKbw=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4445.namprd11.prod.outlook.com (52.135.37.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Mon, 16 Dec 2019 17:06:51 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:06:51 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 55/55] staging: wfx: update TODO
Thread-Topic: [PATCH 55/55] staging: wfx: update TODO
Thread-Index: AQHVtDLQ/BtiUAAMk0KMGEMeh2Xbgg==
Date:   Mon, 16 Dec 2019 17:04:01 +0000
Message-ID: <20191216170302.29543-56-Jerome.Pouiller@silabs.com>
References: <20191216170302.29543-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20191216170302.29543-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fad92e05-b22d-44c8-bcab-08d7824a5836
x-ms-traffictypediagnostic: MN2PR11MB4445:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4445255DEE1069D9F6BE93D893510@MN2PR11MB4445.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(366004)(39850400004)(396003)(136003)(189003)(199004)(110136005)(6486002)(107886003)(36756003)(186003)(316002)(66946007)(54906003)(5660300002)(66574012)(66446008)(66556008)(85182001)(66476007)(76116006)(91956017)(64756008)(2616005)(6506007)(15650500001)(85202003)(2906002)(26005)(71200400001)(6512007)(966005)(4326008)(8936002)(81166006)(1076003)(478600001)(86362001)(81156014)(6666004)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4445;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HUKN1TWGmiR8eIDZIAWPqyesgxvIP54GBjndjbatA55BSwFMoQ0NTO1cC6mVT9vsTQs6r/rz/8gtePiqEDRXfR11urRHJx80QiHQdIQ+Tn53sjswjJ/0gBScNnm3v4i2rkg2SCvQirIjb/vGx+ps7iRnS58r9euCzno/itjJXm54zVBJ/Cfr3d7rzocSPcHlAmtjKPK+LMKFdQuH6oCmaBuv310+I8Z9SFP95l5C/FGtnughHOT5FH0uFKNBaVmiGYYEidd3Q89H/TKj5DLmnWhuC2+NYX0+Qlvm49KAvUNXtoSjhZzIg/Ybv+k3v97sOihoTJnu91JuOijmxhod5hHkjYGtJAz0v+90pRJZ/S5SaxFfgRbf+dH8MnTk1PlcBkzhZiXJJFjjYVqvoMYOCuGz84uFz3tC4D9kxdmM298KoLhRlMLHJZEA7nbRULj1SOCjxti2yEWGfTfZhtVr6foGXaj865UtmkE5UonV+DE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <909C6621AB20434384C9954A0E10B010@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fad92e05-b22d-44c8-bcab-08d7824a5836
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:04:01.0303
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KqrQe9S1bPwJlEMhKQmL57wryivRXqp/9VgOHDpWDSjAvytYz6M4xjwQDY5ed2isCocNNbQR+CNqnwuTER3kzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4445
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KDQpV
cGRhdGUgdGhlIFRPRE8gbGlzdCBvZiB3ZnggZHJpdmVyIHdpdGggYSBtb3JlIHByZWNpc2UgbGlz
dCBvZiBpdGVtcy4NCg0KU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5w
b3VpbGxlckBzaWxhYnMuY29tPg0KLS0tDQogZHJpdmVycy9zdGFnaW5nL3dmeC9UT0RPIHwgNzgg
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLQ0KIDEgZmlsZSBjaGFuZ2Vk
LCA2NCBpbnNlcnRpb25zKCspLCAxNCBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZl
cnMvc3RhZ2luZy93ZngvVE9ETyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvVE9ETw0KaW5kZXggZTQ0
NzcyMjg5YWY4Li4xNzQyNmQ5ZDhjMTUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4
L1RPRE8NCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvVE9ETw0KQEAgLTEsMTcgKzEsNjcgQEAN
CiBUaGlzIGlzIGEgbGlzdCBvZiB0aGluZ3MgdGhhdCBuZWVkIHRvIGJlIGRvbmUgdG8gZ2V0IHRo
aXMgZHJpdmVyIG91dCBvZiB0aGUNCiBzdGFnaW5nIGRpcmVjdG9yeS4NCiANCi0gIC0gSSBoYXZl
IHRvIHRha2UgYSBkZWNpc2lvbiBhYm91dCBzZWN1cmUgbGluayBzdXBwb3J0LiBJIGNhbjoNCi0g
ICAgICAtIGRyb3AgY29tcGxldGVseQ0KLSAgICAgIC0ga2VlcCBpdCBpbiBhbiBleHRlcm5hbCBw
YXRjaCAobXkgcHJlZmVycmVkIG9wdGlvbikNCi0gICAgICAtIHJlcGxhY2UgY2FsbCB0byBtYmVk
dGxzIHdpdGgga2VybmVsIGNyeXB0byBBUEkgKG5lY2Vzc2l0YXRlIGENCi0gICAgICAgIGJ1bmNo
IG9mIHdvcmspDQotICAgICAgLSBwdWxsIG1iZWR0bHMgaW4ga2VybmVsIChub24tcmVhbGlzdGlj
KQ0KLQ0KLSAgLSBtYWM4MDIxMSBpbnRlcmZhY2UgZG9lcyBub3QgKHlldCkgaGF2ZSBleHBlY3Rl
ZCBxdWFsaXR5IHRvIGJlIHBsYWNlZA0KLSAgICBvdXRzaWRlIG9mIHN0YWdpbmc6DQotICAgICAg
LSBTb21lIHByb2Nlc3NpbmdzIGFyZSByZWR1bmRhbnQgd2l0aCBtYWM4MDIxMSBvbmVzDQotICAg
ICAgLSBNYW55IG1lbWJlcnMgZnJvbSB3ZnhfZGV2L3dmeF92aWYgY2FuIGJlIHJldHJpZXZlZCBm
cm9tIG1hYzgwMjExDQotICAgICAgICBzdHJ1Y3R1cmVzDQotICAgICAgLSBTb21lIGZ1bmN0aW9u
cyBhcmUgdG9vIGNvbXBsZXgNCi0gICAgICAtIC4uLg0KKyAgLSBBbGxvY2F0aW9uIG9mICJsaW5r
IGlkcyIgaXMgdG9vIGNvbXBsZXguIEFsbG9jYXRpb24vcmVsZWFzZSBvZiBsaW5rIGlkcyBmcm9t
DQorICAgIHN0YV9hZGQoKS9zdGFfcmVtb3ZlKCkgc2hvdWxkIGJlIHN1ZmZpY2llbnQuDQorDQor
ICAtIFRoZSBwYXRoIGZvciBwYWNrZXRzIHdpdGggSUVFRTgwMjExX1RYX0NUTF9TRU5EX0FGVEVS
X0RUSU0gZmxhZ3Mgc2hvdWxkIGJlDQorICAgIGNsZWFuZWQgdXAuIEN1cnJlbnRseSwgdGhlIHBy
b2Nlc3MgaW52b2x2ZSBtdWx0aXBsZSB3b3JrIHN0cnVjdHMgYW5kIGENCisgICAgdGltZXIuIEl0
IGNvdWxkIGJlIHNpbXBsaWZlZC4gSW4gYWRkLCB0aGUgcmVxdWV1ZSBtZWNoYW5pc20gdHJpZ2dl
cnMgbW9yZQ0KKyAgICBmcmVxdWVudGx5IHRoYW4gaXQgc2hvdWxkLg0KKw0KKyAgLSBBbGwgc3Ry
dWN0dXJlcyBkZWZpbmVkIGluIGhpZl9hcGlfKi5oIGFyZSBpbnRlbmRlZCB0byBzZW50L3JlY2Vp
dmVkIHRvL2Zyb20NCisgICAgaGFyZHdhcmUuIEFsbCB0aGVpciBtZW1iZXJzIHdob3VsZCBiZSBk
ZWNsYXJlZCBfX2xlMzIgb3IgX19sZTE2LiBUaGVzZQ0KKyAgICBzdHJ1Y3RzIHNob3VsZCBvbmx5
IGJlZW4gdXNlZCBpbiBmaWxlcyBuYW1lZCBoaWZfKiAoYW5kIG1heWJlIGluIGRhdGFfKi5jKS4N
CisgICAgVGhlIHVwcGVyIGxheWVycyAoc3RhLmMsIHNjYW4uYyBldGMuLi4pIHNob3VsZCBtYW5h
Z2UgbWFjODAyMTEgc3RydWN0dXJlcy4NCisgICAgU2VlOg0KKyAgICAgICBodHRwczovL2xvcmUu
a2VybmVsLm9yZy9sa21sLzIwMTkxMTExMjAyODUyLkdYMjY1MzBAWmVuSVYubGludXgub3JnLnVr
DQorDQorICAtIE9uY2UgcHJldmlvdXMgaXRlbSBkb25lLCBpdCB3aWxsIGJlIHBvc3NpYmxlIHRv
IGF1ZGl0IHRoZSBkcml2ZXIgd2l0aA0KKyAgICBgc3BhcnNlJy4gSXQgd2lsbCBwcm9iYWJseSBm
aW5kIHRvbnMgb2YgcHJvYmxlbXMgd2l0aCBiaWcgZW5kaWFuDQorICAgIGFyY2hpdGVjdHVyZXMu
DQorDQorICAtIGhpZl9hcGlfKi5oIHdoYXZlIGJlZW4gaW1wb3J0ZWQgZnJvbSBmaXJtd2FyZSBj
b2RlLiBTb21lIG9mIHRoZSBzdHJ1Y3R1cmVzDQorICAgIGFyZSBuZXZlciB1c2VkIGluIGRyaXZl
ci4NCisNCisgIC0gRHJpdmVyIHRyeSB0byBtYWludGFpbnMgcG93ZXIgc2F2ZSBzdGF0dXMgb2Yg
dGhlIHN0YXRpb25zLiBIb3dldmVyLCB0aGlzDQorICAgIHdvcmsgaXMgYWxyZWFkeSBkb25lIGJ5
IG1hYzgwMjExLiBzdGFfYXNsZWVwX21hc2sgYW5kIHBzcG9sbF9tYXNrIHNob3VsZCBiZQ0KKyAg
ICBkcm9wcGVkLg0KKw0KKyAgLSB3ZnhfdHhfcXVldWVzX2dldCgpIHNob3VsZCBiZSByZXdvcmtl
ZC4gSXQgY3VycmVudGx5IHRyeSBjb21wdXRlIGl0c2VsZiB0aGUNCisgICAgUW9TIHBvbGljeS4g
SG93ZXZlciwgZmlybXdhcmUgYWxyZWFkeSBkbyB0aGUgam9iLiBGaXJtd2FyZSB3b3VsZCBwcmVm
ZXIgdG8NCisgICAgaGF2ZSBhIGZldyBwYWNrZXRzIGluIGVhY2ggcXVldWUgYW5kIGJlIGFibGUg
dG8gY2hvb3NlIGl0c2VsZiB3aGljaCBxdWV1ZSB0bw0KKyAgICB1c2UuDQorDQorICAtIFdoZW4g
ZHJpdmVyIGlzIGFib3V0IHRvIGxvb3NlIEJTUywgaXQgZm9yZ2UgaXRzIG93biBOdWxsIEZ1bmMg
cmVxdWVzdCAoc2VlDQorICAgIHdmeF9jcW1fYnNzbG9zc19zbSgpKS4gSXQgc2hvdWxkIHVzZSBt
ZWNoYW5pc20gcHJvdmlkZWQgYnkgbWFjODAyMTEuDQorDQorICAtIEFQIGlzIGFjdHVhbGx5IGlz
IHNldHVwIGFmdGVyIGEgY2FsbCB0byB3ZnhfYnNzX2luZm9fY2hhbmdlZCgpLiBZZXQsDQorICAg
IGllZWU4MDIxMV9vcHMgcHJvdmlkZSBjYWxsYmFjayBzdGFydF9hcCgpLg0KKw0KKyAgLSBUaGUg
Y3VycmVudCBwcm9jZXNzIGZvciBqb2luaW5nIGEgbmV0d29yayBpcyBpbmNyZWRpYmx5IGNvbXBs
ZXguIFNob3VsZCBiZQ0KKyAgICByZXdvcmtlZC4NCisNCisgIC0gTW9uaXRvcmluZyBtb2RlIGlz
IG5vdCBpbXBsZW1lbnRlZCBkZXNwaXRlIGJlaW5nIG1hbmRhdG9yeSBieSBtYWM4MDIxMS4NCisN
CisgIC0gImNvbXBhdGlibGUiIHZhbHVlIGFyZSBub3QgY29ycmVjdC4gVGhleSBzaG91bGQgYmUg
InZlbmRvcixjaGlwIi4gU2VlOg0KKyAgICAgICBodHRwczovL2xvcmUua2VybmVsLm9yZy9kcml2
ZXJkZXYtZGV2ZWwvNTIyNjU3MC5DTUg1aFZsWmNJQHBjLTQyDQorDQorICAtIFRoZSAic3RhdGUi
IGZpZWxkIGZyb20gd2Z4X3ZpZiBzaG91bGQgYmUgcmVwbGFjZWQgYnkgInZpZi0+dHlwZSIuDQor
DQorICAtIEl0IHNlZW1zIHRoYXQgd2Z4X3VwbG9hZF9rZXlzKCkgaXMgdXNlbGVzcy4NCisNCisg
IC0gImV2ZW50X3F1ZXVlIiBmcm9tIHdmeF92aWYgc2VlbXMgb3ZlcmtpbGwuIFRoZXNlIGV2ZW50
IGFyZSByYXJlIGFuZCB0aGV5DQorICAgICBwcm9iYWJseSBjb3VsZCBiZSBoYW5kbGVkIGluIGEg
c2ltcGxlciBmYXNoaW9uLg0KKw0KKyAgLSBGZWF0dXJlIGNhbGxlZCAic2VjdXJlIGxpbmsiIHNo
b3VsZCBiZSBlaXRoZXIgZGV2ZWxvcGVkICh1c2luZyBrZXJuZWwNCisgICAgY3J5cHRvIEFQSSkg
b3IgZHJvcHBlZC4NCisNCisgIC0gSW4gd2Z4X2NtZF9zZW5kKCksICJhc3luYyIgYWxsb3cgdG8g
c2VuZCBjb21tYW5kIHdpdGhvdXQgd2FpdGluZyB0aGUgcmVwbHkuDQorICAgIEl0IG1heSBoZWxw
IGluIHNvbWUgc2l0dWF0aW9uLCBidXQgaXQgaXMgbm90IHlldCB1c2VkLiBJbiBhZGQsIGl0IG1h
eSBjYXVzZQ0KKyAgICBzb21lIHRyb3VibGU6DQorICAgICAgaHR0cHM6Ly9sb3JlLmtlcm5lbC5v
cmcvZHJpdmVyZGV2LWRldmVsL2FscGluZS5ERUIuMi4yMS4xOTEwMDQxMzE3MzgxLjI5OTJAaGFk
cmllbi8NCisgICAgU28sIGZpeCBpdCAoYnkgcmVwbGFjaW5nIHRoZSBtdXRleCB3aXRoIGEgc2Vt
YXBob3JlKSBvciBkcm9wIGl0Lg0KKw0KKyAgLSBDaGlwIHN1cHBvcnQgUDJQLCBidXQgZHJpdmVy
IGRvZXMgbm90IGltcGxlbWVudCBpdC4NCisNCisgIC0gQ2hpcCBzdXBwb3J0IGtpbmQgb2YgTWVz
aCwgYnV0IGRyaXZlciBkb2VzIG5vdCBpbXBsZW1lbnQgaXQuDQotLSANCjIuMjAuMQ0K
