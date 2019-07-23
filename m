Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 745F3716E4
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 13:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389316AbfGWLXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 07:23:06 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:57114 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728103AbfGWLXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 07:23:05 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 1E752C0138;
        Tue, 23 Jul 2019 11:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1563880985; bh=9UW9/84TwIUIVuYiPPzMsdPqkNq+dXf/epk2GQkAG3w=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=f3PAgNQ3t9TP3mHbYgDKoR92GyXyZgYU0wzuPnuRSIxC0vW+ikcdC3jIDutzjtKAU
         SR+E52HMDBCpYpLWg5zRkHfo5fJPfh45Qe96Njmjg9aEa39eOrFYWVIZjlqe4JPnF2
         SbX4jWty9hznpSZB5DVQBE5bWjabiV4WQVsxBbO0+1degZ8CqZahAmGvg5DKjOs7aB
         4AP4gH5/0QYn4w/veQqCZ88GImThj08ODNNhgnxGecp7fNIKft+jFg95Q1sVqTs5Ol
         SfIbjpYEY5+uBO9/OgikBaAxw7JGzKk/72GOd6cQj2KlLEoWQdZU8ka3u9gh1ermhg
         yrL+jsNOEOYjQ==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id BA33CA0067;
        Tue, 23 Jul 2019 11:22:44 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 23 Jul 2019 04:22:42 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Tue, 23 Jul 2019 04:22:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f/ORiRDwIKqDq9eU+FFbL7KCqkD+3IhrrbY75YIhJbyGtXd4L1aZM6YVW2U+Bt0AIBxIvACyQ1A/ykc3hQxffg+/EO7CcGnu39SBjdyEvSux+edamNMdYjiAb4qfMq8iZm4R7xCdXN6SfaC3nU5YVIa1SBNGQ+ddiuOAEH3DdRjQ0bBkA/FIYUhSRuR99rXrZxVmpadHEuaD7QGSX/JsRjUzk2Zd8HQwX8t2BYNZE1RPphIefTuwOsoEiMMXB0fItDNrx3o2A/5j/tStpowpLH3mcIt8XxmCLHQXJftlHJKKaDKpvTPq/WMuByCL0D1qgLJai69FS6eAoFbkKu9ncQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9UW9/84TwIUIVuYiPPzMsdPqkNq+dXf/epk2GQkAG3w=;
 b=AcoJiAayhA8O1FMqTdpYGtsilDg2DrgCUsNhKJYOH0AY4i3mZNabYGBmLwTaG1JFrcF6qPc71dJDqEcvSZy24dMbPPyYdWhO1iaDxglz7+aRECKaGo5KRyUqZS/apiixSdm3tifzIU71ramOSOhycGyaRwGAxuy4/g/P4AvYs+NlvP9ddrm+PagSPNF1qvtZzNNmI+84n9c77iWyw+9CRmddnINL6cn0XDw0KPDM68oNwEvwzkOyEn1Ad+bRzvc4pgt3/ddUuLXtVnn8GWkFKSWJU0fgqYNP4nYdfnQHlfORKhUnVWdYRPaQOzHakUGuTxSsS7oz+YZJnhbd5VSV2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=synopsys.com;dmarc=pass action=none
 header.from=synopsys.com;dkim=pass header.d=synopsys.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9UW9/84TwIUIVuYiPPzMsdPqkNq+dXf/epk2GQkAG3w=;
 b=JT49G9CEs8/9JNctF3dgafxaL2tyIGehczr/YsoKAsPBJPObvDAtndEkVOMv+zzLgqM+V3kJQTCSCP/fNY6f1uLh20qZswcbvd2cnaxuy/6QxQG/d+DtDvsegyEWRMFnclQojl1Cg9lCnQRnssohZwFzwOhhV8JBw/LqWqGI5kg=
