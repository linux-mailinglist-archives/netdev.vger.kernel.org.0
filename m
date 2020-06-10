Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 892401F53B6
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 13:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728595AbgFJLoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 07:44:11 -0400
Received: from mail-eopbgr70045.outbound.protection.outlook.com ([40.107.7.45]:45127
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728584AbgFJLoL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jun 2020 07:44:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IrUsXiME4Ghn5s7gF1owGmBCEv3Gi8FIfRYEG4NzyXquZeLk9dn81agCb/vbAuM4oTORAvZgNSFwtgN4jUJoaCeLW9ymGQgcepLNQH6CwaKKi7VyhEy6aYd/y1wFewEsmhRv/xfsFl3uxDWpjiNEe0gsMh+7ZnpbNBVTBIBbEKOIKp2z2etJyIgw8wzVJARvJR8aVnJLV8uondfKbhLTuNRZVTq19gK3CqBpunpI+nIOvVMNukDWZd3Gn2WlqLo+8v3XzmV7r9VzqHE5nj8JvOCyAluExtUZjbnFb20WUgHdCXiaL8IV2OLAn2pvH/8q10ypmsvrhAmuYlzj3Xls3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C/7HxmCMS2gOQ4TZhcnRl7e4+YtZ2KTJMQACX2NCCQA=;
 b=R/ihRt1lZIR55UB0TUpCei0+LaPn4LYsQwFRxPZZeB2Z2FufyE+zMxNjWjiVjWpe6O3UTpU4LKvk1N3hJNopMf3M4TL1avH2W0P9DxFjql5emRrNT8tAuwLKxWuLSwXwk1Mo2sLDj9pr55aL7tS0feSZdxHc1bExHBJBMPlXx9Qe1LFKUkcK+/2MBdiNPF+Ii8K2brZ9USSyHZYj1cGz6HqDSt8zcmAdhpKIzoOFv189/ccfTEMa5Ukc4K0t8cnAdTrylhMznBNZng1ZDDOzy7fxZ5raEn+EgXAtH1UDipYqbVu118httpKxeg5/XXmVgJzLB1LL4mk0GglbWwt0rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C/7HxmCMS2gOQ4TZhcnRl7e4+YtZ2KTJMQACX2NCCQA=;
 b=T76Na5sgJFLHPSfXsXUnMESt9P7EmeVJKiSc5qKHdzfFTm+KDLeZxdSL0GaLelz6b6bnCkNlyGia67aBmCYuEeQoIBThwp+yBBmh9DoQeoh1jhDrHB9DFlPBTzYkYZTKbXfO0DPflzg+hphpZzkuw54snxm5nDp2wXqbjp/Vd5w=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0402MB2750.eurprd04.prod.outlook.com
 (2603:10a6:800:b5::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18; Wed, 10 Jun
 2020 11:44:06 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0%7]) with mapi id 15.20.3088.018; Wed, 10 Jun 2020
 11:44:06 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Helmut Grohne <helmut.grohne@intenta.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: RE: correct use of PHY_INTERFACE_MODE_RGMII{,_TXID,_RXID,_ID}
Thread-Topic: correct use of PHY_INTERFACE_MODE_RGMII{,_TXID,_RXID,_ID}
Thread-Index: AQHWPv+rJSUSn7JYpECgg8rsrkvkYajRio+wgAAc+wCAAAODEA==
Date:   Wed, 10 Jun 2020 11:44:05 +0000
Message-ID: <VI1PR0402MB3871D78BA83E01301A08B4F4E0830@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200610081236.GA31659@laureti-dev>
 <VI1PR0402MB3871F98C656BF1A0A599CA59E0830@VI1PR0402MB3871.eurprd04.prod.outlook.com>
 <20200610103450.GA10547@laureti-dev>
In-Reply-To: <20200610103450.GA10547@laureti-dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intenta.de; dkim=none (message not signed)
 header.d=none;intenta.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.56.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5bd9c96a-ac4e-4bd8-4fe0-08d80d339496
