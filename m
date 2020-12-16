Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 659C72DBB45
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 07:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725802AbgLPGe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 01:34:26 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:14611 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725274AbgLPGe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 01:34:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1608100466; x=1639636466;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ew7ZqInoW0nIKowVG8J1JY1F/rpWh8eZTStYk2a1Jkw=;
  b=zdbNGplem3ysNBvo3qtFI5mKL1QixH+8B9KYYfcBLyLTCNzqV9gdD0p3
   ZvnMWbfgVb86G6X3wkyuKtF3OmwhMiosuPWXeOWGwkiuvz0rQAavERv24
   tSvYzitkIUDl6YBhb8O9KjLBS3Kd7dUwdwMmZhKng0JxYmHdgbMfoKzLl
   nvjkzHAlrN4navDbadMLzl4Lhv5xHlcUMnR9cnIjqc72QTcyuLbBzUZZ7
   3Y63OvrksCWcEXGxaSTnXECdfxrlyYna4dILPaO1drzWNIUOR0R0WNdu6
   SDWo60mvNkaTupk7Dv/mAFfd+8/Bsa6seZt45xZ6MK9Fi5Dc7lA28Kce1
   A==;
IronPort-SDR: t0kgNwu9ErAz8vhHYjO00mboalVYODDzvudCbZv9nEZV7P6NzsEjJJ1ZXC7U55O6v7BheacWAJ
 d0sFssbsHTXXOeX6hRO/17QS2DzFiyHgFPFJ4DbtiquPHrOwmk1UKtq/tKyQpCK6Rgb1mZ1seO
 r3ZDEcBGUFQEN5iKpzNx/ToEjWEJz8SxjpqixVQCi9liUOCuEWYpo6rhfiByYYAVlT7EA9xhNF
 mRz2iI0IymOzLxR6oZLjktjEzwAD6Yl5qbdU9pxW7K8Z7vIVYwg2KfZvykEsrWerMAKppgQIuU
 OUQ=
X-IronPort-AV: E=Sophos;i="5.78,423,1599548400"; 
   d="scan'208";a="97277707"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Dec 2020 23:33:10 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 15 Dec 2020 23:33:10 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Tue, 15 Dec 2020 23:33:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LKjmZE1C0Qw0S7gOxjbWwZv1Dl3CkA72pv1L9lTg1B03fYzV9Uy98sGOfRg4FFRaXgq8hkiAHJlPovjI+qPKS/sZ7t1qVIsAgTRGX8iDkaIEd7iPrfKPyqFllSWOwRpWPN4U+cXdb9LDUvWbVrjBLEhUPQ+/jlhKLiXGo6CqoCeRB3e97LVpUuoSBdCekhiRlWoLYOv/Zv61jJGeVz0ZlW1LgNZoKajOjAzA6jQTild2HK7OvDORHxOc0Uk+ZaFLoF4lbPnKqmnNClh9JtbcxO5ewxtHQuAhUP6k0Hwa8a3aQ11qJeBb+gAH0/+/S639/XR0tc+WK1u5PQw1roCHCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4aqgkICVntKrbc0BPyimhvpKvxz9592AY6MryyhTEGQ=;
 b=nssqz9bsccsfGrNNu62J7Y3AC+XhCU4Xh+Xa5G92qTsUUgHcVCo2vkAOqUZWSTuzJwP17rZdUWoeZk+mAOGP9LwPuAnP/yUTwMWbHewnHAq5nxJ21XAqsHvITnfwWnaP741YrQgqQabh46ol1nV+znmniLN5PY2lIaM/X83hPIH9jZlkhZYvA9/V2Vj48jxmV4gH+aVuyMR/ZByZax7rB9FCneyzJ1nqprnO+Xv8AeMwuot4umfFny4dfVZvCZ8fAo3Dp9++nz3O5Jn61eh3ivhTwLIjV03FLBF9mGdZcLkSRMrW2vGa0Z4atHqPkkfSbLscJ42jNF3/H9kDIaHKjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4aqgkICVntKrbc0BPyimhvpKvxz9592AY6MryyhTEGQ=;
 b=OwsT/cczYsFNf/ZtXOAICxy4RoszVKgvsLTqVV5jnRMeb0+HFY6EMv9B0H9ATLm0s80djWAHE4VxWNds4UST137FW4V7eJUtnOh1/BCvWTfa5viWKtZPtI1ozSVCNJXc5vy1A2B5lbN0XPhnl4H98e5xb8ckDPBnQGfMZUoWcCM=
