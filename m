Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2BAE78726
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 10:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbfG2IR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 04:17:27 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:42138 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726305AbfG2IR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 04:17:27 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id C0C94C01A5;
        Mon, 29 Jul 2019 08:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1564388245; bh=jomg73WNcWkB4SunBMf9ppAWHFTZWPgwSKUGvfxNaxs=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=XtP4H+51GxAvIqsC9avVFn0Q43uq0WVrha50QVmNCBR/jLupcBzo8sk1XF57iHBEy
         vmEvG/x7LXmFlEvSJaW0/w1Z5VMRVS/evkwn4rzcZk457mYmcXJ5BLICRX/Pu+fMHu
         skFVPeSSipOKZ8C4KVkhzy6DgcvV0C+k2NMSJyuSwTJXt8g/tQU82nc6uW+Ou6bjQa
         xt2xILONdrPW4/ScZYEGGjfKzBqzabSsoXtpAYr495VKGYLqEd9qdSEHgXVlMszJxy
         1SzGISTwbCe96/gZHt5bFS2rn3PzWoM2JJ1z6UNUkscCBztXXMJ+4D0t2umbaMgScR
         eyeMuUugJLdRA==
Received: from US01WXQAHTC1.internal.synopsys.com (us01wxqahtc1.internal.synopsys.com [10.12.238.230])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 54A9BA0093;
        Mon, 29 Jul 2019 08:17:18 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WXQAHTC1.internal.synopsys.com (10.12.238.230) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 29 Jul 2019 01:16:17 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 29 Jul 2019 01:16:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G8PUqbHY3v2T4dLD8MhjXzyq0TrkHSo/y0SB5wdN/gaGyMDTw7EtQ37kkHfSS66jYbxe/IktcqnUXKf9W+oKxZHeroQvZj12cRBgnW/bV+CGxqV2+t4Ow7QLwxhaKtaioNMwtwxK2bOIWl/PsFvhlxh0pk3QRgk5HmIIMhjJlFo+O9rcgJuqgU5byO9BllA+sH8tuYc33Dxf5jgwfK976HoxZHsXFzOdJpK04oMpGGE9kHdr6raC/gIFsVe3d1RilWLhnq09+hIu128ecjAvvMfrkWXMzL/V7JOuKMxuEzlyxsuKLtcist1Y2fXf0k3BDKInAyO+p2ORW6AICf2Fxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ggRDWLuzaX2XwRa9LXmg4kRowGxvpEUQxDBHXvXFGts=;
 b=cARhPU+pzw51Xzah+3puWt0u+/GsVNu7jr47abZmDQq5HOluza3Zqm23TqB7ZHLFcMTLaJZBMtXMbWHsFXvtmNe6H9zz5fDwES9S+9XPxV4P9dk6mz2uVN59FmNuzp3uy5v0O87562dgr4euJ5o2lcUeEOtaH/QGRupqJWLDramHy6xu4g/DMmY4ofjkfCgdgsKq0Xp4BrVVLaOksmMVdn6Wtel3S7BBWqa+wG3w/YgidlnbMW94R36cLaanXZtsgcAS2IKDIQEMazcMFA/grCTLQeqYr7gTp9H2EjTtqbiMzOohpq1885/8c74cmz/2rMFj//Jb414yWBy1xVvxeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=synopsys.com;dmarc=pass action=none
 header.from=synopsys.com;dkim=pass header.d=synopsys.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ggRDWLuzaX2XwRa9LXmg4kRowGxvpEUQxDBHXvXFGts=;
 b=ARuIxtY0o32r39XEKnwrtiaRliHqFvE6XqW7OQVIPUp6bG/pBsrLLAC/LUBA4mP69ngWqmavm1fvhDVwjCjYIjme12UkMeB7DZi8ijCgKn51GegqmC8m28jMgs9YC6EZMZDSUgTpnTowBBGdIMH2RV1poanvfJHR46fe9CakdGg=
