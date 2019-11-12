Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40C73F9B52
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 21:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbfKLU4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 15:56:22 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:17881 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726718AbfKLU4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 15:56:21 -0500
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Bryan.Whitehead@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Bryan.Whitehead@microchip.com";
  x-sender="Bryan.Whitehead@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Bryan.Whitehead@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; spf=Pass smtp.mailfrom=Bryan.Whitehead@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: iOZF2MiRIGt8NQnobQmaGhMMm++awndlrSlq8t5DvueinXXkxMi58QLZscHZloYGU/ZVxd3Vh9
 NWCpHS6VRSC9+S4G5efBowV/43BA4tBldYtW97bH8XF5bzYqFNLBmnIRC55NpgYgF+r6nROyhJ
 E90L+omcDwvchM38F1Sq1SKcQuNSFsP8E9m0FOTgVpiAgxybCUEOY78ZRaaTDXCogSOytuZpDC
 fzg+t2mI+HDaKL1dtCxzvw3Py2xg2AlBvswKS4Os28a4tLCfYLkwk1tFqtm8u450ngaKZJp33D
 i6k=
X-IronPort-AV: E=Sophos;i="5.68,297,1569308400"; 
   d="scan'208";a="54008556"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Nov 2019 13:56:20 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 12 Nov 2019 13:56:11 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 12 Nov 2019 13:56:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ng+J/4vdJudJfLgpP5EGA9lJo4YkuocUHVSIjcNWHeruQOXKGMob6/WCXmkBHpmQIo4IJexJISfGi3oY2VLQeHomWiKcDwPQxkiVeS6ZwFEEUmMIIMVMTEYsgCLlAPB3TnWl1NUqCn7/SgycRsLgK1wC4OXvOelW5qoR5XBPOkeKd2dkPSy2bm9PP7N8/IFKfFbn/U1sX/DOK5r5VJLcSBJ8m2CGnVkB5+bncmaK8CV8tilQ7L9txswi/Rdm7/SmB/N7qFsbwQehJVYyWOouu5yWhGHHSIYjW642/WdMQqekwG+Uqb1w/X3B/CQ2huVjApxj6z8Gw61yVKaDB6C6Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=06BdHPzNL1BViFG24z7wI0LiQoUeqWIns7AO4OqB9X4=;
 b=TlsQ1dSSZFsmXS6qaxwXmWjFE3OymrVLBL6hTL5SGIhSFFmtDkEbX6EDr/T1/vA34RYcitYRo8VLhj22PfXgMAblVFyR3yutD+BBtnyRruOcZ+A/lNXJF5KUtbGLWUHW430mldr8P3aDT7ENGQs2OoI2tOiSghzrWm7y8bQuqJvDkaLj6gmmQTWQXVrnq8O+Ib9SefEApG6RPQyexpJvq6VIa/QcN2K2hwQoxtv9QMSb4Qnn9vQJAWR7+x9ZiULOlOMUiasEtagorB+1bd6Kfpu2Ijrhyok4paSVAFxROtE1PqsfIv4a0KJfPp+KLrCuQ1tnxXjoTyd0N6G2fxlr2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=06BdHPzNL1BViFG24z7wI0LiQoUeqWIns7AO4OqB9X4=;
 b=IRMHUMR0/qT6vcYKtibOFd5YYlP9rms4KLY6ycxJnWrbQ/jwrng/HhActrZiT3BFdj8n0WFKBryGrotme9cihk48t/JkQ9sHRZ9wBulojbzV9FRd8DAIWNKWuuRX1JhcmUNwG77+q0RMxn8gAPstuWH3gLVFgtmigC22MooGffU=