Received: from BYAPR11MB3558.namprd11.prod.outlook.com (2603:10b6:a03:b3::11)
 by BYAPR11MB2805.namprd11.prod.outlook.com (2603:10b6:a02:c1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.17; Wed, 16 Dec
 2020 06:33:07 +0000
Received: from BYAPR11MB3558.namprd11.prod.outlook.com
 ([fe80::ddf8:d2b5:c453:4ad8]) by BYAPR11MB3558.namprd11.prod.outlook.com
 ([fe80::ddf8:d2b5:c453:4ad8%7]) with mapi id 15.20.3654.025; Wed, 16 Dec 2020
 06:33:07 +0000
From:   <Tristram.Ha@microchip.com>
To:     <m.grzeschik@pengutronix.de>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <kernel@pengutronix.de>, <netdev@vger.kernel.org>,
        <matthias.schiffer@ew.tq-group.com>, <Woojung.Huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH v5 4/6] net: dsa: microchip: ksz8795: add support for
 ksz88xx chips
Thread-Topic: [PATCH v5 4/6] net: dsa: microchip: ksz8795: add support for
 ksz88xx chips
Thread-Index: AQHWzJiCBEaZ3rgukUyu5Jv4O9bkVan5So4Q
Date:   Wed, 16 Dec 2020 06:33:06 +0000
Message-ID: <BYAPR11MB35585C642A2073D0CBC85E44ECC50@BYAPR11MB3558.namprd11.prod.outlook.com>
References: <20201207125627.30843-1-m.grzeschik@pengutronix.de>
 <20201207125627.30843-5-m.grzeschik@pengutronix.de>
In-Reply-To: <20201207125627.30843-5-m.grzeschik@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none
 header.from=microchip.com;
