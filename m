Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD1C2D1A36
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 21:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgLGUEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 15:04:11 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:40715 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbgLGUEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 15:04:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607371449; x=1638907449;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Zu5UCQFS3nkDjhTGNWeH07M2QjGRfbfPcXq2XoU/cqo=;
  b=S7V4BNlAYhfymQKTI0ZnGwCkKCzC8RRxZbjuDTE9j+reroV/VLKmxIEx
   +TXn7b8srjol4uH+9MdPkaswfARG9UoFZ7bYPXj4W0OIKQbQbNkUvjsG4
   rFfS98dmqPQU3o6DrTlaEM4q0j2EFhborGtUak/ksCfYCb+oOgCZcy0xH
   8lM58ztr6azvyzP3jlYtzNx6tFXFCot6m0Kb4dJn11C0x4E+EST5H332L
   UCBfpmEu1M4Ib0NdV5gdfTZwQBiLAWJKEjaTxi/vrng9daAMGlR8iAYyN
   hpofIfx/ED+cXagK9ZgUFPeWs1zqeoLAM6gc2mGuyHjahSOtdMRQ1wqJh
   Q==;
IronPort-SDR: 1CMFeS4UzJ/SWhXyov1iVan939LGNohbMkKDJg3r9rKbTtwMwbYGdPcJx/zNGx9GeetWwKJvI6
 LaUNjzULRtH138Blpt6k2rV4lc00WnZp5nClCOQyVfn5rR3/1KOhqWmZA1bR0b+ApHN9oA+eo2
 2eKV0IXXdZiBI4yDHVBax/2MOtrmubQY+ydJSwadbxumuatqr3r8fxuz71PQEPnV6VuyC3Yijy
 Lw1JSbQTBS7z979EKpc8riHWCUi1EghxDvW2C/9jFIRt1WuqDfN2WL26GAwtDfj0FVPV2KQKNO
 mEY=
X-IronPort-AV: E=Sophos;i="5.78,400,1599548400"; 
   d="scan'208";a="98926235"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Dec 2020 13:03:04 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 7 Dec 2020 13:03:04 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Mon, 7 Dec 2020 13:03:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lvN9g2a0dm+QAsOdBw4Ue76Ccj1+xR0Wy6SflAbHfP0ckVvVpD1Lyllmh5++UviA3SBAceuReSqdjZs8sjwNl3Sn4MWpgwE/lDFjgpN7sJmHoxfhqH4pFQk5GMigns9luwU6rr7Z7nOF6yrccf6Vg4c6Lq1BK1jQU2ePwGUnKmjosXfo+jvQJiaUpano2ZWhMDmYfzRj3B1+mPD+FBc6LKQvvLHAk3lyf3ggEXdEwNSHq1Gzt0gQXRa34Dw++b3UegwNnG7XkaJU/rjq1Wc8T2XGNzAvjFSUGgdya68txuQ7XMiE1e+Bc5ZTQYPBG4czvudJVugAj48cNUCQW1GrlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JzYyfRynFRXPT8p9+WgX8XBI8jf26ec104oWBffjHeg=;
 b=RS/lL3ffr+NRGTQXeaGmLHsfSrRrNaVo0VEF/1ckTWOLMrBJfcVME/oEPXT03uN7kc1M14kOtE1G86h80JJs4//Gk6SdssL9PW9jE750tTP8/uhXMFqQR/9q2C2IKpZn3fatXYhBR9esaKRlh5Zn52Kvg8TYKecUSLCXIJwN40ZlEigy4wZ5j8ktorjalOWEN13FXIOkNFEQzPwNP3Z33GRtXF/i2+PAusAHU3G7uIjSX2KgD/iKVObItEjhS04av4bEXBSGVQy8l/6mVrhQK+qgYRMtY2F3+CilBSMVesw/odkrjtlsqO/JdFSKm8sGR36PdD7CxDbrRNZ6mqnHfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JzYyfRynFRXPT8p9+WgX8XBI8jf26ec104oWBffjHeg=;
 b=AdLEqIajBN5++65lnLlA8HUfMuWyb2XsnafiGiihci0hmAauLe7k0oeTkOUW5pQd2mKf+ealH0Qp8qkjCHeK6DtH1/ZTNOvXTVqazwQc1nJFYqLjnB95BQS44PNR/4l6mYW5Rgt5tj7hj6WDGL9lgdB8O9z6PNSov9iQjLUQ7IQ=
