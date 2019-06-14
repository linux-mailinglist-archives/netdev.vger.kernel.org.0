Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5975A4650F
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 18:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbfFNQzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 12:55:06 -0400
Received: from mail-eopbgr140053.outbound.protection.outlook.com ([40.107.14.53]:50754
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725801AbfFNQzF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 12:55:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bcN/PHZ2GeSg3BO0oqo7dKV65yFSAldTrIAbcfI6Zlk=;
 b=H2sn2MCPDI4nlIjaLcsZMzjzBkPnsa1of8ATbStp/ZnBpMOZJJBr/jkRNKWi66tMPy89L+sHy96H6mviiPwpdHzs2kZt2Sctj5uWgJDL/7qLN7JZbO1LvcDEswMw4uS0sfE8W7zaRJ2HhcvkBB6QWSUCWgZ8faUyFR8AAKEHvWU=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1SPR01MB0378.eurprd04.prod.outlook.com (20.179.209.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Fri, 14 Jun 2019 16:54:56 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::714d:36e8:3ca4:f188]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::714d:36e8:3ca4:f188%3]) with mapi id 15.20.1987.012; Fri, 14 Jun 2019
 16:54:56 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
CC:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
Subject: RE: [PATCH RFC 4/6] dpaa2-mac: add initial driver
Thread-Topic: [PATCH RFC 4/6] dpaa2-mac: add initial driver
Thread-Index: AQHVIkOic0VlYNvv5k+vuQS/+20WvqaaYEuAgACIT4CAAG4lcA==
Date:   Fri, 14 Jun 2019 16:54:56 +0000
Message-ID: <VI1PR0402MB2800FA7EF554B855F3B90353E0EE0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1560470153-26155-1-git-send-email-ioana.ciornei@nxp.com>
 <1560470153-26155-5-git-send-email-ioana.ciornei@nxp.com>
 <20190614014223.GD28822@lunn.ch>
 <20190614095015.mhs723furhhsaclo@shell.armlinux.org.uk>
