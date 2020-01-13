Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B66D139443
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 16:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728900AbgAMPFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 10:05:51 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:33600 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726399AbgAMPFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 10:05:50 -0500
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 2A468C05D4;
        Mon, 13 Jan 2020 15:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1578927949; bh=EXRTjK2fkDHTZIWU02AU+myEJpSP+8P8fNFbCIfAr0M=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=T/AlMzOAYnqv8A9/k0geKwRvR/ojAxN9qxbA1w9+saGHtf90vtXjtRDBYUgJ0AgR6
         zhjZyWcDebk3lDve2Dxos4zy16MiQ3/Vdyn06SLpwMddpB5883A6rqGxWzRg0E/NeX
         +NA/2VzOGT4xM6tdBvC/hFfe9+ksjCXBfolVqJezdGIW8LyeGQpYj9tKX7ipURr5i4
         KTaCa+ScSH2d8WMhHjhiGbiysdCaqbrqA0kvAQhpOF5DSCaVUUeQkPF7amFZUe465C
         IdyqFD7jAPI3lSbvUunlOCjAVyn/vodNFJjJGdKUWX6s9kt92rK6+7CeL6bY9+igGn
         LehWSQqyOArAg==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 4F160A0069;
        Mon, 13 Jan 2020 15:05:48 +0000 (UTC)
Received: from us01hybrid1.internal.synopsys.com (10.200.27.51) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 13 Jan 2020 07:05:48 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.200.27.51) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 13 Jan 2020 07:05:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eaPsFTya9RQvacqtksWv14uPX8dYT8bFc8BWRhofYeuDmOdRkXUKgVdh0Sm5sWSj3fqw/wPlHPBEdrftE1w3Z2B603uWDbVBIQG/tmsiFZX9YsbrhSxYZn2xlsxbojUYTkXbkuB5ExK8JYjEBXTIu2WctRZdGeSXsa1cp2dKrEO5b/LXsTnOuOi4Npm61PQ/X6LJ6Q0lU/1ZX3+j88ImL4Exc022TslU22pQn+HKBQCjTA8QB8K5TyZ9t/Dy2CvlsraCyGuAj4NJrXMW3fdRTPQ99BKAzuU67X1PkjYYt3mBe54zXKDLGc8lo534BfCqysrlIOW+j+XeWESpl32Y8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EXRTjK2fkDHTZIWU02AU+myEJpSP+8P8fNFbCIfAr0M=;
 b=dKUWVrdB+gRQeUqbaW2KwMq5CL6bJr2053Sis/XsPxpWVxPczEBeQtzkzcOBGStdiCZipVjYYhJA8NQlJYs66vl0Lvt4IyDkZQIYtmYFLCCp+tPUuym63RUWd3+Xl+IPdzbRaxpdU0zkRIwNrjsnpIQp2OkD2UY9IMa63ziGq2xf5jEut8aQOLM+QF+k8YedClmtzZ0GWePMdeukn199+ZGku1DpIb55Xbb8DV4u9byyocJj1ZchE0NYgogz31sat9MITsdqPTCNDxPM+4vEutA9VIbTwxmdMEAGpkV0/zR4CmBcsMMy/CuOcfZxtGi5gm90dloS0+IgpamKWCG7pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EXRTjK2fkDHTZIWU02AU+myEJpSP+8P8fNFbCIfAr0M=;
 b=iKVPU3hHAR96Su+6N+5SpbSPnSRv854pAtQsTB9qDTWZSuTmeoc4DxogRnogLl3KGSFRViD1uwSH2eUe4PoXwaehyYVD4tPTKwd7tghngQOrK91c9FNCwvUV43A6Zvx26XaJKhe4oZQpTNJh+h0CK2KjuIt/jIiRt1aKTjh01R0=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3233.namprd12.prod.outlook.com (20.179.65.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.11; Mon, 13 Jan 2020 15:05:46 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2%6]) with mapi id 15.20.2623.015; Mon, 13 Jan 2020
 15:05:46 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Joao Pinto" <Joao.Pinto@synopsys.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC net-next] net: phy: Add basic support for Synopsys XPCS
 using a PHY driver
Thread-Topic: [RFC net-next] net: phy: Add basic support for Synopsys XPCS
 using a PHY driver
Thread-Index: AQHVyhMHPh1TkUf6pU+JUVzLFdFzk6fomWeAgAAAjSCAAAp/gIAAAN2wgAAJooCAAAH8EA==
Date:   Mon, 13 Jan 2020 15:05:46 +0000
Message-ID: <BN8PR12MB32660970D0294CCEE7B16B53D3350@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <4953fc69a26bee930bccdeb612f1ce740a4294df.1578921062.git.Jose.Abreu@synopsys.com>
 <20200113133845.GD11788@lunn.ch>
 <BN8PR12MB32666F34D45D7881BDD4CAB3D3350@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200113141817.GN25745@shell.armlinux.org.uk>
 <BN8PR12MB326690820A7619664F7CC257D3350@BN8PR12MB3266.namprd12.prod.outlook.com>
 <CA+h21hpsauapCGEHqVqHpEU2K-VsAh3vKBRJ_N8iq2i35SedOw@mail.gmail.com>
