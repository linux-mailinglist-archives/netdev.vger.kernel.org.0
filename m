Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63D4A78D7E
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 16:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387420AbfG2OJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 10:09:09 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:37596 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727921AbfG2OJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 10:09:08 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id C92EEC2087;
        Mon, 29 Jul 2019 14:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1564409348; bh=PPw81ZyziDEZrNSCSmuSlX2OJpN1Wb0TdrfxzfvWa90=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=JmcROkRtHSxvpt3LpWIxiaHOE2cz4wCVY8va5Gu1qDrZnjlh5hUutyJ4FJe3NBcDV
         D0K8HQ/nUIoguny57pwBNEvsfB046Kl5bNBrnpxqvDrS8yNHrIsdz4kYqSodRcTJzI
         Vu+Ez9DVZUxzyxVI1+Y0k1PuIfymtF8ntYHQaC5KNrSRLYy8kuzzeGS2XilSoS1OAB
         T1yMumGdcNLOmvvP1FSWDnOUFc+CQwIxfvyw40uTR+XpbzsrqaZVADlQpeOyW+yArl
         W82mKgiKLIe93+RlzwDFxTd3zq0IbVcOzZ29jIpbj7D75ZZdXkNWBsbbmPPcVaJJnw
         22B8yCoQBFKHg==
Received: from US01WXQAHTC1.internal.synopsys.com (us01wxqahtc1.internal.synopsys.com [10.12.238.230])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 4EDE7A0093;
        Mon, 29 Jul 2019 14:09:05 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WXQAHTC1.internal.synopsys.com (10.12.238.230) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 29 Jul 2019 07:08:32 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 29 Jul 2019 07:08:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mVGvB7PpL5s986xrlFINyuBxjRNXrFO1/ZALnefVOYoZ434qIVJe2WmSX0/wuBqmnCq1WzUObQUeZhb0yZ7+Wk8cRsJeri+M2dTeCwwOMmIUQhNgM5ECXwid5kURunPHUtny5h0qjqDYKRDd4PFuyoGnc4T9rEGkfhF0KPPagRPBDq4iNvpK58LeGQxOzDvwxTv+/Sh99QkvsfqU2agvmVV94Efur9+Z+8vBCreeqN3VChgDpLy5Nwg1nFzC0KLw/bUy14sVwQ9o2BBhFz2ETjXVfM7rVDiqMuxxW5N/a8buqSSrHKldDLFDFwxT3JnmY1yoUfV04YE4JV1HFglXpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZzG4YDsUIh7Zf8n1przrCe22tnBK5WeUjA/h4Hp0cSg=;
 b=aR5uVOhOfDrVYgZBDXvX3w7Xc9K1FPkMYqlmNzdk3Vqyw6KwwGtEe7j6XOnQqAUzhcbXahXmdZUFzPIP+4eDeuQZqqqmOy+hqliu5P9ADi0qdf19EoCvMbqZo+Mj+aFDL9gqc8TgQmEyMGG1NOisvo6etnQsodWfq4YKPL2YJBTO5plnO4VXqzXwTGQDi+RebdG4PqSW1unW4mcvPCnnvT5fRU1mP1PuzCWj+IJsGldKqEcKflaFHtrOX0Io63xfk7d1MsslSFQauLdaFgK4O6aVwQkA1Bl+OTEv+PyRnsSc0V4ckYY1u2wBvKWq+bkODKMolzN8BN6USoO7YIfXWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=synopsys.com;dmarc=pass action=none
 header.from=synopsys.com;dkim=pass header.d=synopsys.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZzG4YDsUIh7Zf8n1przrCe22tnBK5WeUjA/h4Hp0cSg=;
 b=fgGAjWC15yC9eplWpHFzEJRPpfznMYAnU5oRP5Kr915oTJPUjC419czSRgXS7vePIC7XFNUc2kVZd3QEuZf+yWHWTmVB22Tgos5kFZvgAaflMUmOrLGkKjubgtIk7vMJ4LZp0nyOzZE9pGMHkZK7d0M2f5qM0Ad4VUZLWT46X8k=
