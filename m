Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73F91D7110
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 10:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbfJOIcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 04:32:19 -0400
Received: from mail-eopbgr130108.outbound.protection.outlook.com ([40.107.13.108]:45699
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726220AbfJOIcS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 04:32:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mU/S+VGiunKjwVIHc5m0T2PAui8GXgZgPq4O/Yq8Ag0SeJKXjWHbZsR494J+RBmBVZhR/iThXBbnXWqr9KFFjPI0QWIzf6PWUqQDduetrpBGecaRiwGfJv6DC+2NfN66xfdEpkeCPMcyW1Yo+93CUhTGT+RNyu0oauyWvzQzu6W4wNPSuyhTKR0b4mpsiDKlhqeKThigilGj6FLS9EUcxiJHL93Dez+Xp1mI5h5jIddbeq669ZhhII4OiZxl4P+d4xiwXrljvgmMnVois3Sii4x+SJr3Rjck1emIjvWX0HuiLlA54W+QZ/90Pau19KoF+C+BcflLhCzBSLmN/7zpRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bJPOWqQ78mseCUcahxd8Vh9/gaRJVf0BQ0sDU3mpv6s=;
 b=mcVLNKXIwQ5FvLJSNs8odWMYtI057kEL387e8UswcOifF0lAO49S44VfCmac7V3ki0MSPc5e7rBfnKT7CVS0U5ZYcoMDp6svOcxycMLp9OycAhp+/aVQL9qeSEPUpQ8u4oSYyx5XdIDu06yyiki+19RTAh8ILxmBplNIAdJov+55FhKgGWWldO3itcUt0umgrFFigtmqv1v/CJgtthulbdrGJ6HJPKEXj4EYkGz6CF1MPVyZdTWNIgHXfDBqzV3rCX2G1KHCXkaMBpcrJtiUG1LJxFgwTvhu0LDHmR0AND4SY6eiAujfldCIitH0N7hqOeZA6MtpIrEcCpoaWj3kng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=victronenergy.com; dmarc=pass action=none
 header.from=victronenergy.com; dkim=pass header.d=victronenergy.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=victronenergy.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bJPOWqQ78mseCUcahxd8Vh9/gaRJVf0BQ0sDU3mpv6s=;
 b=rJ3ga7mcWYmqhEWrzP+AV2P/HkfBOVB9JYK2E5wg8dTdtmgM8HCVDkvjS6UJUpTfGnruXo3IgQudxmjJ7+qjch9PMlgqqMBYMZ1h/Dw0o5D5RyDpK7F11B9ne9jO2DvVpYw4sHXfQIWrGxClDNXjFNfcNItp8Mf1nNc9BDCNM5o=
Received: from VI1PR0701MB2623.eurprd07.prod.outlook.com (10.173.82.19) by
 VI1PR0701MB2256.eurprd07.prod.outlook.com (10.169.130.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Tue, 15 Oct 2019 08:32:12 +0000
Received: from VI1PR0701MB2623.eurprd07.prod.outlook.com
 ([fe80::49b7:a244:d3e4:396c]) by VI1PR0701MB2623.eurprd07.prod.outlook.com
 ([fe80::49b7:a244:d3e4:396c%9]) with mapi id 15.20.2347.023; Tue, 15 Oct 2019
 08:32:12 +0000
From:   Jeroen Hofstee <jhofstee@victronenergy.com>
To:     Simon Horman <simon.horman@netronome.com>
CC:     kbuild test robot <lkp@intel.com>,
        Pankaj Sharma <pankj.sharma@samsung.com>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "eugen.hristev@microchip.com" <eugen.hristev@microchip.com>,
        "ludovic.desroches@microchip.com" <ludovic.desroches@microchip.com>,
        "pankaj.dubey@samsung.com" <pankaj.dubey@samsung.com>,
        "rcsekar@samsung.com" <rcsekar@samsung.com>,
        Sriram Dash <sriram.dash@samsung.com>
Subject: Re: [PATCH] can: m_can: fix boolreturn.cocci warnings
Thread-Topic: [PATCH] can: m_can: fix boolreturn.cocci warnings
Thread-Index: AQHVgqC6kxp5Y3lYAEWW8xE0x20ntadbNZEAgAALUACAAAngAIAAFhAA
Date:   Tue, 15 Oct 2019 08:32:12 +0000
Message-ID: <1921cfe4-0ee0-e2a5-6696-df5f612c6c56@victronenergy.com>
References: <1571052844-22633-1-git-send-email-pankj.sharma@samsung.com>
 <20191014150428.xhhc43ovkxm6oxf2@332d0cec05f4>
 <20191015055718.mypn63s2ovgwipk3@netronome.com>
 <9ad7810b-2205-3227-7ef9-0272f3714839@victronenergy.com>
 <20191015071311.yssgqhoax46lfa7l@netronome.com>
In-Reply-To: <20191015071311.yssgqhoax46lfa7l@netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
x-originating-ip: [213.126.8.10]
x-clientproxiedby: AM0PR02CA0013.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::26) To VI1PR0701MB2623.eurprd07.prod.outlook.com
 (2603:10a6:801:b::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jhofstee@victronenergy.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fa9122f3-5c96-4955-1692-08d7514a2d01
x-ms-traffictypediagnostic: VI1PR0701MB2256:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1PR0701MB2256DB6BDC83052C45773690C0930@VI1PR0701MB2256.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 01917B1794
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39850400004)(366004)(396003)(136003)(376002)(346002)(199004)(189003)(4326008)(81166006)(81156014)(8936002)(86362001)(229853002)(25786009)(6246003)(8676002)(54906003)(31696002)(6486002)(58126008)(14454004)(6116002)(3846002)(36756003)(478600001)(966005)(2906002)(6916009)(66066001)(31686004)(65806001)(65956001)(5660300002)(11346002)(486006)(256004)(386003)(53546011)(66476007)(316002)(52116002)(66556008)(64756008)(66446008)(476003)(14444005)(446003)(2616005)(102836004)(76176011)(6306002)(6512007)(7736002)(6436002)(305945005)(7416002)(71190400001)(26005)(71200400001)(6506007)(66946007)(186003)(99286004);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR0701MB2256;H:VI1PR0701MB2623.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: victronenergy.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IFrKzbIvwUW0RXw/wLBYnZCbe6sYtNl586lYAosFhYTYICbrWLMZN3Vn9HT6z1JftOMw0JS4Qw/W69csHrGZDT5xAujXAXAzaOumSSwpl7jh3YmvKRgOA1z5lcs65kkzNbyLTWt0DotMIg1Ty5fSdsf44M2enqIs0fLPam8/yLfgbIRW0AixuHQfdpLNri/8k7HAvNZg8uctskTKNYTAr1OO1kDI3Bbd2XKL6W5JFgRARQfE0x/60x5DhS3dGY4FbFt+CU5JFGukpQkMK0jANQn4OyjJx9s7XaxdYtnem20x2DxlNR/luwa+UOFmy28/uZr9+LPqo+XO0qo5MjiyqAzbC5jQoXHxXSGqbu2PBN1M4rDrz8QX8bJY1hdgYjKi6FF7OhixhQG1JNtpRu/arHa2cti8xElBohCvLs+BlJ/rzKxsD13FbXBizkeGEVCLUJQJOQpyp1cPdJusbRjNgw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <36FD5BB1CE056448B363901C9E4F9225@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: victronenergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa9122f3-5c96-4955-1692-08d7514a2d01
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2019 08:32:12.2849
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 60b95f08-3558-4e94-b0f8-d690c498e225
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x1S1nQFaa4Wk+7BUrfV4DPW3Nhiik2WnuTDlE3/jdvpzla89B6roJPWV8/fkSwxRQqe6yTzQt+tH76joekwy3vAlXAOllE0MJncfxBY3P1k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0701MB2256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8gU2ltb24sDQoNCk9uIDEwLzE1LzE5IDk6MTMgQU0sIFNpbW9uIEhvcm1hbiB3cm90ZToN
Cj4gT24gVHVlLCBPY3QgMTUsIDIwMTkgYXQgMDY6Mzc6NTRBTSArMDAwMCwgSmVyb2VuIEhvZnN0
ZWUgd3JvdGU6DQo+PiBIaSwNCj4+DQo+PiBPbiAxMC8xNS8xOSA3OjU3IEFNLCBTaW1vbiBIb3Jt
YW4gd3JvdGU6DQo+Pj4gT24gTW9uLCBPY3QgMTQsIDIwMTkgYXQgMTE6MDQ6MjhQTSArMDgwMCwg
a2J1aWxkIHRlc3Qgcm9ib3Qgd3JvdGU6DQo+Pj4+IEZyb206IGtidWlsZCB0ZXN0IHJvYm90IDxs
a3BAaW50ZWwuY29tPg0KPj4+Pg0KPj4+PiBkcml2ZXJzL25ldC9jYW4vbV9jYW4vbV9jYW4uYzo3
ODM6OS0xMDogV0FSTklORzogcmV0dXJuIG9mIDAvMSBpbiBmdW5jdGlvbiAnaXNfcHJvdG9jb2xf
ZXJyJyB3aXRoIHJldHVybiB0eXBlIGJvb2wNCj4+Pj4NCj4+Pj4gICAgUmV0dXJuIHN0YXRlbWVu
dHMgaW4gZnVuY3Rpb25zIHJldHVybmluZyBib29sIHNob3VsZCB1c2UNCj4+Pj4gICAgdHJ1ZS9m
YWxzZSBpbnN0ZWFkIG9mIDEvMC4NCj4+Pj4gR2VuZXJhdGVkIGJ5OiBzY3JpcHRzL2NvY2NpbmVs
bGUvbWlzYy9ib29scmV0dXJuLmNvY2NpDQo+Pj4+DQo+Pj4+IEZpeGVzOiA0Njk0NjE2M2FjNjEg
KCJjYW46IG1fY2FuOiBhZGQgc3VwcG9ydCBmb3IgaGFuZGxpbmcgYXJiaXRyYXRpb24gZXJyb3Ii
KQ0KPj4+PiBDQzogUGFua2FqIFNoYXJtYSA8cGFua2ouc2hhcm1hQHNhbXN1bmcuY29tPg0KPj4+
PiBTaWduZWQtb2ZmLWJ5OiBrYnVpbGQgdGVzdCByb2JvdCA8bGtwQGludGVsLmNvbT4NCj4+Pj4g
LS0tDQo+Pj4+DQo+Pj4+IHVybDogICAgaHR0cHM6Ly9naXRodWIuY29tLzBkYXktY2kvbGludXgv
Y29tbWl0cy9QYW5rYWotU2hhcm1hL2Nhbi1tX2Nhbi1hZGQtc3VwcG9ydC1mb3ItaGFuZGxpbmct
YXJiaXRyYXRpb24tZXJyb3IvMjAxOTEwMTQtMTkzNTMyDQo+Pj4+DQo+Pj4+ICAgIG1fY2FuLmMg
fCAgICA0ICsrLS0NCj4+Pj4gICAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBk
ZWxldGlvbnMoLSkNCj4+Pj4NCj4+Pj4gLS0tIGEvZHJpdmVycy9uZXQvY2FuL21fY2FuL21fY2Fu
LmMNCj4+Pj4gKysrIGIvZHJpdmVycy9uZXQvY2FuL21fY2FuL21fY2FuLmMNCj4+Pj4gQEAgLTc4
MCw5ICs3ODAsOSBAQCBzdGF0aWMgaW5saW5lIGJvb2wgaXNfbGVjX2Vycih1MzIgcHNyKQ0KPj4+
PiAgICBzdGF0aWMgaW5saW5lIGJvb2wgaXNfcHJvdG9jb2xfZXJyKHUzMiBpcnFzdGF0dXMpDQo+
Pj4+ICAgIHsNCj4+Pj4gICAgCWlmIChpcnFzdGF0dXMgJiBJUl9FUlJfTEVDXzMxWCkNCj4+Pj4g
LQkJcmV0dXJuIDE7DQo+Pj4+ICsJCXJldHVybiB0cnVlOw0KPj4+PiAgICAJZWxzZQ0KPj4+PiAt
CQlyZXR1cm4gMDsNCj4+Pj4gKwkJcmV0dXJuIGZhbHNlOw0KPj4+PiAgICB9DQo+Pj4+ICAgIA0K
Pj4+PiAgICBzdGF0aWMgaW50IG1fY2FuX2hhbmRsZV9wcm90b2NvbF9lcnJvcihzdHJ1Y3QgbmV0
X2RldmljZSAqZGV2LCB1MzIgaXJxc3RhdHVzKQ0KPj4+Pg0KPj4+IDwyYz4NCj4+PiBQZXJoYXBz
IHRoZSBmb2xsb3dpbmcgaXMgYSBuaWNlciB3YXkgdG8gZXhwcmVzcyB0aGlzIChjb21wbGV0ZWx5
IHVudGVzdGVkKToNCj4+Pg0KPj4+IAlyZXR1cm4gISEoaXJxc3RhdHVzICYgSVJfRVJSX0xFQ18z
MVgpOw0KPj4+IDwvMmM+DQo+Pg0KPj4gUmVhbGx5Li4uLiwgISEgZm9yIGJvb2wgLyBfQm9vbCB0
eXBlcz8gd2h5IG5vdCBzaW1wbHk6DQo+Pg0KPj4gc3RhdGljIGlubGluZSBib29sIGlzX3Byb3Rv
Y29sX2Vycih1MzIgaXJxc3RhdHVzKQ0KPj4gCXJldHVybiBpcnFzdGF0dXMgJiBJUl9FUlJfTEVD
XzMxWDsNCj4+IH0NCj4gR29vZCBwb2ludCwgc2lsbHkgbWUuDQoNCg0KRm9yIGNsYXJpdHksIEkg
YW0gY29tbWVudGluZyBvbiB0aGUgc3VnZ2VzdGlvbiBtYWRlIGJ5DQp0aGUgdG9vbCwgbm90IHRo
ZSBwYXRjaCBpdHNlbGYuLg0KDQpSZWdhcmRzLA0KDQpKZXJvZW4NCg0K