x-originating-ip: [99.25.38.29]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2b467529-651d-4139-0318-08d8a18c7331
x-ms-traffictypediagnostic: BYAPR11MB2805:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB2805DFB2AE416F6E8D5A1998ECC50@BYAPR11MB2805.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8+wWHhBaoK1kydB4XwMwrhijcvthYKb5muhzfSW18HFbbONCrptZg69Fp0TvANp1rVHU+dfFl/rr+oi5eODiO/nLvn/haj1eCoPZMbxdWeCICj/1Q117dzePCuxxcZh+XNkCj1vscah1fLNFyxYUj3AN252dJKu4369sgNt2WpqlxkndSEV3qDJMjVJ4kUYX6XsYPm3BupVz96A5SsuiUo8r1DEZIVRmJr3GX5ioTHs8a+6PD9oTV1JA63g8gxho/HPs4CoOCn8m7FRIzfSkIWNH5CyAnFGEm1tkDtKub/F0b5mbKPZhQTTnC/vyqJOKWoT3Ysmphj9J9BP6T/P1wA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3558.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(39860400002)(376002)(136003)(366004)(107886003)(76116006)(8676002)(64756008)(66556008)(66946007)(71200400001)(66446008)(33656002)(8936002)(5660300002)(86362001)(2906002)(316002)(55016002)(54906003)(6506007)(6916009)(66476007)(478600001)(52536014)(4326008)(26005)(7696005)(9686003)(186003)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?t6XthNctsb9C0fnbRs2057Qyv4WmGb7yUOEMhWgJTbecn7OldpK3qnSgtNOu?=
 =?us-ascii?Q?CBN8ddIwyIfMWdDjqjvgFGbRo4c8UKRvlDmmEvizQncLQT6TXeN0NhengBta?=
 =?us-ascii?Q?bqAFQRv/ZURrlX0gQ5HXTl2mlaGi3fuyXB/D2qbEomWMP4XJVXvgyzSsc+Af?=
 =?us-ascii?Q?okHxV/PGAODDv/Wafy0e3jbS1avGBDDCnA1Olm0aI/nEppsk2Ei83exgliv9?=
 =?us-ascii?Q?Y+/TrezhngsG+LdsU6ecAu/vuquiPv9JqR5teFwzctZGi7oBzpWjw+Omu0xU?=
 =?us-ascii?Q?TrGBKa1hGAAOSAISXTsjDu7VN8Jb5PfzGt6gtCqbkK89pwvobaG0HJVc+kkl?=
 =?us-ascii?Q?THNrM0J6p/t3K0hZzPMGv0mF+IBpzOLeLJCdpH4wLusQF6GSsFjIHRtK3Lr6?=
 =?us-ascii?Q?YfMeeUqTAO9lrSDRC0toa6Dpl9TB1+0raRmB3bQbGbpesFjKO8w/DRcelVtd?=
 =?us-ascii?Q?+FVKSaQigm2atscSq/COaFAvvWpN+MpqsVRME1FPhzjpIhi1E93TBgH49a19?=
 =?us-ascii?Q?oWpjIH2INy1zZ/lJaRLJCG+RTYWxR3J1UHWatKaWXwj0JslY5RGBbhM2J1jW?=
 =?us-ascii?Q?OdCGGmB5aCPgKjhym77UtP7/2KidEYkRtgCFTa4YJZKJNOna79d/H8plC4OA?=
 =?us-ascii?Q?jSKXdnrxLoOqwKNegNA4rIk/IfuqOYOg/JdZFvVFpH0nSFq7tRCcr1LTTr3y?=
 =?us-ascii?Q?alyWEDoxteS6jIu/o158HldEXdDy9cliLYVwwBTIiufpYZ8JYYfYrScR7z2g?=
 =?us-ascii?Q?E4OKMySFNvSV2idLAfyQsvfETQNnZ4sJ+Qi0fPERKZNK2NJGccz5kOuhqmNT?=
 =?us-ascii?Q?pAMBjqYYA74T/QBL5x5B2XtqZvyeW7W3y10RxqCZ6I45XociL4qgaJJXFQgJ?=
 =?us-ascii?Q?1wWQzsvYB6uZzs9aP6L42Np51KxW4kalv+9cTlfctrP+x1oC+5lbwQULVzWw?=
 =?us-ascii?Q?wXXrEu52n0nnL+oELXf7KbtXwAY7nmptC/zJ3Ff21uU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3558.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b467529-651d-4139-0318-08d8a18c7331
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2020 06:33:07.1261
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jd83E7TpOEAX92nLLXOo94ovEsBh3QhmufURK3GZ5YbA4IwH7AWLtudh1fMKQVa1+874X9JkxV+DFrDWSIbWUgO+DE5NaUlWPJ/WhkOG+vc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2805
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  static void ksz8_r_vlan_table(struct ksz_device *dev, u16 vid, u32 *vlan=
)
>  {
> -       int index;
> -       u16 *data;
> -       u16 addr;
> +       u16 addr =3D vid / dev->phy_port_cnt;
>         u64 buf;
>=20
> -       data =3D (u16 *)&buf;
> -       addr =3D vid / dev->phy_port_cnt;
> -       index =3D vid & 3;
>         ksz8_r_table(dev, TABLE_VLAN, addr, &buf);
> -       *vlan =3D data[index];
> +       if (dev->features & IS_88X3) {
> +               *vlan =3D (u32)buf;
> +       } else {
> +               u16 *data =3D (u16 *)&buf;
> +
> +               *vlan =3D data[vid & 3];
> +       }
>  }
>=20
>  static void ksz8_w_vlan_table(struct ksz_device *dev, u16 vid, u32 vlan)
>  {
> -       int index;
> -       u16 *data;
> -       u16 addr;
> +       u16 addr =3D vid / dev->phy_port_cnt;
>         u64 buf;
>=20
> -       data =3D (u16 *)&buf;
> -       addr =3D vid / dev->phy_port_cnt;
> -       index =3D vid & 3;
>         ksz8_r_table(dev, TABLE_VLAN, addr, &buf);
> -       data[index] =3D vlan;
> +
> +       if (dev->features & IS_88X3) {
> +               buf =3D vlan;
> +       } else {
> +               u16 *data =3D (u16 *)&buf;
> +
> +               data[vid & 3] =3D vlan;
> +       }
> +
>         dev->vlan_cache[vid].table[0] =3D vlan;
>         ksz8_w_table(dev, TABLE_VLAN, addr, buf);
>  }

I am confused about how the addr is derived.

In KSZ8795 vid is in range of 0-4095.  The addr is just (vid / 4) as there
are 4 entries in one access.  The data are lined up in 16-bit boundary
so that the VLAN information can be accessed using the array.

For KSZ8895 the VLAN data are not lined up so the 64-bit variable
needs to be shifted accordingly and masked.

For KSZ8863 the addr is a hard value from 0 to 15.  The data buffer is just
32-bit.  The vid value is contained in the entry.  You need to match that v=
id
with the input vid to return the right information.

You need a different VLAN read function to check if the VLAN is already
programmed in the VLAN table by searching all 16 entries.

For the VLAN write function you need to check if there is available space
to add a new entry.  The VID range is still 0-4095, but the FID range is 0-=
15.

