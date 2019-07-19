Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 802CC6E43C
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 12:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbfGSKZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 06:25:57 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:48058 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726271AbfGSKZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 06:25:56 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 8AF6BC00ED;
        Fri, 19 Jul 2019 10:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1563531956; bh=YUoxp8V8z6wxjOisiUYi5AxgNxWOgk/zYFTpxgl+uiU=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=PcvtcCejRsWLqSF2EZ977r2Z7EM6yEo2h0DfCWkyXh3VU6ci6ZtMs0Kwys9EM+nsg
         iIZ8gaGT2U0V0r3MVCfhQiVZUvMOuAs/pVGjFGsVFXpgRR4IBI0AelU4x+bDH6rmig
         bylZshyPlv23PfX/jZdpFz5xFwtRBe7AE9hqVCbEVOWTKSnnFUT7CiAqlNTBI2Jx88
         Euw2MtlJSiDr2IfRXpAq8QV3Auz7Kjq3KmttWAZfs6rKUW7ZgO24tDbNKwk0e7C5MK
         /3pjv6XkOXMbygFNLF4GRZWvnW2YsRpsMArsBv65m/Z6lmmI9Wewp1GUGfXwG+MTnQ
         14Kzjq0IMGnIQ==
Received: from US01WXQAHTC1.internal.synopsys.com (us01wxqahtc1.internal.synopsys.com [10.12.238.230])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id A7C85A009A;
        Fri, 19 Jul 2019 10:25:54 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WXQAHTC1.internal.synopsys.com (10.12.238.230) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Fri, 19 Jul 2019 03:25:42 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Fri, 19 Jul 2019 03:25:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qt+etx6PvnR6GdtmvHgbj41CBb6uLwIMzN2ZrXvDF2han3nHisSmxgK58IME1j3L4hwn8t4XMy58QzOMYl3KIOP8YvsjbSwQeI73oXY98UCtVw03jBEU4roo5zmi7ZD4Ptrowad48xCQwmQycAmCEsenpqjtfeQGBrN++/5NY/Bo9CFWTdY8jfLl30+WPaOKq1FOLL5qkmuiyJqC8qG3IC0FUQgGHzm/jVIKno+VbHsvxv2j0bgA6AqCc2lHqcP7ec0eYqCJSY7LYUWPnCLYiziCxK3pfjSxvPnIfGY5VjZLEU8OwQWqBqs1VrhU7vtEJ5nIQ9IKhEeUNmgye3Is+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ugRZf8R1wpnJL2MNBs9xqQ/73m3VDN2tMUgT7mwIRM=;
 b=ZID6pfQlFu+nvjYm1xMiud/WgFd2lJMViA5EML/hqa0277X3TcJDbkaNj0aaChfaW4DEU1BCGw4RE+WFil8TrZU8pibkk65nyG9K7uJLYsf8TOtJr5GcFL8jN7d1QDKR2B754Wky100PySijkUeEY7ur3CV5MgJ7a3jWe7imbiIrwzUI9/EwLET5F59CJqHwjfLS0E6M5OO7q+Gc2uWL9KQLu/heGwtIbiPAHw1rTF1TCaAwUaNVXPjuTnGn+OAWziT8Pb4Z4+w4E4jJldm6WmVsWu5hhMoyvPlzBJPdngwJJfOzSZXd/DinNtFkYSvQtb/jYjeCpH8ft7nmmavNsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=synopsys.com;dmarc=pass action=none
 header.from=synopsys.com;dkim=pass header.d=synopsys.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ugRZf8R1wpnJL2MNBs9xqQ/73m3VDN2tMUgT7mwIRM=;
 b=ue/rWi2Tamir7bPFEu5v4T/I9nKADSZ5KQYFBr2MN+YvPULZp5NWACpjyZob64dn9TXtiBdPISfMjeIj44RCRvWTNPZmjaK32nZfa1hVndtSA8b8jTgrM5jJ/HDdnvf5OnMxF/4yMNViJ0CRGbr4O1jFSkDR+LaOHMluvn49UGY=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.66.159) by
 BN8PR12MB3428.namprd12.prod.outlook.com (20.178.211.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.13; Fri, 19 Jul 2019 10:25:41 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::61ef:5598:59e0:fc9d]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::61ef:5598:59e0:fc9d%5]) with mapi id 15.20.2073.012; Fri, 19 Jul 2019
 10:25:41 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Jon Hunter <jonathanh@nvidia.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
