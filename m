Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03FD371551
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 11:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbfGWJhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 05:37:21 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:52294 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725372AbfGWJhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 05:37:20 -0400
Received: from mailhost.synopsys.com (dc8-mailhost2.synopsys.com [10.13.135.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 902F6C01CB;
        Tue, 23 Jul 2019 09:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1563874640; bh=OCx/N+B3+q69cHy8CVUBCCf6bkMTBeEKd9WBOD7ADXU=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=NRkE3Mf1sPnj+I4WL8PxLIlDV0p+TOV3qOwb2ZqPHco3rK2qtnV+l+6oIfnPJJcoH
         EJHq1V7ugeHbLvGn33GAj1Ss7+jkA5enCQBFvaRpfKLh8hFQ4B3S3sQvS9nAmLhqnp
         qb5NMkyitfGeXo6HNmQvWpR3duZ/EA1DOWnXueJpd9TedE5V69vB4rziagv0N0NENr
         0NxQChyLUJA1sfHIyPHnncjYQ4/S28IrhuNNn/+wFABpvCZMEcjasJaFyn1CYPi270
         vuvAdOVW0fPuVeCGukkasuBJfC5QbRQqyBL6lBJs5+zxeBUvgrosV+Dk/QT+zzIBpN
         2OoNFTbYoXdBw==
Received: from us01wehtc1.internal.synopsys.com (us01wehtc1-vip.internal.synopsys.com [10.12.239.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id A5D53A0065;
        Tue, 23 Jul 2019 09:37:00 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 us01wehtc1.internal.synopsys.com (10.12.239.231) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 23 Jul 2019 02:36:44 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Tue, 23 Jul 2019 02:36:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dgohvpLI31wXjdpD9O8UolEpp2R+TCxmEvxGvu3AqbiUejUzzZSs66QGzj7ltBSbaB/k1EVKPI6uSm7XprMBXaYLtXzK8jpeu8HJpwP+JW6s6fYgm7c1wQcfL8mkuQDWXD8QI0LyVWY7KEZinm+HNPrK2KWyTtRGU2RAZboqisd9+cgk5YWzQR2yyNfhI8h+TFVE5pYwYS20U0WwD1DYZdE7fGH8FreKIzO94swjCH5Ug5kgdBylL4RUF86g/+hFS6cZ+nOkmuxAajhSg02Rx5zYb8ZiJvGfL458fFbjKLbOc+oRPczZVWYxXKxqiXab/fKr5ybk8HPoIcVcuOkokQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OCx/N+B3+q69cHy8CVUBCCf6bkMTBeEKd9WBOD7ADXU=;
 b=eCnczlYDMR2HJ63FMdIHER8p/CLtQfocMeaE4nSLpq5S9EWvgi9NsupF1KMb2tnlL5vtk1cUjn7PCe3BeNF9F8JkelRnS+/Y7vtKZfTki4swjMcD2Uuk/XARuLrpR7PnQPN8CVX18/jDyNAZhC4jVNNIbmlIytqRBx7d1Ag7JiSj/HoVMuOiLBom/21kKLOf/ZkzUU2uepQWjXi6nzy+ABQCuD+BHq2HjfgM29kaXDnIFygKyx+jl2hpzw82V4ELlm70jKAPWSx7Y3aqCh7HCgO86j438MplvdRlgPYRq1VugJNLp0WK1VvaY3HKR1Xg7gHReVNJ3uZ0cQIGGWPrkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=synopsys.com;dmarc=pass action=none
 header.from=synopsys.com;dkim=pass header.d=synopsys.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OCx/N+B3+q69cHy8CVUBCCf6bkMTBeEKd9WBOD7ADXU=;
 b=iKAYvB+dlkHZ9VqK/fXyhTRmaJefC4XO8LiLIan29o/TZLlsgjshJRvHY+Rt2LPlwtf9aDUGqyTmS/cBI9r3AUvTjIckeegPJDIPhQYf+BvfPplBAeqazG6AgEnFKYdhuxu7mD78Pl5xjtBLHqbmaZ97zbwbKP/hy7SUbiSLz+E=
Received: from BYAPR12MB3269.namprd12.prod.outlook.com (20.179.93.146) by
 BYAPR12MB2998.namprd12.prod.outlook.com (20.178.53.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.17; Tue, 23 Jul 2019 09:36:43 +0000
Received: from BYAPR12MB3269.namprd12.prod.outlook.com
 ([fe80::f5b8:ac6e:ea68:cb1c]) by BYAPR12MB3269.namprd12.prod.outlook.com
 ([fe80::f5b8:ac6e:ea68:cb1c%4]) with mapi id 15.20.2094.013; Tue, 23 Jul 2019
 09:36:42 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     =?iso-8859-2?Q?Ond=F8ej_Jirman?= <megi@xff.cz>,
        Jose Abreu <Jose.Abreu@synopsys.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Heiner Kallweit" <hkallweit1@gmail.com>
Subject: RE: [PATCH net-next 0/3] net: stmmac: Convert to phylink
Thread-Topic: [PATCH net-next 0/3] net: stmmac: Convert to phylink
Thread-Index: AQHVIGkCReoXsI1ev0mBbW+MAvwZAqbW1RMAgAALU8CAAATNgIAAAL0ggAAKQYCAAAF88IAABCiAgAE8+mA=
Date:   Tue, 23 Jul 2019 09:36:42 +0000
Message-ID: <BYAPR12MB32694541534ED0ABA3C55BE6D3C70@BYAPR12MB3269.namprd12.prod.outlook.com>
References: <cover.1560266175.git.joabreu@synopsys.com>
 <20190722124240.464e73losonwb356@core.my.home>
 <BN8PR12MB32660B12F8E2617ED42249BBD3C40@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190722134023.GD8972@lunn.ch>
 <BN8PR12MB3266678A3ABD0EBF429C9766D3C40@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190722141943.GE8972@lunn.ch>
 <BN8PR12MB3266BEC39374BE3E9CD2647DD3C40@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190722143955.uwzvcmhc4bdr2zr5@core.my.home>
In-Reply-To: <20190722143955.uwzvcmhc4bdr2zr5@core.my.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3942a70b-4934-4505-01b5-08d70f51458e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR12MB2998;
x-ms-traffictypediagnostic: BYAPR12MB2998:
x-microsoft-antispam-prvs: <BYAPR12MB29984BDB0D77B58B40AE3983D3C70@BYAPR12MB2998.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(396003)(136003)(39860400002)(346002)(189003)(199004)(26005)(186003)(6246003)(478600001)(4326008)(53936002)(25786009)(2906002)(7696005)(76176011)(5660300002)(52536014)(76116006)(66446008)(64756008)(66556008)(66476007)(66946007)(102836004)(8936002)(6506007)(66066001)(81166006)(8676002)(33656002)(81156014)(68736007)(99286004)(71190400001)(110136005)(54906003)(14454004)(486006)(71200400001)(7736002)(74316002)(5024004)(256004)(305945005)(6116002)(6636002)(229853002)(476003)(11346002)(446003)(7416002)(86362001)(3846002)(55016002)(316002)(6436002)(9686003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR12MB2998;H:BYAPR12MB3269.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: r15gpNl/wdg26Yor7FPk6Cr2Ic0wbuUk7NOwLC78EsqCljRuVlyGsyGMrJG0pLoi7ejureH7aELvYMPchTAUbqzp3caHAT+8+t1NfrAfjK0+LCvLinfZRd6HE50KJHpcsFCvcuAn/e2Qj6pVapt65i9dnNHGZEdMTdXBa4dV3ajJLoFijEFI9uvnh165uaRvmpAKMjHEgUmhIeOMM5FkhOnOALjUmzBzqQvOOi5BAtR80/MoLP5DAfV2qeQWBjrtrH+cJ31kkUToBlR3YfAyeJ1g1KAlTxYeCWA1fjiuFK5nr90IgNfrBRlxUAKYTr4TLziExXjPYPfHazEanm5cXHDo2fadynT0qpsN1gMRTANKDwGy5vg2LUJKKtbjMWLrYRS++oULcUXi/JTPfhR09c1eQ8efUftcPof7TGJxDOY=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3942a70b-4934-4505-01b5-08d70f51458e
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 09:36:42.9476
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: joabreu@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2998
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ond=F8ej Jirman <megi@xff.cz>
Date: Jul/22/2019, 15:39:55 (UTC+00:00)

> On Mon, Jul 22, 2019 at 02:26:45PM +0000, Jose Abreu wrote:
> > From: Andrew Lunn <andrew@lunn.ch>
> > Date: Jul/22/2019, 15:19:43 (UTC+00:00)
> >=20
> > > On Mon, Jul 22, 2019 at 01:58:20PM +0000, Jose Abreu wrote:
> > > > From: Andrew Lunn <andrew@lunn.ch>
> > > > Date: Jul/22/2019, 14:40:23 (UTC+00:00)
> > > >=20
> > > > > Does this mean that all stmmac variants support 1G? There are non=
e
> > > > > which just support Fast Ethernet?
> > > >=20
> > > > This glue logic drivers sometimes reflect a custom IP that's Synops=
ys=20
> > > > based but modified by customer, so I can't know before-hand what's =
the=20
> > > > supported max speed. There are some old versions that don't support=
 1G=20
> > > > but I expect that PHY driver limits this ...
> > >=20
> > > If a Fast PHY is used, then yes, it would be limited. But sometimes a
> > > 1G PHY is used because they are cheaper than a Fast PHY.
> > > =20
> > > > > I'm also not sure the change fits the problem. Why did it not
> > > > > negotiate 100FULL rather than 10Half? You are only moving the 1G
> > > > > speeds around, so 100 speeds should of been advertised and select=
ed.
> > > >=20
> > > > Hmm, now that I'm looking at it closer I agree with you. Maybe link=
=20
> > > > partner or PHY doesn't support 100M ?
> > >=20
> > > In the working case, ethtool shows the link partner supports 10, 100,
> > > and 1G. So something odd is going on here.
> > >=20
> > > You fix does seems reasonable, and it has been reported to fix the
> > > issue, but it would be good to understand what is going on here.
> >=20
> > Agreed!
> >=20
> > Ondrej, can you please share dmesg log and ethtool output with the fixe=
d=20
> > patch ?
>=20
> See the attachment, or this link:

So, I've removed all 1G link modes from stmmac and run it on an ARM=20
based board. My link status resolves to 100M/Full using Generic PHY so=20
maybe something is wrong with the PHY driver that Ondrej is using=20
("RTL8211E Gigabit Ethernet") ?

---
Thanks,
Jose Miguel Abreu
