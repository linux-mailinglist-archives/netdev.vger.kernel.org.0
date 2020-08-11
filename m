Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCEB24209C
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 21:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbgHKTxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 15:53:40 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:5981 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbgHKTxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 15:53:38 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f32f7340000>; Tue, 11 Aug 2020 12:53:24 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 11 Aug 2020 12:53:37 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 11 Aug 2020 12:53:37 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 11 Aug
 2020 19:53:37 +0000
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.59) by
 HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 11 Aug 2020 19:53:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ABREAJ/0PdKdTLVJLKSHzGUSzFeUPcZXKmzUpEf9b68CaTxtEEt5eyNOB5CPxrGeKxYnrNj/6NaOqukuoUt3oLPp/B657QghDLFYbjXYpKFCDtRkksClRb4fKrn937DNKxrgp3lUkNoLbCE66ISKYoXlobg86WGNEyZhr5fdHH4ICOM0YT996l7qcfhuTkU3bV5ATFMzMiYogMRQ0wm/h5ZWETs/tRCWi5oEEX746LYQUv8JwgNeN/ox4UmL/PIKRN53MChOn7Gkwu0e74izoFp+hZmhDpKrnXzfHYy9KzBu4Rwlw7fRXMu8tsLNPR8lC3LBkeabf72AYQ+nwjB5ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8TluiBHhKOJdcpnVHkl/iO20f3LEqyR4synU0T8bgQ=;
 b=dbMvM3yiaFhbYUkGQ1nhzrcnFlPVgGlxqkmbL9tNYFQIlyqyhep6Bx6Sj5q6Qi/CN8ZGjXkt1MuKn7zAk7bVBEzl5NSeCeCwA0XAZRVkFEteGuc7esqeV6sgGzoVUZIsONNKWUk7CqnBlRjeKVqO9TzWCdHDMFgwLNeZyUo20b9LvOwUf3DtyRw6U+PgpjjZEiXuM64b8qUPgvXyTVZ+9+fISMJwaIYWDU9Q9MUTbEziM1A8594GjWAuMnW3AgRmSsMQyolDWxOoJc1JZGw+QMuP81gXtsfdAylpBn1vhWERLPwEpL/Qu8DwptNkSoOYZaIC7azZqIsLReV0ctCgEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from CH2PR12MB3895.namprd12.prod.outlook.com (2603:10b6:610:2a::13)
 by CH2PR12MB4053.namprd12.prod.outlook.com (2603:10b6:610:7c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Tue, 11 Aug
 2020 19:53:36 +0000
Received: from CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::3069:824f:79ef:e2b3]) by CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::3069:824f:79ef:e2b3%7]) with mapi id 15.20.3261.025; Tue, 11 Aug 2020
 19:53:35 +0000
From:   Asmaa Mnebhi <asmaa@nvidia.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        David Thompson <dthompson@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Asmaa Mnebhi <Asmaa@mellanox.com>
Subject: RE: [PATCH net-next] Add Mellanox BlueField Gigabit Ethernet driver
Thread-Topic: [PATCH net-next] Add Mellanox BlueField Gigabit Ethernet driver
Thread-Index: AQHWZ2HxHXVRhRunfEuitWH9aE9Z16kzXFeQ
Date:   Tue, 11 Aug 2020 19:53:35 +0000
Message-ID: <CH2PR12MB3895E054D1E00168D9FFB2F0D7450@CH2PR12MB3895.namprd12.prod.outlook.com>
References: <1596047355-28777-1-git-send-email-dthompson@mellanox.com>
 <20200731174222.GE1748118@lunn.ch>