Received: from BYAPR11MB3558.namprd11.prod.outlook.com (2603:10b6:a03:b3::11)
 by BYAPR11MB2837.namprd11.prod.outlook.com (2603:10b6:a02:c6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Mon, 7 Dec
 2020 20:02:58 +0000
Received: from BYAPR11MB3558.namprd11.prod.outlook.com
 ([fe80::ddf8:d2b5:c453:4ad8]) by BYAPR11MB3558.namprd11.prod.outlook.com
 ([fe80::ddf8:d2b5:c453:4ad8%7]) with mapi id 15.20.3632.017; Mon, 7 Dec 2020
 20:02:58 +0000
From:   <Tristram.Ha@microchip.com>
To:     <m.grzeschik@pengutronix.de>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <kernel@pengutronix.de>, <netdev@vger.kernel.org>,
        <matthias.schiffer@ew.tq-group.com>, <Woojung.Huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH v5 3/6] net: dsa: microchip: ksz8795: move register
 offsets and shifts to separate struct
Thread-Topic: [PATCH v5 3/6] net: dsa: microchip: ksz8795: move register
 offsets and shifts to separate struct
Thread-Index: AQHWzJiDl1ccCGRBEE+DUl26VAp2xKnsBQTA
Date:   Mon, 7 Dec 2020 20:02:57 +0000
Message-ID: <BYAPR11MB3558976CEC22D7EDB99CB429ECCE0@BYAPR11MB3558.namprd11.prod.outlook.com>
References: <20201207125627.30843-1-m.grzeschik@pengutronix.de>
 <20201207125627.30843-4-m.grzeschik@pengutronix.de>
In-Reply-To: <20201207125627.30843-4-m.grzeschik@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none
 header.from=microchip.com;
