Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80D0B12ADA0
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 18:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbfLZROi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 12:14:38 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:59892 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726480AbfLZROh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 12:14:37 -0500
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 14305C096E;
        Thu, 26 Dec 2019 17:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1577380476; bh=le4nA7EEjIQ/8dDjq/zddFgh/LFz5D/hv7vEtLT/MXQ=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=TDSn+jT+zVxCM459OfDnrzPiZ5IwRY6fWxTt6dN0z5FpDVFkS4IlEQ3m0AdGofa5P
         p+/VKKSxpiNcCsoSuXkpYhSspzJWNI9r5O5MFNDQyLBjouilfA3TS78vZXofn27EwL
         x8cdYlRso+Q5Ksb5Ddxffu/GRNnEkKGZADoTql6G0uXMKsVqfUxAw3cyUogajm1+Ia
         6CDBFjFd3B4zgZ29P8FB58BPXmK7Nd66AXYY7HLSKIBFMBBr90DRtvF9amfAg9CgIX
         /adpjQRskw6hMhQ0NsPzZ9TWdAmEAQqbScPR50CDPxLgi+k1q4HdO4NO0tk9f0JTtk
         y3x0PF2negbTQ==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id D288AA007E;
        Thu, 26 Dec 2019 17:14:33 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 26 Dec 2019 09:14:23 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Thu, 26 Dec 2019 09:14:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lf8pyPC+mugwc/qRwl7wrNhhuv/4pQu7J5XaYBgmes+kEacNFIIZXaUGlELcE0LvpVo+3yKvtTXsEGhHh1V8sQocPUvYUMAXIqftjm9tr94MnXMiFP7tFTmWb7COvNu1KZvHEv0CZ6iuHM5IS0sX81oC6UC6cfTdsWUUrG9K+Bt/3H+FzO3+YwEzPyLOFymXNNpWhDaeT49WNTjVtsGKszgkdmwD5G13CQiGfkwpKsqvNa3lEV2xqCZjr7JHg0qeXXDZy4vlhphMYx7paweRfbogVEEvG1YdjEnL9niT/4XKBqKGkgqRKPwiK6OVfeijLVbBLMEb3ZgbZlvuGA4HjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=le4nA7EEjIQ/8dDjq/zddFgh/LFz5D/hv7vEtLT/MXQ=;
 b=jQj0dyUgjEmz1ebiVb7tdifDFC4PuvSrLVjZhPS1pXk+YspwB26pDpAdRiRxI2/OaUl+Bdpoo95ydWGooDprvR2Q0pBqJWWQDDhfq2p8gJaVm2w/vpDXtdpCqXwYKZXptuN8LFXqXgC1WjtJxyheKY31Xb2RMjBYjfAzBoKek9cfsZFbhCJYisb0AzhTNHSXM1t2e+ZRd8uiriqjKCVDnBjPBJusNe5DWnh7wLNoBiWD/eoSGch8iLTTyi4MYdiOMKd3JVYzmArfPGpDuqCwJLjgwpvVpnMEYMxHU7JP1sU9UWfsy40XydKYWaEygXu8VM/Ve7IfKEzRm0V1Z7eJtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=le4nA7EEjIQ/8dDjq/zddFgh/LFz5D/hv7vEtLT/MXQ=;
 b=ZXNnWdDo+eu2qe9NLZyCVCYyLTWnX0gDf0wszsxtRrrTWQO6iaUcCKvNcjwU3oL2X+6Vh4oqSpQWgDu3H/PjKCsAoD6OG9ceaC8EnKdr+/evQp1Y/I76darmgFvqbLaIBJH30opwraIH5RAOrFZYSLKRvZC7IANdjYH2/WPc03Q=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3235.namprd12.prod.outlook.com (20.179.67.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.15; Thu, 26 Dec 2019 17:14:21 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::3d20:3a36:3b64:4510]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::3d20:3a36:3b64:4510%7]) with mapi id 15.20.2581.007; Thu, 26 Dec 2019
 17:14:21 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Colin Ian King <colin.king@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: net: stmmac: Add basic EST support for GMAC5+