CC:     Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: RE: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Thread-Topic: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Thread-Index: AQHVMYtq2Zx4WVoG/U2kL8GCK0bP/abPQEOAgADTx+CAABvLAIABeX5ggAAOFICAAAG4AIAAAXQAgAAaB/A=
Date:   Fri, 19 Jul 2019 10:25:41 +0000
Message-ID: <BN8PR12MB3266FD9CF18691EDEF05A4B8D3CB0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <cover.1562149883.git.joabreu@synopsys.com>
 <1b254bb7fc6044c5e6e2fdd9e00088d1d13a808b.1562149883.git.joabreu@synopsys.com>
 <29dcc161-f7c8-026e-c3cc-5adb04df128c@nvidia.com>
 <BN8PR12MB32661E919A8DEBC7095BAA12D3C80@BN8PR12MB3266.namprd12.prod.outlook.com>
 <6a6bac84-1d29-2740-1636-d3adb26b6bcc@nvidia.com>
 <BN8PR12MB3266960A104A7CDBB4E59192D3CB0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <bc9ab3c5-b1b9-26d4-7b73-01474328eafa@nvidia.com>
 <BN8PR12MB3266989D15E017A789E14282D3CB0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <4db855e4-1d59-d30b-154c-e7a2aa1c9047@nvidia.com>
