Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8D2E7485B
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 09:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388289AbfGYHoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 03:44:46 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:46602 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388193AbfGYHop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 03:44:45 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 3E5B2C0BE9;
        Thu, 25 Jul 2019 07:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1564040684; bh=d9aXbseWip4geo2Hn8GtPODaXk2zWbqcUFG8pTF/y8w=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=DJG86KchMQFfMb3OCMA2OOO+iTGHBXjf4KwVT58gWQ4tGle3ev3OCFfy1offTc96W
         qAaXr0xu0IIuwepJNRrFbkqnUfZ/NFM7MwbRrfjCDWky+4Ztc6ShmlSv43qu3B5mEW
         A6PT4NCf2uiTlpb4CBmrIWu7x4giQs/W9E6lQ5xj1uDNbgBXAJK76OP6HBB1QLkkFP
         FFL+azTQeNtLOnA0UTeo7EyR+2U2rt+3eBDjeL4NFgeuuumTtetYZzlMbswEx3FePO
         PxiHSNl7mEQXKs6enHra9XQCjhdR7gJy6XgeXwrBqdNRH/7UaJ8DygKZWvtalHWtjN
         XNalFjMfuZ0bg==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 4B6ABA006A;
        Thu, 25 Jul 2019 07:44:41 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 25 Jul 2019 00:44:32 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Thu, 25 Jul 2019 00:44:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AGcPuNPFHib+7M5RKPk4JYGyU6wU+bfvbt+Ca7NSTTOY++DW+sFF3X0P41x0FwoF1YPoXwER2Ht51kmdzbk2nSx/j+6Z3hTSrK0NL62hohzHyL8yb4871EE/7lpNDwUtwMS5B8WWGTyeSf08tD1CRoFVLI1cGZwCSYKsSeSxRgVgj3RTS2gxWxdjFev32Mk8HNGmXq5JV/evHSEI94Y3zSrimaO7sliO1eo+X+EiVGhT6XzvjICvhkVMDbQZbcSHg8JGDQ7MCYZ3E4PHdoRLa6Gz6uXQjCY71Be8q6FO8qm3M63MbIeAZJfxjwm0qbNRoa84l49x9BVeXGLg1N0J3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d9aXbseWip4geo2Hn8GtPODaXk2zWbqcUFG8pTF/y8w=;
 b=dsDYmfZkTG6+YXDcjcQ3muXoIdx+4vjPahT4VpLXiuufgSo+L1xYclYnpHOK2R7ZWrwy6F/DNCuP6RkecKVbWt2qRkreB7fSev1bSXj7MLy8PuYkD+XdHRNVezCoOT+u1pL84WD0iIwQmKbF4JxubkHtEwwBn8Rv7SOqZutxcAl/Is4zsj2X9KyX2jzAo0KUy1UeF5EAk6EXupcI0QACNgFd6JUtVZskKeYfvMN5/ZoZjkvcQaufo0FssifpWmCV8S+ojIq4j5u3YdVRH9cV7emyQ/6kCqnTKica6/VeCAHjVhWFEA2FQJqXfqFumAv5zjqCt+Z3l9w74HdhllIYAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=synopsys.com;dmarc=pass action=none
 header.from=synopsys.com;dkim=pass header.d=synopsys.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d9aXbseWip4geo2Hn8GtPODaXk2zWbqcUFG8pTF/y8w=;
 b=Tg07hLtUO4KnGgEgFUDKTuyxm7eDOPi9JL4RzWCJHVsQD88B9woIeYjrvh+AIcU4c/ODiKvzb/0bx34ElvkjmFco/91hTuq2QEUfcEU7X2WXvPTI786CKr2D1WWTyb2bUBG78/8mShQprmnTJcoRI4qlmzWL6dtvLVLyjJCiD94=
