Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9271046011
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 16:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbfFNOJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 10:09:02 -0400
Received: from mail-eopbgr80081.outbound.protection.outlook.com ([40.107.8.81]:19038
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727382AbfFNOJC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 10:09:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QG27JHsgbclyI0aB89n36GqOnLCi+jhQDAfh+LizxSQ=;
 b=Ow5az637JmYV4nstdl1iwLdBiTEN0mtS1waLmcEZGn4zji+ii0k0z748z8jYsW+ZP2mi/nBDpmem/wXZhYVb/p3zi02uKeI0RFTCqfL0NaBX8O1I6YJKxw5GebW/BU7iny695cifbuhtgAVWjPg0IRXvbzCz4A9luX1x1Bk2Quo=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3901.eurprd04.prod.outlook.com (52.134.17.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.13; Fri, 14 Jun 2019 14:08:58 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::714d:36e8:3ca4:f188]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::714d:36e8:3ca4:f188%3]) with mapi id 15.20.1987.012; Fri, 14 Jun 2019
 14:08:58 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
Subject: RE: [PATCH RFC 4/6] dpaa2-mac: add initial driver
Thread-Topic: [PATCH RFC 4/6] dpaa2-mac: add initial driver
Thread-Index: AQHVIkOic0VlYNvv5k+vuQS/+20WvqaaYEuAgADEePA=
Date:   Fri, 14 Jun 2019 14:08:58 +0000
Message-ID: <VI1PR0402MB2800B4186EE51AE54149AF33E0EE0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1560470153-26155-1-git-send-email-ioana.ciornei@nxp.com>
 <1560470153-26155-5-git-send-email-ioana.ciornei@nxp.com>
 <20190614014223.GD28822@lunn.ch>