Received: from MN2PR11MB4333.namprd11.prod.outlook.com (10.255.90.25) by
 MN2PR11MB3727.namprd11.prod.outlook.com (20.178.252.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Tue, 12 Nov 2019 20:56:08 +0000
Received: from MN2PR11MB4333.namprd11.prod.outlook.com
 ([fe80::e82a:ef05:d8ca:4cd]) by MN2PR11MB4333.namprd11.prod.outlook.com
 ([fe80::e82a:ef05:d8ca:4cd%6]) with mapi id 15.20.2430.023; Tue, 12 Nov 2019
 20:56:08 +0000
From:   <Bryan.Whitehead@microchip.com>
To:     <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH v1 net-next] mscc.c: Add support for additional VSC PHYs
Thread-Topic: [PATCH v1 net-next] mscc.c: Add support for additional VSC PHYs
Thread-Index: AQHVmXJIiwJOwhRbeU+HRtKC5Z72x6eH//SAgAABu0A=
Date:   Tue, 12 Nov 2019 20:56:08 +0000
Message-ID: <MN2PR11MB4333B89CD568C6B66C8C60E3FA770@MN2PR11MB4333.namprd11.prod.outlook.com>
References: <1573574048-12251-1-git-send-email-Bryan.Whitehead@microchip.com>
 <20191112204031.GH10875@lunn.ch>
