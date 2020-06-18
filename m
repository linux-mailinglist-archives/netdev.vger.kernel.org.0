Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3481FF90A
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 18:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729096AbgFRQSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 12:18:04 -0400
Received: from mail-am6eur05on2065.outbound.protection.outlook.com ([40.107.22.65]:6079
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728134AbgFRQSB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 12:18:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m0WcehnPJ3T+XjGWgVxP9edcj6rB3ywiq8+o/NqHcWKR9nYYGgC5A0bhuE2A0AmfzgacVjPcuOa5DjT6ZK7Kkj+5BNQkosy4JpffQfrgi74Yhp8N9uwt6vpLXABU1yfQwusy3ISgs8WyHav4VUomJzJwkFOH6fCXjFX0SdORNcQTfS4oGVNeOIZC11d/MekVMCNOcsxIJuKLDd9I9nTbjAsxWUuwsA9yNZTcLjHTpfyIpCbdemzbfOFTg9zXjFEHkmmtmDEXNXyNbKYyO3S0Ze4O/dycik4QIf2X0mXt+e813aad1Gi/JaPP7aKN/ocPJDVGS+0bot32MYgkdoVTFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RPV4KUPpIzYbfQcGfQm8Sh8sh+d+btB0UrYZ+TMUJ30=;
 b=lFi4K8gyABBXhTpRGcAkDIFAmbMumQELq3PKZQ53yCWGFQKnNz58JzXtJMuVB/c3lfscHXyNMjGASphVPEzcBSVybur3ozNTXUaHXSgPGtwkrsCh7j4zcEfeZutm5K1nJe8JBM0RB7BJfHN6pcgtQWKrqHTVoDQSt15ymRlrE/tHhQeSC7kYvYJMKKoCMkFiktKZVZkNk5FU2Wvw9O3CQ3Y+RfbFC+3a6tjbOvoJqObdrKyYdvWSBelrgXdzrvzx+caB5fWY3vYPFyzxENT7296CCNZFowmSNmZILAj1fRqMIthVvXm6W/7cYnYuvINokNtjPnNYapgT47WgU3S9pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RPV4KUPpIzYbfQcGfQm8Sh8sh+d+btB0UrYZ+TMUJ30=;
 b=AymvICAuGPf9l71mCFUxfNOa+PylFyQGTLrp70I9e+E4x/SPue9EkbQotVx9xcsRmWBxf57H8mMrD3FoDG8Fv2O47S6D8/PYVGRuScnVH8tM6uZ5ryQcAaKe8S7FCDDDsj1xCMiSc19Pllg4BMi45aNlXs6/8ufVCenRihb+oXE=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0402MB2926.eurprd04.prod.outlook.com
 (2603:10a6:800:b0::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Thu, 18 Jun
 2020 16:17:57 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0%7]) with mapi id 15.20.3109.021; Thu, 18 Jun 2020
 16:17:57 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: RE: [PATCH net-next 4/5] net: phy: add Lynx PCS MDIO module
Thread-Topic: [PATCH net-next 4/5] net: phy: add Lynx PCS MDIO module
Thread-Index: AQHWRWlFJODo1hCReU2dgxtV9gIXrKjeaHmAgAAGAiA=
Date:   Thu, 18 Jun 2020 16:17:56 +0000
Message-ID: <VI1PR0402MB387191C53CE915E5AC060669E09B0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200618120837.27089-1-ioana.ciornei@nxp.com>
 <20200618120837.27089-5-ioana.ciornei@nxp.com>
 <20200618140623.GC1551@shell.armlinux.org.uk>