Thread-Topic: net: stmmac: Add basic EST support for GMAC5+
Thread-Index: AQHVt5AvYOAfEKP32kajpx2asGgxD6fMsE8A
Date:   Thu, 26 Dec 2019 17:14:20 +0000
Message-ID: <BN8PR12MB326646266EF7CEA29685CF0AD32B0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <c1b6b4cc-bc94-8ed6-0098-de9e5321722a@canonical.com>
In-Reply-To: <c1b6b4cc-bc94-8ed6-0098-de9e5321722a@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [188.251.69.242]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: efe4d2ec-6943-4a75-631e-08d78a270c70
x-ms-traffictypediagnostic: BN8PR12MB3235:
x-microsoft-antispam-prvs: <BN8PR12MB32353C7D2F3A9FD4BC87C9FBD32B0@BN8PR12MB3235.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 02638D901B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(39860400002)(136003)(396003)(366004)(51914003)(189003)(199004)(71200400001)(316002)(86362001)(8676002)(110136005)(66946007)(76116006)(26005)(6506007)(8936002)(52536014)(33656002)(81156014)(81166006)(186003)(5660300002)(2906002)(9686003)(55016002)(64756008)(66476007)(66446008)(7696005)(66556008)(4326008)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3235;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ooaZTlnb5x4NdPu75Of9zALmdLfFosk6YoMv4zSS+OmKcNDX+R2YE0DiMNOv61zNmxgZUAYtHlgmZ+ASC+bhE3zax4gPD0MVGXPtyDRL9hjRt0KT0ZptXcYfVCG1phqK4dk1SIyzFKtFHT8ls28ACDuERWGE2N705RSISA+89J2GBChNCBQGAmKbuAknrwrr/bPr3P0ziXbXx3AscqVh/AzK/HrPi0KznnLdpUDJCMcVcK/Q5tl6TTEGd7Uq7XLFaXWqU4nFkoaDP6BliriO3XR1oZjjNbL1/rXjXlBGWUryuJRB81sIpyFIOZ5Mc12ExPHiymZjuwj5AlIIBLFnEwQMX2/qYpy/fPvPgUn8rJW8ux+d0Id4anJn+pmhG0D8xvF5+h8C4pMDzsE5setbEHoemkpL6ajuIaGPWDPwwit5JfGl7IQVHkccZs8ZJzLgJclghaP+4ttKcsog57C1J5yNo0106ZSGEi3kLuX/QaVFtqF5Wabw+hcUI4oqWtMn
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: efe4d2ec-6943-4a75-631e-08d78a270c70
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Dec 2019 17:14:21.0305
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RFZDm1voRoN4GsI3W0bWEdT9k6T3qyaDPJxtxaXB0GCH28xUAsFJ+rVkjj3V9ZpTJOoCAVwo2ctW7pC20ZXuTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3235
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQ29saW4gSWFuIEtpbmcgPGNvbGluLmtpbmdAY2Fub25pY2FsLmNvbT4NCkRhdGU6IERl
Yy8yMC8yMDE5LCAyMzo0OTowMiAoVVRDKzAwOjAwKQ0KDQo+IEhpLA0KPiANCj4gU3RhdGljIGFu
YWx5c2lzIHdpdGggQ292ZXJpdHkgaGFzIGRldGVjdGVkIGEgcG90ZW50aWFsIGlzc3VlIHdpdGgg
dGhlDQo+IGZvbGxvd2luZyBjb21taXQ6DQo+IA0KPiBjb21taXQgNTA0NzIzYWYwZDg1NDM0YmU1
ZmI2ZjJkZGUwYjYyNjQ0YTdmMWVhZA0KPiBBdXRob3I6IEpvc2UgQWJyZXUgPGpvYWJyZXVAc3lu
b3BzeXMuY29tPg0KPiBEYXRlOiAgIFdlZCBEZWMgMTggMTE6MzM6MDUgMjAxOSArMDEwMA0KPiAN
Cj4gICAgIG5ldDogc3RtbWFjOiBBZGQgYmFzaWMgRVNUIHN1cHBvcnQgZm9yIEdNQUM1Kw0KPiAN
Cj4gDQo+IEluIGZ1bmN0aW9uIGR3bWFjNV9lc3RfY29uZmlndXJlKCkgd2UgaGF2ZSBhIHU2NCB0
b3RhbF9jdHIgYmVpbmcNCj4gYXNzaWduZWQgYXMgZm9sbG93czoNCj4gDQo+IAl0b3RhbF9jdHIg
PSBjZmctPmN0clswXSArIGNmZy0+Y3RyWzFdICogMTAwMDAwMDAwMDsNCj4gDQo+IFRoZSBjZmct
PmN0clsxXSBpcyBhIHUzMiwgdGhlIG11bHRpcGxpY2F0aW9uIG9mIGNmZy0+Y3RyWzFdIGlzIGEg
dTMyDQo+IG11bHRpcGxpY2F0aW9uIG9wZXJhdGlvbiwgc28gbXVsdGlwbHlpbmcgYnkgMTAwMDAw
MDAwMCBjYW4gcG90ZW50aWFsbHkNCj4gY2F1c2UgYW4gb3ZlcmZsb3cuICBFaXRoZXIgY2ZnLT5j
dHJbMV0gbmVlZHMgdG8gYmUgY2FzdCB0byBhIHU2NCBvcg0KPiAxMDAwMDAwMDAwIHNob3VsZCBi
ZSBhdCBsZWFzdCBhIDEwMDAwMDAwMDBVTCB0byBhdm9pZCB0aGlzIG92ZXJmbG93LiBJDQo+IHdh
cyBnb2luZyB0byBmaXggdGhpcyBidXQgb24gZnVydGhlciBpbnNwZWN0aW9uIEkgd2FzIG5vdCBz
dXJlIGlmIHRoZQ0KPiBvcmlnaW5hbCBjb2RlIHdhcyBpbnRlbmRlZCBhczoNCj4gDQo+IAl0b3Rh
bF9jdHIgPSBjZmctPmN0clswXSArIGNmZy0+Y3RyWzFdICogMTAwMDAwMDAwMFVMOw0KPiBvcjoN
Cj4gCXRvdGFsX2N0ciA9IChjZmctPmN0clswXSArIGNmZy0+Y3RyWzFdKSAqIDEwMDAwMDAwMDBV
TDsNCj4gDQo+IC4uaGVuY2UgSSdtIGZsYWdnaW5nIHRoaXMgdXAgYXMgcG90ZW50aWFsIGVycm9y
Lg0KDQpUaGFua3MgZm9yIHRoZSByZXBvcnQuIFRoZSBmaXJzdCBvcHRpb24gaXMgdGhlIGNvcnJl
Y3Qgb25lIGFzIGN0clsxXSBpcyANCnNlY29uZHMgYW5kIGN0clswXSBpcyBuYW5vc2Vjb25kcy4g
Q2FuIHlvdSBzZW5kIGEgZml4LXVwIHBhdGNoID8NCg0KLS0tDQpUaGFua3MsDQpKb3NlIE1pZ3Vl
bCBBYnJldQ0K
