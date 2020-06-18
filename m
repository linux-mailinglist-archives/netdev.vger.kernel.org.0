Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E891FFE60
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 00:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728232AbgFRW4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 18:56:32 -0400
Received: from mail-eopbgr70071.outbound.protection.outlook.com ([40.107.7.71]:49825
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727037AbgFRW4b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 18:56:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OgHF6Q5q7BWG9i0CMs3MMyesZA++Uip4nai4JwhFQ0p+/W8nQsrrozaqqZc1eP9V0FiwSXH1HvanuWUQMY49A9LlTglj+q9YNwwltWzHs3giHS59HSp1OBuYAIr3cVWLDhObieGdpt9v4r9paeGT6z106/qvUlVd4HRv3cjWW+oyUGRAs6xyCP4yCnLmou97ynW9ASZSBDso1aRNDpin2zUv33LfBR3rF5/k0B2630Wm3rB4z3cf5jRAn2u8SW6Y+Ee9F2YFBwWfrNCWyqEuRj0jWerxXBM23bZ+dF4dSgt9YiZTkzvO3QjigS1vJTbR39ysVM3hx9bU9UTNFHxXNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=it12cRppXefJ4bNlyIQ9cI9cWm7dvxFmqQXrd/w0e+w=;
 b=OVXTj7lyyJ59g6+9vbwSnAUyY0EEfJH7JKaQAkZB3cRMLSbuIzdLyFryturYACUAj8vdBL5MOVDqmYwKuCN1T1fJC5hl49Hj4HjcHEYGcyYLAckfXFKpx+uP8vHUYEhLoG+u6hSRgIJ0vDXbj8VnOdbu0C6KDPWsdvtB402PuynVnhl1mp48SDizL+iVX3Hn6+vEy1R5VnXSSGrQy1vkof/Ln/EqInUJMFEFpEtreE6CQLMwOluhBruSwKgIjaL2exxZ7Qppa5wYvjzzoTtLEdxPiLrFkUQPYbR5Ttx4b+sp8A5EocEgfo1V+bLzso5V/q75tP8iQSlUuIgBLmsKbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=it12cRppXefJ4bNlyIQ9cI9cWm7dvxFmqQXrd/w0e+w=;
 b=oHkyw9w/GVNHgcDB6jxIFNaK1tBdYxWfi4lQm/32CDGlff1/HNTqbexFvC2V/XthibDFq1iJTuPUW9U8YbTLacF1Q8t5or+YiUQ6BSZajRvo9+RmW56KPNDXkhdqK6CIq+nlFp6R5Nc+dtpBYGeOg6/WjI3td2iw6goJ4R4PhIM=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0402MB3744.eurprd04.prod.outlook.com
 (2603:10a6:803:16::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Thu, 18 Jun
 2020 22:56:26 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0%7]) with mapi id 15.20.3109.021; Thu, 18 Jun 2020
 22:56:26 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: RE: [PATCH net-next 4/5] net: phy: add Lynx PCS MDIO module
Thread-Topic: [PATCH net-next 4/5] net: phy: add Lynx PCS MDIO module
Thread-Index: AQHWRWlFJODo1hCReU2dgxtV9gIXrKjeaHmAgAAGAiCAACkmAIAAAPiQgABVL4CAAAv0cA==
Date:   Thu, 18 Jun 2020 22:56:26 +0000
Message-ID: <VI1PR0402MB3871A178B8F0632AD64D745CE09B0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200618120837.27089-1-ioana.ciornei@nxp.com>
 <20200618120837.27089-5-ioana.ciornei@nxp.com>
 <20200618140623.GC1551@shell.armlinux.org.uk>
 <VI1PR0402MB387191C53CE915E5AC060669E09B0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
 <20200618165510.GG1551@shell.armlinux.org.uk>
 <VI1PR0402MB38712F94BAAC32DB1C8AB7F8E09B0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
 <20200618220331.GA279339@lunn.ch>
In-Reply-To: <20200618220331.GA279339@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.56.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 34a2c53c-19df-4474-fe58-08d813dad4e1
x-ms-traffictypediagnostic: VI1PR0402MB3744:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB374454B14AECC844253D3D1EE09B0@VI1PR0402MB3744.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0438F90F17
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ku3t4UAKfnqKQFauOGC61Y1TWjRWs8GnETQ2Z0ZNfyN5B4yyfid5YFbKEFrYBBO3SOnjP6b+0jOFB5KDgJoV+JkiLYNvFm5+gQm6/nbewQCaLM8sQzUDqS2KW6tlxTOx2B3UwUXLeGvyDCf1aha3wG9LmH8y76gUI9oFnSdMwO4bSXlTbjqXkw7wddMr+vuucQ2LiawuXgse/TEvk4TrkUyxsSAw620ay/tv0+WsTA5Y19Hfkfo0c9uLIqyDafcv5TdavTEmftBhNwGYipT/cWf0SvY6t4v5zgVLrOtUTRD4Eh+eM/Ly//CGjtwR6klH
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(136003)(366004)(376002)(39860400002)(52536014)(44832011)(6506007)(478600001)(86362001)(71200400001)(8676002)(8936002)(6916009)(186003)(26005)(2906002)(4744005)(66556008)(4326008)(66446008)(64756008)(33656002)(76116006)(9686003)(66946007)(5660300002)(54906003)(316002)(7696005)(55016002)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: INs7ns/X6AnuwFp4py0w2WjTmxQFLA2EcmLv6CGmwQinEii/xS0FLQKJSzUfkD8re7MJX6MdmywKMRr73VDQ/fPhoF71H0wv0wOtbNrA6HcGBBdcXJGynGwVUPqNYJw89EEYx81dYex6paOksLUDrigOT4WlP3pBngrpjZeYU8HXt7wKi3shFkDxZQHj4n1x1hbhUEeeA67Cx6tDulVYVWHDfnh7Aq0huXK2VMyrvKw9eijLSCu7jvFbBxo36mYjbc1xntlG2GNDaUDR/2GFs12iQNiVfwFEiUP83ozli5th+EyBznlRGf4R0px/3L2wcasJ0DF+2XkTRLkA3+UKmlbRg1qLJkE7PAVHtGgE5H2i6LwFevDAtYae7oCYdzVodoNOq8pnpHNd/Av6iNzAhGKaiqhsPCC3RtY9RNsbw0tu6UcUnG9QgEwJXoXzOe5JiLuVosLCGK/3i4MhdwdSGPFKfP7zBUV+Y9wtlbtaByE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34a2c53c-19df-4474-fe58-08d813dad4e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2020 22:56:26.7074
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eyKY+PwuMh5BJhsDEe3sKyUFn/cSbm6VimQXR5jX53HqKlmFfbZ2s/+hTdKvIAs2nqK8NUfgyG5fDLX/OCB3qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3744
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH net-next 4/5] net: phy: add Lynx PCS MDIO module
>=20
> > Are there really instances where the ethernet driver has to manage
> > multiple different types of PCSs? I am not sure this type of snippet
> > of code is really going to occur.
>=20
> Hi Ioana
>=20
> The Marvell mv88e6390 family has three PCS's, one for SGMII/1000BaseX, a
> 10Gbase-X4/X2 and a 10GBAse-R. So this sort of code could appear.
>=20

I should have been more clear as I was wondering about different types of P=
CS IPs
(i.e. different vendors and such).

We are in the same case as the Marvell mv88e6390 family, it seems, and we t=
reat
this directly in the Lynx PCS module by a 'switch case' statement by the in=
terface type.
The MAC driver just calls the functions, no choosing necessary on its part,=
 all of that
is done by the PCS module.

Ioana