Received: from BYAPR12MB3269.namprd12.prod.outlook.com (20.179.93.146) by
 BYAPR12MB3109.namprd12.prod.outlook.com (20.178.54.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.17; Tue, 23 Jul 2019 11:22:40 +0000
Received: from BYAPR12MB3269.namprd12.prod.outlook.com
 ([fe80::f5b8:ac6e:ea68:cb1c]) by BYAPR12MB3269.namprd12.prod.outlook.com
 ([fe80::f5b8:ac6e:ea68:cb1c%4]) with mapi id 15.20.2094.013; Tue, 23 Jul 2019
 11:22:40 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Robin Murphy <robin.murphy@arm.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Lars Persson <lists@bofh.nu>,
        "Ilias Apalodimas" <ilias.apalodimas@linaro.org>
CC:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Thread-Topic: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Thread-Index: AQHVMYtq2Zx4WVoG/U2kL8GCK0bP/abPQEOAgADTx+CABnZ9AIAADuYAgAAFQOCAAAnIAIAABLTAgAFMy7CAAB4gAIAAAO7wgAAG6gCAAA6iEA==
Date:   Tue, 23 Jul 2019 11:22:40 +0000
Message-ID: <BYAPR12MB32698DC13D8D531F3FDBAC5CD3C70@BYAPR12MB3269.namprd12.prod.outlook.com>
References: <cover.1562149883.git.joabreu@synopsys.com>
 <1b254bb7fc6044c5e6e2fdd9e00088d1d13a808b.1562149883.git.joabreu@synopsys.com>
 <29dcc161-f7c8-026e-c3cc-5adb04df128c@nvidia.com>
 <BN8PR12MB32661E919A8DEBC7095BAA12D3C80@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190722101830.GA24948@apalos>
 <CADnJP=thexf2sWcVVOLWw14rpteEj0RrfDdY8ER90MpbNN4-oA@mail.gmail.com>
 <BN8PR12MB326661846D53AAEE315A7434D3C40@BN8PR12MB3266.namprd12.prod.outlook.com>
 <11557fe0-0cba-cb49-0fb6-ad24792d4a53@nvidia.com>
 <BN8PR12MB3266664ECA192E02C06061EED3C40@BN8PR12MB3266.namprd12.prod.outlook.com>
 <BYAPR12MB3269A725AFDDA21E92946558D3C70@BYAPR12MB3269.namprd12.prod.outlook.com>
 <ab14f31f-2045-b1be-d31f-2a81b8527dac@nvidia.com>
 <BYAPR12MB32692AF2BA127C5DA5B74804D3C70@BYAPR12MB3269.namprd12.prod.outlook.com>
 <6c769226-bdd9-6fe0-b96b-5a0d800fed24@arm.com>
In-Reply-To: <6c769226-bdd9-6fe0-b96b-5a0d800fed24@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 97803c52-c8ef-413e-7052-08d70f6012be
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR12MB3109;
x-ms-traffictypediagnostic: BYAPR12MB3109:
x-microsoft-antispam-prvs: <BYAPR12MB31094C000AF17BA791461961D3C70@BYAPR12MB3109.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(136003)(346002)(396003)(366004)(189003)(199004)(186003)(478600001)(6246003)(26005)(53936002)(25786009)(5660300002)(2906002)(52536014)(76176011)(7696005)(66946007)(4326008)(8936002)(76116006)(66446008)(64756008)(66556008)(66476007)(102836004)(6506007)(53546011)(81156014)(81166006)(8676002)(68736007)(99286004)(33656002)(71190400001)(110136005)(54906003)(486006)(71200400001)(14454004)(7736002)(256004)(7416002)(74316002)(305945005)(14444005)(316002)(6116002)(476003)(229853002)(11346002)(446003)(86362001)(3846002)(9686003)(66066001)(55016002)(6436002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR12MB3109;H:BYAPR12MB3269.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0RF8Opg4NJJmZSpkFh0ZlWKfiBK92ACBS3W4JjXXRmdgdrWN+3g7aWU0FC3GrAHV3IolS0pgne/vN16Jl902n7+TNyWv42YIiYhKLGIjR8MpguzvRc68i8uWQNdNxOQBndzrPNg2Tz64NQ/WcGdDExuRxVCeFYZwFxMNoZ/PLsINXyaqIZdcy6hqCVXT8icXcp8fgt/NragkB9CSUv9Als8Psi/IwnET/npzVkKwREKiPHu0QA7q0YOiRxGq0zchB0vJ1KoCWU92KiVyJxgrqm7wzYPB9TiSwyr6GfG51V7/Nhylb4W28hDL1+0cQ4xc+XYFzd9U8E2XiZ6pcz608fpn5PiMXsbcPcJLxij0yoWhd5cUCyIvPvrUX/NAU+QQnxGtD+l0+pccAMbkEqsATHl1gsTiIN84FntjFgVGrY4=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 97803c52-c8ef-413e-7052-08d70f6012be
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 11:22:40.1032
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: joabreu@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3109
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogUm9iaW4gTXVycGh5IDxyb2Jpbi5tdXJwaHlAYXJtLmNvbT4NCkRhdGU6IEp1bC8yMy8y
MDE5LCAxMToyOToyOCAoVVRDKzAwOjAwKQ0KDQo+IE9uIDIzLzA3LzIwMTkgMTE6MDcsIEpvc2Ug
QWJyZXUgd3JvdGU6DQo+ID4gRnJvbTogSm9uIEh1bnRlciA8am9uYXRoYW5oQG52aWRpYS5jb20+
DQo+ID4gRGF0ZTogSnVsLzIzLzIwMTksIDExOjAxOjI0IChVVEMrMDA6MDApDQo+ID4gDQo+ID4+
IFRoaXMgYXBwZWFycyB0byBiZSBhIHdpbm5lciBhbmQgYnkgZGlzYWJsaW5nIHRoZSBTTU1VIGZv
ciB0aGUgZXRoZXJuZXQNCj4gPj4gY29udHJvbGxlciBhbmQgcmV2ZXJ0aW5nIGNvbW1pdCA5NTRh
MDNiZTAzM2M3Y2VmODBkZGMyMzJlN2NiZGIxN2RmNzM1NjYzDQo+ID4+IHRoaXMgd29ya2VkISBT
byB5ZXMgYXBwZWFycyB0byBiZSByZWxhdGVkIHRvIHRoZSBTTU1VIGJlaW5nIGVuYWJsZWQuIFdl
DQo+ID4+IGhhZCB0byBlbmFibGUgdGhlIFNNTVUgZm9yIGV0aGVybmV0IHJlY2VudGx5IGR1ZSB0
byBjb21taXQNCj4gPj4gOTU0YTAzYmUwMzNjN2NlZjgwZGRjMjMyZTdjYmRiMTdkZjczNTY2My4N
Cj4gPiANCj4gPiBGaW5hbGx5IDopDQo+ID4gDQo+ID4gSG93ZXZlciwgZnJvbSAiZ2l0IHNob3cg
OTU0YTAzYmUwMzNjN2NlZjgwZGRjMjMyZTdjYmRiMTdkZjczNTY2MyI6DQo+ID4gDQo+ID4gKyAg
ICAgICAgIFRoZXJlIGFyZSBmZXcgcmVhc29ucyB0byBhbGxvdyB1bm1hdGNoZWQgc3RyZWFtIGJ5
cGFzcywgYW5kDQo+ID4gKyAgICAgICAgIGV2ZW4gZmV3ZXIgZ29vZCBvbmVzLiAgSWYgc2F5aW5n
IFlFUyBoZXJlIGJyZWFrcyB5b3VyIGJvYXJkDQo+ID4gKyAgICAgICAgIHlvdSBzaG91bGQgd29y
ayBvbiBmaXhpbmcgeW91ciBib2FyZC4NCj4gPiANCj4gPiBTbywgaG93IGNhbiB3ZSBmaXggdGhp
cyA/IElzIHlvdXIgZXRoZXJuZXQgRFQgbm9kZSBtYXJrZWQgYXMNCj4gPiAiZG1hLWNvaGVyZW50
OyIgPw0KPiANCj4gVGhlIGZpcnN0IHRoaW5nIHRvIHRyeSB3b3VsZCBiZSBib290aW5nIHRoZSBm
YWlsaW5nIHNldHVwIHdpdGggDQo+ICJpb21tdS5wYXNzdGhyb3VnaD0xIiAob3IgdXNpbmcgQ09O
RklHX0lPTU1VX0RFRkFVTFRfUEFTU1RIUk9VR0gpIC0gaWYgDQo+IHRoYXQgbWFrZXMgdGhpbmdz
IHNlZW0gT0ssIHRoZW4gdGhlIHByb2JsZW0gaXMgbGlrZWx5IHJlbGF0ZWQgdG8gYWRkcmVzcyAN
Cj4gdHJhbnNsYXRpb247IGlmIG5vdCwgdGhlbiBpdCdzIHByb2JhYmx5IHRpbWUgdG8gc3RhcnQg
bG9va2luZyBhdCBuYXN0aWVzIA0KPiBsaWtlIGNvaGVyZW5jeSBhbmQgb3JkZXJpbmcsIGFsdGhv
dWdoIGluIHByaW5jaXBsZSBJIHdvdWxkbid0IGV4cGVjdCB0aGUgDQo+IFNNTVUgdG8gaGF2ZSB0
b28gbXVjaCBpbXBhY3QgdGhlcmUuDQo+IA0KPiBEbyB5b3Uga25vdyBpZiB0aGUgU01NVSBpbnRl
cnJ1cHRzIGFyZSB3b3JraW5nIGNvcnJlY3RseT8gSWYgbm90LCBpdCdzIA0KPiBwb3NzaWJsZSB0
aGF0IGFuIGluY29ycmVjdCBhZGRyZXNzIG9yIG1hcHBpbmcgZGlyZWN0aW9uIGNvdWxkIGxlYWQg
dG8gDQo+IHRoZSBETUEgdHJhbnNhY3Rpb24ganVzdCBiZWluZyBzaWxlbnRseSB0ZXJtaW5hdGVk
IHdpdGhvdXQgYW55IGZhdWx0IA0KPiBpbmRpY2F0aW9uLCB3aGljaCBnZW5lcmFsbHkgcHJlc2Vu
dHMgYXMgaW5leHBsaWNhYmxlIHdlaXJkbmVzcyAoSSd2ZSANCj4gY2VydGFpbmx5IHNlZW4gdGhh
dCBvbiBhbm90aGVyIHBsYXRmb3JtIHdpdGggdGhlIG1peCBvZiBhbiB1bnN1cHBvcnRlZCANCj4g
aW50ZXJydXB0IGNvbnRyb2xsZXIgYW5kIGFuICdpbXBlcmZlY3QnIGV0aGVybmV0IGRyaXZlciku
DQo+IA0KPiBKdXN0IHRvIGNvbmZpcm0sIGhhcyB0aGUgb3JpZ2luYWwgcGF0Y2ggYmVlbiB0ZXN0
ZWQgd2l0aCANCj4gQ09ORklHX0RNQV9BUElfREVCVUcgdG8gcnVsZSBvdXQgYW55IGhpZ2gtbGV2
ZWwgbWlzaGFwcz8NCg0KWWVzIGJ1dCBib3RoIG15IHNldHVwcyBkb24ndCBoYXZlIGFueSBJT01N
VTogT25lIGlzIHg4NiArIFNXSU9UTEIgYW5kIA0KYW5vdGhlciBpcyBqdXN0IGNvaGVyZW50IHJl
Z2FyZGluZyBDUFUuDQoNCi0tLQ0KVGhhbmtzLA0KSm9zZSBNaWd1ZWwgQWJyZXUNCg==
