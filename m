Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B184426F8CB
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 10:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgIRI7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 04:59:46 -0400
Received: from mail-eopbgr00064.outbound.protection.outlook.com ([40.107.0.64]:2726
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726109AbgIRI7q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 04:59:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gL1zIP1ayETdsV8evPGx7/Rzxw4E4VHzD1fw3suYiCMythikUg7oo/7moO6Je9Txq2ROk4HoxYlUWmdhXkhiOSh9bpeVm9lrqzVhTI1B/CDBG0aKbZ6x+EqhdAKDZPH914Cnqa1QjEErIHU1VJEc75y2LUzkjFCo5lkq3xIkEzbtc3y1SMNzb9mVjZUHYZqOGvEZzEcKo44OwsFspOwScUyI5WaJrIJx8z8OTfKjgFV4rCIOj1eq9Da2R/e1A0gT7zEBVrppZvw+N51WhuAR/J5NMl3Z1XBihuW3JRYAlfTinGEOIN578q4aUJiqVlOh66TRXH5TuHA9L84vtzk+tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=04eRJoeBTluUt8XQHVaHeBL6YRAwUFaCBczku+lA+L8=;
 b=boZoq+Xg5ns1/jH5Q0HjDcQWZ+tIZ+Dk/DzU+iLQ+Pwvu5m1U7ANHceqwfixRs4YouUUf+PrdmNUx08G6jnYV+ooXqzYfBmEq4y4xDEEnX9YoBbKWw+P9jEBuIbUNFSNsrgYwG3yDoaYa34REJ0dCtMet4Kvz0Cgnd9AQH4Cop/zytA6l4dS6FMvds0HT2OHn1X35ip2JJrs1vEyCmNsl5nuG1XA/OWIx7lWuDfTfDtJuJU7xMQcNsksgRLjouNOUURI2kE88oJTCdXnqxl5Nr1DnTNvd/bWo7amBzjCJuFodF3GmVsHTCf/exmFQXcrHxYanvYnkuOtZJnORpJ5ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=04eRJoeBTluUt8XQHVaHeBL6YRAwUFaCBczku+lA+L8=;
 b=KjSBXimcpCTs+l9TKHBIKbMcaBbx35PBim8zn2PzDQLeXyTE3eDUJMz7yJ56983pZE4MRVkdjp9UTA8TdJlXs71X13BWg6Gl8AawwWXhFGmVAvdYfUFbFqsYstsefC4gVqyvLKX4abCKvAFbwveLhR8367P1P6afNjI5310e/FU=
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com (2603:10a6:20b:10d::24)
 by AM5PR0402MB2932.eurprd04.prod.outlook.com (2603:10a6:203:9c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.19; Fri, 18 Sep
 2020 08:59:42 +0000
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::f431:1df6:f18b:ad99]) by AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::f431:1df6:f18b:ad99%7]) with mapi id 15.20.3391.019; Fri, 18 Sep 2020
 08:59:42 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: RE: [v3, 6/6] dpaa2-eth: fix a build warning in dpmac.c
Thread-Topic: [v3, 6/6] dpaa2-eth: fix a build warning in dpmac.c
Thread-Index: AQHWjCNDZZSvtMFBFkqXjoflE6bd/alrVEiAgALHKEA=
Date:   Fri, 18 Sep 2020 08:59:42 +0000
Message-ID: <AM7PR04MB6885F0D0172B0F2E8D4E375BF83F0@AM7PR04MB6885.eurprd04.prod.outlook.com>
References: <20200916120830.11456-1-yangbo.lu@nxp.com>
 <20200916120830.11456-7-yangbo.lu@nxp.com>
 <VI1PR0402MB3871D33D658BF35116426E9EE0210@VI1PR0402MB3871.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB3871D33D658BF35116426E9EE0210@VI1PR0402MB3871.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 795388a6-6825-4054-963e-08d85bb12ebb
