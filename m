Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD57224302F
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 22:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgHLUiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 16:38:00 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:16140 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbgHLUh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 16:37:58 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f3453180002>; Wed, 12 Aug 2020 13:37:44 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 12 Aug 2020 13:37:58 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 12 Aug 2020 13:37:58 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 12 Aug
 2020 20:37:58 +0000
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.46) by
 HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 12 Aug 2020 20:37:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TSVzhX4itao/qm/PcvGwpWmY4O4E/FhQOj3Gmp95bZTGl05plsSa5oa/08+kU+M1a3fUujLTFjPEOQplHA3TV0fcdVlq4PPxxZJhXCXXXUdmB/egAmVHWWXwopt1AglnlZpCZ1iXE4Zv7pzkjemgz2Ltpf1tBZuZ6LQqNVwy1YjmEntVZy43r/2l60PomcANgH1YpFGv9KcbY21yRmoxnDCW2c6JbQfqx6Kdtx7reeqCIfBcpRAA8pfHoBAvJyZeoMWJ8V3Zlb8E3qPvRDiueiNAXu+74QTrj3rK0JOTu4LKDsj2grdGm8uBVQn5VfEDChmSmg76a2vDNGEUn+QMsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mJm6eH/WywQvLzmfS0W3lMGJm4NaAjjBc8xuGcQCoCQ=;
 b=OorI8Z48KnmbzPDXrFSSYVxZSvc3o7xMpPkFBT0uQUEVWDdwPXiwRYB9bqfz0MoTE1zQrpyYdKjUMXYAcGWebxKnRApKkOMOVz6MfjmQYCnwCw25xRemGfxKTVuokay/SXqgYB3xamCPMWqurzwOhd1tqOn6Z+ORsih2n/CiwrZ76f4LsslbyE1FIKV4lw94cGhm3XDMB/hEiteWo2ceh6npfh3af9mGv+udmZV3EifymWA1lNHuLCKU05GMO1uL9x/Xrd4zmhQgLr/tJZ6ysLjrpObku4MTrRV/haMP6ZqrLMgUj6GaBpypdzkvSW3hQoe94Y+NOcoUJ6dDE8iggQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from CH2PR12MB3895.namprd12.prod.outlook.com (2603:10b6:610:2a::13)
 by CH2PR12MB4119.namprd12.prod.outlook.com (2603:10b6:610:aa::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16; Wed, 12 Aug
 2020 20:37:56 +0000
Received: from CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::d0ca:e3a:fdea:784]) by CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::d0ca:e3a:fdea:784%6]) with mapi id 15.20.3283.016; Wed, 12 Aug 2020
 20:37:56 +0000
From:   Asmaa Mnebhi <asmaa@nvidia.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     David Thompson <dthompson@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "Asmaa Mnebhi" <Asmaa@mellanox.com>
Subject: RE: [PATCH net-next] Add Mellanox BlueField Gigabit Ethernet driver
Thread-Topic: [PATCH net-next] Add Mellanox BlueField Gigabit Ethernet driver
Thread-Index: AQHWZ2HxHXVRhRunfEuitWH9aE9Z16kzXFeQgAAKzQCAAZdfkA==
Date:   Wed, 12 Aug 2020 20:37:56 +0000
Message-ID: <CH2PR12MB3895636714ECACC888869058D7420@CH2PR12MB3895.namprd12.prod.outlook.com>
References: <1596047355-28777-1-git-send-email-dthompson@mellanox.com>
 <20200731174222.GE1748118@lunn.ch>
 <CH2PR12MB3895E054D1E00168D9FFB2F0D7450@CH2PR12MB3895.namprd12.prod.outlook.com>
 <20200811200652.GD2141651@lunn.ch>