x-ms-traffictypediagnostic: VI1PR0402MB2750:
x-microsoft-antispam-prvs: <VI1PR0402MB27508E31916DC24C483D53CCE0830@VI1PR0402MB2750.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0430FA5CB7
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SUq4PmjZJsRumnTyqQEFtFGGJj7TH/cU7DDatJxRg5CGvx1JHR/ytaRpyZ28cRliLLATiMpksWNkw3+ImjlSQ9Ilh93QgTJME/M9Gtk0uxuhTZmzT9KtJ2MgJkO75M4c+GnuHJE0pPUFuzYPP9Ldm1yw8ewEn3XkRqkI/2YkB/EPPtL13o56XtInjnwFRv+BpSVyVeW5a6Nrf6Lv/w8/lwRVPVnQS+mvAVvq6l4CWoFgUqGQSZQ68qvEKLytVhG56Qw7aObWRGADqJ2lbd9aICdvicQCvcgmEFiFNpjRfr6wYwNH1XbxR61CzMMI4DYAPuox63S7KLIIHBeGABp+Nn0k04QeC5Y8EyeG7eNPygraFn1oXbALJ2S/GCCtZWqA9ZzPd6qs23qbsBBpiadQwQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(39860400002)(346002)(136003)(376002)(2906002)(76116006)(186003)(26005)(4326008)(66556008)(5660300002)(316002)(64756008)(71200400001)(478600001)(66476007)(44832011)(6916009)(86362001)(52536014)(66446008)(66946007)(55016002)(6506007)(54906003)(966005)(33656002)(8676002)(7696005)(9686003)(83380400001)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: NqsqPfFKsUdfKXthftVFs7CJ5EUxHY8OsLRTrKy0aqzCSsBJ6143ozdj1g8ILL2RaSKMyWLsHB8M2jzJ7SksEvQ1MPJBCmNbARvniMrFuCqC3su2JJHknuscJSqoJ+RQ9/TJijMEsy9oc4rYILKWy7jJnmzRbCkb32pYpMaIeojwBrO6+w5RAnNQzC+wwBOKcxOIZJY+TfB7KtwelZcTLvFewddHOYCi1RjK0g29sd8J26W8QrOkPewrT4c7z376twa6u7oo2d4t/psZ9wcRD5KXnYU5AOYnTQEchyIGQiTkQMPWRkKK3gbrJs17Zj1Hq2YMl8iWaKjYZ0YSKK1XsI4/BV+6mjI2TeC1UR3RWqEzAtAYF+NSkg0MWpKSZcraySCgvsGXVxor8nHG/eoSsv3HxINJKCJjcIpArzBzCRzzlSUlndgHSsuYC4HfvQ2o3qJoPu1zI6OlXaC6dYfycXW9GWKKTkCqfJXC/l+LWR0=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bd9c96a-ac4e-4bd8-4fe0-08d80d339496
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2020 11:44:05.9067
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uCwBABnlrnZuKzuM+YZn4JPBRibMw2MN73iepbZ6nnEzIy3iCleIfqG4zAEuI+J73mC4k+B6PmTo+nmFYuGhAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2750
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: correct use of PHY_INTERFACE_MODE_RGMII{,_TXID,_RXID,_ID}
>=20
> Hi Ioana,
>=20
> On Wed, Jun 10, 2020 at 11:10:23AM +0200, Ioana Ciornei wrote:
> > > freescale/dpaa2/dpaa2-mac.c is interesting. It checks whether any
> > > rgmii mode other than PHY_INTERFACE_MODE_RGMII is used and complains
> > > that delays are not supported in that case. The above comment says
> > > that the MAC does not support adding delays. It seems that in that
> > > case, the only working mode should be PHY_INTERFACE_MODE_RGMII_ID
> > > rather than PHY_INTERFACE_MODE_RGMII. Is the code mixed up or my
> understanding?
> >
> > The snippet that you are referring to is copied below for quick referen=
ce:
> >
> > /* The MAC does not have the capability to add RGMII delays so
> >  * error out if the interface mode requests them and there is no PHY
> >  * to act upon them
> >  */
> > if (of_phy_is_fixed_link(dpmac_node) &&
> >     (mac->if_mode =3D=3D PHY_INTERFACE_MODE_RGMII_ID ||
> >      mac->if_mode =3D=3D PHY_INTERFACE_MODE_RGMII_RXID ||
> >      mac->if_mode =3D=3D PHY_INTERFACE_MODE_RGMII_TXID)) {
> > 	netdev_err(net_dev, "RGMII delay not supported\n");
> >
> > The important part which you seem to be missing is that a functional
> > RGMII link can have the delays inserted by the PHY, the MAC or by PCB
> > traces (in this exact order of preference). Here we check for any
> > RGMII interface mode that requests delays to be added when the
> > interface is in fixed link mode (using of_phy_is_fixed_link()), thus th=
ere is no
> PHY to act upon them.
> > This restriction, as the comment says, comes from the fact that the
> > MAC is not able to add RGMII delays.
> >
> > When we are dealing with a fixed link, the only solution for DPAA2 is
> > to use plain PHY_INTERFACE_MODE_RGMII and to hope that somebody
> > external to this Linux system made sure that the delays have been
> > inserted (be those PCB delays, or internal delays added by the link par=
tner).
>=20
> If I am reading this correctly, you are saying that the DPAA2 driver is o=
perating
> as a PHY, not as a MAC here. Is that correct?
>=20

Not at all. The dpaa2-mac driver operates as a MAC.

> This distinction is a bit difficult (in particular for fixed links) since=
 RGMII is
> symmetric, but it is important for understanding the definitions from
> Documentation/devicetree/bindings/net/ethernet-controller.yaml:
>=20
> |       # RX and TX delays are added by the MAC when required
> |       - rgmii
> |
> |       # RGMII with internal RX and TX delays provided by the PHY,
> |       # the MAC should not add the RX or TX delays in this case
> |       - rgmii-id
> |
> |       # RGMII with internal RX delay provided by the PHY, the MAC
> |       # should not add an RX delay in this case
> |       - rgmii-rxid
> |
> |       # RGMII with internal TX delay provided by the PHY, the MAC
> |       # should not add an TX delay in this case
> |       - rgmii-txid
>=20
> These are turned into the matching PHY_INTERFACE_MODE_* by the OF code.
>=20
> My understanding is that the delays are always described as seen by the P=
HY.
> When it says that an "internal delay" (id) is present, the delay is inter=
nal to the
> PHY, not the MAC. So unless DPAA2 is operating as a PHY, it still seems r=
eversed
> to me.
>=20
> If we think of DPAA2 as a MAC (which seems more natural to me), it should=
 only
> allow rgmii-id, becaue it does not support adding delays according to the
> comment.
>=20
> Helmut

I do see your point. According to the DT bindings document description, the=
 phy-mode
property is imperative for a PHY (rgmii-rxid =3D> apply RGMII RX delays) an=
d also imperative
for the MAC but in the reverse direction (rgmii-rxid =3D> apply RGMII TX de=
lays). That
would be a reasonable interpretation, which some drivers take (dwmac_rk.c, =
as you
pointed out).*

* by the way, the second driver you highlighted to behave "as expected", ra=
vb_main.c,
does _not_ do that, it applies all delays by itself (and _not_ in the rever=
se direction)
and then just masks them out (see "iface =3D PHY_INTERFACE_MODE_RGMII"
right before calling of_phy_connect), so that the PHY driver doesn't apply =
them again.
Arguably, this should be illegal if we were to quote the DT bindings docume=
nt.

What is actually complicating these phy-mode values for RGMII is the fact t=
hat PCB
traces exist, but they aren't accounted for by the phy-mode description. So=
 if you would
have delays introduced by PCB traces in a MAC-to-PHY setup, you would have =
no way
to describe that correctly and have a functional link at the same time (i.e=
. you couldn't
prevent the PHY _and_ the MAC from applying delays).=20

Others have stared at that DT bindings description document too, it seems, =
and they took
what appears to be a more practical approach:
https://patchwork.ozlabs.org/project/netdev/patch/20190410005700.31582-19-o=
lteanv@gmail.com/
https://patchwork.ozlabs.org/project/netdev/patch/20190413012822.30931-21-o=
lteanv@gmail.com/

Interpreting the PHY modes as informative for the MAC when there is a PHY a=
ttached
allows us to account for PCB traces. Only if there is no PHY, the PHY mode =
becomes
imperative for the MAC, and PCB traces can be accounted for in that case as=
 well.

Ioana