In-Reply-To: <20190614095015.mhs723furhhsaclo@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [92.121.36.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 39cb64e1-cb32-4359-a1fe-08d6f0e907c4
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1SPR01MB0378;
x-ms-traffictypediagnostic: VI1SPR01MB0378:
x-microsoft-antispam-prvs: <VI1SPR01MB0378263D32904967CBEBF0B8E0EE0@VI1SPR01MB0378.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0068C7E410
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39860400002)(136003)(366004)(346002)(376002)(189003)(199004)(2906002)(9686003)(99286004)(476003)(486006)(7736002)(305945005)(44832011)(316002)(66556008)(66446008)(66476007)(64756008)(14454004)(53936002)(478600001)(71190400001)(76116006)(73956011)(71200400001)(66946007)(4326008)(6246003)(186003)(6436002)(6506007)(446003)(68736007)(8676002)(110136005)(54906003)(5660300002)(256004)(229853002)(81166006)(102836004)(33656002)(11346002)(8936002)(66066001)(81156014)(26005)(52536014)(55016002)(25786009)(14444005)(6116002)(3846002)(74316002)(86362001)(76176011)(7696005)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1SPR01MB0378;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: DMwvXCKWZwZKmGt9oFtTVqhBPC52QLNrqnvIRnhK2IGjFhGb2jzWrJywVprAtMmEvUTUFGe1R2oHs6tc0VEj7RPQb5kP0rBAy5C9vyjqBgnUC01Zk7DXYO8a+PoTCVKo09rFIjaZFCKv+9chWTKbELX+yDCV4lf66lonZTUpwq+Whk25IJbxNMOJB+7bFgAk3+EuLM3qPJXPI0iA/C6odkNcNnabmehPisvPL4TnJPCTDuuXrz62F4GnTRd8HhnZ2BIpKUq8df4KN6Jn+E4JyDJUnv+auKIznWzWe94lKwu7lW8RUoqTMdTw60FagAaVwD1zl4RcxbXq+53h505gwYrY7mnhXd5t0rQYbVlbPprkv/uxAZ2TYuiU5TRZzKKLlkG5OTQhHtcxplfLsKc+9ZHoWDzHbz8A2JZJ04Yid+8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39cb64e1-cb32-4359-a1fe-08d6f0e907c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2019 16:54:56.6365
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ioana.ciornei@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1SPR01MB0378
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH RFC 4/6] dpaa2-mac: add initial driver
>=20
> On Fri, Jun 14, 2019 at 03:42:23AM +0200, Andrew Lunn wrote:
> > > +static phy_interface_t phy_mode(enum dpmac_eth_if eth_if) {
> > > +	switch (eth_if) {
> > > +	case DPMAC_ETH_IF_RGMII:
> > > +		return PHY_INTERFACE_MODE_RGMII;
> >
> > So the MAC cannot insert RGMII delays? I didn't see anything in the
> > PHY object about configuring the delays. Does the PCB need to add
> > delays via squiggles in the tracks?
> >
> > > +static void dpaa2_mac_validate(struct phylink_config *config,
> > > +			       unsigned long *supported,
> > > +			       struct phylink_link_state *state) {
> > > +	struct dpaa2_mac_priv *priv =3D to_dpaa2_mac_priv(phylink_config);
> > > +	struct dpmac_link_state *dpmac_state =3D &priv->state;
> > > +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) =3D { 0, };
> > > +
> > > +	phylink_set(mask, Autoneg);
> > > +	phylink_set_port_modes(mask);
> > > +
> > > +	switch (state->interface) {
> > > +	case PHY_INTERFACE_MODE_10GKR:
> > > +		phylink_set(mask, 10baseT_Full);
> > > +		phylink_set(mask, 100baseT_Full);
> > > +		phylink_set(mask, 1000baseT_Full);
> > > +		phylink_set(mask, 10000baseT_Full);
> > > +		break;
>=20
> How does 10GBASE-KR mode support these lesser speeds - 802.3 makes no
> provision for slower speeds for a 10GBASE-KR link, it is a fixed speed li=
nk.  I
> don't see any other possible phy interface mode supported that would allo=
w
> for the 1G, 100M and 10M speeds (i.o.w. SGMII).  If SGMII is not supporte=
d,
> then how do you expect these other speeds to work?
>=20
> Does your PHY do speed conversion - if so, we need to come up with a much
> better way of handling that (we need phylib to indicate that the PHY is s=
o
> capable.)

These are PHYs connected using an XFI interface that indeed can operate at =
lower
speeds and are capable of rate adaptation using pause frames.

Also, I've used PHY_INTERFACE_MODE_10GKR since a dedicated XFI mode is not =
available.
=20
>=20
> > > +	case PHY_INTERFACE_MODE_QSGMII:
> > > +	case PHY_INTERFACE_MODE_RGMII:
> > > +	case PHY_INTERFACE_MODE_RGMII_ID:
> > > +	case PHY_INTERFACE_MODE_RGMII_RXID:
> > > +	case PHY_INTERFACE_MODE_RGMII_TXID:
> > > +		phylink_set(mask, 10baseT_Full);
> > > +		phylink_set(mask, 100baseT_Full);
> > > +		phylink_set(mask, 1000baseT_Full);
> > > +		break;
> > > +	case PHY_INTERFACE_MODE_USXGMII:
> > > +		phylink_set(mask, 10baseT_Full);
> > > +		phylink_set(mask, 100baseT_Full);
> > > +		phylink_set(mask, 1000baseT_Full);
> > > +		phylink_set(mask, 10000baseT_Full);
> > > +		break;
> > > +	default:
> > > +		goto empty_set;
> > > +	}
> >
> > I think this is wrong. This is about validating what the MAC can do.
> > The state->interface should not matter. The PHY will indicate what
> > interface mode should be used when auto-neg has completed. The MAC is
> > then expected to change its interface to fit.
>=20
> The question is whether a PHY/MAC wired up using a particular topology ca=
n
> switch between other interface types.
>=20
> For example, SGMII, 802.3z and 10GBASE-KR all use a single serdes lane
> which means that as long as both ends are configured for the same protoco=
l,
> the result should work.  As an example, Marvell 88x3310 PHYs switch
> between these three modes depending on the negotiated speed.
>=20
> So, this is more to do with saying what the MAC can support with a partic=
ular
> wiring topology rather than the strict PHY interface type.
>=20
> Take mvneta:
>=20
>         /* Half-duplex at speeds higher than 100Mbit is unsupported */
>         if (pp->comphy || state->interface !=3D
> PHY_INTERFACE_MODE_2500BASEX) {
>                 phylink_set(mask, 1000baseT_Full);
>                 phylink_set(mask, 1000baseX_Full);
>         }
>         if (pp->comphy || state->interface =3D=3D
> PHY_INTERFACE_MODE_2500BASEX) {
>                 phylink_set(mask, 2500baseX_Full);
>         }
>=20
> If we have a comphy, we can switch the MAC speed between 1G and 2.5G
> here, so we allow both 1G and 2.5G to be set in the supported mask.
>=20
> If we do not have a comphy, we are not able to change the MAC speed at
> runtime, so we are more restrictive with the support mask.
>=20
> > > +static void dpaa2_mac_config(struct phylink_config *config, unsigned
> int mode,
> > > +			     const struct phylink_link_state *state) {
> > > +	struct dpaa2_mac_priv *priv =3D to_dpaa2_mac_priv(phylink_config);
> > > +	struct dpmac_link_state *dpmac_state =3D &priv->state;
> > > +	struct device *dev =3D &priv->mc_dev->dev;
> > > +	int err;
> > > +
> > > +	if (state->speed =3D=3D SPEED_UNKNOWN && state->duplex =3D=3D
> DUPLEX_UNKNOWN)
> > > +		return;
>=20
> As I've already pointed out, state->speed and state->duplex are only vali=
d
> for fixed-link and PHY setups.  They are not valid for SGMII and 802.3z, =
which
> use in-band configuration/negotiation, but then in your validate callback=
, it
> seems you don't support these.
>=20
> Since many SFP modules require SGMII and 802.3z, I wonder how this is
> going to work.
>=20
> > > +
> > > +	dpmac_state->up =3D !!state->link;
> > > +	if (dpmac_state->up) {
>=20
> No, whether the link is up or down is not a concern for this function, an=
d it's
> not guaranteed to be valid here.

Agreed. We can just remove that.

>=20
> I can see I made a bad choice when designing this interface - it was simp=
ler to
> have just one structure for reading the link state from the MAC and setti=
ng
> the configuration, because the two were very similar.
>=20
> I can see I should've made them separate and specific to each call (which
> would necessitate additional code, but for the sake of enforcing correct
> programming interface usage, it would've been the right thing.)
>=20
> > > +		dpmac_state->rate =3D state->speed;
> > > +
> > > +		if (!state->duplex)
> > > +			dpmac_state->options |=3D
> DPMAC_LINK_OPT_HALF_DUPLEX;
> > > +		else
> > > +			dpmac_state->options &=3D
> ~DPMAC_LINK_OPT_HALF_DUPLEX;
> > > +
> > > +		if (state->an_enabled)
> > > +			dpmac_state->options |=3D
> DPMAC_LINK_OPT_AUTONEG;
> > > +		else
> > > +			dpmac_state->options &=3D
> ~DPMAC_LINK_OPT_AUTONEG;
> >
> > As Russell pointed out, this auto-neg is only valid in a limited
> > context. The MAC generally does not perform auto-neg. The MAC is only
> > involved in auto-neg when inband signalling is used between the MAC
> > and PHY in 802.3z.
>=20
> or SGMII.
>=20
> --