In-Reply-To: <20200618140623.GC1551@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.56.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 64a8fd7b-a412-4713-1032-08d813a3299a
x-ms-traffictypediagnostic: VI1PR0402MB2926:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB29265779323904ED1C0CC443E09B0@VI1PR0402MB2926.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0438F90F17
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z1wlwQ/VDIYwLYefhWIzPNems0WvA6tWKMe5v4tGobBmV+Lc7Asstlko7o4iEh3H/cJswrCQb3zfaMf+wPuompgiNV2k5nm8dIrJr43+j2bbInEx20BZSABjY8sdml6zvAzJwylR4/ff56vva4Xwwr2z5tHYFGHY9Uj9EJNzf2DbW1GXOVxQdi/LmS3Nz1AsfnbBDcjcc9sOaUAhKVeZfHpoAGwPi+XPcSJf9xnnb7awjy1qtRHhW9vc7CYaplq+gFSuyaaekb0JCI/8n6j3uXf4ZEtvZE4nyY3CPUKIIaDAXo69jzjQ6ZrjixDNUtd2zcRPu8noERwyFwGhJ9Yk8Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(376002)(346002)(136003)(366004)(76116006)(66556008)(66946007)(66476007)(66446008)(64756008)(7696005)(26005)(33656002)(186003)(316002)(54906003)(86362001)(44832011)(83380400001)(6506007)(478600001)(52536014)(8676002)(5660300002)(2906002)(4326008)(55016002)(9686003)(6916009)(71200400001)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: BT6pitG+da0lg+GxWScv7jnBYlETT53u3Ei9d76qrw8K4Oz/hwPWM8UXw0V4n8Jh9mycH9HBwoiyAVnKZcCRRD9LohU2cT7aNsSM7wJ7Trau72ZckN8qIA9vlsEcvXGIXVPmMGlXSilNfErM9Gt4qvCSdRFcJfymgQX9aBDPqQhAZCQCe2Mlx4ROFwVX7OuEjLQKKUDgGwqvYpS4o+EH+oHpebzehgOdVs1NemOWHu2DbU91Ca0z7Pnh9VobPRbwFNxKbsuOW5t1UPgZ3h/mvqG3hkyUzaPzqRIIv/guHGgK/ZlNIUYF9J0tEPpU3aVLgn4nyi9dzn5OxJig+vo7NS1GjuGT6H34lOavhBXCtu8CURWWHnLyvJWGKRW0lLWW7ixPfpXzA5AS3EBpKg4YvBY3c+MX3GfR/yHi2VzHPDAKadLAh18/drE0C42INMaDI0I6tNZkUbCL3HT+Qhd4yKE2jEmKXlgCBfk7GwcelyM=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64a8fd7b-a412-4713-1032-08d813a3299a
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2020 16:17:56.9805
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1PrOV2cdsoM6gm/zX46Tpx4WkBUQ4aq47gZ0O+uLbqfOxzyc8qFn+qAG0nc+Y/UmsKSloAO3HhqQmqhScCR8JQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2926
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH net-next 4/5] net: phy: add Lynx PCS MDIO module
>=20
> On Thu, Jun 18, 2020 at 03:08:36PM +0300, Ioana Ciornei wrote:
> > Add a Lynx PCS MDIO module which exposes the necessary operations to
> > drive the PCS using PHYLINK.
> >
> > The majority of the code is extracted from the Felix DSA driver, which
> > will be also modified in a later patch, and exposed as a separate
> > module for code reusability purposes.
> >
> > At the moment, USXGMII (only with in-band AN and speeds up to 2500),
> > SGMII, QSGMII and 2500Base-X (only w/o in-band AN) are supported by
> > the Lynx PCS MDIO module since these were also supported by Felix.
> >
> > The module can only be enabled by the drivers in need and not user
> > selectable.
>=20
> Is this the same PCS found in the LX2160A?  It looks very similar.
>=20

Yes, it is.
I already tested these protocols on LX2160A (and some other DPAA2 SoCs).
The idea is to have this patch set without any functional changes accepted =
and
then I will wire up dpaa2-eth as well into this.