In-Reply-To: <CA+h21hpsauapCGEHqVqHpEU2K-VsAh3vKBRJ_N8iq2i35SedOw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bd657282-1061-4c10-7d1f-08d7983a119b
x-ms-traffictypediagnostic: BN8PR12MB3233:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB3233D90D5FA442E251F1842FD3350@BN8PR12MB3233.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 028166BF91
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(366004)(346002)(376002)(39860400002)(189003)(199004)(52536014)(81166006)(6916009)(4326008)(66446008)(4744005)(66556008)(64756008)(66476007)(66946007)(71200400001)(76116006)(81156014)(55016002)(9686003)(2906002)(26005)(54906003)(6506007)(8936002)(186003)(7696005)(478600001)(86362001)(8676002)(5660300002)(316002)(33656002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3233;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bFmS9rZ7H+r2U7OnGzJe8L9dl+nTePZWiAj0IDqzI/ChXOl6X35VFEm612S5X0SIKIoXctt5q/Et2fizfvnEMkDp5P7qEX+RL52kATlWkDXj+Axj0hAYig4dxUqTtC3HUn2+83lGg1vSc7e42SyY90SQ2jermzwzxxS/gPspFV/+8zmKtYKwJhfSXQWSu/C1STk0GxwUV8HNsy8s+h0a9UloAKWAMApDCm4+iRiOqu8VsnO7HS3u5CuDFjLztlMJ8TCkPgdWmR7lcq+MIt6LMNoIgqZMDjfP03++dd2inGqLjKbrEUJKATuhL+3uod+NPaWpI6bZjc8yaiKNcvPhhJxIxSfnrjZFZOcl0apzZolwadjycVebcAK9zgfFoj4/QPa4DYymhzdzCFVajvdvhzb5Fu19dq329sEXPIMeO7WuAx78EnMvUOnCiPrOAy/w
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: bd657282-1061-4c10-7d1f-08d7983a119b
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2020 15:05:46.5763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qmh9+kJIlMx6cK0usXoThzv1c5c3Hd0OBLuC/CpqqR0MjOo5QUlgO5wiTGCudsPfiyE9JRgJtHTS8Lzt1CaCEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3233
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogVmxhZGltaXIgT2x0ZWFuIDxvbHRlYW52QGdtYWlsLmNvbT4NCkRhdGU6IEphbi8xMy8y
MDIwLCAxNDo1NTo1MSAoVVRDKzAwOjAwKQ0KDQo+IENsYXVzZXMgNzIgYW5kIDczIGRlc2NyaWJl
IHNvbWUgUE1EIGxpbmsgdHJhaW5pbmcgcHJvY2VkdXJlIHRvbywgYXMNCj4gcGFydCBvZiBhdXRv
LW5lZ290aWF0aW9uIGZvciAxMEdCYXNlLUtSLiBEb2VzIHRoZSBYR1BDUyBkbyBhbnkgb2YNCj4g
dGhhdD8gSXMgdGhpcyBzZXJpZXMgc3VmZmljaWVudCBmb3IgbGluayB0cmFpbmluZyB0byB3b3Jr
IHdoZW4gaW4gdGhlDQo+IDEwR0Jhc2UtS1IgY29wcGVyIGJhY2twbGFuZSBsaW5rIG1vZGU/DQoN
ClllcywgaXRzIHN1cHBvcnRlZCBieSB0aGUgSVAgYnV0IG5vdCBpbiB0aGUgcGF0Y2guIEl0J3Mg
d29ya2luZyBmaW5lIA0Kd2l0aG91dCB0aGUgbGluayB0cmFpbmluZyBwcm9jZWR1cmUuIEFjdHVh
bGx5LCBDbGF1c2UgNzIgTGluayB0cmFpbmluZyBpcyANCm9wdGlvbmFsIGluIHRoZSBJUCwgYW5k
IGluIHRoZSBjb25maWd1cmF0aW9uIEkgaGF2ZSBub3cgaXQncyBub3QgZW5hYmxlZCANCnNvIGV2
ZW4gaWYgSSBpbXBsZW1lbnRlZCBpdCBJIHdvdWxkIG5lZWQgYSBuZXcgSFcgdG8gdGVzdCBpdC4N
Cg0KLS0tDQpUaGFua3MsDQpKb3NlIE1pZ3VlbCBBYnJldQ0K