Received: from BYAPR12MB3269.namprd12.prod.outlook.com (20.179.93.146) by
 BYAPR12MB3080.namprd12.prod.outlook.com (20.178.54.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.13; Thu, 25 Jul 2019 07:44:29 +0000
Received: from BYAPR12MB3269.namprd12.prod.outlook.com
 ([fe80::f5b8:ac6e:ea68:cb1c]) by BYAPR12MB3269.namprd12.prod.outlook.com
 ([fe80::f5b8:ac6e:ea68:cb1c%4]) with mapi id 15.20.2094.013; Thu, 25 Jul 2019
 07:44:29 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Jon Hunter <jonathanh@nvidia.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
CC:     David Miller <davem@davemloft.net>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "lists@bofh.nu" <lists@bofh.nu>,
        "Joao.Pinto@synopsys.com" <Joao.Pinto@synopsys.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "maxime.ripard@bootlin.com" <maxime.ripard@bootlin.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "wens@csie.org" <wens@csie.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Thread-Topic: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Thread-Index: AQHVMYtq2Zx4WVoG/U2kL8GCK0bP/abPQEOAgADTx+CABnZ9AIAADuYAgAAFQOCAAAnIAIAABLTAgAFMy7CAAB4gAIAAAO7wgAAG6gCAABvPAIAAcGAAgADrmoCAAA0XIIAAA1AAgAAAhFCAABUsgIAABPNggAAIUICAAUrO0A==
Date:   Thu, 25 Jul 2019 07:44:28 +0000
Message-ID: <BYAPR12MB3269F4E62B64484B08F90998D3C10@BYAPR12MB3269.namprd12.prod.outlook.com>
References: <BYAPR12MB32692AF2BA127C5DA5B74804D3C70@BYAPR12MB3269.namprd12.prod.outlook.com>
 <6c769226-bdd9-6fe0-b96b-5a0d800fed24@arm.com>
 <8756d681-e167-fe4a-c6f0-47ae2dcbb100@nvidia.com>
 <20190723.115112.1824255524103179323.davem@davemloft.net>
 <20190724085427.GA10736@apalos>
 <BYAPR12MB3269AA9955844E317B62A239D3C60@BYAPR12MB3269.namprd12.prod.outlook.com>
 <20190724095310.GA12991@apalos>
 <BYAPR12MB3269C5766F553438ECFF2C9BD3C60@BYAPR12MB3269.namprd12.prod.outlook.com>
 <33de62bf-2f8a-bf00-9260-418b12bed24c@nvidia.com>
 <BYAPR12MB32696F0A2BFDF69F31C4311CD3C60@BYAPR12MB3269.namprd12.prod.outlook.com>
 <a07c3480-af03-a61b-4e9c-d9ceb29ce622@nvidia.com>
In-Reply-To: <a07c3480-af03-a61b-4e9c-d9ceb29ce622@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4243fa12-4056-4343-fd51-08d710d3ecae
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BYAPR12MB3080;
x-ms-traffictypediagnostic: BYAPR12MB3080:|BYAPR12MB3080:
x-microsoft-antispam-prvs: <BYAPR12MB308068F3E3668C69CFA07A7CD3C10@BYAPR12MB3080.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(39860400002)(396003)(346002)(376002)(20864003)(189003)(199004)(305945005)(446003)(11346002)(476003)(102836004)(33656002)(6246003)(486006)(229853002)(53546011)(186003)(6506007)(99286004)(76176011)(26005)(316002)(7416002)(7696005)(66946007)(5660300002)(14444005)(256004)(25786009)(64756008)(66556008)(66476007)(53936002)(71200400001)(4326008)(52536014)(76116006)(86362001)(66446008)(19627235002)(71190400001)(3846002)(68736007)(8936002)(478600001)(6116002)(6436002)(9686003)(14454004)(8676002)(81156014)(81166006)(2906002)(55016002)(66066001)(74316002)(7736002)(110136005)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR12MB3080;H:BYAPR12MB3269.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: S3wEkdB2WCpBW7JaoYjxjbNzSoGyX6Ri1PpSx8outhdqfCp9mEuAx1agOBe69994m0PJnnqx1EQrqF1tBtshplEQkn/CjAVcSybBDnuIBrYlB+mlA72/tTPQCy5nV3vVXY3mlxG7mhOLPvfr8yxAeJUYvk3PtGp/A2f471HgVSEywQxIwCQZDj3iiN1c7RWYuUrbKoOMO/uoZibupXs6KdmqlEzxZteiAIpZ5FlKLtiVoUjszW8RmD/K85sa1hNMyPsHZnC6L37dQ8MU14vrTQE/N61sEsymUwwBetjOwJIx/YdhA/yKSio6833dWYxqqd14TYABzfXx8PD7932b/Bwfxiney21JsE5s7duMm4GyU2HMfF0fE8feprK2m9DwR3Q/g9VqQbY9GZd7O4nm8YBs1oCClPUTb9ar033GICw=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4243fa12-4056-4343-fd51-08d710d3ecae
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 07:44:28.8141
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: joabreu@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3080
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSm9uIEh1bnRlciA8am9uYXRoYW5oQG52aWRpYS5jb20+DQpEYXRlOiBKdWwvMjQvMjAx
OSwgMTI6NTg6MTUgKFVUQyswMDowMCkNCg0KPiANCj4gT24gMjQvMDcvMjAxOSAxMjozNCwgSm9z
ZSBBYnJldSB3cm90ZToNCj4gPiBGcm9tOiBKb24gSHVudGVyIDxqb25hdGhhbmhAbnZpZGlhLmNv
bT4NCj4gPiBEYXRlOiBKdWwvMjQvMjAxOSwgMTI6MTA6NDcgKFVUQyswMDowMCkNCj4gPiANCj4g
Pj4NCj4gPj4gT24gMjQvMDcvMjAxOSAxMTowNCwgSm9zZSBBYnJldSB3cm90ZToNCj4gPj4NCj4g
Pj4gLi4uDQo+ID4+DQo+ID4+PiBKb24sIEkgd2FzIGFibGUgdG8gcmVwbGljYXRlIChhdCBzb21l
IGxldmVsKSB5b3VyIHNldHVwOg0KPiA+Pj4NCj4gPj4+ICMgZG1lc2cgfCBncmVwIC1pIGFybS1z
bW11DQo+ID4+PiBbICAgIDEuMzM3MzIyXSBhcm0tc21tdSA3MDA0MDAwMC5pb21tdTogcHJvYmlu
ZyBoYXJkd2FyZSANCj4gPj4+IGNvbmZpZ3VyYXRpb24uLi4NCj4gPj4+IFsgICAgMS4zMzczMzBd
IGFybS1zbW11IDcwMDQwMDAwLmlvbW11OiBTTU1VdjIgd2l0aDoNCj4gPj4+IFsgICAgMS4zMzcz
MzhdIGFybS1zbW11IDcwMDQwMDAwLmlvbW11OiAgICAgICAgIHN0YWdlIDEgdHJhbnNsYXRpb24N
Cj4gPj4+IFsgICAgMS4zMzczNDZdIGFybS1zbW11IDcwMDQwMDAwLmlvbW11OiAgICAgICAgIHN0
YWdlIDIgdHJhbnNsYXRpb24NCj4gPj4+IFsgICAgMS4zMzczNTRdIGFybS1zbW11IDcwMDQwMDAw
LmlvbW11OiAgICAgICAgIG5lc3RlZCB0cmFuc2xhdGlvbg0KPiA+Pj4gWyAgICAxLjMzNzM2M10g
YXJtLXNtbXUgNzAwNDAwMDAuaW9tbXU6ICAgICAgICAgc3RyZWFtIG1hdGNoaW5nIHdpdGggMTI4
IA0KPiA+Pj4gcmVnaXN0ZXIgZ3JvdXBzDQo+ID4+PiBbICAgIDEuMzM3Mzc0XSBhcm0tc21tdSA3
MDA0MDAwMC5pb21tdTogICAgICAgICAxIGNvbnRleHQgYmFua3MgKDAgDQo+ID4+PiBzdGFnZS0y
IG9ubHkpDQo+ID4+PiBbICAgIDEuMzM3MzgzXSBhcm0tc21tdSA3MDA0MDAwMC5pb21tdTogICAg
ICAgICBTdXBwb3J0ZWQgcGFnZSBzaXplczogDQo+ID4+PiAweDYxMzExMDAwDQo+ID4+PiBbICAg
IDEuMzM3MzkzXSBhcm0tc21tdSA3MDA0MDAwMC5pb21tdTogICAgICAgICBTdGFnZS0xOiA0OC1i
aXQgVkEgLT4gDQo+ID4+PiA0OC1iaXQgSVBBDQo+ID4+PiBbICAgIDEuMzM3NDAyXSBhcm0tc21t
dSA3MDA0MDAwMC5pb21tdTogICAgICAgICBTdGFnZS0yOiA0OC1iaXQgSVBBIC0+IA0KPiA+Pj4g
NDgtYml0IFBBDQo+ID4+Pg0KPiA+Pj4gIyBkbWVzZyB8IGdyZXAgLWkgc3RtbWFjDQo+ID4+PiBb
ICAgIDEuMzQ0MTA2XSBzdG1tYWNldGggNzAwMDAwMDAuZXRoZXJuZXQ6IEFkZGluZyB0byBpb21t
dSBncm91cCAwDQo+ID4+PiBbICAgIDEuMzQ0MjMzXSBzdG1tYWNldGggNzAwMDAwMDAuZXRoZXJu
ZXQ6IG5vIHJlc2V0IGNvbnRyb2wgZm91bmQNCj4gPj4+IFsgICAgMS4zNDgyNzZdIHN0bW1hY2V0
aCA3MDAwMDAwMC5ldGhlcm5ldDogVXNlciBJRDogMHgxMCwgU3lub3BzeXMgSUQ6IA0KPiA+Pj4g
MHg1MQ0KPiA+Pj4gWyAgICAxLjM0ODI4NV0gc3RtbWFjZXRoIDcwMDAwMDAwLmV0aGVybmV0OiAg
ICAgRFdNQUM0LzUNCj4gPj4+IFsgICAgMS4zNDgyOTNdIHN0bW1hY2V0aCA3MDAwMDAwMC5ldGhl
cm5ldDogRE1BIEhXIGNhcGFiaWxpdHkgcmVnaXN0ZXIgDQo+ID4+PiBzdXBwb3J0ZWQNCj4gPj4+
IFsgICAgMS4zNDgzMDJdIHN0bW1hY2V0aCA3MDAwMDAwMC5ldGhlcm5ldDogUlggQ2hlY2tzdW0g
T2ZmbG9hZCBFbmdpbmUgDQo+ID4+PiBzdXBwb3J0ZWQNCj4gPj4+IFsgICAgMS4zNDgzMTFdIHN0
bW1hY2V0aCA3MDAwMDAwMC5ldGhlcm5ldDogVFggQ2hlY2tzdW0gaW5zZXJ0aW9uIA0KPiA+Pj4g
c3VwcG9ydGVkDQo+ID4+PiBbICAgIDEuMzQ4MzIwXSBzdG1tYWNldGggNzAwMDAwMDAuZXRoZXJu
ZXQ6IFRTTyBzdXBwb3J0ZWQNCj4gPj4+IFsgICAgMS4zNDgzMjhdIHN0bW1hY2V0aCA3MDAwMDAw
MC5ldGhlcm5ldDogRW5hYmxlIFJYIE1pdGlnYXRpb24gdmlhIEhXIA0KPiA+Pj4gV2F0Y2hkb2cg
VGltZXINCj4gPj4+IFsgICAgMS4zNDgzMzddIHN0bW1hY2V0aCA3MDAwMDAwMC5ldGhlcm5ldDog
VFNPIGZlYXR1cmUgZW5hYmxlZA0KPiA+Pj4gWyAgICAxLjM0ODQwOV0gbGlicGh5OiBzdG1tYWM6
IHByb2JlZA0KPiA+Pj4gWyA0MTU5LjE0MDk5MF0gc3RtbWFjZXRoIDcwMDAwMDAwLmV0aGVybmV0
IGV0aDA6IFBIWSBbc3RtbWFjLTA6MDFdIA0KPiA+Pj4gZHJpdmVyIFtHZW5lcmljIFBIWV0NCj4g
Pj4+IFsgNDE1OS4xNDEwMDVdIHN0bW1hY2V0aCA3MDAwMDAwMC5ldGhlcm5ldCBldGgwOiBwaHk6
IHNldHRpbmcgc3VwcG9ydGVkIA0KPiA+Pj4gMDAsMDAwMDAwMDAsMDAwMDYyZmYgYWR2ZXJ0aXNp
bmcgMDAsMDAwMDAwMDAsMDAwMDYyZmYNCj4gPj4+IFsgNDE1OS4xNDIzNTldIHN0bW1hY2V0aCA3
MDAwMDAwMC5ldGhlcm5ldCBldGgwOiBObyBTYWZldHkgRmVhdHVyZXMgDQo+ID4+PiBzdXBwb3J0
IGZvdW5kDQo+ID4+PiBbIDQxNTkuMTQyMzY5XSBzdG1tYWNldGggNzAwMDAwMDAuZXRoZXJuZXQg
ZXRoMDogSUVFRSAxNTg4LTIwMDggQWR2YW5jZWQgDQo+ID4+PiBUaW1lc3RhbXAgc3VwcG9ydGVk
DQo+ID4+PiBbIDQxNTkuMTQyNDI5XSBzdG1tYWNldGggNzAwMDAwMDAuZXRoZXJuZXQgZXRoMDog
cmVnaXN0ZXJlZCBQVFAgY2xvY2sNCj4gPj4+IFsgNDE1OS4xNDI0MzldIHN0bW1hY2V0aCA3MDAw
MDAwMC5ldGhlcm5ldCBldGgwOiBjb25maWd1cmluZyBmb3IgDQo+ID4+PiBwaHkvZ21paSBsaW5r
IG1vZGUNCj4gPj4+IFsgNDE1OS4xNDI0NTJdIHN0bW1hY2V0aCA3MDAwMDAwMC5ldGhlcm5ldCBl
dGgwOiBwaHlsaW5rX21hY19jb25maWc6IA0KPiA+Pj4gbW9kZT1waHkvZ21paS9Vbmtub3duL1Vu
a25vd24gYWR2PTAwLDAwMDAwMDAwLDAwMDA2MmZmIHBhdXNlPTEwIGxpbms9MCANCj4gPj4+IGFu
PTENCj4gPj4+IFsgNDE1OS4xNDI0NjZdIHN0bW1hY2V0aCA3MDAwMDAwMC5ldGhlcm5ldCBldGgw
OiBwaHkgbGluayB1cCANCj4gPj4+IGdtaWkvMUdicHMvRnVsbA0KPiA+Pj4gWyA0MTU5LjE0MjQ3
NV0gc3RtbWFjZXRoIDcwMDAwMDAwLmV0aGVybmV0IGV0aDA6IHBoeWxpbmtfbWFjX2NvbmZpZzog
DQo+ID4+PiBtb2RlPXBoeS9nbWlpLzFHYnBzL0Z1bGwgYWR2PTAwLDAwMDAwMDAwLDAwMDAwMDAw
IHBhdXNlPTBmIGxpbms9MSBhbj0wDQo+ID4+PiBbIDQxNTkuMTQyNDgxXSBzdG1tYWNldGggNzAw
MDAwMDAuZXRoZXJuZXQgZXRoMDogTGluayBpcyBVcCAtIDFHYnBzL0Z1bGwgDQo+ID4+PiAtIGZs
b3cgY29udHJvbCByeC90eA0KPiA+Pj4NCj4gPj4+IFRoZSBvbmx5IG1pc3NpbmcgcG9pbnQgaXMg
dGhlIE5GUyBib290IHRoYXQgSSBjYW4ndCByZXBsaWNhdGUgd2l0aCB0aGlzIA0KPiA+Pj4gc2V0
dXAuIEJ1dCBJIGRpZCBzb21lIHNhbml0eSBjaGVja3M6DQo+ID4+Pg0KPiA+Pj4gUmVtb3RlIEVu
cG9pbnQ6DQo+ID4+PiAjIGRkIGlmPS9kZXYvdXJhbmRvbSBvZj1vdXRwdXQuZGF0IGJzPTEyOE0g
Y291bnQ9MQ0KPiA+Pj4gIyBuYyAtYyAxOTIuMTY4LjAuMiAxMjM0IDwgb3V0cHV0LmRhdA0KPiA+
Pj4gIyBtZDVzdW0gb3V0cHV0LmRhdCANCj4gPj4+IGZkZTllMDgxODI4MTgzNmU0ZmMwZWRmZWRl
MmI4NzYyICBvdXRwdXQuZGF0DQo+ID4+Pg0KPiA+Pj4gRFVUOg0KPiA+Pj4gIyBuYyAtbCAtYyAt
cCAxMjM0ID4gb3V0cHV0LmRhdA0KPiA+Pj4gIyBtZDVzdW0gb3V0cHV0LmRhdCANCj4gPj4+IGZk
ZTllMDgxODI4MTgzNmU0ZmMwZWRmZWRlMmI4NzYyICBvdXRwdXQuZGF0DQo+ID4+DQo+ID4+IE9u
IG15IHNldHVwLCBpZiBJIGRvIG5vdCB1c2UgTkZTIHRvIG1vdW50IHRoZSByb290ZnMsIGJ1dCB0
aGVuIG1hbnVhbGx5DQo+ID4+IG1vdW50IHRoZSBORlMgc2hhcmUgYWZ0ZXIgYm9vdGluZywgSSBk
byBub3Qgc2VlIGFueSBwcm9ibGVtcyByZWFkaW5nIG9yDQo+ID4+IHdyaXRpbmcgdG8gZmlsZXMg
b24gdGhlIHNoYXJlLiBTbyBJIGFtIG5vdCBzdXJlIGlmIGl0IGlzIHNvbWUgc29ydCBvZg0KPiA+
PiByYWNlIHRoYXQgaXMgb2NjdXJyaW5nIHdoZW4gbW91bnRpbmcgdGhlIE5GUyBzaGFyZSBvbiBi
b290LiBJdCBpcyAxMDAlDQo+ID4+IHJlcHJvZHVjaWJsZSB3aGVuIHVzaW5nIE5GUyBmb3IgdGhl
IHJvb3QgZmlsZS1zeXN0ZW0uDQo+ID4gDQo+ID4gSSBkb24ndCB1bmRlcnN0YW5kIGhvdyBjYW4g
dGhlcmUgYmUgY29ycnVwdGlvbiB0aGVuIHVubGVzcyB0aGUgSVAgQVhJIA0KPiA+IHBhcmFtZXRl
cnMgYXJlIG1pc2NvbmZpZ3VyZWQgd2hpY2ggY2FuIGxlYWQgdG8gc3BvcmFkaWMgdW5kZWZpbmVk
IA0KPiA+IGJlaGF2aW9yLg0KPiA+IA0KPiA+IFRoZXNlIHByaW50cyBmcm9tIHlvdXIgbG9nczoN
Cj4gPiBbICAgMTQuNTc5MzkyXSBSdW4gL2luaXQgYXMgaW5pdCBwcm9jZXNzDQo+ID4gL2luaXQ6
IGxpbmUgNTg6IGNobW9kOiBjb21tYW5kIG5vdCBmb3VuZA0KPiA+IFsgMTA6MjI6NDYgXSBMNFQt
SU5JVFJEIEJ1aWxkIERBVEU6IE1vbiBKdWwgMjIgMTA6MjI6NDYgVVRDIDIwMTkNCj4gPiBbIDEw
OjIyOjQ2IF0gUm9vdCBkZXZpY2UgZm91bmQ6IG5mcw0KPiA+IFsgMTA6MjI6NDYgXSBFdGhlcm5l
dCBpbnRlcmZhY2VzOiBldGgwDQo+ID4gWyAxMDoyMjo0NiBdIElQIEFkZHJlc3M6IDEwLjIxLjE0
MC40MQ0KPiA+IA0KPiA+IFdoZXJlIGFyZSB0aGV5IGNvbWluZyBmcm9tID8gRG8geW91IGhhdmUg
YW55IGV4dHJhIGluaXQgc2NyaXB0ID8NCj4gDQo+IEJ5IGRlZmF1bHQgdGhlcmUgaXMgYW4gaW5p
dGlhbCByYW1kaXNrIHRoYXQgaXMgbG9hZGVkIGZpcnN0IGFuZCB0aGVuIHRoZQ0KPiByb290ZnMg
aXMgbW91bnRlZCBvdmVyIE5GUy4gSG93ZXZlciwgZXZlbiBpZiBJIHJlbW92ZSB0aGlzIHJhbWRp
c2sgYW5kDQo+IGRpcmVjdGx5IG1vdW50IHRoZSByb290ZnMgdmlhIE5GUyB3aXRob3V0IGl0IHRo
ZSBwcm9ibGVtIHBlcnNpc3RzLiBTbyBJDQo+IGRvbid0IHNlZSBhbnkgaXNzdWUgd2l0aCB0aGUg
cmFtZGlzayBhbmQgd2hhdHMgbW9yZSBpcyB3ZSBoYXZlIGJlZW4NCj4gdXNpbmcgdGhpcyBmb3Ig
YSBsb25nIGxvbmcgdGltZS4gTm90aGluZyBoYXMgY2hhbmdlZCBoZXJlLg0KDQpPSy4gQ2FuIHlv
dSBwbGVhc2UgdGVzdCB3aGF0IElsaWFzIG1lbnRpb25lZCA/DQoNCkJhc2ljYWxseSB5b3UgY2Fu
IGhhcmQtY29kZSB0aGUgb3JkZXIgdG8gMCBpbiANCmFsbG9jX2RtYV9yeF9kZXNjX3Jlc291cmNl
cygpOg0KLSBwcF9wYXJhbXMub3JkZXIgPSBESVZfUk9VTkRfVVAocHJpdi0+ZG1hX2J1Zl9zeiwg
UEFHRV9TSVpFKTsNCisgcHBfcGFyYW1zLm9yZGVyID0gMDsNCg0KVW5sZXNzIHlvdSB1c2UgYSBN
VFUgPiBQQUdFX1NJWkUuDQoNCi0tLQ0KVGhhbmtzLA0KSm9zZSBNaWd1ZWwgQWJyZXUNCg==