In-Reply-To: <20191112204031.GH10875@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [47.19.18.123]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 314c28f7-96d2-431e-0d95-08d767b2be2a
x-ms-traffictypediagnostic: MN2PR11MB3727:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3727B365C66ED948F4D43A64FA770@MN2PR11MB3727.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(346002)(396003)(366004)(376002)(199004)(189003)(256004)(71200400001)(71190400001)(446003)(8676002)(66066001)(25786009)(9686003)(8936002)(6436002)(4326008)(52536014)(55016002)(229853002)(81156014)(3846002)(6116002)(81166006)(2906002)(316002)(11346002)(54906003)(99286004)(14454004)(5660300002)(33656002)(486006)(476003)(7696005)(6506007)(76176011)(6916009)(66946007)(66476007)(86362001)(186003)(305945005)(74316002)(478600001)(26005)(6246003)(76116006)(66446008)(107886003)(66556008)(102836004)(64756008)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3727;H:MN2PR11MB4333.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JAZgbbBtPODtEjBSzGNbvMZYTLEbh1c05XRycXpASPgp/7SZh+RMtiJ7i2A7xym/teZbqzslQpWs87IPLtZJ5df7KS3bZLAQhGTBV8yPZp4v6XESuhdSaXmnumNTnNKtinruuw4Xqjwd3A079aNbmEKpTI0qkue2yNDb23XmWyNNR/VFV5wsyFwxdpgn+lzqK+tlGFw0hVONMgyAwYvsMOnYBtGMsjW21vnjKatpG82TIgVZVhjoUpglU1XsN5z4/pypWKaekzxbpSSSnYZH61JFRNj2/Nlk2zYZUgTQY4j8Ia/dIeojZxpZs1jG6Yn8paR6JGKZSKjZ9g77ZyT1Ik+CFfnvT9a+JTaIL9UZelSBoA5HFtDWbQYijSBI4ahK/I3wpxjRZs9oMoXJpZsqp+h2VzCPegV2/b/spb1MMP7MDMxyNd6ub3867KAmqlxq
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 314c28f7-96d2-431e-0d95-08d767b2be2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 20:56:08.6592
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zDqA5b5zb31fhzuc5ExLfZf8kaB0gfgp9YJg5eeFpPyqaieFzETRvfMJcH7x9IVQLjdJve9tLXYFso7PRoIeqn2wR1q0G9qj0rAKUgGi2LI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3727
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Tue, Nov 12, 2019 at 10:54:08AM -0500, Bryan Whitehead wrote:
> > Add support for the following VSC PHYs
> > 	VSC8504, VSC8552, VSC8572,
> > 	VSC8562, VSC8564, VSC8575, VSC8582
> >
> > Signed-off-by: Bryan Whitehead <Bryan.Whitehead@microchip.com>
> > ---
> >  drivers/net/phy/mscc.c | 182
> > +++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 182 insertions(+)
> >
> > diff --git a/drivers/net/phy/mscc.c b/drivers/net/phy/mscc.c index
> > 805cda3..8933681 100644
> > --- a/drivers/net/phy/mscc.c
> > +++ b/drivers/net/phy/mscc.c
> > @@ -253,12 +253,18 @@ enum rgmii_rx_clock_delay {
> >  #define MSCC_PHY_TR_MSB			  18
> >
> >  /* Microsemi PHY ID's */
> > +#define PHY_ID_VSC8504			  0x000704c0
> >  #define PHY_ID_VSC8514			  0x00070670
> >  #define PHY_ID_VSC8530			  0x00070560
> >  #define PHY_ID_VSC8531			  0x00070570
> >  #define PHY_ID_VSC8540			  0x00070760
> >  #define PHY_ID_VSC8541			  0x00070770
> > +#define PHY_ID_VSC8552			  0x000704e0
> > +#define PHY_ID_VSC856X			  0x000707e0
> > +#define PHY_ID_VSC8572			  0x000704d0
> >  #define PHY_ID_VSC8574			  0x000704a0
> > +#define PHY_ID_VSC8575			  0x000707d0
> > +#define PHY_ID_VSC8582			  0x000707b0
> >  #define PHY_ID_VSC8584			  0x000707c0
> >
> >  #define MSCC_VDDMAC_1500		  1500
> > @@ -1597,6 +1603,8 @@ static bool vsc8584_is_pkg_init(struct
> > phy_device *phydev, bool reversed)
> >
> >  		phy =3D container_of(map[addr], struct phy_device, mdio);
> >
> > +		if (!phy)
> > +			continue;
> > +
> >  		if ((phy->phy_id & phydev->drv->phy_id_mask) !=3D
> >  		    (phydev->drv->phy_id & phydev->drv->phy_id_mask))
> >  			continue;
> > @@ -1648,9 +1656,27 @@ static int vsc8584_config_init(struct phy_device
> *phydev)
> >  	 */
> >  	if (!vsc8584_is_pkg_init(phydev, val & PHY_ADDR_REVERSED ? 1 : 0))
> {
> >  		if ((phydev->phy_id & phydev->drv->phy_id_mask) =3D=3D
> > +		    (PHY_ID_VSC8504 & phydev->drv->phy_id_mask))
> > +			ret =3D vsc8574_config_pre_init(phydev);
> > +		else if ((phydev->phy_id & phydev->drv->phy_id_mask) =3D=3D
> > +		    (PHY_ID_VSC8552 & phydev->drv->phy_id_mask))
> > +			ret =3D vsc8574_config_pre_init(phydev);
> > +		else if ((phydev->phy_id & phydev->drv->phy_id_mask) =3D=3D
> > +		    (PHY_ID_VSC856X & phydev->drv->phy_id_mask))
> > +			ret =3D vsc8584_config_pre_init(phydev);
>=20
> Could we turn this into a switch statement? I think
>=20
>       switch (phydev->phy_id & phydev->drv->phy_id_mask) {
>       case PHY_ID_VSC8504:
>       case PHY_ID_VSC8552:
>       	   ret =3D vsc8574_config_pre_init(phydev);
> 	   break
>       case PHY_ID_VSC856X:
>       	   ret =3D vsc8584_config_pre_init(phydev);
> 	   break;
>=20
> etc should work, since PHY_ID_VSC8<FOO> always has the lower nibble set
> to 0.

Hi Andrew,

I would like to do exactly that, but I was concerned future changes might c=
hange the phy_id_mask, so to keep code less brittle, and more flexible I th=
ought I should keep the "AND mask" operations such as (PHY_ID_VSC8<FOO> & p=
hydev->drv->phy_id_mask)

If you judge this is an unreasonable concern, then I will change it to a sw=
itch statement.
Let me know,
Thanks,
Bryan