Received: from MN2PR12MB3279.namprd12.prod.outlook.com (20.179.83.83) by
 MN2PR12MB3199.namprd12.prod.outlook.com (20.179.81.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Mon, 29 Jul 2019 14:08:31 +0000
Received: from MN2PR12MB3279.namprd12.prod.outlook.com
 ([fe80::3128:f343:a3d9:41a7]) by MN2PR12MB3279.namprd12.prod.outlook.com
 ([fe80::3128:f343:a3d9:41a7%3]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 14:08:31 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Robin Murphy <robin.murphy@arm.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Jon Hunter <jonathanh@nvidia.com>,
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
        "Chen-Yu Tsai" <wens@csie.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: RE: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Thread-Topic: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Thread-Index: AQHVMYtq2Zx4WVoG/U2kL8GCK0bP/abbdEOAgAAAgcCAABHmgIAADDMggAGB8wCAAa8dIIACpFiggAAs3ACAAAdb0IAACH4AgAACfEA=
Date:   Mon, 29 Jul 2019 14:08:29 +0000
Message-ID: <MN2PR12MB3279ABF628C52883021123C5D3DD0@MN2PR12MB3279.namprd12.prod.outlook.com>
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
In-Reply-To: <fcf648d2-70cc-d734-871a-ca7f745791b7@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9530f349-dd3d-48bb-66d2-08d7142e3c62
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(49563074)(7193020);SRVR:MN2PR12MB3199;
x-ms-traffictypediagnostic: MN2PR12MB3199:|MN2PR12MB3199:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR12MB31993EB3CEA28EB8D09E35ABD3DD0@MN2PR12MB3199.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(376002)(39860400002)(366004)(136003)(189003)(199004)(52314003)(966005)(99936001)(54906003)(110136005)(6116002)(3846002)(6436002)(316002)(2201001)(7416002)(33656002)(256004)(14444005)(5024004)(2906002)(186003)(66066001)(486006)(26005)(76116006)(446003)(11346002)(478600001)(229853002)(305945005)(7736002)(52536014)(102836004)(71200400001)(71190400001)(81166006)(81156014)(8676002)(66556008)(8936002)(66476007)(66446008)(64756008)(14454004)(66946007)(66616009)(25786009)(86362001)(53546011)(6506007)(99286004)(6246003)(4326008)(5660300002)(2501003)(68736007)(55016002)(6306002)(9686003)(76176011)(7696005)(53936002)(74316002)(476003)(440614002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR12MB3199;H:MN2PR12MB3279.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Woy5W5USn18KNYpXTCK/LXlwjxPOr/L7z8gJoRVy+1OV0BE6cpjD7a8c6jN/s1KHN7JI0BL9viU0iTSF9uRTZ5cEqtJO8XXs8aTb87K6FOBEJjsSRMLakrGRvecgWGzB35h1vYZlWnRa8n8TTl4dPZmMjIS9rzUK3sAX8UCzweY+n0VkBu1lRIW6RLuRINQwcc9fZwvAcjdwAp6k6nEcNpcos6yy3cUe+6oX4dmz0GimJt/vp6RGjIjpKBThXQNOajmKCZziH3pYb2XfjfJ4uw/RCwvhKc1tAEqRCr8qxnFSpiSe+WpgEoz9iG+ihpWaGXnEp3/pecYo4Hldf4CjUHNFv6NpX1ueRRW7gB5h8YKwf3Y/zxDkbxHejXaB0MYIc5Cfd8QRdAoccZDQa4v9CfVhmfFKO41b4UueELgB7lA=
Content-Type: multipart/mixed;
        boundary="_002_MN2PR12MB3279ABF628C52883021123C5D3DD0MN2PR12MB3279namp_"
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9530f349-dd3d-48bb-66d2-08d7142e3c62
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 14:08:30.3671
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: joabreu@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3199
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--_002_MN2PR12MB3279ABF628C52883021123C5D3DD0MN2PR12MB3279namp_
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

RnJvbTogUm9iaW4gTXVycGh5IDxyb2Jpbi5tdXJwaHlAYXJtLmNvbT4NCkRhdGU6IEp1bC8yOS8y
MDE5LCAxMjo1MjowMiAoVVRDKzAwOjAwKQ0KDQo+IE9uIDI5LzA3LzIwMTkgMTI6MjksIEpvc2Ug
QWJyZXUgd3JvdGU6DQo+ID4gKysgQ2F0YWxpbiwgV2lsbCAoQVJNNjQgTWFpbnRhaW5lcnMpDQo+
ID4gDQo+ID4gRnJvbTogSm9uIEh1bnRlciA8am9uYXRoYW5oQG52aWRpYS5jb20+DQo+ID4gRGF0
ZTogSnVsLzI5LzIwMTksIDExOjU1OjE4IChVVEMrMDA6MDApDQo+ID4gDQo+ID4+DQo+ID4+IE9u
IDI5LzA3LzIwMTkgMDk6MTYsIEpvc2UgQWJyZXUgd3JvdGU6DQo+ID4+PiBGcm9tOiBKb3NlIEFi
cmV1IDxqb2FicmV1QHN5bm9wc3lzLmNvbT4NCj4gPj4+IERhdGU6IEp1bC8yNy8yMDE5LCAxNjo1
NjozNyAoVVRDKzAwOjAwKQ0KPiA+Pj4NCj4gPj4+PiBGcm9tOiBKb24gSHVudGVyIDxqb25hdGhh
bmhAbnZpZGlhLmNvbT4NCj4gPj4+PiBEYXRlOiBKdWwvMjYvMjAxOSwgMTU6MTE6MDAgKFVUQysw
MDowMCkNCj4gPj4+Pg0KPiA+Pj4+Pg0KPiA+Pj4+PiBPbiAyNS8wNy8yMDE5IDE2OjEyLCBKb3Nl
IEFicmV1IHdyb3RlOg0KPiA+Pj4+Pj4gRnJvbTogSm9uIEh1bnRlciA8am9uYXRoYW5oQG52aWRp
YS5jb20+DQo+ID4+Pj4+PiBEYXRlOiBKdWwvMjUvMjAxOSwgMTU6MjU6NTkgKFVUQyswMDowMCkN
Cj4gPj4+Pj4+DQo+ID4+Pj4+Pj4NCj4gPj4+Pj4+PiBPbiAyNS8wNy8yMDE5IDE0OjI2LCBKb3Nl
IEFicmV1IHdyb3RlOg0KPiA+Pj4+Pj4+DQo+ID4+Pj4+Pj4gLi4uDQo+ID4+Pj4+Pj4NCj4gPj4+
Pj4+Pj4gV2VsbCwgSSB3YXNuJ3QgZXhwZWN0aW5nIHRoYXQgOi8NCj4gPj4+Pj4+Pj4NCj4gPj4+
Pj4+Pj4gUGVyIGRvY3VtZW50YXRpb24gb2YgYmFycmllcnMgSSB0aGluayB3ZSBzaG91bGQgc2V0
IGRlc2NyaXB0b3IgZmllbGRzDQo+ID4+Pj4+Pj4+IGFuZCB0aGVuIGJhcnJpZXIgYW5kIGZpbmFs
bHkgb3duZXJzaGlwIHRvIEhXIHNvIHRoYXQgcmVtYWluaW5nIGZpZWxkcw0KPiA+Pj4+Pj4+PiBh
cmUgY29oZXJlbnQgYmVmb3JlIG93bmVyIGlzIHNldC4NCj4gPj4+Pj4+Pj4NCj4gPj4+Pj4+Pj4g
QW55d2F5LCBjYW4geW91IGFsc28gYWRkIGEgZG1hX3JtYigpIGFmdGVyIHRoZSBjYWxsIHRvDQo+
ID4+Pj4+Pj4+IHN0bW1hY19yeF9zdGF0dXMoKSA/DQo+ID4+Pj4+Pj4NCj4gPj4+Pj4+PiBZZXMu
IEkgcmVtb3ZlZCB0aGUgZGVidWcgcHJpbnQgYWRkZWQgdGhlIGJhcnJpZXIsIGJ1dCB0aGF0IGRp
ZCBub3QgaGVscC4NCj4gPj4+Pj4+DQo+ID4+Pj4+PiBTbywgSSB3YXMgZmluYWxseSBhYmxlIHRv
IHNldHVwIE5GUyB1c2luZyB5b3VyIHJlcGxpY2F0ZWQgc2V0dXAgYW5kIEkNCj4gPj4+Pj4+IGNh
bid0IHNlZSB0aGUgaXNzdWUgOigNCj4gPj4+Pj4+DQo+ID4+Pj4+PiBUaGUgb25seSBkaWZmZXJl
bmNlIEkgaGF2ZSBmcm9tIHlvdXJzIGlzIHRoYXQgSSdtIHVzaW5nIFRDUCBpbiBORlMNCj4gPj4+
Pj4+IHdoaWxzdCB5b3UgKEkgYmVsaWV2ZSBmcm9tIHRoZSBsb2dzKSwgdXNlIFVEUC4NCj4gPj4+
Pj4NCj4gPj4+Pj4gU28gSSB0cmllZCBUQ1AgYnkgc2V0dGluZyB0aGUga2VybmVsIGJvb3QgcGFy
YW1zIHRvICduZnN2ZXJzPTMnIGFuZA0KPiA+Pj4+PiAncHJvdG89dGNwJyBhbmQgdGhpcyBkb2Vz
IGFwcGVhciB0byBiZSBtb3JlIHN0YWJsZSwgYnV0IG5vdCAxMDAlIHN0YWJsZS4NCj4gPj4+Pj4g
SXQgc3RpbGwgYXBwZWFycyB0byBmYWlsIGluIHRoZSBzYW1lIHBsYWNlIGFib3V0IDUwJSBvZiB0
aGUgdGltZS4NCj4gPj4+Pj4NCj4gPj4+Pj4+IFlvdSBkbyBoYXZlIGZsb3cgY29udHJvbCBhY3Rp
dmUgcmlnaHQgPyBBbmQgeW91ciBIVyBGSUZPIHNpemUgaXMgPj0gNGsgPw0KPiA+Pj4+Pg0KPiA+
Pj4+PiBIb3cgY2FuIEkgdmVyaWZ5IGlmIGZsb3cgY29udHJvbCBpcyBhY3RpdmU/DQo+ID4+Pj4N
Cj4gPj4+PiBZb3UgY2FuIGNoZWNrIGl0IGJ5IGR1bXBpbmcgcmVnaXN0ZXIgTVRMX1J4UV9PcGVy
YXRpb25fTW9kZSAoMHhkMzApLg0KPiA+Pg0KPiA+PiBXaGVyZSB3b3VsZCBiZSB0aGUgYXBwcm9w
cmlhdGUgcGxhY2UgdG8gZHVtcCB0aGlzPyBBZnRlciBwcm9iZT8gTWF5YmUNCj4gPj4gYmVzdCBp
ZiB5b3UgY2FuIHNoYXJlIGEgY29kZSBzbmlwcGV0IG9mIHdoZXJlIHRvIGR1bXAgdGhpcy4NCj4g
Pj4NCj4gPj4+PiBDYW4geW91IGFsc28gYWRkIElPTU1VIGRlYnVnIGluIGZpbGUgImRyaXZlcnMv
aW9tbXUvaW9tbXUuYyIgPw0KPiA+Pg0KPiA+PiBZb3UgY2FuIGZpbmQgYSBib290IGxvZyBoZXJl
Og0KPiA+Pg0KPiA+PiBodHRwczovL3VybGRlZmVuc2UucHJvb2Zwb2ludC5jb20vdjIvdXJsP3U9
aHR0cHMtM0FfX3Bhc3RlLnVidW50dS5jb21fcF9xdFJxdFlLSEdGXyZkPUR3SUNhUSZjPURQTDZf
WF82SmtYRng3QVhXcUIwdGcmcj1XSERzYzZrY1dBbDRpOTZWbTVoSl8xOUlKaXV4eF9wX1J6bzJn
LXVIREt3Jm09TnJ4c1IyZXRwWkhHYjdIa040WGRnYUdtS00xWFl5bGRpaE5QTDZxVlN2MCZzPUNN
QVRFY0hWb3FadzRzSXJOT1hjN1NGRV9rVl81Q081RVUyMS15SmV6NmMmZT0NCj4gPj4NCj4gPj4+
IEFuZCwgcGxlYXNlIHRyeSBhdHRhY2hlZCBkZWJ1ZyBwYXRjaC4NCj4gPj4NCj4gPj4gV2l0aCB0
aGlzIHBhdGNoIGl0IGFwcGVhcnMgdG8gYm9vdCBmaW5lLiBTbyBmYXIgbm8gaXNzdWVzIHNlZW4u
DQo+ID4gDQo+ID4gVGhhbmsgeW91IGZvciB0ZXN0aW5nLg0KPiA+IA0KPiA+IEhpIENhdGFsaW4g
YW5kIFdpbGwsDQo+ID4gDQo+ID4gU29ycnkgdG8gYWRkIHlvdSBpbiBzdWNoIGEgbG9uZyB0aHJl
YWQgYnV0IHdlIGFyZSBzZWVpbmcgYSBETUEgaXNzdWUNCj4gPiB3aXRoIHN0bW1hYyBkcml2ZXIg
aW4gYW4gQVJNNjQgcGxhdGZvcm0gd2l0aCBJT01NVSBlbmFibGVkLg0KPiA+IA0KPiA+IFRoZSBp
c3N1ZSBzZWVtcyB0byBiZSBzb2x2ZWQgd2hlbiBidWZmZXJzIGFsbG9jYXRpb24gZm9yIERNQSBi
YXNlZA0KPiA+IHRyYW5zZmVycyBhcmUgKm5vdCogbWFwcGVkIHdpdGggdGhlIERNQV9BVFRSX1NL
SVBfQ1BVX1NZTkMgZmxhZyAqT1IqDQo+ID4gd2hlbiBJT01NVSBpcyBkaXNhYmxlZC4NCj4gPiAN
Cj4gPiBOb3RpY2UgdGhhdCBhZnRlciB0cmFuc2ZlciBpcyBkb25lIHdlIGRvIHVzZQ0KPiA+IGRt
YV9zeW5jX3NpbmdsZV9mb3Jfe2NwdSxkZXZpY2V9IGFuZCB0aGVuIHdlIHJldXNlICp0aGUgc2Ft
ZSogcGFnZSBmb3INCj4gPiBhbm90aGVyIHRyYW5zZmVyLg0KPiA+IA0KPiA+IENhbiB5b3UgcGxl
YXNlIGNvbW1lbnQgb24gd2hldGhlciBETUFfQVRUUl9TS0lQX0NQVV9TWU5DIGNhbiBub3QgYmUg
dXNlZA0KPiA+IGluIEFSTTY0IHBsYXRmb3JtcyB3aXRoIElPTU1VID8NCj4gDQo+IEluIHRlcm1z
IG9mIHdoYXQgdGhleSBkbywgdGhlcmUgc2hvdWxkIGJlIG5vIGRpZmZlcmVuY2Ugb24gYXJtNjQg
YmV0d2VlbjoNCj4gDQo+IGRtYV9tYXBfcGFnZSguLi4sIGRpcik7DQo+IC4uLg0KPiBkbWFfdW5t
YXBfcGFnZSguLi4sIGRpcik7DQo+IA0KPiBhbmQ6DQo+IA0KPiBkbWFfbWFwX3BhZ2VfYXR0cnMo
Li4uLCBkaXIsIERNQV9BVFRSX1NLSVBfQ1BVX1NZTkMpOw0KPiBkbWFfc3luY19zaW5nbGVfZm9y
X2RldmljZSguLi4sIGRpcik7DQo+IC4uLg0KPiBkbWFfc3luY19zaW5nbGVfZm9yX2NwdSguLi4s
IGRpcik7DQo+IGRtYV91bm1hcF9wYWdlX2F0dHJzKC4uLiwgZGlyLCBETUFfQVRUUl9TS0lQX0NQ
VV9TWU5DKTsNCj4gDQo+IHByb3ZpZGVkIHRoYXQgdGhlIGZpcnN0IHN5bmMgY292ZXJzIHRoZSB3
aG9sZSBidWZmZXIgYW5kIGFueSBzdWJzZXF1ZW50IA0KPiBvbmVzIGNvdmVyIGF0IGxlYXN0IHRo
ZSBwYXJ0cyBvZiB0aGUgYnVmZmVyIHdoaWNoIG1heSBoYXZlIGNoYW5nZWQuIFBsdXMgDQo+IGZv
ciBjb2hlcmVudCBoYXJkd2FyZSBpdCdzIGVudGlyZWx5IG1vb3QgZWl0aGVyIHdheS4NCg0KVGhh
bmtzIGZvciBjb25maXJtaW5nLiBUaGF0J3MgaW5kZWVkIHdoYXQgc3RtbWFjIGlzIGRvaW5nIHdo
ZW4gYnVmZmVyIGlzIA0KcmVjZWl2ZWQgYnkgc3luY2luZyB0aGUgcGFja2V0IHNpemUgdG8gQ1BV
Lg0KDQo+IA0KPiBHaXZlbiBKb24ncyBwcmV2aW91cyBmaW5kaW5ncywgSSB3b3VsZCBsZWFuIHRv
d2FyZHMgdGhlIGlkZWEgdGhhdCANCj4gcGVyZm9ybWluZyB0aGUgZXh0cmEgKHJlZHVuZGFudCkg
Y2FjaGUgbWFpbnRlbmFuY2UgcGx1cyBiYXJyaWVyIGluIA0KPiBkbWFfdW5tYXAgaXMgbW9zdGx5
IGp1c3QgcGVydHVyYmluZyB0aW1pbmcgaW4gdGhlIHNhbWUgd2F5IGFzIHRoZSBkZWJ1ZyANCj4g
cHJpbnQgd2hpY2ggYWxzbyBtYWRlIHRoaW5ncyBzZWVtIE9LLg0KDQpNaWtrbyBzYWlkIHRoYXQg
VGVncmExODYgaXMgbm90IGNvaGVyZW50IHNvIHdlIGhhdmUgdG8gZXhwbGljaXQgZmx1c2ggDQpw
aXBlbGluZSBidXQgSSBkb24ndCB1bmRlcnN0YW5kIHdoeSBzeW5jX3NpbmdsZSgpIGlzIG5vdCBk
b2luZyBpdCAuLi4NCg0KSm9uLCBjYW4geW91IHBsZWFzZSByZW1vdmUgKmFsbCogZGVidWcgcHJp
bnRzLCBoYWNrcywgZXRjIC4uLiBhbmQgdGVzdCANCnRoaXMgb25lIGluIGF0dGFjaCB3aXRoIHBs
YWluIC1uZXQgdHJlZSA/DQoNCi0tLQ0KVGhhbmtzLA0KSm9zZSBNaWd1ZWwgQWJyZXUNCg==

--_002_MN2PR12MB3279ABF628C52883021123C5D3DD0MN2PR12MB3279namp_
Content-Type: application/octet-stream;
	name="0001-net-stmmac-Flush-all-data-cache-in-RX-path.patch"
Content-Description: 0001-net-stmmac-Flush-all-data-cache-in-RX-path.patch
Content-Disposition: attachment;
	filename="0001-net-stmmac-Flush-all-data-cache-in-RX-path.patch"; size=1647;
	creation-date="Mon, 29 Jul 2019 14:01:54 GMT";
	modification-date="Mon, 29 Jul 2019 14:01:54 GMT"
Content-Transfer-Encoding: base64

RnJvbSAxYjUxMmM3OTljZDg5NmM3YjYwOWJlNTEyZGI3YzQ3N2RlZjQzYzZiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8MWI1MTJjNzk5Y2Q4OTZjN2I2MDliZTUxMmRiN2M0
NzdkZWY0M2M2Yi4xNTY0NDA4OTE0LmdpdC5qb2FicmV1QHN5bm9wc3lzLmNvbT4KRnJvbTogSm9z
ZSBBYnJldSA8am9hYnJldUBzeW5vcHN5cy5jb20+CkRhdGU6IE1vbiwgMjkgSnVsIDIwMTkgMTY6
MDE6MzYgKzAyMDAKU3ViamVjdDogW1BBVENIIG5ldF0gbmV0OiBzdG1tYWM6IEZsdXNoIGFsbCBk
YXRhIGNhY2hlIGluIFJYIHBhdGgKClNpZ25lZC1vZmYtYnk6IEpvc2UgQWJyZXUgPGpvYWJyZXVA
c3lub3BzeXMuY29tPgotLS0KQ2M6IEdpdXNlcHBlIENhdmFsbGFybyA8cGVwcGUuY2F2YWxsYXJv
QHN0LmNvbT4KQ2M6IEFsZXhhbmRyZSBUb3JndWUgPGFsZXhhbmRyZS50b3JndWVAc3QuY29tPgpD
YzogSm9zZSBBYnJldSA8am9hYnJldUBzeW5vcHN5cy5jb20+CkNjOiAiRGF2aWQgUy4gTWlsbGVy
IiA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD4KQ2M6IE1heGltZSBDb3F1ZWxpbiA8bWNvcXVlbGluLnN0
bTMyQGdtYWlsLmNvbT4KQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcKQ2M6IGxpbnV4LXN0bTMy
QHN0LW1kLW1haWxtYW4uc3Rvcm1yZXBseS5jb20KQ2M6IGxpbnV4LWFybS1rZXJuZWxAbGlzdHMu
aW5mcmFkZWFkLm9yZwpDYzogbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZwotLS0KIGRyaXZl
cnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hY19tYWluLmMgfCAzICsrKwogMSBm
aWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0
aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hY19tYWluLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC9zdG1pY3JvL3N0bW1hYy9zdG1tYWNfbWFpbi5jCmluZGV4IDk4YjFhNWM2ZDUzNy4uZWQ3ZjBk
NmJkMGJjIDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9z
dG1tYWNfbWFpbi5jCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0
bW1hY19tYWluLmMKQEAgLTI3LDYgKzI3LDcgQEAKICNpbmNsdWRlIDxsaW51eC9pZi5oPgogI2lu
Y2x1ZGUgPGxpbnV4L2lmX3ZsYW4uaD4KICNpbmNsdWRlIDxsaW51eC9kbWEtbWFwcGluZy5oPgor
I2luY2x1ZGUgPGxpbnV4L2RtYS1ub25jb2hlcmVudC5oPgogI2luY2x1ZGUgPGxpbnV4L3NsYWIu
aD4KICNpbmNsdWRlIDxsaW51eC9wcmVmZXRjaC5oPgogI2luY2x1ZGUgPGxpbnV4L3BpbmN0cmwv
Y29uc3VtZXIuaD4KQEAgLTM0MjAsNiArMzQyMSw4IEBAIHN0YXRpYyBpbnQgc3RtbWFjX3J4KHN0
cnVjdCBzdG1tYWNfcHJpdiAqcHJpdiwgaW50IGxpbWl0LCB1MzIgcXVldWUpCiAJCQkJY29udGlu
dWU7CiAJCQl9CiAKKwkJCWFyY2hfZG1hX3ByZXBfY29oZXJlbnQoYnVmLT5wYWdlLCBmcmFtZV9s
ZW4pOworCiAJCQlkbWFfc3luY19zaW5nbGVfZm9yX2NwdShwcml2LT5kZXZpY2UsIGJ1Zi0+YWRk
ciwKIAkJCQkJCWZyYW1lX2xlbiwgRE1BX0ZST01fREVWSUNFKTsKIAkJCXNrYl9jb3B5X3RvX2xp
bmVhcl9kYXRhKHNrYiwgcGFnZV9hZGRyZXNzKGJ1Zi0+cGFnZSksCi0tIAoyLjcuNAoK

--_002_MN2PR12MB3279ABF628C52883021123C5D3DD0MN2PR12MB3279namp_--
