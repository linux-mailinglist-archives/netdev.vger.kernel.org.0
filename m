Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48243701DD
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 16:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730701AbfGVOE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 10:04:57 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:60270 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728637AbfGVOEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 10:04:55 -0400
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 997B6C0A8A;
        Mon, 22 Jul 2019 14:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1563804294; bh=6SshQAV11Iu3QdhIPa1HwhiRSC4UC02at29tT2+52jg=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=Sv110pmicouavIAZUjJIaVeQoWWC5ASgoFwBTw2oUjFrKGs7D9UdiI6FSBxFNebMN
         PeBvMWnaRvldMHoeBae3ouuiRy0G+KMAYpdkyvUHJVCKsmQ/x4ohOoa9mh+Q/MNnUG
         jJHb7hbzQkL7s5Hajf427QSns+ph2MCDNfcUCz4WPmXoL1453ewZLQlkkAsf8kK+hw
         3Za609X32+JSNxvXaCW29LJq2VVy/iXgh6zfLQ6SoG/lCHaCRRTHRv9ETctTOh1P5u
         5rsSPH31XZNxwBceb9aybznT7lLOu+adtFa9xDCvxYSGcQ3fRpXUkutHnvMM3O6wZz
         8Ba9SMPAsn23A==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id D55A8A0091;
        Mon, 22 Jul 2019 14:04:51 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 22 Jul 2019 07:04:51 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 22 Jul 2019 07:04:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HqoFRBNrhuz4pQB7doi5z0bg3N5Pv3WTwVOFkRX6uDVUar90/Fv3KbwpbftJwJ57B8sSQJ14AmVe+OVPjBboY/tIMREZYLVm2XMRUURD0TdVPJNSsPKsEMK06A8okDuCdeO88GjyzfJIEykw/U2cndmqdmn0G2w0QxCJQm9E1JjWVCdOIQMu3FGJvk0VQOXpRe2z/z/JRYpcsfvtTWLubgeF0wMqd61uCsg/FVo0rHB08zM8cify+MpXRzfv9LwOvO8a6YX2xE5JaqPPvkRIiX26pV5L08B/PgWVjQkUE69F4rUs58gqH3553Am6q2VpMSP2AO5cqpV8GktzU4KjVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6SshQAV11Iu3QdhIPa1HwhiRSC4UC02at29tT2+52jg=;
 b=DcPkRPpVN1+VwONl99fqV0gnTvSg2lZEe2PngsymtHM9cn1KOfSEvBjqI7Ets3ewqR011nR9rh1erGw+4tMW1UnYpUJr4r2ZFkep5aEMT5lLgkjlMbCITFUhhTYBh+QJ5NMLCeH5DK7447Tvl1sKQF9LooKIPcAo5N7UQS1fyF00LcnOxFUVVlEgu94Gr0gd6YXBQ/HTey7G0OKuHaz2amqgAEux5zwWxIDs2AHeC+rApQrB8qz2lgwfM2UB3od/ibVhVCFR2g06GTBltWlYYNKytGnjSm0CQh0HBRDnZQaHGYQmbJrfzo7HV3lR89UOuFyBbNz+DPk8ZKf1PhVdDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=synopsys.com;dmarc=pass action=none
 header.from=synopsys.com;dkim=pass header.d=synopsys.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6SshQAV11Iu3QdhIPa1HwhiRSC4UC02at29tT2+52jg=;
 b=DBhK9U55ri+atPPNYzVks2a7h5SKfJQ0XTc2H4izCW4BoTLo46FsVnGs51yC5Et4YL2+gswgurl+XTuXbqYIw1C2srv1uy6v1SDLNqGynSpLzQejzEOZWo5O1S6GsCKC8QnXqACitn/epuMyk96Bc3JMKriX4n8yoqFcuLP2f2A=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.66.159) by
 BN8PR12MB3122.namprd12.prod.outlook.com (20.178.210.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.17; Mon, 22 Jul 2019 14:04:49 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::61ef:5598:59e0:fc9d]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::61ef:5598:59e0:fc9d%5]) with mapi id 15.20.2094.013; Mon, 22 Jul 2019
 14:04:49 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Jon Hunter <jonathanh@nvidia.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Lars Persson <lists@bofh.nu>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
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
Thread-Index: AQHVMYtq2Zx4WVoG/U2kL8GCK0bP/abPQEOAgADTx+CABnZ9AIAADuYAgAAFQOCAAAnIAIAABLTA
Date:   Mon, 22 Jul 2019 14:04:49 +0000
Message-ID: <BN8PR12MB3266664ECA192E02C06061EED3C40@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <cover.1562149883.git.joabreu@synopsys.com>
 <1b254bb7fc6044c5e6e2fdd9e00088d1d13a808b.1562149883.git.joabreu@synopsys.com>
 <29dcc161-f7c8-026e-c3cc-5adb04df128c@nvidia.com>
 <BN8PR12MB32661E919A8DEBC7095BAA12D3C80@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190722101830.GA24948@apalos>
 <CADnJP=thexf2sWcVVOLWw14rpteEj0RrfDdY8ER90MpbNN4-oA@mail.gmail.com>
 <BN8PR12MB326661846D53AAEE315A7434D3C40@BN8PR12MB3266.namprd12.prod.outlook.com>
 <11557fe0-0cba-cb49-0fb6-ad24792d4a53@nvidia.com>