In-Reply-To: <20200731174222.GE1748118@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [65.96.160.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7cce29fa-93ac-4ae8-84c1-08d83e303c0c
x-ms-traffictypediagnostic: CH2PR12MB4053:
x-microsoft-antispam-prvs: <CH2PR12MB4053A57890E2AC96C57D0643D7450@CH2PR12MB4053.namprd12.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dpqYsXzkFIbLow19rmKzKkJsy3IIuj8bYuUquenw6k0xsKOymyKQHa0qXuE6u1St4FWh7HtfuhSLrtjKm4TAdSpV1e+9YcykAujOtrX6M8qzPEpLIIXxzqVgEefwrgKfsqWO/sLI9gJ0qfOzELbVfU50l+oIklVCG52adQQbi7HBEPNJyylPtxxyAVXCJoaVgJViIp0APkHxy+mBMqR37DoWnO/hgpVf6fBO+AEqUat6udTULZJpoz/R7+674lzau3dcUQKSmLD5aUle1f/TN04JAeQAzwRSAikvQJCEirvsJUdiDK+kR5Uvd9y5eAXMxFJ1Bypa8J5ooTcTH1X9gw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3895.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(396003)(346002)(376002)(136003)(83380400001)(4326008)(186003)(107886003)(8676002)(8936002)(52536014)(2906002)(54906003)(6506007)(71200400001)(7696005)(5660300002)(33656002)(86362001)(110136005)(478600001)(66476007)(55016002)(316002)(66556008)(66446008)(9686003)(26005)(64756008)(66946007)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: wgGbaFzqOyYo2Hr4N8C+pfWLl+gC4foGzEUdmMzDtMt70mTvjrDkogoEnuDgymIte1zapo7khuKtisQMCuoXBuoCNVGzJN6rrzsnizFg+dTwyiVA2Og/iBwsqD2z1Ter+wR7HXfowIsWx8XrjZyss10+f9WOXUKUVVJYW/5hX4wH2ae1PqujQqweQZZ0tDiq+9RYbCZergdny7cLuvkjTuJ3TZpENoTibu8TWjzFXnPSNy2jx8Z96/bl2/JYyfbfZK3yItdowMUkbC5nQxxFoc9VDrkqLNk317NAGck6e5LfEQAdyUwyZ/Jnb1BZBxcFnvx0KoaJkjMVfemwzrABAz5GQtcxhBCIq03YQQqX315YkYP/KTgggWqKkTqGytccUv61WrnhTd3u4Kqr4UDWaDvNRjULfdpA16QSIZaegZssh/GTRfWVsbi0OV4vlm88sdGN+z7DdakfUF/6oxzOgxNS30vkt8uH//UTzZZcj2QrI7h6pXEIFuv243RtFg3D/DFWygK7Go7wifHIsvaKgBtCu0WxbuVAnEhVikE/C/pygz3eaF9zsHMQ8KV3JY7creTFjbmx6tU8pRcvsrial8+GS3t/iZRXBMzB9fslgWlOKUX9kgCg9Nk7tp+1FZKNC2vTircQ9Wqq4YDFQ4++jw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3895.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cce29fa-93ac-4ae8-84c1-08d83e303c0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2020 19:53:35.8421
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dacxOecuIyIePQ9Tor3PbdM2AXtfIAvrJpoS/BlCy/AEG06Xbq9lbTd1OBJ/r/5+mIpEoVOhwiTrDlCdVOGTvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4053
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1597175604; bh=G8TluiBHhKOJdcpnVHkl/iO20f3LEqyR4synU0T8bgQ=;
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
        b=qstj7CzZ7nLwBUzVhW14har+WD1PXFuMWRvM05JBvK85DIMsNCYazETxaIS3nspw1
         ZeDIt5fmLTziVsqCCZ0jXh3aQNbvpqJAP/rRSo0goS4lg8bJZu4WGeuNPvL+216nQt
         ITPaMqhn3q5Bn4iewuGgd4c5Sfd9mw7Wt12Tgm2yEEM0Xo5Zjjz4D+Mu6fPHeS2DUV
         s7PWT1vnAtTLU8NWpKCd4rM1gx+a7wYLiYrUPCtF8YNi5UZlOwBUqXHHd20tMRQp/p
         11BPQM4vRZBH+zBXH29CQfwj3l2hRkdJHdFDNOsma2BDuuMtDNOLefpHo1TA0VIdI0
         H+NN0q9PBLs4Q==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Thanks again for your feedback.

> > +	/* Finally check if this interrupt is from PHY device.
> > +	 * Return if it is not.
> > +	 */
> > +	val =3D readl(priv->gpio_io +
> > +			MLXBF_GIGE_GPIO_CAUSE_OR_CAUSE_EVTEN0);
> > +	if (!(val & priv->phy_int_gpio_mask))
> > +		return IRQ_NONE;
> > +
> > +	/* Clear interrupt when done, otherwise, no further interrupt
> > +	 * will be triggered.
> > +	 * Writing 0x1 to the clear cause register also clears the
> > +	 * following registers:
> > +	 * cause_gpio_arm_coalesce0
> > +	 * cause_rsh_coalesce0
> > +	 */
> > +	val =3D readl(priv->gpio_io +
> > +			MLXBF_GIGE_GPIO_CAUSE_OR_CLRCAUSE);
> > +	val |=3D priv->phy_int_gpio_mask;
> > +	writel(val, priv->gpio_io +
> > +			MLXBF_GIGE_GPIO_CAUSE_OR_CLRCAUSE);
>=20
> Shoudn't there be a call into the PHY driver at this point?
>=20
> > +
> > +	return IRQ_HANDLED;
> > +}
>=20
> So these last three functions seem to be an interrupt controller?  So why=
 not
> model it as a Linux interrupt controller?

Apologies for the confusion. The plan is to remove support to the polling a=
nd instead support the HW interrupt as follows (from the probe):
irq =3D platform_get_irq(pdev, MLXBF_GIGE_PHY_INT_N);
         if (irq < 0) {
                 dev_err(dev, "Failed to retrieve irq 0x%x\n", irq);
                 return -ENODEV;
         }
         priv->mdiobus->irq[phy_addr] =3D irq;

This HW interrupt is the PHY interrupt which indicates link up/link down.
The MAC driver calls phy_connect_direct, which I thought was sufficient to =
handle the interrupt since it calls phy_request_interrupt.
Phy_request_interrupt calls request_threaded_irq which registers phy_interr=
upt as a callback.
Phy_interrupt triggers the phy state machine which checks the link status. =
The state machine goes into phy_check_link_status which eventually calls ml=
xbf_gige_handle_link_change.

I guess my question is should we model it as a linux interrupt controller r=
ather than use phy_connect_direct ?=20

Using phy_connect_direct to register my interrupt handler, I have encounter=
ed a particular issue where the PHY interrupt is triggered before the phy l=
ink status bit (reg 0x1 of the PHY device) is set to 1 (indicating link is =
up).
So the PHY interrupt triggers the PHY state machine, which checks the link =
status and sees that it is still 0, so it keeps the link state as DOWN.
Adding a delay to wait for the register to be set accordingly fixes this "r=
ace condition". But it doesn't look nice.

Thank you.
Asmaa
