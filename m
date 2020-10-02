Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF802281717
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 17:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387978AbgJBPsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 11:48:51 -0400
Received: from mail-eopbgr10065.outbound.protection.outlook.com ([40.107.1.65]:49365
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726090AbgJBPsu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 11:48:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oUqtgkHuf4CtsdsdUewwDbupPrahl2PW+8Y2+4JAS7+mWTfLP6LPjb5jFZADAUpeygaMcXhK6nAPSGbFJYGegPMvhWmHaXzVy2SHnfmAYQm2wUeSXjUKvsFjqOkhPm3NEDKQ90t1HycJJTXcaAi1M047j3Opze/03EVGdNbtj8Nf3JNjZQ0VnSo7D0KLyggOLv2pycJ0+/syVeDlYq5IyU1uw6DPKzofmMAM5xeEQSuuZNRZQDflN1UBP58DXL5H9Y/vgiXDrImEGJs5FsemGVMwwBIsdPEfrAngfSR6vUTcL73iZwhdV7BaOWU9R5wiZKuMvs/yOur8CVV9YmUltA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7QjjdrDe/lMQTIVoe++tOx+swkeowT5TBpNaC0hXTxk=;
 b=XkzTtDSIBpw2SzwJr/AnJW6LmGg+fLIkBewWsrHFfube0XjPgwzQAYrWrqtuEU+szi1AjXvG+d890xXI/kfojspXYCtWUV6hUXQ1q5ZER1xrRWudMOv2+ogk0ZIxcFQDPhTsF3DwaqPdogPaZfxN/vZ1wcWjGE7giyM4LXW+Xnyn0sT6KTuP+LzB9mSO1b3itgGvAhMpt7owB1Q+qb11Za9xsp4nXP9hrdHuY2OXyFePp7xXYLdpMsyz2dhrkbn4oiHcMNVoXEUqFjdPGFEnya3RFifRkK2OOIOfcPwln//m1kZtHctor+dByjNLC2wZ1Oy+6Hpf9ZL1Odmt3AGWdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7QjjdrDe/lMQTIVoe++tOx+swkeowT5TBpNaC0hXTxk=;
 b=irNbeust0iEinPyzUolth5vGqKGjmX124EIfadg6vaRUxK6wbvlzlCdLdDVr5+v1dCKQ4TA39M6OrL1bVBr9gQ2giWxRJlv+DLGvnULJ2eTFbw7b+7SsY5TwRrEnioRU2ybbbykWSjZFeB2ckp/13dAaiOk1fN3bbN6vTQz77tI=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0402MB2942.eurprd04.prod.outlook.com
 (2603:10a6:800:b5::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.38; Fri, 2 Oct
 2020 15:48:47 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::3c18:4bf1:4da0:a3bf]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::3c18:4bf1:4da0:a3bf%3]) with mapi id 15.20.3412.032; Fri, 2 Oct 2020
 15:48:47 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [RESEND net-next 2/9] arm64: dts: ls1088ardb: add QSGMII PHY
 nodes
Thread-Topic: [RESEND net-next 2/9] arm64: dts: ls1088ardb: add QSGMII PHY
 nodes
Thread-Index: AQHWmMtFXF6Z21i18kyPSUvp65o2QamEcimAgAADRgA=
Date:   Fri, 2 Oct 2020 15:48:47 +0000
Message-ID: <20201002154846.6rfkgrcl24hbal5c@skbuf>
References: <20201002144847.13793-1-ioana.ciornei@nxp.com>
 <20201002144847.13793-3-ioana.ciornei@nxp.com>
 <02d2d46c-8a88-2d44-f8b7-ed73cae93eda@gmail.com>