Received: from MN2PR12MB3279.namprd12.prod.outlook.com (20.179.83.83) by
 MN2PR12MB3326.namprd12.prod.outlook.com (20.178.242.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Mon, 29 Jul 2019 08:16:15 +0000
Received: from MN2PR12MB3279.namprd12.prod.outlook.com
 ([fe80::3128:f343:a3d9:41a7]) by MN2PR12MB3279.namprd12.prod.outlook.com
 ([fe80::3128:f343:a3d9:41a7%3]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 08:16:15 +0000
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
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: RE: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Thread-Topic: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Thread-Index: AQHVMYtq2Zx4WVoG/U2kL8GCK0bP/abbdEOAgAAAgcCAABHmgIAADDMggAGB8wCAAa8dIIACpFig
Date:   Mon, 29 Jul 2019 08:16:15 +0000
Message-ID: <MN2PR12MB327907D4A6FB378AC989571AD3DD0@MN2PR12MB3279.namprd12.prod.outlook.com>
References: <cover.1562149883.git.joabreu@synopsys.com>
 <1b254bb7fc6044c5e6e2fdd9e00088d1d13a808b.1562149883.git.joabreu@synopsys.com>
 <7a79be5d-7ba2-c457-36d3-1ccef6572181@nvidia.com>
 <BYAPR12MB3269927AB1F67D46E150ED6BD3C10@BYAPR12MB3269.namprd12.prod.outlook.com>
 <9e695f33-fd9f-a910-0891-2b63bd75e082@nvidia.com>
 <BYAPR12MB3269B4A401E4DA10A07515C7D3C10@BYAPR12MB3269.namprd12.prod.outlook.com>
 <1e2ea942-28fe-15b9-f675-8d6585f9a33f@nvidia.com>
 <BYAPR12MB326922CDCB1D4B3D4A780CFDD3C30@BYAPR12MB3269.namprd12.prod.outlook.com>
In-Reply-To: <BYAPR12MB326922CDCB1D4B3D4A780CFDD3C30@BYAPR12MB3269.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dcfbdc21-f1e1-4b53-c281-08d713fd06ae
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(49563074)(7193020);SRVR:MN2PR12MB3326;
x-ms-traffictypediagnostic: MN2PR12MB3326:|MN2PR12MB3326:
x-microsoft-antispam-prvs: <MN2PR12MB3326615BBA0AADB68B513719D3DD0@MN2PR12MB3326.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(39850400004)(136003)(396003)(366004)(376002)(189003)(199004)(52314003)(71200400001)(186003)(6246003)(256004)(14444005)(5024004)(26005)(305945005)(6506007)(71190400001)(99936001)(2501003)(3846002)(6116002)(11346002)(486006)(68736007)(476003)(14454004)(7416002)(2906002)(99286004)(446003)(74316002)(102836004)(478600001)(53546011)(5660300002)(2201001)(33656002)(9686003)(66946007)(76116006)(53936002)(229853002)(66446008)(64756008)(66556008)(66476007)(66616009)(76176011)(66066001)(110136005)(4326008)(7736002)(55016002)(8676002)(6436002)(81156014)(81166006)(25786009)(54906003)(52536014)(8936002)(86362001)(7696005)(316002)(440614002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR12MB3326;H:MN2PR12MB3279.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6jtKGzHigD3uez2UCyGpdLXxS3XxA6wavQ+zr1j21/SqdQKLsC/yfP7RdLhZ7RW+UTFTghcIzwiTqf0p4okJmPqamNzEVy6AnJ4xOo2vJZldYSaTMf0dzNeLBi2l1Z3T93yX2+EnyJwFTTSCz6+/qd3ugIWTFoOlYM/7slbsfxs0eyhl9n2Ac2GxAPLndLXXKE/PUfbaijBAtq2H2LaLXnpzzQbvYwzLAwjsGfq2YyKsDhoM7feRYzGpqPfg0/cUg9LAAVRMEP3ZDfoSkoROFHxEx+SdmMicGaJS0NPoz3iHPdcxopToahLaooa5kzhd8i5QjFfZcHlCK8wZneJ+qeR99TTTRgJaFK/8c0d3qapH+UEijQrE/jqWb6QDGJZm0r86pD3kdeG9glNY+VjUL7l5e3pd9aYLEgwx8A+Xuqk=
Content-Type: multipart/mixed;
        boundary="_002_MN2PR12MB327907D4A6FB378AC989571AD3DD0MN2PR12MB3279namp_"
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: dcfbdc21-f1e1-4b53-c281-08d713fd06ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 08:16:15.4155
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: joabreu@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3326
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--_002_MN2PR12MB327907D4A6FB378AC989571AD3DD0MN2PR12MB3279namp_
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

RnJvbTogSm9zZSBBYnJldSA8am9hYnJldUBzeW5vcHN5cy5jb20+DQpEYXRlOiBKdWwvMjcvMjAx
OSwgMTY6NTY6MzcgKFVUQyswMDowMCkNCg0KPiBGcm9tOiBKb24gSHVudGVyIDxqb25hdGhhbmhA
bnZpZGlhLmNvbT4NCj4gRGF0ZTogSnVsLzI2LzIwMTksIDE1OjExOjAwIChVVEMrMDA6MDApDQo+
IA0KPiA+IA0KPiA+IE9uIDI1LzA3LzIwMTkgMTY6MTIsIEpvc2UgQWJyZXUgd3JvdGU6DQo+ID4g
PiBGcm9tOiBKb24gSHVudGVyIDxqb25hdGhhbmhAbnZpZGlhLmNvbT4NCj4gPiA+IERhdGU6IEp1
bC8yNS8yMDE5LCAxNToyNTo1OSAoVVRDKzAwOjAwKQ0KPiA+ID4gDQo+ID4gPj4NCj4gPiA+PiBP
biAyNS8wNy8yMDE5IDE0OjI2LCBKb3NlIEFicmV1IHdyb3RlOg0KPiA+ID4+DQo+ID4gPj4gLi4u
DQo+ID4gPj4NCj4gPiA+Pj4gV2VsbCwgSSB3YXNuJ3QgZXhwZWN0aW5nIHRoYXQgOi8NCj4gPiA+
Pj4NCj4gPiA+Pj4gUGVyIGRvY3VtZW50YXRpb24gb2YgYmFycmllcnMgSSB0aGluayB3ZSBzaG91
bGQgc2V0IGRlc2NyaXB0b3IgZmllbGRzIA0KPiA+ID4+PiBhbmQgdGhlbiBiYXJyaWVyIGFuZCBm
aW5hbGx5IG93bmVyc2hpcCB0byBIVyBzbyB0aGF0IHJlbWFpbmluZyBmaWVsZHMgDQo+ID4gPj4+
IGFyZSBjb2hlcmVudCBiZWZvcmUgb3duZXIgaXMgc2V0Lg0KPiA+ID4+Pg0KPiA+ID4+PiBBbnl3
YXksIGNhbiB5b3UgYWxzbyBhZGQgYSBkbWFfcm1iKCkgYWZ0ZXIgdGhlIGNhbGwgdG8gDQo+ID4g
Pj4+IHN0bW1hY19yeF9zdGF0dXMoKSA/DQo+ID4gPj4NCj4gPiA+PiBZZXMuIEkgcmVtb3ZlZCB0
aGUgZGVidWcgcHJpbnQgYWRkZWQgdGhlIGJhcnJpZXIsIGJ1dCB0aGF0IGRpZCBub3QgaGVscC4N
Cj4gPiA+IA0KPiA+ID4gU28sIEkgd2FzIGZpbmFsbHkgYWJsZSB0byBzZXR1cCBORlMgdXNpbmcg
eW91ciByZXBsaWNhdGVkIHNldHVwIGFuZCBJIA0KPiA+ID4gY2FuJ3Qgc2VlIHRoZSBpc3N1ZSA6
KA0KPiA+ID4gDQo+ID4gPiBUaGUgb25seSBkaWZmZXJlbmNlIEkgaGF2ZSBmcm9tIHlvdXJzIGlz
IHRoYXQgSSdtIHVzaW5nIFRDUCBpbiBORlMgDQo+ID4gPiB3aGlsc3QgeW91IChJIGJlbGlldmUg
ZnJvbSB0aGUgbG9ncyksIHVzZSBVRFAuDQo+ID4gDQo+ID4gU28gSSB0cmllZCBUQ1AgYnkgc2V0
dGluZyB0aGUga2VybmVsIGJvb3QgcGFyYW1zIHRvICduZnN2ZXJzPTMnIGFuZA0KPiA+ICdwcm90
bz10Y3AnIGFuZCB0aGlzIGRvZXMgYXBwZWFyIHRvIGJlIG1vcmUgc3RhYmxlLCBidXQgbm90IDEw
MCUgc3RhYmxlLg0KPiA+IEl0IHN0aWxsIGFwcGVhcnMgdG8gZmFpbCBpbiB0aGUgc2FtZSBwbGFj
ZSBhYm91dCA1MCUgb2YgdGhlIHRpbWUuDQo+ID4gDQo+ID4gPiBZb3UgZG8gaGF2ZSBmbG93IGNv
bnRyb2wgYWN0aXZlIHJpZ2h0ID8gQW5kIHlvdXIgSFcgRklGTyBzaXplIGlzID49IDRrID8NCj4g
PiANCj4gPiBIb3cgY2FuIEkgdmVyaWZ5IGlmIGZsb3cgY29udHJvbCBpcyBhY3RpdmU/DQo+IA0K
PiBZb3UgY2FuIGNoZWNrIGl0IGJ5IGR1bXBpbmcgcmVnaXN0ZXIgTVRMX1J4UV9PcGVyYXRpb25f
TW9kZSAoMHhkMzApLg0KPiANCj4gQ2FuIHlvdSBhbHNvIGFkZCBJT01NVSBkZWJ1ZyBpbiBmaWxl
ICJkcml2ZXJzL2lvbW11L2lvbW11LmMiID8NCg0KQW5kLCBwbGVhc2UgdHJ5IGF0dGFjaGVkIGRl
YnVnIHBhdGNoLg0KDQotLS0NClRoYW5rcywNCkpvc2UgTWlndWVsIEFicmV1DQo=

--_002_MN2PR12MB327907D4A6FB378AC989571AD3DD0MN2PR12MB3279namp_
Content-Type: application/octet-stream;
	name="0001-net-page_pool-Do-not-skip-CPU-sync.patch"
Content-Description: 0001-net-page_pool-Do-not-skip-CPU-sync.patch
Content-Disposition: attachment;
	filename="0001-net-page_pool-Do-not-skip-CPU-sync.patch"; size=1532;
	creation-date="Mon, 29 Jul 2019 08:14:35 GMT";
	modification-date="Mon, 29 Jul 2019 08:14:35 GMT"
Content-Transfer-Encoding: base64

RnJvbSBkMjAzYTRmMDU1YTM2YWUyMGVmYmNlZTdjZGY3MGNlMTNmZmYxMmM5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8ZDIwM2E0ZjA1NWEzNmFlMjBlZmJjZWU3Y2RmNzBj
ZTEzZmZmMTJjOS4xNTY0Mzg4MDc1LmdpdC5qb2FicmV1QHN5bm9wc3lzLmNvbT4KRnJvbTogSm9z
ZSBBYnJldSA8am9hYnJldUBzeW5vcHN5cy5jb20+CkRhdGU6IE1vbiwgMjkgSnVsIDIwMTkgMTA6
MTQ6MjEgKzAyMDAKU3ViamVjdDogW1BBVENIIG5ldF0gbmV0OiBwYWdlX3Bvb2w6IERvIG5vdCBz
a2lwIENQVSBzeW5jCgpTaWduZWQtb2ZmLWJ5OiBKb3NlIEFicmV1IDxqb2FicmV1QHN5bm9wc3lz
LmNvbT4KLS0tCkNjOiBKZXNwZXIgRGFuZ2FhcmQgQnJvdWVyIDxoYXdrQGtlcm5lbC5vcmc+CkNj
OiBJbGlhcyBBcGFsb2RpbWFzIDxpbGlhcy5hcGFsb2RpbWFzQGxpbmFyby5vcmc+CkNjOiAiRGF2
aWQgUy4gTWlsbGVyIiA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD4KQ2M6IG5ldGRldkB2Z2VyLmtlcm5l
bC5vcmcKQ2M6IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcKLS0tCiBuZXQvY29yZS9wYWdl
X3Bvb2wuYyB8IDUgKystLS0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDMgZGVs
ZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvbmV0L2NvcmUvcGFnZV9wb29sLmMgYi9uZXQvY29yZS9w
YWdlX3Bvb2wuYwppbmRleCAzMjcyZGM3YThjODEuLjAyNjJmY2RmMjE3ZSAxMDA2NDQKLS0tIGEv
bmV0L2NvcmUvcGFnZV9wb29sLmMKKysrIGIvbmV0L2NvcmUvcGFnZV9wb29sLmMKQEAgLTE1Niw3
ICsxNTYsNyBAQCBzdGF0aWMgc3RydWN0IHBhZ2UgKl9fcGFnZV9wb29sX2FsbG9jX3BhZ2VzX3Ns
b3coc3RydWN0IHBhZ2VfcG9vbCAqcG9vbCwKIAkgKi8KIAlkbWEgPSBkbWFfbWFwX3BhZ2VfYXR0
cnMocG9vbC0+cC5kZXYsIHBhZ2UsIDAsCiAJCQkJIChQQUdFX1NJWkUgPDwgcG9vbC0+cC5vcmRl
ciksCi0JCQkJIHBvb2wtPnAuZG1hX2RpciwgRE1BX0FUVFJfU0tJUF9DUFVfU1lOQyk7CisJCQkJ
IHBvb2wtPnAuZG1hX2RpciwgMCk7CiAJaWYgKGRtYV9tYXBwaW5nX2Vycm9yKHBvb2wtPnAuZGV2
LCBkbWEpKSB7CiAJCXB1dF9wYWdlKHBhZ2UpOwogCQlyZXR1cm4gTlVMTDsKQEAgLTIzMCw4ICsy
MzAsNyBAQCBzdGF0aWMgdm9pZCBfX3BhZ2VfcG9vbF9jbGVhbl9wYWdlKHN0cnVjdCBwYWdlX3Bv
b2wgKnBvb2wsCiAJZG1hID0gcGFnZS0+ZG1hX2FkZHI7CiAJLyogRE1BIHVubWFwICovCiAJZG1h
X3VubWFwX3BhZ2VfYXR0cnMocG9vbC0+cC5kZXYsIGRtYSwKLQkJCSAgICAgUEFHRV9TSVpFIDw8
IHBvb2wtPnAub3JkZXIsIHBvb2wtPnAuZG1hX2RpciwKLQkJCSAgICAgRE1BX0FUVFJfU0tJUF9D
UFVfU1lOQyk7CisJCQkgICAgIFBBR0VfU0laRSA8PCBwb29sLT5wLm9yZGVyLCBwb29sLT5wLmRt
YV9kaXIsIDApOwogCXBhZ2UtPmRtYV9hZGRyID0gMDsKIHNraXBfZG1hX3VubWFwOgogCWF0b21p
Y19pbmMoJnBvb2wtPnBhZ2VzX3N0YXRlX3JlbGVhc2VfY250KTsKLS0gCjIuNy40Cgo=

--_002_MN2PR12MB327907D4A6FB378AC989571AD3DD0MN2PR12MB3279namp_--
