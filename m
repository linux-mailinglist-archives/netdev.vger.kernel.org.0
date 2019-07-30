Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E70327A4BF
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 11:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731814AbfG3Jjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 05:39:39 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:55614 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725784AbfG3Jjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 05:39:39 -0400
Received: from mailhost.synopsys.com (dc8-mailhost1.synopsys.com [10.13.135.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 1C567C0098;
        Tue, 30 Jul 2019 09:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1564479578; bh=4h+68blNv5NVywr44YSkLaStZdLuLPToGk/Uc1hJlnc=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=eLFel2wwNSUTg770pjUF9mOaoAF3iwLwAdutWl3d+7Xj6XXu6Xw6l1jULIviKviTv
         JgFlR+0euukW+j0DhGcWY4SK8J6TeGsoI7AruZRCNIC3R9vqrJlzp1cNY/1WWtpHOP
         oeuMA+IvVVdj4kIAg+EERA8WSzGyak3PcCf4FVDbvHljOKo9waD/wZl0a9LtUEl0DE
         zpxkztDfpB66w++m+dQQ7yAKPD2xoKIIVKRwovTjK/QGZNzBxFgjI5nIazEMZZZ2Vc
         6/tBpymVnWf2jorBSMB/bgX3MukfKdxtZZ03aYwPGbc6ECE2CZg7Ku9ARppnVD1bcL
         7cfP3tYOHWpKA==
Received: from US01WXQAHTC1.internal.synopsys.com (us01wxqahtc1.internal.synopsys.com [10.12.238.230])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id C3B89A006B;
        Tue, 30 Jul 2019 09:39:34 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WXQAHTC1.internal.synopsys.com (10.12.238.230) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 30 Jul 2019 02:39:34 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Tue, 30 Jul 2019 02:39:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rx+8+k/eTBhR10hycgcsu1m1+EuIbwW73bWvEZDHyDyeCde6WMnnjz5CH29ZPqo14sJYGmouAOztrpLRYDHaHGAYe3IxyOnGUUDhCQ7JSPAcqxY2+wbmKlbf/IBkXRMWEPyGxlKPCOBHEGT3xAuzFdb0ADwRYKNz1V7iTBiP6CCwnD1ghLgjem1zoK8nx27fPFixlRXxsuPmT41ceB4WraLb4eLMhEN78RFM9B0pGcQWYhVqRQQu2CR+FdaLmCUkwxNcQSIimna45yk4tj0+ywNFEbalKPG6RrHSdiBoghfffL1hm3ompSiWjd0GcnHxTobqZ1O0k0K0QfiwiV+Vog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vKUpENlR+Mv1EsBKHsHr4DNYqxx51Txwnucg9YPXThc=;
 b=Bzf5DtM1i0IkcFQdZHgZASblm5/TZzRA724Mv8+8Ynt7jCxFqDDpWl9LcaQ/nj/87gjfTxPCdrAyiJAAWlbryJLTbuY895Bi20D/yUmDJTC3HGnZEQHknj2wSxdrGLhR1omByCZWRF0edpXRoGKY0FJZ9Otc/e3eF+I/woesd4g/u1kIKiHMBvUC3gsuZ/dxWgLWjGDb3jMVyt5SDm63enVeZ8NgenhSbj3uklLlHTf+4ynEEG6nBoHIvlUlAweCsDLjaEUFYiVWcCeidlVS0YpJQaled2dwq8VqLtKRqLqvnhcNsubg2p0vCH2KPB3S+3+0AxhXT+3KNQd2WP2GPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=synopsys.com;dmarc=pass action=none
 header.from=synopsys.com;dkim=pass header.d=synopsys.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vKUpENlR+Mv1EsBKHsHr4DNYqxx51Txwnucg9YPXThc=;
 b=RJSi9YE9wL38ap+Sd0yui+gSDPsruGRUpZC+Gi0aghqGVQKAZGt3YIyKpGDyRx0pI63kzGv/rrgpuEVYzMb+HfrLToJwNZSziFzGXz3bFRIizN05SaJ3Q4c9M2AXUH0FhQptGNSKJ5MvHyHIUqd/9l453E5qsw2DzNwDtWMigO0=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.66.159) by
 BN8PR12MB3074.namprd12.prod.outlook.com (20.178.209.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Tue, 30 Jul 2019 09:39:32 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::6016:66cc:e24f:986c]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::6016:66cc:e24f:986c%5]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 09:39:32 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Jon Hunter <jonathanh@nvidia.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
