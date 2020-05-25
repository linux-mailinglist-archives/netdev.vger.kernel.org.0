Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD851E11E3
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 17:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404203AbgEYPiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 11:38:51 -0400
Received: from mail-eopbgr20062.outbound.protection.outlook.com ([40.107.2.62]:42154
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404040AbgEYPiu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 11:38:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZtehEhaspkeVkPkHAHVmbJxUVf/MbNSw9C+2WWwDodOpTOybpnorYyCSO+q/lvsG+4YroZSreCkT2sUcsuSvVY8ktywakdGrlwm/1JE72O1srE054viPPhDh277003mU09QbdGvFdYMwvaod+/2cSAYk7vVFtA14sGGhl9xOZQD39EFuUuDaqAh0sRbAYnaMYLA12y+Lq45on4TCNAvBD8QyXYklFKR/wnwxe162uXe5XrYcTnimf2HHJhP5Pums7dx+tgyAKvyVgS5sQuSQr1qHZtzbfx+hRBgqeUmXdxjL7mr7KRdFsFLF14GfBXonFXPRXGYBiob+sMbV3ShrRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=53Dcbh4Z+GxFEKM1JmHEXA3hSZhxodZdnBjWByKzWlU=;
 b=UkDdQobDqfxO/yRZnSeGQNEBmGUmIp3oQrXyUniqvLfO9DeC0gQpYTHZKDNbjmSEwrbqdUlp8khwc1Tttz1sK89eoHbAX78BE6CQIKHe7s/fuHoLbImz58mFvAg1pmTnfEg49M8Djsn40CDE8PrcO9B+7P1W42zry23WhqXAyc8zi1L/Zy0co0wxFWULxhNyU0p6RFqXduLGT7mYvoId/lLLySSh6g2NOXz4DX2zcKvkMVnQltti3/AV/fj/lXo1+AA2F3lmPIHMN6dla7d/NlNYpow0nkxue91+WBaFy4Xccv6Qn8HPTv+pp9N1WIDGMhqVpxL4aFtuRihZ7yfS0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=53Dcbh4Z+GxFEKM1JmHEXA3hSZhxodZdnBjWByKzWlU=;
 b=PYvBdbg8cXy20JQI/tNnLbYjJE7wIxQ+18gs13RY+RRMXx04mwtK0ek/pfmSa+E0vR2HktIHKcCtX6MO09WxdJ32YvYED+uXmdHF2w+yF1Ly+xsA9IA0cB0kP53XWOINv23s9pAhvCLlpsZrpiCFc5mLh3wLBH52oLgNhpVVv/U=
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3382.eurprd04.prod.outlook.com
 (2603:10a6:209:3::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Mon, 25 May
 2020 15:38:45 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 15:38:45 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Sascha Hauer <s.hauer@pengutronix.de>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "martin.fuzzey@flowbird.group" <martin.fuzzey@flowbird.group>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: RE: [EXT] Re: [PATCH net v2 1/4] net: ethernet: fec: move GPR
 register offset and bit into DT
Thread-Topic: [EXT] Re: [PATCH net v2 1/4] net: ethernet: fec: move GPR
 register offset and bit into DT
Thread-Index: AQHWMmQbAjemULJOyk+5PiY4BhQghai4n1yAgABOi9A=
Date:   Mon, 25 May 2020 15:38:45 +0000
Message-ID: <AM6PR0402MB36079806C9FFFFE18BDE2EAAFFB30@AM6PR0402MB3607.eurprd04.prod.outlook.com>
References: <1590390569-4394-1-git-send-email-fugang.duan@nxp.com>
 <1590390569-4394-2-git-send-email-fugang.duan@nxp.com>
 <20200525104849.GQ11869@pengutronix.de>
In-Reply-To: <20200525104849.GQ11869@pengutronix.de>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 74505663-78c0-4b37-c58a-08d800c1b63f
x-ms-traffictypediagnostic: AM6PR0402MB3382:
x-microsoft-antispam-prvs: <AM6PR0402MB33827C2CDCEDB38512071398FFB30@AM6PR0402MB3382.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:580;
x-forefront-prvs: 0414DF926F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: duVSajBfPb/xcZME573queoX2vMZnRerrT2REg0UmaBfXVmZ7lxcIUHZekLNmSkChofgtoh0zbpJUBjcj5laXsDO+wJR0OpykgoJVEE2Tw54mzpwYdtxXWXXrcQJqOdkaU61ypBea2WueUz78Hp/IuK5yDrM/tqqFyJUwf/2yRX9CwxShIE3JU6bEmk/Ly2cAksf5yYx5kb1/hXDzU2uGDj9Ruq7U0Tn5mbOORHsMPv5UC+69bBCqptIpFV/Vz1Y3yOAIEUPd2WSxRGJsEC5PW4zHny+5YvnLgVu0lavgkfiOHmvjzDOsXVH2i95nsLXPT8irED5yYbdvCRFyTEj4ugXO/h4dwK0eJDeCR77WQH78FepPWrtOPohPojmAWQanipZ4+8sMJjEDx44n8mkqQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(366004)(346002)(39860400002)(396003)(5660300002)(316002)(83080400001)(8676002)(186003)(6506007)(45080400002)(966005)(26005)(478600001)(66556008)(66946007)(6916009)(76116006)(54906003)(66446008)(64756008)(66476007)(52536014)(71200400001)(8936002)(7696005)(86362001)(33656002)(4326008)(2906002)(55016002)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: bl7+Eq6YbLKv9eBAOnvxjs9VofLkhniorQMgR00Z2Em9bJzZoJZ40HnOjDW5/hbLRWJjjhMb1IZu/6SLTcDX19mgglLoMpZoVQpjO/greoykPgn2HRo0CivW7pviAWoNkceJMLnDDIQAwIW29RsM6d5Dxkyw985a6oO8hqKOZ3Z8IRoTF9a5OJC+bSEI8H0Tu3stXg7bv6hUSYvy7ZGCwC7ztIBp1m9HBWCgwBiHvzZNhnj3yGahIYnH+OcD0cCQM/XvCD/eRQAScppFDeu0b7MK2oZ3sPascBEtW0QtLub02sSiQ9YEy0gY+Lzk/adcVE50QzuCEETpjwsBbC5pseEWHe27bmhSKcnFw3eyAdrBexi0scIgCdMmsgMwZSmS+qBrd41E6Gj/pJnaXOGrP1v7Y7B6yDmh1qmOH3i6xCiERFuBOR6M5giz6uW66N8fv6mN0JcJNzhYW8I/twUMwMKxTWs7mbSu1PQDBGhUyweugjYahbWK7RBonSohnhAR
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74505663-78c0-4b37-c58a-08d800c1b63f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2020 15:38:45.8306
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ic4HpcJ5idJLjUNeQUq75RbWLdTWil8sKEgO8V/SAdJgiEM+PCVBR3W0YioVlyrMDafU99maORKx3nqVpfdgKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3382
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de> Sent: Monday, May 25, 2020 6:49=
 PM
> On Mon, May 25, 2020 at 03:09:26PM +0800, fugang.duan@nxp.com wrote:
> > From: Fugang Duan <fugang.duan@nxp.com>
> >
> > The commit da722186f654 (net: fec: set GPR bit on suspend by DT
> > configuration) set the GPR reigster offset and bit in driver for wake
> > on lan feature.
> >
> > But it introduces two issues here:
> > - one SOC has two instances, they have different bit
> > - different SOCs may have different offset and bit
> >
> > So to support wake-on-lan feature on other i.MX platforms, it should
> > configure the GPR reigster offset and bit from DT.
> >
> > So the patch is to improve the commit da722186f654 (net: fec: set GPR
> > bit on suspend by DT configuration) to support multiple ethernet
> > instances on i.MX series.
> >
> > v2:
> >  * switch back to store the quirks bitmask in driver_data
> >
> > Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
> > ---
> >  drivers/net/ethernet/freescale/fec_main.c | 103
> > ++++++++++--------------------
> >  1 file changed, 34 insertions(+), 69 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/freescale/fec_main.c
> > b/drivers/net/ethernet/freescale/fec_main.c
> > index 2e20914..4f55d30 100644
> > --- a/drivers/net/ethernet/freescale/fec_main.c
> > +++ b/drivers/net/ethernet/freescale/fec_main.c
> > @@ -86,56 +86,6 @@ static void fec_enet_itr_coal_init(struct net_device
> *ndev);
> >  #define FEC_ENET_OPD_V       0xFFF0
> >  #define FEC_MDIO_PM_TIMEOUT  100 /* ms */
> >
> > -struct fec_devinfo {
> > -     u32 quirks;
> > -     u8 stop_gpr_reg;
> > -     u8 stop_gpr_bit;
> > -};
>=20
> Honestly I like the approach of having a struct fec_devinfo for abstracti=
ng
> differences between different hardware variants. It gives you more freedo=
m
> to describe the differences. Converting this back to a single bitfield is=
 a step
> backward, even when currently struct fec_devinfo only contains a single
> value.
>=20
> Sascha
>=20
Sascha, thanks for your review.
v1 patch is doing like this by using a struct fec_devinfo for abstracting d=
ifferences.
In fact, I also like v1 method.

I will send the v3 version by using v1 patch.

> --
> Pengutronix e.K.                           |
> |
> Steuerwalder Str. 21                       |
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttp%3A%2F%2Fwww.p
> engutronix.de%2F&amp;data=3D02%7C01%7Cfugang.duan%40nxp.com%7C2ae
> 2657af251492ced5608d80099384e%7C686ea1d3bc2b4c6fa92cd99c5c30163
> 5%7C0%7C0%7C637260005356084997&amp;sdata=3DsarhmRepUf1o4hCZ8WH
> oSBrg%2Fl128jz%2BNXxHRGAM%2FL0%3D&amp;reserved=3D0  |
> 31137 Hildesheim, Germany                  | Phone:
> +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:
> +49-5121-206917-5555 |
