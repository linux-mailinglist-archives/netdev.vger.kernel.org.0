Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F011E11E6
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 17:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404196AbgEYPkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 11:40:01 -0400
Received: from mail-eopbgr10059.outbound.protection.outlook.com ([40.107.1.59]:25667
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404002AbgEYPkB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 11:40:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aIyxMfE8i7e12vp+EXTShQHUSPYDeY8PhkFdZ7DJhEyxWcJK3DKoI9D/oMcdBTeO5/0m2AO77Z6VyI1mld8qODpxhTiRTUTnKI8Ln/DH+I+qUYQWdj3WZdhPaNVxu7pexnXa+Nv95yrroGHIRCUjGiCXLG+eXf7q49dBMhcmJfqgbWCJn6a5w9sfq1ZNLgIuHjDnHMsjKj33wyQqEWz6JbtRXvdoQHtAoE4BpxKqw8KvvHgL4lIkgNYQ73p2RiVZyLZG4Q/mPXcI7Any93tDSmRMD005Gtt9Y2hTrtX275e3CsRe1hgiNMN+gyanhsdbsiA8FyNiKEK7c/Fwgdxh+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3gjopTxsc+XZqQtNt3UBNS+sME3zWS0mL1+e0RY1RNU=;
 b=j+ZaWsQYHwJ5p3uM+C6Zfb0/y5g64tvLrhSFMXUlJgriEKVt4IK0bYAtqVrHk/dsWdgsrJzY+Qll8rQ6WOhbGNJm1yN0W5aJGQ3FXVvXl8P7wMYUpdvl/SGz5KGfZ24Bfa7273wdQOsZshYm7zCi4KLsNP/iHY6At9RiWSfPaZrGr33ynfSot3askjyKyZf6psLQwbCMdx9A5JuXwY36TDdMDgEAtrT3pciTfkuSqI39VPgHOf7PWQo3f+CbfXxyc3QD+9EjswLsa9RP59ZELDTNPhJH/cQ5lqp1tsBiKRonnOcA0TNlMeY0XoLaV3fZnsnIFqb6cvbRez18A2WChw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3gjopTxsc+XZqQtNt3UBNS+sME3zWS0mL1+e0RY1RNU=;
 b=S3K4817PMfFWzC9BDibJJgk8JjarmjYaVzeLpu+/dEP/QCtP3xhBkvst/IUkfyGntbUWWT5MVyyQudHGckCacCQEDr5nrdMHHIoKmCXIOfhH92RRJ6/kS4BwoZgiVXdZHQiAfCPWD1iu3/aCm7Hkz9EGNVXRHHB6E4rni8kzlAc=
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3543.eurprd04.prod.outlook.com
 (2603:10a6:209:6::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Mon, 25 May
 2020 15:39:57 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 15:39:57 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "martin.fuzzey@flowbird.group" <martin.fuzzey@flowbird.group>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: RE: [EXT] Re: [PATCH net v2 3/4] ARM: dts: imx: add ethernet stop
 mode property
Thread-Topic: [EXT] Re: [PATCH net v2 3/4] ARM: dts: imx: add ethernet stop
 mode property
Thread-Index: AQHWMmQeRZb5W9lPOke/BkM4XeDCaqi40kgAgAAeD5A=
Date:   Mon, 25 May 2020 15:39:56 +0000
Message-ID: <AM6PR0402MB360701A48614A2D42164F0A6FFB30@AM6PR0402MB3607.eurprd04.prod.outlook.com>
References: <1590390569-4394-1-git-send-email-fugang.duan@nxp.com>
 <1590390569-4394-4-git-send-email-fugang.duan@nxp.com>
 <20200525135104.GB752669@lunn.ch>
In-Reply-To: <20200525135104.GB752669@lunn.ch>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 82ed01ee-0599-433e-546c-08d800c1e09e
x-ms-traffictypediagnostic: AM6PR0402MB3543:
x-microsoft-antispam-prvs: <AM6PR0402MB35437B0CDC9219ADD68981FBFFB30@AM6PR0402MB3543.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 0414DF926F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3n2/lHWapUuBEhvr5b7JR3qsm3SkYmTNCSb6cltz/D8ioPFCwXDRZYk3Pib3cq58w/dIqhnbWEn3i7OAmwH/eQgjPcQ7zLvGB/4JulugKDasYkY3geQtkHD++qoJgRERQZ2Dq6WCSCQR80kJsLiUzO32M3Wz74j5860LQlLXpUuaWwskHuqLIKAUdsJ1Ts1zZkQ9VbfxImkhrsq4+uAD8bao5HzfaqK3fng+a8rU7Z//p39yuQu5C6pPNvArkw9PRuYx97hYHVP/D4sCdOxiwv04+7c8YIY3TuC9xXSWeLFcU8ZJ0HzpM3bvJwPm+lG0DvvEyLZSbLwfyY5dOIePgw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(396003)(376002)(346002)(366004)(6916009)(54906003)(316002)(33656002)(478600001)(9686003)(8676002)(8936002)(52536014)(4326008)(5660300002)(4744005)(2906002)(71200400001)(86362001)(186003)(66476007)(55016002)(66946007)(66556008)(6506007)(64756008)(76116006)(66446008)(7696005)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: viHNlXfc3UjITv26Ied+8NrFRBUpeBpzYVKK5Xqfnn5K8WzMlMkLZCZmQWY/lCDQhzffuaM/HdikIONzLxIz8IIWCxD3K8ho7duglSvMEe46e0jkdxrRz+dIow/yjhkncq+yEkedFB++P7ugXVyGU53aHvxhc2G46LIOXP2yHrP8mp1lqlAB8gj6OTZFtfi1ikPSVxLVLnlLALeGWf2nvfaUkVIkeUJRGAssnl9Cid1keZI9lIuWOgIC/eYemb0Y+nw1ptlHKj9pom+YAXdx3QqcAza332/7qqvdUxCFJVQbwbJT8EvKj5XGu0Wgdu6kLwe3Eol9TeCP/6h4maaBRXDJAGU6jVs9oaApP8H3bKV9JRXfMjGTGmZHKaZvahfhmCmC09txUgtRuz0tkK5TRyrnVlKBQf8vOJ7pZXkjBCjUIxef06rmIVeMctHPr4WjEzxIbKPxrNBhmKvcai8MYM5aA5xNpMNvgoa5Y3A9wEHyW8YzL1+ytMuZo/hehVV/
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82ed01ee-0599-433e-546c-08d800c1e09e
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2020 15:39:56.9376
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mDEw26b2rrg6l1EMxoQMYKbzbANcSCV1W8Nj/cYGfShouxkbGcJ6CYBna0pWtOQJvSmZ++7IdTdU/UaqrzY0yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3543
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch> Sent: Monday, May 25, 2020 9:51 PM
> On Mon, May 25, 2020 at 03:09:28PM +0800, fugang.duan@nxp.com wrote:
> > From: Fugang Duan <fugang.duan@nxp.com>
> >
> > - Update the imx6qdl gpr property to define gpr register
> >   offset and bit in DT.
> > - Add imx6sx/imx6ul/imx7d ethernet stop mode property.
> >
> > Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
>=20
> Thanks for adding a user.
>=20
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>=20
>     Andrew

Andrew, thanks for your review.
