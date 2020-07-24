Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A04C22C95E
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 17:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgGXPio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 11:38:44 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:12106 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbgGXPin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 11:38:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595605123; x=1627141123;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=L1LZ3/W4fKFHSwdiz+cNlyxiWT8K5jvJg3rmGNxlzz8=;
  b=EX0A7BSC8RkryqilqAKRIKACweMSaOC1PgLbdLfubni9rZC07T58cIi6
   f5hHLWS7KzQ8MEv9IN4SVWw6ttLsq4svQXKG1jluwgq3mlNLuJFx+STIA
   TKPdvY3bwiEPkDHIgZoKC884E/+FQm+Sf2OR9rqbBvRls6V1HBgVBm1PE
   U5l2SGGxNmGhXr9v/KE8qwP9zBmrd9yOznYPyNilXBeJUDgra8r34jslZ
   M5V/UOTmy1ksEzuVv8WYqw1a+ghVLmnDWbKToQZYHGk2b0+PFro1cCLX2
   nOb2O5nQuAYWdKs2XhmLFAzRSyFLfLDJRpE8cp9Eb7yXzrfCBw27UmVTJ
   w==;
IronPort-SDR: UITYq28uINNst2innDxK0/aNGnuSUu3nmzyedyM22f9inE55LMmOvi88Uc/vT0pu6iDVjENJvo
 Qqo8HxLgPewrTjp+WPpMAmsuKrMd/AZBPA/BjR85b3cWlELjmsNiSiZl+5UJC5T7mVbaGNJpmO
 I4nNNGgCQ7xZcqkXVgcMOs8q7AyDNYtWpwb+8jDQCeDE8PCgtZyH2Y9KACsdMev9m6WlwEp7H1
 mJJLf7T0uXAr+HA9MAL2cirBG66+VCbQ4RXFweabRtzbH0SiAFiAyWSdnNTnnn5OreBd9cPAi3
 vjA=
X-IronPort-AV: E=Sophos;i="5.75,391,1589266800"; 
   d="scan'208";a="81184979"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jul 2020 08:38:42 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 24 Jul 2020 08:37:59 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Fri, 24 Jul 2020 08:37:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gn6dJyoB6j5Co0PdnoHLJzcdj4tkx0PJa2oCvDQhgs7ewlDaojmujKu50qdkU0RHzBhVmd60O4PNxpGRkJP48OsQkL9/eIQts+PRwCHTURIKt5WONOi8pb5JBmJcwyQc5aZKILpcHS9Qpr11Dzr79YB36w/aNSV8Tkv/Y8vXQQapGCxaChx1XnOu/Vn6/YjIltlD74yLFxqeM5wDyKv48r5J9/wbaGjHeWucn4b/VZlFPnRsRsfLS0AJ9bdsTmUROazE3aXKiTqorwVFsQBc4a3sFzAbtuqTV8sG5lgUg0p8YK5F9NZdc4JUCmtAH0D/qIi1zUt4GxzsyNO95IiWGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J/OqRjeeUncsyNTxKpR48CvC45U7jRxDlAQMBkDG07o=;
 b=QkG0zBEXOGmPoAqkc7wp/d+PyDSsu57W7nQCLxbnL46BeeeIfmppxR2h6EJQwseF5zU9f6hzzwQfveqQi/OWJyEC7J4hfE8WK3HngdQiOYT8c2M4JrNWfj1C+ZOtJH4KW1a5b4g56BTlp3QyrWZdGS0iRAH/18fLITOIBdBdXAvEo4AYiisc/JYaKID3gLizOQ76nb0tslZ6RQ21j72ThVs8BWMdkV2/Y/XOhQXQsqxUprAY0cbyO90gIP6W8z9ylNT4sf0pZ6lWqHaxsYkenHC8R4Pb5OFaFKoJGTHlpYMbEjPVyQcyYiCFn8UTCBCC6ymZUHaFeFBHnh3ocblo5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J/OqRjeeUncsyNTxKpR48CvC45U7jRxDlAQMBkDG07o=;
 b=fGJZLvRA8Kd+uThsF4i1HEQOxYHj5ztqvM1B5+vi8BjFeHNUDDvlnSMqDl/P6lLU+mIjmIg9rvEUIf/LGHY7GiocW2CWjtsYdxIgYl6Q8emsi1ooSBkLpg8ST2wczRJEZHQlCO5zfkyEE8UsPlz8B8CYnPqleeew9+1Z/+iofrs=