CC:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: RE: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Thread-Topic: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Thread-Index: AQHVMYtq2Zx4WVoG/U2kL8GCK0bP/abbdEOAgAAAgcCAABHmgIAADDMggAGB8wCAAa8dIIACpFiggAAs3ACAAAdb0IAACH4AgAACfECAAJ/bAIAAyh8g
Date:   Tue, 30 Jul 2019 09:39:31 +0000
Message-ID: <BN8PR12MB32664E23137805984F6FB2DAD3DC0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <cover.1562149883.git.joabreu@synopsys.com>
 <1b254bb7fc6044c5e6e2fdd9e00088d1d13a808b.1562149883.git.joabreu@synopsys.com>
 <7a79be5d-7ba2-c457-36d3-1ccef6572181@nvidia.com>
 <BYAPR12MB3269927AB1F67D46E150ED6BD3C10@BYAPR12MB3269.namprd12.prod.outlook.com>
 <9e695f33-fd9f-a910-0891-2b63bd75e082@nvidia.com>
 <BYAPR12MB3269B4A401E4DA10A07515C7D3C10@BYAPR12MB3269.namprd12.prod.outlook.com>
 <1e2ea942-28fe-15b9-f675-8d6585f9a33f@nvidia.com>
 <BYAPR12MB326922CDCB1D4B3D4A780CFDD3C30@BYAPR12MB3269.namprd12.prod.outlook.com>
 <MN2PR12MB327907D4A6FB378AC989571AD3DD0@MN2PR12MB3279.namprd12.prod.outlook.com>
 <b99b1e49-0cbc-2c66-6325-50fa6f263d91@nvidia.com>
 <MN2PR12MB327997BDF2EA5CEE00F45AC3D3DD0@MN2PR12MB3279.namprd12.prod.outlook.com>
 <fcf648d2-70cc-d734-871a-ca7f745791b7@arm.com>
 <MN2PR12MB3279ABF628C52883021123C5D3DD0@MN2PR12MB3279.namprd12.prod.outlook.com>
 <8a60361f-b914-93ef-0d80-92ae4ad8b808@nvidia.com>
In-Reply-To: <8a60361f-b914-93ef-0d80-92ae4ad8b808@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4e73c822-733d-4f9b-ca79-08d714d1d38c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(49563074)(7193020);SRVR:BN8PR12MB3074;
x-ms-traffictypediagnostic: BN8PR12MB3074:|BN8PR12MB3074:
x-microsoft-antispam-prvs: <BN8PR12MB30744C1074DD830DDBB64750D3DC0@BN8PR12MB3074.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(376002)(39860400002)(346002)(396003)(366004)(136003)(189003)(199004)(86362001)(74316002)(71200400001)(68736007)(71190400001)(66616009)(53546011)(6436002)(99286004)(26005)(76116006)(66476007)(66946007)(316002)(66556008)(6506007)(9686003)(305945005)(256004)(11346002)(14444005)(7416002)(7696005)(76176011)(486006)(229853002)(476003)(54906003)(110136005)(102836004)(5660300002)(66446008)(55016002)(64756008)(5024004)(52536014)(186003)(53936002)(446003)(8676002)(4326008)(6246003)(2906002)(81156014)(8936002)(81166006)(99936001)(6116002)(3846002)(2501003)(2201001)(14454004)(7736002)(66066001)(33656002)(25786009)(478600001)(49934004)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3074;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Mht5+xHBcKJAChmzXR/+O336D9cuJFKb0n6LE4Nk3NfYpPUW9FoBt7pQgelCBSNvUGXqUrHuwJckVOGhuW+u84cZpswOx8nQRB6+XtieCXRIzbQV8aF+Jeshv7BBQ2nf4CeQaNzzBRHQdDGyZ1ChnmrwPihXPS3N/PKch3ZhDPoM7029Z9j3jdmrZX7E9gY5LA+G9PhiixP0iRuTFr2yX4piDCZu2Eq9pAcvWqzU4PYrWzHUE+9PTmd4d3Jw2CuwoZag4sme/dz8YZRhCABSediywaZ3M+haLHaB9WGXqVx0rAwL44VfVF6OOGieZC7gLhy85f5/3bLK0bWRgxEyX/Vh6zY1dzjZvafmRSNKd2IQEy6W7GhbnawFtGjy7BS26gutIXbCllu7l94HaLdV7SQTGJd47NGl0M3bGeb0YjY=
Content-Type: multipart/mixed;
        boundary="_002_BN8PR12MB32664E23137805984F6FB2DAD3DC0BN8PR12MB3266namp_"
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e73c822-733d-4f9b-ca79-08d714d1d38c
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 09:39:32.4335
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: joabreu@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3074
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--_002_BN8PR12MB32664E23137805984F6FB2DAD3DC0BN8PR12MB3266namp_
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