x-ms-traffictypediagnostic: AM5PR0402MB2932:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM5PR0402MB2932C45F563426A74E0D485BF83F0@AM5PR0402MB2932.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:626;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BMhy1zWLFdWykdFdng7jTlV8TbE1Ap/9WCvfLaUcabc7b/iBC4mQmGfYg3or2DaakdkSbCkMvSGBIGLyGsdOw3OM0uG1ZHPbYjY4NTyz+pdmPCvG0w4APg6qxugMudK976nB867ATNLfggPr28ZXWUoU/IBm05cLazqKXjhgXx1X3l1yeEEgeQIED68Q8g50eQPOvnqsTPSxAKq7Vib+vnkRTUiGoRA8o1MaREv+CYu42jLJtcpxBI7og0Mrf5RBgbyvYo3eLp/0u08738ANRqHUOfe7kRfzJ7E26kytRERHnUPnqeKzStuzP11pi4VICsrg9GbGAH6gKJUctXS7ZA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB6885.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(366004)(39860400002)(376002)(52536014)(5660300002)(110136005)(54906003)(55016002)(6506007)(7696005)(478600001)(26005)(186003)(53546011)(9686003)(4326008)(33656002)(83380400001)(2906002)(8676002)(71200400001)(66556008)(66476007)(76116006)(66946007)(66446008)(8936002)(64756008)(316002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: P4O7hwelONpGnLt0znL8v4YlL92QLSHN7LGUEjthII8v3Jea8i1JKRAYyknb1ILhfjR6eo6kieNdQJeYSgT4HalyVT52i23mAh7lc7BB2slV8C+0cgFS3RqZjQg4gDNeT+33k5284mxoUCQrrGZdrnmjhMb3GBXCxT3Or3bQxWIqp55awU7vlghJj/O3cM22hxygQQuMl9FnuRq72jI3WnecblIWTZ4mio9NmmyBpyD/Opa5kNpnfgEBirMQ1xMMUPgGatyhRcrSVgObWPUbTPUza4hnO4dMp++YLmFe54xOpriizfKRqjA7EmNtlJRCBo6/duyBcEHQlfcuI6p4MGqrP0yGyvFuf5OGxAXZc21BJ7zuMz+EDqM/SlyRmZWPpeCgCUl0e1nx7a+AgdRAk4l6VsxTKCGs+NGj/GdA1b9J3zJEaCDFx1ThZHlWdryEDtwgesZ/WHOTMyHjJfQI3ID7dRsk8wlpBKYRPHd7CeZ21Oo/R/YYvrz83of5ynVzD8giali3FFTITMMOcgPeymn4C3E3jfJHajHZwnSKj+kIF7WY8oU3tfYoEcvPvhzxl/8Ka6iU743NRUGHWh1YXWTxcuKKd091ChGHSA7Hn61vb0A874ALWfo8YDs0b6o1SGzNZUC6naPSf100EPA9zw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM7PR04MB6885.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 795388a6-6825-4054-963e-08d85bb12ebb
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2020 08:59:42.3344
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WlqL1msVKJtfAartVkb54h6Lebinvqc7eCLnBFArvJ9g//LtUKwtNMSgR2pdNpdblgtT+2Gn8Odr1RqI9u3Ukw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0402MB2932
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ioana,

> -----Original Message-----
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> Sent: Wednesday, September 16, 2020 10:33 PM
> To: Y.b. Lu <yangbo.lu@nxp.com>; netdev@vger.kernel.org
> Cc: Y.b. Lu <yangbo.lu@nxp.com>; David S . Miller <davem@davemloft.net>;
> Jakub Kicinski <kuba@kernel.org>; Ioana Ciocoi Radulescu
> <ruxandra.radulescu@nxp.com>; Richard Cochran
> <richardcochran@gmail.com>
> Subject: RE: [v3, 6/6] dpaa2-eth: fix a build warning in dpmac.c
>=20
>=20
> > Subject: [v3, 6/6] dpaa2-eth: fix a build warning in dpmac.c
> >
> > Fix below sparse warning in dpmac.c.
> > warning: cast to restricted __le64
> >
> > Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> > ---
> > Changes for v3:
> > 	- Added this patch.
> > ---
> >  drivers/net/ethernet/freescale/dpaa2/dpmac.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/freescale/dpaa2/dpmac.c
> > b/drivers/net/ethernet/freescale/dpaa2/dpmac.c
> > index d5997b6..71f165c 100644
> > --- a/drivers/net/ethernet/freescale/dpaa2/dpmac.c
> > +++ b/drivers/net/ethernet/freescale/dpaa2/dpmac.c
> > @@ -177,7 +177,7 @@ int dpmac_get_counter(struct fsl_mc_io *mc_io,
> u32
> > cmd_flags, u16 token,
> >  		return err;
> >
> >  	dpmac_rsp =3D (struct dpmac_rsp_get_counter *)cmd.params;
> > -	*value =3D le64_to_cpu(dpmac_rsp->counter);
> > +	*value =3D dpmac_rsp->counter;
> >
>=20
> Hi Yangbo,
>=20
> The proper fix for this is to define as __le64 the counter in the
> dpmac_rsp_get_counter structure as below:
>=20
> --- a/drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h
> @@ -67,7 +67,7 @@ struct dpmac_cmd_get_counter {
>=20
>  struct dpmac_rsp_get_counter {
>         u64 pad;
> -       u64 counter;
> +       __le64 counter;
>  };
>=20
> Also, if you feel like this is not really part of the series I can take i=
t and send the
> patch separately.

Thank you. Let me send the fix for v2 separately.

>=20
> Thanks,
> Ioana
>=20
> >  	return 0;
> >  }
> > --
> > 2.7.4

