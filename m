Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 119CD17DC4F
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 10:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgCIJWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 05:22:19 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:58822 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725796AbgCIJWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 05:22:18 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id D4EEB40064;
        Mon,  9 Mar 2020 09:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1583745738; bh=/Me148QZ8ckeM03vekb8lkVBetYzZbsMU8smEOfgd1c=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=IWc7ph/jNbtP1DgUeydQ6GrquurupV/oZ49Gq+HbHH/pDtuNrTfAYhWmJlz+6iNDb
         Ka6vi/HZFWKE2CREezJgd9mNiyJvLejwBbdWQRUwd0tHXwLEKDIOGHkEj5GXkqpdrD
         xqYQYQRgfmcfLYRnutzfmAX853qeowfns/MPeCbNaO5YCKihmvuijXGCDk7ysnKA/9
         kQZcdkakOzhxeeG8hqmh1Lndn8jWpytF/NwF+5zmx8L9venqdZycfIqBe03Tw4h7EX
         d4A4+7ZPB+pRVFTexKhhucgipWMgJIN2hCbsNCHhUVm9i23DncYh6Pl0h8b6n4GMPF
         WpDe4w60wehDQ==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id B3267A0067;
        Mon,  9 Mar 2020 09:22:14 +0000 (UTC)
Received: from us01hybrid1.internal.synopsys.com (10.200.27.51) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 9 Mar 2020 02:22:14 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.200.27.51) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 9 Mar 2020 02:22:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WPtYzB6+DjRo0BSq3GbhR3stNdTy5MZ4ZxJVrsm+30nOUx4t1nrpaDiVqd/Ko6mm+q6uggAYvovZ8tP54CNM8QZdylEMWurRZpgYPqzQbpjIaJEdKM8087THLmoRECKVlHbZfhbr9bjuY02340xOv1nMDZaUY12JTQan7X5ncfG4u9h5T79Cq6mpwEyLKa/dzdjKTZygANJ/b0iPBeVFxDYUtDB5d6n4f8hQTpLh6L4YybBblsXlW5ClxRlTxqP6CIDmVP/zl9c+kUxBrZQj3UbMFswHB3VWawT+LF7lNULTKL+ymV1sLCzFehbyW5rPlyibgjjPQCY933iuuLqULQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ufpYa88ph5YLFZaLlT6DnjsHiR26YQXh7Uya4vuoMxU=;
 b=NiuHrRY411CuhYbVHDAQmPbcbOvAFJJci25Ys12B9g0Q+eE2QSJ1ip45RU2ILUXE7xSP0jdDQSd+++8GsKtRHBi9FNTaRJr/nHynhxvjoz2S+WFO/WT6sb9+HSxPJrz4+ZdKERw2Ap/EjcLOYqGfcfZkefyYhpKoosh8XBaf9Dp0VZeO3/cBINbNLqVom5ePyOX9jBzt3QMlyhgtSHO2ZV2DiU8SSoYrEGsQ0PFbqJ3UlQqPwWDwOmGZ4NrVnuqTFedhLX8AAhIdSXnNYjlbFAD6pOc/jW8S/w93hLmtKDTR5Ui6jG5grn7zeqK4w+Rmnk6tX/b0ev+jx9FXtSQqJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ufpYa88ph5YLFZaLlT6DnjsHiR26YQXh7Uya4vuoMxU=;
 b=aXGrM3dnFLHLUzG29L3I7r0Xp7ZT/A/n/AJD2+hLNSnB5qwLNmCryz+Dp0j9S2iKmsz2iOSTBNZjrJACm5OGYIVlfkzzkeEdaM2FeBKnKNv5ZlMICf5iTp1yWel9zj0dc0rS53/KC5OeylyD6w1VftnlgNHh8FVOn7RLz7uPyX4=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (2603:10b6:408:6e::17)
 by BN8PR12MB3345.namprd12.prod.outlook.com (2603:10b6:408:64::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Mon, 9 Mar
 2020 09:22:12 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c9ed:b08e:f3c5:42fa]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c9ed:b08e:f3c5:42fa%7]) with mapi id 15.20.2793.013; Mon, 9 Mar 2020
 09:22:12 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     "Chng, Jack Ping" <jack.ping.chng@linux.intel.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Re:[RFC net-next] net: phy: Add basic support for Synopsys XPCS
 using a PHY driver
Thread-Topic: Re:[RFC net-next] net: phy: Add basic support for Synopsys XPCS
 using a PHY driver
