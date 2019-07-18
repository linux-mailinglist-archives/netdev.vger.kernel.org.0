Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 817266C9F4
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 09:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbfGRHad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 03:30:33 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:33330 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726304AbfGRHac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 03:30:32 -0400
Received: from mailhost.synopsys.com (dc8-mailhost2.synopsys.com [10.13.135.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 496A1C2967;
        Thu, 18 Jul 2019 07:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1563435031; bh=wi3lbCFurWzNllCa1BfsB65zzLLkVvSCZbPfv/dPEsM=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=VRUxJVZ/Ql90IIPd5yzyp496IXiUKTYdHXnxi3XQNm6w8IAqnolbXvH+5q70s3Zld
         6vlygFQ459cka6ZR18RSIYACoEgRoI75wDk1hXi49TG0hTWqdpoMQ6x6d9jy4uoQK7
         8TA3FRYT2manlySf6Ajfvm4PrR3ENf9RVlAzeToa8VUEop8B6cBP+5BCCe5zfLm7aI
         dBeL1vcdrBHqP6lAS5a+V+QTBGR2JxPd+cgrFj75bxLKASRkG5eszgKsgzV/EQuw8n
         FLDqaVX/SrTN/kmvE1mUoTlJUu5nfvOS3eGODZWyd3GWg0CA/cHvyOTUmlFelsOGms
         k9D5l3L9ZGLDg==
Received: from us01wehtc1.internal.synopsys.com (us01wehtc1-vip.internal.synopsys.com [10.12.239.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id A6FE0A0067;
        Thu, 18 Jul 2019 07:30:14 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 us01wehtc1.internal.synopsys.com (10.12.239.231) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 18 Jul 2019 00:29:53 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Thu, 18 Jul 2019 00:29:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L6LFzSNTAljBwh+svyvpYFeRruDHEcrD0gTquyNV8YR2NyO907iUwl5mXAAydScFVV49cNc2ZQOn2xBLoQQSpaoVHXMwI4aOy55nAo/sMAfI+dMQktydaPAMuCmrwWlXBlQ2BvFMQ6tCJMOWhyedBOog5s8p1h1sSeFqneICyqujn9RkeJV/tJtT6Gc23SNbvStqrlsOjxwttPHj/gsT4Gne+Kiu1vktsAt1k26kMW8XUT7Ne90Ai0snJqub5QGkme2eRB3kblT4SHkhB84q/pelcV2HVbQ/2BdceSf+UdyiRUNWor4yhpKnwTpEXpXW+MPDg5v/xyRTr4NCOWKfew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wi3lbCFurWzNllCa1BfsB65zzLLkVvSCZbPfv/dPEsM=;
 b=O1Bgx62AZTIKJl4V0cyAryHAGha51C1itCcEK1pKG6L8/KBV9PmKw4kXyhmC+5udDYCgefGLcW4fQmM8A8wxY0StK5NPN+VFH6K4hLvGX2+vOgPqRvf4zs7aOMUGBIYS4QWqlMSn8wQk0LZZilNUtygF0LpO44DIWqldL219hMW53cCjxaenJpMR9l6ivVx4ByjhszYfoW3Eb/Aj4Qf/V9Bby5hLsOy3iwWexoXg9IGrPMb544eHhUthg3xKwumv8dnWGcTVMAA1liMTHenfHFq0BAFPiXCLjhf4iWtB9ai3kgOiEDVWo8uxZoiRd5FJ7p1ERE7k2G9rUEmMf3U/Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=synopsys.com;dmarc=pass action=none
 header.from=synopsys.com;dkim=pass header.d=synopsys.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wi3lbCFurWzNllCa1BfsB65zzLLkVvSCZbPfv/dPEsM=;
 b=WX6Z740hX39PnryaEh3UwALDIfosigkP0xIc7l2RXc90bP9YHzoTmAo5XkqegOR1zVKuhtX2W47JYgwbzo+24KTHGH7Lz2kBsy6Yh+JeA8J6c3LKnUrJoS8tFIso0lvYKpbhE+JgcSoIJARkOyCps4bTayxf+mcBjl55PpZXPb4=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.66.159) by
 BN8PR12MB3364.namprd12.prod.outlook.com (20.178.211.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.12; Thu, 18 Jul 2019 07:29:49 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::61ef:5598:59e0:fc9d]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::61ef:5598:59e0:fc9d%5]) with mapi id 15.20.2073.012; Thu, 18 Jul 2019
 07:29:49 +0000
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
Thread-Index: AQHVMYtq2Zx4WVoG/U2kL8GCK0bP/abPQEOAgADRbnA=
Date:   Thu, 18 Jul 2019 07:29:49 +0000
Message-ID: <BN8PR12MB3266311B8D76DABE8448E3E3D3C80@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <cover.1562149883.git.joabreu@synopsys.com>
 <1b254bb7fc6044c5e6e2fdd9e00088d1d13a808b.1562149883.git.joabreu@synopsys.com>
 <29dcc161-f7c8-026e-c3cc-5adb04df128c@nvidia.com>
In-Reply-To: <29dcc161-f7c8-026e-c3cc-5adb04df128c@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fc230020-b5b4-4d5c-4a6c-08d70b51b76f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR12MB3364;
x-ms-traffictypediagnostic: BN8PR12MB3364:
x-microsoft-antispam-prvs: <BN8PR12MB3364C246A25174B24636121CD3C80@BN8PR12MB3364.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1091;
x-forefront-prvs: 01026E1310
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(346002)(39860400002)(366004)(376002)(199004)(189003)(316002)(55016002)(9686003)(4326008)(2906002)(3846002)(5660300002)(52536014)(6246003)(6116002)(486006)(305945005)(66066001)(446003)(53936002)(11346002)(99286004)(229853002)(6436002)(2201001)(54906003)(110136005)(66476007)(71200400001)(71190400001)(66446008)(64756008)(66946007)(66556008)(7416002)(7696005)(76116006)(68736007)(8676002)(76176011)(186003)(86362001)(26005)(256004)(8936002)(81156014)(7736002)(476003)(2501003)(74316002)(81166006)(14454004)(25786009)(6506007)(14444005)(478600001)(33656002)(102836004);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3364;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: tsvOF5zZoAV0KWydtKBrDCH2COPGDLauOQwdoJeVZWtpOlDwonT3R5dpHexLKl3hPjUHteJtkOP2gBLINa3Ps5LNWRlUTNX8AZqbCFUSsUngJGg7LTmNawrArwJzOIQTNnhadkv7T8wEAFwrJsHkiVWS7AdxW3l7TO/clCPrEW2cMhIFtBRWt3Hfqnb/MbL2ln38w+FeWc2jIpwh1lNa1SUfsjhCD0gPfdcVDK1GjgFOB5+fAQ2jbLWP0rh8XoTKKAo+Z8gZQN8dNpA+H1plcSYpvkbX+SFV/sMttEyERYogIP4/2RNakdeQtcRGRMqETsJeUzUquiVJqWW5VjDMZcbyQNaTyiEfhaFCWOMNxlTTH5Ubrf1OapiRZ2H5+jbw3150o+oihjy5Eey9ge7eRBl+HfvbXjD4yhTTSTquhzE=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: fc230020-b5b4-4d5c-4a6c-08d70b51b76f
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2019 07:29:49.2376
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: joabreu@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3364
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSm9uIEh1bnRlciA8am9uYXRoYW5oQG52aWRpYS5jb20+DQpEYXRlOiBKdWwvMTcvMjAx
OSwgMTk6NTg6NTMgKFVUQyswMDowMCkNCg0KPiBJIGFtIHNlZWluZyBhIGJvb3QgcmVncmVzc2lv
biBvbiBvbmUgb2Ygb3VyIFRlZ3JhIGJvYXJkcyB3aXRoIGJvdGgNCj4gbWFpbmxpbmUgYW5kIC1u
ZXh0LiBCaXNlY3RpbmcgaXMgcG9pbnRpbmcgdG8gdGhpcyBjb21taXQgYW5kIHJldmVydGluZw0K
PiB0aGlzIGNvbW1pdCBvbiB0b3Agb2YgbWFpbmxpbmUgZml4ZXMgdGhlIHByb2JsZW0uIFVuZm9y
dHVuYXRlbHksIHRoZXJlDQo+IGlzIG5vdCBtdWNoIG9mIGEgYmFja3RyYWNlIGJ1dCB3aGF0IEkg
aGF2ZSBjYXB0dXJlZCBpcyBiZWxvdy4gDQo+IA0KPiBQbGVhc2Ugbm90ZSB0aGF0IHRoaXMgaXMg
c2VlbiBvbiBhIHN5c3RlbSB0aGF0IGlzIHVzaW5nIE5GUyB0byBtb3VudA0KPiB0aGUgcm9vdGZz
IGFuZCB0aGUgY3Jhc2ggb2NjdXJzIHJpZ2h0IGFyb3VuZCB0aGUgcG9pbnQgdGhlIHJvb3RmcyBp
cw0KPiBtb3VudGVkLg0KPiANCj4gTGV0IG1lIGtub3cgaWYgeW91IGhhdmUgYW55IHRob3VnaHRz
Lg0KPiANCj4gQ2hlZXJzDQo+IEpvbiANCj4gDQo+IFsgICAxMi4yMjE4NDNdIEtlcm5lbCBwYW5p
YyAtIG5vdCBzeW5jaW5nOiBBdHRlbXB0ZWQgdG8ga2lsbCBpbml0ISBleGl0Y29kZT0weDAwMDAw
MDBiDQo+IFsgICAxMi4yMjk0ODVdIENQVTogNSBQSUQ6IDEgQ29tbTogaW5pdCBUYWludGVkOiBH
IFMgICAgICAgICAgICAgICAgNS4yLjAtMTE1MDAtZzkxNmY1NjJmYjI4YSAjMTgNCj4gWyAgIDEy
LjIzODA3Nl0gSGFyZHdhcmUgbmFtZTogTlZJRElBIFRlZ3JhMTg2IFAyNzcxLTAwMDAgRGV2ZWxv
cG1lbnQgQm9hcmQgKERUKQ0KPiBbICAgMTIuMjQ1MTA1XSBDYWxsIHRyYWNlOg0KPiBbICAgMTIu
MjQ3NTQ4XSAgZHVtcF9iYWNrdHJhY2UrMHgwLzB4MTUwDQo+IFsgICAxMi4yNTExOTldICBzaG93
X3N0YWNrKzB4MTQvMHgyMA0KPiBbICAgMTIuMjU0NTA1XSAgZHVtcF9zdGFjaysweDljLzB4YzQN
Cj4gWyAgIDEyLjI1NzgwOV0gIHBhbmljKzB4MTNjLzB4MzJjDQo+IFsgICAxMi4yNjA4NTNdICBj
b21wbGV0ZV9hbmRfZXhpdCsweDAvMHgyMA0KPiBbICAgMTIuMjY0Njc2XSAgZG9fZ3JvdXBfZXhp
dCsweDM0LzB4OTgNCj4gWyAgIDEyLjI2ODI0MV0gIGdldF9zaWduYWwrMHgxMDQvMHg2NjgNCj4g
WyAgIDEyLjI3MTcxOF0gIGRvX25vdGlmeV9yZXN1bWUrMHgyYWMvMHgzODANCj4gWyAgIDEyLjI3
NTcxNl0gIHdvcmtfcGVuZGluZysweDgvMHgxMA0KPiBbICAgMTIuMjc5MTA5XSBTTVA6IHN0b3Bw
aW5nIHNlY29uZGFyeSBDUFVzDQo+IFsgICAxMi4yODMwMjVdIEtlcm5lbCBPZmZzZXQ6IGRpc2Fi
bGVkDQo+IFsgICAxMi4yODY1MDJdIENQVSBmZWF0dXJlczogMHgwMDAyLDIwODA2MDAwDQo+IFsg
ICAxMi4yOTA0OTldIE1lbW9yeSBMaW1pdDogbm9uZQ0KPiBbICAgMTIuMjkzNTQ4XSAtLS1bIGVu
ZCBLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzogQXR0ZW1wdGVkIHRvIGtpbGwgaW5pdCEgZXhp
dGNvZGU9MHgwMDAwMDAwYiBdLS0tDQo+IA0KPiAtLSANCj4gbnZwdWJsaWMNCg0KWW91IGRvbid0
IGhhdmUgYW55IG1vcmUgZGF0YSA/IENhbiB5b3UgYWN0aXZhdGUgRE1BLUFQSSBkZWJ1ZyBhbmQg
Y2hlY2sgDQppZiB0aGVyZSBpcyBhbnkgbW9yZSBpbmZvIG91dHB1dHRlZCA/DQoNCi0tLQ0KVGhh
bmtzLA0KSm9zZSBNaWd1ZWwgQWJyZXUNCg==