In-Reply-To: <20200811200652.GD2141651@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [65.96.160.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c209bcb2-2c80-4c96-6f51-08d83eff9862
x-ms-traffictypediagnostic: CH2PR12MB4119:
x-microsoft-antispam-prvs: <CH2PR12MB4119B0695B31304629414547D7420@CH2PR12MB4119.namprd12.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Jn7G+Ae0V6aLbLAk1U6yarQX4ofU101V/knm0GCQvCjCtjs5Fy94Fjp10Qf2na3U/5XGVI9nOcfbF3mslJFVRWC6+ehx4HFnPKEleCBbY2YVO16dE7XJgeFJFCdC1FLjVCH9tH8yhjR+4XFAaCBDdeA7l57yOq6EH1KALZ9O32vf/JKRpC4fFfZg3ld+GPJ7GD9gPOz0pozL8YK/V+j+FhKAOYOtmLvTKGuOfpym2UHrUamLFGm7ovhDBBsdM644OsztyqA+Wza1HCrgQGf2A8Swczs9rKs1BaZsq4MbIiNm2Sb4xNKvJzpt4Rtc4IH/BjIaTSxhPU9tOTG6GprgSg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3895.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(396003)(346002)(376002)(4326008)(186003)(71200400001)(2906002)(26005)(5660300002)(54906003)(66476007)(33656002)(52536014)(53546011)(107886003)(76116006)(6506007)(66556008)(66946007)(316002)(66446008)(64756008)(8936002)(86362001)(55016002)(8676002)(9686003)(7696005)(6916009)(478600001)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: s9JDKzyaosFGvl0kIJUT/zwGvyUB9N18ZGZJXajWEWohznIsoWJPWuy8AeRpsD4nNhNlsiDfE30Zep7jrI4VLmQBPa9RNlYNl+CV6vmzsVBZ5Ck4vdXPquxVqh87VNCpKMWGlCjUX5E9Ts7ag6cud1yATzwl7VW/WiivfRgMzT9v0we5cYC2WP6lRtySvG1U3Wke3EJbu5wboUAxB6wgDB48627R5aJVyDjyUmgH4YAAhYWZohPAykAsu9NY8jjB6w5AOHitvSJ2VtA8IJgsZA/pzk+HcJCkhqMDFXoMcyIX+x4PDHn911TiVrfdu6rL2zSsoXJoWWbzUW6ib8A9v40xkwc2oZS1PPb4BHNWF3obv5O+zZeV9CwW161V6nNvG0WQ8zB7XMPb5VQwa/6D5A13hmbujtM8C7SuVfivCN/ur8k0y9SmAgBWxODciuze1/GrmODfvTwoGbyJ2vJ01h7EleDf+O+PiyEJXBiCXHWt8Xa6jgGMebXGSCsFLX03lNsvpK2OH2xwL3Oi9/Ib362RHr/jdEw37seNtDAPM3A1HlDAXiFCi/TMzGJFDsnL/yfrtXHzp3NKUmuaz+EH5oNE4k+ktGh6U3Ee9+OyEg0ttaH4S6ThoTKwJt1+Vdy3kGEC6fWVordXue22DYaHjQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3895.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c209bcb2-2c80-4c96-6f51-08d83eff9862
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2020 20:37:56.5776
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P9x7k2xEYYEv19arCpwQXa6ruw+j0u6agceAh56LOcQBsxKUY5o8kPkONScDNPGdcDhTXLVfnnCmdsj5hOafng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4119
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1597264664; bh=mJm6eH/WywQvLzmfS0W3lMGJm4NaAjjBc8xuGcQCoCQ=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:From:To:CC:Subject:Thread-Topic:
         Thread-Index:Date:Message-ID:References:In-Reply-To:
         Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-microsoft-antispam-prvs:
         x-ms-exchange-transport-forked:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=Fmk03QUZFurs0BkfvxIgua1+acpnIckGaU5ShVfuQU3Zw+A9bw9K+OH0XM1tJp36K
         6vjuke9aTGF5HcmFDvq9PfKsT0aK1LEhB1uc3W+JHVHuDJMDQbFyd5TZoe3U1mKz0D
         T0zs4pgZ26rjIHzmHCJ/2fGPYvF1CCU6DW1AfHJsuE5Bls6586ksyLAeXzHo7K+IGZ
         +vZ6ZHi9dgDSMvuICU2Szoinv/ht1gvg1hrSATB4JIQZTryxdkCtz6K7xEwe32xmeE
         ecPGzUz7smfWofTnHdRCg6z/4TUVQwmcz0a+d/D2EV/C+6pdfRTYRRA0X2SWJDUvfT
         QoLXR7ubD2wew==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Tuesday, August 11, 2020 4:07 PM
> To: Asmaa Mnebhi <asmaa@nvidia.com>
> Cc: David Thompson <dthompson@mellanox.com>;
> netdev@vger.kernel.org; davem@davemloft.net; kuba@kernel.org; Jiri
> Pirko <jiri@mellanox.com>; Asmaa Mnebhi <Asmaa@mellanox.com>
> Subject: Re: [PATCH net-next] Add Mellanox BlueField Gigabit Ethernet
> driver
>=20
> On Tue, Aug 11, 2020 at 07:53:35PM +0000, Asmaa Mnebhi wrote:
> > Hi Andrew,
> >
> > Thanks again for your feedback.
> >
> > > > +	/* Finally check if this interrupt is from PHY device.
> > > > +	 * Return if it is not.
> > > > +	 */
> > > > +	val =3D readl(priv->gpio_io +
> > > > +			MLXBF_GIGE_GPIO_CAUSE_OR_CAUSE_EVTEN0);
> > > > +	if (!(val & priv->phy_int_gpio_mask))
> > > > +		return IRQ_NONE;
> > > > +
> > > > +	/* Clear interrupt when done, otherwise, no further interrupt
> > > > +	 * will be triggered.
> > > > +	 * Writing 0x1 to the clear cause register also clears the
> > > > +	 * following registers:
> > > > +	 * cause_gpio_arm_coalesce0
> > > > +	 * cause_rsh_coalesce0
> > > > +	 */
> > > > +	val =3D readl(priv->gpio_io +
> > > > +			MLXBF_GIGE_GPIO_CAUSE_OR_CLRCAUSE);
> > > > +	val |=3D priv->phy_int_gpio_mask;
> > > > +	writel(val, priv->gpio_io +
> > > > +			MLXBF_GIGE_GPIO_CAUSE_OR_CLRCAUSE);
> > >
> > > Shoudn't there be a call into the PHY driver at this point?
> > >
> > > > +
> > > > +	return IRQ_HANDLED;
> > > > +}
> > >
> > > So these last three functions seem to be an interrupt controller?
> > > So why not model it as a Linux interrupt controller?
> >
> > Apologies for the confusion. The plan is to remove support to the polli=
ng
> and instead support the HW interrupt as follows (from the probe):
> > irq =3D platform_get_irq(pdev, MLXBF_GIGE_PHY_INT_N);
> >          if (irq < 0) {
> >                  dev_err(dev, "Failed to retrieve irq 0x%x\n", irq);
> >                  return -ENODEV;
> >          }
> >          priv->mdiobus->irq[phy_addr] =3D irq;
>=20
> O.K, that is one way to do it. The other is via the MAC driver calling
> phy_mac_interrupt().
>=20
> > I guess my question is should we model it as a linux interrupt
> > controller rather than use phy_connect_direct ?
>=20
> It seems like there are other interrupt sources, not just the PHY. Do you=
 plan