Thread-Index: AQHVyhMHPh1TkUf6pU+JUVzLFdFzk6fomWeAgAAAjSCAAAp/gIAKvyCAgAAHGACAAANl4IAACl2AgBdyL2mANWk/gA==
Date:   Mon, 9 Mar 2020 09:22:12 +0000
Message-ID: <BN8PR12MB3266C896974574439AFEA0D6D3FE0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20200120113935.GC25745@shell.armlinux.org.uk>
 <e942b414-08bd-0305-9128-26666a7a5d5a@linux.intel.com>
 <99652f12-c7b4-756d-d169-4770cf1f0d96@linux.intel.com>
In-Reply-To: <99652f12-c7b4-756d-d169-4770cf1f0d96@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0aa31fe2-0a6e-4220-b6b7-08d7c40b59e3
x-ms-traffictypediagnostic: BN8PR12MB3345:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB3345C87DA9098A60453FD99AD3FE0@BN8PR12MB3345.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 0337AFFE9A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(136003)(376002)(366004)(39860400002)(189003)(199004)(26005)(7696005)(8676002)(316002)(8936002)(33656002)(52536014)(6916009)(2906002)(5660300002)(81166006)(81156014)(6506007)(966005)(66446008)(66556008)(55016002)(76116006)(186003)(66946007)(4326008)(71200400001)(66476007)(4744005)(86362001)(478600001)(54906003)(64756008)(9686003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3345;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VdCtP0htTFl0NZgzvRg/R46vvJWp7ARa9r48b0md01hv9CcYn7wmwCKgw3opS8HAcT68UsoRJFnus8uq9EycupK0sn8eLiZoXJu2OsKg7q3Gb4oZXs3jI+fIoxqH7gY1BKXvGOMqSQjeVdRvzYDmgaBA0H4Yk7if7+LeKechEqwuLTRuaBY1J/r+gstXJ6cCIGZu1bvsNPWZqqX35FePmhuadCUQddp44kAMorXN2HvgXnBHoWi2/M3WTTBy2rLIvdaD16W15bjE9c4tQvjIY1QOQrPftQ/hkS/2U/E+QrAGXWM6q+1no9vynGMeqOpaq4F7C8PecZyJaBPsDhLtIeYO/qoNWfv/a/hGodfsZTq6Vbn8nqWzkbTxUHO3aqJHXIaMtbpvwCLtoZF7nf1487NGm9KvFemYOW2JQp9W4y33Jk8EuGdXGmLQMQzzMmmMK5XqixJbucSdoXRQ2mSsj6EinWRRgSShcBsG86oxkupK5/fx5iOCn9Bn+Sr2ucv0vCzY0gf3BD/wiODr8ShS/w==
x-ms-exchange-antispam-messagedata: anUWSvVLw6FhZ6m6+ax3S5pgH9I4DJpyLu5LO7aQHUyTD1Tzx/MBmZtLkfC3S5vWAtaWbpwP1YJ11yUGx8wQfmipq2uF2Uwn04vv300BkcCneY9ZjwsGS1EjGF1G0Xt3pov5yZk0tL0h2QfcEJOOPw==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0aa31fe2-0a6e-4220-b6b7-08d7c40b59e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2020 09:22:12.6885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q1DUBxJaGbUPfZ8h2xEg1ZOZzqxF5SjnA00sm3QDv8USX1HGmVs6leNacESNzIjn4Hvwb3WNsWfNF/oxK0jsgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3345
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chng, Jack Ping <jack.ping.chng@linux.intel.com>
Date: Feb/04/2020, 09:41:35 (UTC+00:00)

> Currently our network SoC has something like this:
> XGMAC-> XPCS -> Combo PHY -> PHY
>=20
> In the xpcs driver probe(), get and calibrate the phy:
>=20
> priv->phy =3D devm_phy_get(&pdev->dev, "phy");
> if (IS_ERR(priv->phy)) {
>  =A0=A0=A0 dev_warn(dev, "No phy\n");
>  =A0=A0=A0 return PTR_ERR(priv->phy);
> }
>=20
> ret =3D phy_init(priv->phy);
> if (ret)
>  =A0=A0=A0 return ret;
>=20
> ret =3D phy_power_on(priv->phy);
> if (ret) {
>  =A0=A0=A0 phy_exit(priv->phy);
>  =A0=A0=A0 return ret;
> }
> ret =3D phy_calibrate(priv->phy);
> if (ret) {
>  =A0=A0=A0 phy_exit(priv->phy);
>  =A0=A0=A0 return ret;
> }
>=20
> xpcs driver needs to handle phy or phy_device depending on the phy?

Apologies for the delayed answer.

I think XPCS should be agnostic of PHY so this should be handled by stmmac=
=20
core and=20





































































PHYLINK.

I submitted a new series: https://patchwork.ozlabs.org/project/netdev/list/=
?series=3D163171

Can you please test it ?

---
Thanks,
Jose Miguel Abreu
