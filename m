Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4A222F7BB
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 20:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730193AbgG0S1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 14:27:05 -0400
Received: from mail-eopbgr30055.outbound.protection.outlook.com ([40.107.3.55]:30439
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727886AbgG0S1F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 14:27:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=difafbEGkANn/RtvU8G9XkVHIH05Ag3cWSp9nGBXjEGo8HYBpOLeZoiwYclau8jkhkvDvFmnKM41a7jsmvShQGNhA5anw3JP+3Wpz1cFU1Y6adPojr3Z1FNnXNy0dTJvHobhmmX/Qx5jPjf6ALaZMmsVgdVysNoYAgb7ODKA+l8PyBCgaJv7xwmqnfVFCDQBdLh1+lSuavHD1eUuPD6I4n4staCODCKtxVNxnAht4J4UT219Ocwdmqx20HE3FmpQohEALnDaF3hIrPpMEWiPv+T3ooT4tqIm7V1djrH1waaDP/T64jqW77V5cMYvA2Ljcs7wEqsE66+kG6FLNh/WOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RgyMs88xb3xh9rj8fQmOv8iFhXXxx5LNoocjMRiIqbQ=;
 b=mUbcEcWQiJE2s/OvwglN2Zc8uI/CIxJ0xENY6TdY67WLPbSPS4LxzkMrVuZqS7XCLaZIxvD38ay+lodHClqfH8kN6u3J3kMUoYWjVtUKZ/T6JgZIeToZq+xAr4h+ysD5lJQcok3u4UOE+0VbCNfxWODdMcLJsZlQgSkApDe1p+Fsv8NkfPmjcYf6bc1kj4Kyjs0hO0O8gXno/ibdV36TO+pcrSCqrJS8K6z1kAnU4ks86B+EmnReTCDYTpHbXAIshPnxxboQ3e+SlfkwGVWoTmyrVGsaHRjZwFLNMlohcqgSrtbrssUJR/6RMNcFNrDde47NuXoOZS979ap+h/fxyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RgyMs88xb3xh9rj8fQmOv8iFhXXxx5LNoocjMRiIqbQ=;
 b=XWBiLM6SqjpeU1CGbyDqt/OMJ6SgmDDnGQEDqOQjgCOUZlVNVi2LEGaRdODEbojwZQxqvzCGmbD9ekjJwWILwX81zySmDebunKkqqXmI7144glU928jv6A7pEJQS3TD4mfEy7sCeV7DyXH3BRgYlLWtyG23NQR8nJ7u9wli1hxY=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR04MB5008.eurprd04.prod.outlook.com
 (2603:10a6:803:62::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Mon, 27 Jul
 2020 18:27:00 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::d4df:67d5:c1f7:fba]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::d4df:67d5:c1f7:fba%4]) with mapi id 15.20.3216.033; Mon, 27 Jul 2020
 18:27:00 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>