Received: from MN2PR11MB3662.namprd11.prod.outlook.com (2603:10b6:208:ee::11)
 by MN2PR11MB3792.namprd11.prod.outlook.com (2603:10b6:208:f7::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.22; Fri, 24 Jul
 2020 15:38:40 +0000
Received: from MN2PR11MB3662.namprd11.prod.outlook.com
 ([fe80::64d6:baa6:7bec:3c54]) by MN2PR11MB3662.namprd11.prod.outlook.com
 ([fe80::64d6:baa6:7bec:3c54%7]) with mapi id 15.20.3216.026; Fri, 24 Jul 2020
 15:38:40 +0000
From:   <Bryan.Whitehead@microchip.com>
To:     <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH net-next] mscc: Add LCPLL Reset to VSC8574 Family of phy
 drivers
Thread-Topic: [PATCH net-next] mscc: Add LCPLL Reset to VSC8574 Family of phy
 drivers
Thread-Index: AQHWYS1Pa/FhIgpObUi5DOaSOO6xe6kWt7WAgAAm5aA=
Date:   Fri, 24 Jul 2020 15:38:40 +0000
Message-ID: <MN2PR11MB3662EE0CFF3200534A728764FA770@MN2PR11MB3662.namprd11.prod.outlook.com>
References: <1595534997-29187-1-git-send-email-Bryan.Whitehead@microchip.com>
 <20200724131917.GE1472201@lunn.ch>
