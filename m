Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 074291393AB
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 15:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbgAMO2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 09:28:03 -0500
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:60190 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726074AbgAMO2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 09:28:03 -0500
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id DE9F1C00A0;
        Mon, 13 Jan 2020 14:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1578925682; bh=o3CDZFAEMbWq2bAS1monYLWG4nL1yfonfLZ9GzV1dXE=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=DarbXJBRZRaAyCQr+y03+dn10s/Shtn7JCLQYVBNPvVdm55L74G/q+nZV9H68ThXi
         u6dGiDrVPxRV8n67SCeKOrcIsHKt8oD896X9D+bgLU9NqAKkc5F+xA6u+dtuSlEQ+1
         ODy9Hpz8OBottww3gmKgJ8osApNOaiN8OKMZiVOGtfDQaSJ2cxypDs6/rnm6PzvUp6
         Bov3LQ5MERCr090o50/A6Rte+Uux+LbqKTjRVbOByGBVbsr4+KElHKMAM7jByyAtva
         Rrsgqx8JI1ghzF6dNU+PGd4hYsgyRS3tqFmss0TPliCt/ZvNpRkUtYilbfpI+X//kb
         PZO6RUrFDrfsA==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id DB968A0083;
        Mon, 13 Jan 2020 14:27:59 +0000 (UTC)
Received: from us01hybrid1.internal.synopsys.com (10.200.27.51) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 13 Jan 2020 06:27:59 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.200.27.51) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 13 Jan 2020 06:27:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KjlRigh6ofgtH/Y87nYl/l3H6WN9LS/9fq6hnlLe4+UcpvdGXL6HUgu69QgGG+43UdT/3AWlwqgSLbRfQAUT3TRQBX1ZkhicEgg6NwlgffKwnqOcjqhLviDvTnm5TKbq8fhOtXfemPs4Twp7DGLj5pQyFhIvHDMXn28AG5N0EY//XwBVrovNaDghnnI8CwuexsKVcz17udpGJIGkzjDzV2uIKQPVX6HedKSLz9bBRRuLApI2PMkzt06FvY9T65qfLSp5fmEchIPa6yPw5WZcpo+UwOiYlgYrWI8omNDc+WwFvmftfH+yRGZapUwmMyr501CCYf7W7Bg1WppzoKtIeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7/oMFKrb+dJZQMwKU9Py6oA/tDbpYlbgolZ0ZjqXf6A=;
 b=Awamele66TbKsY5H6iGkfcPkZN3hWg++TfVRxfTZrIVITcoa0QLz0v1P0IX5lmGog53CdRKx0IBZSiippi+gCCvxkb6UgEjIbfyKf3CQKpHd3wL3V6CXbDqNh8Tvs8R2jfKdRfu1JUtj8fx3Ie9+JzxbPxGWUPDJQ4zc5hmZGhvjNbLuLNdtNTIVXPSRCSiBvGu3MEroWd6xkDFct13Lmh7I2ESo0Xh1vBEMEKwc7ZyQ6pEJrwKOnOlKWtunFnnksz1njo9jIHCH+OOUXA/5BUjUt7DH8buIYebrXPEB35u84tC7AGtFNylaeLn09CIc/PlVo5Uq1DTU0qhMtw0ANA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7/oMFKrb+dJZQMwKU9Py6oA/tDbpYlbgolZ0ZjqXf6A=;
 b=Z3U8cI+Kwuw3oieVFiWOF47AI/ehgwVpfTi47n00SfIdWy8P1dnPGXdx7wyZCPmz7rXiCUmipPJipI4fzXwbUiav0Cf9SgH9JT8CDzAmwuz0EFnIHVmUgOVm3QCgGbX4qbhU9IIyXHQMGQ8r9JkvhE5ub0anYZ+gat0nM0t/BZs=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB2978.namprd12.prod.outlook.com (20.178.210.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.13; Mon, 13 Jan 2020 14:27:56 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2%6]) with mapi id 15.20.2623.015; Mon, 13 Jan 2020
 14:27:56 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC net-next] net: phy: Add basic support for Synopsys XPCS
 using a PHY driver
Thread-Topic: [RFC net-next] net: phy: Add basic support for Synopsys XPCS
 using a PHY driver
Thread-Index: AQHVyhMHPh1TkUf6pU+JUVzLFdFzk6fomWeAgAAAjSCAAAp/gIAAAN2w
Date:   Mon, 13 Jan 2020 14:27:56 +0000
Message-ID: <BN8PR12MB326690820A7619664F7CC257D3350@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <4953fc69a26bee930bccdeb612f1ce740a4294df.1578921062.git.Jose.Abreu@synopsys.com>
 <20200113133845.GD11788@lunn.ch>
 <BN8PR12MB32666F34D45D7881BDD4CAB3D3350@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200113141817.GN25745@shell.armlinux.org.uk>