Subject: RE: [PATCH net-next v4 0/5] net: phy: add Lynx PCS MDIO module
Thread-Topic: [PATCH net-next v4 0/5] net: phy: add Lynx PCS MDIO module
Thread-Index: AQHWYZC4YCXOCeCZEUertSpJGVnGvakbw2SQ
Date:   Mon, 27 Jul 2020 18:27:00 +0000
Message-ID: <VI1PR0402MB38713F0EB239E7E1A42B9771E0720@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200724080143.12909-1-ioana.ciornei@nxp.com>
In-Reply-To: <20200724080143.12909-1-ioana.ciornei@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.95.40]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d278d987-2dd9-4672-03b9-08d8325aa741
x-ms-traffictypediagnostic: VI1PR04MB5008:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB5008F20F79928C7654DAAB3BE0720@VI1PR04MB5008.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h0+GnumcXtAjKJmzpCH8of+ldh7WWFKGet6aTgeVqkJabDNmTBMtENHh+spRs4XWk9Ht0S1UlPeozO90iBwJCwUPJ3u6whtfqtDOpDpn4dMHcTLBYEVEKjEGMwtz/IfoT3dBdU5VXZ51dY2vbgi4NC9RdPOpPTjRnZBXk0RAQizkLjR08PGCnP8znRpcTeFaQGrYPZ+nbP64ghS9rO0THq0W4QE3Sf8YT1pyYG+NYFeJeVyIljO99lMzOITVL9YbZwxfT0bhAYfGCXLXPm/Vfo0GMrDQRDUTYQYE5TlcKVzS0xoifKMdFH9qmiGpWOO3qyXjXginVEzJWhfArdkbDw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(136003)(376002)(346002)(366004)(478600001)(7696005)(33656002)(55016002)(66946007)(2906002)(26005)(44832011)(52536014)(66556008)(5660300002)(83380400001)(66446008)(64756008)(66476007)(76116006)(186003)(9686003)(6506007)(71200400001)(86362001)(8676002)(54906003)(316002)(4326008)(8936002)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: og+X0xwfEHHdt5xy+1iaVu4MvRKjk882I3A8C+LIncfdJwqT3ARjPjFfmSptxPdPlT7JAETh+oIqyOeDq6wZrfgueWegoGVAGhCM4ATSCjgb1oV0UbgY1orxgN5sU1IcmxA4YBFfyHBd86YkaO+ZZSi3ww0XuxyGpPjWB28uymMB0zQLJa88AqEDOklP6fC8kpGkOwCJJw0og+VTC+sWYgo6azUoCBbpakUJhfiPYds91IDDGgqzQ4RbS4MPFlJXQbq4KCKGdUOB24F5f5s5IN1E3QbBrK3yAlP04qRQjbHnWsqmrxKQHkZj60ECeYvQX77fI6m1wcSdASjxBpSjImtZhAStx6n0lSwXoVxUMH0reZ+s9ilDbz5XSSZ/X2jTA5/DhpauK7U9Nbim9GYf4oZ6G6uN84VuKd9WJMQAPiqD0CJZRXyF7QTNS4QRLLFosbbHcWpefBFatNL4X8axS63c6OANQZkVOk126c+dxDA=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d278d987-2dd9-4672-03b9-08d8325aa741
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2020 18:27:00.5707
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4L2DLnSML468q3H5GPqmSflwQnWKtMcJPiAD0y3hNbmLWRlkhHLDGLTnCVJyhN6LVHmoYaVX7kXDw1jC4jVg3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5008
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: [PATCH net-next v4 0/5] net: phy: add Lynx PCS MDIO module
>=20
> Add support for the Lynx PCS as a separate module in drivers/net/phy/.
> The advantage of this structure is that multiple ethernet or switch drive=
rs used
> on NXP hardware (ENETC, Seville, Felix DSA switch etc) can share the same
> implementation of PCS configuration and runtime management.
>=20
> The module implements phylink_pcs_ops and exports a phylink_pcs
> (incorporated into a lynx_pcs) which can be directly passed to phylink th=
rough
> phylink_pcs_set.
>=20
> The first 3 patches add some missing pieces in phylink and the locked mdi=
obus
> write accessor. Next, the Lynx PCS MDIO module is added as a standalone
> module. The majority of the code is extracted from the Felix DSA driver. =
The last
> patch makes the necessary changes in the Felix and Seville drivers in ord=
er to use
> the new common PCS implementation.
>=20
> At the moment, USXGMII (only with in-band AN), SGMII, QSGMII (with and
> without in-band AN) and 2500Base-X (only w/o in-band AN) are supported by=
 the
> Lynx PCS MDIO module since these were also supported by Felix and no
> functional change is intended at this time.
>=20

Any feedback on the use of phylink_pcs?

Thanks,
Ioana

> Changes in v2:
>  * got rid of the mdio_lynx_pcs structure and directly exported the  func=
tions
> without the need of an indirection
>  * made the necessary adjustments for this in the Felix DSA driver
>  * solved the broken allmodconfig build test by making the module  trista=
te
> instead of bool
>  * fixed a memory leakage in the Felix driver (the pcs structure was  all=
ocated
> twice)
>=20
> Changes in v3:
>  * added support for PHYLINK PCS ops in DSA (patch 5/9)
>  * cleanup in Felix PHYLINK operations and migrate to
>  phylink_mac_link_up() being the callback of choice for applying MAC
> configuration (patches 6-8)
>=20
> Changes in v4:
>  * use the newly introduced phylink PCS mechanism
>  * install the phylink_pcs in the phylink_mac_config DSA ops
>  * remove the direct implementations of the PCS ops
>  * do no use the SGMII_ prefix when referring to the IF_MORE register
>  * add a phylink helper to decode the USXGMII code word
>  * remove cleanup patches for Felix (these have been already accepted)
>  * Seville (recently introduced) now has PCS support through the same  Ly=
nx PCS
> module
>=20
> Ioana Ciornei (5):
>   net: phylink: add helper function to decode USXGMII word
>   net: phylink: consider QSGMII interface mode in
>     phylink_mii_c22_pcs_get_state
>   net: mdiobus: add clause 45 mdiobus write accessor
>   net: phy: add Lynx PCS module
>   net: dsa: ocelot: use the Lynx PCS helpers in Felix and Seville
>=20
>  MAINTAINERS                              |   7 +
>  drivers/net/dsa/ocelot/Kconfig           |   1 +
>  drivers/net/dsa/ocelot/felix.c           |  28 +-
>  drivers/net/dsa/ocelot/felix.h           |  20 +-
>  drivers/net/dsa/ocelot/felix_vsc9959.c   | 374 ++---------------------
>  drivers/net/dsa/ocelot/seville_vsc9953.c |  21 +-
>  drivers/net/phy/Kconfig                  |   6 +
>  drivers/net/phy/Makefile                 |   1 +
>  drivers/net/phy/pcs-lynx.c               | 314 +++++++++++++++++++
>  drivers/net/phy/phylink.c                |  44 +++
>  include/linux/mdio.h                     |   6 +
>  include/linux/pcs-lynx.h                 |  21 ++
>  include/linux/phylink.h                  |   3 +
>  13 files changed, 442 insertions(+), 404 deletions(-)  create mode 10064=
4
> drivers/net/phy/pcs-lynx.c  create mode 100644 include/linux/pcs-lynx.h
>=20
> --
> 2.25.1

