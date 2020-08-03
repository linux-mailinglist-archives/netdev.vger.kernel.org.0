Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D542F23A820
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 16:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbgHCOL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 10:11:57 -0400
Received: from mail-eopbgr40065.outbound.protection.outlook.com ([40.107.4.65]:23479
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728258AbgHCOL4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 10:11:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V28iOwZXGOAqbWmoXuotD0uOfjR4+n7RlKFKLM1befVCz9RWn14w0d7zXr+92Q2r0Q64gC4J0TVz+qKzDR4eYLB14tk7cSY7Ov4CJM+pOzmneg0VgDoj8VqBD5kkBXOidEDLAE55IaChxTallWWDwOC0VF7ZrQ2Lh7/tQ966RCLWxReO6r0u+fH4lp9pKxhL5GDjQpk/Jd4+GI2KSML1TUpVrGWI9WST+fbd/pEBEOhdU9cgXzuF069xkgC4C+IhRTy2Fd5N+g5iWBKShOVNYh4m89hmM2Fsu3Jfqhim/IaPEL6jxccYp65oivNGkHohbDtYEA65f/Lq5DUZkRdw6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ftGGC7lgw7ls7kJMO7GSjZlpxRwmnYnBgXDRAuPEgdw=;
 b=DjuhNY8GqSjspFBYuT/v4pgxCOSVsM3EqNjJeMZtNR5B6wCJggj32QIo6pogXNfXxZhBSsDVUsmXzGsYsY5tski+ABMXlHkTFrFf+sIL73O52wviq1wIgPKbjhh9HBJ4ocClQsL1wwHZvzOi/5sgm0gPxis/96yTubREu5y039FEarULM9RVsMMY3ioahHsO5zJybexlrAA77CIRmkOe95PfvFijgXexqKCpAbJ9mUzBD50deVpwcdb1XgssDezZCxeadv0Fnz9DpH79+ioQLCYEZkwFJahHnkFWMpzzXlzaCfKo6CxcuUKg1MKOncvF3f8NfbDpln+dhsDN8RMZNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ftGGC7lgw7ls7kJMO7GSjZlpxRwmnYnBgXDRAuPEgdw=;
 b=L4wQM9i0umzruFkdHHrQ0orPNZwxrHXLtRq7T1r0E2FhnYMHDKg21u3J5QXOr6jA0XFDIURNc/97WY/t+CmdXJIVdy+sbJGoT8ayFuusI9KCEMTLbLxmWaIEmrE2GZLfa6/9TEBDb/YEl7FKfl/7rA0eaxlLextXCU0cfO8Li6A=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by AM6PR04MB5415.eurprd04.prod.outlook.com (2603:10a6:20b:93::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Mon, 3 Aug
 2020 14:11:10 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::f5cb:bc18:1991:c31f]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::f5cb:bc18:1991:c31f%2]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 14:11:10 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>
CC:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: RE: [PATCH RFC net-next 2/3] net: phy: Move into subdirectories
Thread-Topic: [PATCH RFC net-next 2/3] net: phy: Move into subdirectories
Thread-Index: AQHWZFc25SjonBVpqU+qj/KfQfAVU6kmdqhA
Date:   Mon, 3 Aug 2020 14:11:10 +0000
Message-ID: <AM6PR04MB3976B8E1672E74D127BAD833EC4D0@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <20200727204731.1705418-1-andrew@lunn.ch>
 <20200727204731.1705418-3-andrew@lunn.ch>