RnJvbTogSm9uIEh1bnRlciA8am9uYXRoYW5oQG52aWRpYS5jb20+DQpEYXRlOiBKdWwvMjkvMjAx
OSwgMjI6MzM6MDQgKFVUQyswMDowMCkNCg0KPiANCj4gT24gMjkvMDcvMjAxOSAxNTowOCwgSm9z
ZSBBYnJldSB3cm90ZToNCj4gDQo+IC4uLg0KPiANCj4gPj4+IEhpIENhdGFsaW4gYW5kIFdpbGws
DQo+ID4+Pg0KPiA+Pj4gU29ycnkgdG8gYWRkIHlvdSBpbiBzdWNoIGEgbG9uZyB0aHJlYWQgYnV0
IHdlIGFyZSBzZWVpbmcgYSBETUEgaXNzdWUNCj4gPj4+IHdpdGggc3RtbWFjIGRyaXZlciBpbiBh
biBBUk02NCBwbGF0Zm9ybSB3aXRoIElPTU1VIGVuYWJsZWQuDQo+ID4+Pg0KPiA+Pj4gVGhlIGlz
c3VlIHNlZW1zIHRvIGJlIHNvbHZlZCB3aGVuIGJ1ZmZlcnMgYWxsb2NhdGlvbiBmb3IgRE1BIGJh
c2VkDQo+ID4+PiB0cmFuc2ZlcnMgYXJlICpub3QqIG1hcHBlZCB3aXRoIHRoZSBETUFfQVRUUl9T
S0lQX0NQVV9TWU5DIGZsYWcgKk9SKg0KPiA+Pj4gd2hlbiBJT01NVSBpcyBkaXNhYmxlZC4NCj4g
Pj4+DQo+ID4+PiBOb3RpY2UgdGhhdCBhZnRlciB0cmFuc2ZlciBpcyBkb25lIHdlIGRvIHVzZQ0K
PiA+Pj4gZG1hX3N5bmNfc2luZ2xlX2Zvcl97Y3B1LGRldmljZX0gYW5kIHRoZW4gd2UgcmV1c2Ug
KnRoZSBzYW1lKiBwYWdlIGZvcg0KPiA+Pj4gYW5vdGhlciB0cmFuc2Zlci4NCj4gPj4+DQo+ID4+
PiBDYW4geW91IHBsZWFzZSBjb21tZW50IG9uIHdoZXRoZXIgRE1BX0FUVFJfU0tJUF9DUFVfU1lO
QyBjYW4gbm90IGJlIHVzZWQNCj4gPj4+IGluIEFSTTY0IHBsYXRmb3JtcyB3aXRoIElPTU1VID8N
Cj4gPj4NCj4gPj4gSW4gdGVybXMgb2Ygd2hhdCB0aGV5IGRvLCB0aGVyZSBzaG91bGQgYmUgbm8g
ZGlmZmVyZW5jZSBvbiBhcm02NCBiZXR3ZWVuOg0KPiA+Pg0KPiA+PiBkbWFfbWFwX3BhZ2UoLi4u
LCBkaXIpOw0KPiA+PiAuLi4NCj4gPj4gZG1hX3VubWFwX3BhZ2UoLi4uLCBkaXIpOw0KPiA+Pg0K
PiA+PiBhbmQ6DQo+ID4+DQo+ID4+IGRtYV9tYXBfcGFnZV9hdHRycyguLi4sIGRpciwgRE1BX0FU
VFJfU0tJUF9DUFVfU1lOQyk7DQo+ID4+IGRtYV9zeW5jX3NpbmdsZV9mb3JfZGV2aWNlKC4uLiwg
ZGlyKTsNCj4gPj4gLi4uDQo+ID4+IGRtYV9zeW5jX3NpbmdsZV9mb3JfY3B1KC4uLiwgZGlyKTsN
Cj4gPj4gZG1hX3VubWFwX3BhZ2VfYXR0cnMoLi4uLCBkaXIsIERNQV9BVFRSX1NLSVBfQ1BVX1NZ
TkMpOw0KPiA+Pg0KPiA+PiBwcm92aWRlZCB0aGF0IHRoZSBmaXJzdCBzeW5jIGNvdmVycyB0aGUg
d2hvbGUgYnVmZmVyIGFuZCBhbnkgc3Vic2VxdWVudCANCj4gPj4gb25lcyBjb3ZlciBhdCBsZWFz
dCB0aGUgcGFydHMgb2YgdGhlIGJ1ZmZlciB3aGljaCBtYXkgaGF2ZSBjaGFuZ2VkLiBQbHVzIA0K
PiA+PiBmb3IgY29oZXJlbnQgaGFyZHdhcmUgaXQncyBlbnRpcmVseSBtb290IGVpdGhlciB3YXku
DQo+ID4gDQo+ID4gVGhhbmtzIGZvciBjb25maXJtaW5nLiBUaGF0J3MgaW5kZWVkIHdoYXQgc3Rt
bWFjIGlzIGRvaW5nIHdoZW4gYnVmZmVyIGlzIA0KPiA+IHJlY2VpdmVkIGJ5IHN5bmNpbmcgdGhl
IHBhY2tldCBzaXplIHRvIENQVS4NCj4gPiANCj4gPj4NCj4gPj4gR2l2ZW4gSm9uJ3MgcHJldmlv
dXMgZmluZGluZ3MsIEkgd291bGQgbGVhbiB0b3dhcmRzIHRoZSBpZGVhIHRoYXQgDQo+ID4+IHBl
cmZvcm1pbmcgdGhlIGV4dHJhIChyZWR1bmRhbnQpIGNhY2hlIG1haW50ZW5hbmNlIHBsdXMgYmFy
cmllciBpbiANCj4gPj4gZG1hX3VubWFwIGlzIG1vc3RseSBqdXN0IHBlcnR1cmJpbmcgdGltaW5n
IGluIHRoZSBzYW1lIHdheSBhcyB0aGUgZGVidWcgDQo+ID4+IHByaW50IHdoaWNoIGFsc28gbWFk
ZSB0aGluZ3Mgc2VlbSBPSy4NCj4gPiANCj4gPiBNaWtrbyBzYWlkIHRoYXQgVGVncmExODYgaXMg
bm90IGNvaGVyZW50IHNvIHdlIGhhdmUgdG8gZXhwbGljaXQgZmx1c2ggDQo+ID4gcGlwZWxpbmUg
YnV0IEkgZG9uJ3QgdW5kZXJzdGFuZCB3aHkgc3luY19zaW5nbGUoKSBpcyBub3QgZG9pbmcgaXQg
Li4uDQo+ID4gDQo+ID4gSm9uLCBjYW4geW91IHBsZWFzZSByZW1vdmUgKmFsbCogZGVidWcgcHJp
bnRzLCBoYWNrcywgZXRjIC4uLiBhbmQgdGVzdCANCj4gPiB0aGlzIG9uZSBpbiBhdHRhY2ggd2l0
aCBwbGFpbiAtbmV0IHRyZWUgPw0KPiANCj4gU28gZmFyIEkgaGF2ZSBqdXN0IGJlZW4gdGVzdGlu
ZyBvbiB0aGUgbWFpbmxpbmUga2VybmVsIGJyYW5jaC4gVGhlIGlzc3VlDQo+IHN0aWxsIHBlcnNp
c3RzIGFmdGVyIGFwcGx5aW5nIHRoaXMgb24gbWFpbmxpbmUuIEkgY2FuIHRlc3Qgb24gdGhlIC1u
ZXQNCj4gdHJlZSwgYnV0IEkgYW0gbm90IHN1cmUgdGhhdCB3aWxsIG1ha2UgYSBkaWZmZXJlbmNl
Lg0KPiANCj4gQ2hlZXJzDQo+IEpvbg0KPiANCj4gLS0gDQo+IG52cHVibGljDQoNCkkgbG9va2Vk
IGF0IG5ldHNlYyBpbXBsZW1lbnRhdGlvbiBhbmQgSSBub3RpY2VkIHRoYXQgd2UgYXJlIHN5bmNp
bmcgdGhlIA0Kb2xkIGJ1ZmZlciBmb3IgZGV2aWNlIGluc3RlYWQgb2YgdGhlIG5ldyBvbmUuIG5l
dHNlYyBzeW5jcyB0aGUgYnVmZmVyIA0KZm9yIGRldmljZSBpbW1lZGlhdGVseSBhZnRlciB0aGUg
YWxsb2NhdGlvbiB3aGljaCBtYXkgYmUgd2hhdCB3ZSBoYXZlIHRvIA0KZG8uIE1heWJlIHRoZSBh
dHRhY2hlZCBwYXRjaCBjYW4gbWFrZSB0aGluZ3Mgd29yayBmb3IgeW91ID8NCg0KLS0tDQpUaGFu
a3MsDQpKb3NlIE1pZ3VlbCBBYnJldQ0K

