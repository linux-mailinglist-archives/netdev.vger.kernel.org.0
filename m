Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB73715B1
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 12:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732933AbfGWKH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 06:07:57 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:53510 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729973AbfGWKH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 06:07:56 -0400
Received: from mailhost.synopsys.com (dc8-mailhost1.synopsys.com [10.13.135.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id C1DC3C01CB;
        Tue, 23 Jul 2019 10:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1563876475; bh=B/FukePsT/8RmZAE8slOAobauCkkf2mTKzNmN8T/ULo=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=hTcA4jwLSPayknpmXA5HnPkNUvWPFITiu0m2mIFt8Rk2a4Awgx2i4AyBpu8tl8wC4
         GpEc6y7EgIPuPpTHfc84nYfEWiU2QRhZqr3hWgOgLvnfch78ExROcFxX4bfNbjP0bg
         tpDuBRtWuhbm6r3j6sani8hEjGmj0Yapprsd7z7W0h6AIp1XWBH4dUsSc+oqa/oGQj
         GJ7c713Iy4P2q1bbqxtHS3i1U9zil9Kdz4bNUtwGT1COn02xSMPdfRf9fbgewULtgN
         QAFL8aP1SyMmjQXHvm3718ItImFL2XvQG4QFgr6aqFx4od1dgp0h2HHHLFzTuyCLHm
         qkraSfFZk0qaw==
Received: from US01WXQAHTC1.internal.synopsys.com (us01wxqahtc1.internal.synopsys.com [10.12.238.230])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 8F8C6A006A;
        Tue, 23 Jul 2019 10:07:53 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WXQAHTC1.internal.synopsys.com (10.12.238.230) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 23 Jul 2019 03:07:53 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Tue, 23 Jul 2019 03:07:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V5pAsBHQNpr+rg+hsY2y44lwCJmyOAWUG9Duqe+3RvObE9/vyyxv+kQ+v1nPCi7MFkKwzu2ixsFPSaE9RkAQ1tcVcGqvE/ZCAcfXELgA5IrO8zt0LR0GV1qVAm4zG7NYYfzCsa+ay6K3s2V+udfRtzoOV4sxAsKoqMrrqovIHmCNYMdenEkI9BX4T86MC6V1cgJ0rFYu36J+J0HW8Z+p9bG4TxpjyzNGq2uYY9z7yyVg9Tlj5xNCMhdccGAARs6qxGVMR3SGU2lbUMGpHCRernD094PaZZgOpU9C93fN9i4HVRbZZ/CHTs7tYdfxjMOCSZhAs6MiBU69hHhW35H6zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B/FukePsT/8RmZAE8slOAobauCkkf2mTKzNmN8T/ULo=;
 b=R4lmfkcLMXkKLIDe2Fs2Cmg7zCgYglVN8+3TYSd/N//cVpx8Hkma9cliEwj6e6g7qD3Cbj4lZo4qY0Fhd8jGzrxsxKMwjqeRV6HosQ/76xF0kDOAuvwgQF8SLfHqTKbzEGCXs4SyzutuSrdJUVo+tsmn+LVcEQBart5CGTcqgxfkSBGvIIg8SUp2J5+tz6ksIEowPQyyOQBcHHycsHd0TGbORhGwL4j4r+NpjUcxIoSKkMqn0wDTLjTbxrhCXrlWCvrWZ5uYAiQP65VWORPTQFmnEqpXil1IgCmUSGL8Q/oZB6OsoxSCY4TZXOYbRc7+m8H+VM3iGH1DhGZKKHYkEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=synopsys.com;dmarc=pass action=none
 header.from=synopsys.com;dkim=pass header.d=synopsys.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B/FukePsT/8RmZAE8slOAobauCkkf2mTKzNmN8T/ULo=;
 b=vuC6r2b1s/q5QwMydOlzPCfTGDId/xZcuMKONZunMwnb1W79WCTKYhJlOvcrAVelJ45WnImrCfFlrW/6fNxD8fywmUsvBUr/Fh+MjF2VtEkqc/u3++LOa9mqOPk2K4W816w4tuu+OdGOMekpapE0Usar5W32cAfTBoWECGHYCP8=
Received: from BYAPR12MB3269.namprd12.prod.outlook.com (20.179.93.146) by
 BYAPR12MB2693.namprd12.prod.outlook.com (20.176.255.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.15; Tue, 23 Jul 2019 10:07:51 +0000
Received: from BYAPR12MB3269.namprd12.prod.outlook.com
 ([fe80::f5b8:ac6e:ea68:cb1c]) by BYAPR12MB3269.namprd12.prod.outlook.com
 ([fe80::f5b8:ac6e:ea68:cb1c%4]) with mapi id 15.20.2094.013; Tue, 23 Jul 2019
 10:07:51 +0000
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
Thread-Index: AQHVMYtq2Zx4WVoG/U2kL8GCK0bP/abPQEOAgADTx+CABnZ9AIAADuYAgAAFQOCAAAnIAIAABLTAgAFMy7CAAB4gAIAAAO7w
Date:   Tue, 23 Jul 2019 10:07:51 +0000
Message-ID: <BYAPR12MB32692AF2BA127C5DA5B74804D3C70@BYAPR12MB3269.namprd12.prod.outlook.com>
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
In-Reply-To: <ab14f31f-2045-b1be-d31f-2a81b8527dac@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3e33fc0f-2178-49fe-7b7f-08d70f559f36
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR12MB2693;
x-ms-traffictypediagnostic: BYAPR12MB2693:
x-microsoft-antispam-prvs: <BYAPR12MB269332C6AB7724A944A95D61D3C70@BYAPR12MB2693.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(376002)(396003)(136003)(346002)(199004)(189003)(446003)(4744005)(54906003)(81166006)(102836004)(14454004)(2906002)(99286004)(11346002)(76176011)(8676002)(68736007)(7696005)(316002)(186003)(476003)(81156014)(6116002)(3846002)(8936002)(33656002)(26005)(6506007)(71200400001)(71190400001)(110136005)(9686003)(229853002)(6246003)(55016002)(53936002)(76116006)(66066001)(66946007)(66476007)(64756008)(66556008)(5660300002)(66446008)(478600001)(4326008)(256004)(52536014)(86362001)(6436002)(486006)(7416002)(7736002)(25786009)(74316002)(305945005);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR12MB2693;H:BYAPR12MB3269.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Dj0EqqP9oB1l2vRzu3uln+wkq5zVtDcPDyl1BvYOnJZjR+23RUDPjYcTlGWv6LJ5PSMz0ifnvyA4SshvnyA9/XXuW4pxRz9q7OJ1mNgPT7qRsuJtyH1GB+8lhwpXO69ImIxIJIVJ52f7Ss0I1djVR7N6Q74ER86UXry8kjYgVM5JBcQJc1DNmJh0HS+SwPAzCKq+9bvTk9VtCQJXvhMPvFE1MQOmza3fmGerh6u8gDmiIUOAjPayfsYsg38R1kafTKkGaHs5UoxwLzJYbmkRhg2hIiqIRWpwNAk7rzth1fYH8EUGmA/tAhk/yKRC+Lhsj+420bTb3aprsW6p/2ujeDv+rUZFqYp7Zy4DP+PQY7DaFUFfaDRHGr2hRZHTT/hv6M4lDy0mQU+X85lyMRutD0/LP8nd62U7fgDmF/Z64xA=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e33fc0f-2178-49fe-7b7f-08d70f559f36
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 10:07:51.3159
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: joabreu@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2693
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSm9uIEh1bnRlciA8am9uYXRoYW5oQG52aWRpYS5jb20+DQpEYXRlOiBKdWwvMjMvMjAx
OSwgMTE6MDE6MjQgKFVUQyswMDowMCkNCg0KPiBUaGlzIGFwcGVhcnMgdG8gYmUgYSB3aW5uZXIg
YW5kIGJ5IGRpc2FibGluZyB0aGUgU01NVSBmb3IgdGhlIGV0aGVybmV0DQo+IGNvbnRyb2xsZXIg
YW5kIHJldmVydGluZyBjb21taXQgOTU0YTAzYmUwMzNjN2NlZjgwZGRjMjMyZTdjYmRiMTdkZjcz
NTY2Mw0KPiB0aGlzIHdvcmtlZCEgU28geWVzIGFwcGVhcnMgdG8gYmUgcmVsYXRlZCB0byB0aGUg
U01NVSBiZWluZyBlbmFibGVkLiBXZQ0KPiBoYWQgdG8gZW5hYmxlIHRoZSBTTU1VIGZvciBldGhl
cm5ldCByZWNlbnRseSBkdWUgdG8gY29tbWl0DQo+IDk1NGEwM2JlMDMzYzdjZWY4MGRkYzIzMmU3
Y2JkYjE3ZGY3MzU2NjMuDQoNCkZpbmFsbHkgOikNCg0KSG93ZXZlciwgZnJvbSAiZ2l0IHNob3cg
OTU0YTAzYmUwMzNjN2NlZjgwZGRjMjMyZTdjYmRiMTdkZjczNTY2MyI6DQoNCisgICAgICAgICBU
aGVyZSBhcmUgZmV3IHJlYXNvbnMgdG8gYWxsb3cgdW5tYXRjaGVkIHN0cmVhbSBieXBhc3MsIGFu
ZA0KKyAgICAgICAgIGV2ZW4gZmV3ZXIgZ29vZCBvbmVzLiAgSWYgc2F5aW5nIFlFUyBoZXJlIGJy
ZWFrcyB5b3VyIGJvYXJkDQorICAgICAgICAgeW91IHNob3VsZCB3b3JrIG9uIGZpeGluZyB5b3Vy
IGJvYXJkLg0KDQpTbywgaG93IGNhbiB3ZSBmaXggdGhpcyA/IElzIHlvdXIgZXRoZXJuZXQgRFQg
bm9kZSBtYXJrZWQgYXMgDQoiZG1hLWNvaGVyZW50OyIgPw0KDQotLS0NClRoYW5rcywNCkpvc2Ug
TWlndWVsIEFicmV1DQo=
