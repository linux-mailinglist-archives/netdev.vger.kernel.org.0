Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A756E75241
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 17:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388979AbfGYPMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 11:12:51 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:34866 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387553AbfGYPMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 11:12:51 -0400
Received: from mailhost.synopsys.com (dc8-mailhost1.synopsys.com [10.13.135.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 43B15C1C1A;
        Thu, 25 Jul 2019 15:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1564067570; bh=CPGA2FpyGuZLv84v2O/aHQ+ZIaWuwHQWeXM1BdijTSc=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=BEkoAuxfn8If2zfQsmsxpn0KW1K1y9qEx76Lm5xCFiBmopQOsxorAxjH/RpvuYisn
         chufpGWPKnuJ3KFR9lvOT0vgxBH6UF8hjNtICmSA64OMstzVtW8HMGXPf3aP0N1/3m
         UlqBEU09pok8EBMmJGf3JgPbb3NG1LEVXG2wHYCYN/iA/DxmTS12uaJStU6gfljz0E
         qHdhaTQew030hUHyu+LA47DaCxDpcbPKIP3kUUNI9S6TxN8h6dnnv1HSz318fDn938
         oMbU7sNZ85uf9Y5EFT04UTYU4xU3c9oZAXfaVeOH0fxwyn2hfO4161jTkho79o9oXO
         jzTZEd+thOl4g==
Received: from US01WEHTC2.internal.synopsys.com (us01wehtc2.internal.synopsys.com [10.12.239.237])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id E29CCA006A;
        Thu, 25 Jul 2019 15:12:46 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC2.internal.synopsys.com (10.12.239.237) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 25 Jul 2019 08:12:46 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Thu, 25 Jul 2019 08:12:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TRMY03N8XRoR0UNzHwr7T20zN3sBVBFpdQhBn8Z6zrmR3cC1bI5biXGl0OHYB0ChAx7cV3ahv+0IbqS81urrhZqbnzmpAbsWtAqBYwGZ7XQDvesSRwVf9z7HNgBqp8XrdhGpQY+buJy5LSefEU9scUkxnH57wIqLVoorIWSz/dS8uZO4Wcs6tVVO4upugufktFnKUi9ThipX5yB770WDYqNyRNu61wz/1ruJaaAQenLkPrJPE6Z/uChZ9JTkHzt79GGNoCoJDgvZCdk1Uw5Bw4mJeJ90Y98jCB+IZv4KpSnpg+xhL/xy2hjWAmwQuF7NJdjWl19qEQTSZhjeTZURGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CPGA2FpyGuZLv84v2O/aHQ+ZIaWuwHQWeXM1BdijTSc=;
 b=Jpg/LFUX7tTMmTN+ZAMQC9dpGM35Ar0qyk5g+YY+l9gEmDQ14dRgP9obtwcT6br7cMeejINPgEKlJhZfiyCtpX9H3mF70Qx8NBofsZab1a1APC8v8AI0feX5+Chh0yJsQjBzQuVRu/F2zArQ9hhXVPCNtd9g6jdfvOZVQWens2nIWxHcK2D9oIbiRqcRx+9jSVa0WFRkFqT8U/dkV4/6ONLaK0++m2oSVPU3kcWefHo37F7v+H5D7jySjVOvokpiOa4sGn30vzTonDxuLi6xetHHdaPHmnwh2pkhnjf7+XqCnmiPJJ27YapdlsYiDja3/lzkcHg86XSEIYFzkvmCeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=synopsys.com;dmarc=pass action=none
 header.from=synopsys.com;dkim=pass header.d=synopsys.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CPGA2FpyGuZLv84v2O/aHQ+ZIaWuwHQWeXM1BdijTSc=;
 b=X8+eQefiolazXMNPyy7S+pBw2OIuxMex4I1ChYqDv8c4LxP3dvQDdiVdA5t8wMGQ9kUOMl1LsOCca9+tHgUD4gP0+vxt4LD1eOHrBUvajOK4YiP+6vUSVg5XGtdbwHgK74GIXQ0S5Ad3RM1yitSG0y2n5IRflXcdHHh7CWqE2+M=
Received: from BYAPR12MB3269.namprd12.prod.outlook.com (20.179.93.146) by
 BYAPR12MB2774.namprd12.prod.outlook.com (20.177.126.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Thu, 25 Jul 2019 15:12:44 +0000
Received: from BYAPR12MB3269.namprd12.prod.outlook.com
 ([fe80::f5b8:ac6e:ea68:cb1c]) by BYAPR12MB3269.namprd12.prod.outlook.com
 ([fe80::f5b8:ac6e:ea68:cb1c%4]) with mapi id 15.20.2094.013; Thu, 25 Jul 2019
 15:12:44 +0000
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
        Robin Murphy <robin.murphy@arm.com>,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: RE: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Thread-Topic: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Thread-Index: AQHVMYtq2Zx4WVoG/U2kL8GCK0bP/abbdEOAgAAAgcCAABHmgIAADDMg
Date:   Thu, 25 Jul 2019 15:12:44 +0000
Message-ID: <BYAPR12MB3269B4A401E4DA10A07515C7D3C10@BYAPR12MB3269.namprd12.prod.outlook.com>
References: <cover.1562149883.git.joabreu@synopsys.com>
 <1b254bb7fc6044c5e6e2fdd9e00088d1d13a808b.1562149883.git.joabreu@synopsys.com>
 <7a79be5d-7ba2-c457-36d3-1ccef6572181@nvidia.com>
 <BYAPR12MB3269927AB1F67D46E150ED6BD3C10@BYAPR12MB3269.namprd12.prod.outlook.com>
 <9e695f33-fd9f-a910-0891-2b63bd75e082@nvidia.com>
In-Reply-To: <9e695f33-fd9f-a910-0891-2b63bd75e082@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 28f4ac83-9f92-4e6d-74a6-08d711128ba3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR12MB2774;
x-ms-traffictypediagnostic: BYAPR12MB2774:
x-microsoft-antispam-prvs: <BYAPR12MB2774DBB4B8D61D9B8097B196D3C10@BYAPR12MB2774.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(396003)(366004)(39860400002)(376002)(199004)(52314003)(189003)(99286004)(256004)(66946007)(76116006)(33656002)(66556008)(66446008)(7416002)(316002)(3846002)(2906002)(71190400001)(6116002)(486006)(66476007)(8936002)(81156014)(81166006)(4744005)(71200400001)(52536014)(2501003)(478600001)(26005)(7736002)(9686003)(25786009)(186003)(5660300002)(476003)(8676002)(305945005)(54906003)(6246003)(66066001)(2201001)(53936002)(6436002)(53546011)(446003)(102836004)(229853002)(4326008)(68736007)(6506007)(74316002)(14454004)(76176011)(55016002)(7696005)(64756008)(110136005)(86362001)(11346002)(440614002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR12MB2774;H:BYAPR12MB3269.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 01aYrOaq+R/cxmHSSkyFrP3+ukr0hyghq+UCjzWUiJOGExzzltDgKikj8r6u3U2q3MTd6bgd+WsaHBayVWhWO4IIpUFXS3kXj7EvQicuvPbutfpGbW21zKJpQ0bGSewheSudDa6+sljcELme+dTVIf+86tv6J65GYsAbTJjVJbQOuQviMSztYLBJsCtY+cG6KVdotiDrqiWLPT2qz18ffMh8LMo8IhOgCXsy6cOmWj8s2rTydnMBI1N4wHzdzXmT0VMLn29hrsxOWDzLKi+PXVv4MQeBjfnOx702jG7WI7Bc9XSXNE4jQ51WlVDknvjs+dt5+znMdPr1DSR6AC2bfH9OIEroCMlNzncSQASWL+iIGSscs6UyLxCSw+mHKOrbludqyM/AShmvJdKqV8K0oW1lUttKcDWidTw94JEROv8=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 28f4ac83-9f92-4e6d-74a6-08d711128ba3
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 15:12:44.5023
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: joabreu@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2774
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSm9uIEh1bnRlciA8am9uYXRoYW5oQG52aWRpYS5jb20+DQpEYXRlOiBKdWwvMjUvMjAx
OSwgMTU6MjU6NTkgKFVUQyswMDowMCkNCg0KPiANCj4gT24gMjUvMDcvMjAxOSAxNDoyNiwgSm9z
ZSBBYnJldSB3cm90ZToNCj4gDQo+IC4uLg0KPiANCj4gPiBXZWxsLCBJIHdhc24ndCBleHBlY3Rp
bmcgdGhhdCA6Lw0KPiA+IA0KPiA+IFBlciBkb2N1bWVudGF0aW9uIG9mIGJhcnJpZXJzIEkgdGhp
bmsgd2Ugc2hvdWxkIHNldCBkZXNjcmlwdG9yIGZpZWxkcyANCj4gPiBhbmQgdGhlbiBiYXJyaWVy
IGFuZCBmaW5hbGx5IG93bmVyc2hpcCB0byBIVyBzbyB0aGF0IHJlbWFpbmluZyBmaWVsZHMgDQo+
ID4gYXJlIGNvaGVyZW50IGJlZm9yZSBvd25lciBpcyBzZXQuDQo+ID4gDQo+ID4gQW55d2F5LCBj
YW4geW91IGFsc28gYWRkIGEgZG1hX3JtYigpIGFmdGVyIHRoZSBjYWxsIHRvIA0KPiA+IHN0bW1h
Y19yeF9zdGF0dXMoKSA/DQo+IA0KPiBZZXMuIEkgcmVtb3ZlZCB0aGUgZGVidWcgcHJpbnQgYWRk
ZWQgdGhlIGJhcnJpZXIsIGJ1dCB0aGF0IGRpZCBub3QgaGVscC4NCg0KU28sIEkgd2FzIGZpbmFs
bHkgYWJsZSB0byBzZXR1cCBORlMgdXNpbmcgeW91ciByZXBsaWNhdGVkIHNldHVwIGFuZCBJIA0K
Y2FuJ3Qgc2VlIHRoZSBpc3N1ZSA6KA0KDQpUaGUgb25seSBkaWZmZXJlbmNlIEkgaGF2ZSBmcm9t
IHlvdXJzIGlzIHRoYXQgSSdtIHVzaW5nIFRDUCBpbiBORlMgDQp3aGlsc3QgeW91IChJIGJlbGll
dmUgZnJvbSB0aGUgbG9ncyksIHVzZSBVRFAuDQoNCllvdSBkbyBoYXZlIGZsb3cgY29udHJvbCBh
Y3RpdmUgcmlnaHQgPyBBbmQgeW91ciBIVyBGSUZPIHNpemUgaXMgPj0gNGsgPw0KDQotLS0NClRo
YW5rcywNCkpvc2UgTWlndWVsIEFicmV1DQo=
