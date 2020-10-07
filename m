Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62E23285D5F
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 12:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbgJGKvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 06:51:33 -0400
Received: from mail-db8eur05on2046.outbound.protection.outlook.com ([40.107.20.46]:42935
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726388AbgJGKvd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 06:51:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dHLS2kLauQmx+NaIVfgNk3PaTYBkP44bIILQJ0rSWgVXrzsT0icczJVXUFZNOVgy1Pguhxc5q7OK9i+6RSEpP/5unXAKNiVDNYl/3pQESEHovScThCZektTv1Dj9/0MQA8cByIkD84KulGPL4ghKwmbXUjC5nFa5RPi8RNzRGsd1rZwqtwIZTiMwtIZ0N9PaUDG8FIsneb2K0EHpLCBCxN5e5gMiAVQaJWDdu6CfEVdB7oSbMNEex6Oxr/Hmfk6ogg9HIJWaLGPayhjApAAEjdBomi4xIN/j3m07a/Deb6x1xaLrTGGCUkQddX7Y9jj8u0cVknXAEqyXfsVMzATEKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9VYhWBBOgh+JKQro+z3cfzWnn8USNXmwmjZP9zAHX54=;
 b=j9aWaOuNsUDCONyGoKSrDHwXoQie4V7fpv2mhkcrojHqJxpqhyjRjRbHeEdMaM22/sWrfv0pzDm5xgv7fRtoPDEUy6ANc0u+KDQ0D+vhL1HrtHk9RLOdw5X2miMnd3K9BP+AMDSnBnpTh4FDovmf0ZBVeCiW3BqyvIfZuOo9K8/tOjzRnUyrTOSRPNqeGtN3ylV3m5bXGRhPS1/vvN+RnFhTq61cy0N0XLgegi6mwX3ZQ2BPMuQAs+Lq2A/A/nyA6togRRRzrT9IaQClQFgELpwPfeQHCeAVN51crlpPRE7msVcEqxtCgYYLB75XpDQtbn673QMrRf6o6MYI6GlEzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9VYhWBBOgh+JKQro+z3cfzWnn8USNXmwmjZP9zAHX54=;
 b=A2inaN+hzvHP8dZhuQ9E0n02kmQItHw1QCNkASesCd9PGgMSanEqD2TXEzPyK63/26kWXYHuQCch0laffyjyEJkT5MWlj45g0OmcNbUMdwAdYJo1LpcO8+YFk/bIBteg125AsUvSiXYBqJ4Cu62J/V0VVvs1srmeQvSTyqVxWQQ=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR04MB5406.eurprd04.prod.outlook.com
 (2603:10a6:803:ce::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.37; Wed, 7 Oct
 2020 10:51:29 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::3c18:4bf1:4da0:a3bf]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::3c18:4bf1:4da0:a3bf%3]) with mapi id 15.20.3433.044; Wed, 7 Oct 2020
 10:51:29 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Rob Herring <robh@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v2 01/10] dt-bindings: net: add the dpaa2-mac DTS
 definition
Thread-Topic: [PATCH net-next v2 01/10] dt-bindings: net: add the dpaa2-mac
 DTS definition
Thread-Index: AQHWmQA0dlPJuozT/U+6h7CC9yndwamLFFmAgADpRAA=
Date:   Wed, 7 Oct 2020 10:51:29 +0000
Message-ID: <20201007105128.nvzlrsg5fgtjka5p@skbuf>
References: <20201002210737.27645-1-ioana.ciornei@nxp.com>
 <20201002210737.27645-2-ioana.ciornei@nxp.com>
 <20201006205635.GA2810492@bogus>