In-Reply-To: <11557fe0-0cba-cb49-0fb6-ad24792d4a53@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 45ba71a6-c102-4321-d9f1-08d70ead8f77
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BN8PR12MB3122;
x-ms-traffictypediagnostic: BN8PR12MB3122:
x-microsoft-antispam-prvs: <BN8PR12MB3122E8CFBA7CA98D07B89891D3C40@BN8PR12MB3122.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 01068D0A20
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(136003)(396003)(376002)(39860400002)(199004)(189003)(54906003)(8676002)(8936002)(81166006)(81156014)(110136005)(6436002)(99286004)(256004)(14444005)(5024004)(316002)(71200400001)(71190400001)(76176011)(53936002)(7696005)(33656002)(55016002)(478600001)(7416002)(25786009)(9686003)(66066001)(102836004)(14454004)(53546011)(11346002)(5660300002)(446003)(2906002)(66556008)(66446008)(76116006)(186003)(26005)(229853002)(68736007)(6506007)(66946007)(64756008)(66476007)(7736002)(6116002)(4326008)(52536014)(74316002)(305945005)(486006)(3846002)(476003)(6246003)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3122;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1BM5mmwA7lkdSNah+01UdI+N/idZv7In5dAzEuosJ4fw1qua7O7m+GQxqX22dnkDhJUGxOapH78MvMCE7cWmI5M36zhmFaxAsuQS0/weM3+ocJZ6zWoy6/vMveYPZ6DZJpyexgmI3EiUJPV/afcKEkyPJ0XxOP1S4kjaBDr5wmMDHP4rLu8zhZf8pY9Cz55rvxivzQF7OQ7tUYWjwRyitVm/6layEyyCa4lKz2jZLfAwPz8sb44UwQZFdAIhNli77cjSSOFjX1xCeXdM3BQgu4prPudmxLtsDG7U4ZzZJ65gLD16wp0jL1pIEMCIjRMvH0/2S1qRGQzudj2xgP/HiPTHfsb9m+fshoj6vwTmrASpvI/3+GFdhEtXP0aB1grMk4jRq8l3OSFQIMsBe26FSbyUGuaw8el00D8v+ef6R/k=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 45ba71a6-c102-4321-d9f1-08d70ead8f77
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2019 14:04:49.3882
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: joabreu@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3122
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSm9uIEh1bnRlciA8am9uYXRoYW5oQG52aWRpYS5jb20+DQpEYXRlOiBKdWwvMjIvMjAx
OSwgMTM6MDU6MzggKFVUQyswMDowMCkNCg0KPiANCj4gT24gMjIvMDcvMjAxOSAxMjozOSwgSm9z
ZSBBYnJldSB3cm90ZToNCj4gPiBGcm9tOiBMYXJzIFBlcnNzb24gPGxpc3RzQGJvZmgubnU+DQo+
ID4gRGF0ZTogSnVsLzIyLzIwMTksIDEyOjExOjUwIChVVEMrMDA6MDApDQo+ID4gDQo+ID4+IE9u
IE1vbiwgSnVsIDIyLCAyMDE5IGF0IDEyOjE4IFBNIElsaWFzIEFwYWxvZGltYXMNCj4gPj4gPGls
aWFzLmFwYWxvZGltYXNAbGluYXJvLm9yZz4gd3JvdGU6DQo+ID4+Pg0KPiA+Pj4gT24gVGh1LCBK
dWwgMTgsIDIwMTkgYXQgMDc6NDg6MDRBTSArMDAwMCwgSm9zZSBBYnJldSB3cm90ZToNCj4gPj4+
PiBGcm9tOiBKb24gSHVudGVyIDxqb25hdGhhbmhAbnZpZGlhLmNvbT4NCj4gPj4+PiBEYXRlOiBK
dWwvMTcvMjAxOSwgMTk6NTg6NTMgKFVUQyswMDowMCkNCj4gPj4+Pg0KPiA+Pj4+PiBMZXQgbWUg
a25vdyBpZiB5b3UgaGF2ZSBhbnkgdGhvdWdodHMuDQo+ID4+Pj4NCj4gPj4+PiBDYW4geW91IHRy
eSBhdHRhY2hlZCBwYXRjaCA/DQo+ID4+Pj4NCj4gPj4+DQo+ID4+PiBUaGUgbG9nIHNheXMgIHNv
bWVvbmUgY2FsbHMgcGFuaWMoKSByaWdodD8NCj4gPj4+IENhbiB3ZSB0cnllIGFuZCBmaWd1cmUg
d2VyZSB0aGF0IGhhcHBlbnMgZHVyaW5nIHRoZSBzdG1tYWMgaW5pdCBwaGFzZT8NCj4gPj4+DQo+
ID4+DQo+ID4+IFRoZSByZWFzb24gZm9yIHRoZSBwYW5pYyBpcyBoaWRkZW4gaW4gdGhpcyBvbmUg
bGluZSBvZiB0aGUga2VybmVsIGxvZ3M6DQo+ID4+IEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5n
OiBBdHRlbXB0ZWQgdG8ga2lsbCBpbml0ISBleGl0Y29kZT0weDAwMDAwMDBiDQo+ID4+DQo+ID4+
IFRoZSBpbml0IHByb2Nlc3MgaXMga2lsbGVkIGJ5IFNJR1NFR1YgKHNpZ25hbCAxMSA9IDB4Yiku
DQo+ID4+DQo+ID4+IEkgd291bGQgc3VnZ2VzdCB5b3UgbG9vayBmb3IgZGF0YSBjb3JydXB0aW9u
IGJ1Z3MgaW4gdGhlIFJYIHBhdGguIElmDQo+ID4+IHRoZSBjb2RlIGlzIGZldGNoZWQgZnJvbSB0
aGUgTkZTIG1vdW50IHRoZW4gYSBjb3JydXB0IFJYIGJ1ZmZlciBjYW4NCj4gPj4gdHJpZ2dlciBh
IGNyYXNoIGluIHVzZXJzcGFjZS4NCj4gPj4NCj4gPj4gL0xhcnMNCj4gPiANCj4gPiANCj4gPiBK
b24sIEknbSBub3QgZmFtaWxpYXIgd2l0aCBBUk0uIEFyZSB0aGUgYnVmZmVyIGFkZHJlc3NlcyBi
ZWluZyBhbGxvY2F0ZWQgDQo+ID4gaW4gYSBjb2hlcmVudCByZWdpb24gPyBDYW4geW91IHRyeSBh
dHRhY2hlZCBwYXRjaCB3aGljaCBhZGRzIGZ1bGwgbWVtb3J5IA0KPiA+IGJhcnJpZXIgYmVmb3Jl
IHRoZSBzeW5jID8NCj4gDQo+IFRCSCBJIGFtIG5vdCBzdXJlIGFib3V0IHRoZSBidWZmZXIgYWRk
cmVzc2VzIGVpdGhlci4gVGhlIGF0dGFjaGVkIHBhdGNoDQo+IGRpZCBub3QgaGVscC4gU2FtZSBw
cm9ibGVtIHBlcnNpc3RzLg0KDQpPSy4gSSdtIGp1c3QgZ3Vlc3Npbmcgbm93IGF0IHRoaXMgc3Rh
Z2UgYnV0IGNhbiB5b3UgZGlzYWJsZSBTTVAgPw0KDQpXZSBoYXZlIHRvIG5hcnJvdyBkb3duIGlm
IHRoaXMgaXMgY29oZXJlbmN5IGlzc3VlIGJ1dCB5b3Ugc2FpZCB0aGF0IA0KYm9vdGluZyB3aXRo
b3V0IE5GUyBhbmQgdGhlbiBtb3VudGluZyBtYW51YWxseSB0aGUgc2hhcmUgd29ya3MgLi4uIFNv
LCANCmNhbiB5b3Ugc2hhcmUgbG9ncyB3aXRoIHNhbWUgZGVidWcgcHJpbnRzIGluIHRoaXMgY29u
ZGl0aW9uIGluIG9yZGVyIHRvIA0KY29tcGFyZSA/DQoNCi0tLQ0KVGhhbmtzLA0KSm9zZSBNaWd1
ZWwgQWJyZXUNCg==