In-Reply-To: <4db855e4-1d59-d30b-154c-e7a2aa1c9047@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 68291de8-2a79-409d-13e9-08d70c337357
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(49563074)(7193020);SRVR:BN8PR12MB3428;
x-ms-traffictypediagnostic: BN8PR12MB3428:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <BN8PR12MB342859FECA7A9907EE0F9568D3CB0@BN8PR12MB3428.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(346002)(39860400002)(396003)(366004)(199004)(189003)(66446008)(14444005)(76116006)(2501003)(5024004)(4326008)(53936002)(110136005)(52536014)(256004)(76176011)(316002)(7416002)(478600001)(6506007)(9686003)(55016002)(6306002)(99286004)(229853002)(64756008)(5660300002)(66476007)(7696005)(6436002)(6246003)(66946007)(7736002)(486006)(81166006)(2201001)(86362001)(33656002)(71200400001)(66066001)(25786009)(6116002)(966005)(3846002)(102836004)(8936002)(66616009)(14454004)(71190400001)(54906003)(81156014)(68736007)(11346002)(305945005)(2906002)(476003)(446003)(66556008)(26005)(186003)(74316002)(8676002)(53546011)(99936001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3428;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 08tW8VAO21QyOmGfd/2Mnl5gnYI5TlnMBUMnMbBsgTx4Py/vb7Fpz9JJTuQHwrd0CmauDmKdVp0VY8nNft9CPE9ic9O8FztNzkd0j7AeX5mTHzFbn+DuvqQVJEQ5bnovoUxfEraZ0USZCSerlP6lc0lLXxFMbg3FQX1ZbzOIBkxYNIoeHDmTfxYfG0A47Srn9brIiyU4+2CZ82bnX1GhOcrfG52nJuPNlVDNq/TSF8fESw1Ue2j+iXvNueFgzLvsxQlAhQte6GxSmtdEch3aVCuqH7sW/Pf0rDX+yATf1r8jBqfwrAuuRvWyX7EekulTuZyrW6ujAg1tlDu22ok24+2+4bSEm8mjm8YZ7JD0cCtC6gYFm0ivXw3xE/FsmH7H5FVb/I5ODYkgAsN6NH7mrAv3Lz/jhjAxmZzg9Xv7/ws=
Content-Type: multipart/mixed;
        boundary="_002_BN8PR12MB3266FD9CF18691EDEF05A4B8D3CB0BN8PR12MB3266namp_"
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 68291de8-2a79-409d-13e9-08d70c337357
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 10:25:41.2917
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: joabreu@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3428
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--_002_BN8PR12MB3266FD9CF18691EDEF05A4B8D3CB0BN8PR12MB3266namp_
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

RnJvbTogSm9uIEh1bnRlciA8am9uYXRoYW5oQG52aWRpYS5jb20+DQpEYXRlOiBKdWwvMTkvMjAx
OSwgMDk6NDk6MTAgKFVUQyswMDowMCkNCg0KPiANCj4gT24gMTkvMDcvMjAxOSAwOTo0NCwgSm9z
ZSBBYnJldSB3cm90ZToNCj4gPiBGcm9tOiBKb24gSHVudGVyIDxqb25hdGhhbmhAbnZpZGlhLmNv
bT4NCj4gPiBEYXRlOiBKdWwvMTkvMjAxOSwgMDk6Mzc6NDkgKFVUQyswMDowMCkNCj4gPiANCj4g
Pj4NCj4gPj4gT24gMTkvMDcvMjAxOSAwODo1MSwgSm9zZSBBYnJldSB3cm90ZToNCj4gPj4+IEZy
b206IEpvbiBIdW50ZXIgPGpvbmF0aGFuaEBudmlkaWEuY29tPg0KPiA+Pj4gRGF0ZTogSnVsLzE4
LzIwMTksIDEwOjE2OjIwIChVVEMrMDA6MDApDQo+ID4+Pg0KPiA+Pj4+IEhhdmUgeW91IHRyaWVk
IHVzaW5nIE5GUyBvbiBhIGJvYXJkIHdpdGggdGhpcyBldGhlcm5ldCBjb250cm9sbGVyPw0KPiA+
Pj4NCj4gPj4+IEknbSBoYXZpbmcgc29tZSBpc3N1ZXMgc2V0dGluZyB1cCB0aGUgTkZTIHNlcnZl
ciBpbiBvcmRlciB0byByZXBsaWNhdGUgDQo+ID4+PiBzbyB0aGlzIG1heSB0YWtlIHNvbWUgdGlt
ZS4NCj4gPj4NCj4gPj4gSWYgdGhhdCdzIHRoZSBjYXNlLCB3ZSBtYXkgd2lzaCB0byBjb25zaWRl
ciByZXZlcnRpbmcgdGhpcyBmb3Igbm93IGFzIGl0DQo+ID4+IGlzIHByZXZlbnRpbmcgb3VyIGJv
YXJkIGZyb20gYm9vdGluZy4gQXBwZWFycyB0byByZXZlcnQgY2xlYW5seSBvbiB0b3ANCj4gPj4g
b2YgbWFpbmxpbmUuDQo+ID4+DQo+ID4+PiBBcmUgeW91IGFibGUgdG8gYWRkIHNvbWUgZGVidWcg
aW4gc3RtbWFjX2luaXRfcnhfYnVmZmVycygpIHRvIHNlZSB3aGF0J3MgDQo+ID4+PiB0aGUgYnVm
ZmVyIGFkZHJlc3MgPw0KPiA+Pg0KPiA+PiBJZiB5b3UgaGF2ZSBhIGRlYnVnIHBhdGNoIHlvdSB3
b3VsZCBsaWtlIG1lIHRvIGFwcGx5IGFuZCB0ZXN0IHdpdGggSQ0KPiA+PiBjYW4uIEhvd2V2ZXIs
IGl0IGlzIGJlc3QgeW91IHByZXBhcmUgdGhlIHBhdGNoIGFzIG1heWJlIEkgd2lsbCBub3QgZHVt
cA0KPiA+PiB0aGUgYXBwcm9wcmlhdGUgYWRkcmVzc2VzLg0KPiA+Pg0KPiA+PiBDaGVlcnMNCj4g
Pj4gSm9uDQo+ID4+DQo+ID4+IC0tIA0KPiA+PiBudnB1YmxpYw0KPiA+IA0KPiA+IFNlbmQgbWUg
ZnVsbCBib290IGxvZyBwbGVhc2UuDQo+IA0KPiBQbGVhc2Ugc2VlOiBodHRwczovL3VybGRlZmVu
c2UucHJvb2Zwb2ludC5jb20vdjIvdXJsP3U9aHR0cHMtM0FfX3Bhc3RlLmRlYmlhbi5uZXRfMTA5
MjI3N18mZD1Ed0lDYVEmYz1EUEw2X1hfNkprWEZ4N0FYV3FCMHRnJnI9V0hEc2M2a2NXQWw0aTk2
Vm01aEpfMTlJSml1eHhfcF9Sem8yZy11SERLdyZtPWlIYWhOUEVJZWdrMW1lckUxdXRqUnZDOFhv
ejVqUWxOYjFWUnpQSGs0LTQmcz00VVRibzhtaVM0TS1QbUdOdXA0T1hnSk9vc2d2SlFabTl3Y3ZX
WWpKczdrJmU9IA0KPiANCj4gQ2hlZXJzDQo+IEpvbg0KPiANCj4gLS0gDQo+IG52cHVibGljDQoN
ClRoYW5rcy4gQ2FuIHlvdSBhZGQgYXR0YWNoZWQgcGF0Y2ggYW5kIGNoZWNrIGlmIFdBUk4gaXMg
dHJpZ2dlcmVkID8gQW5kIA0KaXQgd291bGQgYmUgZ29vZCB0byBrbm93IHdoZXRoZXIgdGhpcyBp
cyBib290IHNwZWNpZmljIGNyYXNoIG9yIGp1c3QgDQpkb2Vzbid0IHdvcmsgYXQgYWxsLCBpLmUu
IG5vdCB1c2luZyBORlMgdG8gbW91bnQgcm9vdGZzIGFuZCBpbnN0ZWFkIA0KbWFudWFsbHkgY29u
ZmlndXJlIGludGVyZmFjZSBhbmQgc2VuZC9yZWNlaXZlIHBhY2tldHMuDQoNCi0tLQ0KVGhhbmtz
LA0KSm9zZSBNaWd1ZWwgQWJyZXUNCg==

--_002_BN8PR12MB3266FD9CF18691EDEF05A4B8D3CB0BN8PR12MB3266namp_
Content-Type: application/octet-stream;
	name="0001-net-stmmac-Add-page-sanity-check.patch"
Content-Description: 0001-net-stmmac-Add-page-sanity-check.patch
Content-Disposition: attachment;
	filename="0001-net-stmmac-Add-page-sanity-check.patch"; size=1393;
	creation-date="Fri, 19 Jul 2019 10:22:11 GMT";
	modification-date="Fri, 19 Jul 2019 10:22:11 GMT"
Content-Transfer-Encoding: base64

RnJvbSBkNDk1NjIwZmVjY2YyNGRjNTQyMTgyMTljNGM3Zjc5Yzg2OTZlY2FhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8ZDQ5NTYyMGZlY2NmMjRkYzU0MjE4MjE5YzRjN2Y3
OWM4Njk2ZWNhYS4xNTYzNTMxNzMxLmdpdC5qb2FicmV1QHN5bm9wc3lzLmNvbT4KRnJvbTogSm9z
ZSBBYnJldSA8am9hYnJldUBzeW5vcHN5cy5jb20+CkRhdGU6IEZyaSwgMTkgSnVsIDIwMTkgMTI6
MjE6NDQgKzAyMDAKU3ViamVjdDogW1BBVENIIG5ldF0gbmV0OiBzdG1tYWM6IEFkZCBwYWdlIHNh
bml0eSBjaGVjawoKQWRkIGEgV0FSTl9PTigpIHdoZW4gcGFnZSBpcyBOVUxMLgoKU2lnbmVkLW9m
Zi1ieTogSm9zZSBBYnJldSA8am9hYnJldUBzeW5vcHN5cy5jb20+CgotLS0KQ2M6IEdpdXNlcHBl
IENhdmFsbGFybyA8cGVwcGUuY2F2YWxsYXJvQHN0LmNvbT4KQ2M6IEFsZXhhbmRyZSBUb3JndWUg
PGFsZXhhbmRyZS50b3JndWVAc3QuY29tPgpDYzogSm9zZSBBYnJldSA8am9hYnJldUBzeW5vcHN5
cy5jb20+CkNjOiAiRGF2aWQgUy4gTWlsbGVyIiA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD4KQ2M6IE1h
eGltZSBDb3F1ZWxpbiA8bWNvcXVlbGluLnN0bTMyQGdtYWlsLmNvbT4KQ2M6IG5ldGRldkB2Z2Vy
Lmtlcm5lbC5vcmcKQ2M6IGxpbnV4LXN0bTMyQHN0LW1kLW1haWxtYW4uc3Rvcm1yZXBseS5jb20K
Q2M6IGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZwpDYzogbGludXgta2VybmVs
QHZnZXIua2VybmVsLm9yZwotLS0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFj
L3N0bW1hY19tYWluLmMgfCAyICsrCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspCgpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvc3RtbWFjX21h
aW4uYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hY19tYWluLmMK
aW5kZXggNWYxMjk0Y2UwMjE2Li5lYWM2OTIwMzAxZTkgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0
L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hY19tYWluLmMKKysrIGIvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvc3RtbWFjX21haW4uYwpAQCAtMzM1MCw2ICszMzUwLDgg
QEAgc3RhdGljIGludCBzdG1tYWNfcngoc3RydWN0IHN0bW1hY19wcml2ICpwcml2LCBpbnQgbGlt
aXQsIHUzMiBxdWV1ZSkKIAkJZW50cnkgPSBuZXh0X2VudHJ5OwogCQlidWYgPSAmcnhfcS0+YnVm
X3Bvb2xbZW50cnldOwogCisJCVdBUk5fT04oIWJ1Zi0+cGFnZSk7CisKIAkJaWYgKHByaXYtPmV4
dGVuZF9kZXNjKQogCQkJcCA9IChzdHJ1Y3QgZG1hX2Rlc2MgKikocnhfcS0+ZG1hX2VyeCArIGVu
dHJ5KTsKIAkJZWxzZQotLSAKMi43LjQKCg==

--_002_BN8PR12MB3266FD9CF18691EDEF05A4B8D3CB0BN8PR12MB3266namp_--
