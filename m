Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 551F51624C7
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 11:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgBRKmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 05:42:46 -0500
Received: from mail-eopbgr10063.outbound.protection.outlook.com ([40.107.1.63]:59156
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726298AbgBRKmq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 05:42:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EqMZeWp3pYdGhrZ91Mg89dd8cfJbojQBnhHsc59BqcSnIvrVQirf6AgKKMjLBN1uPk9oijufdKLk2uI7QiFx9/tjUlAe81sFVEmAA5npziAJOmHbgX2BjeG/5x324TwumsOig3czuKJzjIoEQNptP+KRkQ0MRnNjCFrd2MqONYN7y7uQnK1vkhqSQ1LCfZpxT1D1UwRN3lBfU20SziPq+UEM6HBj2VisH5s6lyRD6g7kt8tOPTv/lMHI7jHamzSoq5ocFL2rnLFhhucsjs34uQD8Y4Y+FsRLD2xPc3tuT8MnaBEJx8ki2dVBD9V7YOZxhwcPlUnbirdua04Iy4DpyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wuCf46v9U/4pIVLk1A42+ukt9UG7SKaYClRgs9TlbeM=;
 b=BIFAkFoJ42PyYc02Vfkd1ZqjRGn5RyhfH6c/vCkb0DZX4DtwFCCz2qqU/GZJuQxEyoioQffXHymKvSgJPdzqnEzFZkUnOKjVpY+qjKx7Ah5p9PgJfu+xn0ziWGdw7cHFDdLTWHQRrMab3KvDUmQXoDEL+TxWnWsc7mHSYZu2W6ymgO+tKay5CNdNJCzGrxbaKgQQTvDxzLn682n8LTHOj0CcpKXR/el4Px8yXP2F6rmP15H1fxUdMrkEQFuCIXY6nTZlSpxcrChvK3n1kWfRvQyO4NSGC7ohkYN+X34Lbst1SR5TvDz6gPNH00niHCGDXMNFAPELr3E3IP96mgOJ1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wuCf46v9U/4pIVLk1A42+ukt9UG7SKaYClRgs9TlbeM=;
 b=eOekWvim2rjhT7hc8a4cOTXSEo9OitA9IfmAWlC/xGx6DwCAOwQw+lafFDYVEey8xtDNE3kfoVl//LCSaoDO87mg6H8gF2A0qIs995IFUCdV9w30QzvArVAO+QwnFgMTdPF3j8oH4HfO9uPzLZ6mg9bXuQOen8SNCEoE2ghWSyo=
Received: from DB8PR04MB6828.eurprd04.prod.outlook.com (52.133.240.149) by
 DB8PR04MB6649.eurprd04.prod.outlook.com (20.179.248.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Tue, 18 Feb 2020 10:42:41 +0000
Received: from DB8PR04MB6828.eurprd04.prod.outlook.com
 ([fe80::9484:81c6:c73b:2697]) by DB8PR04MB6828.eurprd04.prod.outlook.com
 ([fe80::9484:81c6:c73b:2697%6]) with mapi id 15.20.2729.032; Tue, 18 Feb 2020
 10:42:41 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: RE: [CFT 5/8] net: dpaa2-mac: use resolved link config in
 mac_link_up()
Thread-Topic: [CFT 5/8] net: dpaa2-mac: use resolved link config in
 mac_link_up()
Thread-Index: AQHV5bcxlb7q6LK72026fB41sPY1+6ggwm4AgAAAU9A=
Date:   Tue, 18 Feb 2020 10:42:41 +0000
Message-ID: <DB8PR04MB6828ECB9945F747281C5796EE0110@DB8PR04MB6828.eurprd04.prod.outlook.com>
References: <20200217172242.GZ25745@shell.armlinux.org.uk>
 <E1j3k80-00072W-E5@rmk-PC.armlinux.org.uk>
 <20200218103400.GF25745@shell.armlinux.org.uk>
In-Reply-To: <20200218103400.GF25745@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ee67e5a1-24e1-441a-6a26-08d7b45f47a0
x-ms-traffictypediagnostic: DB8PR04MB6649:
x-microsoft-antispam-prvs: <DB8PR04MB6649C9560593EC66026BAF06E0110@DB8PR04MB6649.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 031763BCAF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(366004)(136003)(39860400002)(396003)(199004)(189003)(44832011)(186003)(55016002)(6916009)(86362001)(6506007)(5660300002)(966005)(8676002)(81156014)(81166006)(4326008)(45080400002)(478600001)(26005)(66476007)(54906003)(33656002)(7696005)(8936002)(66446008)(64756008)(66556008)(76116006)(9686003)(2906002)(52536014)(71200400001)(316002)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB6649;H:DB8PR04MB6828.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YNB7yQqvIcdr7DkkFJlZjd5NCtpKXvpJP1J+yST+bz0FLjpZ6BeiX1UkvkXzH6B3MgycydGtTh0/Moe4uEH8gNvQeGDp1+mypGp2MkyNGBYAcpO5dUL2qKVGtZcQG1bOXQh7FoQptcGRMQIYwfqnGaLPuYq2z1V9dwXAi6Ihdz3e67+QSrg9ZeH0LqCzjr+vNEH/8Hvvipq3fARjxD1rbvW5edK2IAPXqNQt5pLLSLHSdkIe6KhkX+1iVz0AwoFINiKoUbBprRXegornTByPKWVxW/4KQ4k9Rgow5c6zjnX2fYxHXjleMWvmUIXGjVRPom10rj5q/19wmMmq4nD5y+Ag2OBAbe/tWTG+rOBsywvMpPDKUkxFYIY6tKnYfrYt3nIjiEf5IUlSYsOmbZUWxgLWBOCkkeyPLVSgo+XFIHVrl4+ZeR0m1Ah0p7mttF2gl07f7gxXhmOnUavPY4SJi2i5wukzeeGOAAy1Ddlag+hRN2nAWS/VtS6Mc6fZQQ/UXea2iDcwc83jVZIa1qXqlA==
x-ms-exchange-antispam-messagedata: Fhwymlbzmjhf+WWKS4SpAfy/VjTLlAywOIGMVhvQLZaHNDDrtFS0//hd7Ryqpd3Qo9dJ/7dBIn02qwPwYPNjfMdnkfTsN16sLo/7HPRwUuStUPl+dw8SRLCaUtdtgz44FKMyUr1wVHsbYE4O9UL3Sw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee67e5a1-24e1-441a-6a26-08d7b45f47a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2020 10:42:41.1558
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1BMaZhCYVB99VM559YmelPsNLOePcSREIH13OriZj8wp7wjlUrUTC8cxqrfzfaaxPbQ/e75f4/zs2cRXZZ1UMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6649
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [CFT 5/8] net: dpaa2-mac: use resolved link config in mac_li=
nk_up()
>=20
> It would really help if MAINTAINERS were updated with the correct informa=
tion
> for this driver:
>=20
> DPAA2 ETHERNET DRIVER
> M:      Ioana Radulescu <ruxandra.radulescu@nxp.com>
>=20
> This address bounces.  Given what I find in the git history, is the corre=
ct person is
> now:
>=20
> Ioana Ciornei <ioana.ciornei@nxp.com>
>=20
> Please submit a patch updating MAINTAINERS.  Thanks.

Sure thing.  I'll update the MAINTAINERS file and list myself instead of Io=
ana Radulescu.

>=20
> On Mon, Feb 17, 2020 at 05:24:16PM +0000, Russell King wrote:
> > Convert the DPAA2 ethernet driver to use the finalised link parameters
> > in mac_link_up() rather than the parameters in mac_config(), which are
> > more suited to the needs of the DPAA2 MC firmware than those available
> > via mac_config().
> >
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > ---
> >  .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 54
> > +++++++++++--------  .../net/ethernet/freescale/dpaa2/dpaa2-mac.h  |
> > 1 +
> >  2 files changed, 33 insertions(+), 22 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> > b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> > index 3a75c5b58f95..3ee236c5fc37 100644
> > --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> > +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> > @@ -123,35 +123,16 @@ static void dpaa2_mac_config(struct phylink_confi=
g
> *config, unsigned int mode,
> >  	struct dpmac_link_state *dpmac_state =3D &mac->state;
> >  	int err;
> >
> > -	if (state->speed !=3D SPEED_UNKNOWN)
> > -		dpmac_state->rate =3D state->speed;
> > -
> > -	if (state->duplex !=3D DUPLEX_UNKNOWN) {
> > -		if (!state->duplex)
> > -			dpmac_state->options |=3D
> DPMAC_LINK_OPT_HALF_DUPLEX;
> > -		else
> > -			dpmac_state->options &=3D
> ~DPMAC_LINK_OPT_HALF_DUPLEX;
> > -	}
> > -
> >  	if (state->an_enabled)
> >  		dpmac_state->options |=3D DPMAC_LINK_OPT_AUTONEG;
> >  	else
> >  		dpmac_state->options &=3D ~DPMAC_LINK_OPT_AUTONEG;
> >
> > -	if (state->pause & MLO_PAUSE_RX)
> > -		dpmac_state->options |=3D DPMAC_LINK_OPT_PAUSE;
> > -	else
> > -		dpmac_state->options &=3D ~DPMAC_LINK_OPT_PAUSE;
> > -
> > -	if (!!(state->pause & MLO_PAUSE_RX) ^ !!(state->pause &
> MLO_PAUSE_TX))
> > -		dpmac_state->options |=3D DPMAC_LINK_OPT_ASYM_PAUSE;
> > -	else
> > -		dpmac_state->options &=3D ~DPMAC_LINK_OPT_ASYM_PAUSE;
> > -
> >  	err =3D dpmac_set_link_state(mac->mc_io, 0,
> >  				   mac->mc_dev->mc_handle, dpmac_state);
> >  	if (err)
> > -		netdev_err(mac->net_dev, "dpmac_set_link_state() =3D %d\n",
> err);
> > +		netdev_err(mac->net_dev, "%s: dpmac_set_link_state() =3D
> %d\n",
> > +			   __func__, err);
> >  }
> >
> >  static void dpaa2_mac_link_up(struct phylink_config *config, @@
> > -165,10 +146,37 @@ static void dpaa2_mac_link_up(struct phylink_config
> *config,
> >  	int err;
> >
> >  	dpmac_state->up =3D 1;
> > +
> > +	if (mac->if_link_type =3D=3D DPMAC_LINK_TYPE_PHY) {
> > +		/* If the DPMAC is configured for PHY mode, we need
> > +		 * to pass the link parameters to the MC firmware.
> > +		 */
> > +		dpmac_state->rate =3D speed;
> > +
> > +		if (duplex =3D=3D DUPLEX_HALF)
> > +			dpmac_state->options |=3D
> DPMAC_LINK_OPT_HALF_DUPLEX;
> > +		else if (duplex =3D=3D DUPLEX_FULL)
> > +			dpmac_state->options &=3D
> ~DPMAC_LINK_OPT_HALF_DUPLEX;
> > +
> > +		/* This is lossy; the firmware really should take the pause
> > +		 * enablement status rather than pause/asym pause status.
> > +		 */
> > +		if (rx_pause)
> > +			dpmac_state->options |=3D DPMAC_LINK_OPT_PAUSE;
> > +		else
> > +			dpmac_state->options &=3D ~DPMAC_LINK_OPT_PAUSE;
> > +
> > +		if (rx_pause ^ tx_pause)
> > +			dpmac_state->options |=3D
> DPMAC_LINK_OPT_ASYM_PAUSE;
> > +		else
> > +			dpmac_state->options &=3D
> ~DPMAC_LINK_OPT_ASYM_PAUSE;
> > +	}
> > +
> >  	err =3D dpmac_set_link_state(mac->mc_io, 0,
> >  				   mac->mc_dev->mc_handle, dpmac_state);
> >  	if (err)
> > -		netdev_err(mac->net_dev, "dpmac_set_link_state() =3D %d\n",
> err);
> > +		netdev_err(mac->net_dev, "%s: dpmac_set_link_state() =3D
> %d\n",
> > +			   __func__, err);
> >  }
> >
> >  static void dpaa2_mac_link_down(struct phylink_config *config, @@
> > -241,6 +249,8 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
> >  		goto err_close_dpmac;
> >  	}
> >
> > +	mac->if_link_type =3D attr.link_type;
> > +
> >  	dpmac_node =3D dpaa2_mac_get_node(attr.id);
> >  	if (!dpmac_node) {
> >  		netdev_err(net_dev, "No dpmac@%d node found.\n", attr.id);
> diff
> > --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
> > b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
> > index 4da8079b9155..2130d9c7d40e 100644
> > --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
> > +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
> > @@ -20,6 +20,7 @@ struct dpaa2_mac {
> >  	struct phylink_config phylink_config;
> >  	struct phylink *phylink;
> >  	phy_interface_t if_mode;
> > +	enum dpmac_link_type if_link_type;
> >  };
> >
> >  bool dpaa2_mac_is_type_fixed(struct fsl_mc_device *dpmac_dev,
> > --
> > 2.20.1
> >
> >
>=20
> --
> RMK's Patch system:
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fwww.a=
r
> mlinux.org.uk%2Fdeveloper%2Fpatches%2F&amp;data=3D02%7C01%7Cioana.cior
> nei%40nxp.com%7C09d0167191914135433808d7b45e15fd%7C686ea1d3bc2b4
> c6fa92cd99c5c301635%7C0%7C0%7C637176188497544105&amp;sdata=3Dt0%2B
> OzkoqRM180UHGBrW6FYAvHsIelx4CaP4oC3QcP1k%3D&amp;reserved=3D0
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbp=
s up
> According to speedtest.net: 11.9Mbps down 500kbps up