In-Reply-To: <20200724131917.GE1472201@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [68.195.34.108]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 35ce7391-4459-411d-e0e1-08d82fe7a3f0
x-ms-traffictypediagnostic: MN2PR11MB3792:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3792E2DB7B9ADBA62E587245FA770@MN2PR11MB3792.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: phanppXVD9oeVDF43kAp1cODh9BuFLlGZrpkvsq42q30ekCmQym3CvFkteRuUzGL43ldmCNc65YuI/3b67i85lcVhCClIdkr9pponI60OSo4AtImEzzU/Ua5iT/h0XoSbY1z0W5NHuF6x9JR2cvBF7oaT9GdUH/prAZQ4+l0EYk0GpcZYoxmkmkHYYaI0EiIpGKFDCDWoYCvwDuJou1097O8b7zQPYr2GZNJXtUa6LOGpQYc1Y79lvowNVjcnMxNdmkFfsOJ/MKFhv2wTEiknke/pyfXmeXT9qVNeqFOECX/+9CfywKShP7A470pQiDPJ/k8uEljv7HnrquK/vbgVw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3662.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(396003)(366004)(346002)(39860400002)(376002)(316002)(2906002)(9686003)(26005)(53546011)(33656002)(7696005)(478600001)(54906003)(55016002)(6506007)(186003)(8676002)(8936002)(83380400001)(64756008)(4326008)(66446008)(66476007)(107886003)(66946007)(66556008)(6916009)(86362001)(71200400001)(52536014)(5660300002)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: sf0d0wEdhDWhDtLJCt3uVMFM8MtqilnlWLG4sfTobRDOsGy10CQaIzikRgwL5SaNKvfgJYed8uTTMojYzEGusZZUZDnTHBRoAN0tWZ9U3lYa23A+P68BOdilxDy4869V4k8PnlCM7iFasbnfcfLNk7FhqgJe+9uducc90JxmV8CZIP2OC+Ls6WgC2GNKnxZOFWhIafhp6yAfT9RnPnoumCs7CIT0t1tU1pwGS+xWPxU28y9OMnVxXtn3BYny53TU8eAtINfk/Xm0oaYhnHivJ0UVumY2xws9kfSzcr9kKzyCYu5SWB2BrNnt7yStGUiyoXpwOPSPlWIOH4Mn6ADMGWOo1RXOFjPquvtgNu2nE4jw5u9AaMYdC4IMf/2f9bSpCKSrChETiKwFSjt/B3fSZJFG2p2nlrmTAof9ddEYiyLgII2ZGJ97T4MDZI80FQeLYmIvEKe2qJs6srptWDLYNhTM1YShB5DPjSKCg7UEHIQ=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3662.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35ce7391-4459-411d-e0e1-08d82fe7a3f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2020 15:38:40.6568
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jEEuWKNp3+CmO6oWqpl3ccMYmqFbSKR2zwOafSbV5d3ZyhtzXKs41gESnHMsmWsHNVDSFOnBsEdOjAaA6AhqQKv6sTMTxfC3g3teSvr+ufc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3792
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Andrew, I will apply your suggestions.

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Friday, July 24, 2020 9:19 AM
> To: Bryan Whitehead - C21958 <Bryan.Whitehead@microchip.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; UNGLinuxDriver
> <UNGLinuxDriver@microchip.com>
> Subject: Re: [PATCH net-next] mscc: Add LCPLL Reset to VSC8574 Family of =
phy
> drivers
>=20
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> On Thu, Jul 23, 2020 at 04:09:57PM -0400, Bryan Whitehead wrote:
> > The LCPLL Reset sequence is added to the initialization path of the
> > VSC8574 Family of phy drivers.
> >
> > The LCPLL Reset sequence is known to reduce hardware inter-op issues
> > when using the QSGMII MAC interface.
> >
> > This patch is submitted to net-next to avoid merging conflicts that
> > may arise if submitted to net.
> >
> > Signed-off-by: Bryan Whitehead <Bryan.Whitehead@microchip.com>
> > ---
> >  drivers/net/phy/mscc/mscc_main.c | 90
> > ++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 90 insertions(+)
> >
> > diff --git a/drivers/net/phy/mscc/mscc_main.c
> > b/drivers/net/phy/mscc/mscc_main.c
> > index a4fbf3a..f2fa221 100644
> > --- a/drivers/net/phy/mscc/mscc_main.c
> > +++ b/drivers/net/phy/mscc/mscc_main.c
> > @@ -929,6 +929,90 @@ static bool vsc8574_is_serdes_init(struct
> > phy_device *phydev)  }
> >
> >  /* bus->mdio_lock should be locked when using this function */
> > +/* Page should already be set to MSCC_PHY_PAGE_EXTENDED_GPIO */
> > +static int vsc8574_wait_for_micro_complete(struct phy_device *phydev)
> > +{
> > +     u16 timeout =3D 500;
> > +     u16 reg18g =3D 0;
> > +
> > +     reg18g =3D phy_base_read(phydev, 18);
> > +     while (reg18g & 0x8000) {
> > +             timeout--;
> > +             if (timeout =3D=3D 0)
> > +                     return -1;
>=20
> Hi Bryan
>=20
> -ETIMEDOUT;
>=20
> But as Florian said, please add a phy_base_read_poll_timeout() following =
what
> phy_read_poll_timeout() does.
>=20
> > +             usleep_range(1000, 2000);
> > +             reg18g =3D phy_base_read(phydev, 18);
> > +     }
> > +
> > +     return 0;
> > +}
>=20
>=20
> > +
> > +/* bus->mdio_lock should be locked when using this function */ static
> > +int vsc8574_reset_lcpll(struct phy_device *phydev) {
> > +     u16 reg_val =3D 0;
> > +     int ret =3D 0;
> > +
> > +     phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS,
> > +                    MSCC_PHY_PAGE_EXTENDED_GPIO);
> > +
> > +     /* Read LCPLL config vector into PRAM */
> > +     phy_base_write(phydev, 18, 0x8023);
> > +     ret =3D vsc8574_wait_for_micro_complete(phydev);
> > +     if (ret)
> > +             goto done;
> ...
> > +
> > +done:
> > +     phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS,
> MSCC_PHY_PAGE_STANDARD);
> > +     return ret;
> > +}
>=20
> So if vsc8574_wait_for_micro_complete() was to return -1, you pass it on.
>=20
> > +
> > +/* bus->mdio_lock should be locked when using this function */
> >  static int vsc8574_config_pre_init(struct phy_device *phydev)  {
> >       static const struct reg_val pre_init1[] =3D { @@ -1002,6 +1086,12
> > @@ static int vsc8574_config_pre_init(struct phy_device *phydev)
> >       bool serdes_init;
> >       int ret;
> >
> > +     ret =3D vsc8574_reset_lcpll(phydev);
> > +     if (ret) {
> > +             dev_err(dev, "failed lcpll reset\n");
> > +             return ret;
> > +     }
>=20
> And pass it on further. It could reach user space as an errno. It is just=
 safer to
> always use an errno value.
>=20
>      Andrew