x-originating-ip: [99.25.38.29]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dc8c5ef0-5e82-4c17-9771-08d89aeb181c
x-ms-traffictypediagnostic: BYAPR11MB2837:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB2837312DED3D4531896DFC20ECCE0@BYAPR11MB2837.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sUuexfI63Pr+dGQgPChcChX2zi4hxi4EuVciH6Fv5nC1214ftcAgDFnykeC1mjzRjIN6oy8VfqngX21LpS3kCUGAU+iOKYUtWQxDMjik+lXSCPGSJkW+Z22JTIoOA1yBbER87bbYjiK+cReBVQsIsALrZyvE+ZJcKxU+lAop8E2ttgsSGxhMWyaIMoT0evWWue0ntTvpZNoaOSRTTOmZsv8UrBsGz/+Qu9vjYt5Y2RqVPBra8IpHlksMNHikhOFYlOchWYa5W3Ag70T3BI9dzNelhCSJ3ZzdNOllLQExrM4dQO/3g2b5mqlfMQHRBj1ER58E9LWpvfcdRUrUixcWww==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3558.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(376002)(396003)(346002)(136003)(2906002)(7696005)(8936002)(33656002)(55016002)(66946007)(66476007)(83380400001)(9686003)(66556008)(66446008)(8676002)(71200400001)(64756008)(107886003)(4326008)(54906003)(478600001)(6916009)(5660300002)(186003)(52536014)(316002)(6506007)(86362001)(26005)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?k6KXF+EvlJlYXAFfQLDTfM0lGuoPPOGmV/I+2F5esSBFFsLvo3zaP9rbqwW9?=
 =?us-ascii?Q?xgp+YZALAH6i3n104nGkpkkKMTHhPt5XdH1WGwJX6YtMHuJzbeET9fLiN3Wt?=
 =?us-ascii?Q?32yBNGctNvmC5Qq5asXf3FSyVsYuVOd9zhOikqJpDTsbFIGXLowKbm47Qlyi?=
 =?us-ascii?Q?EtPs1ywjLk0PR4ypKMzjjuHewsOuGZXlCXXwfjergUR6XF+UofB8f5c945u9?=
 =?us-ascii?Q?g+9CfA5/nRRuxddNJvCeU+5nWvEepdUDYnloueTlo5d7loNjcZMdX0w2DJuj?=
 =?us-ascii?Q?ABy9zirT2nHzsyTCJ/uIj3LGubMsBIS3LGLYhw7SJKiEwW5kah/qoCenVm4I?=
 =?us-ascii?Q?CiUinEh4lWDCA481YE6mN8HN/a6yJtKceOPv2FaHYWBgBfckooQDKj+UqhmP?=
 =?us-ascii?Q?Njr1osnOmI79AWWa3v0YdOvjAmW7ct+WA5C4as0tEepuIvoetVmUw1WR32eh?=
 =?us-ascii?Q?Kflcqkc5VMi78mQyFGpNTGcpBslEC9yaYXSjqbyREro8Uvj08TLiLjfBqmCi?=
 =?us-ascii?Q?EWPA5pVl9wLvbD4NciNMS8xxrGR8X60HSIv8eCZkt+qFy7RY3QY0vZzJPFTj?=
 =?us-ascii?Q?ewChebn8MCKJzDQA5YFbOPknxlt+TyzvR7kQjehCbknQMQyXA8pUv4AwPLd6?=
 =?us-ascii?Q?BBWa5XlO33nO9X3yPbPwFnxN4NsdbCyjTjTaibA+Q/OVdfu0ybkyb9efG+Au?=
 =?us-ascii?Q?szbNgv30qJ7magc2i6+uUTKtWmuptZYS/EGJhODkEDSYRILWKSbZzyMPzNov?=
 =?us-ascii?Q?ax/mvkM3TGCOPxotdlIa2gDR3KkgSLEl1VS2MkwyZBK4hBPSkEA0gq6Kkvtw?=
 =?us-ascii?Q?ojE4y8FjrQALnJVoT1SLGYJX3siU6/dwzZYl2z59X2bGp0Tk22QtyCIf1l9p?=
 =?us-ascii?Q?appI7g/ENEQSYnDjl2LW05bHHG+KFg7slKK9kEvSFDU4k8xuwm+hrB0pnikB?=
 =?us-ascii?Q?VSp+4DAF2Wd9A6z0cKXbzTuPx73f/kkdhY8Qje8Bvw8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3558.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc8c5ef0-5e82-4c17-9771-08d89aeb181c
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2020 20:02:58.4694
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KgWTH/FTkxBtzQLa8ccawUTA2MnilqyJ1rLzV1HZYGlnZWjB9awIRMmRmv9jmtzeqjTmAFe13iMZPgEn7yEOoYbuROP9kWQKLTBqsQF8vhc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2837
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> In order to get this driver used with other switches the functions need
> to use different offsets and register shifts. This patch changes the
> direct use of the register defines to register description structures,
> which can be set depending on the chips register layout.
>=20
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
>=20
> ---
> v1 -> v4: - extracted this change from bigger previous patch
> v4 -> v5: - added missing variables in ksz8_r_vlan_entries
>           - moved shifts, masks and registers to arrays indexed by enums
>           - using unsigned types where possible
> ---
>  drivers/net/dsa/microchip/ksz8.h        |  69 +++++++
>  drivers/net/dsa/microchip/ksz8795.c     | 261 +++++++++++++++++-------
>  drivers/net/dsa/microchip/ksz8795_reg.h |  85 --------
>  3 files changed, 253 insertions(+), 162 deletions(-)
>  create mode 100644 drivers/net/dsa/microchip/ksz8.h

Sorry for not respond to these patches sooner.

There are 3 older KSZ switch families: KSZ8863/73, KSZ8895/64, and KSZ8795/=
94.
The newer KSZ8795 is not considered an upgrade for KSZ8895, so some of
these switch registers are moved around and some features are dropped.

It is best to have one driver to support all 3 switches, but some operation=
s are
Incompatible so it may be better to keep the drivers separate for now.

For basic operations those issues may not occur so it seems simple to have
one driver handling all 3 switches.  I will come up with a list of those
incompatibilities.

The tail tag format of KSZ8863 is different from KSZ8895 and KSZ8795, but
because of the DSA driver implementation that issue never comes up.