In-Reply-To: <20201006205635.GA2810492@bogus>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.229.171]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ce856e13-e0bb-40e2-ecbf-08d86aaef24a
x-ms-traffictypediagnostic: VI1PR04MB5406:
x-microsoft-antispam-prvs: <VI1PR04MB540687AD60AC3D1CCE01E4F0E00A0@VI1PR04MB5406.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: igdf2v7EWxvEIKYCX81jv58BE1YMf4d2Wag9JowmGuUDibnmabv6dTBQ3tIygvijNFdzj996vmGZvpDAOERAS9H/29/wVGZ7sWVDzx9hM893NWh/LnVbRAajYQK1OGklRSf7yzYaJbI/fgx8oRBpIIYrsjjZwBFgayHM/r3ZX1Y3z4/JXUTdJO7Yb34S2Oa9LDM6nEUi/UvIjKcOm7iTd8EqFmTcGMfHAj+thjcOLCd8IlhvR10fdhY7mkriYEyVOnF4ZW4HbO42ATFpxLryCNUEoUgcIRJ/nTtXuEs/XRWTVXolX6GR7PWQdh9ljt+/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(346002)(366004)(376002)(39860400002)(396003)(136003)(33716001)(8676002)(9686003)(54906003)(316002)(6512007)(2906002)(8936002)(76116006)(66476007)(66446008)(478600001)(44832011)(64756008)(66556008)(66946007)(91956017)(186003)(86362001)(1076003)(5660300002)(6916009)(71200400001)(4326008)(6506007)(6486002)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 0ItFmoYhISw8gjHrjo5xwxdaJoy2U39VPc54qvJ9kKJWgeKASjnrPKYpmdGd+gbElfVTHdNlrpRN1g6pFspZebIUNyRFTkxSl273gXa39gRGdG7HhMimZbw3q4jic3WNQZJyfN8tuctgdMiVggQWKxWgQnGFjcavh91spZTA1XlI4r/84h1xLt/eaJbKx3SPwidtNkqEXIm0DxpU+gNDbMIRf4JzBoBdJnWhJ1OBDydz4NxvzpoLTeRJStt7PqLZ+6nmTitplYhcrEKiBU++ViT9Zy/W0Xp+AnpK2VXr7XGdX0C6bmofm2M4U9zjr+n0PeFkmXbyPJFjsZ8bNHxbvdscp45J0IkOGweQk/wK++jGx9c+4kDJTAMbPy9CE5XubBcmTmgRv18HGUcwABjghliJXdE9VBO33gcK1e/h+wk6L/pNJ8fzm8gEOQW7WhwxiQi2xFwa0j8SdN2iUbWl8iF86tRwgFCwVV9yc5xaiEUdSX7oUXxHm2WfyljKAUBImxDRTQ7h3p9UDyMRzpIeygqN9jh1fiWKCUwzARQoWTfBpaRLRgDiR/KrhkNfPJB2ajEfb2fHV7EgSG0GW0mysAF1QiQejp+JKO1eFDiTsVCC0GB0GFpOxPVmuXYmFQ4FPJlgYD7zLykWtY469+Syig==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3876F1BDA871684FB3480115C5994897@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce856e13-e0bb-40e2-ecbf-08d86aaef24a
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2020 10:51:29.3196
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b32jxziFVE4GBh52MUbCbf63UekN2OPoSw+e2KPTW5rYCz7SWuxYQh04EXGDxPrdwDyJ8Ex8g+KbKiYRJY0hJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5406
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 06, 2020 at 03:56:35PM -0500, Rob Herring wrote:
> On Sat, Oct 03, 2020 at 12:07:28AM +0300, Ioana Ciornei wrote:
> > Add a documentation entry for the DTS bindings needed and supported by
> > the dpaa2-mac driver.
> >=20
> > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > ---
> > Changes in v2:
> >  - new patch
> >=20
> >  .../devicetree/bindings/net/dpaa2-mac.yaml    | 55 +++++++++++++++++++
>=20
> Use the compatible string for the filename.

Sure.

> > +title: DPAA2 MAC bindings
> > +
> > +maintainers:
> > +  - Ioana Ciornei <ioana.ciornei@nxp.com>
> > +
> > +description:
> > +  This binding represents the DPAA2 MAC objects found on the fsl-mc bu=
s and
> > +  located under the 'dpmacs' node for the fsl-mc bus DTS node.
>=20
> Need $ref to ethernet-controller.yaml
>=20
> > +
> > +properties:
> > +  compatible:
> > +    const: "fsl,qoriq-mc-dpmac"
>=20
> Don't need quotes.

Got it.

>=20
> > +
> > +  reg:
> > +    maxItems: 1
> > +    description: The DPMAC number
> > +
> > +  phy-handle: true
> > +
> > +  phy-connection-type: true
> > +
> > +  phy-mode: true
> > +
> > +  pcs-handle:
> > +    $ref: /schemas/types.yaml#definitions/phandle
> > +    description:
> > +      A reference to a node representing a PCS PHY device found on
> > +      the internal MDIO bus.
>=20
> Perhaps use the 'phys' binding? (Too many PHYs with ethernet...)
>=20
> This would be the on-chip XAUI/SerDes phy? That's typically 'phys' where=
=20
> as 'phy-handle' is ethernet PHY.=20
>=20

The PCS deals with proper coding (8b/10b, 64b/66b) and auto-negotiation
between the MAC and whatever is connected to it. It is, logically
speaking, above the SERDES which implements the physical layer
(PMA/PMD). We are not describing or configuring electrical parameters of
SERDES lanes and such here, we are just referencing the PCS found on the
internal MDIO bus of the MAC.

> > +
> > +  managed: true
> > +
> > +required:
> > +  - reg
>=20
> addtionalProperties: false

Ok, I'll add it.
I didn't find a reference to it in the writing-schema.rst. I think that
would have helped.

>=20
> > +
> > +examples:
> > +  - |
> > +    dpmacs {
> > +      #address-cells =3D <1>;
> > +      #size-cells =3D <0>;
> > +
> > +      dpmac@4 {
>=20
> ethernet@4

Ok.

>=20
> > +        compatible =3D "fsl,qoriq-mc-dpmac";
> > +        reg =3D <0x4>;
> > +        phy-handle =3D <&mdio1_phy6>;
> > +        phy-connection-type =3D "qsgmii";
> > +        managed =3D "in-band-status";
> > +        pcs-handle =3D <&pcs3_1>;
> > +      };
> > +    };
> > --=20
> > 2.28.0
> > =