--_002_BN8PR12MB32664E23137805984F6FB2DAD3DC0BN8PR12MB3266namp_
Content-Type: application/octet-stream;
	name="0001-net-stmmac-Sync-RX-Buffer-upon-allocation.patch"
Content-Description: 0001-net-stmmac-Sync-RX-Buffer-upon-allocation.patch
Content-Disposition: attachment;
	filename="0001-net-stmmac-Sync-RX-Buffer-upon-allocation.patch"; size=2465;
	creation-date="Tue, 30 Jul 2019 09:36:22 GMT";
	modification-date="Tue, 30 Jul 2019 09:36:22 GMT"
Content-Transfer-Encoding: base64

RnJvbSAzNjAxZTNhZTQzNTdkNDhiMzI5NGY0Mjc4MWQwZjE5MDk1ZDFiMDBlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8MzYwMWUzYWU0MzU3ZDQ4YjMyOTRmNDI3ODFkMGYx
OTA5NWQxYjAwZS4xNTY0NDc5MzgyLmdpdC5qb2FicmV1QHN5bm9wc3lzLmNvbT4KRnJvbTogSm9z
ZSBBYnJldSA8am9hYnJldUBzeW5vcHN5cy5jb20+CkRhdGU6IFR1ZSwgMzAgSnVsIDIwMTkgMTE6
MzY6MTMgKzAyMDAKU3ViamVjdDogW1BBVENIIG5ldF0gbmV0OiBzdG1tYWM6IFN5bmMgUlggQnVm
ZmVyIHVwb24gYWxsb2NhdGlvbgoKU2lnbmVkLW9mZi1ieTogSm9zZSBBYnJldSA8am9hYnJldUBz
eW5vcHN5cy5jb20+Ci0tLQpDYzogR2l1c2VwcGUgQ2F2YWxsYXJvIDxwZXBwZS5jYXZhbGxhcm9A
c3QuY29tPgpDYzogQWxleGFuZHJlIFRvcmd1ZSA8YWxleGFuZHJlLnRvcmd1ZUBzdC5jb20+CkNj
OiBKb3NlIEFicmV1IDxqb2FicmV1QHN5bm9wc3lzLmNvbT4KQ2M6ICJEYXZpZCBTLiBNaWxsZXIi
IDxkYXZlbUBkYXZlbWxvZnQubmV0PgpDYzogTWF4aW1lIENvcXVlbGluIDxtY29xdWVsaW4uc3Rt
MzJAZ21haWwuY29tPgpDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZwpDYzogbGludXgtc3RtMzJA
c3QtbWQtbWFpbG1hbi5zdG9ybXJlcGx5LmNvbQpDYzogbGludXgtYXJtLWtlcm5lbEBsaXN0cy5p
bmZyYWRlYWQub3JnCkNjOiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnCi0tLQogZHJpdmVy
cy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvc3RtbWFjX21haW4uYyB8IDEzICsrKysrKysr
KystLS0KIDEgZmlsZSBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQoK
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hY19t
YWluLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9zdG1tYWNfbWFpbi5j
CmluZGV4IDk4YjFhNWM2ZDUzNy4uOWE0YTU2YWQzNWNkIDEwMDY0NAotLS0gYS9kcml2ZXJzL25l
dC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9zdG1tYWNfbWFpbi5jCisrKyBiL2RyaXZlcnMvbmV0
L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hY19tYWluLmMKQEAgLTMyNzEsOSArMzI3MSwx
MSBAQCBzdGF0aWMgaW5saW5lIGludCBzdG1tYWNfcnhfdGhyZXNob2xkX2NvdW50KHN0cnVjdCBz
dG1tYWNfcnhfcXVldWUgKnJ4X3EpCiBzdGF0aWMgaW5saW5lIHZvaWQgc3RtbWFjX3J4X3JlZmls
bChzdHJ1Y3Qgc3RtbWFjX3ByaXYgKnByaXYsIHUzMiBxdWV1ZSkKIHsKIAlzdHJ1Y3Qgc3RtbWFj
X3J4X3F1ZXVlICpyeF9xID0gJnByaXYtPnJ4X3F1ZXVlW3F1ZXVlXTsKLQlpbnQgZGlydHkgPSBz
dG1tYWNfcnhfZGlydHkocHJpdiwgcXVldWUpOworCWludCBsZW4sIGRpcnR5ID0gc3RtbWFjX3J4
X2RpcnR5KHByaXYsIHF1ZXVlKTsKIAl1bnNpZ25lZCBpbnQgZW50cnkgPSByeF9xLT5kaXJ0eV9y
eDsKIAorCWxlbiA9IERJVl9ST1VORF9VUChwcml2LT5kbWFfYnVmX3N6LCBQQUdFX1NJWkUpICog
UEFHRV9TSVpFOworCiAJd2hpbGUgKGRpcnR5LS0gPiAwKSB7CiAJCXN0cnVjdCBzdG1tYWNfcnhf
YnVmZmVyICpidWYgPSAmcnhfcS0+YnVmX3Bvb2xbZW50cnldOwogCQlzdHJ1Y3QgZG1hX2Rlc2Mg
KnA7CkBAIC0zMjkxLDYgKzMyOTMsMTMgQEAgc3RhdGljIGlubGluZSB2b2lkIHN0bW1hY19yeF9y
ZWZpbGwoc3RydWN0IHN0bW1hY19wcml2ICpwcml2LCB1MzIgcXVldWUpCiAJCX0KIAogCQlidWYt
PmFkZHIgPSBwYWdlX3Bvb2xfZ2V0X2RtYV9hZGRyKGJ1Zi0+cGFnZSk7CisKKwkJLyogU3luYyB3
aG9sZSBhbGxvY2F0aW9uIHRvIGRldmljZS4gVGhpcyB3aWxsIGludmFsaWRhdGUgb2xkCisJCSAq
IGRhdGEuCisJCSAqLworCQlkbWFfc3luY19zaW5nbGVfZm9yX2RldmljZShwcml2LT5kZXZpY2Us
IGJ1Zi0+YWRkciwgbGVuLAorCQkJCQkgICBETUFfRlJPTV9ERVZJQ0UpOworCiAJCXN0bW1hY19z
ZXRfZGVzY19hZGRyKHByaXYsIHAsIGJ1Zi0+YWRkcik7CiAJCXN0bW1hY19yZWZpbGxfZGVzYzMo
cHJpdiwgcnhfcSwgcCk7CiAKQEAgLTM0MjUsOCArMzQzNCw2IEBAIHN0YXRpYyBpbnQgc3RtbWFj
X3J4KHN0cnVjdCBzdG1tYWNfcHJpdiAqcHJpdiwgaW50IGxpbWl0LCB1MzIgcXVldWUpCiAJCQlz
a2JfY29weV90b19saW5lYXJfZGF0YShza2IsIHBhZ2VfYWRkcmVzcyhidWYtPnBhZ2UpLAogCQkJ
CQkJZnJhbWVfbGVuKTsKIAkJCXNrYl9wdXQoc2tiLCBmcmFtZV9sZW4pOwotCQkJZG1hX3N5bmNf
c2luZ2xlX2Zvcl9kZXZpY2UocHJpdi0+ZGV2aWNlLCBidWYtPmFkZHIsCi0JCQkJCQkgICBmcmFt
ZV9sZW4sIERNQV9GUk9NX0RFVklDRSk7CiAKIAkJCWlmIChuZXRpZl9tc2dfcGt0ZGF0YShwcml2
KSkgewogCQkJCW5ldGRldl9kYmcocHJpdi0+ZGV2LCAiZnJhbWUgcmVjZWl2ZWQgKCVkYnl0ZXMp
IiwKLS0gCjIuNy40Cgo=

--_002_BN8PR12MB32664E23137805984F6FB2DAD3DC0BN8PR12MB3266namp_--
