Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50ABF281706
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 17:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388020AbgJBPqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 11:46:35 -0400
Received: from mail-eopbgr10045.outbound.protection.outlook.com ([40.107.1.45]:7491
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388023AbgJBPqa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 11:46:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GMS9/BUuvRtz75qrUhNQEB3d2dr52GYUzZn6hfooQWJh1usB4XwxSVROZUo+wONRNiXp6Ux3nNktiThN2ZoJJnQXIlcltfHAF+oe6fHJ2LQsBbMzXbrVZpeQscqDYCw5lmkOMUdu+cfsW2LDg6KrCQGx6d6cj0qw8e7jMP11XrZbDAJmbnw3g2ug/WLLdGjkXrXmO62vAbsAMJyCIiJLzXLjmgGTHa+eDCdCPBwAs1j591bWe37qGsyj0z+FW7hQENLw1d16On2nBQeKENU33pKlklhUyYk0+PLs2kzxhQwkZMZPiXoJUSqB9U+h3f+bP4dLegpN3DFWf3U1nws5ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3eCydG607GpIzL1PWwv+O72kJNeiLMp2Wap2eGgY87w=;
 b=C5aRCIT5qZf+Cx+GyqiCi1k4OeAjbEV5F0/r15Jjn8qbX8AvKAsAMr3nTSB6A1+z5gKPR2NwZlSDPJ5BCE8WDMbzkZdXUiVEfII9UDPrWBeV37BFb6l74zF8PMvjW+L0NRId5vdhyRFEirMUWjgh9derUVzUZ1HX7qhWsMyJTzGB21vXNDeaOlFmlWf84851aZUDGtW+S78VZliBjBiqQdOXuiBg5wj5NekLN8KwpISHvqDl5eoGVhJWT3FxMLx6w5oA+EyJ5wOZEZdfYQSetqtS3Ehb1D5hi02Fb8NXq1zd0KUzfmwepE31grklcT9uIBFgESWmvojy8QaK9vEucA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3eCydG607GpIzL1PWwv+O72kJNeiLMp2Wap2eGgY87w=;
 b=ElpeKy6G1OE4DPctMsEFIHy+1HHPwzWqjQWd80HYRj5AUjlAdr55b1SwA0WHD6hMFH/kQReDKdmPVm57lMWqMmYAm2LFdizpLkSBFD850wHdKEgtsCPgBVKa42xu6Za/2/w6XWGWwog1nyjlZQUwAmCaCqhXIdjmYPj21Vks7s0=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0402MB2942.eurprd04.prod.outlook.com
 (2603:10a6:800:b5::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.38; Fri, 2 Oct
 2020 15:46:26 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::3c18:4bf1:4da0:a3bf]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::3c18:4bf1:4da0:a3bf%3]) with mapi id 15.20.3412.032; Fri, 2 Oct 2020
 15:46:26 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [RESEND net-next 1/9] arm64: dts: ls1088a: add external MDIO
 device nodes
Thread-Topic: [RESEND net-next 1/9] arm64: dts: ls1088a: add external MDIO
 device nodes
Thread-Index: AQHWmMtFhI7cQlHN6kCYyKurRknaVamEcUyAgAADegA=
Date:   Fri, 2 Oct 2020 15:46:26 +0000
Message-ID: <20201002154624.yekn2daly5fm2lol@skbuf>
References: <20201002144847.13793-1-ioana.ciornei@nxp.com>
 <20201002144847.13793-2-ioana.ciornei@nxp.com>
 <f5c9c03b-8839-4923-b9f8-7ab9a9554d43@gmail.com>
