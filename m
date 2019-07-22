Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 816216FCAD
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 11:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729323AbfGVJrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 05:47:52 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:57732 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729314AbfGVJrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 05:47:51 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 959CFC0C17;
        Mon, 22 Jul 2019 09:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1563788870; bh=hq6gJ+K6N4pn/7PhWA2I1CQUMqIfpkRR26n8J4BBq9Q=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=hzU4UymHml3WqCGbSv5OB1Mw5Oqy6as082mZzZgWYGGDOb78+1jVcLatFVZL6OI13
         gf9L1qgphzvHby/Ppc60G5zmMJBBRY7h/U4o60T+9tKVdFjeeEcaVThMPC5WKQemEG
         SG93M6hwdNbaM0c/LsvdZGmNQiBByOdVcj+FpaLy21H49kqMbfFDjS5iTAY3UmZjka
         GhJ9f89EX6AHALz++I/XGd88WMOkubYuHxYablpnF1ojV31GybtBI8wcYa8EEAUlYu
         bOem/fCvQqYZ1v6i53EVJiTgqcPvjP7z1eQ3Ug/16Jny1PlVQFthjPY1JoDxh0dpR4
         g33lNfry5iUPg==
Received: from US01WEHTC2.internal.synopsys.com (us01wehtc2.internal.synopsys.com [10.12.239.237])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id CF355A00A3;
        Mon, 22 Jul 2019 09:47:47 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC2.internal.synopsys.com (10.12.239.237) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 22 Jul 2019 02:47:47 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 22 Jul 2019 02:47:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D+VybMxTBN+wF1jz6PKye6JOWuva8BcAfDz7vCYbTyJJG5qmRLkEx47jbXr3NbpgfjdNmVuRHLEpOFizQNuFzVHwWtplNNbxuczfaOgUntUGziu1U6MFPeEkZ63AuvHAypeWt7u4MiFqHJ/G/LXZpjFwLpg8Kx8HRr+RwgbB5yVbuxpYb7kDYISpgK2UBr/GYKOv8vf58RNFi3YDmFV7ZKy6+hOkq7rj0g8ennjGWaSr5UkFbGchwrpNojaDUzzTF9y51VJuK7uzg3NDy/sr6I0PP7FSlt08hAzf8yS3Fca2ocA11nqmXT1ThRCGWNITzqe33oipy5qvj2xrI2Qe+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hq6gJ+K6N4pn/7PhWA2I1CQUMqIfpkRR26n8J4BBq9Q=;
 b=ObTB4Lg96VzVijeoLDIn0ZBTxhWWiwkYv7QVDIrWwME2G5RzhrcwG66cCuBonOn8Yg4JeuiLNuzNR++uenwaNdENAHmaDpHBKM5+d6bBG33LI9QTcEBjoTNyoS9258FY+uYoroNW43PHGwGFrjJNZPTjzEpsUhbh+G7LrAYaM1qOZs1QqocHqjdHS84oZMNsqYH8YlQKLwFQBOXI2tEqOISIyzjnOqcXAOHp1tYCO4C+Dq/rEQaqqM78IivIMOZo4L6dJdCvQ7jDvj/OHtcT9TBdaEfXAFWx10O9j11Mz6NzYzY6Nu7L+5CnjK6y1vpQ4bLb4qaHLKvS6G1lh/tttA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=synopsys.com;dmarc=pass action=none
 header.from=synopsys.com;dkim=pass header.d=synopsys.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hq6gJ+K6N4pn/7PhWA2I1CQUMqIfpkRR26n8J4BBq9Q=;
 b=BqBMuba0cBxTtgru6iq8CBud3JfYzIxKZ+Uf946xpsxcwx1nGFFtw6+wBAheSBTKK1RvWfXfr/pLftCsVO2ZWj9yRWXQ4UdGWUY7C+FWpb+m8F8VYR4cgbiN1J0D1qSY2fXNe2Hi2D5BXwBMUve/VnxemcOHmTHnnoc2MGvnA0Q=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.66.159) by
 BN8PR12MB3476.namprd12.prod.outlook.com (20.178.212.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Mon, 22 Jul 2019 09:47:46 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::61ef:5598:59e0:fc9d]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::61ef:5598:59e0:fc9d%5]) with mapi id 15.20.2094.013; Mon, 22 Jul 2019
 09:47:44 +0000
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
Thread-Index: AQHVMYtq2Zx4WVoG/U2kL8GCK0bP/abPQEOAgADTx+CAABvLAIABeX5ggAAOFICAAAG4AIAAAXQAgAAaB/CAACO4AIAAAIsAgAAR0ACABE5q0IAAJe0AgAAA9wA=
Date:   Mon, 22 Jul 2019 09:47:44 +0000
Message-ID: <BN8PR12MB3266362102CCB6B4DDE4BEA0D3C40@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <cover.1562149883.git.joabreu@synopsys.com>
 <1b254bb7fc6044c5e6e2fdd9e00088d1d13a808b.1562149883.git.joabreu@synopsys.com>
 <29dcc161-f7c8-026e-c3cc-5adb04df128c@nvidia.com>
 <BN8PR12MB32661E919A8DEBC7095BAA12D3C80@BN8PR12MB3266.namprd12.prod.outlook.com>
 <6a6bac84-1d29-2740-1636-d3adb26b6bcc@nvidia.com>
 <BN8PR12MB3266960A104A7CDBB4E59192D3CB0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <bc9ab3c5-b1b9-26d4-7b73-01474328eafa@nvidia.com>
 <BN8PR12MB3266989D15E017A789E14282D3CB0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <4db855e4-1d59-d30b-154c-e7a2aa1c9047@nvidia.com>
 <BN8PR12MB3266FD9CF18691EDEF05A4B8D3CB0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <64e37224-6661-ddb0-4394-83a16e1ccb61@nvidia.com>
 <BN8PR12MB3266E1FAC5B7874EFA69DD7BD3CB0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <25512348-5b98-aeb7-a6fb-f90376e66a84@nvidia.com>
 <BN8PR12MB32665C1A106D3DCBF89CEA54D3C40@BN8PR12MB3266.namprd12.prod.outlook.com>
 <49efad87-2f74-5804-af4c-33730f865c41@nvidia.com>