> to use any of them? It can be easier to debug issues if you have an inter=
rupt
> controller, can see counters in /proc/interrupts, etc. Also, if you need =
to
> export the lines to some other driver, e.g. SFP, it is easier to do when =
there is
> an interrupt controller.
>=20
> > Using phy_connect_direct to register my interrupt handler, I have
> > encountered a particular issue where the PHY interrupt is triggered
> > before the phy link status bit (reg 0x1 of the PHY device) is set to
> > 1 (indicating link is up).
>=20
> So the hardware is broken :-(
>=20
> What about the other way, link down? Same problem?
>=20
> Polling is probably your best bet, since it is robust against broken inte=
rrupts.
> If i remember correctly, this is an off the shelf 1G PHY?
> Microchip? Is there an errata for this? Maybe the errata suggests a work
> around?

So let me explain further and would greatly appreciate your input.
Technically, when this driver gets loaded, we shouldn't need the interrupt =
when bringing up the link for the first time, do we?
Correct me if I am wrong, "phy_start" should bring up the link. Phy_start c=
alls phy_start_aneg, which eventually calls phy_check_link_status.
phy_check_link_status , reads the link state bit of the BMSR register (only=
 twice),  and based on that determines whether to bring up/down the link. I=
n our case, that bit is still 0 when the read is donw. A little bit later, =
it gets set to 1.

This is why polling works in this case. Phy_start fails to bring up the lin=
k but the polling eventually bring it up. If we choose to use the interrupt=
, we should make sure that the=20
Interrupt is enabled a little bit after phy_start, otherwise, it would just=
 be wasted.

Best,
Asmaa

>=20
>      Andrew