In-Reply-To: <20200113141817.GN25745@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4e261460-03e6-476a-80a0-08d79834c8ab
x-ms-traffictypediagnostic: BN8PR12MB2978:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB2978D2FDA45993F77C2B9F68D3350@BN8PR12MB2978.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 028166BF91
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(396003)(346002)(136003)(39860400002)(189003)(199004)(7696005)(8936002)(86362001)(186003)(54906003)(71200400001)(64756008)(66556008)(66476007)(66946007)(26005)(6506007)(66446008)(52536014)(5660300002)(76116006)(6916009)(478600001)(966005)(9686003)(316002)(55016002)(33656002)(4326008)(2906002)(8676002)(81156014)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB2978;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3F8qckIhIAKmoPFtpLtzn8IB4te9H92yS98tdjIWWHRebJlXjkyf4of5nDBJxXGm8m7Z3FZcE4X64PBX/2NDc8w+lKXHmbCRNPGAUJdf7YoApbHnj3+pc22UXBmCKnIuSK4fARoDznszXx492pjtWzYzW7ZsXHo4nV85GGsHJDsrbA4n8X+48otp+vnkCDa0j6Qexe6uIwyk/WCve21cH+XuG2RX7CGvgMs92w3XlXLGY6kDykiI03st5uXwaOTMLadZolQtVcuc+05bhcTwfbjZUcZ8c+fDN5vshECibt5WhJYyhXbTOaY3bgxcicQkmmWm0ywhhF8fXe2asJZkrsOljaUNFqm98tuFX9O3LqZyXvLaPIoSrCaQSz1/v1ZR3tmFlvgFcC6Kvjg0uSwAhWzyhez/dqInuuoiRxc2O/rjwBEIodOsRGsHrIi3a8pz5cQ1wty8RNA/wJAM/PEJGdHA6xZJwjf+urffnHUhnjJItj0KXm0ZhsGnZcScwlwBXyStipqrRH6apmvSZ9Xy+g==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e261460-03e6-476a-80a0-08d79834c8ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2020 14:27:56.7119
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9VJMr1urxeoWMWjxcjI9pJJHAOpFncGI/Dp95nev9bTl1Hn/iHVAPp0hHHhkBEnd7otEQ8mpDsVqhLqMG8D64A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2978
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Jan/13/2020, 14:18:17 (UTC+00:00)

> On Mon, Jan 13, 2020 at 01:54:28PM +0000, Jose Abreu wrote:
> > From: Andrew Lunn <andrew@lunn.ch>
> > Date: Jan/13/2020, 13:38:45 (UTC+00:00)
> >=20
> > > On Mon, Jan 13, 2020 at 02:11:08PM +0100, Jose Abreu wrote:
> > > > Adds the basic support for XPCS including support for USXGMII.
> > >=20
> > > Hi Jose
> > >=20
> > > Please could you describe the 'big picture'. What comes after the
> > > XPCS? An SFP? A copper PHY? How in Linux do you combine this PHY and
> > > whatever comes next using PHYLINK?
> > >=20
> > > Or do only support backplane with this, and the next thing in the lin=
e
> > > is the peers XPCS?
> >=20
> > My current setup is this:
> >=20
> > Host PC x86 -> PCI -> XGMAC -> XPCS -> SERDES 10G-BASE-R -> QSFP+
> >=20
> > The only piece that needs configuration besides XGMAC is the XPCS hereb=
y=20
> > I "called" it a PHY ... Anyway, this is an RFC because I'm not entirely=
=20
> > sure about the approach. Hmm ?
>=20
> I don't seem to have been copied on the original mail, so I'm jumping
> in blind here.

Thanks for the comments. I'll add you in next versions, you can find=20
original posting at:
- https://patchwork.ozlabs.org/patch/1222133/

> In phylink, the=20
mac_pcs_get_state() method is supposed to read from
> the PCS - in your case, the XPCS.  This wasn't obvious when phylink
> was first submitted, especially as mvneta and mvpp2 don't offer
> 802.3 MDIO compliant PCS interfaces.  Hence the recent change in
> naming of that method.

Yes I saw that. The thing is that this is a different and stand-alone=20
IP. Maybe I can add it into some sort of module library in PHY folder ?

> I've recently suggested a patch to phylink to add a generic helper to
> read the state from a generic 802.3 clause 37 PCS, but I guess that
> won't be sufficient for an XPCS.  However, it should give some clues
> if you're intending to use phylink.

This uses Clause 73 for Autoneg. I can add that into PHYLINK core if you=20
agree.
=20
---
Thanks,
Jose Miguel Abreu