In-Reply-To: <49efad87-2f74-5804-af4c-33730f865c41@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7e9aa974-9723-4a8d-3f35-08d70e89a576
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR12MB3476;
x-ms-traffictypediagnostic: BN8PR12MB3476:
x-microsoft-antispam-prvs: <BN8PR12MB34765947837CC7AAD9A305CBD3C40@BN8PR12MB3476.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01068D0A20
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(376002)(39860400002)(136003)(396003)(52314003)(199004)(189003)(5660300002)(3846002)(7416002)(2906002)(54906003)(478600001)(74316002)(66446008)(7736002)(305945005)(81156014)(2501003)(66946007)(110136005)(64756008)(66476007)(229853002)(6116002)(52536014)(5024004)(81166006)(8676002)(68736007)(316002)(8936002)(76116006)(6506007)(446003)(55016002)(256004)(26005)(6436002)(53936002)(76176011)(476003)(66556008)(2201001)(4326008)(71200400001)(102836004)(186003)(7696005)(86362001)(53546011)(66066001)(71190400001)(25786009)(33656002)(11346002)(6246003)(14444005)(9686003)(99286004)(486006)(14454004);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3476;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: obzIGZdfAOdYS3pYXkcFl2DGm3bMttg7JDCY+aqQspFZNBBbzjgdTTODsiHU4Vakh51KTvhh679NLqttwrPvz59mWuLfGWutrkBfOnuq3hatU6sUyJ/xmBnP8lMYYZhBIxfWPL7kzLFDRMKeqV0WuBwjO/5wJvIXo+QgKRXG59CiwaDfHKCBc5otpWpju/ByWmubcgancfSIfM2dz4jfYIBY6UPObbnXKqCa9sN489op3f3OFp0M/j5YrjbqcFqJUzEPmzIuwfXAMis8bqejleXB3VGttGKYtgTVNJFGsFlWdNEYLpHjqNFhChoeeNWuxGVrMD/odP3hX8FzfSQQC37tXBqc10vKoW+up1ORYv70WWiDf3wLl9j5UEgOd1H6iW1o95zeN8ymuLEGIqtmxOXQR65B5pmDScvxqAhxYmM=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e9aa974-9723-4a8d-3f35-08d70e89a576
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2019 09:47:44.4533
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: joabreu@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3476
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSm9uIEh1bnRlciA8am9uYXRoYW5oQG52aWRpYS5jb20+DQpEYXRlOiBKdWwvMjIvMjAx
OSwgMTA6Mzc6MTggKFVUQyswMDowMCkNCg0KPiANCj4gT24gMjIvMDcvMjAxOSAwODoyMywgSm9z
ZSBBYnJldSB3cm90ZToNCj4gPiBGcm9tOiBKb24gSHVudGVyIDxqb25hdGhhbmhAbnZpZGlhLmNv
bT4NCj4gPiBEYXRlOiBKdWwvMTkvMjAxOSwgMTQ6MzU6NTIgKFVUQyswMDowMCkNCj4gPiANCj4g
Pj4NCj4gPj4gT24gMTkvMDcvMjAxOSAxMzozMiwgSm9zZSBBYnJldSB3cm90ZToNCj4gPj4+IEZy
b206IEpvbiBIdW50ZXIgPGpvbmF0aGFuaEBudmlkaWEuY29tPg0KPiA+Pj4gRGF0ZTogSnVsLzE5
LzIwMTksIDEzOjMwOjEwIChVVEMrMDA6MDApDQo+ID4+Pg0KPiA+Pj4+IEkgYm9vdGVkIHRoZSBi
b2FyZCB3aXRob3V0IHVzaW5nIE5GUyBhbmQgdGhlbiBzdGFydGVkIHVzZWQgZGhjbGllbnQgdG8N
Cj4gPj4+PiBicmluZyB1cCB0aGUgbmV0d29yayBpbnRlcmZhY2UgYW5kIGl0IGFwcGVhcnMgdG8g
YmUgd29ya2luZyBmaW5lLiBJIGNhbg0KPiA+Pj4+IGV2ZW4gbW91bnQgdGhlIE5GUyBzaGFyZSBm
aW5lLiBTbyBpdCBkb2VzIGFwcGVhciB0byBiZSBwYXJ0aWN1bGFyIHRvDQo+ID4+Pj4gdXNpbmcg
TkZTIHRvIG1vdW50IHRoZSByb290ZnMuDQo+ID4+Pg0KPiA+Pj4gRGFtbi4gQ2FuIHlvdSBzZW5k
IG1lIHlvdXIgLmNvbmZpZyA/DQo+ID4+DQo+ID4+IFllcyBubyBwcm9ibGVtLiBBdHRhY2hlZC4N
Cj4gPiANCj4gPiBDYW4geW91IGNvbXBpbGUgeW91ciBpbWFnZSB3aXRob3V0IG1vZHVsZXMgKGku
ZS4gYWxsIGJ1aWx0LWluKSBhbmQgbGV0IA0KPiA+IG1lIGtub3cgaWYgdGhlIGVycm9yIHN0aWxs
IGhhcHBlbnMgPw0KPiANCj4gSSBzaW1wbHkgcmVtb3ZlZCB0aGUgL2xpYi9tb2R1bGVzIGRpcmVj
dG9yeSBmcm9tIHRoZSBORlMgc2hhcmUgYW5kDQo+IHZlcmlmaWVkIHRoYXQgSSBzdGlsbCBzZWUg
dGhlIHNhbWUgaXNzdWUuIFNvIGl0IGlzIG5vdCBsb2FkaW5nIHRoZQ0KPiBtb2R1bGVzIHRoYXQg
aXMgYSBwcm9ibGVtLg0KDQpXZWxsLCBJIG1lYW50IHRoYXQgbG9hZGluZyBtb2R1bGVzIGNhbiBi
ZSBhbiBpc3N1ZSBidXQgdGhhdCdzIG5vdCB0aGUgDQp3YXkgdG8gdmVyaWZ5IHRoYXQuDQoNCllv
dSBuZWVkIHRvIGhhdmUgYWxsIG1vZHVsZXMgYnVpbHQtaW4gc28gdGhhdCBpdCBwcm92ZXMgdGhh
dCBubyBtb2R1bGUgDQp3aWxsIHRyeSB0byBiZSBsb2FkZWQuDQoNCkFueXdheSwgdGhpcyBpcyBw
cm9iYWJseSBub3QgdGhlIGNhdXNlIGFzIHlvdSB3b3VsZG4ndCBldmVuIGJlIGFibGUgdG8gDQpj
b21waWxlIGtlcm5lbCBpZiB5b3UgbmVlZCBhIHN5bWJvbCBmcm9tIGEgbW9kdWxlIHdpdGggc3Rt
bWFjIGJ1aWx0LWluLiANCktjb25maWcgd291bGQgY29tcGxhaW4gYWJvdXQgdGhhdC4NCg0KVGhl
IG90aGVyIGNhdXNlIGNvdWxkIGJlIGRhdGEgY29ycnVwdGlvbiBpbiB0aGUgUlggcGF0aC4gQXJl
IHlvdSBhYmxlIHRvIA0Kc2VuZCBtZSBwYWNrZXQgZHVtcCBieSBydW5uaW5nIHdpcmVzaGFyayBl
aXRoZXIgaW4gdGhlIHRyYW5zbWl0dGVyIHNpZGUgDQooaS5lLiBORlMgc2VydmVyKSwgb3IgdXNp
bmcgc29tZSBraW5kIG9mIHN3aXRjaCA/DQoNCi0tLQ0KVGhhbmtzLA0KSm9zZSBNaWd1ZWwgQWJy
ZXUNCg==
