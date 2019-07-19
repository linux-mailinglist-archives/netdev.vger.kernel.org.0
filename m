Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 195F36E2C7
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 10:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbfGSIoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 04:44:44 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:44354 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726222AbfGSIon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 04:44:43 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 3C02CC11FC;
        Fri, 19 Jul 2019 08:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1563525883; bh=6TzLPV223NdVLTWkhC5Hi9PC1wFR3WXo/ukXsr9sHfs=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=R4ZgaIJ6nVBF4miqdN8/L5Pb0O6bIo8d3fO+L0AWjdrzNrQgvVF4226I62+Dgma20
         HPreLrz3mIQWqUDFgEbgae4+TrzmGUg/Vd2zTXUHQYt8VzGG9kB5cP3nJexWCVXVoo
         unLw3IqRdN9HDamYmiL3CFjHa+Pkvu0o8yg/t6aQL5RQBn+p/s/+HBcr+khIQrFBgD
         W40NrmUsvd0S/2MoglrVty4opaUob7U0+HkOrdJBDsMRn71MV18gJ6D8Id6JfymwFG
         IH3g4s5oA0OZ28AqVvymSZaWVKXAxm9E60EnrUPD13TeuefK5+RaNOwFGxCxxssvHN
         wiD/DOtrQMhPw==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 8FBCEA0067;
        Fri, 19 Jul 2019 08:44:41 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Fri, 19 Jul 2019 01:44:24 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Fri, 19 Jul 2019 01:44:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nj0vEupm19U1PRDeHBBR3x54rkF4+TZccN2BqMTuXJz1syR+cxfUdB22euVp0nhZNqsd5HpvVNlZKfr6lUfWKrQK0v4es+12+FdhN4I7sU/WoWFa/2dFm4RwbN54TRGVHk63nfIBz3Vxp6+kIrcRy/iAnljEQgLm3isgiu04y/35gLr0ypSN6QrfDLN5hOCjcJid6xZnedi4Yt/krRrUHnpJ/Yc+BFJDErw78yr27F1WF0QxQtVPoXfJzaCJrpyBV01Lp6l5QRgGseZe1GLxgdxwO1ImOhlERzkC7FFvcKtHGN6PTZfgiD0W2vgR2Fj3zcHrSC9g1Xs3KksVDCo1ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6TzLPV223NdVLTWkhC5Hi9PC1wFR3WXo/ukXsr9sHfs=;
 b=JFU2RdELbpRFVygm7g7A/e8R5tWvrieKZvEVyNzIN3RP0NuEsTjf0dknAIrKLr+8/q870X9XwERR1okA02hxSgUqczDo748eH9OUbFjyG7ohxj2rkFp+a+7tqfE8CA7WXXg2IOdDQmw/xu7+avTzgMpzqtEAt2gmR5a9cl/Hjmc0bsWA6y76vSR9SoSqtTXM25DainrOv/VKoJfe/nYqrlA/sGAGxYRMBX7bYR5wkUihfuqVsNAXkBgaFs6N0fKXhTkKGmUBe/7KoFk4cpLG95mFDy+gV8seUxexMKTrXe12Z5L0M+VgwCZzjlo9+MpcHz8IlNqnVTUp9MDJbBxpng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=synopsys.com;dmarc=pass action=none
 header.from=synopsys.com;dkim=pass header.d=synopsys.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6TzLPV223NdVLTWkhC5Hi9PC1wFR3WXo/ukXsr9sHfs=;
 b=d2d00bMtRDErYm3kUPXIZhLQ3nObkW6J9U7DTOGaIJAc2uxoDzs5kJsWcx2e32CsuX6ZMc92jqOuxF+xYAEpA75QQNkQMS5AtLnrOCT9UKWCdy6KRyMcb5Fwsy+PhuwJgkDgNEKvNleSXwKl5dsrfC0Op3cy+tEWpzZdSikiu0Y=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.66.159) by
 BN8PR12MB2897.namprd12.prod.outlook.com (20.179.64.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.11; Fri, 19 Jul 2019 08:44:23 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::61ef:5598:59e0:fc9d]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::61ef:5598:59e0:fc9d%5]) with mapi id 15.20.2073.012; Fri, 19 Jul 2019
 08:44:23 +0000
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
Thread-Index: AQHVMYtq2Zx4WVoG/U2kL8GCK0bP/abPQEOAgADTx+CAABvLAIABeX5ggAAOFICAAAG4AA==
Date:   Fri, 19 Jul 2019 08:44:23 +0000
Message-ID: <BN8PR12MB3266989D15E017A789E14282D3CB0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <cover.1562149883.git.joabreu@synopsys.com>
 <1b254bb7fc6044c5e6e2fdd9e00088d1d13a808b.1562149883.git.joabreu@synopsys.com>
 <29dcc161-f7c8-026e-c3cc-5adb04df128c@nvidia.com>
 <BN8PR12MB32661E919A8DEBC7095BAA12D3C80@BN8PR12MB3266.namprd12.prod.outlook.com>
 <6a6bac84-1d29-2740-1636-d3adb26b6bcc@nvidia.com>
 <BN8PR12MB3266960A104A7CDBB4E59192D3CB0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <bc9ab3c5-b1b9-26d4-7b73-01474328eafa@nvidia.com>