> -static void ksz8_from_vlan(u16 vlan, u8 *fid, u8 *member, u8 *valid)
> +static void ksz8_from_vlan(struct ksz_device *dev, u32 vlan, u8 *fid,
> +                          u8 *member, u8 *valid)
>  {
> -       *fid =3D vlan & VLAN_TABLE_FID;
> -       *member =3D (vlan & VLAN_TABLE_MEMBERSHIP) >>
> VLAN_TABLE_MEMBERSHIP_S;
> -       *valid =3D !!(vlan & VLAN_TABLE_VALID);
> +       struct ksz8 *ksz8 =3D dev->priv;
> +       const u32 *masks =3D ksz8->masks;
> +       const u8 *shifts =3D ksz8->shifts;
> +
> +       *fid =3D vlan & masks[VLAN_TABLE_FID];
> +       *member =3D (vlan & masks[VLAN_TABLE_MEMBERSHIP]) >>
> +                       shifts[VLAN_TABLE_MEMBERSHIP_S];
> +       *valid =3D !!(vlan & masks[VLAN_TABLE_VALID]);
>  }
>=20
> -static void ksz8_to_vlan(u8 fid, u8 member, u8 valid, u16 *vlan)
> +static void ksz8_to_vlan(struct ksz_device *dev, u8 fid, u8 member, u8
> valid,
> +                        u32 *vlan)
>  {
> +       struct ksz8 *ksz8 =3D dev->priv;
> +       const u32 *masks =3D ksz8->masks;
> +       const u8 *shifts =3D ksz8->shifts;
> +
>         *vlan =3D fid;
> -       *vlan |=3D (u16)member << VLAN_TABLE_MEMBERSHIP_S;
> +       *vlan |=3D (u16)member << shifts[VLAN_TABLE_MEMBERSHIP_S];
>         if (valid)
> -               *vlan |=3D VLAN_TABLE_VALID;
> +               *vlan |=3D masks[VLAN_TABLE_VALID];
>  }
>=20
>  static void ksz8_r_vlan_entries(struct ksz_device *dev, u16 addr)
>  {
> +       struct ksz8 *ksz8 =3D dev->priv;
> +       const u8 *shifts =3D ksz8->shifts;
>         u64 data;
>         int i;
>=20
> @@ -418,7 +509,7 @@ static void ksz8_r_vlan_entries(struct ksz_device
> *dev, u16 addr)
>         addr *=3D dev->phy_port_cnt;
>         for (i =3D 0; i < dev->phy_port_cnt; i++) {
>                 dev->vlan_cache[addr + i].table[0] =3D (u16)data;
> -               data >>=3D VLAN_TABLE_S;
> +               data >>=3D shifts[VLAN_TABLE];
>         }
>  }
>=20
> @@ -454,6 +545,8 @@ static void ksz8_w_vlan_table(struct ksz_device *dev,
> u16 vid, u32 vlan)
>=20

The VLAN table operation in KSZ8863 is completely different from KSZ8795.

> -/**
> - * VLAN_TABLE_FID                      00-007F007F-007F007F
> - * VLAN_TABLE_MEMBERSHIP               00-0F800F80-0F800F80
> - * VLAN_TABLE_VALID                    00-10001000-10001000
> - */
> -
> -#define VLAN_TABLE_FID                 0x007F
> -#define VLAN_TABLE_MEMBERSHIP          0x0F80
> -#define VLAN_TABLE_VALID               0x1000
> -
> -#define VLAN_TABLE_MEMBERSHIP_S                7
> -#define VLAN_TABLE_S                   16
> -

In KSZ8795 you can use all 4096 VLAN id.  Each entry in the table contains
4 VID.  The FID is actually used for lookup and there is a limit, so you ne=
ed
to convert VID to FID when programming the VLAN table.

The only effect of using FID is the same MAC address can be used in
different VLANs.

In KSZ8863 there are only 16 entries in the VLAN table.  Just like static
MAC table each entry is programmed using an index.  The entry contains
the VID, which does not have any relationship with the index unlike in
KSZ8795.

The number of FID is also limited to 16.  So the maximum VLAN used is 16.

>  /**
>   * MIB_COUNTER_VALUE                   00-00000000-3FFFFFFF
>   * MIB_TOTAL_BYTES                     00-0000000F-FFFFFFFF
> @@ -956,9 +874,6 @@
>   * MIB_COUNTER_OVERFLOW                        00-00000040-00000000
>   */
>=20
> -#define MIB_COUNTER_OVERFLOW           BIT(6)
> -#define MIB_COUNTER_VALID              BIT(5)
> -
>  #define MIB_COUNTER_VALUE              0x3FFFFFFF

The MIB counters are also a little different in KSZ8863 and KSZ8795.
KSZ8863 may have smaller total bytes.  In normal operation this issue may
not come up.