In-Reply-To: <20200727204731.1705418-3-andrew@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=oss.nxp.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [82.76.227.152]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4703db5f-ab07-4b15-dede-08d837b712cc
x-ms-traffictypediagnostic: AM6PR04MB5415:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB5415510B459FD03149C9C46CAD4D0@AM6PR04MB5415.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mSUzeb9iMgSxQmKQIvzf/ih/Zd5jApQ6bCO7iHlnyT62HKvxvoRupgw4ClVMEdrM40jG6Ks50b24XbI1V1gTKmDVnNk9hpl1zGSZVk3eH9M3+kshePT3Pt8jcYe6gnmdtadSxuzYUz/GCrYIMU2QKDvMMUJrjgR0Dt44NwgIC4VrPz7SU40hqlp6jpTcAJw+6VaQuTHT/OQTF2VjTA80Y8gKDd6KK1H7FkSNywKZibxDFlGgsmbPz/L8rDK5Nd5ayuoMjBcA+RX2gsrUk7z/eCfe4Qc2y6dEnjb7jfiw57Tutb4+sUQo8jOqsbYHl+u7fYD+UDbEysTPzETEhXd8Iw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(366004)(136003)(39860400002)(396003)(64756008)(186003)(26005)(6506007)(53546011)(66476007)(76116006)(66556008)(66446008)(30864003)(66946007)(71200400001)(52536014)(5660300002)(83380400001)(7696005)(8676002)(55016002)(316002)(86362001)(4326008)(33656002)(478600001)(9686003)(8936002)(54906003)(110136005)(2906002)(559001)(579004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Tn43NoGkkO+iIqzADoF8bgL7XNyTQALpNAFvIqTDPBw+zAuKisSAj14G7I4bvoogK0UPb0+7+3J5vPruMWmJZ/x3ckq66QanB47n8esRw8yhYPOg+hT/iWlCwqxPT2cqd/Df5q8brzLNQxMxT4P6zfMJtMGoXBAG1gOkbjlJqG200MsDqUW/yfCTCVBtgbh/jC0KNOJnvjf4Y/o+BceRyoVj1xgnyNmB4jdI3mA2wjd9PQtMED1yF9cOf3s3N2NHsq3Bnqv6wJ42yZS3JuHevz/TVKp3Lb5vl1iG8CwlPciidx8NPclSi/dDVDOL2QcIXCR5yqLexKV+k857sBpHqfhbG3LqKmkiGPFgWs0DmZody0FoO7GdFwA+BMgocliGtSsmAq34mLzP/Ur+o3h2ab87FrOwV5ueFM5G8GJvT+lYQf1I1d/TDixFgKoMjlhMHGTyylJzA8365Zzmkcre5CkIOXt4ASOmRQ0xHqjbVzOnT6d+SY5hA2tDQ84Vp+YpNfeBEvtGC9qcWWXwMgLnxGn0AA8UmUX6BBpX8NraZOcGJk91g+4gqhIZrSVQ6rmdV2mCnH8Ad9DcIcwjHaZsSmQJ2j3v82yMVU07yFHmskm0bL9eXYXQb5ew2wewzOG985vsm54bIsUNh+KoySgrMw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4703db5f-ab07-4b15-dede-08d837b712cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2020 14:11:10.5435
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KrbgJohVy9KhYWNnXx2gjR+1DkXODQHRFJrQx3UrsR0oYWwYIYcV07eajZuLGWK89SuYW/9pnbgiZNwqpaxt3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5415
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of Andrew Lunn
> Sent: 27 July 2020 23:48
> To: netdev <netdev@vger.kernel.org>
> Cc: Ioana Ciornei <ioana.ciornei@nxp.com>; Florian Fainelli
> <f.fainelli@gmail.com>; Russell King <rmk+kernel@armlinux.org.uk>; Heiner
> Kallweit <hkallweit1@gmail.com>; Andrew Lunn <andrew@lunn.ch>
> Subject: [PATCH RFC net-next 2/3] net: phy: Move into subdirectories
>=20
> Move the PHY drivers into the phy subdirectory

We could keep the PHY drivers in the base drivers/net/phy/ folder, move
only mdio to introduce lesser changes.

> Move the MDIO bus drivers into the mdio subdirectory
>=20
> Take this opportunity to sort the Kconfig entries based on the text
> that appears in the menu, and the Makefiles.
>=20
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/phy/Kconfig                       | 481 +-----------------
>  drivers/net/phy/Makefile                      |  77 +--
>  drivers/net/phy/mdio/Kconfig                  | 226 ++++++++
>  drivers/net/phy/mdio/Makefile                 |  26 +
>  drivers/net/phy/{ =3D> mdio}/mdio-aspeed.c      |   0
>  drivers/net/phy/{ =3D> mdio}/mdio-bcm-iproc.c   |   0
>  drivers/net/phy/{ =3D> mdio}/mdio-bcm-unimac.c  |   0
>  drivers/net/phy/{ =3D> mdio}/mdio-bitbang.c     |   0
>  drivers/net/phy/{ =3D> mdio}/mdio-cavium.c      |   0
>  drivers/net/phy/{ =3D> mdio}/mdio-cavium.h      |   0
>  drivers/net/phy/{ =3D> mdio}/mdio-gpio.c        |   0
>  drivers/net/phy/{ =3D> mdio}/mdio-hisi-femac.c  |   0
>  drivers/net/phy/{ =3D> mdio}/mdio-ipq4019.c     |   0
>  drivers/net/phy/{ =3D> mdio}/mdio-ipq8064.c     |   0
>  drivers/net/phy/{ =3D> mdio}/mdio-moxart.c      |   0
>  drivers/net/phy/{ =3D> mdio}/mdio-mscc-miim.c   |   0
>  .../net/phy/{ =3D> mdio}/mdio-mux-bcm-iproc.c   |   0
>  drivers/net/phy/{ =3D> mdio}/mdio-mux-gpio.c    |   0
>  .../net/phy/{ =3D> mdio}/mdio-mux-meson-g12a.c  |   0
>  drivers/net/phy/{ =3D> mdio}/mdio-mux-mmioreg.c |   0
>  .../net/phy/{ =3D> mdio}/mdio-mux-multiplexer.c |   0
>  drivers/net/phy/{ =3D> mdio}/mdio-mux.c         |   0
>  drivers/net/phy/{ =3D> mdio}/mdio-mvusb.c       |   0
>  drivers/net/phy/{ =3D> mdio}/mdio-octeon.c      |   0
>  drivers/net/phy/{ =3D> mdio}/mdio-sun4i.c       |   0
>  drivers/net/phy/{ =3D> mdio}/mdio-thunder.c     |   0
>  drivers/net/phy/{ =3D> mdio}/mdio-xgene.c       |   0
>  drivers/net/phy/phy/Kconfig                   | 243 +++++++++
>  drivers/net/phy/phy/Makefile                  |  50 ++
>  drivers/net/phy/{ =3D> phy}/adin.c              |   0
>  drivers/net/phy/{ =3D> phy}/amd.c               |   0
>  drivers/net/phy/{ =3D> phy}/aquantia.h          |   0
>  drivers/net/phy/{ =3D> phy}/aquantia_hwmon.c    |   0
>  drivers/net/phy/{ =3D> phy}/aquantia_main.c     |   0
>  drivers/net/phy/{ =3D> phy}/at803x.c            |   0
>  drivers/net/phy/{ =3D> phy}/ax88796b.c          |   0
>  drivers/net/phy/{ =3D> phy}/bcm-cygnus.c        |   0
>  drivers/net/phy/{ =3D> phy}/bcm-phy-lib.c       |   0
>  drivers/net/phy/{ =3D> phy}/bcm-phy-lib.h       |   0
>  drivers/net/phy/{ =3D> phy}/bcm54140.c          |   0
>  drivers/net/phy/{ =3D> phy}/bcm63xx.c           |   0
>  drivers/net/phy/{ =3D> phy}/bcm7xxx.c           |   0
>  drivers/net/phy/{ =3D> phy}/bcm84881.c          |   0
>  drivers/net/phy/{ =3D> phy}/bcm87xx.c           |   0
>  drivers/net/phy/{ =3D> phy}/broadcom.c          |   0
>  drivers/net/phy/{ =3D> phy}/cicada.c            |   0
>  drivers/net/phy/{ =3D> phy}/cortina.c           |   0
>  drivers/net/phy/{ =3D> phy}/davicom.c           |   0
>  drivers/net/phy/{ =3D> phy}/dp83640.c           |   0
>  drivers/net/phy/{ =3D> phy}/dp83640_reg.h       |   0
>  drivers/net/phy/{ =3D> phy}/dp83822.c           |   0
>  drivers/net/phy/{ =3D> phy}/dp83848.c           |   0
>  drivers/net/phy/{ =3D> phy}/dp83867.c           |   0
>  drivers/net/phy/{ =3D> phy}/dp83869.c           |   0
>  drivers/net/phy/{ =3D> phy}/dp83tc811.c         |   0
>  drivers/net/phy/{ =3D> phy}/et1011c.c           |   0
>  drivers/net/phy/{ =3D> phy}/icplus.c            |   0
>  drivers/net/phy/{ =3D> phy}/intel-xway.c        |   0
>  drivers/net/phy/{ =3D> phy}/lxt.c               |   0
>  drivers/net/phy/{ =3D> phy}/marvell.c           |   0
>  drivers/net/phy/{ =3D> phy}/marvell10g.c        |   0
>  drivers/net/phy/{ =3D> phy}/meson-gxl.c         |   0
>  drivers/net/phy/{ =3D> phy}/micrel.c            |   0
>  drivers/net/phy/{ =3D> phy}/microchip.c         |   0
>  drivers/net/phy/{ =3D> phy}/microchip_t1.c      |   0
>  drivers/net/phy/{ =3D> phy}/mscc/Makefile       |   0
>  drivers/net/phy/{ =3D> phy}/mscc/mscc.h         |   0
>  .../net/phy/{ =3D> phy}/mscc/mscc_fc_buffer.h   |   0
>  drivers/net/phy/{ =3D> phy}/mscc/mscc_mac.h     |   0
>  drivers/net/phy/{ =3D> phy}/mscc/mscc_macsec.c  |   0
>  drivers/net/phy/{ =3D> phy}/mscc/mscc_macsec.h  |   0
>  drivers/net/phy/{ =3D> phy}/mscc/mscc_main.c    |   0
>  drivers/net/phy/{ =3D> phy}/national.c          |   0
>  drivers/net/phy/{ =3D> phy}/nxp-tja11xx.c       |   0
>  drivers/net/phy/{ =3D> phy}/qsemi.c             |   0
>  drivers/net/phy/{ =3D> phy}/realtek.c           |   0
>  drivers/net/phy/{ =3D> phy}/rockchip.c          |   0
>  drivers/net/phy/{ =3D> phy}/smsc.c              |   0
>  drivers/net/phy/{ =3D> phy}/ste10Xp.c           |   0
>  drivers/net/phy/{ =3D> phy}/teranetics.c        |   0
>  drivers/net/phy/{ =3D> phy}/uPD60620.c          |   0
>  drivers/net/phy/{ =3D> phy}/vitesse.c           |   0
>  82 files changed, 559 insertions(+), 544 deletions(-)
>  create mode 100644 drivers/net/phy/mdio/Kconfig
>  create mode 100644 drivers/net/phy/mdio/Makefile
>  rename drivers/net/phy/{ =3D> mdio}/mdio-aspeed.c (100%)
>  rename drivers/net/phy/{ =3D> mdio}/mdio-bcm-iproc.c (100%)
>  rename drivers/net/phy/{ =3D> mdio}/mdio-bcm-unimac.c (100%)
>  rename drivers/net/phy/{ =3D> mdio}/mdio-bitbang.c (100%)
>  rename drivers/net/phy/{ =3D> mdio}/mdio-cavium.c (100%)
>  rename drivers/net/phy/{ =3D> mdio}/mdio-cavium.h (100%)
>  rename drivers/net/phy/{ =3D> mdio}/mdio-gpio.c (100%)
>  rename drivers/net/phy/{ =3D> mdio}/mdio-hisi-femac.c (100%)
>  rename drivers/net/phy/{ =3D> mdio}/mdio-ipq4019.c (100%)
>  rename drivers/net/phy/{ =3D> mdio}/mdio-ipq8064.c (100%)
>  rename drivers/net/phy/{ =3D> mdio}/mdio-moxart.c (100%)
>  rename drivers/net/phy/{ =3D> mdio}/mdio-mscc-miim.c (100%)
>  rename drivers/net/phy/{ =3D> mdio}/mdio-mux-bcm-iproc.c (100%)
>  rename drivers/net/phy/{ =3D> mdio}/mdio-mux-gpio.c (100%)
>  rename drivers/net/phy/{ =3D> mdio}/mdio-mux-meson-g12a.c (100%)
>  rename drivers/net/phy/{ =3D> mdio}/mdio-mux-mmioreg.c (100%)
>  rename drivers/net/phy/{ =3D> mdio}/mdio-mux-multiplexer.c (100%)
>  rename drivers/net/phy/{ =3D> mdio}/mdio-mux.c (100%)
>  rename drivers/net/phy/{ =3D> mdio}/mdio-mvusb.c (100%)
>  rename drivers/net/phy/{ =3D> mdio}/mdio-octeon.c (100%)
>  rename drivers/net/phy/{ =3D> mdio}/mdio-sun4i.c (100%)
>  rename drivers/net/phy/{ =3D> mdio}/mdio-thunder.c (100%)
>  rename drivers/net/phy/{ =3D> mdio}/mdio-xgene.c (100%)
>  create mode 100644 drivers/net/phy/phy/Kconfig
>  create mode 100644 drivers/net/phy/phy/Makefile
>  rename drivers/net/phy/{ =3D> phy}/adin.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/amd.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/aquantia.h (100%)
>  rename drivers/net/phy/{ =3D> phy}/aquantia_hwmon.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/aquantia_main.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/at803x.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/ax88796b.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/bcm-cygnus.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/bcm-phy-lib.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/bcm-phy-lib.h (100%)
>  rename drivers/net/phy/{ =3D> phy}/bcm54140.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/bcm63xx.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/bcm7xxx.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/bcm84881.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/bcm87xx.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/broadcom.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/cicada.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/cortina.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/davicom.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/dp83640.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/dp83640_reg.h (100%)
>  rename drivers/net/phy/{ =3D> phy}/dp83822.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/dp83848.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/dp83867.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/dp83869.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/dp83tc811.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/et1011c.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/icplus.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/intel-xway.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/lxt.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/marvell.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/marvell10g.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/meson-gxl.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/micrel.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/microchip.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/microchip_t1.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/mscc/Makefile (100%)
>  rename drivers/net/phy/{ =3D> phy}/mscc/mscc.h (100%)
>  rename drivers/net/phy/{ =3D> phy}/mscc/mscc_fc_buffer.h (100%)
>  rename drivers/net/phy/{ =3D> phy}/mscc/mscc_mac.h (100%)
>  rename drivers/net/phy/{ =3D> phy}/mscc/mscc_macsec.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/mscc/mscc_macsec.h (100%)
>  rename drivers/net/phy/{ =3D> phy}/mscc/mscc_main.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/national.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/nxp-tja11xx.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/qsemi.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/realtek.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/rockchip.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/smsc.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/ste10Xp.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/teranetics.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/uPD60620.c (100%)
>  rename drivers/net/phy/{ =3D> phy}/vitesse.c (100%)
>=20
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index dd20c2c27c2f..a193236fd65a 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -3,235 +3,7 @@
>  # PHY Layer Configuration
>  #
>=20
> -menuconfig MDIO_DEVICE
> -	tristate "MDIO bus device drivers"
> -	help
> -	  MDIO devices and driver infrastructure code.
> -
> -if MDIO_DEVICE
> -
> -config MDIO_BUS
> -	tristate
> -	default m if PHYLIB=3Dm
> -	default MDIO_DEVICE
> -	help
> -	  This internal symbol is used for link time dependencies and it
> -	  reflects whether the mdio_bus/mdio_device code is built as a
> -	  loadable module or built-in.
> -
> -if MDIO_BUS
> -
> -config MDIO_DEVRES
> -	tristate
> -
> -config MDIO_ASPEED
> -	tristate "ASPEED MDIO bus controller"
> -	depends on ARCH_ASPEED || COMPILE_TEST
> -	depends on OF_MDIO && HAS_IOMEM
> -	help
> -	  This module provides a driver for the independent MDIO bus
> -	  controllers found in the ASPEED AST2600 SoC. This is a driver for
> the
> -	  third revision of the ASPEED MDIO register interface - the first
> two
> -	  revisions are the "old" and "new" interfaces found in the AST2400
> and
> -	  AST2500, embedded in the MAC. For legacy reasons, FTGMAC100 driver
> -	  continues to drive the embedded MDIO controller for the AST2400
> and
> -	  AST2500 SoCs, so say N if AST2600 support is not required.
> -
> -config MDIO_BCM_IPROC
> -	tristate "Broadcom iProc MDIO bus controller"
> -	depends on ARCH_BCM_IPROC || COMPILE_TEST
> -	depends on HAS_IOMEM && OF_MDIO
> -	default ARCH_BCM_IPROC
> -	help
> -	  This module provides a driver for the MDIO busses found in the
> -	  Broadcom iProc SoC's.
> -
> -config MDIO_BCM_UNIMAC
> -	tristate "Broadcom UniMAC MDIO bus controller"
> -	depends on HAS_IOMEM
> -	help
> -	  This module provides a driver for the Broadcom UniMAC MDIO busses.
> -	  This hardware can be found in the Broadcom GENET Ethernet MAC
> -	  controllers as well as some Broadcom Ethernet switches such as the
> -	  Starfighter 2 switches.
> -
> -config MDIO_BITBANG
> -	tristate "Bitbanged MDIO buses"
> -	help
> -	  This module implements the MDIO bus protocol in software,
> -	  for use by low level drivers that export the ability to
> -	  drive the relevant pins.
> -
> -	  If in doubt, say N.
> -
> -config MDIO_BUS_MUX
> -	tristate
> -	depends on OF_MDIO
> -	help
> -	  This module provides a driver framework for MDIO bus
> -	  multiplexers which connect one of several child MDIO busses
> -	  to a parent bus.  Switching between child busses is done by
> -	  device specific drivers.
> -
> -config MDIO_BUS_MUX_BCM_IPROC
> -	tristate "Broadcom iProc based MDIO bus multiplexers"
> -	depends on OF && OF_MDIO && (ARCH_BCM_IPROC || COMPILE_TEST)
> -	select MDIO_BUS_MUX
> -	default ARCH_BCM_IPROC
> -	help
> -	  This module provides a driver for MDIO bus multiplexers found in
> -	  iProc based Broadcom SoCs. This multiplexer connects one of
> several
> -	  child MDIO bus to a parent bus. Buses could be internal as well as
> -	  external and selection logic lies inside the same multiplexer.
> -
> -config MDIO_BUS_MUX_GPIO
> -	tristate "GPIO controlled MDIO bus multiplexers"
> -	depends on OF_GPIO && OF_MDIO
> -	select MDIO_BUS_MUX
> -	help
> -	  This module provides a driver for MDIO bus multiplexers that
> -	  are controlled via GPIO lines.  The multiplexer connects one of
> -	  several child MDIO busses to a parent bus.  Child bus
> -	  selection is under the control of GPIO lines.
> -
> -config MDIO_BUS_MUX_MESON_G12A
> -	tristate "Amlogic G12a based MDIO bus multiplexer"
> -	depends on ARCH_MESON || COMPILE_TEST
> -	depends on OF_MDIO && HAS_IOMEM && COMMON_CLK
> -	select MDIO_BUS_MUX
> -	default m if ARCH_MESON
> -	help
> -	  This module provides a driver for the MDIO multiplexer/glue of
> -	  the amlogic g12a SoC. The multiplexers connects either the
> external
> -	  or the internal MDIO bus to the parent bus.
> -
> -config MDIO_BUS_MUX_MMIOREG
> -	tristate "MMIO device-controlled MDIO bus multiplexers"
> -	depends on OF_MDIO && HAS_IOMEM
> -	select MDIO_BUS_MUX
> -	help
> -	  This module provides a driver for MDIO bus multiplexers that
> -	  are controlled via a simple memory-mapped device, like an FPGA.
> -	  The multiplexer connects one of several child MDIO busses to a
> -	  parent bus.  Child bus selection is under the control of one of
> -	  the FPGA's registers.
> -
> -	  Currently, only 8/16/32 bits registers are supported.
> -
> -config MDIO_BUS_MUX_MULTIPLEXER
> -	tristate "MDIO bus multiplexer using kernel multiplexer subsystem"
> -	depends on OF_MDIO
> -	select MULTIPLEXER
> -	select MDIO_BUS_MUX
> -	help
> -	  This module provides a driver for MDIO bus multiplexer
> -	  that is controlled via the kernel multiplexer subsystem. The
> -	  bus multiplexer connects one of several child MDIO busses to
> -	  a parent bus.  Child bus selection is under the control of
> -	  the kernel multiplexer subsystem.
> -
> -config MDIO_CAVIUM
> -	tristate
> -
> -config MDIO_GPIO
> -	tristate "GPIO lib-based bitbanged MDIO buses"
> -	depends on MDIO_BITBANG
> -	depends on GPIOLIB || COMPILE_TEST
> -	help
> -	  Supports GPIO lib-based MDIO busses.
> -
> -	  To compile this driver as a module, choose M here: the module
> -	  will be called mdio-gpio.
> -
> -config MDIO_HISI_FEMAC
> -	tristate "Hisilicon FEMAC MDIO bus controller"
> -	depends on HAS_IOMEM && OF_MDIO
> -	help
> -	  This module provides a driver for the MDIO busses found in the
> -	  Hisilicon SoC that have an Fast Ethernet MAC.
> -
> -config MDIO_I2C
> -	tristate
> -	depends on I2C
> -	help
> -	  Support I2C based PHYs.  This provides a MDIO bus bridged
> -	  to I2C to allow PHYs connected in I2C mode to be accessed
> -	  using the existing infrastructure.
> -
> -	  This is library mode.
> -
> -config MDIO_IPQ4019
> -	tristate "Qualcomm IPQ4019 MDIO interface support"
> -	depends on HAS_IOMEM && OF_MDIO
> -	help
> -	  This driver supports the MDIO interface found in Qualcomm
> -	  IPQ40xx series Soc-s.
> -
> -config MDIO_IPQ8064
> -	tristate "Qualcomm IPQ8064 MDIO interface support"
> -	depends on HAS_IOMEM && OF_MDIO
> -	depends on MFD_SYSCON
> -	help
> -	  This driver supports the MDIO interface found in the network
> -	  interface units of the IPQ8064 SoC
> -
> -config MDIO_MOXART
> -	tristate "MOXA ART MDIO interface support"
> -	depends on ARCH_MOXART || COMPILE_TEST
> -	help
> -	  This driver supports the MDIO interface found in the network
> -	  interface units of the MOXA ART SoC
> -
> -config MDIO_MSCC_MIIM
> -	tristate "Microsemi MIIM interface support"
> -	depends on HAS_IOMEM
> -	select MDIO_DEVRES
> -	help
> -	  This driver supports the MIIM (MDIO) interface found in the
> network
> -	  switches of the Microsemi SoCs; it is recommended to switch on
> -	  CONFIG_HIGH_RES_TIMERS
> -
> -config MDIO_MVUSB
> -	tristate "Marvell USB to MDIO Adapter"
> -	depends on USB
> -	help
> -	  A USB to MDIO converter present on development boards for
> -	  Marvell's Link Street family of Ethernet switches.
> -
> -config MDIO_OCTEON
> -	tristate "Octeon and some ThunderX SOCs MDIO buses"
> -	depends on (64BIT && OF_MDIO) || COMPILE_TEST
> -	depends on HAS_IOMEM
> -	select MDIO_CAVIUM
> -	help
> -	  This module provides a driver for the Octeon and ThunderX MDIO
> -	  buses. It is required by the Octeon and ThunderX ethernet device
> -	  drivers on some systems.
> -
> -config MDIO_SUN4I
> -	tristate "Allwinner sun4i MDIO interface support"
> -	depends on ARCH_SUNXI || COMPILE_TEST
> -	help
> -	  This driver supports the MDIO interface found in the network
> -	  interface units of the Allwinner SoC that have an EMAC (A10,
> -	  A12, A10s, etc.)
> -
> -config MDIO_THUNDER
> -	tristate "ThunderX SOCs MDIO buses"
> -	depends on 64BIT
> -	depends on PCI
> -	select MDIO_CAVIUM
> -	help
> -	  This driver supports the MDIO interfaces found on Cavium
> -	  ThunderX SoCs when the MDIO bus device appears as a PCI
> -	  device.
> -
> -config MDIO_XGENE
> -	tristate "APM X-Gene SoC MDIO bus controller"
> -	depends on ARCH_XGENE || COMPILE_TEST
> -	help
> -	  This module provides a driver for the MDIO busses found in the
> -	  APM X-Gene SoC's.
> +source "drivers/net/phy/mdio/Kconfig"
>=20
>  config MDIO_XPCS
>  	tristate "Synopsys DesignWare XPCS controller"
> @@ -239,9 +11,6 @@ config MDIO_XPCS
>  	  This module provides helper functions for Synopsys DesignWare XPCS
>  	  controllers.
>=20
> -endif
> -endif
> -
>  config PHYLINK
>  	tristate
>  	depends on NETDEVICES
> @@ -292,132 +61,6 @@ config SFP
>  	depends on HWMON || HWMON=3Dn
>  	select MDIO_I2C
>=20
> -config ADIN_PHY
> -	tristate "Analog Devices Industrial Ethernet PHYs"
> -	help
> -	  Adds support for the Analog Devices Industrial Ethernet PHYs.
> -	  Currently supports the:
> -	  - ADIN1200 - Robust,Industrial, Low Power 10/100 Ethernet PHY
> -	  - ADIN1300 - Robust,Industrial, Low Latency 10/100/1000 Gigabit
> -	    Ethernet PHY
> -
> -config AMD_PHY
> -	tristate "AMD PHYs"
> -	help
> -	  Currently supports the am79c874
> -
> -config AQUANTIA_PHY
> -	tristate "Aquantia PHYs"
> -	help
> -	  Currently supports the Aquantia AQ1202, AQ2104, AQR105, AQR405
> -
> -config AX88796B_PHY
> -	tristate "Asix PHYs"
> -	help
> -	  Currently supports the Asix Electronics PHY found in the X-Surf
> 100
> -	  AX88796B package.
> -
> -config BCM63XX_PHY
> -	tristate "Broadcom 63xx SOCs internal PHY"
> -	depends on BCM63XX || COMPILE_TEST
> -	select BCM_NET_PHYLIB
> -	help
> -	  Currently supports the 6348 and 6358 PHYs.
> -
> -config BCM7XXX_PHY
> -	tristate "Broadcom 7xxx SOCs internal PHYs"
> -	select BCM_NET_PHYLIB
> -	help
> -	  Currently supports the BCM7366, BCM7439, BCM7445, and
> -	  40nm and 65nm generation of BCM7xxx Set Top Box SoCs.
> -
> -config BCM87XX_PHY
> -	tristate "Broadcom BCM8706 and BCM8727 PHYs"
> -	help
> -	  Currently supports the BCM8706 and BCM8727 10G Ethernet PHYs.
> -
> -config BCM_CYGNUS_PHY
> -	tristate "Broadcom Cygnus/Omega SoC internal PHY"
> -	depends on ARCH_BCM_IPROC || COMPILE_TEST
> -	depends on MDIO_BCM_IPROC
> -	select BCM_NET_PHYLIB
> -	help
> -	  This PHY driver is for the 1G internal PHYs of the Broadcom
> -	  Cygnus and Omega Family SoC.
> -
> -	  Currently supports internal PHY's used in the BCM11300,
> -	  BCM11320, BCM11350, BCM11360, BCM58300, BCM58302,
> -	  BCM58303 & BCM58305 Broadcom Cygnus SoCs.
> -
> -config BCM_NET_PHYLIB
> -	tristate
> -
> -config BROADCOM_PHY
> -	tristate "Broadcom PHYs"
> -	select BCM_NET_PHYLIB
> -	help
> -	  Currently supports the BCM5411, BCM5421, BCM5461, BCM54616S,
> BCM5464,
> -	  BCM5481, BCM54810 and BCM5482 PHYs.
> -
> -config BCM54140_PHY
> -	tristate "Broadcom BCM54140 PHY"
> -	depends on PHYLIB
> -	depends on HWMON || HWMON=3Dn
> -	select BCM_NET_PHYLIB
> -	help
> -	  Support the Broadcom BCM54140 Quad SGMII/QSGMII PHY.
> -
> -	  This driver also supports the hardware monitoring of this PHY and
> -	  exposes voltage and temperature sensors.
> -
> -config BCM84881_PHY
> -	tristate "Broadcom BCM84881 PHY"
> -	depends on PHYLIB
> -	help
> -	  Support the Broadcom BCM84881 PHY.
> -
> -config CICADA_PHY
> -	tristate "Cicada PHYs"
> -	help
> -	  Currently supports the cis8204
> -
> -config CORTINA_PHY
> -	tristate "Cortina EDC CDR 10G Ethernet PHY"
> -	help
> -	  Currently supports the CS4340 phy.
> -
> -config DAVICOM_PHY
> -	tristate "Davicom PHYs"
> -	help
> -	  Currently supports dm9161e and dm9131
> -
> -config DP83822_PHY
> -	tristate "Texas Instruments DP83822/825/826 PHYs"
> -	help
> -	  Supports the DP83822, DP83825I, DP83825CM, DP83825CS, DP83825S,
> -	  DP83826C and DP83826NC PHYs.
> -
> -config DP83TC811_PHY
> -	tristate "Texas Instruments DP83TC811 PHY"
> -	help
> -	  Supports the DP83TC811 PHY.
> -
> -config DP83848_PHY
> -	tristate "Texas Instruments DP83848 PHY"
> -	help
> -	  Supports the DP83848 PHY.
> -
> -config DP83867_PHY
> -	tristate "Texas Instruments DP83867 Gigabit PHY"
> -	help
> -	  Currently supports the DP83867 PHY.
> -
> -config DP83869_PHY
> -	tristate "Texas Instruments DP83869 Gigabit PHY"
> -	help
> -	  Currently supports the DP83869 PHY.  This PHY supports copper and
> -	  fiber connections.
> -
>  config FIXED_PHY
>  	tristate "MDIO Bus/PHY emulation with fixed speed/link PHYs"
>  	depends on PHYLIB
> @@ -428,123 +71,17 @@ config FIXED_PHY
>=20
>  	  Currently tested with mpc866ads and mpc8349e-mitx.
>=20
> -config ICPLUS_PHY
> -	tristate "ICPlus PHYs"
> -	help
> -	  Currently supports the IP175C and IP1001 PHYs.
> -
> -config INTEL_XWAY_PHY
> -	tristate "Intel XWAY PHYs"
> -	help
> -	  Supports the Intel XWAY (former Lantiq) 11G and 22E PHYs.
> -	  These PHYs are marked as standalone chips under the names
> -	  PEF 7061, PEF 7071 and PEF 7072 or integrated into the Intel
> -	  SoCs xRX200, xRX300, xRX330, xRX350 and xRX550.
> -
> -config LSI_ET1011C_PHY
> -	tristate "LSI ET1011C PHY"
> -	help
> -	  Supports the LSI ET1011C PHY.
> -
> -config LXT_PHY
> -	tristate "Intel LXT PHYs"
> -	help
> -	  Currently supports the lxt970, lxt971
> -
> -config MARVELL_PHY
> -	tristate "Marvell PHYs"
> -	help
> -	  Currently has a driver for the 88E1011S
> -
> -config MARVELL_10G_PHY
> -	tristate "Marvell Alaska 10Gbit PHYs"
> -	help
> -	  Support for the Marvell Alaska MV88X3310 and compatible PHYs.
> -
> -config MESON_GXL_PHY
> -	tristate "Amlogic Meson GXL Internal PHY"
> -	depends on ARCH_MESON || COMPILE_TEST
> -	help
> -	  Currently has a driver for the Amlogic Meson GXL Internal PHY
> -
> -config MICREL_PHY
> -	tristate "Micrel PHYs"
> -	help
> -	  Supports the KSZ9021, VSC8201, KS8001 PHYs.
> -
> -config MICROCHIP_PHY
> -	tristate "Microchip PHYs"
> -	help
> -	  Supports the LAN88XX PHYs.
> -
> -config MICROCHIP_T1_PHY
> -	tristate "Microchip T1 PHYs"
> -	help
> -	  Supports the LAN87XX PHYs.
> -
> -config MICROSEMI_PHY
> -	tristate "Microsemi PHYs"
> -	depends on MACSEC || MACSEC=3Dn
> -	select CRYPTO_LIB_AES if MACSEC
> -	help
> -	  Currently supports VSC8514, VSC8530, VSC8531, VSC8540 and VSC8541
> PHYs
> -
> -config NATIONAL_PHY
> -	tristate "National Semiconductor PHYs"
> -	help
> -	  Currently supports the DP83865 PHY.
> -
> -config NXP_TJA11XX_PHY
> -	tristate "NXP TJA11xx PHYs support"
> -	depends on HWMON
> -	help
> -	  Currently supports the NXP TJA1100 and TJA1101 PHY.
> -
> -config AT803X_PHY
> -	tristate "Qualcomm Atheros AR803X PHYs"
> -	depends on REGULATOR
> -	help
> -	  Currently supports the AR8030, AR8031, AR8033 and AR8035 model
> -
> -config QSEMI_PHY
> -	tristate "Quality Semiconductor PHYs"
> -	help
> -	  Currently supports the qs6612
> -
> -config REALTEK_PHY
> -	tristate "Realtek PHYs"
> -	help
> -	  Supports the Realtek 821x PHY.
> -
> -config RENESAS_PHY
> -	tristate "Driver for Renesas PHYs"
> -	help
> -	  Supports the Renesas PHYs uPD60620 and uPD60620A.
> -
> -config ROCKCHIP_PHY
> -	tristate "Driver for Rockchip Ethernet PHYs"
> -	help
> -	  Currently supports the integrated Ethernet PHY.
> -
> -config SMSC_PHY
> -	tristate "SMSC PHYs"
> -	help
> -	  Currently supports the LAN83C185, LAN8187 and LAN8700 PHYs
> -
> -config STE10XP
> -	tristate "STMicroelectronics STe10Xp PHYs"
> +config MDIO_I2C
> +	tristate
> +	depends on I2C
>  	help
> -	  This is the driver for the STe100p and STe101p PHYs.
> +	  Support I2C based PHYs.  This provides a MDIO bus bridged
> +	  to I2C to allow PHYs connected in I2C mode to be accessed
> +	  using the existing infrastructure.
>=20
> -config TERANETICS_PHY
> -	tristate "Teranetics PHYs"
> -	help
> -	  Currently supports the Teranetics TN2020
> +	  This is library mode.
>=20
> -config VITESSE_PHY
> -	tristate "Vitesse PHYs"
> -	help
> -	  Currently supports the vsc8244
> +source "drivers/net/phy/phy/Kconfig"
>=20
>  config XILINX_GMII2RGMII
>  	tristate "Xilinx GMII2RGMII converter driver"
> diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> index d84bab489a53..6bdf04478d34 100644
> --- a/drivers/net/phy/Makefile
> +++ b/drivers/net/phy/Makefile
> @@ -1,6 +1,8 @@
>  # SPDX-License-Identifier: GPL-2.0
>  # Makefile for Linux PHY drivers and MDIO bus drivers
>=20
> +obj-y				+=3D phy/ mdio/
> +
>  libphy-y			:=3D phy.o phy-c45.o phy-core.o phy_device.o \
>  				   linkmode.o
>  mdio-bus-y			+=3D mdio_bus.o mdio_device.o
> @@ -23,30 +25,8 @@ libphy-$(CONFIG_LED_TRIGGER_PHY)	+=3D
> phy_led_triggers.o
>=20
>  obj-$(CONFIG_PHYLINK)		+=3D phylink.o
>  obj-$(CONFIG_PHYLIB)		+=3D libphy.o
> +obj-$(CONFIG_FIXED_PHY)		+=3D fixed_phy.o
>=20
> -obj-$(CONFIG_MDIO_ASPEED)	+=3D mdio-aspeed.o
> -obj-$(CONFIG_MDIO_BCM_IPROC)	+=3D mdio-bcm-iproc.o
> -obj-$(CONFIG_MDIO_BCM_UNIMAC)	+=3D mdio-bcm-unimac.o
> -obj-$(CONFIG_MDIO_BITBANG)	+=3D mdio-bitbang.o
> -obj-$(CONFIG_MDIO_BUS_MUX)	+=3D mdio-mux.o
> -obj-$(CONFIG_MDIO_BUS_MUX_BCM_IPROC)	+=3D mdio-mux-bcm-iproc.o
> -obj-$(CONFIG_MDIO_BUS_MUX_GPIO)	+=3D mdio-mux-gpio.o
> -obj-$(CONFIG_MDIO_BUS_MUX_MESON_G12A)	+=3D mdio-mux-meson-g12a.o
> -obj-$(CONFIG_MDIO_BUS_MUX_MMIOREG) +=3D mdio-mux-mmioreg.o
> -obj-$(CONFIG_MDIO_BUS_MUX_MULTIPLEXER) +=3D mdio-mux-multiplexer.o
> -obj-$(CONFIG_MDIO_CAVIUM)	+=3D mdio-cavium.o
> -obj-$(CONFIG_MDIO_GPIO)		+=3D mdio-gpio.o
> -obj-$(CONFIG_MDIO_HISI_FEMAC)	+=3D mdio-hisi-femac.o
> -obj-$(CONFIG_MDIO_I2C)		+=3D mdio-i2c.o
> -obj-$(CONFIG_MDIO_IPQ4019)	+=3D mdio-ipq4019.o
> -obj-$(CONFIG_MDIO_IPQ8064)	+=3D mdio-ipq8064.o
> -obj-$(CONFIG_MDIO_MOXART)	+=3D mdio-moxart.o
> -obj-$(CONFIG_MDIO_MSCC_MIIM)	+=3D mdio-mscc-miim.o
> -obj-$(CONFIG_MDIO_MVUSB)	+=3D mdio-mvusb.o
> -obj-$(CONFIG_MDIO_OCTEON)	+=3D mdio-octeon.o
> -obj-$(CONFIG_MDIO_SUN4I)	+=3D mdio-sun4i.o
> -obj-$(CONFIG_MDIO_THUNDER)	+=3D mdio-thunder.o
> -obj-$(CONFIG_MDIO_XGENE)	+=3D mdio-xgene.o
>  obj-$(CONFIG_MDIO_XPCS)		+=3D mdio-xpcs.o
>=20
>  obj-$(CONFIG_NETWORK_PHY_TIMESTAMPING) +=3D mii_timestamper.o
> @@ -54,54 +34,7 @@ obj-$(CONFIG_NETWORK_PHY_TIMESTAMPING) +=3D
> mii_timestamper.o
>  obj-$(CONFIG_SFP)		+=3D sfp.o
>  sfp-obj-$(CONFIG_SFP)		+=3D sfp-bus.o
>  obj-y				+=3D $(sfp-obj-y) $(sfp-obj-m)
> +obj-$(CONFIG_MDIO_I2C)		+=3D mdio-i2c.o
>=20
> -obj-$(CONFIG_ADIN_PHY)		+=3D adin.o
> -obj-$(CONFIG_AMD_PHY)		+=3D amd.o
> -aquantia-objs			+=3D aquantia_main.o
> -ifdef CONFIG_HWMON
> -aquantia-objs			+=3D aquantia_hwmon.o
> -endif
> -obj-$(CONFIG_AQUANTIA_PHY)	+=3D aquantia.o
> -obj-$(CONFIG_AX88796B_PHY)	+=3D ax88796b.o
> -obj-$(CONFIG_AT803X_PHY)	+=3D at803x.o
> -obj-$(CONFIG_BCM63XX_PHY)	+=3D bcm63xx.o
> -obj-$(CONFIG_BCM7XXX_PHY)	+=3D bcm7xxx.o
> -obj-$(CONFIG_BCM87XX_PHY)	+=3D bcm87xx.o
> -obj-$(CONFIG_BCM_CYGNUS_PHY)	+=3D bcm-cygnus.o
> -obj-$(CONFIG_BCM_NET_PHYLIB)	+=3D bcm-phy-lib.o
> -obj-$(CONFIG_BROADCOM_PHY)	+=3D broadcom.o
> -obj-$(CONFIG_BCM54140_PHY)	+=3D bcm54140.o
> -obj-$(CONFIG_BCM84881_PHY)	+=3D bcm84881.o
> -obj-$(CONFIG_CICADA_PHY)	+=3D cicada.o
> -obj-$(CONFIG_CORTINA_PHY)	+=3D cortina.o
> -obj-$(CONFIG_DAVICOM_PHY)	+=3D davicom.o
> -obj-$(CONFIG_DP83640_PHY)	+=3D dp83640.o
> -obj-$(CONFIG_DP83822_PHY)	+=3D dp83822.o
> -obj-$(CONFIG_DP83TC811_PHY)	+=3D dp83tc811.o
> -obj-$(CONFIG_DP83848_PHY)	+=3D dp83848.o
> -obj-$(CONFIG_DP83867_PHY)	+=3D dp83867.o
> -obj-$(CONFIG_DP83869_PHY)	+=3D dp83869.o
> -obj-$(CONFIG_FIXED_PHY)		+=3D fixed_phy.o
> -obj-$(CONFIG_ICPLUS_PHY)	+=3D icplus.o
> -obj-$(CONFIG_INTEL_XWAY_PHY)	+=3D intel-xway.o
> -obj-$(CONFIG_LSI_ET1011C_PHY)	+=3D et1011c.o
> -obj-$(CONFIG_LXT_PHY)		+=3D lxt.o
> -obj-$(CONFIG_MARVELL_PHY)	+=3D marvell.o
> -obj-$(CONFIG_MARVELL_10G_PHY)	+=3D marvell10g.o
> -obj-$(CONFIG_MESON_GXL_PHY)	+=3D meson-gxl.o
>  obj-$(CONFIG_MICREL_KS8995MA)	+=3D spi_ks8995.o
> -obj-$(CONFIG_MICREL_PHY)	+=3D micrel.o
> -obj-$(CONFIG_MICROCHIP_PHY)	+=3D microchip.o
> -obj-$(CONFIG_MICROCHIP_T1_PHY)	+=3D microchip_t1.o
> -obj-$(CONFIG_MICROSEMI_PHY)	+=3D mscc/
> -obj-$(CONFIG_NATIONAL_PHY)	+=3D national.o
> -obj-$(CONFIG_NXP_TJA11XX_PHY)	+=3D nxp-tja11xx.o
> -obj-$(CONFIG_QSEMI_PHY)		+=3D qsemi.o
> -obj-$(CONFIG_REALTEK_PHY)	+=3D realtek.o
> -obj-$(CONFIG_RENESAS_PHY)	+=3D uPD60620.o
> -obj-$(CONFIG_ROCKCHIP_PHY)	+=3D rockchip.o
> -obj-$(CONFIG_SMSC_PHY)		+=3D smsc.o
> -obj-$(CONFIG_STE10XP)		+=3D ste10Xp.o
> -obj-$(CONFIG_TERANETICS_PHY)	+=3D teranetics.o
> -obj-$(CONFIG_VITESSE_PHY)	+=3D vitesse.o
> -obj-$(CONFIG_XILINX_GMII2RGMII) +=3D xilinx_gmii2rgmii.o
> +
> diff --git a/drivers/net/phy/mdio/Kconfig b/drivers/net/phy/mdio/Kconfig
> new file mode 100644
> index 000000000000..f5ea07b84d65
> --- /dev/null
> +++ b/drivers/net/phy/mdio/Kconfig
> @@ -0,0 +1,226 @@
> +menuconfig MDIO_DEVICE
> +	tristate "MDIO bus device drivers"
> +	help
> +	  MDIO devices and driver infrastructure code.
> +
> +if MDIO_DEVICE
> +
> +config MDIO_BUS
> +	tristate
> +	default m if PHYLIB=3Dm
> +	default MDIO_DEVICE
> +	help
> +	  This internal symbol is used for link time dependencies and it
> +	  reflects whether the mdio_bus/mdio_device code is built as a
> +	  loadable module or built-in.
> +
> +if MDIO_BUS
> +
> +config MDIO_DEVRES
> +	tristate
> +
> +comment "MDIO Multiplexor drivers"
> +
> +config MDIO_BUS_MUX
> +	tristate
> +	depends on OF_MDIO
> +	help
> +	  This module provides a driver framework for MDIO bus
> +	  multiplexers which connect one of several child MDIO busses
> +	  to a parent bus.  Switching between child busses is done by
> +	  device specific drivers.
> +
> +config MDIO_BUS_MUX_MESON_G12A
> +	tristate "Amlogic G12a based MDIO bus multiplexer"
> +	depends on ARCH_MESON || COMPILE_TEST
> +	depends on OF_MDIO && HAS_IOMEM && COMMON_CLK
> +	select MDIO_BUS_MUX
> +	default m if ARCH_MESON
> +	help
> +	  This module provides a driver for the MDIO multiplexer/glue of
> +	  the amlogic g12a SoC. The multiplexers connects either the
> external
> +	  or the internal MDIO bus to the parent bus.
> +
> +config MDIO_BUS_MUX_BCM_IPROC
> +	tristate "Broadcom iProc based MDIO bus multiplexers"
> +	depends on OF && OF_MDIO && (ARCH_BCM_IPROC || COMPILE_TEST)
> +	select MDIO_BUS_MUX
> +	default ARCH_BCM_IPROC
> +	help
> +	  This module provides a driver for MDIO bus multiplexers found in
> +	  iProc based Broadcom SoCs. This multiplexer connects one of
> several
> +	  child MDIO bus to a parent bus. Buses could be internal as well as
> +	  external and selection logic lies inside the same multiplexer.
> +
> +config MDIO_BUS_MUX_GPIO
> +	tristate "GPIO controlled MDIO bus multiplexers"
> +	depends on OF_GPIO && OF_MDIO
> +	select MDIO_BUS_MUX
> +	help
> +	  This module provides a driver for MDIO bus multiplexers that
> +	  are controlled via GPIO lines.  The multiplexer connects one of
> +	  several child MDIO busses to a parent bus.  Child bus
> +	  selection is under the control of GPIO lines.
> +
> +config MDIO_BUS_MUX_MULTIPLEXER
> +	tristate "MDIO bus multiplexer using kernel multiplexer subsystem"
> +	depends on OF_MDIO
> +	select MULTIPLEXER
> +	select MDIO_BUS_MUX
> +	help
> +	  This module provides a driver for MDIO bus multiplexer
> +	  that is controlled via the kernel multiplexer subsystem. The
> +	  bus multiplexer connects one of several child MDIO busses to
> +	  a parent bus.  Child bus selection is under the control of
> +	  the kernel multiplexer subsystem.
> +
> +config MDIO_BUS_MUX_MMIOREG
> +	tristate "MMIO device-controlled MDIO bus multiplexers"
> +	depends on OF_MDIO && HAS_IOMEM
> +	select MDIO_BUS_MUX
> +	help
> +	  This module provides a driver for MDIO bus multiplexers that
> +	  are controlled via a simple memory-mapped device, like an FPGA.
> +	  The multiplexer connects one of several child MDIO busses to a
> +	  parent bus.  Child bus selection is under the control of one of
> +	  the FPGA's registers.
> +
> +	  Currently, only 8/16/32 bits registers are supported.
> +
> +comment "MDIO Bus drivers"
> +
> +config MDIO_SUN4I
> +	tristate "Allwinner sun4i MDIO interface support"
> +	depends on ARCH_SUNXI || COMPILE_TEST
> +	help
> +	  This driver supports the MDIO interface found in the network
> +	  interface units of the Allwinner SoC that have an EMAC (A10,
> +	  A12, A10s, etc.)
> +
> +config MDIO_XGENE
> +	tristate "APM X-Gene SoC MDIO bus controller"
> +	depends on ARCH_XGENE || COMPILE_TEST
> +	help
> +	  This module provides a driver for the MDIO busses found in the
> +	  APM X-Gene SoC's.
> +
> +config MDIO_ASPEED
> +	tristate "ASPEED MDIO bus controller"
> +	depends on ARCH_ASPEED || COMPILE_TEST
> +	depends on OF_MDIO && HAS_IOMEM
> +	help
> +	  This module provides a driver for the independent MDIO bus
> +	  controllers found in the ASPEED AST2600 SoC. This is a driver for
> the
> +	  third revision of the ASPEED MDIO register interface - the first
> two
> +	  revisions are the "old" and "new" interfaces found in the AST2400
> and
> +	  AST2500, embedded in the MAC. For legacy reasons, FTGMAC100 driver
> +	  continues to drive the embedded MDIO controller for the AST2400
> and
> +	  AST2500 SoCs, so say N if AST2600 support is not required.
> +
> +config MDIO_BITBANG
> +	tristate "Bitbanged MDIO buses"
> +	help
> +	  This module implements the MDIO bus protocol in software,
> +	  for use by low level drivers that export the ability to
> +	  drive the relevant pins.
> +
> +	  If in doubt, say N.
> +
> +config MDIO_BCM_IPROC
> +	tristate "Broadcom iProc MDIO bus controller"
> +	depends on ARCH_BCM_IPROC || COMPILE_TEST
> +	depends on HAS_IOMEM && OF_MDIO
> +	default ARCH_BCM_IPROC
> +	help
> +	  This module provides a driver for the MDIO busses found in the
> +	  Broadcom iProc SoC's.
> +
> +config MDIO_BCM_UNIMAC
> +	tristate "Broadcom UniMAC MDIO bus controller"
> +	depends on HAS_IOMEM
> +	help
> +	  This module provides a driver for the Broadcom UniMAC MDIO busses.
> +	  This hardware can be found in the Broadcom GENET Ethernet MAC
> +	  controllers as well as some Broadcom Ethernet switches such as the
> +	  Starfighter 2 switches.
> +
> +config MDIO_CAVIUM
> +	tristate
> +
> +config MDIO_GPIO
> +	tristate "GPIO lib-based bitbanged MDIO buses"
> +	depends on MDIO_BITBANG
> +	depends on GPIOLIB || COMPILE_TEST
> +	help
> +	  Supports GPIO lib-based MDIO busses.
> +
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called mdio-gpio.
> +
> +config MDIO_HISI_FEMAC
> +	tristate "Hisilicon FEMAC MDIO bus controller"
> +	depends on HAS_IOMEM && OF_MDIO
> +	help
> +	  This module provides a driver for the MDIO busses found in the
> +	  Hisilicon SoC that have an Fast Ethernet MAC.
> +
> +config MDIO_MVUSB
> +	tristate "Marvell USB to MDIO Adapter"
> +	depends on USB
> +	help
> +	  A USB to MDIO converter present on development boards for
> +	  Marvell's Link Street family of Ethernet switches.
> +
> +config MDIO_MSCC_MIIM
> +	tristate "Microsemi MIIM interface support"
> +	depends on HAS_IOMEM
> +	select MDIO_DEVRES
> +	help
> +	  This driver supports the MIIM (MDIO) interface found in the
> network
> +	  switches of the Microsemi SoCs; it is recommended to switch on
> +	  CONFIG_HIGH_RES_TIMERS
> +
> +config MDIO_MOXART
> +	tristate "MOXA ART MDIO interface support"
> +	depends on ARCH_MOXART || COMPILE_TEST
> +	help
> +	  This driver supports the MDIO interface found in the network
> +	  interface units of the MOXA ART SoC
> +
> +config MDIO_OCTEON
> +	tristate "Octeon and some ThunderX SOCs MDIO buses"
> +	depends on (64BIT && OF_MDIO) || COMPILE_TEST
> +	depends on HAS_IOMEM
> +	select MDIO_CAVIUM
> +	help
> +	  This module provides a driver for the Octeon and ThunderX MDIO
> +	  buses. It is required by the Octeon and ThunderX ethernet device
> +	  drivers on some systems.
> +
> +config MDIO_IPQ4019
> +	tristate "Qualcomm IPQ4019 MDIO interface support"
> +	depends on HAS_IOMEM && OF_MDIO
> +	help
> +	  This driver supports the MDIO interface found in Qualcomm
> +	  IPQ40xx series Soc-s.
> +
> +config MDIO_IPQ8064
> +	tristate "Qualcomm IPQ8064 MDIO interface support"
> +	depends on HAS_IOMEM && OF_MDIO
> +	depends on MFD_SYSCON
> +	help
> +	  This driver supports the MDIO interface found in the network
> +	  interface units of the IPQ8064 SoC
> +
> +config MDIO_THUNDER
> +	tristate "ThunderX SOCs MDIO buses"
> +	depends on 64BIT
> +	depends on PCI
> +	select MDIO_CAVIUM
> +	help
> +	  This driver supports the MDIO interfaces found on Cavium
> +	  ThunderX SoCs when the MDIO bus device appears as a PCI
> +	  device.
> +
> +endif
> +endif
> diff --git a/drivers/net/phy/mdio/Makefile b/drivers/net/phy/mdio/Makefil=
e
> new file mode 100644
> index 000000000000..9f52aca3bc60
> --- /dev/null
> +++ b/drivers/net/phy/mdio/Makefile
> @@ -0,0 +1,26 @@
> +# SPDX-License-Identifier: GPL-2.0
> +# Makefile for Linux MDIO bus drivers
> +
> +obj-$(CONFIG_MDIO_BUS_MUX)		+=3D mdio-mux.o
> +obj-$(CONFIG_MDIO_BUS_MUX_BCM_IPROC)	+=3D mdio-mux-bcm-iproc.o
> +obj-$(CONFIG_MDIO_BUS_MUX_GPIO)		+=3D mdio-mux-gpio.o
> +obj-$(CONFIG_MDIO_BUS_MUX_MESON_G12A)	+=3D mdio-mux-meson-g12a.o
> +obj-$(CONFIG_MDIO_BUS_MUX_MMIOREG) 	+=3D mdio-mux-mmioreg.o
> +obj-$(CONFIG_MDIO_BUS_MUX_MULTIPLEXER) 	+=3D mdio-mux-multiplexer.o
> +
> +obj-$(CONFIG_MDIO_ASPEED)		+=3D mdio-aspeed.o
> +obj-$(CONFIG_MDIO_BCM_IPROC)		+=3D mdio-bcm-iproc.o
> +obj-$(CONFIG_MDIO_BCM_UNIMAC)		+=3D mdio-bcm-unimac.o
> +obj-$(CONFIG_MDIO_BITBANG)		+=3D mdio-bitbang.o
> +obj-$(CONFIG_MDIO_CAVIUM)		+=3D mdio-cavium.o
> +obj-$(CONFIG_MDIO_GPIO)			+=3D mdio-gpio.o
> +obj-$(CONFIG_MDIO_HISI_FEMAC)		+=3D mdio-hisi-femac.o
> +obj-$(CONFIG_MDIO_IPQ4019)		+=3D mdio-ipq4019.o
> +obj-$(CONFIG_MDIO_IPQ8064)		+=3D mdio-ipq8064.o
> +obj-$(CONFIG_MDIO_MOXART)		+=3D mdio-moxart.o
> +obj-$(CONFIG_MDIO_MSCC_MIIM)		+=3D mdio-mscc-miim.o
> +obj-$(CONFIG_MDIO_MVUSB)		+=3D mdio-mvusb.o
> +obj-$(CONFIG_MDIO_OCTEON)		+=3D mdio-octeon.o
> +obj-$(CONFIG_MDIO_SUN4I)		+=3D mdio-sun4i.o
> +obj-$(CONFIG_MDIO_THUNDER)		+=3D mdio-thunder.o
> +obj-$(CONFIG_MDIO_XGENE)		+=3D mdio-xgene.o
> diff --git a/drivers/net/phy/mdio-aspeed.c b/drivers/net/phy/mdio/mdio-
> aspeed.c
> similarity index 100%
> rename from drivers/net/phy/mdio-aspeed.c
> rename to drivers/net/phy/mdio/mdio-aspeed.c
> diff --git a/drivers/net/phy/mdio-bcm-iproc.c b/drivers/net/phy/mdio/mdio=
-
> bcm-iproc.c
> similarity index 100%
> rename from drivers/net/phy/mdio-bcm-iproc.c
> rename to drivers/net/phy/mdio/mdio-bcm-iproc.c
> diff --git a/drivers/net/phy/mdio-bcm-unimac.c
> b/drivers/net/phy/mdio/mdio-bcm-unimac.c
> similarity index 100%
> rename from drivers/net/phy/mdio-bcm-unimac.c
> rename to drivers/net/phy/mdio/mdio-bcm-unimac.c
> diff --git a/drivers/net/phy/mdio-bitbang.c b/drivers/net/phy/mdio/mdio-
> bitbang.c
> similarity index 100%
> rename from drivers/net/phy/mdio-bitbang.c
> rename to drivers/net/phy/mdio/mdio-bitbang.c
> diff --git a/drivers/net/phy/mdio-cavium.c b/drivers/net/phy/mdio/mdio-
> cavium.c
> similarity index 100%
> rename from drivers/net/phy/mdio-cavium.c
> rename to drivers/net/phy/mdio/mdio-cavium.c
> diff --git a/drivers/net/phy/mdio-cavium.h b/drivers/net/phy/mdio/mdio-
> cavium.h
> similarity index 100%
> rename from drivers/net/phy/mdio-cavium.h
> rename to drivers/net/phy/mdio/mdio-cavium.h
> diff --git a/drivers/net/phy/mdio-gpio.c b/drivers/net/phy/mdio/mdio-
> gpio.c
> similarity index 100%
> rename from drivers/net/phy/mdio-gpio.c
> rename to drivers/net/phy/mdio/mdio-gpio.c
> diff --git a/drivers/net/phy/mdio-hisi-femac.c
> b/drivers/net/phy/mdio/mdio-hisi-femac.c
> similarity index 100%
> rename from drivers/net/phy/mdio-hisi-femac.c
> rename to drivers/net/phy/mdio/mdio-hisi-femac.c
> diff --git a/drivers/net/phy/mdio-ipq4019.c b/drivers/net/phy/mdio/mdio-
> ipq4019.c
> similarity index 100%
> rename from drivers/net/phy/mdio-ipq4019.c
> rename to drivers/net/phy/mdio/mdio-ipq4019.c
> diff --git a/drivers/net/phy/mdio-ipq8064.c b/drivers/net/phy/mdio/mdio-
> ipq8064.c
> similarity index 100%
> rename from drivers/net/phy/mdio-ipq8064.c
> rename to drivers/net/phy/mdio/mdio-ipq8064.c
> diff --git a/drivers/net/phy/mdio-moxart.c b/drivers/net/phy/mdio/mdio-
> moxart.c
> similarity index 100%
> rename from drivers/net/phy/mdio-moxart.c
> rename to drivers/net/phy/mdio/mdio-moxart.c
> diff --git a/drivers/net/phy/mdio-mscc-miim.c b/drivers/net/phy/mdio/mdio=
-
> mscc-miim.c
> similarity index 100%
> rename from drivers/net/phy/mdio-mscc-miim.c
> rename to drivers/net/phy/mdio/mdio-mscc-miim.c
> diff --git a/drivers/net/phy/mdio-mux-bcm-iproc.c
> b/drivers/net/phy/mdio/mdio-mux-bcm-iproc.c
> similarity index 100%
> rename from drivers/net/phy/mdio-mux-bcm-iproc.c
> rename to drivers/net/phy/mdio/mdio-mux-bcm-iproc.c
> diff --git a/drivers/net/phy/mdio-mux-gpio.c b/drivers/net/phy/mdio/mdio-
> mux-gpio.c
> similarity index 100%
> rename from drivers/net/phy/mdio-mux-gpio.c
> rename to drivers/net/phy/mdio/mdio-mux-gpio.c
> diff --git a/drivers/net/phy/mdio-mux-meson-g12a.c
> b/drivers/net/phy/mdio/mdio-mux-meson-g12a.c
> similarity index 100%
> rename from drivers/net/phy/mdio-mux-meson-g12a.c
> rename to drivers/net/phy/mdio/mdio-mux-meson-g12a.c
> diff --git a/drivers/net/phy/mdio-mux-mmioreg.c
> b/drivers/net/phy/mdio/mdio-mux-mmioreg.c
> similarity index 100%
> rename from drivers/net/phy/mdio-mux-mmioreg.c
> rename to drivers/net/phy/mdio/mdio-mux-mmioreg.c
> diff --git a/drivers/net/phy/mdio-mux-multiplexer.c
> b/drivers/net/phy/mdio/mdio-mux-multiplexer.c
> similarity index 100%
> rename from drivers/net/phy/mdio-mux-multiplexer.c
> rename to drivers/net/phy/mdio/mdio-mux-multiplexer.c
> diff --git a/drivers/net/phy/mdio-mux.c b/drivers/net/phy/mdio/mdio-mux.c
> similarity index 100%
> rename from drivers/net/phy/mdio-mux.c
> rename to drivers/net/phy/mdio/mdio-mux.c
> diff --git a/drivers/net/phy/mdio-mvusb.c b/drivers/net/phy/mdio/mdio-
> mvusb.c
> similarity index 100%
> rename from drivers/net/phy/mdio-mvusb.c
> rename to drivers/net/phy/mdio/mdio-mvusb.c
> diff --git a/drivers/net/phy/mdio-octeon.c b/drivers/net/phy/mdio/mdio-
> octeon.c
> similarity index 100%
> rename from drivers/net/phy/mdio-octeon.c
> rename to drivers/net/phy/mdio/mdio-octeon.c
> diff --git a/drivers/net/phy/mdio-sun4i.c b/drivers/net/phy/mdio/mdio-
> sun4i.c
> similarity index 100%
> rename from drivers/net/phy/mdio-sun4i.c
> rename to drivers/net/phy/mdio/mdio-sun4i.c
> diff --git a/drivers/net/phy/mdio-thunder.c b/drivers/net/phy/mdio/mdio-
> thunder.c
> similarity index 100%
> rename from drivers/net/phy/mdio-thunder.c
> rename to drivers/net/phy/mdio/mdio-thunder.c
> diff --git a/drivers/net/phy/mdio-xgene.c b/drivers/net/phy/mdio/mdio-
> xgene.c
> similarity index 100%
> rename from drivers/net/phy/mdio-xgene.c
> rename to drivers/net/phy/mdio/mdio-xgene.c
> diff --git a/drivers/net/phy/phy/Kconfig b/drivers/net/phy/phy/Kconfig
> new file mode 100644
> index 000000000000..51c01e51be34
> --- /dev/null
> +++ b/drivers/net/phy/phy/Kconfig
> @@ -0,0 +1,243 @@
> +config AMD_PHY
> +	tristate "AMD PHYs"
> +	help
> +	  Currently supports the am79c874
> +
> +config ADIN_PHY
> +	tristate "Analog Devices Industrial Ethernet PHYs"
> +	help
> +	  Adds support for the Analog Devices Industrial Ethernet PHYs.
> +	  Currently supports the:
> +	  - ADIN1200 - Robust,Industrial, Low Power 10/100 Ethernet PHY
> +	  - ADIN1300 - Robust,Industrial, Low Latency 10/100/1000 Gigabit
> +	    Ethernet PHY
> +
> +config MESON_GXL_PHY
> +	tristate "Amlogic Meson GXL Internal PHY"
> +	depends on ARCH_MESON || COMPILE_TEST
> +	help
> +	  Currently has a driver for the Amlogic Meson GXL Internal PHY
> +
> +config AQUANTIA_PHY
> +	tristate "Aquantia PHYs"
> +	help
> +	  Currently supports the Aquantia AQ1202, AQ2104, AQR105, AQR405
> +
> +config AX88796B_PHY
> +	tristate "Asix PHYs"
> +	help
> +	  Currently supports the Asix Electronics PHY found in the X-Surf
> 100
> +	  AX88796B package.
> +
> +config BCM_NET_PHYLIB
> +	tristate
> +
> +config BCM54140_PHY
> +	tristate "Broadcom BCM54140 PHY"
> +	depends on PHYLIB
> +	depends on HWMON || HWMON=3Dn
> +	select BCM_NET_PHYLIB
> +	help
> +	  Support the Broadcom BCM54140 Quad SGMII/QSGMII PHY.
> +
> +	  This driver also supports the hardware monitoring of this PHY and
> +	  exposes voltage and temperature sensors.
> +
> +config BROADCOM_PHY
> +	tristate "Broadcom BCM5xxx PHYs"
> +	select BCM_NET_PHYLIB
> +	help
> +	  Currently supports the BCM5411, BCM5421, BCM5461, BCM54616S,
> BCM5464,
> +	  BCM5481, BCM54810 and BCM5482 PHYs.
> +
> +config BCM63XX_PHY
> +	tristate "Broadcom 63xx SOCs internal PHY"
> +	depends on BCM63XX || COMPILE_TEST
> +	select BCM_NET_PHYLIB
> +	help
> +	  Currently supports the 6348 and 6358 PHYs.
> +
> +config BCM7XXX_PHY
> +	tristate "Broadcom 7xxx SOCs internal PHYs"
> +	select BCM_NET_PHYLIB
> +	help
> +	  Currently supports the BCM7366, BCM7439, BCM7445, and
> +	  40nm and 65nm generation of BCM7xxx Set Top Box SoCs.
> +
> +config BCM84881_PHY
> +	tristate "Broadcom BCM84881 PHY"
> +	depends on PHYLIB
> +	help
> +	  Support the Broadcom BCM84881 PHY.
> +
> +config BCM87XX_PHY
> +	tristate "Broadcom BCM8706 and BCM8727 PHYs"
> +	help
> +	  Currently supports the BCM8706 and BCM8727 10G Ethernet PHYs.
> +
> +config BCM_CYGNUS_PHY
> +	tristate "Broadcom Cygnus/Omega SoC internal PHY"
> +	depends on ARCH_BCM_IPROC || COMPILE_TEST
> +	depends on MDIO_BCM_IPROC
> +	select BCM_NET_PHYLIB
> +	help
> +	  This PHY driver is for the 1G internal PHYs of the Broadcom
> +	  Cygnus and Omega Family SoC.
> +
> +	  Currently supports internal PHY's used in the BCM11300,
> +	  BCM11320, BCM11350, BCM11360, BCM58300, BCM58302,
> +	  BCM58303 & BCM58305 Broadcom Cygnus SoCs.
> +
> +config CICADA_PHY
> +	tristate "Cicada PHYs"
> +	help
> +	  Currently supports the cis8204
> +
> +config CORTINA_PHY
> +	tristate "Cortina EDC CDR 10G Ethernet PHY"
> +	help
> +	  Currently supports the CS4340 phy.
> +
> +config DAVICOM_PHY
> +	tristate "Davicom PHYs"
> +	help
> +	  Currently supports dm9161e and dm9131
> +
> +config ICPLUS_PHY
> +	tristate "ICPlus PHYs"
> +	help
> +	  Currently supports the IP175C and IP1001 PHYs.
> +
> +config INTEL_XWAY_PHY
> +	tristate "Intel XWAY PHYs"
> +	help
> +	  Supports the Intel XWAY (former Lantiq) 11G and 22E PHYs.
> +	  These PHYs are marked as standalone chips under the names
> +	  PEF 7061, PEF 7071 and PEF 7072 or integrated into the Intel
> +	  SoCs xRX200, xRX300, xRX330, xRX350 and xRX550.
> +
> +config LXT_PHY
> +	tristate "Intel LXT PHYs"
> +	help
> +	  Currently supports the lxt970, lxt971
> +
> +config LSI_ET1011C_PHY
> +	tristate "LSI ET1011C PHY"
> +	help
> +	  Supports the LSI ET1011C PHY.
> +
> +config MARVELL_PHY
> +	tristate "Marvell Alaska 1Gbit PHYs"
> +	help
> +	  Currently has a driver for the 88E1011S
> +
> +config MARVELL_10G_PHY
> +	tristate "Marvell Alaska 10Gbit PHYs"
> +	help
> +	  Support for the Marvell Alaska MV88X3310 and compatible PHYs.
> +
> +config MICREL_PHY
> +	tristate "Micrel PHYs"
> +	help
> +	  Supports the KSZ9021, VSC8201, KS8001 PHYs.
> +
> +config MICROCHIP_PHY
> +	tristate "Microchip LAN88XX PHYs"
> +	help
> +	  Supports the LAN88XX PHYs.
> +
> +config MICROCHIP_T1_PHY
> +	tristate "Microchip LAN87xx T1 PHYs"
> +	help
> +	  Supports the LAN87XX PHYs.
> +
> +config MICROSEMI_PHY
> +	tristate "Microsemi PHYs"
> +	depends on MACSEC || MACSEC=3Dn
> +	select CRYPTO_LIB_AES if MACSEC
> +	help
> +	  Currently supports VSC8514, VSC8530, VSC8531, VSC8540 and VSC8541
> PHYs
> +
> +config NATIONAL_PHY
> +	tristate "National Semiconductor PHYs"
> +	help
> +	  Currently supports the DP83865 PHY.
> +
> +config NXP_TJA11XX_PHY
> +	tristate "NXP TJA11xx PHYs support"
> +	depends on HWMON
> +	help
> +	  Currently supports the NXP TJA1100 and TJA1101 PHY.
> +
> +config AT803X_PHY
> +	tristate "Qualcomm Atheros AR803X PHYs"
> +	depends on REGULATOR
> +	help
> +	  Currently supports the AR8030, AR8031, AR8033 and AR8035 model
> +
> +config QSEMI_PHY
> +	tristate "Quality Semiconductor PHYs"
> +	help
> +	  Currently supports the qs6612
> +
> +config REALTEK_PHY
> +	tristate "Realtek PHYs"
> +	help
> +	  Supports the Realtek 821x PHY.
> +
> +config RENESAS_PHY
> +	tristate "Renesas PHYs"
> +	help
> +	  Supports the Renesas PHYs uPD60620 and uPD60620A.
> +
> +config ROCKCHIP_PHY
> +	tristate "Rockchip Ethernet PHYs"
> +	help
> +	  Currently supports the integrated Ethernet PHY.
> +
> +config SMSC_PHY
> +	tristate "SMSC PHYs"
> +	help
> +	  Currently supports the LAN83C185, LAN8187 and LAN8700 PHYs
> +
> +config STE10XP
> +	tristate "STMicroelectronics STe10Xp PHYs"
> +	help
> +	  This is the driver for the STe100p and STe101p PHYs.
> +
> +config TERANETICS_PHY
> +	tristate "Teranetics PHYs"
> +	help
> +	  Currently supports the Teranetics TN2020
> +
> +config DP83822_PHY
> +	tristate "Texas Instruments DP83822/825/826 PHYs"
> +	help
> +	  Supports the DP83822, DP83825I, DP83825CM, DP83825CS, DP83825S,
> +	  DP83826C and DP83826NC PHYs.
> +
> +config DP83848_PHY
> +	tristate "Texas Instruments DP83848 PHY"
> +	help
> +	  Supports the DP83848 PHY.
> +
> +config DP83867_PHY
> +	tristate "Texas Instruments DP83867 Gigabit PHY"
> +	help
> +	  Currently supports the DP83867 PHY.
> +
> +config DP83869_PHY
> +	tristate "Texas Instruments DP83869 Gigabit PHY"
> +	help
> +	  Currently supports the DP83869 PHY.  This PHY supports copper and
> +	  fiber connections.
> +
> +config DP83TC811_PHY
> +	tristate "Texas Instruments DP83TC811 PHY"
> +	help
> +	  Supports the DP83TC811 PHY.
> +
> +config VITESSE_PHY
> +	tristate "Vitesse PHYs"
> +	help
> +	  Currently supports the vsc8244
> diff --git a/drivers/net/phy/phy/Makefile b/drivers/net/phy/phy/Makefile
> new file mode 100644
> index 000000000000..f0c2b82c03ac
> --- /dev/null
> +++ b/drivers/net/phy/phy/Makefile
> @@ -0,0 +1,50 @@
> +# SPDX-License-Identifier: GPL-2.0
> +# Makefile for Linux PHY drivers
> +
> +obj-$(CONFIG_ADIN_PHY)		+=3D adin.o
> +obj-$(CONFIG_AMD_PHY)		+=3D amd.o
> +aquantia-objs			+=3D aquantia_main.o
> +ifdef CONFIG_HWMON
> +aquantia-objs			+=3D aquantia_hwmon.o
> +endif
> +obj-$(CONFIG_AQUANTIA_PHY)	+=3D aquantia.o
> +obj-$(CONFIG_AT803X_PHY)	+=3D at803x.o
> +obj-$(CONFIG_AX88796B_PHY)	+=3D ax88796b.o
> +obj-$(CONFIG_BCM54140_PHY)	+=3D bcm54140.o
> +obj-$(CONFIG_BCM63XX_PHY)	+=3D bcm63xx.o
> +obj-$(CONFIG_BCM7XXX_PHY)	+=3D bcm7xxx.o
> +obj-$(CONFIG_BCM84881_PHY)	+=3D bcm84881.o
> +obj-$(CONFIG_BCM87XX_PHY)	+=3D bcm87xx.o
> +obj-$(CONFIG_BCM_CYGNUS_PHY)	+=3D bcm-cygnus.o
> +obj-$(CONFIG_BCM_NET_PHYLIB)	+=3D bcm-phy-lib.o
> +obj-$(CONFIG_BROADCOM_PHY)	+=3D broadcom.o
> +obj-$(CONFIG_CICADA_PHY)	+=3D cicada.o
> +obj-$(CONFIG_CORTINA_PHY)	+=3D cortina.o
> +obj-$(CONFIG_DAVICOM_PHY)	+=3D davicom.o
> +obj-$(CONFIG_DP83640_PHY)	+=3D dp83640.o
> +obj-$(CONFIG_DP83822_PHY)	+=3D dp83822.o
> +obj-$(CONFIG_DP83848_PHY)	+=3D dp83848.o
> +obj-$(CONFIG_DP83867_PHY)	+=3D dp83867.o
> +obj-$(CONFIG_DP83869_PHY)	+=3D dp83869.o
> +obj-$(CONFIG_DP83TC811_PHY)	+=3D dp83tc811.o
> +obj-$(CONFIG_ICPLUS_PHY)	+=3D icplus.o
> +obj-$(CONFIG_INTEL_XWAY_PHY)	+=3D intel-xway.o
> +obj-$(CONFIG_LSI_ET1011C_PHY)	+=3D et1011c.o
> +obj-$(CONFIG_LXT_PHY)		+=3D lxt.o
> +obj-$(CONFIG_MARVELL_10G_PHY)	+=3D marvell10g.o
> +obj-$(CONFIG_MARVELL_PHY)	+=3D marvell.o
> +obj-$(CONFIG_MESON_GXL_PHY)	+=3D meson-gxl.o
> +obj-$(CONFIG_MICREL_PHY)	+=3D micrel.o
> +obj-$(CONFIG_MICROCHIP_PHY)	+=3D microchip.o
> +obj-$(CONFIG_MICROCHIP_T1_PHY)	+=3D microchip_t1.o
> +obj-$(CONFIG_MICROSEMI_PHY)	+=3D mscc/
> +obj-$(CONFIG_NATIONAL_PHY)	+=3D national.o
> +obj-$(CONFIG_NXP_TJA11XX_PHY)	+=3D nxp-tja11xx.o
> +obj-$(CONFIG_QSEMI_PHY)		+=3D qsemi.o
> +obj-$(CONFIG_REALTEK_PHY)	+=3D realtek.o
> +obj-$(CONFIG_RENESAS_PHY)	+=3D uPD60620.o
> +obj-$(CONFIG_ROCKCHIP_PHY)	+=3D rockchip.o
> +obj-$(CONFIG_SMSC_PHY)		+=3D smsc.o
> +obj-$(CONFIG_STE10XP)		+=3D ste10Xp.o
> +obj-$(CONFIG_TERANETICS_PHY)	+=3D teranetics.o
> +obj-$(CONFIG_VITESSE_PHY)	+=3D vitesse.o
> diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/phy/adin.c
> similarity index 100%
> rename from drivers/net/phy/adin.c
> rename to drivers/net/phy/phy/adin.c
> diff --git a/drivers/net/phy/amd.c b/drivers/net/phy/phy/amd.c
> similarity index 100%
> rename from drivers/net/phy/amd.c
> rename to drivers/net/phy/phy/amd.c
> diff --git a/drivers/net/phy/aquantia.h b/drivers/net/phy/phy/aquantia.h
> similarity index 100%
> rename from drivers/net/phy/aquantia.h
> rename to drivers/net/phy/phy/aquantia.h
> diff --git a/drivers/net/phy/aquantia_hwmon.c
> b/drivers/net/phy/phy/aquantia_hwmon.c
> similarity index 100%
> rename from drivers/net/phy/aquantia_hwmon.c
> rename to drivers/net/phy/phy/aquantia_hwmon.c
> diff --git a/drivers/net/phy/aquantia_main.c
> b/drivers/net/phy/phy/aquantia_main.c
> similarity index 100%
> rename from drivers/net/phy/aquantia_main.c
> rename to drivers/net/phy/phy/aquantia_main.c
> diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/phy/at803x.c
> similarity index 100%
> rename from drivers/net/phy/at803x.c
> rename to drivers/net/phy/phy/at803x.c
> diff --git a/drivers/net/phy/ax88796b.c b/drivers/net/phy/phy/ax88796b.c
> similarity index 100%
> rename from drivers/net/phy/ax88796b.c
> rename to drivers/net/phy/phy/ax88796b.c
> diff --git a/drivers/net/phy/bcm-cygnus.c b/drivers/net/phy/phy/bcm-
> cygnus.c
> similarity index 100%
> rename from drivers/net/phy/bcm-cygnus.c
> rename to drivers/net/phy/phy/bcm-cygnus.c
> diff --git a/drivers/net/phy/bcm-phy-lib.c b/drivers/net/phy/phy/bcm-phy-
> lib.c
> similarity index 100%
> rename from drivers/net/phy/bcm-phy-lib.c
> rename to drivers/net/phy/phy/bcm-phy-lib.c
> diff --git a/drivers/net/phy/bcm-phy-lib.h b/drivers/net/phy/phy/bcm-phy-
> lib.h
> similarity index 100%
> rename from drivers/net/phy/bcm-phy-lib.h
> rename to drivers/net/phy/phy/bcm-phy-lib.h
> diff --git a/drivers/net/phy/bcm54140.c b/drivers/net/phy/phy/bcm54140.c
> similarity index 100%
> rename from drivers/net/phy/bcm54140.c
> rename to drivers/net/phy/phy/bcm54140.c
> diff --git a/drivers/net/phy/bcm63xx.c b/drivers/net/phy/phy/bcm63xx.c
> similarity index 100%
> rename from drivers/net/phy/bcm63xx.c
> rename to drivers/net/phy/phy/bcm63xx.c
> diff --git a/drivers/net/phy/bcm7xxx.c b/drivers/net/phy/phy/bcm7xxx.c
> similarity index 100%
> rename from drivers/net/phy/bcm7xxx.c
> rename to drivers/net/phy/phy/bcm7xxx.c
> diff --git a/drivers/net/phy/bcm84881.c b/drivers/net/phy/phy/bcm84881.c
> similarity index 100%
> rename from drivers/net/phy/bcm84881.c
> rename to drivers/net/phy/phy/bcm84881.c
> diff --git a/drivers/net/phy/bcm87xx.c b/drivers/net/phy/phy/bcm87xx.c
> similarity index 100%
> rename from drivers/net/phy/bcm87xx.c
> rename to drivers/net/phy/phy/bcm87xx.c
> diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/phy/broadcom.c
> similarity index 100%
> rename from drivers/net/phy/broadcom.c
> rename to drivers/net/phy/phy/broadcom.c
> diff --git a/drivers/net/phy/cicada.c b/drivers/net/phy/phy/cicada.c
> similarity index 100%
> rename from drivers/net/phy/cicada.c
> rename to drivers/net/phy/phy/cicada.c
> diff --git a/drivers/net/phy/cortina.c b/drivers/net/phy/phy/cortina.c
> similarity index 100%
> rename from drivers/net/phy/cortina.c
> rename to drivers/net/phy/phy/cortina.c
> diff --git a/drivers/net/phy/davicom.c b/drivers/net/phy/phy/davicom.c
> similarity index 100%
> rename from drivers/net/phy/davicom.c
> rename to drivers/net/phy/phy/davicom.c
> diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/phy/dp83640.c
> similarity index 100%
> rename from drivers/net/phy/dp83640.c
> rename to drivers/net/phy/phy/dp83640.c
> diff --git a/drivers/net/phy/dp83640_reg.h
> b/drivers/net/phy/phy/dp83640_reg.h
> similarity index 100%
> rename from drivers/net/phy/dp83640_reg.h
> rename to drivers/net/phy/phy/dp83640_reg.h
> diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/phy/dp83822.c
> similarity index 100%
> rename from drivers/net/phy/dp83822.c
> rename to drivers/net/phy/phy/dp83822.c
> diff --git a/drivers/net/phy/dp83848.c b/drivers/net/phy/phy/dp83848.c
> similarity index 100%
> rename from drivers/net/phy/dp83848.c
> rename to drivers/net/phy/phy/dp83848.c
> diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/phy/dp83867.c
> similarity index 100%
> rename from drivers/net/phy/dp83867.c
> rename to drivers/net/phy/phy/dp83867.c
> diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/phy/dp83869.c
> similarity index 100%
> rename from drivers/net/phy/dp83869.c
> rename to drivers/net/phy/phy/dp83869.c
> diff --git a/drivers/net/phy/dp83tc811.c b/drivers/net/phy/phy/dp83tc811.=
c
> similarity index 100%
> rename from drivers/net/phy/dp83tc811.c
> rename to drivers/net/phy/phy/dp83tc811.c
> diff --git a/drivers/net/phy/et1011c.c b/drivers/net/phy/phy/et1011c.c
> similarity index 100%
> rename from drivers/net/phy/et1011c.c
> rename to drivers/net/phy/phy/et1011c.c
> diff --git a/drivers/net/phy/icplus.c b/drivers/net/phy/phy/icplus.c
> similarity index 100%
> rename from drivers/net/phy/icplus.c
> rename to drivers/net/phy/phy/icplus.c
> diff --git a/drivers/net/phy/intel-xway.c b/drivers/net/phy/phy/intel-
> xway.c
> similarity index 100%
> rename from drivers/net/phy/intel-xway.c
> rename to drivers/net/phy/phy/intel-xway.c
> diff --git a/drivers/net/phy/lxt.c b/drivers/net/phy/phy/lxt.c
> similarity index 100%
> rename from drivers/net/phy/lxt.c
> rename to drivers/net/phy/phy/lxt.c
> diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/phy/marvell.c
> similarity index 100%
> rename from drivers/net/phy/marvell.c
> rename to drivers/net/phy/phy/marvell.c
> diff --git a/drivers/net/phy/marvell10g.c
> b/drivers/net/phy/phy/marvell10g.c
> similarity index 100%
> rename from drivers/net/phy/marvell10g.c
> rename to drivers/net/phy/phy/marvell10g.c
> diff --git a/drivers/net/phy/meson-gxl.c b/drivers/net/phy/phy/meson-gxl.=
c
> similarity index 100%
> rename from drivers/net/phy/meson-gxl.c
> rename to drivers/net/phy/phy/meson-gxl.c
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/phy/micrel.c
> similarity index 100%
> rename from drivers/net/phy/micrel.c
> rename to drivers/net/phy/phy/micrel.c
> diff --git a/drivers/net/phy/microchip.c b/drivers/net/phy/phy/microchip.=
c
> similarity index 100%
> rename from drivers/net/phy/microchip.c
> rename to drivers/net/phy/phy/microchip.c
> diff --git a/drivers/net/phy/microchip_t1.c
> b/drivers/net/phy/phy/microchip_t1.c
> similarity index 100%
> rename from drivers/net/phy/microchip_t1.c
> rename to drivers/net/phy/phy/microchip_t1.c
> diff --git a/drivers/net/phy/mscc/Makefile
> b/drivers/net/phy/phy/mscc/Makefile
> similarity index 100%
> rename from drivers/net/phy/mscc/Makefile
> rename to drivers/net/phy/phy/mscc/Makefile
> diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/phy/mscc/mscc.=
h
> similarity index 100%
> rename from drivers/net/phy/mscc/mscc.h
> rename to drivers/net/phy/phy/mscc/mscc.h
> diff --git a/drivers/net/phy/mscc/mscc_fc_buffer.h
> b/drivers/net/phy/phy/mscc/mscc_fc_buffer.h
> similarity index 100%
> rename from drivers/net/phy/mscc/mscc_fc_buffer.h
> rename to drivers/net/phy/phy/mscc/mscc_fc_buffer.h
> diff --git a/drivers/net/phy/mscc/mscc_mac.h
> b/drivers/net/phy/phy/mscc/mscc_mac.h
> similarity index 100%
> rename from drivers/net/phy/mscc/mscc_mac.h
> rename to drivers/net/phy/phy/mscc/mscc_mac.h
> diff --git a/drivers/net/phy/mscc/mscc_macsec.c
> b/drivers/net/phy/phy/mscc/mscc_macsec.c
> similarity index 100%
> rename from drivers/net/phy/mscc/mscc_macsec.c
> rename to drivers/net/phy/phy/mscc/mscc_macsec.c
> diff --git a/drivers/net/phy/mscc/mscc_macsec.h
> b/drivers/net/phy/phy/mscc/mscc_macsec.h
> similarity index 100%
> rename from drivers/net/phy/mscc/mscc_macsec.h
> rename to drivers/net/phy/phy/mscc/mscc_macsec.h
> diff --git a/drivers/net/phy/mscc/mscc_main.c
> b/drivers/net/phy/phy/mscc/mscc_main.c
> similarity index 100%
> rename from drivers/net/phy/mscc/mscc_main.c
> rename to drivers/net/phy/phy/mscc/mscc_main.c
> diff --git a/drivers/net/phy/national.c b/drivers/net/phy/phy/national.c
> similarity index 100%
> rename from drivers/net/phy/national.c
> rename to drivers/net/phy/phy/national.c
> diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/phy/nxp-
> tja11xx.c
> similarity index 100%
> rename from drivers/net/phy/nxp-tja11xx.c
> rename to drivers/net/phy/phy/nxp-tja11xx.c
> diff --git a/drivers/net/phy/qsemi.c b/drivers/net/phy/phy/qsemi.c
> similarity index 100%
> rename from drivers/net/phy/qsemi.c
> rename to drivers/net/phy/phy/qsemi.c
> diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/phy/realtek.c
> similarity index 100%
> rename from drivers/net/phy/realtek.c
> rename to drivers/net/phy/phy/realtek.c
> diff --git a/drivers/net/phy/rockchip.c b/drivers/net/phy/phy/rockchip.c
> similarity index 100%
> rename from drivers/net/phy/rockchip.c
> rename to drivers/net/phy/phy/rockchip.c
> diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/phy/smsc.c
> similarity index 100%
> rename from drivers/net/phy/smsc.c
> rename to drivers/net/phy/phy/smsc.c
> diff --git a/drivers/net/phy/ste10Xp.c b/drivers/net/phy/phy/ste10Xp.c
> similarity index 100%
> rename from drivers/net/phy/ste10Xp.c
> rename to drivers/net/phy/phy/ste10Xp.c
> diff --git a/drivers/net/phy/teranetics.c
> b/drivers/net/phy/phy/teranetics.c
> similarity index 100%
> rename from drivers/net/phy/teranetics.c
> rename to drivers/net/phy/phy/teranetics.c
> diff --git a/drivers/net/phy/uPD60620.c b/drivers/net/phy/phy/uPD60620.c
> similarity index 100%
> rename from drivers/net/phy/uPD60620.c
> rename to drivers/net/phy/phy/uPD60620.c
> diff --git a/drivers/net/phy/vitesse.c b/drivers/net/phy/phy/vitesse.c
> similarity index 100%
> rename from drivers/net/phy/vitesse.c
> rename to drivers/net/phy/phy/vitesse.c
> --
> 2.28.0.rc0