> > +/* 2500Base-X is SerDes protocol 7 on Felix and 6 on ENETC. It is a
> > +SerDes lane
> > + * clocked at 3.125 GHz which encodes symbols with 8b/10b and does
> > +not have
> > + * auto-negotiation of any link parameters. Electrically it is
> > +compatible with
> > + * a single lane of XAUI.
> > + * The hardware reference manual wants to call this mode SGMII, but
> > +it isn't
> > + * really, since the fundamental features of SGMII:
> > + * - Downgrading the link speed by duplicating symbols
> > + * - Auto-negotiation
> > + * are not there.
>=20
> I welcome that others are waking up to the industry wide obfuscation of
> terminology surrounding "SGMII" and "1000base-X", and calling it out wher=
e it is
> blatently incorrectly described in documentation.

I will not take the credit for this since this is mainly just a comment bei=
ng moved.

>=20
> > + * The speed is configured at 1000 in the IF_MODE because the clock
> > + frequency
> > + * is actually given by a PLL configured in the Reset Configuration Wo=
rd
> (RCW).
> > + * Since there is no difference between fixed speed SGMII w/o AN and
> > + 802.3z w/o
> > + * AN, we call this PHY interface type 2500Base-X. In case a PHY
> > + negotiates a
> > + * lower link speed on line side, the system-side interface remains
> > + fixed at
> > + * 2500 Mbps and we do rate adaptation through pause frames.
>=20
> We have systems that do have AN with 2500base-X however - which is what y=
ou
> want when you couple two potentially remote systems over a fibre cable.  =
The
> AN in 802.3z (1000base-X) is used to negotiate:
>=20
> - duplex
> - pause mode
>=20
> although in practice, half-duplex is not supported by lots of hardware, w=
hich
> leaves just pause mode.  It is useful to have pause mode negotiation rema=
in
> present, whether it's 1000base-X or 2500base-X, but obviously within the
> hardware boundaries.
>=20
> I suspect the hardware is capable of supporting 802.3z AN when operating =
at
> 2500base-X, but not the SGMII symbol duplication for slower speeds.
>=20

I don't have a definitive answer to this this right now, I'll have to actua=
lly test this
if I can get my hands on some hardware for this setup.

> > +struct mdio_lynx_pcs *mdio_lynx_pcs_create(struct mdio_device
> > +*mdio_dev) {
> > +	struct mdio_lynx_pcs *pcs;
> > +
> > +	if (WARN_ON(!mdio_dev))
> > +		return NULL;
> > +
> > +	pcs =3D kzalloc(sizeof(*pcs), GFP_KERNEL);
> > +	if (!pcs)
> > +		return NULL;
> > +
> > +	pcs->dev =3D mdio_dev;
> > +	pcs->an_restart =3D lynx_pcs_an_restart;
> > +	pcs->get_state =3D lynx_pcs_get_state;
> > +	pcs->link_up =3D lynx_pcs_link_up;
> > +	pcs->config =3D lynx_pcs_config;
>=20
> We really should not have these private structure interfaces.  Private st=
ructure-
> based driver specific interfaces really don't constitute a sane approach =
to
> interface design.
>=20
> Would it work if there was a "struct mdio_device" add to the phylink_conf=
ig
> structure, and then you could have the phylink_pcs_ops embedded into this
> driver?

I think that would restrict too much the usage.
I am afraid there will be instances where the PCS is not recognizable by PH=
Y_ID,
thus no way of knowing which driver to probe which mdio_device.
Also, I would leave to the driver the choice of using (or not) the function=
s=20
exported by Lynx.

>=20
> If not, then we need some kind of mdio_pcs_device that offers this kind o=
f
> functionality.
>=20

Maybe we can meet in the middle?

What if we directly export the helper functions directly as symbols which c=
an
be used by the driver without any mdio_lynx_pcs in the middle
(just the mdio_device passed to the function).
This would be exactly as phylink_mii_c22_pcs_[an_restart/config] are curren=
tly
used.

We can somehow standardize the functions prototypes (which will likely mean
mdio_device instead of the phylink_pcs_ops's phylink_config).

Ioana