In-Reply-To: <02d2d46c-8a88-2d44-f8b7-ed73cae93eda@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.229.171]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7c01385e-37d2-4d52-66b9-08d866eaa67f
x-ms-traffictypediagnostic: VI1PR0402MB2942:
x-microsoft-antispam-prvs: <VI1PR0402MB29423910E60D836756D450DDE0310@VI1PR0402MB2942.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6JYgnI5FlQy8Y8ArdHNb06RahHGh+FIf+kJ3t2i0vZq7a5XgvihdRtWi0LfTstxpVsmsqTr4vKXx/5F/lx8YtfD5g9IPEU64QRsYXDpN6ZWpM3JUWbxewnDoIKkbvlMQdku0sWmbrqgFYTvEz0HP4Skif+Oz0WhPf0pP0bw8PDM7VCTHC4hbJDuxYX6t0tSL4/oyfONkP0IAnAwRDzlzdeJwFZ/Po9g8dAzJyvUSC1az8vCU2J2fN4Hq6nsjjvewEcAJ+xtUD54FhfKYsALCM3VegBAyN2N+ZmC+Hj9IrExknF/Z/1zWSJUcOXdFLzL73zropqOp7UPF8eXmUSzOcg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(39860400002)(366004)(376002)(396003)(136003)(346002)(8676002)(6506007)(2906002)(53546011)(83380400001)(44832011)(4326008)(6486002)(71200400001)(5660300002)(316002)(8936002)(54906003)(86362001)(1076003)(33716001)(9686003)(26005)(91956017)(186003)(66476007)(66556008)(6512007)(64756008)(66946007)(76116006)(478600001)(6916009)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Wp/0ICJTXI8ucNNnvOeWEqFzR3Z5VrEOEDWmSWJtflZ6wgbyDVeR396Qr6S5ywRwRU2LdEyoyMWfLdNLpSKxmccfPd15Nna0fJsVdtxWPnRi5djlYPrECFreVIkn5g6uP19w3B6XSUw3Mk64w+Wc69nxgKSmZWO4SOIctPloxBjSR+Xdk50BliNUi7pStDo8zHmQBerMEmajlUDpwMXhlmMMC4ZaqrQYS98V2JoC9nKpMA5t22iMQN12RNnsMU48MRideqOEk/e3EwVh/4/yZfnDceatusC9hQHbpirWsYx0H4D2k/hd0dZoaOxHHyAGi3scqXC3TZ3qSS+GAZsCWCo6WkJH/cdTltKhwH2LNP5hqr2RnTEalwp9lXlONQcseN4ifALVHxWBse70hBucdz4lX5Tx9bNiCCjIcTKKvph09FW5YTrU5cVliIJvth/8Mk9FRGFPmmlGaCfpb6zDPCkbSosUw3pZRhMH/pUnJBurxFEhp0+VdvKTGXP507BkQh4kZAE+o1t13OCswaej8KxD8hM2xy2o+o2U9kLv7XLVh0eNxE6y5YrRXzZnpZ3amGbMhTh9SKcyHpNQuoL0F2f+GNuWoY3mq9x5wmU3azcapM8wfgSpFpiQrWLnZmHXetSdPXEF/J9BAlBLm7Uagw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <38D619128FEB1C4FB6F5FD22D6FD9F9B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c01385e-37d2-4d52-66b9-08d866eaa67f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2020 15:48:47.3033
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lT+8CQg69U9riXWEb2SWBFT8/8wxjesRPv5Fyo7g4w2hHmBDuo5eoTwmo4eoAj81TE2hoHiSKXued8f7BlAfOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2942
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 02, 2020 at 08:37:03AM -0700, Florian Fainelli wrote:
>=20
>=20
> On 10/2/2020 7:48 AM, Ioana Ciornei wrote:
> > Annotate the external MDIO1 node and describe the 8 QSGMII PHYs found o=
n
> > the LS1088ARDB board and add phy-handles for DPMACs 3-10 to its
> > associated PHY.  Also, add the internal PCS MDIO nodes for the internal
> > MDIO buses found on the LS1088A SoC along with their internal PCS PHY
> > and link the corresponding DPMAC to the PCS through the pcs-handle.
> >=20
> > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > ---
> >   .../boot/dts/freescale/fsl-ls1088a-rdb.dts    | 100 +++++++++++++++++=
+
> >   .../arm64/boot/dts/freescale/fsl-ls1088a.dtsi |  50 +++++++++
> >   2 files changed, 150 insertions(+)
> >=20
> > diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1088a-rdb.dts b/arch/a=
rm64/boot/dts/freescale/fsl-ls1088a-rdb.dts
> > index 5633e59febc3..d7886b084f7f 100644
> > --- a/arch/arm64/boot/dts/freescale/fsl-ls1088a-rdb.dts
> > +++ b/arch/arm64/boot/dts/freescale/fsl-ls1088a-rdb.dts
> > @@ -17,6 +17,98 @@ / {
> >   	compatible =3D "fsl,ls1088a-rdb", "fsl,ls1088a";
> >   };
> > +&dpmac3 {
> > +	phy-handle =3D <&mdio1_phy5>;
> > +	phy-connection-type =3D "qsgmii";
> > +	managed =3D "in-band-status";
> > +	pcs-handle =3D <&pcs3_0>;
>=20
> from net-next/master
>=20
>  git grep 'pcs-handle' Documentation/devicetree/bindings/*
> zsh: exit 1     git grep 'pcs-handle' Documentation/devicetree/bindings/*
>=20
> Is there a binding that we are missing?

I missed adding the new binding description for pcs-handle.
I'll update it in v2.

Thanks,
Ioana=