In-Reply-To: <bc9ab3c5-b1b9-26d4-7b73-01474328eafa@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f53f61b9-3e4a-486c-1f88-08d70c254c76
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR12MB2897;
x-ms-traffictypediagnostic: BN8PR12MB2897:
x-microsoft-antispam-prvs: <BN8PR12MB28975A26EAC16B12C496C221D3CB0@BN8PR12MB2897.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(376002)(136003)(366004)(396003)(199004)(189003)(229853002)(53546011)(4326008)(8676002)(54906003)(2906002)(110136005)(6506007)(14454004)(316002)(74316002)(66066001)(478600001)(7696005)(55016002)(76176011)(33656002)(14444005)(256004)(8936002)(71200400001)(9686003)(2501003)(71190400001)(7416002)(53936002)(486006)(7736002)(68736007)(81156014)(81166006)(2201001)(4744005)(52536014)(6246003)(446003)(6436002)(11346002)(305945005)(476003)(3846002)(6116002)(86362001)(26005)(76116006)(5660300002)(66476007)(66556008)(64756008)(66446008)(66946007)(25786009)(99286004)(102836004)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB2897;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ZpzvEAJTYFnthMJXV/LyliOMM0qgQq1nJOti0RFL+FL5EQMU4x03cM99KT67T+8t0ttmSbqZJLWYDYimZD3smFRYZEJPXKXy7wKKpn572W759TMgIP5kRGN5bsmwLC232B5Gre7xd0NnHgpIxmW9k+HyiEthP1725b5i+FKkZ1pAyVxp0j2xsm+1HCy6frSWfwZ3VMOS9zSBVgYXVYyzfSR8F9QdO4ulQwk7TZliPyCieE4DYAEnNS1tEqBLSwcMnKzePQVvtgbfSpkrpcqR+HlzajJqOqJqubgT/bcoYOr5Yh96OM4iI/DVtOU+p9XztpKVO5RCpFjQq8X/HQq0pwSeE9GN0Md60Yis3CM0z3IOX9HWCiO01K4oOverLTy+7rgpKCVcDf5TRBgnzzoASNG+9oyXPu+ncxsCjp48Nnk=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f53f61b9-3e4a-486c-1f88-08d70c254c76
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 08:44:23.0368
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: joabreu@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2897
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSm9uIEh1bnRlciA8am9uYXRoYW5oQG52aWRpYS5jb20+DQpEYXRlOiBKdWwvMTkvMjAx
OSwgMDk6Mzc6NDkgKFVUQyswMDowMCkNCg0KPiANCj4gT24gMTkvMDcvMjAxOSAwODo1MSwgSm9z
ZSBBYnJldSB3cm90ZToNCj4gPiBGcm9tOiBKb24gSHVudGVyIDxqb25hdGhhbmhAbnZpZGlhLmNv
bT4NCj4gPiBEYXRlOiBKdWwvMTgvMjAxOSwgMTA6MTY6MjAgKFVUQyswMDowMCkNCj4gPiANCj4g
Pj4gSGF2ZSB5b3UgdHJpZWQgdXNpbmcgTkZTIG9uIGEgYm9hcmQgd2l0aCB0aGlzIGV0aGVybmV0
IGNvbnRyb2xsZXI/DQo+ID4gDQo+ID4gSSdtIGhhdmluZyBzb21lIGlzc3VlcyBzZXR0aW5nIHVw
IHRoZSBORlMgc2VydmVyIGluIG9yZGVyIHRvIHJlcGxpY2F0ZSANCj4gPiBzbyB0aGlzIG1heSB0
YWtlIHNvbWUgdGltZS4NCj4gDQo+IElmIHRoYXQncyB0aGUgY2FzZSwgd2UgbWF5IHdpc2ggdG8g
Y29uc2lkZXIgcmV2ZXJ0aW5nIHRoaXMgZm9yIG5vdyBhcyBpdA0KPiBpcyBwcmV2ZW50aW5nIG91
ciBib2FyZCBmcm9tIGJvb3RpbmcuIEFwcGVhcnMgdG8gcmV2ZXJ0IGNsZWFubHkgb24gdG9wDQo+
IG9mIG1haW5saW5lLg0KPiANCj4gPiBBcmUgeW91IGFibGUgdG8gYWRkIHNvbWUgZGVidWcgaW4g
c3RtbWFjX2luaXRfcnhfYnVmZmVycygpIHRvIHNlZSB3aGF0J3MgDQo+ID4gdGhlIGJ1ZmZlciBh
ZGRyZXNzID8NCj4gDQo+IElmIHlvdSBoYXZlIGEgZGVidWcgcGF0Y2ggeW91IHdvdWxkIGxpa2Ug
bWUgdG8gYXBwbHkgYW5kIHRlc3Qgd2l0aCBJDQo+IGNhbi4gSG93ZXZlciwgaXQgaXMgYmVzdCB5
b3UgcHJlcGFyZSB0aGUgcGF0Y2ggYXMgbWF5YmUgSSB3aWxsIG5vdCBkdW1wDQo+IHRoZSBhcHBy
b3ByaWF0ZSBhZGRyZXNzZXMuDQo+IA0KPiBDaGVlcnMNCj4gSm9uDQo+IA0KPiAtLSANCj4gbnZw
dWJsaWMNCg0KU2VuZCBtZSBmdWxsIGJvb3QgbG9nIHBsZWFzZS4NCg0KLS0tDQpUaGFua3MsDQpK
b3NlIE1pZ3VlbCBBYnJldQ0K