In-Reply-To: <20190614014223.GD28822@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [92.121.36.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ee50c83c-6869-43c6-36bf-08d6f0d1d84b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3901;
x-ms-traffictypediagnostic: VI1PR0402MB3901:
x-microsoft-antispam-prvs: <VI1PR0402MB3901D498705E3ACD7171A56EE0EE0@VI1PR0402MB3901.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0068C7E410
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(396003)(136003)(39860400002)(366004)(189003)(199004)(43544003)(55016002)(2906002)(6116002)(3846002)(53936002)(33656002)(316002)(6436002)(74316002)(6916009)(81166006)(9686003)(81156014)(8676002)(26005)(86362001)(186003)(71190400001)(71200400001)(256004)(14444005)(305945005)(476003)(11346002)(446003)(8936002)(44832011)(478600001)(7696005)(486006)(102836004)(76176011)(52536014)(5660300002)(6246003)(25786009)(54906003)(4326008)(7736002)(6506007)(68736007)(14454004)(66446008)(64756008)(66556008)(66476007)(66946007)(73956011)(76116006)(229853002)(66066001)(99286004)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3901;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vh1TPBdsZ9HIiGf1/Ad9qobf8aDbcOkgwYjlh5iXP42X5F1xgAhGzzMqOnA1A+4KuQP8/bcicQgW/FpDXhGhmr2SCtRPftaphnAbh4VyhuWKHgDx/IgThUX98F1Xbax5hHC0dIBbwahDXShwrkB2F2XSxhFCMz75jLODG4lyNwtfl1ML1N5DJVWf0WqyF7s53SPHqpZHSuFG7SD7RVAapLH6ri4LlkOZQE1IN/w8QBd2RY8TWgrfmb0naBQH97F38+MdH6+BybkNh5z5nr1/I7qE88K8YMmoMh59p1czKDLrXlYxfNTOPxOeZKKfKZIqmPMB7oG80LNQtPH9Z6AOMaX2g6+GqfKMpcAV9AzTJ+enIlNsvlXSs90li8CGB+jKIYdZBM6yV7fMuLU1rVag30X4kxPWMJg2g7T2bnzqkdQ=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee50c83c-6869-43c6-36bf-08d6f0d1d84b
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2019 14:08:58.5531
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ioana.ciornei@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3901
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH RFC 4/6] dpaa2-mac: add initial driver
>=20
> > +static phy_interface_t phy_mode(enum dpmac_eth_if eth_if) {
> > +	switch (eth_if) {
> > +	case DPMAC_ETH_IF_RGMII:
> > +		return PHY_INTERFACE_MODE_RGMII;
>=20
> So the MAC cannot insert RGMII delays? I didn't see anything in the PHY o=
bject
> about configuring the delays. Does the PCB need to add delays via squiggl=
es in
> the tracks?
>=20
> > +static void dpaa2_mac_validate(struct phylink_config *config,
> > +			       unsigned long *supported,
> > +			       struct phylink_link_state *state) {
> > +	struct dpaa2_mac_priv *priv =3D to_dpaa2_mac_priv(phylink_config);
> > +	struct dpmac_link_state *dpmac_state =3D &priv->state;
> > +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) =3D { 0, };
> > +
> > +	phylink_set(mask, Autoneg);
> > +	phylink_set_port_modes(mask);
> > +
> > +	switch (state->interface) {
> > +	case PHY_INTERFACE_MODE_10GKR:
> > +		phylink_set(mask, 10baseT_Full);
> > +		phylink_set(mask, 100baseT_Full);
> > +		phylink_set(mask, 1000baseT_Full);
> > +		phylink_set(mask, 10000baseT_Full);
> > +		break;
> > +	case PHY_INTERFACE_MODE_QSGMII:
> > +	case PHY_INTERFACE_MODE_RGMII:
> > +	case PHY_INTERFACE_MODE_RGMII_ID:
> > +	case PHY_INTERFACE_MODE_RGMII_RXID:
> > +	case PHY_INTERFACE_MODE_RGMII_TXID:
> > +		phylink_set(mask, 10baseT_Full);
> > +		phylink_set(mask, 100baseT_Full);
> > +		phylink_set(mask, 1000baseT_Full);
> > +		break;
> > +	case PHY_INTERFACE_MODE_USXGMII:
> > +		phylink_set(mask, 10baseT_Full);
> > +		phylink_set(mask, 100baseT_Full);
> > +		phylink_set(mask, 1000baseT_Full);
> > +		phylink_set(mask, 10000baseT_Full);
> > +		break;
> > +	default:
> > +		goto empty_set;
> > +	}
>=20
> I think this is wrong. This is about validating what the MAC can do. The =
state-
> >interface should not matter. The PHY will indicate what interface mode s=
hould
> be used when auto-neg has completed. The MAC is then expected to change i=
ts
> interface to fit.
>=20
> But lets see what Russell says.

We cannot do reconfiguration of the interface mode at runtime.
The SERDES speaks an ethernet/sata/pcie  coding that is configurable at res=
et time.

>=20
> > +static void dpaa2_mac_config(struct phylink_config *config, unsigned i=
nt
> mode,
> > +			     const struct phylink_link_state *state) {
> > +	struct dpaa2_mac_priv *priv =3D to_dpaa2_mac_priv(phylink_config);
> > +	struct dpmac_link_state *dpmac_state =3D &priv->state;
> > +	struct device *dev =3D &priv->mc_dev->dev;
> > +	int err;
> > +
> > +	if (state->speed =3D=3D SPEED_UNKNOWN && state->duplex =3D=3D
> DUPLEX_UNKNOWN)
> > +		return;
> > +
> > +	dpmac_state->up =3D !!state->link;
> > +	if (dpmac_state->up) {
> > +		dpmac_state->rate =3D state->speed;
> > +
> > +		if (!state->duplex)
> > +			dpmac_state->options |=3D
> DPMAC_LINK_OPT_HALF_DUPLEX;
> > +		else
> > +			dpmac_state->options &=3D
> ~DPMAC_LINK_OPT_HALF_DUPLEX;
> > +
> > +		if (state->an_enabled)
> > +			dpmac_state->options |=3D
> DPMAC_LINK_OPT_AUTONEG;
> > +		else
> > +			dpmac_state->options &=3D
> ~DPMAC_LINK_OPT_AUTONEG;
>=20
> As Russell pointed out, this auto-neg is only valid in a limited context.=
 The MAC
> generally does not perform auto-neg. The MAC is only involved in auto-neg
> when inband signalling is used between the MAC and PHY in 802.3z.
>=20
> As the name says, dpaa2_mac_config is about the MAC.
>=20
>    Andrew

Yes, the dpaa2_mac_config should take care of only the MAC but, in this cas=
e, we cannot convey
piecemeal link state information through the firmware to the Ethernet drive=
r - it has to come all at once.

--
Ioana

