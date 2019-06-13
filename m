Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24FDE43F1C
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390061AbfFMPyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:54:19 -0400
Received: from mail-eopbgr60040.outbound.protection.outlook.com ([40.107.6.40]:59457
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731576AbfFMIzT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 04:55:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M76f60ha0lnEWvqEVu9noFnebjvgVHu7XTHLsdXOL1g=;
 b=A5En9fPSG8gsFBhU95ukqIz2n3tFewu2WI2i9SnwYxSVvTuBlSD5OYy3lolTIAY6wT+zwd2YIzYmD7l+mkTaHsbIZdR1zXGcK5mPwglNlCPDes06Dj2gxIb9/fOik6OaB4xj2iBz+RpDOTyAvQsGM2lSl74iRTJK6ccFgQyDWxE=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3421.eurprd04.prod.outlook.com (52.134.3.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.15; Thu, 13 Jun 2019 08:55:16 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::714d:36e8:3ca4:f188]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::714d:36e8:3ca4:f188%3]) with mapi id 15.20.1987.012; Thu, 13 Jun 2019
 08:55:16 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] net: phylink: set the autoneg state in phylink_phy_change
Thread-Topic: [PATCH] net: phylink: set the autoneg state in
 phylink_phy_change
Thread-Index: AQHVIbKP9yXQ7A3ipUiyPT36szP9naaZPIMAgAAIqNA=
Date:   Thu, 13 Jun 2019 08:55:16 +0000
Message-ID: <VI1PR0402MB2800B6F4FC9C90C96E22979AE0EF0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1560407871-5642-1-git-send-email-ioana.ciornei@nxp.com>
 <20190613081400.2cicsjpslxoidoox@shell.armlinux.org.uk>
In-Reply-To: <20190613081400.2cicsjpslxoidoox@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 65d365d3-bf86-49db-bc3b-08d6efdcdacd
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3421;
x-ms-traffictypediagnostic: VI1PR0402MB3421:
x-microsoft-antispam-prvs: <VI1PR0402MB3421C12E0EC9DA9C8A56BA23E0EF0@VI1PR0402MB3421.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(39860400002)(376002)(346002)(366004)(189003)(199004)(6246003)(52536014)(66946007)(73956011)(26005)(53936002)(76116006)(316002)(99286004)(14454004)(81166006)(476003)(81156014)(4326008)(2906002)(44832011)(186003)(6916009)(68736007)(5660300002)(74316002)(229853002)(66066001)(66476007)(66556008)(64756008)(66446008)(102836004)(6436002)(6506007)(3846002)(6116002)(446003)(486006)(11346002)(55016002)(86362001)(7736002)(76176011)(33656002)(305945005)(25786009)(54906003)(71190400001)(71200400001)(256004)(8676002)(7696005)(9686003)(8936002)(478600001)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3421;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8wV5c36zQX8S0LVxhQKXcVguWRYQWJsGyi39MoDr3c1hrljbkWAXxRHQGSHzhfjaKzvyrJKswkQLT2e7zCzkKRvjrL+N25OiVP147jOWh30neMmVTPQBleycBZpwFbpwYVDAD5uFkjdC/4SDFvuC9SRrzoJ4z7i9JYS9+0/NpSrRqeTjOe//E5j9syUqRPmHT7NDrU66PvrcbDWmmP0JbKI+Vz25TmgNcSCIABpfsBKflNuc0CgCw9294pBcfpcY16MTa7xVuYafbWiiy+oW1hSE7JaoNS2TLDOHT6YI71T9qv+AOeMA4Qfw/f5TFXePuUwdqS25zcUXgtqXbEA8wynHpFmQ2ZGXqFVtQ9R6MuiFZP6DbaCS7sCcsmBsl3J+sujxi3Vg52BvLmXnhrJcmXjqafIPG1H5FhnqYuG2lN0=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65d365d3-bf86-49db-bc3b-08d6efdcdacd
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 08:55:16.1312
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ioana.ciornei@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3421
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH] net: phylink: set the autoneg state in
> phylink_phy_change
>=20
> On Thu, Jun 13, 2019 at 09:37:51AM +0300, Ioana Ciornei wrote:
> > The phy_state field of phylink should carry only valid information
> > especially when this can be passed to the .mac_config callback.
> > Update the an_enabled field with the autoneg state in the
> > phylink_phy_change function.
>=20
> an_enabled is meaningless to mac_config for PHY mode.  Why do you think
> this is necessary?

Well, it's not necessarily used in PHY mode but, from my opinion, it should=
 be set to the correct value nonetheless.

Just to give you more context, I am working on adding phylink support on NX=
P's DPAA2 platforms where any interaction between the PHY management layer =
and the Ethernet devices is made through a firmware.
When the .mac_config callback is invoked, the driver communicates the new c=
onfiguration to the firmware so that the corresponding net_device can see t=
he correct info.
In this case, the an_enabled field is not used for other purpose than to in=
form the net_device of the current configuration and nothing more.

--
Ioana


>=20
> >
> > Fixes: 9525ae83959b ("phylink: add phylink infrastructure")
> > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > ---
> >  drivers/net/phy/phylink.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> > index 5d0af041b8f9..dd1feb7b5472 100644
> > --- a/drivers/net/phy/phylink.c
> > +++ b/drivers/net/phy/phylink.c
> > @@ -688,6 +688,7 @@ static void phylink_phy_change(struct phy_device
> *phydev, bool up,
> >  		pl->phy_state.pause |=3D MLO_PAUSE_ASYM;
> >  	pl->phy_state.interface =3D phydev->interface;
> >  	pl->phy_state.link =3D up;
> > +	pl->phy_state.an_enabled =3D phydev->autoneg;
> >  	mutex_unlock(&pl->state_mutex);
> >
> >  	phylink_run_resolve(pl);
> > --
> > 1.9.1
> >
> >