In-Reply-To: <f5c9c03b-8839-4923-b9f8-7ab9a9554d43@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.229.171]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 15632629-40e5-4ceb-59e0-08d866ea5258
x-ms-traffictypediagnostic: VI1PR0402MB2942:
x-microsoft-antispam-prvs: <VI1PR0402MB2942AAC7FA6796D2F739542AE0310@VI1PR0402MB2942.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S1Vvr7uOtMOmLS3CyqO+URoyWFDxvbUbTqM+WueyKdob3B07ClDYE48F/FHmpk5a/LyDYa5G5v30mMuKH/WcBNyhoZBlcxLNhWYKObOiy+ENh5dLm5+CKea0IzWkgrkZ26yWRJobI9oX2cJrsFnJ52W85UTtdD1HgL1CDkT3HceLDBsCNhek5Lj44xJdU2uwPZmUXLsoSoMaegpZy0j2a68VzEJJoLZ7mUo9IkljnPvg5XghBCMlMYg6CNP8eMaim1le/zy59EUenSH0C9q5EqQiDLwy6d9IXICsmiib5hR5BT24A4FZZlGXXs+CVrX4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(39860400002)(366004)(376002)(396003)(136003)(346002)(4744005)(8676002)(6506007)(2906002)(53546011)(44832011)(4326008)(6486002)(71200400001)(5660300002)(316002)(8936002)(54906003)(86362001)(1076003)(33716001)(9686003)(26005)(91956017)(186003)(66476007)(66556008)(6512007)(64756008)(66946007)(76116006)(478600001)(6916009)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: E1q9XtHT3oFG1YdDPwXpfruT9QxsA1dpd890zhM2QHZYg2oMT/qGoZRlwNwf1Qv6kNg6uJwQ9skig/lUfolx2Mv6+2NqLATjZb6CDlnHEIj8JQ5En5Mazk9AHZjy0WNst+pyHeHzndSKbhe9akgYcbkeWP3b8ISxFRAt/e4stvtBW0KksqaNGrbGljjOC+6F3CaGeA9Q9Fu4ZGXeUSKPj/TXGEcZdq7R8vRM2KOmOBP9Eh3fVsOXNLhH+trs0jTWEntH+/R7M1ZmxNrwMoHMaceDcO9HJPyUkysbzW6pzgI4hcPg1E4rrYdoIpH/sqzsuFn0YZjoQYAL5f7EygkmWJmV5QW81+zxfGpL/CZ4eD7IIKBi4+qdhJzpzvKoyWyvbaj9hm3FsJpK8mGgFc0FWo+CDbpPXCMpyHgVdjaG+Xsk+0xkPzi6YeJvN7Jcui+mS2IoNjPv5ALkFA89RLHPWnH/kulmFfnVpgyYNn3s82J+fZCDFPc2q6JTOqXOjuN5jbHIQaekxCmvSYNInKNB441KAfU61+ZPQeHMmc4Z7M7WL9Qq2MifXwuGXclzlEdLPue/H810dBg60s/mjsyAbkuAfqWS+XWoudFbNrvb8UBQ3JLYoLyJ2Nes2oE6/IuhFWwsAoF5bRDEm0x68Md9Hg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2C7D036A2988EE4787261BF3CDA028F4@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15632629-40e5-4ceb-59e0-08d866ea5258
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2020 15:46:26.1728
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5euUDsbK7j2jVEjTZiO2D72EEpOcHSLM6GmBWChmahkMSycmrRYjqMhz/QAsUoE8u+rHiTNuq6L0PpBeA2t2mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2942
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 02, 2020 at 08:33:57AM -0700, Florian Fainelli wrote:
>=20
>=20
> On 10/2/2020 7:48 AM, Ioana Ciornei wrote:
> > Add the external MDIO device nodes found in the WRIOP global memory
> > region. This is needed for management of external PHYs.
> >=20
> > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > ---
> >   arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi | 18 +++++++++++++++++=
+
> >   1 file changed, 18 insertions(+)
> >=20
> > diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi b/arch/arm6=
4/boot/dts/freescale/fsl-ls1088a.dtsi
> > index 169f4742ae3b..22544e3b7737 100644
> > --- a/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
> > +++ b/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
> > @@ -654,6 +654,24 @@ ptp-timer@8b95000 {
> >   			fsl,extts-fifo;
> >   		};
> > +		emdio1: mdio@0x8B96000 {
>=20
> You should drop the 0x fro the unit address and likewise below.

Sure. Will do.

Ioana=
